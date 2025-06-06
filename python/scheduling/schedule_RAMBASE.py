from scheduling.split_sche import make_split_scheduling
from io import TextIOWrapper
import sys
import csv
import time
import os
import argparse
import copy
args = sys.argv


def alpha2num(c): return ord(c) - ord('A')

ConstList = ["ZERO", "ONE", "PX", "PY", "PX_", "PY_"]

num_str = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

def read_formula_csv(filename):
    f_read = open(filename, "r")
    formulas = []
    for line in csv.reader(f_read):
        if len(line) > 0 and line[0][0] == '#':
            continue
        if len(line) == 4:
            # print([line[0], line[3], line[1], line[2]])
            formulas.append([line[0], line[3], line[1], line[2]])
    f_read.close()
    return formulas


# c = a + b, e = c + d の時 e  から c = a + b を探す
def find_prev_formula(formulas, operand):
    for formula in formulas:
        if formula[0] == operand:
            return formula
    return None


# c = a + b, e = c + d の時 c から e とスケジューリング結果を探して，最小／最大のサイクル数を返す
def find_next_formula(value, formulas, pre_sche_result):
    min_finish_time, max_finish_time = 1000, 0
    for formula in formulas:
        if (formula[2] == value) or (formula[3] == value):
            for sol in pre_sche_result:
                if formula[0] == sol[0]:
                    min_finish_time = min(min_finish_time, int(sol[2]))
                    max_finish_time = max(max_finish_time, int(sol[2]))
        elif (formula[2][:-1]== value) or (formula[3][:-1] == value):
            for sol in pre_sche_result:
                if formula[0] == sol[0]:
                    min_finish_time = min(min_finish_time, int(sol[2]))
                    max_finish_time = max(max_finish_time, int(sol[2]))
        elif (formula[2] + "0" == value) or (formula[3] + "0" == value):
            for sol in pre_sche_result:
                if formula[0] == sol[0]:
                    min_finish_time = min(min_finish_time, int(sol[2]))
                    max_finish_time = max(max_finish_time, int(sol[2]))
        elif (formula[2] + "1" == value) or (formula[3] + "1" == value):
            for sol in pre_sche_result:
                if formula[0] == sol[0]:
                    min_finish_time = min(min_finish_time, int(sol[2]))
                    max_finish_time = max(max_finish_time, int(sol[2]))
    return min_finish_time, max_finish_time


def find_prev_resource(pre_sche_result, operand):
    for pre in pre_sche_result:
        if pre[0] == operand:
            resource = pre[1][:-1]
            resource_num = pre[1][-1]
            end_time = int(pre[3])
            return resource, resource_num, end_time
    return None, None, None


