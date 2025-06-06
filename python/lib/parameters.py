import json
import argparse
import os
from lib.fpx import Fp_t, Fp2_t, Fp4_t, Fp12_t, Fp24_t
from lib.util import bits_list, read_json


psr = argparse.ArgumentParser(
    usage='parameters.py -c <curve_group> -p <p[bit]>',
    description='calculate required parameter for pairing operation'
)
psr.add_argument("-c", "--curve", required=True, help="curve group")
psr.add_argument("-p", "--characteristic", required=True, help="bit width of characteristic number p")
psr.add_argument("-f", "--filename", help="読み込むJSONファイル")
args = psr.parse_args()
curve_group = args.curve
curve_name = args.characteristic
param = read_json("{}/{}-{}/param.json".format(os.path.dirname(os.getcwd().replace("\\", "/")), curve_group, curve_name))

b = param["b"]
u = param["u"]
U = bits_list(u)
D_twist = param["D_twist"]
r = param["r"]
p = param["p"]

if curve_group == "bls12":
    fp2_qnr = param["beta"]
    fp4_qnr = param["xi"]
    fp12_cnr = [[0, 0], [1, 0]]
    xi = fp4_qnr
    Fp = Fp_t(p=p)
    Fp2 = Fp2_t(Fp=Fp, qnr=fp2_qnr)
    Fq = Fp2
    Fp4 = Fp4_t(Fp2=Fp2, qnr=fp4_qnr)
    Fp12 = Fp12_t(Fp4=Fp4, cnr=fp12_cnr)
    Fq6 = Fp12

if curve_group == "bls24":
    fp2_qnr = param["beta"]
    fp4_qnr = param["beta2"]
    fp12_cnr = [[param["xi"][0], 0], [param["xi"][1], 0]]
    xi = fp12_cnr
    Fp = Fp_t(p=p)
    Fp2 = Fp2_t(Fp=Fp, qnr=fp2_qnr)
    Fp4 = Fp4_t(Fp2=Fp2, qnr=fp4_qnr)
    Fq = Fp4
    Fp12 = Fp12_t(Fp4=Fp4, cnr=fp12_cnr)
    Fp24 = Fp24_t(
        Fp12=Fp12, qnr=[[[0, 0], [0, 0]], [[1, 0], [0, 0]], [[0, 0], [0, 0]]]
    )
    Fq6 = Fp24

xi_montconv = Fq.MontConv(xi)
if D_twist:
    xi_inv = Fq.inv(xi_montconv)
    BT = Fq.constMulNotMont(xi_inv, b)
else:
    BT = Fq.constMulNotMont(xi_montconv, b)

P = [Fp.MontConv(param["P"][0]), Fp.MontConv(param["P"][1])]
Q = [Fq.MontConv(param["Q"][0]), Fq.MontConv(param["Q"][1])]
T = [Fq.MontConv(param["Q"][0]), Fq.MontConv(param["Q"][1]), Fq.one()]
