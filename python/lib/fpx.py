from lib.util import bits_of
import random


def u_int(U):
    res = 1
    u = 0
    for ui in U:
        u += res * ui
        res <<= 1
    return u


def px(u, curve_group):
    if curve_group == "bls12":
        return (((u - 1) ** 2) * (u**4 - u**2 + 1)) // 3 + u
    if curve_group == "bls24":
        return (((u - 1) ** 2) * (u**8 - u**4 + 1)) // 3 + u


class Fp_t:
    def __init__(self, p: int) -> None:
        self.p = p
        self.p_len = p.bit_length()
        self.L = 2**self.p_len
        self.montgomery_inv = pow(self.L, -1, self.p)

    def MontConvInv(self, a):
        c = (a * self.montgomery_inv) % self.p
        return c

    def MontConv(self, a):
        t = (a * self.L) % self.p
        return t

    def random_element(self):
        return random.randint(0, self.p - 1)

    def zero(self):
        return 0

    def one(self):
        return self.MontConv(1)

    def add(self, a, b):
        t0 = a + b
        t1 = a + b - self.p
        if t1 >= 0:
            out = t1
        else:
            out = t0
        return out

    def sub(self, a, b):
        t0 = a - b
        t1 = a - b + self.p
        if t0 >= 0:
            out = t0
        else:
            out = t1
        return out

    def neg(self, a):
        return self.sub(0, a)

    def constMulNotMont(self, a, k):  # モンゴメリ乗算じゃない
        if k == 0:
            return 0
        bits_k = bits_of(abs(k))
        tmp = a
        for i in range(1, len(bits_k)):
            tmp = self.add(tmp, tmp)
            if bits_k[i]:
                tmp = self.add(tmp, a)
        if k > 0:
            return tmp
        return self.neg(tmp)

    def guzai(self, a, fp2_qnr):
        return self.constMulNotMont(a, fp2_qnr)

    def mul(self, a, b):
        return (a * b % self.p) * self.montgomery_inv % self.p

    def inv(self, a):
        b = pow(a, self.p - 2, self.p)
        b = (b * self.L % self.p) * self.L % self.p
        return b

    def exp(self, a, x):
        r = a
        res = self.MontConv(1)
        while x > 0:
            if x & 1:
                res = self.mul(res, r)
            x >>= 1
            r = self.mul(r, r)
        return res


