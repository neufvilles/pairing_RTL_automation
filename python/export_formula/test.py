import sys
sys.path.append('./')
import csv
import os
from lib.pairing import add_line_twist6, double_line_twist6, sparse_mult_m6_twist, sparse_mult_d6_twist, SQR012345
from lib.util import FormulaSet
from lib.parameters import Fp, Fp2, Fq, Fq6, P, Q, T, BT, D_twist, xi, curve_group, curve_name


def csv2Formula(path):
    f = open(path, "r")
    formulaList = []
    for line in csv.reader(f):
        formulaList.append(FormulaSet(
            ret=line[0], opr1=line[1], opr2=line[2], type=line[3]))
    return formulaList

ConstList = ["ZERO", "ONE", "PX", "PY", "PX_", "PY_"]

def initialize_value(k, a, b):
    valueList = {}
    valueList["ZERO"] = Fp.zero()
    valueList["ONE"] = Fp.one()
    valueList["PX"] = P[0]
    valueList["PY"] = P[1]
    valueList["PX_"] = Fp.neg(P[0])
    valueList["PY_"] = Fp.neg(P[1])

    numberlist = ["ZERO","ONE","TWO","THREE","FOUR","FIVE","SIX","SEVEN","EIGHT","NINE","TEN",
                  "ELEVEN","TWELVE","THIRTEEN","FOURTEEN","FIFTEEN","SIXTEEN","SEVENTEEN",
                  "EIGHTEEN","NINETEEN","TWENTY"]
    for i in range(len(numberlist)):
        modename = "MODE" + numberlist[i]
        valueList[modename] = i
        modename += "_"
        valueList[modename] = -1*i        

    if k == 12:
        for i in range(2):
            valueList['QX{}'.format(i)] = Q[0][i]
            valueList['QY{}'.format(i)] = Q[1][i]
            valueList['TX{}'.format(i)] = T[0][i]
            valueList['TY{}'.format(i)] = T[1][i]
            valueList['TZ{}'.format(i)] = T[2][i]
            valueList['BT{}'.format(i)] = BT[i]
        for j in range(1, 6):
            for i in range(2):
                valueList['XI{}{}'.format(j, i)] = Fq6.k[j][i]
        for m in range(3):
            for j in range(2):
                for i in range(2):
                    valueList['a{}{}{}'.format(m, j, i)] = a[m][j][i]
                    valueList['b{}{}{}'.format(m, j, i)] = b[m][j][i]
    elif k == 24:
        for j in range(2):
            for i in range(2):
                valueList['QX{}{}'.format(j, i)] = Q[0][j][i]
                valueList['QY{}{}'.format(j, i)] = Q[1][j][i]
                valueList['TX{}{}'.format(j, i)] = T[0][j][i]
                valueList['TY{}{}'.format(j, i)] = T[1][j][i]
                valueList['TZ{}{}'.format(j, i)] = T[2][j][i]
                valueList['BT{}{}'.format(j, i)] = BT[j][i]
        for m in range(1, 6):
            for j in range(2):
                for i in range(2):
                    valueList['XI{}{}{}'.format(m, j, i)] = Fq6.k[m][j][i]
        for i in range(2):
            valueList['K{}'.format(i)] = Fq.k[i]
        for n in range(2):
            for m in range(3):
                for j in range(2):
                    for i in range(2):
                        valueList['a{}{}{}{}'.format(n, m, j, i)] = a[n][m][j][i]
                        valueList['b{}{}{}{}'.format(n, m, j, i)] = b[n][m][j][i]
    return valueList


def calculate_test(valueList: dict, formulaList: list):
    # calculate
    for formula in formulaList:
        if formula.type == "ADD":
            valueList[formula.ret] = Fp.add(
                valueList[formula.opr1], valueList[formula.opr2])
        elif formula.type == "SUB":
            valueList[formula.ret] = Fp.sub(
                valueList[formula.opr1], valueList[formula.opr2])
        elif formula.type == "MUL":
            valueList[formula.ret] = Fp.mul(
                valueList[formula.opr1], valueList[formula.opr2])
        elif formula.type == "INV":
            valueList[formula.ret + "0"] = Fp.inv(valueList[formula.opr1])
            valueList[formula.ret + "1"] = Fp.zero()
        elif formula.type == "FP2MUL":
            if formula.opr2 in ConstList:
                [valueList[formula.ret + "0"], valueList[formula.ret  + "1"]] = Fp2.mul(
                [valueList[formula.opr1 + "0"], valueList[formula.opr1 + "1"]], 
                [valueList[formula.opr2], valueList["ZERO"]])
            else:
                [valueList[formula.ret + "0"], valueList[formula.ret  + "1"]] = Fp2.mul(
                [valueList[formula.opr1 + "0"], valueList[formula.opr1 + "1"]], 
                [valueList[formula.opr2 + "0"], valueList[formula.opr2 + "1"]])
        elif formula.type == "CONSTMUL":
            [valueList[formula.ret + "0"], valueList[formula.ret  + "1"]] = Fp2.constMulNotMont(
                [valueList[formula.opr1 + "0"], valueList[formula.opr1 + "1"]], 
                valueList[formula.opr2])
    return valueList


