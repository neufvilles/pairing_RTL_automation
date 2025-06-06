from lib.fpx import *
from lib.util import flatten_list

def double_line_twist6(Fq, T, P, BT, xi, D_twist):
    TX = T[0]
    TY = T[1]
    TZ = T[2]
    PX = P[0]
    PY = P[1]
    t0 = Fq.sqr(TY)
    t1 = Fq.sqr(TZ)
    t1 = Fq.mul(BT, t1)
    b_ = Fq.add(t1, t1)
    t1 = Fq.add(b_, t1)
    t2 = Fq.mul(TX, TY)
    t2 = Fq.add(t2, t2)
    t3 = Fq.sqr(TX)
    t6 = Fq.add(t3, t3)
    t3 = Fq.add(t6, t3)
    t4 = Fq.mul(TY, TZ)
    t4 = Fq.add(t4, t4)
    new_TZ = Fq.mul(t0, t4)
    new_TZ = Fq.add(new_TZ, new_TZ)
    new_TZ = Fq.add(new_TZ, new_TZ)
    l01 = Fq.sub(t0, t1)
    b2 = Fq.add(t1, t1)
    new_TX = Fq.sub(l01, b2)
    new_TX = Fq.mul(new_TX, t2)
    new_TY = Fq.add(t0, l01)
    b3 = Fq.add(b2, t1)
    new_TY = Fq.mul(b3, new_TY)
    t0 = Fq.sqr(t0)
    new_TY = Fq.add(new_TY, t0)
    # l00 = [mul(t4[0], PY[0]), mul(t4[1], PY[0])]
    # l10 = [mul(t3[0], negFp(PX[0])), mul(t3[1], negFp(PX[0]))]
    l00 = Fq.constMul(t4, PY)
    l10 = Fq.constMul(t3, PX)
    zero = Fq.zero()
    if D_twist:
        l = [l00, l10, zero, l01, zero, zero]
    else:
        l = [l01, zero, l10, l00, zero, zero]
    return [new_TX, new_TY, new_TZ], l


def add_line_twist6(Fq, T, P, Q, BT, xi, D_twist):
    TX = T[0]
    TY = T[1]
    TZ = T[2]
    PX = P[0]
    PY = P[1]
    QX = Q[0]
    QY = Q[1]
    t0 = Fq.mul(QY, TZ)
    t0 = Fq.sub(TY, t0)
    t1 = Fq.mul(QX, TZ)
    t1 = Fq.sub(TX, t1)
    t2 = Fq.sqr(t0)
    t3 = Fq.sqr(t1)
    t4 = Fq.mul(t1, t3)
    t5 = Fq.mul(TZ, t2)
    t5 = Fq.add(t4, t5)
    t3 = Fq.mul(TX, t3)
    t6 = Fq.add(t3, t3)
    t5 = Fq.sub(t5, t6)
    t7 = Fq.sub(t5, t3)
    new_TX = Fq.mul(t1, t5)
    t7 = Fq.mul(t0, t7)
    t8 = Fq.mul(TY, t4)
    new_TY = Fq.add(t7, t8)
    new_TY = Fq.neg(new_TY)
    new_TZ = Fq.mul(TZ, t4)
    l00 = Fq.constMul(t1, PY)
    l10 = Fq.constMul(t0, PX)
    l01 = Fq.mul(QY, t1)
    t0 = Fq.mul(QX, t0)
    l01 = Fq.sub(l01, t0)
    zero = Fq.zero()
    if D_twist:
        l = [l00, l10, zero, l01, zero, zero]
    else:
        l = [l01, zero, l10, l00, zero, zero]
    return [new_TX, new_TY, new_TZ], l


def scalar_mul_twist6(Fq, n, T, P, BT, xi, D_twist):
    res = T
    for nb in bits_of(n)[1:]:
        res, l = double_line_twist6(Fq, res, P, BT, xi, D_twist)
        if nb == 1:
            res, l = add_line_twist6(Fq, res, P, T, BT, xi, D_twist)
    return res


