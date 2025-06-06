from export_formula.fp import sub
from export_formula.fp2 import fp2_mul, fp2_sub, fp2_add, fp2_sqr, fp2_neg, fp2_constMul, fp2_guzai, fp2_constMulNotMont
from export_formula.transform import FormulaOrganizer


def ep2_dbl(D_twist: bool):
    formulaList = fp2_sqr("TY", "t0")
    formulaList += fp2_sqr("TZ", "t1")
    formulaList += fp2_mul("BT", "t1", "t2")
    formulaList += fp2_constMulNotMont("t2", 3, "t3")
    formulaList += fp2_mul("TX", "TY", "t4")
    formulaList += fp2_constMulNotMont("t4", 2, "t5")
    formulaList += fp2_sqr("TX", "t6")
    formulaList += fp2_constMulNotMont("t6", 3, "t7")
    formulaList += fp2_mul("TY", "TZ", "t8")
    formulaList += fp2_constMulNotMont("t8", 2, "t9")
    formulaList += fp2_mul("t0", "t9", "t10_")
    formulaList += fp2_constMulNotMont("t10_", 4, "new_TZ")
    if D_twist:
        formulaList += fp2_sub("t0", "t3", "c01")
    else:
        formulaList += fp2_sub("t0", "t3", "c00")
    formulaList += fp2_constMulNotMont("t3", 2, "t11_")
    if D_twist:
        formulaList += fp2_sub("c01", "t11_", "t12")
    else:
        formulaList += fp2_sub("c00", "t11_", "t12")
    formulaList += fp2_mul("t12", "t5", "new_TX")
    if D_twist:
        formulaList += fp2_add("t0", "c01", "t13")
    else:
        formulaList += fp2_add("t0", "c00", "t13")
    formulaList += fp2_add("t11_", "t3", "b3")
    formulaList += fp2_mul("b3", "t13", "t14")
    formulaList += fp2_sqr("t0", "t15")
    formulaList += fp2_add("t14", "t15", "new_TY")
    if D_twist:
        formulaList += fp2_constMul("t9", "PY", "c00")
        formulaList += fp2_constMul("t7", "PX_", "c10")
    else:
        formulaList += fp2_constMul("t9", "PY", "c01")
        formulaList += fp2_constMul("t7", "PX_", "c20")
    return formulaList

def ep2_dbl_pattern2(D_twist: bool):
    formulaList = fp2_sqr("TY", "t0")
    formulaList += fp2_sqr("TZ", "t1")
    formulaList += fp2_mul("BT", "t1", "t2")
    formulaList += fp2_constMulNotMont("t2", 3, "t3")
    formulaList += fp2_mul("TX", "TY", "t4")
    formulaList += fp2_constMulNotMont("t4", 2, "t5")
    formulaList += fp2_sqr("TX", "t6")
    formulaList += fp2_constMulNotMont("t6", 3, "t7")
    formulaList += fp2_mul("TY", "TZ", "t8")
    formulaList += fp2_constMulNotMont("t8", 2, "t9")
    formulaList += fp2_mul("t0", "t9", "t10_")
    formulaList += fp2_constMulNotMont("t10_", 4, "new_TZ")
    if D_twist:
        formulaList += fp2_sub("t0", "t3", "c01")
    else:
        formulaList += fp2_sub("t0", "t3", "c00")
    formulaList += fp2_constMulNotMont("t3", -3, "t11_") #diff
    formulaList += fp2_add("t0", "t11_", "t12")
    formulaList += fp2_mul("t12", "t5", "new_TX")
    if D_twist:
        formulaList += fp2_add("t0", "c01", "t13")
    else:
        formulaList += fp2_add("t0", "c00", "t13")
    formulaList += fp2_add("t11_", "t3", "b3")
    formulaList += fp2_mul("b3", "t13", "t14")
    formulaList += fp2_sqr("t0", "t15")
    formulaList += fp2_add("t14", "t15", "new_TY")
    if D_twist:
        formulaList += fp2_constMul("t9", "PY", "c00")
        formulaList += fp2_constMul("t7", "PX_", "c10")
    else:
        formulaList += fp2_constMul("t9", "PY", "c01")
        formulaList += fp2_constMul("t7", "PX_", "c20")
    return formulaList

