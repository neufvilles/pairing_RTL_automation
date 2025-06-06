import subprocess
from concurrent.futures.process import ProcessPoolExecutor
import os
import csv
import argparse

psr = argparse.ArgumentParser(
    usage='multi_syn.py -c <clock_period>',
    description='Run 5 logic synthesis in parallel by changing the clock constraint like 4.0, 4.2, 4.4, 4.6, 4.8.'
)
psr.add_argument('-c', '--clock_period', required=True, help='clock constraint')
args = psr.parse_args()
clock_period = int(args.clock_period)

with open("syn_top.tcl", mode="r") as f:
    template = f.read()


def syn(clk):
    prex = str(clk).replace(".", "_")
    res_dir = 'dc_result/' + prex
    os.makedirs(res_dir + "/", exist_ok=True)
    with open(res_dir + '/syn.log', mode='w') as f:
        proc = subprocess.run(
            '(time dc_shell) > dc_result/' +
            prex +
            '/syn.log  2>&1',
            shell=True,
            input=template.format(
                clk=clk,
                prex=prex,
                res_dir=res_dir).encode(),
            stdout=f)

    res = [clk]
    with open(res_dir + '/timing.txt', mode='r') as f:
        for l in f:
            if 'slack' in l and ('sort_by' not in l):
                res.append(clk - float(l.rsplit(' ', 1)[1]))
                break
    with open(res_dir + '/area.txt', mode='r') as f:
        for l in f:
            if 'Total cell area' in l:
                res.append(float(l.rsplit(' ', 1)[1]))
                break

    with open(res_dir + '/power.txt', mode='r') as f:
        for l in f:
            if 'Total Dynamic Power' in l:
                res.append(float(l.rsplit(' ', 4)[1]))
                break
            if 'Cell Leakage Power' in l:
                res.append(float(l.rsplit(' ', 4)[1]))
                break

    with open(res_dir + '/syn.log', mode='r') as f:
        for l in f:
            if 'user' in l:
                res.append(l.rsplit()[1])
                break

    return res


def syn_bit(clk):
    return syn(clk)


with ProcessPoolExecutor() as executor:
    results = executor.map(syn_bit, [clock_period + 0.2 * x for x in range(5)])

with open("result.csv", 'a') as f:
    writer = csv.writer(f, lineterminator="\n")
    writer.writerows(list(results))