def check_result(valueList: dict, k: int, c):
    # check result
    if k == 2:
        for i in range(2):
            if valueList['c{}'.format(i)] != c[i]:
                print("Error: this formula has some error;")
                return
    elif k == 4:
        for j in range(2):
            for i in range(2):
                if valueList['c{}'.format(i)] != c[j][i]:
                    print("Error: this formula has some error;")
                    return
    elif k == 12:
        # print(c)
        for m in range(3):
            for j in range(2):
                for i in range(2):
                    value_name = 'c{}{}{}'.format(m, j, i)
                    if value_name not in valueList.keys():
                        # print("{}: 0".format(value_name))
                        continue
                    # print(valueList[value_name])
                    if valueList[value_name] != c[m][j][i]:
                        print("Error: this formula has some error;")
                        return
    elif k == 24:
        # print(c)
        for n in range(2):
            for m in range(3):
                for j in range(2):
                    for i in range(2):
                        value_name = 'c{}{}{}{}'.format(n, m, j, i)
                        if value_name not in valueList.keys():
                            # print("{}: 0".format(value_name))
                            continue
                        # print(valueList['c{}{}{}{}'.format(n, m, j, i)])
                        if valueList[value_name] != c[n][m][j][i]:
                            print("Error: this formula has some error;")
                            return
    print("Success!")


def test_formula(k, formulaName, a, b, c):
    home_dir = os.path.dirname(os.getcwd().replace("\\", "/"))
    valueList = initialize_value(k, a, b)
    formulaList = csv2Formula(
        path="{}/{}-{}/csv/{}.csv".format(home_dir, curve_group, curve_name, formulaName))
    valueList = calculate_test(valueList, formulaList)
    print(formulaName, end=": ")
    check_result(valueList, k, c)


def test_all_csv(k):
    a = Fq6.random_element()
    b = Fq6.random_element()
    P_dbl = [Fp.neg(P[0]), P[1]]
    P_add = [P[0], Fp.neg(P[1])]
    test_formula(k, "CONJ", a, b, Fq6.conj(a))
    test_formula(k, "FROB", a, b, Fq6.frob(a))
    test_formula(k, "MUL", a, b, Fq6.mul(a, b))
    test_formula(k, "MUL_CONJ", a, b, Fq6.mul(a, Fq6.conj(b)))
    test_formula(k, "SQR", a, b, Fq6.sqr(a))
    new_T, l = double_line_twist6(Fq, T, P_dbl, BT, xi, D_twist)
    test_formula(k, "PDBL", a, b, Fq6.mapFromFq6(l))
    new_T, l = add_line_twist6(Fq, T, P_add, Q, BT, xi, D_twist)
    test_formula(k, "PADD", a, b, Fq6.mapFromFq6(l))
    c_6 = SQR012345(Fq, xi, Fq6.mapToFq6(a))
    test_formula(k, "SQR012345", a, b, Fq6.mapFromFq6(c_6))
    if D_twist:
        c_6 = sparse_mult_d6_twist(Fq, xi, Fq6.mapToFq6(a), Fq6.mapToFq6(b))
    else:
        c_6 = sparse_mult_m6_twist(Fq, xi, Fq6.mapToFq6(a), Fq6.mapToFq6(b))
    test_formula(k, "SPARSE", a, b, Fq6.mapFromFq6(c_6))
    test_formula(k, "INV", a, b, Fq6.inv(a))


if __name__ == "__main__":
    if curve_group == "bls12":
        test_all_csv(k=12)
    if curve_group == "bls24":
        test_all_csv(k=24)