def make_mem_task_definition(
        f_write: TextIOWrapper,
        input_value,
        pre_sche_result,
        formulas,
        mem_table,
        current_formula: list,
        MULnum: int,
        CONSTnum: int,
        ADDnum: int):
    value = current_formula[0]
    if current_formula[2] == current_formula[3] or current_formula[1] == "CONSTMUL":
        # INV or 同じもの同士のFP2MUL or CONSTMUL
        operands = [current_formula[2]]
    else:
        operands = [current_formula[2], current_formula[3]]
    
    for i in range(len(operands)):
        operand = operands[i]
        mem_value_name = "{0}_mem{1}".format(value, i)

        if current_formula[1] == "FP2MUL" or current_formula[1] == "CONSTMUL":
            if operand in input_value in input_value or operand+"0" in input_value:
                f_write.write("\t{0} = S.Tasks('{0}', num=2, length=1, delay_cost=1)\n".format(mem_value_name))
                f_write.write("\t{0}[0] += alt(INPUT_mem_r0)\n".format(mem_value_name))
                f_write.write("\t{0}[1] += alt(INPUT_mem_r1)\n".format(mem_value_name))
            else:
                prev_formula0 = None
                prev_formula1 = None
                pre_resource0, pre_resource_num0, pre_end_time0 = None, None, None
                pre_resource1, pre_resource_num1, pre_end_time1 = None, None, None
                prev_formula0 = find_prev_formula(formulas, operand)
                if prev_formula0 is None:  
                    prev_formula0 = find_prev_formula(formulas, operand + "0")
                    prev_formula1 = find_prev_formula(formulas, operand + "1")
                    pre_resource0, pre_resource_num0, pre_end_time0 = find_prev_resource(pre_sche_result, operand + "0")
                    pre_resource1, pre_resource_num1, pre_end_time1 = find_prev_resource(pre_sche_result, operand + "1")
                else:
                    pre_resource0, pre_resource_num0, pre_end_time0 = find_prev_resource(pre_sche_result, operand)
                if prev_formula0 is None:
                    raise Exception("can't find previous formula")
                opcode = prev_formula0[1]
                if opcode == "INV":
                    f_write.write("\tS += {0} < {1}\n".format(operand, value))
                    f_write.write("\t{0}1 = S.Task('{0}1', length=1, delay_cost=1)\n".format(mem_value_name))
                    f_write.write("\t{0}1 += INPUT_mem_r1\n".format(mem_value_name))                
                    continue
                f_write.write("\t{0} = S.Tasks('{0}', num=2, length=1, delay_cost=1)\n".format(mem_value_name))
                if opcode == "FP2MUL":
                    if pre_resource0 is None:
                        f_write.write("\t{0} += alt(FP2MUL_mem{1})\n".format(mem_value_name, i))
                        for j in range(MULnum):
                            f_write.write("\tS += ({0}*FP2MUL[{3}])-1 < {1}_mem{2}*FP2MUL_mem{2}[{3}]\n".format(operand, value, i, j))
                    else:
                        f_write.write("\t{0} += FP2MUL_mem{2}[{1}]\n".format(mem_value_name, pre_resource_num0, i))
                        f_write.write("\tS += {1} < {0}\n".format(mem_value_name, pre_end_time0 - 1))
                    f_write.write("\t{0}[0] += {0}[1]*FP2MUL_mem{1}\n".format(mem_value_name, i))
                if opcode == "CONSTMUL":
                    if pre_resource0 is None:
                        f_write.write("\t{0} += alt(CONSTMUL_mem)\n".format(mem_value_name, i))
                        for j in range(CONSTnum):
                            f_write.write("\tS += ({0}*CONSTMUL[{3}])-1 < {1}_mem{2}*CONSTMUL_mem[{3}]\n".format(operand, value, i, j))
                    else:
                        f_write.write("\t{0} += CONSTMUL_mem[{1}]\n".format(mem_value_name, pre_resource_num0, i))
                        f_write.write("\tS += {1} < {0}\n".format(mem_value_name, pre_end_time0 - 1))
                    f_write.write("\t{0}[0] += {0}[1]*CONSTMUL_mem\n".format(mem_value_name))
                elif opcode == "ADD" or opcode == "SUB":
                    if pre_resource0 is None:
                        f_write.write("\t{0}[0] += alt(ADD_mem)\n".format(mem_value_name))
                        for j in range((ADDnum+1)//2):
                            f_write.write("\tS += ({0}0*ADD[{3}])-1 < {1}_mem{2}[0]*ADD_mem[{3}]\n".format(operand, value, i, 2*j))
                    else:
                        # print(mem_value_name)
                        f_write.write("\t{0}[0] += ADD_mem[{1}]\n".format(mem_value_name, pre_resource_num0))
                        f_write.write("\tS += {1} < {0}[0]\n".format(mem_value_name, pre_end_time0 - 1))
                    if pre_resource1 is None:
                        f_write.write("\t{0}[1] += alt(ADD_mem)\n".format(mem_value_name))
                        for j in range(ADDnum//2):
                            f_write.write("\tS += ({0}1*ADD[{3}])-1 < {1}_mem{2}[1]*ADD_mem[{3}]\n".format(operand, value, i, 2*j+1))
                    else:
                        f_write.write("\t{0}[1] += ADD_mem[{1}]\n".format(mem_value_name, pre_resource_num1))
                        f_write.write("\tS += {1} < {0}[1]\n".format(mem_value_name, pre_end_time1 - 1))
                    # f_write.write("\t{0}[0] += {0}[1]*ADD_mem\n".format(mem_value_name))
        
    
        elif current_formula[1] == "ADD" or current_formula[1] == "SUB" or current_formula[1] == "INV":
            operand_num = operand[-1]
            if operand_num not in ["0","1"]:
                operand_num = i
            if operand in input_value:
                f_write.write("\t{0} = S.Task('{0}', length=1, delay_cost=1)\n".format(mem_value_name))
                f_write.write("\t{0} += INPUT_mem_r{1}\n".format(mem_value_name, operand_num))
            else:
                prev_formula = find_prev_formula(formulas, operand)
                if prev_formula is None:
                    prev_formula = find_prev_formula(formulas, operand[:-1])
                    pre_resource, pre_resource_num, pre_end_time = find_prev_resource(pre_sche_result, operand[:-1])
                else:
                    pre_resource, pre_resource_num, pre_end_time = find_prev_resource(pre_sche_result, operand)
                if prev_formula is None:
                    raise Exception("can't find previous formula")
                opcode = prev_formula[1]
                operand_num = operand[-1] # Fp2の成分の取得のために必要
                if opcode == "INV":
                    f_write.write("\tS += {0} < {1}\n".format(operand, value))
                    continue
                f_write.write("\t{0} = S.Task('{0}', length=1, delay_cost=1)\n".format(mem_value_name))
                if opcode == "FP2MUL":
                    if pre_resource is None:
                        f_write.write("\t{0} += alt(FP2MUL_mem{1})\n".format(mem_value_name, operand_num))
                        for j in range(MULnum):
                            f_write.write("\tS += ({0}*FP2MUL[{3}])-1 < {1}_mem{2}*FP2MUL_mem{4}[{3}]\n".format(operand[:-1], value, i, j, operand_num))
                    else:
                        f_write.write("\t{0} += FP2MUL_mem{2}[{1}]\n".format(mem_value_name, pre_resource_num, operand_num))
                        f_write.write("\tS += {1} < {0}\n".format(mem_value_name, pre_end_time - 1))
                    # f_write.write("\t{0}[0] += {0}[1]*FP2MUL_mem{1}\n".format(mem_value_name, operand_num))
                elif opcode == "CONSTMUL":
                    if pre_resource is None:
                        f_write.write("\t{0} += alt(CONSTMUL_mem)\n".format(mem_value_name))
                        for j in range(CONSTnum):
                            f_write.write("\tS += ({0}*CONSTMUL[{3}])-1 < {1}_mem{2}*CONSTMUL_mem[{3}]\n".format(operand[:-1], value, i, j))
                    else:
                        f_write.write("\t{0} += CONSTMUL_mem[{1}]\n".format(mem_value_name, pre_resource_num))
                        f_write.write("\tS += {1} < {0}\n".format(mem_value_name, pre_end_time - 1))
                    # f_write.write("\t{0}[0] += {0}[1]*CONSTMUL_mem\n".format(mem_value_name))
                elif opcode == "ADD" or opcode == "SUB":
                    if pre_resource is None:
                        f_write.write("\t{0} += alt(ADD_mem)\n".format(mem_value_name))
                        if operand[-1] == "0":
                            for j in range((ADDnum+1)//2):
                                f_write.write("\tS += ({0}*ADD[{3}])-1 < {1}_mem{2}*ADD_mem[{3}]\n".format(operand, value, i, 2*j))
                        elif operand[-1] == "1":
                            for j in range((ADDnum)//2):
                                f_write.write("\tS += ({0}*ADD[{3}])-1 < {1}_mem{2}*ADD_mem[{3}]\n".format(operand, value, i, 2*j+1))            
                        else:
                            for j in range(ADDnum):
                                f_write.write("\tS += ({0}*ADD[{3}])-1 < {1}_mem{2}*ADD_mem[{3}]\n".format(operand, value, i, j))  
                    else:
                        f_write.write("\t{0} += ADD_mem[{1}]\n".format(mem_value_name, pre_resource_num))
                        f_write.write("\tS += {1} < {0}\n".format(mem_value_name, pre_end_time - 1))

        f_write.write("\tS += {1} <= {0}\n\n".format(value, mem_value_name))
        mem_table[mem_value_name] = operand


def find_mistake(formulas, mem_table_list, output_value, split_ope, depth, pre_sche_result):
    mistaken_formulas = []
    for formula in split_ope[depth]:
        is_exist = False
        sub_value_results = []
        task = formula[0]
        sub_values = {key: False for key, value in mem_table_list[depth].items() if task in key}
        if task in output_value:
            sub_values["{}_w".format(task)] = False
        elif task+"0" in output_value:
            sub_values["{}0_w".format(task)] = False
            sub_values["{}1_w".format(task)] = False
        if formula[1] == "FP2MUL":
            sub_values["{}_in".format(task)] = False

        for sol in pre_sche_result:
            if task == sol[0]:
                is_exist = True
                task_result = sol
            elif sol[0] in sub_values.keys():
                sub_values[sol[0]] = True
                sub_value_results.append(sol)
            elif sol[0][:-1] in sub_values.keys():#######
                sub_values[sol[0][:-1]] = True
                sub_value_results.append(sol)
        if not is_exist:
            for sub_value_result in sub_value_results:
                pre_sche_result.remove(sub_value_result)
            min_finish_time, max_finish_time = find_next_formula(task, formulas, pre_sche_result)
            mistaken_formulas.append(formula + [min_finish_time])
        elif False in sub_values.values():
            pre_sche_result.remove(task_result)
            for sub_value_result in sub_value_results:
                pre_sche_result.remove(sub_value_result)
            min_finish_time, max_finish_time = find_next_formula(task, formulas, pre_sche_result)
            mistaken_formulas.append(formula + [min_finish_time])
    print(mistaken_formulas)
    if depth+1 >= len(split_ope):
        split_ope.append(mistaken_formulas)
    else:
        split_ope[depth+1] = mistaken_formulas + split_ope[depth+1]
    return pre_sche_result, split_ope


def make_pyschedule(
        dir_name,
        file_name,
        formulas,
        mem_table_list,
        split_ope,
        pre_sche_result,
        depth,
        input_value,
        output_value,
        knows,
        MULnum,
        CONSTnum,
        ADDnum,
        input_num):

    f_write = open("{}/{}.py".format(dir_name, file_name), "w")
    f_write.write("from pyschedule import Scenario, solvers, plotters, alt\n\n\n")
    f_write.write("def solve():\n")

    # mul_cycle = mul_num_list[depth]
    # add_cycle = (add_num_list[depth] // ADDnum)
    
    # mul_cycle = mul_num_list[depth]
    # add_cycle = (add_num_list[depth] // ADDnum)
    input_first = []
    for value in input_value:
        if value[-1] == "0" or value[-1] == "1":
            input_first.append(value[:-1])
        else:
            input_first.append(value)

    knows_tmp = []
    knows_tmp += knows
    pre_cycle = 0
    if pre_sche_result != []:
        pre_cycle = int(pre_sche_result[-1][3])
    f_write.write("\thorizon = {0}\n".format(max(pre_cycle + 90, input_num // 2 + 50)))

    f_write.write("\tS = Scenario(\"" + file_name + "\", horizon=horizon)\n")

    f_write.write("\n\t# resource\n")
    f_write.write("\tFP2MUL = S.Resources('FP2MUL', num={0}, size=9)\n".format(MULnum))
    f_write.write("\tFP2MUL_in = S.Resources('FP2MUL_in', num={0})\n".format(MULnum))
    f_write.write("\tCONSTMUL = S.Resources('CONSTMUL', num={0}, periods=range(1, horizon))\n".format(CONSTnum))
    f_write.write("\tINV = S.Resource('INV')\n")
    f_write.write("\tADD = S.Resources('ADD', num={0}, periods=range(1, horizon))\n".format(ADDnum))

    # 1write-2read RAM
    f_write.write("\tFP2MUL_mem0 = S.Resources('FP2MUL_mem0', num={0}, size=2)\n".format(MULnum)) #2r1w * 2
    f_write.write("\tFP2MUL_mem1 = S.Resources('FP2MUL_mem1', num={0}, size=2)\n".format(MULnum))
    f_write.write("\tADD_mem = S.Resources('ADD_mem', num={0}, size=2)\n".format(ADDnum))
    f_write.write("\tINPUT_mem_w0 = S.Resources('INPUT_mem_w0', size=2)\n")
    f_write.write("\tINPUT_mem_w1 = S.Resources('INPUT_mem_w1', size=2)\n")
    f_write.write("\tINPUT_mem_r0 = S.Resources('INPUT_mem_r0', size=2)\n")
    f_write.write("\tINPUT_mem_r1 = S.Resources('INPUT_mem_r1', size=2)\n")
    # f_write.write("\tINPUT_mem_r = S.Resources('INPUT_mem_r', size=2)\n")
    # f_write.write("\tINPUT_mem_r = S.Resources('INPUT_mem_r', size=2)\n")

    # 2write-2read RAM
    f_write.write("\tCONSTMUL_mem = S.Resources('CONSTMUL_mem', num={0}, size=2)\n".format(CONSTnum)) #2r2w * 1

    # multi_resources = ["FP2MUL", "FP2MUL_in", "CONSTMUL", "ADD", "INPUT_mem_w", "INPUT_mem_r", "CONSTMUL_mem", "FP2MUL_mem0", "FP2MUL_mem1", "ADD_mem"]
    multi_resources = ["FP2MUL", "FP2MUL_in", "CONSTMUL", "ADD", "INPUT_mem_w0", "INPUT_mem_r0", "INPUT_mem_w1", "INPUT_mem_r1", "CONSTMUL_mem", "FP2MUL_mem0", "FP2MUL_mem1", "ADD_mem"]
    single_resources = ["INV"]

    f_write.write("\n\t# result of previous scheduling\n")

    for pre in pre_sche_result:
        task = pre[0]
        start_time = int(pre[2])
        end_time = int(pre[3])
        length = end_time - start_time
        f_write.write("\t{0} = S.Task('{0}', length={1}, delay_cost=1)\n".format(task, length))
        f_write.write("\tS += {0} >= {1}\n".format(task, start_time))
        # f_write.write("\tS += {0} <= {1}\n".format(task, end_time))
        if pre[1] in single_resources:
            f_write.write("\t{0} += {1}\n\n".format(task, pre[1]))
        else:
            resource = pre[1][:-1]
            resource_num = pre[1][-1]
            if resource[-1] in num_str and resource[:-5] != "FP2MUL" and resource[:5] != "INPUT":
                resource = pre[1][:-2]
                resource_num = pre[1][-2:] 
            f_write.write("\t{0} += {1}[{2}]\n\n".format(task, resource, resource_num))

    f_write.write("\n\t#############\n\t# new tasks #\n\t#############\n\n")
    tmp_mem_table = {}
    for line in split_ope[depth]:
        if line[1] == "FP2MUL":
            knows_tmp.append(line[0])
            f_write.write("\t{0}_in = S.Task('{0}_in', length=1, delay_cost=1)\n".format(line[0]))
            f_write.write("\t" + line[0] + "_in += alt(FP2MUL_in)\n")
            f_write.write("\t{0} = S.Task('{0}', length=9, delay_cost=1)\n".format(line[0]))
            f_write.write("\t" + line[0] + " += alt(FP2MUL)\n")
            f_write.write("\tS += {0} >= {0}_in\n\n".format(line[0]))
        elif line[1] == "CONSTMUL":
            knows_tmp.append(line[0])
            f_write.write("\t{0} = S.Task('{0}', length=1, delay_cost=1)\n".format(line[0]))
            f_write.write("\t" + line[0] + " += alt(CONSTMUL)\n\n")
        elif line[1] == "ADD" or line[1] == "SUB":
            f_write.write("\t{0} = S.Task('{0}', length=1, delay_cost=1)\n".format(line[0]))
            add_assign = " += "
            if line[0][-1] == "0" or ADDnum == 1:
                add_assign += "ADD[{0}]".format("0")
                for i in range((ADDnum+1)//2 -1):
                    add_assign += " | ADD[{0}]".format(2*i+2)
            elif line[0][-1] == "1":
                add_assign += "ADD[{0}]".format("1")
                for i in range((ADDnum)//2 -1):
                    add_assign += " | ADD[{0}]".format(2*i+3)
            else:
                add_assign += "alt(ADD)"
            f_write.write("\t" + line[0] + add_assign +"\n\n")
        elif line[1] == "INV":
            knows_tmp.append(line[0])
            f_write.write("\t{0} = S.Task('{0}', length=1, delay_cost=1)\n".format(line[0]))
            f_write.write("\t" + line[0] + " += alt(INV)\n\n")
        else:
            raise Exception("ERROR: invalid operand: " + line[1])
        if line[0] in output_value:
            if "new_" in line[0]:
                min_finish_time, max_finish_time = find_next_formula(line[0][4:], formulas, pre_sche_result)
            else:
                min_finish_time_1, max_finish_time_1 = find_next_formula("a{}".format(line[0][1:]), formulas, pre_sche_result)
                min_finish_time_2, max_finish_time_2 = find_next_formula("b{}".format(line[0][1:]), formulas, pre_sche_result)
                max_finish_time = max(max_finish_time_1, max_finish_time_2)
            f_write.write("\tS += {} < {}\n\n".format(max_finish_time, line[0]))
        if len(line) >= 5:
            f_write.write("\tS += {} < {}\n\n".format(line[0], line[-1]))
        make_mem_task_definition(f_write, input_value, pre_sche_result, formulas, tmp_mem_table, line, MULnum, CONSTnum, ADDnum)
        if line[0] in output_value:
            num = line[0][-1]
            f_write.write("\t{0}_w = S.Task('{0}_w', length=1, delay_cost=1)\n".format(line[0]))
            f_write.write("\t{0}_w += alt(INPUT_mem_w{1})\n".format(line[0], num))
            f_write.write("\tS += {0}-1 <= {0}_w\n\n".format(line[0]))
        elif line[0] + "0" in output_value:
            f_write.write("\t{0}0_w = S.Task('{0}0_w', length=1, delay_cost=1)\n".format(line[0]))
            f_write.write("\t{0}0_w += alt(INPUT_mem_w0)\n".format(line[0]))
            f_write.write("\tS += {0}-1 <= {0}0_w\n\n".format(line[0]))
            f_write.write("\t{0}1_w = S.Task('{0}1_w', length=1, delay_cost=1)\n".format(line[0]))
            f_write.write("\t{0}1_w += alt(INPUT_mem_w1)\n".format(line[0]))
            f_write.write("\tS += {0}-1 <= {0}1_w\n\n".format(line[0]))
    mem_table_list.append(tmp_mem_table)
    # print(mem_table_list)

    f_write.write("\tsolvers.mip.solve(S,msg=1,kind='CPLEX',ratio_gap=1.01)\n\n")
    f_write.write("\tsolution = [['hoge']*len(S.solution()[1]) for i in range(len(S.solution()))]\n")
    f_write.write("\tfor i in range(len(S.solution())):\n\t\tfor j in range(len(S.solution()[i])):\n\t\t\tsolution[i][j]=str(S.solution()[i][j])\n")
    f_write.write("\tprint(solution)\n\n")
    f_write.write("\tcycles = int(solution[-1][3])\n\n")

    # TODO: pic_file_nameの変更
    f_write.write("\tpic_file_name = \"{}/{}.png\"\n".format(dir_name, file_name))
    f_write.write("\tif(S.solution() != []):\n\t\tplotters.matplotlib.plot(S,img_filename=pic_file_name, vertical_text=True, fig_size=(cycles*0.25+3, 5), show_task_labels=False)\n\n")
    f_write.write("\treturn solution\n\n")

    f_write.write("if __name__ == \"__main__\":\n")
    f_write.write("\tsolution = solve()\n\n")
    return knows_tmp


if __name__ == "__main__":
    start_time = time.perf_counter()
    psr = argparse.ArgumentParser(
        usage='schedule.py -c <curve_group> -p <p[bit]>',
        description='Execute scheduling with a 7-stage pipelined Fp montgomery multiplier, four Fp adders/subtractors, an Fp inversion operator'
    )
    psr.add_argument('-m', '--mul', default=1, help='number of Fp montgomery multipliers (default is 1)')
    psr.add_argument('-a', '--add', default=4, help='number of Fp adders/subtractors (default is 4)')
    psr.add_argument("-c", "--curve", required=True, help="curve group")
    psr.add_argument("-p", "--characteristic", required=True, help="bit width of characteristic number p")
    psr.add_argument('-n', '--name', required=True, help='スケジューリング対象の名前')
    args = psr.parse_args()

    mul_num = int(args.mul)
    add_num = int(args.add)
    const_num = 1
    curve_group = args.curve
    curve_name = args.characteristic
    algo_name = args.name

    func_name = "{2}_mul{0}_add{1}".format(mul_num, add_num, algo_name)
    formulas, add_formula_num, mul_formula_num = read_formula_csv(
        "/home/kashiwabara/Pairing/pairing_automation_design/{}-{}/csv/{}.csv".format(curve_group, curve_name, algo_name)
    )

    # exec(open("./" + "sche_test.py", 'r', encoding="utf-8").read())
    file_name = func_name

    # スケジューリングの解を保存するリスト
    solution = []
    # 分割したfomulas
    split_ope, input_value, output_value, input_num = make_split_scheduling(formulas)
    split_ope.append([])
    os.makedirs(file_name, exist_ok=True)
    mem_table = {}

    knows = []
    for value in input_value:
        if value[-1] == "0" or value[-1] == "1":
            knows.append(value[:-1])
        else:
            knows.append(value)
    for i in range(len(split_ope)):
        print(i, len(split_ope[i]), split_ope[i])

    pre_sche_result = solution

    for i in range(len(split_ope)):
        # pre_sche_result, split_ope = find_mistake(split_ope, i, pre_sche_result)
        if len(split_ope[i]) == 0:
            continue
        write_file = "{0}/{0}_{1}.py".format(file_name, i)
        make_pyschedule(
            file_name,
            formulas,
            mem_table,
            split_ope,
            pre_sche_result,
            i,
            write_file,
            input_value,
            output_value,
            knows,
            mul_num,
            const_num,
            add_num,
            input_num)
        print(i)
        # print(split_ope[i])
        # make_pyschedule(file_name, formulas, mem_table, split_ope, pre_sche_result, i, write_file, input_value, mul_num, add_num, mul_num_list, add_num_list, input_num)
        exec(open(write_file).read())
        if solution == []:
            raise Exception("no solution found in schedule_{0}".format(i))
        pre_sche_result = solution

    end_time = time.perf_counter()

    f = open(file_name + ".txt", "w")
    print("input = ", file=f, end="")
    print(input_value, file=f)
    print("output = ", file=f, end="")
    print(output_value, file=f)
    print("solution = ", file=f, end="")
    print(solution, file=f)
    print("formulas = ", file=f, end="")
    print(formulas, file=f)
    print("mem_table = ", file=f, end="")
    print(mem_table, file=f)
    print("time = ", end_time - start_time)

    for filename in os.listdir("./"):
        if filename.endswith(".log") and "clone" in filename:
            file_path = os.path.join("./", filename)
            os.remove(file_path)
    if os.path.exists("./Integer_Program-pulp.lp"):
        os.remove("./Integer_Program-pulp.lp")
    if os.path.exists("./Integer_Program-pulp.sol"):
        os.remove("./Integer_Program-pulp.sol")