def Fq6SparseMul(Fq, xi, a0, a1, b0, b1, b2):
    t0 = Fq.mul(a0, b0)
    t1 = Fq.mul(a1, b1)
    t2 = Fq.mul(a1, b2)
    t2 = Fq.guzai(t2, xi)
    t3 = Fq.add(t0, t2)
    t4 = Fq.add(a0, a1)
    t5 = Fq.add(b0, b1)
    t6 = Fq.mul(t4, t5)
    t7 = Fq.add(t0, t1)
    t7 = Fq.sub(t6, t7)
    t8 = Fq.mul(a0, b2)
    t9 = Fq.add(t8, t1)
    return [t3, t7, t9]


def sparse_mult_m6_twist(Fq, xi, l, f):
    T1 = Fq.mul(l[3], f[1])
    T2 = Fq.mul(l[3], f[3])
    T0 = Fq.mul(l[3], f[5])
    T0 = Fq.guzai(T0, xi)  # B = [T5, T7, T6]
    B = Fq6SparseMul(Fq, xi, l[0], l[2], f[0], f[2], f[4])
    a20 = Fq.add(l[2], l[3])
    b00 = Fq.add(f[0], f[1])
    b20 = Fq.add(f[2], f[3])
    b11 = Fq.add(f[4], f[5])
    E = Fq6SparseMul(Fq, xi, l[0], a20, b00, b20, b11)
    T7 = Fq.add(T0, B[0])  # T7 -> T11, T8 -> T12, T9 -> T13
    T8 = Fq.add(T1, B[1])
    T9 = Fq.add(T2, B[2])
    T7 = Fq.sub(E[0], T7)
    T8 = Fq.sub(E[1], T8)
    T9 = Fq.sub(E[2], T9)
    T2 = Fq.guzai(T2, xi)
    T2 = Fq.add(T2, B[0])
    T0 = Fq.add(T0, B[1])
    T1 = Fq.add(T1, B[2])
    return [T2, T7, T0, T8, T1, T9]


def sparse_mult_d6_twist(Fq, xi, l, f):
    T0 = Fq.mul(l[0], f[0])
    T1 = Fq.mul(l[0], f[2])
    T2 = Fq.mul(l[0], f[4])  # f = [T0, T1, T2]
    B = Fq6SparseMul(Fq, xi, l[1], l[3], f[1], f[3], f[5])
    a00 = Fq.add(l[0], l[1])
    b00 = Fq.add(f[0], f[1])
    b20 = Fq.add(f[2], f[3])
    b11 = Fq.add(f[4], f[5])
    E = Fq6SparseMul(Fq, xi, a00, l[3], b00, b20, b11)
    T7 = Fq.add(T0, B[0])  # T7 -> T11, T8 -> T12, T9 -> T13
    T8 = Fq.add(T1, B[1])
    T9 = Fq.add(T2, B[2])
    T7 = Fq.sub(E[0], T7)
    T8 = Fq.sub(E[1], T8)
    T9 = Fq.sub(E[2], T9)
    B[2] = Fq.guzai(B[2], xi)
    T0 = Fq.add(T0, B[2])
    T1 = Fq.add(T1, B[0])
    T2 = Fq.add(T2, B[1])
    return [T0, T7, T1, T8, T2, T9]