def ep2_add(D_twist: bool):
    formulaList = fp2_mul("QY", "TZ", "t0")
    formulaList += fp2_sub("TY", "t0", "t1")
    formulaList += fp2_mul("QX", "TZ", "t2")
    formulaList += fp2_sub("TX", "t2", "t3")
    formulaList += fp2_sqr("t1", "t4")
    formulaList += fp2_sqr("t3", "t5")
    formulaList += fp2_mul("t3", "t5", "t6")
    formulaList += fp2_mul("TZ", "t4", "t7")
    formulaList += fp2_add("t6", "t7", "t8")
    formulaList += fp2_mul("TX", "t5", "t9")
    formulaList += fp2_constMulNotMont("t9", -2, "t10_")
    formulaList += fp2_add("t8", "t10_", "t11_")
    formulaList += fp2_sub("t11_", "t9", "t12")
    formulaList += fp2_mul("t3", "t11_", "new_TX")
    formulaList += fp2_mul("t1", "t12", "t13")
    formulaList += fp2_mul("TY", "t6", "t14")
    formulaList += fp2_add("t13", "t14", "t15")
    formulaList += fp2_constMulNotMont("t15", -1, "new_TY")
    formulaList += fp2_mul("TZ", "t6", "new_TZ")
    if D_twist:
        formulaList += fp2_constMul("t3", "PY_", "c00")
        formulaList += fp2_constMul("t1", "PX", "c10")
    else:
        formulaList += fp2_constMul("t3", "PY_", "c01")
        formulaList += fp2_constMul("t1", "PX", "c20")
    formulaList += fp2_mul("QY", "t3", "t16")
    formulaList += fp2_mul("QX", "t1", "t17")
    if D_twist:
        formulaList += fp2_sub("t16", "t17", "c01")
    else:
        formulaList += fp2_sub("t16", "t17", "c00")
    return formulaList

def fp12_SQR012345(opr1: str, ret: str):
    formulaList = fp2_sqr(opr1 + "00", "t0")
    formulaList += fp2_constMulNotMont(opr1 + "11", 4, "t1")
    formulaList += fp2_mul(opr1 + "00", opr1 + "01", "t2")
    formulaList += fp2_constMulNotMont(opr1 + "01", 2, "t3")
    formulaList += fp2_constMulNotMont(opr1 + "10", 2, "t4")
    formulaList += fp2_constMulNotMont(opr1 + "20", 6, "t5")
    formulaList += fp2_mul(opr1 + "00", opr1 + "11", "t6")
    formulaList += fp2_sqr(opr1 + "20", "t7")
    formulaList += fp2_mul(opr1 + "00", opr1 + "20", "t8")
    formulaList += fp2_constMulNotMont(opr1 + "11", 2, "t9")
    formulaList += fp2_constMulNotMont(opr1 + "21", 2, "t10_")
    formulaList += fp2_mul(opr1 + "10", opr1 + "11", "t11_")

    formulaList += fp2_constMulNotMont("t0", 2, "t12")
    formulaList += fp2_guzai(opr1 + "20", "t13")
    formulaList += fp2_mul("t1", "t13", "t14")
    formulaList += sub("t120", "ONE", "t150")
    formulaList += sub("t121", "ZERO", "t151")
    formulaList += fp2_add("t14", "t15", ret + "00")

    formulaList += fp2_constMulNotMont("t2", 6, "t16")
    formulaList += fp2_add("t3", "t16", ret + "01")

    formulaList += fp2_guzai(opr1 + "21", "t17")
    formulaList += fp2_mul("t5", "t17", "t18")
    formulaList += fp2_add("t4", "t18", ret + "10")

    formulaList += fp2_constMulNotMont("t6", 4, "t19")
    formulaList += fp2_constMulNotMont("t7", 2, "t20_")
    formulaList += fp2_add("t19", "t20_", ret + "11")

    formulaList += fp2_constMulNotMont("t8", 4, "t21_")
    formulaList += fp2_guzai(opr1 + "11", "t22")
    formulaList += fp2_mul("t9", "t22", "t23")
    formulaList += fp2_add("t21_", "t23", ret + "20")

    formulaList += fp2_constMulNotMont("t11_", 6, "t24")
    formulaList += fp2_add("t10_", "t24", ret + "21")
    return formulaList

