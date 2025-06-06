from sage.all_cmdline import *  # import sage library

from sage.rings.integer_ring import ZZ
from sage.rings.rational_field import QQ
from sage.misc.functional import cyclotomic_polynomial
from sage.rings.finite_rings.finite_field_constructor import FiniteField, GF
from sage.schemes.elliptic_curves.constructor import EllipticCurve

# this is much much faster with this statement:
# proof.arithmetic(False)
from sage.structure.proof.all import arithmetic

from parameter import find_curve_parameter_b, find_twist_curve_parameter_xi_ab
from test_pairing import test_order, test_ate_pairing_bls12_aklgl
import json
import argparse


def get_parameters(u0):
    QQx = QQ["x"]
    (x,) = QQx._first_ngens(1)
    # BLS12 polynomials
    px = (x - 1) ** 2 * (x**4 - x**2 + 1) / 3 + x
    rx = x**4 - x**2 + 1
    tx = x + 1
    cx = (x - 1) ** 2 / 3
    yx = (x - 1) * (2 * x**2 - 1) / 3
    c2x = (
        x**8
        - 4 * x**7
        + 5 * x**6
        - 4 * x**4
        + 6 * x**3
        - 4 * x**2
        - 4 * x
        + 13
    ) / 9  # cofactor for G2
    p = ZZ(px(u0))
    r = ZZ(rx(u0))
    c = ZZ(cx(u0))
    c2 = ZZ(c2x(u0))
    t = ZZ(tx(u0))
    y = ZZ(yx(u0))
    Fp = GF(p, proof=False)
    k = 12
    b, E = find_curve_parameter_b(Fp, r, c)
    print("u = {:#x}".format(u0))
    print("p = {:#x}, {} mod 4 # {} bits".format(p, p % 4, p.nbits()))
    print("r = {:#x} # {} bits".format(r, r.nbits()))
    print("c = {:#x} # {} bits".format(c, c.nbits()))
    print("y = {:#x}".format(y))
    print("t = {:#x}".format(t))
    print("BLS{}-{} E: y^2 = x^3 {:+d}".format(k, p.nbits(), b))

    # define Fp2
    Fpz = Fp["z"]
    (z,) = Fpz._first_ngens(1)
    if (p % 4) == 3:
        Fp2 = Fp.extension(z**2 + 1, names=("i",))
        (i,) = Fp2._first_ngens(1)
        a = -1
        print("Fp2 = Fp[x]/(x^2 + 1)")
    else:
        a = 2
        while not (z**2 - a).is_irreducible():
            a = a + 1
        print("Fp2 = Fp[x]/(x^2 - {})".format(a))
        Fp2 = Fp.extension(z**2 - a, names=("i",))
        (i,) = Fp2._first_ngens(1)

    # Fq = Fp2
    Fp2s = Fp2["s"]
    (s,) = Fp2s._first_ngens(1)
    E2, xi, btw, D_twist = find_twist_curve_parameter_xi_ab(b, Fp2, r, d=6)
    if D_twist:
        print(
            "BLS{}-{} E'(Fp4): y^2 = x^3 {:+d}/({}): D-twist".format(
                k, p.nbits(), b, xi
            )
        )
    else:
        print(
            "BLS{}-{} E'(Fp4): y^2 = x^3 {:+d}*({}): M-twist".format(
                k, p.nbits(), b, xi
            )
        )

    P = c * E.random_element()
    while P == E(0) or r * P != E(0):
        P = c * E.random_element()
    Q = c2 * E2.random_element()
    while Q == E2(0) or r * Q != E2(0):
        Q = c2 * E2.random_element()

    params = {
        "u": int(u0),
        "p": int(p),
        "r": int(r),
        "b": int(b),
        "beta": int(a),  # Fp2[i]/(i^2-beta)
        # Fp12[w]/(w^6-(xi1*v+xi0))
        "xi": [int(x) for x in xi.polynomial().list()],
        "D_twist": D_twist,
        "P": [int(P[0]), int(P[1])],
        "Q": [
            [int(x) for x in Q[0].polynomial().list()],
            [int(x) for x in Q[1].polynomial().list()],
        ],
    }

    return params


