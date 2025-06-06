from export_formula.fp import sub
from export_formula.fp4 import fp4_mul, fp4_sub, fp4_add, fp4_sqr, fp4_neg, fp4_constMul, fp4_guzai, fp4_constMulNotMont
from export_formula.transform import FormulaOrganizer


def ep4_dbl(D_twist: bool):
    formulaList = fp4_sqr("TY", "t0")
    formulaList += fp4_sqr("TZ", "t1")
    formulaList += fp4_mul("BT", "t1", "t2")
    formulaList += fp4_constMulNotMont("t2", 3, "t3")
    formulaList += fp4_mul("TX", "TY", "t4")
    formulaList += fp4_constMulNotMont("t4", 2, "t5")
    formulaList += fp4_sqr("TX", "t6")
    formulaList += fp4_constMulNotMont("t6", 3, "t7")
    formulaList += fp4_mul("TY", "TZ", "t8")
    formulaList += fp4_constMulNotMont("t8", 2, "t9")
    formulaList += fp4_mul("t0", "t9", "t10_")
    formulaList += fp4_constMulNotMont("t10_", 4, "new_TZ")
    if D_twist:
        formulaList += fp4_sub("t0", "t3", "c11")
    else:
        formulaList += fp4_sub("t0", "t3", "c00")
    formulaList += fp4_constMulNotMont("t3", 2, "t11_")
    if D_twist:
        formulaList += fp4_sub("c11", "t11_", "t12")
    else:
        formulaList += fp4_sub("c00", "t11_", "t12")
    formulaList += fp4_mul("t12", "t5", "new_TX")
    if D_twist:
        formulaList += fp4_add("t0", "c11", "t13")
    else:
        formulaList += fp4_add("t0", "c00", "t13")
    formulaList += fp4_add("t11_", "t3", "b3")
    formulaList += fp4_mul("b3", "t13", "t14")
    formulaList += fp4_sqr("t0", "t15")
    formulaList += fp4_add("t14", "t15", "new_TY")
    if D_twist:
        formulaList += fp4_constMul("t9", "PY", "c00")
        formulaList += fp4_constMul("t7", "PX_", "c10")
    else:
        formulaList += fp4_constMul("t9", "PY", "c11")
        formulaList += fp4_constMul("t7", "PX_", "c01")
    return formulaList

def ep4_dbl_pattern2(D_twist: bool):
    formulaList = fp4_sqr("TY", "t0")
    formulaList += fp4_sqr("TZ", "t1")
    formulaList += fp4_mul("BT", "t1", "t2")
    formulaList += fp4_constMulNotMont("t2", 3, "t3")
    formulaList += fp4_mul("TX", "TY", "t4")
    formulaList += fp4_constMulNotMont("t4", 2, "t5")
    formulaList += fp4_sqr("TX", "t6")
    formulaList += fp4_constMulNotMont("t6", 3, "t7")
    formulaList += fp4_mul("TY", "TZ", "t8")
    formulaList += fp4_constMulNotMont("t8", 2, "t9")
    formulaList += fp4_mul("t0", "t9", "t10_")
    formulaList += fp4_constMulNotMont("t10_", 4, "new_TZ")
    if D_twist:
        formulaList += fp4_sub("t0", "t3", "c11")
    else:
        formulaList += fp4_sub("t0", "t3", "c00")
    formulaList += fp4_constMulNotMont("t3", -3, "t11_") #diff
    formulaList += fp4_add("t0", "t11_", "t12")
    formulaList += fp4_mul("t12", "t5", "new_TX")
    if D_twist:
        formulaList += fp4_add("t0", "c11", "t13")
    else:
        formulaList += fp4_add("t0", "c00", "t13")
    formulaList += fp4_add("t11_", "t3", "b3")
    formulaList += fp4_mul("b3", "t13", "t14")
    formulaList += fp4_sqr("t0", "t15")
    formulaList += fp4_add("t14", "t15", "new_TY")
    if D_twist:
        formulaList += fp4_constMul("t9", "PY", "c00")
        formulaList += fp4_constMul("t7", "PX_", "c10")
    else:
        formulaList += fp4_constMul("t9", "PY", "c11")
        formulaList += fp4_constMul("t7", "PX_", "c01")
    return formulaList

