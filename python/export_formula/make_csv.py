import sys
sys.path.append('./')
from export_formula.fp12 import fp12_mul, fp12_conj, fp12_frob, fp12_sqr, fp12_mul_conj, fp12_inv
from export_formula.ep2 import ep2_add, ep2_dbl, fp12_sparse_d6, fp12_sparse_m6, fp12_SQR012345, ep2_dbl_pattern2, fp12_SQR012345_pattern2
from export_formula.fp24 import fp24_mul, fp24_conj, fp24_frob, fp24_sqr, fp24_mul_conj, fp24_inv
from export_formula.ep4 import ep4_add, ep4_dbl, fp24_sparse_d6, fp24_sparse_m6, fp24_SQR012345, ep4_dbl_pattern2, fp24_SQR012345_pattern2
from export_formula.transform import FormulaOrganizer
from lib.parameters import curve_group, curve_name, D_twist
import os


def printCsv(filename, formulaList):
    write_f = open(filename, 'w')
    organizer = FormulaOrganizer()
    # home_dir = os.path.dirname(os.getcwd().replace("\\", "/"))
    # csv_dir = "{}/{}-{}/csv/".format(home_dir, curve_group, curve_name)
    # if filename == csv_dir+"MUL.csv":
    #         for formula in formulaList:
    #             print(
    #             "{},{},{},{}".format(
    #                 formula.ret,
    #                 formula.opr1,
    #                 formula.opr2,
    #                 formula.type))
    formulaList = organizer.remove_extra_formula(formulaList)
    for formula in formulaList:
        write_f.write("{},{},{},{}\n".format(
            formula.ret, formula.opr1, formula.opr2, formula.type))


def fp12_makeCsv(directory: str):
    os.makedirs(directory, exist_ok=True)
    printCsv(directory+"CONJ.csv", fp12_conj("a", "c"))
    printCsv(directory+"FROB.csv", fp12_frob("a", "c"))
    printCsv(directory+"MUL.csv", fp12_mul("a", "b", "c"))
    printCsv(directory+"MUL_CONJ.csv", fp12_mul_conj("a", "b", "c"))
    printCsv(directory+"SQR.csv", fp12_sqr("a", "c"))
    printCsv(directory+"PDBL.csv", ep2_dbl(D_twist))
    printCsv(directory+"PADD.csv", ep2_add(D_twist))
    printCsv(directory+"SQR012345.csv", fp12_SQR012345("a", "c"))
    printCsv(directory+"INV.csv", fp12_inv("a", "c"))
    if D_twist:
        printCsv(directory+"SPARSE.csv", fp12_sparse_d6("a", "b", "c"))
    else:
        printCsv(directory+"SPARSE.csv", fp12_sparse_m6("a", "b", "c"))
    
    # 比較用
    printCsv(directory+"PDBL_P2.csv", ep2_dbl_pattern2(D_twist))
    printCsv(directory+"SQR012345_P2.csv", fp12_SQR012345_pattern2("a", "c"))


def fp24_makeCsv(directory: str):
    os.makedirs(directory, exist_ok=True)
    printCsv(directory+"CONJ.csv", fp24_conj("a", "c"))
    printCsv(directory+"FROB.csv", fp24_frob("a", "c"))
    printCsv(directory+"MUL.csv", fp24_mul("a", "b", "c"))
    printCsv(directory+"MUL_CONJ.csv", fp24_mul_conj("a", "b", "c"))
    printCsv(directory+"SQR.csv", fp24_sqr("a", "c"))
    printCsv(directory+"PDBL.csv", ep4_dbl(D_twist))
    printCsv(directory+"PADD.csv", ep4_add(D_twist))
    printCsv(directory+"SQR012345.csv", fp24_SQR012345("a", "c"))
    printCsv(directory+"INV.csv", fp24_inv("a", "c"))
    if D_twist:
        printCsv(directory+"SPARSE.csv", fp24_sparse_d6("a", "b", "c"))
    else:
        printCsv(directory+"SPARSE.csv", fp24_sparse_m6("a", "b", "c"))
    
    # 比較用
    printCsv(directory+"PDBL_P2.csv", ep4_dbl_pattern2(D_twist))
    printCsv(directory+"SQR012345_P2.csv", fp24_SQR012345_pattern2("a", "c"))


if __name__ == "__main__":
    home_dir = os.path.dirname(os.getcwd().replace("\\", "/"))
    csv_dir = "{}/{}-{}/csv/".format(home_dir, curve_group, curve_name)
    if curve_group == "bls12":
        fp12_makeCsv(csv_dir)
    elif curve_group == "bls24":
        fp24_makeCsv(csv_dir)
