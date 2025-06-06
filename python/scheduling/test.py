import importlib
import sys
import os


sys.path.append("..")
a = os.getcwd().replace("\\", "/")
b = os.path.dirname(__file__)
c = os.path.dirname(b)
print(a)
print(b)
print(c)
# scheduling_i = importlib.import_module("bls12-381.scheduling.SQR_mul1_add4.SQR_0", package=None)

# solution = scheduling_i.solve()