def test_curve(u0):
    # preparse("QQx.<x> = QQ[]")
    QQx = QQ["x"]
    (x,) = QQx._first_ngens(1)
    # BLS12 polynomials
    px = (x - 1) ** 2 * (x**4 - x**2 + 1) / 3 + x
    rx = x**4 - x**2 + 1
    tx = x + 1
    cx = (x - 1) ** 2 / 3
    yx = (x - 1) * (2 * x**2 - 1) / 3
    c2x = (
        x**8
        - 4 * x**7
        + 5 * x**6
        - 4 * x**4
        + 6 * x**3
        - 4 * x**2
        - 4 * x
        + 13
    ) / 9  # cofactor for G2
    p = ZZ(px(u0))
    r = ZZ(rx(u0))
    c = ZZ(cx(u0))
    c2 = ZZ(c2x(u0))
    t = ZZ(tx(u0))
    y = ZZ(yx(u0))
    Fp = GF(p, proof=False)
    k = 12
    b, E = find_curve_parameter_b(Fp, r, c)

    print("u = {:#x}".format(u0))
    print("p = {:#x}, {} mod 4 # {} bits".format(p, p % 4, p.nbits()))
    print("r = {:#x} # {} bits".format(r, r.nbits()))
    print("c = {:#x} # {} bits".format(c, c.nbits()))
    print("y = {:#x}".format(y))
    print("t = {:#x}".format(t))
    print("BLS{}-{} E: y^2 = x^3 {:+d}".format(k, p.nbits(), b))
    print("test E (G1): ", end="")
    test_order(E, r * c)

    # define Fp2
    Fpz = Fp["z"]
    (z,) = Fpz._first_ngens(1)
    if (p % 4) == 3:
        Fp2 = Fp.extension(z**2 + 1, names=("i",))
        (i,) = Fp2._first_ngens(1)
        a = -1
        print("Fp2 = Fp[x]/(x^2 + 1)")
    else:
        a = 2
        while not (z**2 - a).is_irreducible():
            a = a + 1
        print("Fp2 = Fp[x]/(x^2 - {})".format(a))
        Fp2 = Fp.extension(z**2 - a, names=("i",))
        (i,) = Fp2._first_ngens(1)

    # Fq = Fp2
    Fp2s = Fp2["s"]
    (s,) = Fp2s._first_ngens(1)
    E2, xi, btw, D_twist = find_twist_curve_parameter_xi_ab(b, Fp2, r, d=6)
    print("test E' (G2): ", end="")
    test_order(E2, r * c2)
    if D_twist:
        print(
            "BLS{}-{} E'(Fp4): y^2 = x^3 {:+d}/({}): D-twist".format(
                k, p.nbits(), b, xi
            )
        )
    else:
        print(
            "BLS{}-{} E'(Fp4): y^2 = x^3 {:+d}*({}): M-twist".format(
                k, p.nbits(), b, xi
            )
        )

    Fq6 = Fp2.extension(s**6 - xi, names=("w",))
    (w,) = Fq6._first_ngens(1)
    try:
        coeffs_xi = xi.polynomial().list()
    except AttributeError as err:
        coeffs_xi = xi.list()
    i0 = ZZ(coeffs_xi[0])
    i1 = ZZ(coeffs_xi[1])
    if abs(i0 - p) < abs(i0):
        i0 = i0 - p
    if abs(i1 - p) < abs(i1):
        i1 = i1 - p

    # xi = i0 + i*i1
    # s^6 - xi = 0 <=> s^6 - i0 = i1*i <=> (s^6 - i0)^2 = i1^2*a
    poly = (z**6 - i0) ** 2 - i1**2 * a
    Fp12 = Fp.extension(poly, names=("S",))
    (S,) = Fp12._first_ngens(1)
    # E_Fp12 = EllipticCurve([Fp12(0), Fp12(b)])
    print("Fq6 = Fq[s]/(s^6{:+d}{:+d}*i): Fq = Fp2".format(int(-i0), int(-i1)))
    print("Fp12 = Fp[z]/({})".format(poly))

    def map_Fq6_Fp12(x):
        # evaluate elements of Fp12 = Fp[i]/(i^2+1)[s]/(s^6-(i+1)) at i=S^6-1 and s=S
        # i <-> w^6-1 = S^6-1 and w <-> S
        # return sum([sum([yj*(S**6-1)**j for j,yj in
        # enumerate(xi.polynomial())]) * S**i for i,xi in enumerate(x.list())])
        return sum(
            [
                xi.polynomial()((S**6 - i0) / i1) * S**e
                for e, xi in enumerate(x.list())
            ]
        )

    test_ate_pairing_bls12_aklgl(E, E2, r, c, c2, u0, Fq6, map_Fq6_Fp12, D_twist)


if __name__ == "__main__":
    psr = argparse.ArgumentParser(
        usage="parameters.py -c <curve_group> -p <p[bit]>",
        description="calculate required parameter for pairing operation",
    )
    psr.add_argument("-c", "--curve", required=True, help="curve group")
    psr.add_argument(
        "-p",
        "--characteristic",
        required=True,
        help="bit width of characteristic number p",
    )
    # psr.add_argument("-f", "--filename", required=True, help="読み込むJSONファイル")
    args = psr.parse_args()
    curve_group = args.curve
    curve_name = args.characteristic
    os.chdir('..')
    target_dir = "{}/{}-{}".format(
        os.path.dirname(os.getcwd().replace("\\", "/")), curve_group, curve_name
    )
    os.makedirs(target_dir, exist_ok=True)
    param_file = "{}/param.json".format(target_dir)

    u0 = 0
    # # bls12-381
    if curve_name == "381":
        u0 = ZZ(-(2**63 + 2**62 + 2**60 + 2**57 + 2**48 + 2**16))
        # # test_curve(u0)

    # # # bls12-446
    if curve_name == "446":
        u0 = ZZ(-(2**75 - 2**73 + 2**63 + 2**57 + 2**50 + 2**17 + 1))
        # # test_curve(u0)

    # # bls12-638
    if curve_name == "638":
        u0 = ZZ(-(2**107) + 2**105 + 2**93 + 2**5)
    
    # bls12-1150
    if curve_name == "1150":
        u0 = ZZ(-(2**192) + 2**188 -(2**115) -(2**110) -(2**44) - 1)

    with open(param_file, "w") as file:
        json.dump(get_parameters(u0), file, indent=4)