def miller_function_ate(Fq6, Fq, Fp, P, Q, BT, xi, D_twist, miller_param_list):
    f = Fq6.one()
    negQ = [Q[0], Fq.neg(Q[1])]
    P_dbl = [Fp.neg(P[0]), P[1]]
    P_add = [P[0], Fp.neg(P[1])]

    if miller_param_list[0] < 0:
        T = [Q[0], Fq.neg(Q[1]), Fq.one()]
    else:
        T = [Q[0], Q[1], Fq.one()]

    for l in miller_param_list[1:]:
        T, e = double_line_twist6(Fq, T, P_dbl, BT, xi, D_twist)
        # print("point doubling T:")
        # for t in flatten_list(T):
        #     print("{:x}".format(t))

        f = Fq6.sqr(f)
        # print("square:")
        # for fx in flatten_list(f):
        #     print("{:x}".format(fx))
        f = Fq6.mapToFq6(f)
        if D_twist:
            f = sparse_mult_d6_twist(Fq, xi, e, f)
        else:
            f = sparse_mult_m6_twist(Fq, xi, e, f)
        if l == 1:
            T, e = add_line_twist6(Fq, T, P_add, Q, BT, xi, D_twist)
            if D_twist:
                f = sparse_mult_d6_twist(Fq, xi, e, f)
            else:
                f = sparse_mult_m6_twist(Fq, xi, e, f)
        if l == -1:
            T, e = add_line_twist6(Fq, T, P_add, negQ, BT, xi, D_twist)
            if D_twist:
                f = sparse_mult_d6_twist(Fq, xi, e, f)
            else:
                f = sparse_mult_m6_twist(Fq, xi, e, f)
        f = Fq6.mapFromFq6(f)
    return T, f


def SQR012345(Fq, xi, f):
    T0 = Fq.sqr(f[0])
    T1 = Fq.add(f[0], f[4])
    T2 = Fq.sub(T1, f[2])
    T1 = Fq.add(T1, f[2])
    T1 = Fq.sqr(T1)
    T2 = Fq.sqr(T2)
    T3 = Fq.mul(f[4], f[2])
    T3 = Fq.add(T3, T3)
    T4 = Fq.sqr(f[4])
    T5 = Fq.mul(f[0], f[3])
    T6 = Fq.mul(f[2], f[5])
    T7 = Fq.mul(f[1], f[4])
    c0 = Fq.guzai(T3, xi)
    c0 = Fq.add(T0, c0)
    c0 = Fq.add(c0, c0)
    c0 = Fq.sub(c0, Fq.one())
    c4 = Fq.add(T0, T4)
    c4 = Fq.add(c4, c4)
    c4 = Fq.sub(T1, c4)
    c4 = Fq.add(T2, c4)
    T4 = Fq.guzai(T4, xi)
    c2 = Fq.sub(T4, T3)
    c2 = Fq.add(c2, c2)
    c2 = Fq.add(c2, T1)
    c2 = Fq.sub(c2, T2)
    T1 = Fq.add(T6, T6)
    T1 = Fq.add(T1, T6)
    T1 = Fq.guzai(T1, xi)
    c1 = Fq.add(f[1], T1)
    c1 = Fq.add(c1, c1)
    T2 = Fq.add(T7, T7)
    T2 = Fq.add(T2, T7)
    c5 = Fq.add(T2, f[5])
    c5 = Fq.add(c5, c5)
    T3 = Fq.add(T5, T5)
    T3 = Fq.add(T3, T5)
    c3 = Fq.add(T3, f[3])
    c3 = Fq.add(c3, c3)
    return [c0, c1, c2, c3, c4, c5]


def final_exp_expFq(Fq6, Fq, xi, U, a):
    r = a
    res = Fq6.one()
    for ui in U:
        if ui == 1:
            res = Fq6.mul(res, r)
        if ui == -1:
            # NOTE: hard partでは冪乗する数a(=conj(f)/f)がunitaryなのでinv(a)=conj(a)
            tmp = Fq6.conj(r)
            res = Fq6.mul(res, tmp)
        # r = SQR012345(Fq, xi, r)
        r = Fq6.mapFromFq6(SQR012345(Fq, xi, Fq6.mapToFq6(r)))
    return res


def final_exp_easy_k12(Fp12: Fp12_t, f):
    k = Fp12.frob(Fp12.frob(f))
    k = Fp12.mul(k, f)
    l = Fp12.inv(k)
    f = Fp12.mul(l, Fp12.conj(k))
    return f


