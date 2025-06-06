import os
import copy
import sys
import argparse
import traceback

def count_operator(formulas):
    result = {}
    for formula in formulas:
        if formula[1] in result:
            result[formula[1]] += 1
        else:
            result[formula[1]] = 1 
    return result


def check_constmode_one(formulas):
    num = 0
    for formula in formulas:
        if formula[1] == "CONSTMUL" and formula[3] == "MODEONE":
            num += 1
    return num

def write_dict(diction):
    write_str = ""
    for key, value in diction.items():
        write_str += "{key}: {value}, ".format(key=key,value=value)
    write_str += "\n"
    return write_str


if __name__ == "__main__":
    input = []
    output = []
    solution = [[]]
    formulas = [[]]
    mem_table = {}

    state_sizes = {}

    psr = argparse.ArgumentParser(
        usage='schedule.py -c <curve_group> -p <p[bit]>',
        description='Generate RTLs of sequencer based on scheduling results'
    )
    psr.add_argument("-c", "--curve", required=True, help="curve group")
    psr.add_argument("-p", "--characteristic", required=True, help="bit width of characteristic number p")
    args = psr.parse_args()
    curve_group = args.curve
    curve_name = args.characteristic

    home_dir = os.path.dirname(os.getcwd().replace("\\", "/"))
    target_dir = "{}/{}-{}".format(home_dir, curve_group, curve_name)
    sequence_file_path = "{}/{}-{}_count_operator.txt".format(target_dir, curve_group, curve_name)
    f = open(sequence_file_path, "w")
    all_result = {}
    for root, dirs, files in os.walk("{}/scheduling/result".format(target_dir)):
        for file in files:
            if file[-4:] != ".txt":
                continue
            # if file[:3] != "INV":
            #     continue
            result_file_path = os.path.join(root, file)
            mem_table = {}
            print(file[:-4])
            # read scheduling result file
            exec(open(result_file_path, 'r', encoding="utf-8").read())
            result = count_operator(formulas)
            print(result)
            f.write(write_dict(result))
            num = check_constmode_one(formulas)
            print("CONSTMUL_MODEONE:{}".format(num))
            f.write("CONSTMUL_MODEONE:{}\n".format(num))
            print
            for key, operator in result.items():
                if key in all_result:
                    all_result[key] += result[key]
                else:
                    all_result[key] = result[key]
    f.write(write_dict(all_result))
    f.close()

    # calc_state_size = max(state_sizes.values()).bit_length()
    # calc_param_file = "{}/RTL/include/CalcCore_param.vh".format(target_dir)
    # f = open(calc_param_file, 'a')
    # f.write("`define CALC_STATE_SIZE " + str(calc_state_size) + "\n")
    # for key, value in state_sizes.items():
    #     f.write("`define CALC_" + key.upper() + "_STATE_SIZE `CALC_STATE_SIZE'd" + str(value) + "\n")
    # f.close()
