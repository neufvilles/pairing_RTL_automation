from export_formula.fp import add, sub, neg, mul, guzai, inv, constMulNotMont
from lib.parameters import fp4_qnr
from export_formula.transform import FormulaOrganizer
from lib.util import FormulaSet, num_to_STR


def fp2_add(opr1: str, opr2: str, ret: str):

    return add(opr1 + '0', opr2 + '0', ret + '0') + \
        add(opr1 + '1', opr2 + '1', ret + '1')


def fp2_sub(opr1: str, opr2: str, ret: str):
    return sub(opr1 + '0', opr2 + '0', ret + '0') + \
        sub(opr1 + '1', opr2 + '1', ret + '1')

# constMulはFp2単位で実装する
def fp2_constMulNotMont(opr1: str, k: int, ret: str):
    if k == 0:
        raise ValueError("*ZERO")
    else:
        return [FormulaSet(opr1=opr1, opr2="MODE{}".format(num_to_STR(k)), ret=ret, type="CONSTMUL")]

# opr2がくそでかいintの定数乗算のとき、元の定数が入っているレジスタを2倍確保する措置を取るようにする
# すなわちPXならFP2MUL(opr1, [PX, ZERO])となるようにする。
def fp2_constMul(opr1: str, opr2: int, ret: str):
    return [FormulaSet(opr1=opr1, opr2=opr2, ret=ret, type="FP2MUL")]

#FP2MULを定義
def fp2_mul(opr1: str, opr2: str, ret: str):
    return [FormulaSet(opr1=opr1, opr2=opr2, ret=ret, type="FP2MUL")]


def fp2_mul_conj(opr1: str, opr2: str, ret: str):  # a * conj(b)
    formulaList: list[FormulaSet] = []
    formulaList += add(opr2 + '0', "ZERO", ret + '_t00') 
    formulaList += neg(opr2 + '1', ret + '_t01')
    formulaList += fp2_mul(opr1, ret + '_t0', ret)
    return formulaList


def fp2_sqr(opr1: str, ret: str):
    return [FormulaSet(opr1=opr1, opr2=opr1, ret=ret, type="FP2MUL")]


def fp2_conj(opr1: str, ret: str):
    return add(opr1 + '0', "ZERO", ret + '0') + neg(opr1 + '1', ret + '1')


def fp2_inv(opr1: str, ret: str):
    formulaList = []
    formulaList += add(opr1 + '0', "ZERO", ret + '_aa0') 
    formulaList += neg(opr1 + '1', ret + '_aa1')
    formulaList += fp2_mul(opr1, ret + '_aa', ret + '_bb')
    formulaList += inv(ret + '_bb0', ret + '_denom_inv')
    formulaList += fp2_constMul(ret + '_aa' , ret + '_denom_inv', ret)
    return formulaList


def fp2_neg(opr1: str, ret: str):
    return neg(opr1 + '0', ret + '0') + neg(opr1 + '1', ret + '1')

# (ret: Fp2) = (opr1: Fp2) * fp4_qnr


# Fp4 = Fp2[v]/(v^2 - fp4_qnr), fp4_qnr = x + yi
def fp2_guzai(opr1: str, ret: str):
    formulaList = []
    xValue, yValue = "ZERO", "ZERO"
    if fp4_qnr[0] != 0:
        xValue = ret + "_x"
        if fp4_qnr[0] == 1:
            xValue = opr1
        else:
            formulaList += fp2_constMulNotMont(opr1, fp4_qnr[0], xValue)
    if fp4_qnr[1] != 0:
        yValue = ret + "_y"
        if fp4_qnr[1] == 1:
            yValue = opr1
        else:
            formulaList += fp2_constMulNotMont(opr1, fp4_qnr[1], yValue)
        formulaList += guzai(yValue + "1", yValue + "1_")
    if xValue != "ZERO" and yValue != "ZERO":
        formulaList += add(xValue + "0", yValue + "1_", ret + "0")
        formulaList += add(xValue + "1", yValue + "0", ret + "1")
    elif xValue != "ZERO":
        formulaList += add(xValue + "0", yValue, ret + "0")
        formulaList += add(xValue + "1", yValue, ret + "1")
    elif yValue != "ZERO":
        formulaList += add(xValue, yValue + "1_", ret + "0")
        formulaList += add(xValue, yValue + "0", ret + "1")           
    return formulaList


def fp2_exp(opr1: str, x: int, ret: str):
    twiceVal = opr1
    tmpVal = "ONE"
    formulaList = []
    i = 0
    while x > 0:
        nextTwiceVal = ret + "_twice{}".format(i)
        nextTmpVal = ret + str(i)
        if x & 1:
            formulaList += fp2_mul(twiceVal, tmpVal, nextTmpVal)
        x >>= 1
        i += 1
        formulaList += fp2_mul(twiceVal, twiceVal, nextTwiceVal)
    formulaList[-1].ret = ret
    return formulaList


if __name__ == "__main__":
    formulaList = fp2_inv("a", "c")
    organizer = FormulaOrganizer()
    formulaList = organizer.remove_extra_formula(formulaList)
    for formula in formulaList:
        print(
            "{},{},{},{}".format(
                formula.ret,
                formula.opr1,
                formula.opr2,
                formula.type))
