import copy, re
# 大規模スケジューリングの分割


def split_list(lst, division_num):

    return [lst[i:i + division_num] for i in range(0, len(lst), division_num)]


def make_split_scheduling(formulas, is_bls24):
    inputs = []
    outputs = []
    input_num = 0
    d = []
    for s in formulas:
        if s[1] == "FP2MUL":
            d.append(s[0] + "0")
            d.append(s[0] + "1")
            outputs.append(s[0] + "0")
            outputs.append(s[0] + "1")
            if (s[2] + "0") in inputs:
                input_num += 1
            elif (s[2] + "0") not in d:
                inputs.append(s[2] + "0")
                inputs.append(s[2] + "1")
                input_num += 1
            if (s[3] + "0") in inputs:
                input_num += 1
            elif (s[3] + "0") not in d:
                inputs.append(s[3] + "0")
                inputs.append(s[3] + "1")
                input_num += 1
            if ((s[2] + "0") in outputs) and (re.fullmatch(r"c[0-2]*", s[2] + "0") is None):
                outputs.remove(s[2] + "0")
                outputs.remove(s[2] + "1")
            if ((s[3] + "0") in outputs) and (re.fullmatch(r"c[0-2]*", s[3] + "1") is None):
                outputs.remove(s[3] + "0")
                outputs.remove(s[3] + "1")
        elif s[1] == "CONSTMUL":
            d.append(s[0] + "0")
            d.append(s[0] + "1")
            outputs.append(s[0] + "0")
            outputs.append(s[0] + "1")
            if (s[2] + "0") in inputs:
                input_num += 1
            elif (s[2] + "0") not in d:
                inputs.append(s[2] + "0")
                inputs.append(s[2] + "1")
                input_num += 1
            if s[3] in inputs:
                input_num += 1
            elif s[3] not in d:
                inputs.append(s[3])
                input_num += 1
            if ((s[2] + "0") in outputs) and (re.fullmatch(r"c[0-2]*", s[2] + "0") is None):
                outputs.remove(s[2] + "0")
                outputs.remove(s[2] + "1")
            if (s[3] in outputs) and (re.fullmatch(r"c[0-2]*", s[3]) is None):
                outputs.remove(s[3])
        elif s[1] == "INV":
            d.append(s[0] + "0")
            d.append(s[0] + "1")
            outputs.append(s[0] + "0")
            outputs.append(s[0] + "1")
            outputs.remove(s[2][:-1] + "1")
            if s[2] in inputs:
                input_num += 1
            elif s[2] not in d:
                inputs.append(s[2])
                input_num += 1
            if s[3] in inputs:
                input_num += 1
            elif s[3] not in d:
                inputs.append(s[3])
                input_num += 1
            if (s[2] in outputs) and (re.fullmatch(r"c[0-2]*", s[2]) is None):
                outputs.remove(s[2])
            if (s[3] in outputs) and (re.fullmatch(r"c[0-2]*", s[3]) is None):
                outputs.remove(s[3])
        else:
            d.append(s[0])
            outputs.append(s[0])
            if s[2] in inputs:
                input_num += 1
            elif s[2] not in d:
                inputs.append(s[2])
                input_num += 1
            if s[3] in inputs:
                input_num += 1
            elif s[3] not in d:
                inputs.append(s[3])
                input_num += 1
            if (s[2] in outputs) and (re.fullmatch(r"c[0-2]*", s[2]) is None):
                outputs.remove(s[2])
            if (s[3] in outputs) and (re.fullmatch(r"c[0-2]*", s[3]) is None):
                outputs.remove(s[3])
    input_first = copy.deepcopy(inputs)
    knows = inputs
    alls = []
    alls += inputs
    for s in formulas:
        if s[1] == "FP2MUL" or s[1] == "CONSTMUL" or s[1] == "INV":
            alls.append(s[0] + "0")
            alls.append(s[0] + "1")
        else:
            alls.append(s[0])
    cnt = 0
    split_ope = [[] for i in range(0, 100)]
    split_index = 0
    DIVIDE_NUM = 70  # RAMの読み出しのスケジューリングに時間がかかるので1番目だけ30, 後は70
    if is_bls24 == True:
        DIVIDE_NUM = 30
    add_num = 0
    mul_num = 0
    const_num = 0
    output_formulas = []
    while (set(knows) != set(alls)):
        # print("knows:", knows)
        # print("alls:", alls)
        # print("split_index:", split_index)
        knows_tmp = []
        split_tmp = []
        for s in formulas:
            # しっかり文字を指定しないとinで判定してくれない
            # 定数にも条件分岐が必要
            if s[1] == "FP2MUL":
                if (s[2] + "0" in knows) and (s[2] + "1" in knows) \
                    and (((s[3] + "0" in knows) and (s[3] + "1" in knows)) or (s[3] in knows)):
                    if (s[0] + "0" not in knows) and  (s[0] + "1" not in knows):
                        knows_tmp.append(s[0] + "0")
                        knows_tmp.append(s[0] + "1")
                        split_tmp.append(s)
                        mul_num += 1
            elif s[1] == "CONSTMUL":
                if (s[2] + "0" in knows) and (s[2] + "1" in knows):
                    if (s[0] + "0" not in knows) and  (s[0] + "1" not in knows):
                        knows_tmp.append(s[0] + "0")
                        knows_tmp.append(s[0] + "1")
                        split_tmp.append(s)
                        const_num += 1
            elif s[1] == "INV":
                if (s[2] in knows) and (s[3] in knows):
                    if (s[0] + "0" not in knows) and  (s[0] + "1" not in knows):
                            knows_tmp.append(s[0] + "0")
                            knows_tmp.append(s[0] + "1")
                            split_tmp.append(s)
            else:
                if (s[2] in knows) and (s[3] in knows):
                    if (s[0] not in knows):
                        knows_tmp.append(s[0])
                        split_tmp.append(s)
                        add_num += 1

        if len(split_ope[split_index]) + len(split_tmp) > DIVIDE_NUM:
            divided_split_tmp = split_list(split_tmp, DIVIDE_NUM)
            for i in range(len(divided_split_tmp)):
                if len(split_ope[split_index]) != 0:
                    split_index += 1
                split_ope[split_index] += divided_split_tmp[i]
        else:
            split_ope[split_index] += split_tmp
        if cnt == 0:
            DIVIDE_NUM = 70
            split_index += 1

        knows += knows_tmp
        cnt += 1
    if (set(knows) != set(alls)):
        print("ng:split scheduling")
        exit()
    # split_ope内の[]を取り除く、冗長?
    split_ope_c = []
    for s in split_ope:
        if s != []:
            split_ope_c.append(s)
    return split_ope_c, input_first, outputs, input_num