class Fp2_t:
    def __init__(self, Fp: Fp_t, qnr: int) -> None:
        self.Fp = Fp
        self.qnr = qnr

    def MontConvInv(self, a):
        return [self.Fp.MontConvInv(a[0]), self.Fp.MontConvInv(a[1])]

    def MontConv(self, a):
        return [self.Fp.MontConv(a[0]), self.Fp.MontConv(a[1])]

    def random_element(self):
        return [self.Fp.random_element(), self.Fp.random_element()]

    def zero(self):
        return [self.Fp.zero(), self.Fp.zero()]

    def one(self):
        return [self.Fp.one(), self.Fp.zero()]

    def add(self, a, b):
        new_r = self.Fp.add(a[0], b[0])
        new_i = self.Fp.add(a[1], b[1])
        return [new_r, new_i]

    def sub(self, a, b):
        new_r = self.Fp.sub(a[0], b[0])
        new_i = self.Fp.sub(a[1], b[1])
        return [new_r, new_i]

    def constMul(self, a, k):  # モンゴメリ乗算
        new_r = self.Fp.mul(a[0], k)
        new_i = self.Fp.mul(a[1], k)
        return [new_r, new_i]

    def constMulNotMont(self, a, k):  # モンゴメリ乗算
        new_r = self.Fp.constMulNotMont(a[0], k)
        new_i = self.Fp.constMulNotMont(a[1], k)
        return [new_r, new_i]

    def guzai(self, a, fp4_qnr):  # qnr = x + yi
        ax = self.constMulNotMont(a, fp4_qnr[0])
        ay = self.constMulNotMont(a, fp4_qnr[1])
        a1y_ = self.Fp.guzai(ay[1], self.qnr)
        new_r = self.Fp.add(ax[0], a1y_)
        new_i = self.Fp.add(ax[1], ay[0])
        return [new_r, new_i]

    def mul(self, a, b):
        t0 = self.Fp.mul(a[0], b[0])
        t1 = self.Fp.mul(a[1], b[1])
        t2 = self.Fp.add(a[0], a[1])
        t3 = self.Fp.add(b[0], b[1])
        t4 = self.Fp.mul(t2, t3)
        s0 = self.Fp.guzai(t1, self.qnr)
        c0 = self.Fp.add(t0, s0)
        t5 = self.Fp.add(t0, t1)
        c1 = self.Fp.sub(t4, t5)
        return [c0, c1]

    def sqr(self, a):
        a1_ = self.Fp.guzai(a[1], self.qnr)
        t0 = self.Fp.add(a[0], a1_)
        t1 = self.Fp.add(a[0], a[1])
        t2 = self.Fp.mul(t0, t1)
        t3 = self.Fp.mul(a[0], a[1])
        t4 = self.Fp.guzai(t3, self.qnr)
        t5 = self.Fp.add(t3, t4)
        c0 = self.Fp.sub(t2, t5)
        c1 = self.Fp.add(t3, t3)
        return [c0, c1]

    def conj(self, a):
        new_r = a[0]
        new_i = self.Fp.neg(a[1])
        return [new_r, new_i]

    def inv(self, a):  # Itoh-Tsujii Inversion
        a_ = self.conj(a)
        a02 = self.Fp.mul(a[0], a[0])
        a12 = self.Fp.mul(a[1], a[1])
        a12_ = self.Fp.guzai(a12, self.qnr)
        t = self.Fp.sub(a02, a12_)
        s = self.Fp.inv(t)
        ainv0 = self.Fp.mul(a_[0], s)
        ainv1 = self.Fp.mul(a_[1], s)
        return [ainv0, ainv1]

    def neg(self, a):
        return [self.Fp.neg(a[0]), self.Fp.neg(a[1])]

    def exp(self, f, u):
        r = f
        for ub in bits_of(u)[1:]:
            r = self.mul(r, r)
            if ub == 1:
                r = self.mul(r, f)
        if u < 0:
            r = self.inv(r)
        return r

    def frob(self, a):
        return self.conj(a)


