import shutil
from io import TextIOWrapper
import os

import sys
sys.path.append('./')
from lib.parameters import Fp, Fp2, fp4_qnr, u, U, p, P, Q, T, BT, curve_group, curve_name


def write_parameter_vh(home_dir: str, f_param):
    p_len = p.bit_length()
    p3 = p * 3
    p5 = p * 5
    L = 2 ** p_len
    p_inv = (-pow(p, -1, L)) % L
    inv_init_val = (2 ** (2 * p_len)) % p

    with open("{}/RTL/lib/bls12/ram_addr.v".format(home_dir), "r") as file:
        content = file.read()

    f = open(f_param, 'a')
    f.write(content)

    f.write("\n\n// constants -------------------------------------------------------------------------------------------------\n")
    f.write("`define WORD_SIZE 'd{}\n".format(p_len))
    f.write("`define CHAR {:d}'h{:x}\n".format(p_len, p))
    f.write("`define CHAR_INV {:d}'h{:x}\n".format(p_len, p_inv))
    f.write("`define INVERSION_INITIAL_VALUE {:d}'h{:x}\n".format(p_len, inv_init_val))
    f.write("`define CHAR_3X {:d}'h{:x}\n\n".format(p_len+2, p3))  # NOTE: Div4PathUnit-aug_p のbit幅要確認
    f.write("`define CHAR_5X {:d}'h{:x}\n\n".format(p_len+3, p5))  # NOTE: 定数乗算に必要

    f.write("// parameters for twisted curve (Ep2)\n")
    f.write("`define BT0 {:d}'h{:x}\n".format(p_len, BT[0]))
    f.write("`define BT1 {:d}'h{:x}\n".format(p_len, BT[1]))

    one = Fp.one()
    xi = [
        [[Fp.one(), 0], [0, 0]],
        Fp2.exp(Fp2.MontConv(fp4_qnr), (p - 1) // 6),
        Fp2.exp(Fp2.MontConv(fp4_qnr), 2 * (p - 1) // 6),
        Fp2.exp(Fp2.MontConv(fp4_qnr), 3 * (p - 1) // 6),
        Fp2.exp(Fp2.MontConv(fp4_qnr), 4 * (p - 1) // 6),
        Fp2.exp(Fp2.MontConv(fp4_qnr), 5 * (p - 1) // 6)
    ]

    f.write("// // constants independent from elliptic curve\n")
    f.write("`define ZERO {}'d0\n".format(p_len))
    f.write("`define ONE {:d}'h{:x}\n\n".format(p_len, one))

    f.write("// Frobenius pre-calculated coefficients\n")
    for i in range(1, 6):
        for j in range(2):
            f.write("`define XI{}{} {:d}'h{:x}\n".format(i, j, p_len, xi[i][j]))
    f.close()


def write_input_vh(f_input):
    f = open(f_input, 'w')
    p_len = p.bit_length()

    # a = random.randint(1, r-1)
    # print("a: " + str(a))
    # aP = ep_mul(a, [P[0][0][0], P[1][0][0]])
    # aP = [[[aP[0][0][0], 0], [0, 0]], [[aP[1][0][0], 0], [0, 0]]]
    aP = P
    f.write("`define PX {:d}'h{:x}\n".format(p_len, aP[0]))
    f.write("`define PX_ {:d}'h{:x}\n".format(p_len, Fp.neg(aP[0])))
    f.write("`define PX3 {:d}'h{:x}\n".format(p_len, Fp.add(aP[0], Fp.add(aP[0], aP[0]))))
    f.write("`define PY {:d}'h{:x}\n".format(p_len, aP[1]))
    f.write("`define PY_ {:d}'h{:x}\n".format(p_len, Fp.neg(aP[1])))

    # b = random.randint(1, r-1)
    # print("b: " + str(b))
    # bT = ep4_mul(b, T)
    # bT = change_to_affine(bT)
    # bQ = bT[: 2]
    bQ = Q
    bT = T

    for i in range(2):
        f.write("`define QX{} {:d}'h{:x}".format(i, p_len, bQ[0][i]))
    for i in range(2):
        f.write("`define QY{} {:d}'h{:x}".format(i, p_len, bQ[1][i]))
    for i in range(2):
        f.write("`define QY_{} {:d}'h{:x}".format(i, p_len, Fp.neg(bQ[1][i])))
    for i in range(2):
        f.write("`define TX{} {:d}'h{:x}".format(i, p_len, bT[0][i]))
    for i in range(2):
        if u > 0:
            f.write("`define TY{} {:d}'h{:x}".format(i, p_len, bT[1][i]))
        else:
            f.write("`define TY{} {:d}'h{:x}".format(i, p_len, Fp.neg(bT[1][i])))
    for i in range(2):
        f.write("`define TZ{} {:d}'h{:x}".format(i, p_len, bT[2][i]))
    f.close()


def print_commands_list(cnt, commands_list, f):
    for index, command in enumerate(commands_list):
        f.write("writeCommands({}, {{`{}, {}, {}, {}}});\n".format(cnt + index, command[0], command[1], command[2], command[3]))


def make_ML_commands(f_ML_commands):
    f = open(f_ML_commands, 'w')
    m = U[::-1]
    cnt = 0
    commands_list = []  # [MODE, opr1, opr2, ret]
    for l in m[1:]:
        if cnt == 0:
            cnt = 1
            commands_list.append(["MODE_PDBL", "`RAM_QX0", "`RAM_QX0", "`RAM_F"])
        else:
            commands_list.append(["MODE_PDBL", "`RAM_QX0", "`RAM_QX0", "`RAM_E"])
            commands_list.append(["MODE_SQUARE", "`RAM_F", "`RAM_F", "`RAM_F"])
            commands_list.append(["MODE_SPARSE_MUL", "`RAM_E", "`RAM_F", "`RAM_F"])
        if l == 1:
            commands_list.append(["MODE_PADD", "`RAM_QX0", "`RAM_QX0", "`RAM_E"])
            commands_list.append(["MODE_SPARSE_MUL", "`RAM_E", "`RAM_F", "`RAM_F"])
        if l == -1:
            commands_list.append(["MODE_PMINUS", "`RAM_QX0", "`RAM_QX0", "`RAM_E"])
            commands_list.append(["MODE_SPARSE_MUL", "`RAM_E", "`RAM_F", "`RAM_F"])
    print_commands_list(0, commands_list, f)
    f.close()
    return len(commands_list)


def expFp12_commands(cnt, opr, ret, f: TextIOWrapper):
    delay_mul = False
    init_to_ret = False
    commands_list = []  # [MODE, opr1, opr2, ret]
    for index, l in enumerate(U):
        if l == 1:
            if index == 0:
                commands_list.append(["MODE_SQR012345", opr, "`RAM_C", "`RAM_C"])
                delay_mul = True
            else:
                if delay_mul:
                    commands_list.append(["MODE_MUL", opr, "`RAM_C", ret])
                    commands_list.append(["MODE_SQR012345", "`RAM_C", "`RAM_C", "`RAM_C"])
                    delay_mul = False
                elif init_to_ret:
                    commands_list[-1][3] = ret
                    commands_list.append(["MODE_SQR012345", ret, "`RAM_C", "`RAM_C"])
                    init_to_ret = False
                else:
                    commands_list.append(["MODE_MUL", ret, "`RAM_C", ret])
                    commands_list.append(["MODE_SQR012345", "`RAM_C", "`RAM_C", "`RAM_C"])
        elif l == -1:
            if index == 0:
                commands_list.append(["MODE_SQR012345", opr, "`RAM_C", "`RAM_C"])
                commands_list.append(["MODE_CONJ", opr, "`RAM_C", ret])
            else:
                if delay_mul:
                    commands_list.append(["MODE_MUL_CONJ", opr, "`RAM_C", ret])
                    delay_mul = False
                elif init_to_ret:
                    commands_list.append(["MODE_CONJ", "`RAM_C", "`RAM_C", ret])
                    init_to_ret = False
                else:
                    commands_list.append(["MODE_MUL_CONJ", ret, "`RAM_C", ret])
                commands_list.append(["MODE_SQR012345", "`RAM_C", "`RAM_C", "`RAM_C"])
        else:
            if index == 0:
                init_to_ret = True
                commands_list.append(["MODE_SQR012345", opr, "`RAM_C", "`RAM_C"])
            else:
                commands_list.append(["MODE_SQR012345", "`RAM_C", "`RAM_C", "`RAM_C"])
    print_commands_list(cnt, commands_list[:-1], f)
    return cnt + len(commands_list) - 1


def make_FE_commands(f_FE_commands):
    f = open(f_FE_commands, 'w')
    f.write("// Easy Part -------------------------------------------------------\n")
    f.write("writeCommands(0, {`MODE_FROB, `RAM_F, `RAM_F, `RAM_E});  // e = FrobFp12(FrobFp12(f))\n")
    f.write("writeCommands(1, {`MODE_FROB, `RAM_E, `RAM_E, `RAM_E});\n")
    f.write("writeCommands(2, {`MODE_MUL, `RAM_F, `RAM_E, `RAM_E}); // e = mulFp12(e, f)\n")
    f.write("writeCommands(3, {`MODE_INV, `RAM_E, `RAM_E, `RAM_F}); // f = invFp12(e)\n")
    f.write("writeCommands(4, {`MODE_MUL_CONJ, `RAM_F, `RAM_E, `RAM_F}); // f = mulFp12_conj_forRTL(f, e)\n")

    f.write("// Hard Part -------------------------------------------------------\n")
    f.write("writeCommands(5, {`MODE_SQR012345, `RAM_F, `RAM_F, `RAM_G}); // t1 = SQR012345Fp12(f)\n")

    f.write("// t2 = expFp12(f)\n")
    cnt = expFp12_commands(6, "`RAM_F", "`RAM_E", f)

    f.write("writeCommands({}, {{`MODE_MUL_CONJ, `RAM_E, `RAM_G, `RAM_G}}); // t1 = mulFp12_conj_forRTL(t2, t1)\n".format(cnt))

    f.write("// t4 = expFp12(t1)\n")
    cnt = expFp12_commands(cnt + 1, "`RAM_G", "`RAM_B", f)

    f.write("writeCommands({}, {{`MODE_MUL_CONJ, `RAM_F, `RAM_G, `RAM_G}}); // t1 = mulFp12_conj_forRTL(f, t1) \n".format(cnt))

    f.write("// t5 = expFp12(t4)\n")
    cnt = expFp12_commands(cnt + 1, "`RAM_B", "`RAM_A", f)

    f.write("writeCommands({}, {{`MODE_MUL, `RAM_F, `RAM_B, `RAM_B}}); // t4 = mulFp12(f, t4)\n".format(cnt))

    f.write("// t3 = expFp12(t5)\n")
    cnt = expFp12_commands(cnt + 1, "`RAM_A", "`RAM_D", f)

    f.write("writeCommands({}, {{`MODE_MUL, `RAM_E, `RAM_A, `RAM_A}}); // t5 = mulFp12(t2, t5)\n".format(cnt))
    f.write("writeCommands({}, {{`MODE_SQR012345, `RAM_E, `RAM_E, `RAM_E}}); // t2 = SQR012345Fp12(t2)\n".format(cnt + 1))
    f.write("writeCommands({}, {{`MODE_FROB, `RAM_B, `RAM_E, `RAM_B}}); // t4 = FrobFp12(FrobFp12(t4))\n".format(cnt + 2))
    f.write("writeCommands({}, {{`MODE_FROB, `RAM_B, `RAM_B, `RAM_B}});\n".format(cnt + 3))
    f.write("writeCommands({}, {{`MODE_FROB, `RAM_A, `RAM_A, `RAM_A}}); // t5 = FrobFp12(FrobFp12(t5))\n".format(cnt + 4))
    f.write("writeCommands({}, {{`MODE_FROB, `RAM_A, `RAM_A, `RAM_A}});\n".format(cnt + 5))
    f.write("writeCommands({}, {{`MODE_MUL, `RAM_E, `RAM_D, `RAM_E}}); //t2 = mulFp12(t2, t3)\n".format(cnt + 6))
    f.write("writeCommands({}, {{`MODE_FROB, `RAM_B, `RAM_B, `RAM_B}}); // t4 = FrobFp12(t4)\n".format(cnt + 7))

    f.write("// t3 = expFp12(t2)\n")
    cnt = expFp12_commands(cnt + 8, "`RAM_E", "`RAM_D", f)

    f.write("writeCommands({}, {{`MODE_MUL, `RAM_B, `RAM_A, `RAM_B}}); // t4 = mulFp12(t4, t5)\n".format(cnt))
    f.write("writeCommands({}, {{`MODE_MUL_CONJ, `RAM_E, `RAM_F, `RAM_A}}); // t5 = mulFp12_conj_forRTL(t2, f)\n".format(cnt + 1))
    f.write("writeCommands({}, {{`MODE_MUL, `RAM_G, `RAM_D, `RAM_G}}); // t1 = mulFp12(t1, t3)\n".format(cnt + 2))
    f.write("writeCommands({}, {{`MODE_FROB, `RAM_A, `RAM_A, `RAM_A}}); // t5 = FrobFp12(t5)\n".format(cnt + 3))
    f.write("writeCommands({}, {{`MODE_MUL, `RAM_G, `RAM_B, `RAM_G}}); // t1 = mulFp12(t1, t4)\n".format(cnt + 4))
    f.write("writeCommands({}, {{`MODE_MUL, `RAM_G, `RAM_A, `RAM_G}}); // t1 = mulFp12(t1, t3)\n".format(cnt + 5))

    return cnt + 6


def testbench_copy(home_dir, RTL_dir):
    shutil.copy("{}/RTL/lib/bls12/input_values.v".format(home_dir), "{}/testbench/include/".format(RTL_dir))
    shutil.copy("{}/RTL/lib/bls12/SQR_test.v".format(home_dir), "{}/testbench/include/".format(RTL_dir))
    shutil.copy("{}/RTL/lib/bls12/sim_new_arch.v".format(home_dir), "{}/testbench/".format(RTL_dir))
    shutil.copy("{}/RTL/lib/bls12/simML.v".format(home_dir), "{}/testbench/".format(RTL_dir))
    shutil.copy("{}/RTL/lib/bls12/simPairing.v".format(home_dir), "{}/testbench/".format(RTL_dir))
    shutil.copy("{}/RTL/lib/bls12/simRAM_wr.v".format(home_dir), "{}/testbench/".format(RTL_dir))
    # shutil.copy("{}/RTL/lib/bls12/init.v".format(home_dir), "{}/include/".format(RTL_dir)) #レジスタ版用


def make_RTL():
    home_dir = os.path.dirname(os.getcwd().replace("\\", "/"))
    RTL_dir = "{}/{}-{}/RTL".format(home_dir, curve_group, curve_name)
    shutil.copytree("{}/RTL".format(home_dir), RTL_dir, dirs_exist_ok=True, ignore=shutil.ignore_patterns("lib"))
    testbench_copy(home_dir, RTL_dir)

    write_parameter_vh(home_dir, f_param="{}/include/parameter.vh".format(RTL_dir))
    write_input_vh(f_input="{}/include/parameter_input.vh".format(RTL_dir))

    cmd_memdepth_ml = make_ML_commands(f_ML_commands="{}/testbench/include/ML_input_commands.v".format(RTL_dir))
    cmd_memdepth_fe = make_FE_commands(f_FE_commands="{}/testbench/include/FE_input_commands.v".format(RTL_dir))
    f = open("{}/include/parameter.vh".format(RTL_dir), 'a')
    f.write("`define CMD_MEMDEPTH_ML {}\n".format(cmd_memdepth_ml))
    f.write("`define CMD_MEMSIZE_ML {}\n\n".format((cmd_memdepth_ml - 1).bit_length()))
    f.write("`define CMD_MEMDEPTH_FE {}\n".format(cmd_memdepth_fe))
    f.write("`define CMD_MEMSIZE_FE {}\n\n".format((cmd_memdepth_fe - 1).bit_length()))
    f.write("`define CMD_MEMSIZE {}\n".format(max((cmd_memdepth_fe - 1).bit_length(), (cmd_memdepth_ml - 1).bit_length())))
    f.close()


if __name__ == '__main__':
    # args = sys.argv
    # dict = read_csv(args[2])
    make_RTL()
