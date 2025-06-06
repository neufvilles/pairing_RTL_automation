# スケジューリングが失敗したときとかに使う


def reproduce_memtable(
        formulas,
        mem_table):
    for formula in formulas:
        operand0 = formula[2]
        operand1 = formula[3]
        mem_table["{0}_mem0".format(formula[0])] = operand0
        mem_table["{0}_mem1".format(formula[0])] = operand1
    return mem_table
    