def ep4_add(D_twist: bool):
    formulaList = fp4_mul("QY", "TZ", "t0")
    formulaList += fp4_sub("TY", "t0", "t1")
    formulaList += fp4_mul("QX", "TZ", "t2")
    formulaList += fp4_sub("TX", "t2", "t3")
    formulaList += fp4_sqr("t1", "t4")
    formulaList += fp4_sqr("t3", "t5")
    formulaList += fp4_mul("t3", "t5", "t6")
    formulaList += fp4_mul("TZ", "t4", "t7")
    formulaList += fp4_add("t6", "t7", "t8")
    formulaList += fp4_mul("TX", "t5", "t9")
    formulaList += fp4_constMulNotMont("t9", -2, "t10_")
    formulaList += fp4_add("t8", "t10_", "t11_")
    formulaList += fp4_sub("t11_", "t9", "t12")
    formulaList += fp4_mul("t3", "t11_", "new_TX")
    formulaList += fp4_mul("t1", "t12", "t13")
    formulaList += fp4_mul("TY", "t6", "t14")
    formulaList += fp4_add("t13", "t14", "t15")
    formulaList += fp4_constMulNotMont("t15", -1, "new_TY")
    formulaList += fp4_mul("TZ", "t6", "new_TZ")
    if D_twist:
        formulaList += fp4_constMul("t3", "PY_", "c00")
        formulaList += fp4_constMul("t1", "PX", "c10")
    else:
        formulaList += fp4_constMul("t3", "PY_", "c11")
        formulaList += fp4_constMul("t1", "PX", "c01")
    formulaList += fp4_mul("QY", "t3", "t16")
    formulaList += fp4_mul("QX", "t1", "t17")
    if D_twist:
        formulaList += fp4_sub("t16", "t17", "c11")
    else:
        formulaList += fp4_sub("t16", "t17", "c00")
    return formulaList

def fp24_SQR012345(opr1: str, ret: str):
    formulaList = fp4_sqr(opr1 + "00", "t0")
    formulaList += fp4_constMulNotMont(opr1 + "01", 4, "t1")
    formulaList += fp4_mul(opr1 + "00", opr1 + "01", "t2")
    formulaList += fp4_constMulNotMont(opr1 + "02", 2, "t3")
    formulaList += fp4_mul(opr1 + "00", opr1 + "02", "t4")
    formulaList += fp4_sqr(opr1 + "01", "t5")
    formulaList += fp4_constMulNotMont(opr1 + "10", 2, "t6")
    formulaList += fp4_constMulNotMont(opr1 + "01", 6, "t7")
    formulaList += fp4_mul(opr1 + "00", opr1 + "11", "t8")
    formulaList += fp4_constMulNotMont(opr1 + "11", 2, "t9")
    formulaList += fp4_constMulNotMont(opr1 + "12", 2, "t10_")
    formulaList += fp4_mul(opr1 + "02", opr1 + "10", "t11_")

    formulaList += fp4_constMulNotMont("t0", 2, "t12")
    formulaList += fp4_guzai(opr1 + "02", "t13")
    formulaList += fp4_mul("t1", "t13", "t14")
    formulaList += sub("t1200", "ONE", "t1500")
    formulaList += sub("t1201", "ZERO", "t1501")
    formulaList += sub("t1210", "ZERO", "t1510")
    formulaList += sub("t1211", "ZERO", "t1511")
    formulaList += fp4_add("t14", "t15", ret + "00")

    formulaList += fp4_constMulNotMont("t2", 4, "t16")
    formulaList += fp4_guzai(opr1 + "02", "t17")
    formulaList += fp4_mul("t3", "t17", "t18")
    formulaList += fp4_add("t16", "t18", ret + "01")

    formulaList += fp4_constMulNotMont("t4", 4, "t19")
    formulaList += fp4_constMulNotMont("t5", 2, "t20_")
    formulaList += fp4_add("t19", "t20_", ret + "02")

    formulaList += fp4_guzai(opr1 + "12", "t21_")
    formulaList += fp4_mul("t7", "t21_", "t22")
    formulaList += fp4_add("t6", "t22", ret + "10")

    formulaList += fp4_constMulNotMont("t8", 6, "t23")
    formulaList += fp4_add("t9", "t23", ret + "11")

    formulaList += fp4_constMulNotMont("t11_", 6, "t24")
    formulaList += fp4_add("t10_", "t24", ret + "12")
    return formulaList

