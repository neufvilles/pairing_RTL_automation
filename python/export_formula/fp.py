from lib.util import bits_of, num_to_STR, FormulaSet
from lib.parameters import fp2_qnr
from export_formula.transform import *


def add(opr1: str, opr2: str, ret: str):
    return [FormulaSet(opr1=opr1, opr2=opr2, ret=ret, type="ADD")]


def sub(opr1: str, opr2: str, ret: str):
    return [FormulaSet(opr1=opr1, opr2=opr2, ret=ret, type="SUB")]


def mul(opr1: str, opr2: str, ret: str):
    return [FormulaSet(opr1=opr1, opr2=opr2, ret=ret, type="MUL")]


#FP上ではなくFP2上で(inv,0)のようにレジスタを2個確保する
def inv(opr1: str, ret: str):
    return [FormulaSet(opr1=opr1, opr2=opr1, ret=ret, type="INV")]


def neg(opr1: str, ret: str):
    return [FormulaSet(opr1="ZERO", opr2=opr1, ret=ret, type="SUB")]


# CONSTMULを定義
# "MODEONE_","MODETWO","MODETWO_","MODETHREE",,"MODETHREE_","MODEFOUR","MODESIX"
def constMulNotMont(opr1: str, k: int, ret: str):
    if k == 0:
        raise ValueError("*ZERO")
    else:
        return [FormulaSet(opr1=opr1, opr2="MODE{}".format(num_to_STR(k)), ret=ret, type="CONSTMUL")]

    # if k == 0:
    #     raise ValueError("*ZERO")
    # formulaList = []
    # bits_k = bits_of(abs(k))
    # tmpVal = opr1
    # cnt = 0
    # for i in range(1, len(bits_k)):
    #     nextTmpVal = ret + str(cnt)
    #     formulaList += add(tmpVal, tmpVal, nextTmpVal)
    #     tmpVal = nextTmpVal
    #     cnt += 1
    #     if bits_k[i]:
    #         nextTmpVal = ret + str(cnt)
    #         formulaList += add(tmpVal, opr1, nextTmpVal)
    #         tmpVal = nextTmpVal
    #         cnt += 1
    # if k > 0:
    #     formulaList += add("ZERO", tmpVal, ret)
    # else:
    #     formulaList += neg(tmpVal, ret)
    # return formulaList

# (ret: Fp) = (opr1: Fp) * fp2_qnr

#今回はfp2_qnrは-1で固定のためnegで代用する
def guzai(opr1: str, ret: str):  # Fp2 = Fp[i]/(i^2 - fp2_qnr)
    return [FormulaSet(opr1="ZERO", opr2=opr1, ret=ret, type="SUB")]
    # return constMulNotMont(opr1, fp2_qnr, ret)


def exp(opr1: str, x: int, ret: str):
    twiceVal = opr1
    tmpVal = "ONE"
    formulaList = []
    i = 0
    while x > 0:
        nextTwiceVal = ret + "_twice{}".format(i)
        nextTmpVal = ret + str(i)
        if x & 1:
            formulaList += mul(twiceVal, tmpVal, nextTmpVal)
        x >>= 1
        i += 1
        formulaList += mul(twiceVal, twiceVal, nextTwiceVal)
    formulaList[-1].ret = ret
    return formulaList


if __name__ == "__main__":
    formulaList = constMulNotMont("x", -1, "y")
    for formula in formulaList:
        print("{},{},{},{}".format(formula.ret,
              formula.opr1, formula.opr2, formula.type))