def final_exp_hard_bls12(Fp12: Fp12_t, Fp2: Fp2_t, xi, U, f):
    t1 = Fp12.mapFromFq6(SQR012345(Fp2, xi, Fp12.mapToFq6(f)))  # f^2
    t2 = final_exp_expFq(Fp12, Fp2, xi, U, f)  # f^u
    t1 = Fp12.conj(t1)
    t1 = Fp12.mul(t1, t2)  # f^(u-2)
    t4 = final_exp_expFq(Fp12, Fp2, xi, U, t1)  # f^(u^2-2u)
    t1 = Fp12.conj(t1)  # f^(-u+2)
    t1 = Fp12.mul(t1, f)  # f^(-u+3)
    t5 = final_exp_expFq(Fp12, Fp2, xi, U, t4)  # f^(u^3-2u^2)
    t4 = Fp12.mul(f, t4)  # f^(u^2-2u+1)
    t3 = final_exp_expFq(Fp12, Fp2, xi, U, t5)  # f^(u^4-2u^3)
    t5 = Fp12.mul(t2, t5)  # f^(u^3-2u^2+u)
    t2 = Fp12.mapFromFq6(SQR012345(Fp2, xi, Fp12.mapToFq6(t2)))  # f^2u
    t4 = Fp12.frob(Fp12.frob(t4))
    t5 = Fp12.frob(t5)
    t5 = Fp12.frob(t5)
    t2 = Fp12.mul(t2, t3)  # f^(u^4-2u^3+2u)
    t4 = Fp12.frob(t4)
    t3 = final_exp_expFq(Fp12, Fp2, xi, U, t2)  # f^(u^5-2u^4+2u^2)
    t4 = Fp12.mul(t4, t5)
    g = Fp12.conj(f)  # f^(-1)
    t5 = Fp12.mul(g, t2)  # f^(u^4-2u^3+2u-1)
    t1 = Fp12.mul(t1, t3)  # f^(u^5-2u^4+2u^2-u+3)
    t5 = Fp12.frob(t5)
    t1 = Fp12.mul(t1, t4)
    t1 = Fp12.mul(t1, t5)
    return t1


def final_exp_bls12(Fp12: Fp12_t, Fp2: Fp2_t, xi, U, f):
    f = final_exp_easy_k12(Fp12, f)
    # print("Final Exponentiation easy part ---------\nf:")
    # for fx in flatten_list(f):
    #     print("{:x}".format(fx))
    g = final_exp_hard_bls12(Fp12, Fp2, xi, U, f)
    return g


def pairing_bls12(Fp12: Fp12_t, Fp2: Fp2_t, Fp: Fp_t, P, Q, BT, xi, D_twist, U):
    T, f = miller_function_ate(
        Fp12, Fp2, Fp, P, Q, BT, xi, D_twist, miller_param_list=U[::-1]
    )
    f = final_exp_bls12(Fp12, Fp2, xi, U, f)
    return f


def final_exp_easy_k24(Fp24: Fp24_t, f):
    e = Fp24.inv(f)
    f = Fp24.conj(f)
    f = Fp24.mul(e, f)
    e = Fp24.frob(Fp24.frob(Fp24.frob(Fp24.frob(f))))
    f = Fp24.mul(e, f)
    return f