def fp24_SQR012345_pattern2(opr1: str, ret: str): #2倍のところをaddにするかconstにするか
    formulaList = fp4_sqr(opr1 + "00", "t0")
    formulaList += fp4_add(opr1 + "00", opr1 + "02", "t1")
    formulaList += fp4_sub("t1", opr1 + "01", "t2")
    formulaList += fp4_add("t1", opr1 + "01", "t8")
    formulaList += fp4_sqr("t8", "t9")
    formulaList += fp4_sqr("t2", "t10_")
    formulaList += fp4_mul(opr1 + "02", opr1 + "01", "t3")
    formulaList += fp4_constMulNotMont("t3", 2, "t11_")
    formulaList += fp4_sqr(opr1 + "02", "t4")
    formulaList += fp4_mul(opr1 + "00", opr1 + "11", "t5")
    formulaList += fp4_mul(opr1 + "01", opr1 + "12", "t6")
    formulaList += fp4_mul(opr1 + "10", opr1 + "02", "t7")
    formulaList += fp4_guzai("t11_", "t12")
    formulaList += fp4_add("t0", "t12", "t13")
    formulaList += sub("t1300", "ONE", "t1400")
    formulaList += sub("t1301", "ZERO", "t1401")
    formulaList += sub("t1310", "ZERO", "t1410")
    formulaList += sub("t1311", "ZERO", "t1411")
    formulaList += fp4_add("t13", "t14", ret + "00")
    formulaList += fp4_add("t0", "t4", "t15")
    formulaList += fp4_constMulNotMont("t15", 2, "t16")
    formulaList += fp4_sub("t9", "t16", "t17")
    formulaList += fp4_add("t10_", "t17", ret + "02")
    formulaList += fp4_guzai("t4", "t18")
    formulaList += fp4_sub("t18", "t11_", "t19")
    formulaList += fp4_constMulNotMont("t19", 2, "t20_")
    formulaList += fp4_add("t20_", "t9", "t21_")
    formulaList += fp4_sub("t21_", "t10_", ret + "01")
    formulaList += fp4_constMulNotMont("t6", 3, "t22")
    formulaList += fp4_guzai("t22", "t23")
    formulaList += fp4_add(opr1 + "10", "t23", "t24")
    formulaList += fp4_add("t24", "t24", ret + "10")
    formulaList += fp4_constMulNotMont("t7", 3, "t25")
    formulaList += fp4_add("t25", opr1 + "12", "t26")
    formulaList += fp4_add("t26", "t26", ret + "12")
    formulaList += fp4_constMulNotMont("t5", 3, "t27")
    formulaList += fp4_add("t27", opr1 + "11", "t28")
    formulaList += fp4_add("t28", "t28", ret + "11")
    return formulaList


def Fp4SparseMul(a0, a1, b0, b1, b2, ret):
    formulaList = fp4_mul(a0, b0, ret + "_t0")
    formulaList += fp4_mul(a1, b1, ret + "_t1")
    formulaList += fp4_mul(a1, b2, ret + "_t2")
    formulaList += fp4_guzai(ret + "_t2", ret + "_t9")
    formulaList += fp4_add(ret + "_t0", ret + "_t9", ret + "0")
    formulaList += fp4_add(a0, a1, ret + "_t4")
    formulaList += fp4_add(b0, b1, ret + "_t5")
    formulaList += fp4_mul(ret + "_t4", ret + "_t5", ret + "_t6")
    formulaList += fp4_add(ret + "_t0", ret + "_t1", ret + "_t7")
    formulaList += fp4_sub(ret + "_t6", ret + "_t7", ret + "1")
    formulaList += fp4_mul(a0, b2, ret + "_t8")
    formulaList += fp4_add(ret + "_t8", ret + "_t1", ret + "2")
    return formulaList


