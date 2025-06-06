from export_formula.fp4 import fp4_frob, fp4_mul
from export_formula.fp12 import fp12_add, fp12_sub, fp12_neg, fp12_mul, fp12_guzai, fp12_inv, fp12_constMulNotMont
from export_formula.transform import FormulaOrganizer

fp24_qnr = [1, 1]


def fp24_add(opr1: str, opr2: str, ret: str):
    return fp12_add(opr1+'0', opr2+'0', ret+'0') + fp12_add(opr1+'1', opr2+'1', ret+'1')


def fp24_sub(opr1: str, opr2: str, ret: str):
    return fp12_sub(opr1+'0', opr2+'0', ret+'0') + fp12_sub(opr1+'1', opr2+'1', ret+'1')


def fp24_constMulNotMont(opr1: str, k: int, ret: str):
    return fp12_constMulNotMont(opr1+'0', k, ret+'0') + fp12_constMulNotMont(opr1+'1', k, ret+'1')


def fp24_mul(opr1: str, opr2: str, ret: str):
    formulaList = []
    formulaList += fp12_mul(opr1+'0', opr2+'0', ret+"_t0")
    formulaList += fp12_mul(opr1+'1', opr2+'1', ret+"_t1")
    formulaList += fp12_add(opr1+'0', opr1+'1', ret+"_t2")
    formulaList += fp12_add(opr2+'0', opr2+'1', ret+"_t3")
    formulaList += fp12_mul(ret+"_t2", ret+"_t3", ret+"_t4")
    formulaList += fp12_guzai(ret+"_t1", ret+"_s0")
    formulaList += fp12_add(ret+"_t0", ret+"_s0", ret+"0")
    formulaList += fp12_add(ret+"_t0", ret+"_t1", ret+"_t5")
    formulaList += fp12_sub(ret+"_t4", ret+"_t5", ret+"1")
    return formulaList


def fp24_mul_conj(opr1: str, opr2: str, ret: str):  # a * conj(b)
    formulaList = []
    formulaList += fp12_mul(opr1+'0', opr2+'0', ret+"_t0")
    formulaList += fp12_mul(opr1+'1', opr2+'1', ret+"_t1")
    formulaList += fp12_add(opr1+'0', opr1+'1', ret+"_t2")
    formulaList += fp12_sub(opr2+'0', opr2+'1', ret+"_t3")
    formulaList += fp12_mul(ret+"_t2", ret+"_t3", ret+"_t4")
    formulaList += fp12_guzai(ret+"_t1", ret+"_s0")
    formulaList += fp12_sub(ret+"_t0", ret+"_s0", ret+"0")
    formulaList += fp12_sub(ret+"_t0", ret+"_t1", ret+"_t5")
    formulaList += fp12_sub(ret+"_t4", ret+"_t5", ret+"1")
    return formulaList


def fp24_sqr(opr1: str, ret: str):
    formulaList = []
    formulaList += fp12_guzai(opr1+'1', ret+"_a1_")
    formulaList += fp12_add(opr1+'0', ret+"_a1_", ret+"_t0")
    formulaList += fp12_add(opr1+'0', opr1+'1', ret+"_t1")
    formulaList += fp12_mul(ret+"_t0", ret+"_t1", ret+"_t2")
    formulaList += fp12_mul(opr1+'0', opr1+'1', ret+"_t3")
    formulaList += fp12_guzai(ret+"_t3", ret+"_t4")
    formulaList += fp12_add(ret+"_t3", ret+"_t4", ret+"_t5")
    formulaList += fp12_sub(ret+"_t2", ret+"_t5", ret+"0")
    formulaList += fp12_add(ret+"_t3", ret+"_t3", ret+"1")
    return formulaList


def fp24_conj(opr1: str, ret: str):
    return fp12_add(opr1+'0', "ZERO", ret+'0') + fp12_neg(opr1+'1', ret+'1')


def fp24_inv(opr1: str, ret: str):
    formulaList = []
    formulaList += fp12_mul(opr1 + "0", opr1 + "0", ret + '_aa')
    formulaList += fp12_mul(opr1 + "1", opr1 + "1", ret + '_bb')
    formulaList += fp12_guzai(ret + '_bb', ret + '_bbxi')
    formulaList += fp12_sub(ret + '_aa', ret + '_bbxi', ret + '_denom')
    formulaList += fp12_inv(ret + '_denom', ret + '_denom_inv')
    formulaList += fp12_mul(opr1 + "0", ret + '_denom_inv', ret + "0")
    formulaList += fp12_mul(opr1 + "1", ret + '_denom_inv', ret + '1_')
    formulaList += fp12_neg(ret + "1_", ret + "1")
    return formulaList


def fp24_neg(opr1: str, ret: str):
    return fp12_neg(opr1+'0', ret+'0') + fp12_neg(opr1+'1', ret+'1')


def fp24_frob(opr1: str, ret: str):
    formulaList = fp4_frob(opr1+"10", ret+"_f10")
    formulaList += fp4_frob(opr1+"01", ret+"_f01")
    formulaList += fp4_frob(opr1+"11", ret+"_f11")
    formulaList += fp4_frob(opr1+"02", ret+"_f02")
    formulaList += fp4_frob(opr1+"12", ret+"_f12")
    formulaList += fp4_frob(opr1+"00", ret+"00")
    formulaList += fp4_mul(ret+"_f10", "XI1", ret+"10")
    formulaList += fp4_mul(ret+"_f01", "XI2", ret+"01")
    formulaList += fp4_mul(ret+"_f11", "XI3", ret+"11")
    formulaList += fp4_mul(ret+"_f02", "XI4", ret+"02")
    formulaList += fp4_mul(ret+"_f12", "XI5", ret+"12")
    return formulaList


def fp24_exp(opr1: str, x: int, ret: str):
    twiceVal = opr1
    tmpVal = "ONE"
    formulaList = []
    i = 0
    while x > 0:
        nextTwiceVal = ret + "_twice{}".format(i)
        nextTmpVal = ret + str(i)
        if x & 1:
            formulaList += fp24_mul(twiceVal, tmpVal, nextTmpVal)
        x >>= 1
        i += 1
        formulaList += fp24_mul(twiceVal, twiceVal, nextTwiceVal)
    formulaList[-1].ret = ret
    return formulaList


if __name__ == "__main__":
    formulaList = fp24_mul("a", "b", "c")
    organizer = FormulaOrganizer()
    formulaList = organizer.remove_extra_formula(formulaList)
    for formula in formulaList:
        print("{},{},{},{}".format(formula.ret,
              formula.opr1, formula.opr2, formula.type))
        # print(formula)
