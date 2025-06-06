from lib.fpx import Fp_t
from lib.util import bits_of


def ep_add(Fp: Fp_t, P1, P2):
    x1 = P1[0]
    y1 = P1[1]
    x2 = P2[0]
    y2 = P2[1]
    dy = Fp.sub(y1, y2)
    dx = Fp.sub(x1, x2)
    dx_inv = Fp.inv(dx)
    la = Fp.mul(dy, dx_inv)
    xtQX = Fp.add(x1, x2)
    la2 = Fp.mul(la, la)
    new_TX = Fp.sub(la2, xtQX)
    xtnewxt = Fp.sub(x1, new_TX)
    laxtnewxt = Fp.mul(la, xtnewxt)
    new_TY = Fp.sub(laxtnewxt, y1)
    return [new_TX, new_TY]


# y^2 = x^3 + B の時
def ep_dbl(Fp: Fp_t, P1):
    x1 = P1[0]
    y1 = P1[1]
    t0 = Fp.mul(x1, x1)
    t1 = Fp.add(t0, t0)
    t1 = Fp.add(t1, t0)
    t2 = Fp.add(y1, y1)
    t2_inv = Fp.inv(t2)
    la = Fp.mul(t1, t2_inv)
    t3 = Fp.add(x1, x1)
    t4 = Fp.mul(la, la)
    new_TX = Fp.sub(t4, t3)
    xtnewxt = Fp.sub(x1, new_TX)
    laxtnewxt = Fp.mul(la, xtnewxt)
    new_TY = Fp.sub(laxtnewxt, y1)
    return [new_TX, new_TY]


def scalar_mul(Fp: Fp_t, n, P):
    res = P
    for nb in bits_of(n)[1:]:
        res = ep_dbl(Fp, res)
        if nb == 1:
            res = ep_add(Fp, res, P)
    return res