def fp24_sparse_m6(opr1: str, opr2: str, ret: str):  # opr1: line evaluation
    formulaList = fp4_mul(opr1 + "11", opr2 + "10", "t1")
    formulaList += fp4_mul(opr1 + "11", opr2 + "11", "t2")
    formulaList += fp4_mul(opr1 + "11", opr2 + "12", "t0")
    formulaList += fp4_guzai("t0", "t3")
    formulaList += Fp4SparseMul(opr1 +
                                "00", opr1 +
                                "01", opr2 +
                                "00", opr2 +
                                "01", opr2 +
                                "02", "t4")
    formulaList += fp4_add(opr1 + "01", opr1 + "11", "t7")
    formulaList += fp4_add(opr2 + "00", opr2 + "10", "t8")
    formulaList += fp4_add(opr2 + "01", opr2 + "11", "t9")
    formulaList += fp4_add(opr2 + "02", opr2 + "12", "t10_")
    formulaList += Fp4SparseMul(opr1 + "00", "t7", "t8", "t9", "t10_", "t5")
    formulaList += fp4_add("t3", "t40", "t14")
    formulaList += fp4_add("t1", "t41", "t15")
    formulaList += fp4_add("t2", "t42", "t16")
    formulaList += fp4_sub("t50", "t14", ret + "10")
    formulaList += fp4_sub("t51", "t15", ret + "11")
    formulaList += fp4_sub("t52", "t16", ret + "12")
    formulaList += fp4_guzai("t2", "t17")
    formulaList += fp4_add("t17", "t40", ret + "00")
    formulaList += fp4_add("t3", "t41", ret + "01")
    formulaList += fp4_add("t1", "t42", ret + "02")
    return formulaList


def fp24_sparse_d6(opr1: str, opr2: str, ret: str):  # opr1: line evaluation
    formulaList = fp4_mul(opr1 + "00", opr2 + "00", "t0")
    formulaList += fp4_mul(opr1 + "00", opr2 + "01", "t1")
    formulaList += fp4_mul(opr1 + "00", opr2 + "02", "t2")
    formulaList += Fp4SparseMul(opr1 +
                                "10", opr1 +
                                "11", opr2 +
                                "10", opr2 +
                                "11", opr2 +
                                "12", "t4")
    formulaList += fp4_add(opr1 + "00", opr1 + "10", "t7")
    formulaList += fp4_add(opr2 + "00", opr2 + "10", "t8")
    formulaList += fp4_add(opr2 + "01", opr2 + "11", "t9")
    formulaList += fp4_add(opr2 + "02", opr2 + "12", "t10_")
    formulaList += Fp4SparseMul("t7", opr1 + "11", "t8", "t9", "t10_", "t5")
    formulaList += fp4_add("t0", "t40", "t14")
    formulaList += fp4_add("t1", "t41", "t15")
    formulaList += fp4_add("t2", "t42", "t16")
    formulaList += fp4_sub("t50", "t14", ret + "10")
    formulaList += fp4_sub("t51", "t15", ret + "11")
    formulaList += fp4_sub("t52", "t16", ret + "12")
    formulaList += fp4_guzai("t42", "t17")
    formulaList += fp4_add("t0", "t17", ret + "00")
    formulaList += fp4_add("t1", "t40", ret + "01")
    formulaList += fp4_add("t2", "t41", ret + "02")
    return formulaList


if __name__ == "__main__":
    formulaList = fp24_SQR012345("a", "c")
    organizer = FormulaOrganizer()
    formulaList = organizer.remove_extra_formula(formulaList)
    for formula in formulaList:
        print(
            "{},{},{},{}".format(
                formula.ret,
                formula.opr1,
                formula.opr2,
                formula.type))