def final_exp_hard_bls24(Fp24: Fp24_t, Fp4: Fp4_t, xi, U, f):
    t0 = final_exp_expFq(Fp24, Fp4, xi, U, f)  # f^u
    t1 = final_exp_expFq(Fp24, Fp4, xi, U, t0)  # f^(u^2)
    t0 = Fp24.mapFromFq6(SQR012345(Fp4, xi, Fp24.mapToFq6(t0)))  # f^(2u)
    t0 = Fp24.conj(t0)  # f^(-2u)
    t0 = Fp24.mul(t0, t1)  # f^(u^2-2u)
    t0 = Fp24.mul(t0, f)  # f^(u^2-2u+1) = f^l7
    t1 = final_exp_expFq(Fp24, Fp4, xi, U, t0)  # f^(l7*u) = f^l6
    t2 = Fp24.frob(t0)  # f^(l7*p)
    t2 = Fp24.mul(t1, t2)  # f^(l7*p+l6)
    t0 = Fp24.conj(t0)  # f^(-l7)
    t1 = final_exp_expFq(Fp24, Fp4, xi, U, t1)  # f^(l6*u) = f^l5
    t2 = Fp24.frob(t2)  # f^(l7*p^2+l6*p)
    t2 = Fp24.mul(t2, t1)  # f^(l7*p^2+l6*p+l5)
    t1 = final_exp_expFq(Fp24, Fp4, xi, U, t1)  # f^(l5*u) = f^l4
    t2 = Fp24.frob(t2)  # f^(l7*p^3+l6*p^2+l5*p)
    t2 = Fp24.mul(t1, t2)  # f^(l7*p^3+l6*p^2+l5*p+l4)
    t1 = final_exp_expFq(Fp24, Fp4, xi, U, t1)  # f^(l4*u)
    t1 = Fp24.mul(t0, t1)  # f^(l4*u-l7) = f^l3
    t2 = Fp24.frob(t2)  # f^(l7*p^4+l6*p^3+l5*p^2+l4*p)
    t2 = Fp24.mul(t1, t2)  # f^(l7*p^4+l6*p^3+l5*p^2+l4*p+l3)
    t1 = final_exp_expFq(Fp24, Fp4, xi, U, t1)  # f^(l3*u) = f^l2
    t2 = Fp24.frob(t2)  # f^(l7*p^5+l6*p^4+l5*p^3+l4*p^2+l3*p)
    t2 = Fp24.mul(t1, t2)  # f^(l7*p^5+l6*p^4+l5*p^3+l4*p^2+l3*p+l2)
    t1 = final_exp_expFq(Fp24, Fp4, xi, U, t1)  # f^(l2*u) = f^l1
    t2 = Fp24.frob(t2)  # f^(l7*p^6+l6*p^5+l5*p^4+l4*p^3+l3*p^2+l2*p)
    t2 = Fp24.mul(t1, t2)  # f^(l7*p^6+l6*p^5+l5*p^4+l4*p^3+l3*p^2+l2*p+l1)
    t1 = final_exp_expFq(Fp24, Fp4, xi, U, t1)  # f^(l1*u)
    t0 = Fp24.mapFromFq6(SQR012345(Fp4, xi, Fp24.mapToFq6(f)))  # f^2
    t0 = Fp24.mul(t0, t1)  # f^(l1*u+2)
    t0 = Fp24.mul(t0, f)  # f^(l1*u+3) = f^l0
    t2 = Fp24.frob(t2)  # f^(l7*p^7+l6*p^6+l5*p^5+l4*p^4+l3*p^3+l2*p^2+l1*p)
    t2 = Fp24.mul(t0, t2)  # f^(l7*p^7+l6*p^6+l5*p^5+l4*p^4+l3*p^3+l2*p^2+l1*p+l0)
    return t2


def final_exp_bls24(Fp24: Fp24_t, Fp4: Fp4_t, xi, U, f):
    f = final_exp_easy_k24(Fp24, f)
    g = final_exp_hard_bls24(Fp24, Fp4, xi, U, f)
    return g


def pairing_bls24(Fp24, Fp4, Fp, P, Q, BT, xi, D_twist, U):
    T, f = miller_function_ate(
        Fp24, Fp4, Fp, P, Q, BT, xi, D_twist, miller_param_list=U[::-1]
    )
    f = final_exp_bls24(Fp24, Fp4, xi, U, f)
    return f