def fp12_SQR012345_pattern2(opr1: str, ret: str):
    formulaList = fp2_sqr(opr1 + "00", "t0")
    formulaList += fp2_add(opr1 + "00", opr1 + "11", "t1")
    formulaList += fp2_sub("t1", opr1 + "20", "t2")
    formulaList += fp2_add("t1", opr1 + "20", "t8")
    formulaList += fp2_sqr("t8", "t9")
    formulaList += fp2_sqr("t2", "t10_")
    formulaList += fp2_mul(opr1 + "11", opr1 + "20", "t3")
    formulaList += fp2_constMulNotMont("t3", 2, "t11_")
    formulaList += fp2_sqr(opr1 + "11", "t4")
    formulaList += fp2_mul(opr1 + "00", opr1 + "01", "t5")
    formulaList += fp2_mul(opr1 + "20", opr1 + "21", "t6")
    formulaList += fp2_mul(opr1 + "10", opr1 + "11", "t7")
    formulaList += fp2_guzai("t11_", "t12")
    formulaList += fp2_add("t0", "t12", "t13")
    formulaList += sub("t130", "ONE", "t140")
    formulaList += sub("t131", "ZERO", "t141")
    formulaList += fp2_add("t13", "t14", ret + "00")
    formulaList += fp2_constMulNotMont("t5", 3, "t27")
    formulaList += fp2_add("t27", opr1 + "01", "t28")
    formulaList += fp2_constMulNotMont("t28", 2, ret + "01")
    formulaList += fp2_add("t0", "t4", "t15")
    formulaList += fp2_constMulNotMont("t15", 2, "t16")
    formulaList += fp2_sub("t9", "t16", "t17")
    formulaList += fp2_add("t10_", "t17", ret + "11")
    formulaList += fp2_guzai("t4", "t18")
    formulaList += fp2_sub("t18", "t11_", "t19")
    formulaList += fp2_constMulNotMont("t19", 2, "t20_")
    formulaList += fp2_add("t20_", "t9", "t21_")
    formulaList += fp2_sub("t21_", "t10_", ret + "20")
    formulaList += fp2_constMulNotMont("t6", 3, "t22")
    formulaList += fp2_guzai("t22", "t23")
    formulaList += fp2_add(opr1 + "10", "t23", "t24")
    formulaList += fp2_constMulNotMont("t24", 2, ret + "10")
    formulaList += fp2_constMulNotMont("t7", 3, "t25")
    formulaList += fp2_add("t25", opr1 + "21", "t26")
    formulaList += fp2_constMulNotMont("t26", 2, ret + "21")
    return formulaList


def Fp2SparseMul(a0, a1, b0, b1, b2, ret):
    formulaList = fp2_mul(a0, b0, ret + "_t0")
    formulaList += fp2_mul(a1, b1, ret + "_t1")
    formulaList += fp2_mul(a1, b2, ret + "_t2")
    formulaList += fp2_guzai(ret + "_t2", ret + "_t9")
    formulaList += fp2_add(ret + "_t0", ret + "_t9", ret + "0")
    formulaList += fp2_add(a0, a1, ret + "_t4")
    formulaList += fp2_add(b0, b1, ret + "_t5")
    formulaList += fp2_mul(ret + "_t4", ret + "_t5", ret + "_t6")
    formulaList += fp2_add(ret + "_t0", ret + "_t1", ret + "_t7")
    formulaList += fp2_sub(ret + "_t6", ret + "_t7", ret + "1")
    formulaList += fp2_mul(a0, b2, ret + "_t8")
    formulaList += fp2_add(ret + "_t8", ret + "_t1", ret + "2")
    return formulaList


