# スケジューリングから抜け落ちた変数がないか確認
import argparse
import os
from scheduling.schedule import find_next_formula
from scheduling.split_sche import make_split_scheduling


def find_mistake(formulas, pre_sche_result):
    mistaken_formulas = []
    for formula in formulas:
        is_exist = False
        mem_is_exist = False
        mem_results = []
        task = formula[0]
        for sol in pre_sche_result:
            if task == sol[0]:
                is_exist = True
            elif ("{}_mem".format(task) in sol[0]) or ("{}_in".format(task) in sol[0]) or ("{}_w".format(task) in sol[0]):
                mem_is_exist = True
                mem_results.append(sol)
        if not is_exist:
            if mem_is_exist:
                for mem_result in mem_results:
                    pre_sche_result.remove(mem_result)
            # min_finish_time, max_finish_time = find_next_formula(task, formulas, pre_sche_result)
            mistaken_formulas.append(formula)
    print(mistaken_formulas)
    # return pre_sche_result, split_ope


psr = argparse.ArgumentParser(
    usage='schedule.py -c <curve_group> -p <p[bit]>',
    description='Execute scheduling with a 7-stage pipelined Fp montgomery multiplier, four Fp adders/subtractors, an Fp inversion operator'
)
psr.add_argument("-c", "--curve", required=True, help="curve group")
psr.add_argument("-p", "--characteristic", required=True, help="bit width of characteristic number p")
args = psr.parse_args()

curve_group = args.curve
curve_name = args.characteristic

home_dir = os.path.dirname(os.getcwd().replace("\\", "/"))
target_dir = "{}/{}-{}".format(home_dir, curve_group, curve_name)

input = []
output = []
solution = [[]]
formulas = [[]]
mem_table = {}

for root, dirs, files in os.walk("{}/scheduling/result".format(target_dir)):
    for file in files:
        if file[-4:] != ".txt":
            continue
        result_file_path = os.path.join(root, file)
        print(result_file_path)
        # read scheduling result file
        exec(open(result_file_path, 'r', encoding="utf-8").read())
        split_ope, input_value, output_value, input_num = make_split_scheduling(formulas)
        find_mistake(formulas, solution)
