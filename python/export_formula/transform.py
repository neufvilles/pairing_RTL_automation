from lib.util import FormulaSet


class TransformElement:
    def __init__(self, value: str, isMinus: bool) -> None:
        self.value = value
        self.isMinus = isMinus
        self.isUsed = False


class FormulaOrganizer:
    def __init__(self) -> None:
        self.transformList: dict[str, TransformElement] = {}

    def find_transform_element(self, value):
        try:
            element = self.transformList[value]
            self.transformList[value].isUsed = True
        except KeyError:
            element = TransformElement(
                value, isMinus=False)
        return element

    def set_transform_element(self, key, value, isMinus=False):
        element = self.find_transform_element(value)
        self.transformList[key] = TransformElement(
            value, isMinus=(element.isMinus) ^ isMinus)

    def transform_formula(self, formula: FormulaSet):
        opr1_element = self.find_transform_element(formula.opr1)
        opr2_element = self.find_transform_element(formula.opr2)

        if opr1_element.isMinus and (not opr2_element.isMinus):
            if formula.type == "ADD":
                return FormulaSet(
                    opr1=opr2_element.value,
                    opr2=opr1_element.value,
                    ret=formula.ret,
                    type="SUB")
            self.set_transform_element(formula.ret, formula.ret, isMinus=True)
            if formula.type == "SUB":
                return FormulaSet(
                    opr1=opr1_element.value,
                    opr2=opr2_element.value,
                    ret=formula.ret,
                    type="ADD")
            return FormulaSet(
                opr1=opr1_element.value,
                opr2=opr2_element.value,
                ret=formula.ret,
                type=formula.type)

        if (not opr1_element.isMinus) and opr2_element.isMinus:
            if formula.type == "ADD":
                return FormulaSet(
                    opr1=opr1_element.value,
                    opr2=opr2_element.value,
                    ret=formula.ret,
                    type="SUB")
            if formula.type == "SUB":
                return FormulaSet(
                    opr1=opr1_element.value,
                    opr2=opr2_element.value,
                    ret=formula.ret,
                    type="ADD")
            self.set_transform_element(formula.ret, formula.ret, isMinus=True)
            return FormulaSet(
                opr1=opr1_element.value,
                opr2=opr2_element.value,
                ret=formula.ret,
                type=formula.type)

        if opr1_element.isMinus and opr2_element.isMinus:
            if formula.type == "ADD" or formula.type == "SUB":
                self.set_transform_element(
                    formula.ret, formula.ret, isMinus=True)
                return FormulaSet(
                    opr1=opr1_element.value,
                    opr2=opr2_element.value,
                    ret=formula.ret,
                    type=formula.type)
        return FormulaSet(
            opr1=opr1_element.value,
            opr2=opr2_element.value,
            ret=formula.ret,
            type=formula.type
        )


    def remove_extra_formula(self, formulaList: list[FormulaSet]):
        resultList = []
        for formula in formulaList:
            if "ZERO" in formula.opr1:
                resultList.append(FormulaSet(opr1="ZERO", opr2=formula.opr2, ret=formula.ret, type=formula.type))
                continue
            if "ZERO" in formula.opr2:
                resultList.append(FormulaSet(opr1=formula.opr1, opr2="ZERO", ret=formula.ret, type=formula.type))
                continue
            resultList.append(self.transform_formula(formula))
        # for key, transform in self.transformList.items():
        #     print("original: {}, value: {}, isMinus: {}, isUsed: {}".format(key, transform.value, transform.isMinus, transform.isUsed))
        return resultList



    # def remove_extra_formula(self, formulaList: list[FormulaSet]):
    #     resultList = []
    #     for formula in formulaList:
    #         if "ZERO" in formula.opr1:
    #             # print(
    #             # "{},{},{},{}".format(
    #             #     formula.ret,
    #             #     formula.opr1,
    #             #     formula.opr2,
    #             #     formula.type))
    #             opr2_element = self.find_transform_element(formula.opr2)
    #             if formula.type == "ADD":
    #                 self.set_transform_element(formula.ret, opr2_element.value)
    #                 continue
    #             if formula.type == "SUB":
    #                 self.set_transform_element(
    #                     formula.ret, opr2_element.value, True)
    #                 continue
    #         if "ZERO" in formula.opr2:
    #             opr1_element = self.find_transform_element(formula.opr1)
    #             # print(
    #             # "{},{},{}".format(
    #             #     opr1_element.value,
    #             #     opr1_element.isMinus,
    #             #     opr1_element.isUsed))                
    #             self.set_transform_element(
    #                 formula.ret, opr1_element.value)
    #             continue
    #         resultList.append(self.transform_formula(formula))
    #     for key, element in self.transformList.items():
    #         if not element.isUsed:
    #             if element.isMinus:
    #                 resultList.append(FormulaSet(opr1="ZERO", opr2=element.value, ret=key, type="SUB"))
    #             else:
    #                 resultList.append(FormulaSet(opr1=element.value, opr2="ZERO", ret=key, type="ADD"))
    #     # for key, transform in self.transformList.items():
    #     #     print("original: {}, value: {}, isMinus: {}, isUsed: {}".format(key, transform.value, transform.isMinus, transform.isUsed))
    #     return resultList