def fp12_sparse_m6(opr1: str, opr2: str, ret: str):  # opr1: line evaluation
    formulaList = fp2_mul(opr1 + "01", opr2 + "10", "t1")
    formulaList += fp2_mul(opr1 + "01", opr2 + "01", "t2")
    formulaList += fp2_mul(opr1 + "01", opr2 + "21", "t0")
    formulaList += fp2_guzai("t0", "t3")
    formulaList += Fp2SparseMul(opr1 + "00", opr1 + "20", opr2 + "00", opr2 + "20", opr2 + "11", "t4")
    formulaList += fp2_add(opr1 + "20", opr1 + "01", "t7")
    formulaList += fp2_add(opr2 + "00", opr2 + "10", "t8")
    formulaList += fp2_add(opr2 + "20", opr2 + "01", "t9")
    formulaList += fp2_add(opr2 + "11", opr2 + "21", "t10_")
    formulaList += Fp2SparseMul(opr1 + "00", "t7", "t8", "t9", "t10_", "t5")
    formulaList += fp2_add("t3", "t40", "t14")
    formulaList += fp2_add("t1", "t41", "t15")
    formulaList += fp2_add("t2", "t42", "t16")
    formulaList += fp2_sub("t50", "t14", ret + "10")
    formulaList += fp2_sub("t51", "t15", ret + "01")
    formulaList += fp2_sub("t52", "t16", ret + "21")
    formulaList += fp2_guzai("t2", "t17")
    formulaList += fp2_add("t17", "t40", ret + "00")
    formulaList += fp2_add("t3", "t41", ret + "20")
    formulaList += fp2_add("t1", "t42", ret + "11")
    return formulaList


def fp12_sparse_d6(opr1: str, opr2: str, ret: str):  # opr1: line evaluation
    formulaList = fp2_mul(opr1 + "00", opr2 + "00", "t0")
    formulaList += fp2_mul(opr1 + "00", opr2 + "20", "t1")
    formulaList += fp2_mul(opr1 + "00", opr2 + "11", "t2")
    formulaList += Fp2SparseMul(opr1 + "10", opr1 + "01", opr2 + "10", opr2 + "01", opr2 + "21", "t4")
    formulaList += fp2_add(opr1 + "00", opr1 + "10", "t7")
    formulaList += fp2_add(opr2 + "00", opr2 + "10", "t8")
    formulaList += fp2_add(opr2 + "20", opr2 + "01", "t9")
    formulaList += fp2_add(opr2 + "11", opr2 + "21", "t10_")
    formulaList += Fp2SparseMul("t7", opr1 + "01", "t8", "t9", "t10_", "t5")
    formulaList += fp2_add("t0", "t40", "t14")
    formulaList += fp2_add("t1", "t41", "t15")
    formulaList += fp2_add("t2", "t42", "t16")
    formulaList += fp2_sub("t50", "t14", ret + "10")
    formulaList += fp2_sub("t51", "t15", ret + "01")
    formulaList += fp2_sub("t52", "t16", ret + "21")
    formulaList += fp2_guzai("t42", "t17")
    formulaList += fp2_add("t0", "t17", ret + "00")
    formulaList += fp2_add("t1", "t40", ret + "20")
    formulaList += fp2_add("t2", "t41", ret + "11")
    return formulaList


if __name__ == "__main__":
    formulaList = fp12_SQR012345()
    organizer = FormulaOrganizer()
    formulaList = organizer.remove_extra_formula(formulaList)
    for formula in formulaList:
        print(
            "{},{},{},{}".format(
                formula.ret,
                formula.opr1,
                formula.opr2,
                formula.type))
