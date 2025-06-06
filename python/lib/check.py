import random
from lib.util import flatten_list
from lib.pairing import (
    double_line_twist6,
    add_line_twist6,
    sparse_mult_d6_twist,
    sparse_mult_m6_twist,
    pairing_bls12,
    pairing_bls24,
    scalar_mul_twist6,
    miller_function_ate,
    final_exp_bls12,
    final_exp_bls24,
)
from lib.ep import scalar_mul
from lib.parameters import p, curve_group, Fp, Fq, Fq6, P, Q, T, BT, xi, D_twist, U


def change_to_affine(Fq, T):
    # 射影座標(X,Y,Z)のZ座標を1に補正する　X,Y座標を取り出せばそのままアフィン座標
    # Montgomery 空間中
    zinv = Fq.inv(T[2])
    xaff = Fq.mul(T[0], zinv)
    yaff = Fq.mul(T[1], zinv)
    return [xaff, yaff, Fq.one()]


def check_rP_Fq(Fq, r, T, P, BT, xi, D_twist):
    # 曲線上の点P，位数rがある時rP = O（無限遠点）となるはず
    inf = scalar_mul_twist6(Fq, r, T, P, BT, xi, D_twist)
    if inf[0] == Fq.zero() and inf[2] == Fq.zero():
        print(
            "check_rP completed: the point on the curve and the field number is correct"
        )
    else:
        print("check_rP uncompleted")


def check_on_curve_Fq_projective(Fq, T, BT):
    # 点T_がFp4曲線上にのっているか y^2 = x^3 + [[A0, A1], [A2, A3]]x + [[B0, B1], [B2, B3]]
    # モンゴメリ空間上の射影座標の点(X,Y,Z)を入力にとる
    # x = X/Z, y = Y/Z より (Y^2)Z = X^3 + AX(Z^2) + B(Z^3) が成立
    A4 = Fq.zero()
    ax = Fq.mul(A4, T[0])
    bz = Fq.mul(BT, T[2])
    axbz = Fq.add(ax, bz)
    z2 = Fq.sqr(T[2])
    axz2bz3 = Fq.mul(axbz, z2)
    x2 = Fq.sqr(T[0])
    x3 = Fq.mul(x2, T[0])
    x3axz2bz3 = Fq.add(x3, axz2bz3)
    y2 = Fq.sqr(T[1])
    y2z = Fq.mul(y2, T[2])
    if y2z == x3axz2bz3:
        print("on the Fq curve: projective coordinates")
    else:
        print("Not on the Fq curve: projective coordinates")


def check_ml(Fq6, Fq, Fp, r, P, Q, BT, xi, D_twist, miller_param_list):
    f = Fq6.one()
    negQ = [Q[0], Fq.neg(Q[1])]
    P_dbl = [Fp.neg(P[0]), P[1]]
    P_add = [P[0], Fp.neg(P[1])]

    if miller_param_list[0] < 0:
        T = [Q[0], Fq.neg(Q[1]), Fq.one()]
    else:
        T = [Q[0], Q[1], Fq.one()]

    check_rP_Fq(Fq, r, T, P, BT, xi, D_twist)
    check_on_curve_Fq_projective(Fq, T, BT)
    for l in miller_param_list[1:]:
        T, e = double_line_twist6(Fq, T, P_dbl, BT, xi, D_twist)
        f = Fq6.sqr(f)
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
        check_rP_Fq(Fq, r, change_to_affine(Fq, T), P, BT, xi, D_twist)
        check_on_curve_Fq_projective(Fq, T, BT)
    return T, f


def check_mul(group):
    a = group.random_element()
    a_inv = group.inv(a)
    one = group.mul(a, a_inv)
    print(group.MontConvInv(one))
    # if group.MontConvInv() == 1:
    #     print("Fp12 ok")
    # else:
    #     print("Fp12 ng")


def check_bilinear(curve_group, Fq6, Fq, Fp, P, Q, BT, xi, D_twist, U):
    if curve_group == "bls12":
        f = pairing_bls12(Fq6, Fq, Fp, P, Q, BT, xi, D_twist, U)
    elif curve_group == "bls24":
        f = pairing_bls24(Fq6, Fq, Fp, P, Q, BT, xi, D_twist, U)

    a = random.randint(1, p - 1)
    aP = scalar_mul(Fp, a, P)

    b = random.randint(1, p - 1)
    bQ = scalar_mul_twist6(Fq, b, T, P, BT, xi, D_twist)
    bQ = change_to_affine(Fq, bQ)

    if curve_group == "bls12":
        abf = pairing_bls12(Fq6, Fq, Fp, aP, bQ, BT, xi, D_twist, U)
    elif curve_group == "bls24":
        abf = pairing_bls24(Fq6, Fq, Fp, aP, bQ, BT, xi, D_twist, U)

    if abf == Fq6.exp(f, a * b):
        print("e(aP, bQ) == e(P, Q)^ab")
    else:
        print("e(aP, bQ) != e(P, Q)^ab")


def check_output(curve_group, Fq6, Fq, Fp, P, Q, BT, xi, D_twist, U):
    T, f = miller_function_ate(
        Fq6, Fq, Fp, P, Q, BT, xi, D_twist, miller_param_list=U[::-1]
    )
    print("Miller Loop ------------------\nT:")
    for t in flatten_list(T):
        print("{:x}".format(t))
    print("f:")
    for fx in flatten_list(f):
        print("{:x}".format(fx))

    if curve_group == "bls12":
        f = final_exp_bls12(Fq6, Fq, xi, U, f)
    elif curve_group == "bls24":
        f = final_exp_bls24(Fq6, Fq, xi, U, f)
    print("Final Exponentiation ---------\nf:")
    for fx in flatten_list(f):
        print("{:x}".format(fx))


if __name__ == "__main__":
    # check_bilinear(
    #     curve_group,
    #     Fq6,
    #     Fq,
    #     Fp,
    #     P,
    #     Q,
    #     BT,
    #     xi,
    #     D_twist,
    #     U,
    # )
    check_output(curve_group, Fq6, Fq, Fp, P, Q, BT, xi, D_twist, U)