class Fp4_t:
    def __init__(self, Fp2: Fp2_t, qnr: int) -> None:
        self.Fp = Fp2.Fp
        self.Fp2 = Fp2
        self.qnr = qnr
        self.k = Fp2.exp(Fp2.MontConv(qnr), (Fp2.Fp.p - 1) // 2)

    def MontConvInv(self, a):
        return [self.Fp2.MontConvInv(a[0]), self.Fp2.MontConvInv(a[1])]

    def MontConv(self, a):
        return [self.Fp2.MontConv(a[0]), self.Fp2.MontConv(a[1])]

    def random_element(self):
        return [self.Fp2.random_element(), self.Fp2.random_element()]

    def zero(self):
        return [self.Fp2.zero(), self.Fp2.zero()]

    def one(self):
        return [self.Fp2.one(), self.Fp2.zero()]

    def add(self, a, b):
        new_r = self.Fp2.add(a[0], b[0])
        new_i = self.Fp2.add(a[1], b[1])
        return [new_r, new_i]

    def sub(self, a, b):
        new_r = self.Fp2.sub(a[0], b[0])
        new_i = self.Fp2.sub(a[1], b[1])
        return [new_r, new_i]

    def constMul(self, a, k):  # モンゴメリ乗算
        new_r = self.Fp2.constMul(a[0], k)
        new_i = self.Fp2.constMul(a[1], k)
        return [new_r, new_i]

    def constMulNotMont(self, a, k):  # モンゴメリ乗算
        new_r = self.Fp2.constMulNotMont(a[0], k)
        new_i = self.Fp2.constMulNotMont(a[1], k)
        return [new_r, new_i]

    def guzai(self, a, fp12_cnr):  # v^2 = guzai = (x + 0i) + (y + 0i)v
        ax = self.constMulNotMont(a, fp12_cnr[0][0])
        ay = self.constMulNotMont(a, fp12_cnr[1][0])
        a1y_ = self.Fp2.guzai(ay[1], self.qnr)
        new_r = self.Fp2.add(ax[0], a1y_)
        new_i = self.Fp2.add(ax[1], ay[0])
        return [new_r, new_i]

    def mul(self, a, b):
        t0 = self.Fp2.mul(a[0], b[0])
        t1 = self.Fp2.mul(a[1], b[1])
        t2 = self.Fp2.add(a[0], a[1])
        t3 = self.Fp2.add(b[0], b[1])
        t4 = self.Fp2.mul(t2, t3)
        s0 = self.Fp2.guzai(t1, self.qnr)
        c0 = self.Fp2.add(t0, s0)
        t5 = self.Fp2.add(t0, t1)
        c1 = self.Fp2.sub(t4, t5)
        return [c0, c1]

    def sqr(self, a):
        a1_ = self.Fp2.guzai(a[1], self.qnr)
        t0 = self.Fp2.add(a[0], a1_)
        t1 = self.Fp2.add(a[0], a[1])
        t2 = self.Fp2.mul(t0, t1)
        t3 = self.Fp2.mul(a[0], a[1])
        t4 = self.Fp2.guzai(t3, self.qnr)
        t5 = self.Fp2.add(t3, t4)
        c0 = self.Fp2.sub(t2, t5)
        c1 = self.Fp2.add(t3, t3)
        return [c0, c1]

    def conj(self, a):
        return [a[0], self.Fp2.neg(a[1])]

    def inv(self, a):  # Itoh-Tsujii Inversion
        aa = self.Fp2.sqr(a[0])
        bb = self.Fp2.sqr(a[1])
        bbxi = self.Fp2.guzai(bb, self.qnr)
        denom = self.Fp2.sub(aa, bbxi)
        denom_inv = self.Fp2.inv(denom)
        c0 = self.Fp2.mul(a[0], denom_inv)
        c1 = self.Fp2.mul(a[1], denom_inv)
        c1_ = self.Fp2.neg(c1)
        return [c0, c1_]

    def neg(self, a):
        return [self.Fp2.neg(a[0]), self.Fp2.neg(a[1])]

    def exp(self, f, u):
        r = f
        for ub in bits_of(abs(u))[1:]:
            r = self.mul(r, r)
            if ub == 1:
                r = self.mul(r, f)
        if u < 0:
            r = self.inv(r)
        return r

    def frob(self, a):
        c0 = self.Fp2.conj(a[0])
        c1 = self.Fp2.mul(self.Fp2.conj(a[1]), self.k)
        return [c0, c1]


class Fp12_t:
    def __init__(self, Fp4: Fp4_t, cnr) -> None:
        self.Fp2 = Fp4.Fp2
        self.Fp4 = Fp4
        self.cnr = cnr
        self.k = [
            Fp4.Fp2.one(),
            Fp4.Fp2.exp(Fp4.Fp2.MontConv(Fp4.qnr), (Fp4.Fp2.Fp.p - 1) // 6),
            Fp4.Fp2.exp(Fp4.Fp2.MontConv(Fp4.qnr), 2 * (Fp4.Fp2.Fp.p - 1) // 6),
            Fp4.Fp2.exp(Fp4.Fp2.MontConv(Fp4.qnr), 3 * (Fp4.Fp2.Fp.p - 1) // 6),
            Fp4.Fp2.exp(Fp4.Fp2.MontConv(Fp4.qnr), 4 * (Fp4.Fp2.Fp.p - 1) // 6),
            Fp4.Fp2.exp(Fp4.Fp2.MontConv(Fp4.qnr), 5 * (Fp4.Fp2.Fp.p - 1) // 6),
        ]

    def MontConvInv(self, a):
        return [
            self.Fp4.MontConvInv(a[0]),
            self.Fp4.MontConvInv(a[1]),
            self.Fp4.MontConvInv(a[2]),
        ]

    def MontConv(self, a):
        return [
            self.Fp4.MontConv(a[0]),
            self.Fp4.MontConv(a[1]),
            self.Fp4.MontConv(a[2]),
        ]

    def random_element(self):
        return [
            self.Fp4.random_element(),
            self.Fp4.random_element(),
            self.Fp4.random_element(),
        ]

    def zero(self):
        return [self.Fp4.zero(), self.Fp4.zero(), self.Fp4.zero()]

    def one(self):
        return [self.Fp4.one(), self.Fp4.zero(), self.Fp4.zero()]

    def mapFromFq6(
        self, a
    ):  # a0 + a1w + a2w^2 + a3w^3 + a4w^4 + a5w^5 -> (a0 + a3v) + (a1 + a4v)w + (a2 + a5v)w^2
        return [[a[0], a[3]], [a[1], a[4]], [a[2], a[5]]]

    def mapToFq6(
        self, a
    ):  # (a00 + a01v) + (a10 + a11v)w + (a20 + a21v)w^2 -> a00 + a10w + a20w^2 + a01w^3 + a11w^4 + a21w^5
        return [a[0][0], a[1][0], a[2][0], a[0][1], a[1][1], a[2][1]]

    def add(self, a, b):
        c0 = self.Fp4.add(a[0], b[0])
        c1 = self.Fp4.add(a[1], b[1])
        c2 = self.Fp4.add(a[2], b[2])
        return [c0, c1, c2]

    def sub(self, a, b):
        c0 = self.Fp4.sub(a[0], b[0])
        c1 = self.Fp4.sub(a[1], b[1])
        c2 = self.Fp4.sub(a[2], b[2])
        return [c0, c1, c2]

    def constMul(self, a, k):  # モンゴメリ乗算
        a0 = self.Fp4.constMul(a[0], k)
        a1 = self.Fp4.constMul(a[1], k)
        a2 = self.Fp4.constMul(a[2], k)
        return [a0, a1, a2]

    def constMulNotMont(self, a, k):  # モンゴメリ乗算
        a0 = self.Fp4.constMulNotMont(a[0], k)
        a1 = self.Fp4.constMulNotMont(a[1], k)
        a2 = self.Fp4.constMulNotMont(a[2], k)
        return [a0, a1, a2]

    def guzai(self, a, fp24_qnr):  # v^2 = guzai = u
        return [self.Fp4.guzai(a[2], self.cnr), a[0], a[1]]

    def mul(self, a, b):
        t0 = self.Fp4.mul(a[0], b[0])
        t1 = self.Fp4.mul(a[1], b[1])
        t2 = self.Fp4.mul(a[2], b[2])
        t3 = self.Fp4.mul(self.Fp4.add(a[0], a[1]), self.Fp4.add(b[0], b[1]))
        t4 = self.Fp4.mul(self.Fp4.add(a[1], a[2]), self.Fp4.add(b[1], b[2]))
        t5 = self.Fp4.mul(self.Fp4.add(a[2], a[0]), self.Fp4.add(b[2], b[0]))
        t3 = self.Fp4.sub(t3, self.Fp4.add(t0, t1))
        t4 = self.Fp4.sub(t4, self.Fp4.add(t1, t2))
        t4 = self.Fp4.guzai(t4, self.cnr)
        c0 = self.Fp4.add(t0, t4)
        t5 = self.Fp4.sub(t5, self.Fp4.add(t2, t0))
        t2 = self.Fp4.guzai(t2, self.cnr)
        c1 = self.Fp4.add(t3, t2)
        c2 = self.Fp4.add(t1, t5)
        return [c0, c1, c2]

    def mul_conj(self, a, b):
        t0 = self.Fp4.mul(a[0], self.Fp4.conj(b[0]))
        t1 = self.Fp4.mul(a[1], self.Fp4.conj(b[1]))
        t2 = self.Fp4.mul(a[2], self.Fp4.conj(b[2]))
        t3 = self.Fp4.mul(self.Fp4.add(a[0], a[1]), self.Fp4.conj(self.Fp4.sub(b[0], b[1])))
        t4 = self.Fp4.mul(self.Fp4.add(a[1], a[2]), self.Fp4.conj(self.Fp4.sub(b[1], b[2])))
        t5 = self.Fp4.mul(self.Fp4.add(a[2], a[0]), self.Fp4.conj(self.Fp4.add(b[2], b[0])))
        t3 = self.Fp4.sub(t3, self.Fp4.sub(t0, t1))
        t4 = self.Fp4.sub(t4, self.Fp4.sub(t1, t2))
        t4 = self.Fp4.guzai(t4, self.cnr)
        c0 = self.Fp4.sub(t0, t4)
        t5 = self.Fp4.sub(t5, self.Fp4.add(t2, t0))
        t2 = self.Fp4.guzai(t2, self.cnr)
        c1 = self.Fp4.add(t3, t2)
        c2 = self.Fp4.sub(t5, t1)
        return [c0, c1, c2]

    def sqr(self, a):
        t0 = self.Fp4.sqr(a[0])
        t1 = self.Fp4.sqr(a[1])
        t2 = self.Fp4.sqr(a[2])
        t3 = self.Fp4.sqr(self.Fp4.add(a[0], a[1]))
        t4 = self.Fp4.sqr(self.Fp4.add(a[1], a[2]))
        t5 = self.Fp4.sqr(self.Fp4.add(a[2], a[0]))
        s0 = self.Fp4.sub(t3, self.Fp4.add(t0, t1))
        s1 = self.Fp4.sub(t4, self.Fp4.add(t1, t2))
        s2 = self.Fp4.sub(t5, self.Fp4.add(t2, t0))
        s1 = self.Fp4.guzai(s1, self.cnr)
        t2 = self.Fp4.guzai(t2, self.cnr)
        c0 = self.Fp4.add(t0, s1)
        c1 = self.Fp4.add(s0, t2)
        c2 = self.Fp4.add(t1, s2)
        return [c0, c1, c2]

    def conj(self, a):
        a01 = self.Fp2.neg(a[0][1])
        a10 = self.Fp2.neg(a[1][0])
        a21 = self.Fp2.neg(a[2][1])
        return [[a[0][0], a01], [a10, a[1][1]], [a[2][0], a21]]

    def inv(self, a):  # Itoh-Tsujii Inversion
        aa = self.Fp4.sqr(a[0])
        bb = self.Fp4.sqr(a[1])
        cc = self.Fp4.sqr(a[2])
        ab = self.Fp4.mul(a[0], a[1])
        bc = self.Fp4.mul(a[1], a[2])
        ac = self.Fp4.mul(a[2], a[0])
        bcxi = self.Fp4.guzai(bc, self.cnr)
        pa = self.Fp4.sub(aa, bcxi)
        ccxi = self.Fp4.guzai(cc, self.cnr)
        pb = self.Fp4.sub(ccxi, ab)
        pc = self.Fp4.sub(bb, ac)
        pbc = self.Fp4.mul(pb, a[2])
        pcb = self.Fp4.mul(pc, a[1])
        pbccb = self.Fp4.add(pbc, pcb)
        pxi = self.Fp4.guzai(pbccb, self.cnr)
        paa = self.Fp4.mul(pa, a[0])
        q = self.Fp4.add(pxi, paa)
        q_inv = self.Fp4.inv(q)
        ya = self.Fp4.mul(pa, q_inv)
        yb = self.Fp4.mul(pb, q_inv)
        yc = self.Fp4.mul(pc, q_inv)
        return [ya, yb, yc]

    def neg(self, a):
        return [self.Fp4.neg(a[0]), self.Fp4.neg(a[1]), self.Fp4.neg(a[2])]

    def exp(self, f, u):
        r = f
        for ub in bits_of(abs(u))[1:]:
            r = self.mul(r, r)
            if ub == 1:
                r = self.mul(r, f)
        if u < 0:
            r = self.inv(r)
        return r

    def frob(self, a):
        f10_c = self.Fp2.frob(a[1][0])
        f20_c = self.Fp2.frob(a[2][0])
        f01_c = self.Fp2.frob(a[0][1])
        f11_c = self.Fp2.frob(a[1][1])
        f21_c = self.Fp2.frob(a[2][1])
        f00 = self.Fp2.frob(a[0][0])
        f10 = self.Fp2.mul(f10_c, self.k[1])
        f20 = self.Fp2.mul(f20_c, self.k[2])
        f01 = self.Fp2.mul(f01_c, self.k[3])
        f11 = self.Fp2.mul(f11_c, self.k[4])
        f21 = self.Fp2.mul(f21_c, self.k[5])
        return [[f00, f01], [f10, f11], [f20, f21]]


class Fp24_t:
    def __init__(self, Fp12: Fp12_t, qnr) -> None:
        self.Fp4 = Fp12.Fp4
        self.Fp12 = Fp12
        self.qnr = qnr
        self.k = [
            Fp12.Fp4.one(),
            self.Fp12.Fp4.exp(
                Fp12.Fp4.MontConv(Fp12.cnr), (Fp12.Fp4.Fp2.Fp.p - 1) // 6
            ),
            self.Fp12.Fp4.exp(
                Fp12.Fp4.MontConv(Fp12.cnr), 2 * (Fp12.Fp4.Fp2.Fp.p - 1) // 6
            ),
            self.Fp12.Fp4.exp(
                Fp12.Fp4.MontConv(Fp12.cnr), 3 * (Fp12.Fp4.Fp2.Fp.p - 1) // 6
            ),
            self.Fp12.Fp4.exp(
                Fp12.Fp4.MontConv(Fp12.cnr), 4 * (Fp12.Fp4.Fp2.Fp.p - 1) // 6
            ),
            self.Fp12.Fp4.exp(
                Fp12.Fp4.MontConv(Fp12.cnr), 5 * (Fp12.Fp4.Fp2.Fp.p - 1) // 6
            ),
        ]

    def MontConvInv(self, a):
        return [self.Fp12.MontConvInv(a[0]), self.Fp12.MontConvInv(a[1])]

    def MontConv(self, a):
        return [self.Fp12.MontConv(a[0]), self.Fp12.MontConv(a[1])]

    def random_element(self):
        return [self.Fp12.random_element(), self.Fp12.random_element()]

    def zero(self):
        return [self.Fp12.zero(), self.Fp12.zero()]

    def one(self):
        return [self.Fp12.one(), self.Fp12.zero()]

    def mapFromFq6(
        self, a
    ):  # a0 + a1w + a2w^2 + a3w^3 + a4w^4 + a5w^5 -> (a0 + a2v + a4v^2) + (a1 + a3v + a5v^2)w
        return [[a[0], a[2], a[4]], [a[1], a[3], a[5]]]

    def mapToFq6(
        self, a
    ):  # (a00 + a01v + a02)v + (a10 + a11v + a12v)w -> a00 + a10w + a01w^2 + a11w^3 + a02w^4 + a12w^5
        return [a[0][0], a[1][0], a[0][1], a[1][1], a[0][2], a[1][2]]

    def add(self, a, b):
        new_r = self.Fp12.add(a[0], b[0])
        new_i = self.Fp12.add(a[1], b[1])
        return [new_r, new_i]

    def sub(self, a, b):
        new_r = self.Fp12.sub(a[0], b[0])
        new_i = self.Fp12.sub(a[1], b[1])
        return [new_r, new_i]

    def constMul(self, a, k):
        new_r = self.Fp12.constMul(a[0], k)
        new_i = self.Fp12.constMul(a[1], k)
        return [new_r, new_i]

    def constMulNotMont(self, a, k):
        new_r = self.Fp12.constMulNotMont(a[0], k)
        new_i = self.Fp12.constMulNotMont(a[1], k)
        return [new_r, new_i]

    def mul(self, a, b):
        t0 = self.Fp12.mul(a[0], b[0])
        t1 = self.Fp12.mul(a[1], b[1])
        t2 = self.Fp12.add(a[0], a[1])
        t3 = self.Fp12.add(b[0], b[1])
        t4 = self.Fp12.mul(t2, t3)
        s0 = self.Fp12.guzai(t1, self.qnr)
        c0 = self.Fp12.add(t0, s0)
        t5 = self.Fp12.add(t0, t1)
        c1 = self.Fp12.sub(t4, t5)
        return [c0, c1]

    def sqr(self, a):
        a1_ = self.Fp12.guzai(a[1], self.qnr)
        t0 = self.Fp12.add(a[0], a1_)
        t1 = self.Fp12.add(a[0], a[1])
        t2 = self.Fp12.mul(t0, t1)
        t3 = self.Fp12.mul(a[0], a[1])
        t4 = self.Fp12.guzai(t3, self.qnr)
        t5 = self.Fp12.add(t3, t4)
        c0 = self.Fp12.sub(t2, t5)
        c1 = self.Fp12.add(t3, t3)
        return [c0, c1]

    def conj(self, a):
        return [a[0], self.Fp12.neg(a[1])]

    def inv(self, a):  # Itoh-Tsujii Inversion
        aa = self.Fp12.sqr(a[0])
        bb = self.Fp12.sqr(a[1])
        bbxi = self.Fp12.guzai(bb, self.qnr)
        denom = self.Fp12.sub(aa, bbxi)
        denom_inv = self.Fp12.inv(denom)
        c0 = self.Fp12.mul(a[0], denom_inv)
        c1 = self.Fp12.mul(a[1], denom_inv)
        c1_ = self.Fp12.neg(c1)
        return [c0, c1_]

    def neg(self, a):
        return [self.Fp12.neg(a[0]), self.Fp12.neg(a[1])]

    def exp(self, f, u):
        r = f
        for ub in bits_of(abs(u))[1:]:
            r = self.mul(r, r)
            if ub == 1:
                r = self.mul(r, f)
        if u < 0:
            r = self.inv(r)
        return r

    def frob(self, a):
        f10_c = self.Fp4.frob(a[1][0])
        f01_c = self.Fp4.frob(a[0][1])
        f11_c = self.Fp4.frob(a[1][1])
        f02_c = self.Fp4.frob(a[0][2])
        f12_c = self.Fp4.frob(a[1][2])
        new_f00 = self.Fp4.frob(a[0][0])
        new_f10 = self.Fp4.mul(f10_c, self.k[1])
        new_f01 = self.Fp4.mul(f01_c, self.k[2])
        new_f11 = self.Fp4.mul(f11_c, self.k[3])
        new_f02 = self.Fp4.mul(f02_c, self.k[4])
        new_f12 = self.Fp4.mul(f12_c, self.k[5])
        return [[new_f00, new_f01, new_f02], [new_f10, new_f11, new_f12]]


if __name__ == "__main__":
    p = 0x1A0111EA397FE69A4B1BA7B6434BACD764774B84F38512BF6730D2A0F6B0F6241EABFFFEB153FFFFB9FEFFFFFFFFAAAB
    # bls12-381
    Fp_bls12_381 = Fp_t(p=p)
    Fp2_bls12_381 = Fp2_t(Fp=Fp_bls12_381, qnr=-1)
    Fp4_bls12_381 = Fp4_t(Fp2=Fp2_bls12_381, qnr=[1, 1])
    Fp12_bls12_381 = Fp12_t(Fp2=Fp2_bls12_381, Fp4=Fp4_bls12_381, cnr=[[0, 0], [1, 0]])

    # check_mul(Fp12_bls12_381)
