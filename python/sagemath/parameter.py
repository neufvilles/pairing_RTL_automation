from sage.schemes.elliptic_curves.constructor import EllipticCurve


def find_curve_parameter_b(Fq, r, c):
    """
    Find the smallest curve parameter b, assuming j(E) = 0 (a=0)
    E: y^2 = x^3 + b

    INPUT:
    - `Fq`: finite field of definition of E
    - `r`: subgroup order of E
    - `c`: cofactor of the order

    The curve order should be r*c
    There are six possible orders: r*c, the quadratic twist,
    one of the two cubic twists, one of the two 6-th twists.
    This function iterates over b, starting at b=1, then -1, 2, -2 ...

    RETURN: b, E/Fq
    """
    order_E = False
    order = r * c
    b = 1
    while not order_E:
        E = EllipticCurve([Fq(0), Fq(b)])
        P = E.random_element()
        order_E = order * P == E(0)
        if not order_E:
            if b > 0:
                b = -b
            else:
                b = -b + 1
    return b, E


def find_twist_curve_parameter_xi_ab(ab, Fq, r, d=6):
    """
    Find the smallest non-zero curve coefficient atw or btw for the d-twist of
    E: y^2 = x^3 + b (3- or 6-twist) or E: y^2 = x^3 + a*x (4-twist)

    INPUT:
    - `ab`: nonzero curve coefficient of E
    - `Fq`: field of definition of the d-twist
    - `r`: prime subgroup order
    - `g2c`: cofactor, so that the d-twist order is r*g2c over Fq
    - `d`: twist degree, can be 3, 4 or 6
    - `D_twist`: is it a D-twist (divide: btw = b/xi) or a M-twist (multiply: btw=b*xi)

    Cited in Benger-Scott
    Constructing Tower Extensions of Finite Fields for Implementation of
    Pairing-Based Cryptography
    Theorem 3.75 in Lidl Niederreiter
    Let d >= 2 be an integer and alpha in F_{p^m}^{*}. Then
    the binomial x^d - alpha is irreducible in Fpm[x] if and only if
    the following two conditions are satisfied:
    1. each prime factor of d divides the order e of alpha in Fpm*,
        but not (p-1)/e;
    2. If d = 0 mod 4 then p^m = 1 mod 4.

    if Fq is not Fp, then the irreducible binomial x^d - xi maybe should
    be such that xi in Fq but not in Fp (that is, xi = a0 + i).

    In practice, this function is not working very well, it sometimes runs infinity loops I don't know why.
    """
    if d not in [3, 6, 4]:
        raise ValueError(
            "Error the twist degree should be in [3, 6, 4] but d={} given".format(d)
        )
    m = Fq.degree()
    if m == 1:
        i = 0
    else:
        i = Fq.gen(0)
    k = m * d
    if (
        m > 1
        and ((d * m % 4) != 0 or (Fq.characteristic() % 4) == 1)
        and (d * m != 16)
        and (d * m != 18)
        and (d * m != 36)
        and (d * m != 27 or (Fq.characteristic() % 27) == 1)
    ):
        find_mult_i = True
    else:
        find_mult_i = False
    print(
        "    p = {} mod {}, find_mult_i = {}".format(
            Fq.characteristic() % k, k, find_mult_i
        )
    )
    Fqz_ = Fq["z_"]
    (z_,) = Fqz_._first_ngens(1)
    if m == 1 or find_mult_i:
        ii = 1
    else:
        ii = 0
    if find_mult_i:
        xi = ii * i
    else:
        xi = i + ii
    order_Etw = False
    while not (z_**d - xi).is_irreducible():
        if ii <= 0:
            ii = -ii + 1
        else:
            ii = -ii
        if find_mult_i:
            xi = ii * i
        else:
            xi = i + ii
    # print("xi = {}".format(xi))
    # D_twist
    if d == 3:
        abtw = ab / xi**2
    else:
        abtw = ab / xi
    if d == 6 or d == 3:
        Etw = EllipticCurve([Fq(0), abtw])  # cubic or sextic twist
    elif d == 4:
        Etw = EllipticCurve([abtw, Fq(0)])  # quartic twist
    points_num = Etw.cardinality()
    order_Etw = points_num % r == 0
    if order_Etw:
        return Etw, xi, abtw, True
    # M_twist
    if d == 3:
        abtw = ab * xi**2
    else:
        abtw = ab * xi
    if d == 6 or d == 3:
        Etw = EllipticCurve([Fq(0), abtw])  # cubic or sextic twist
    elif d == 4:
        Etw = EllipticCurve([abtw, Fq(0)])  # quartic twist
    points_num = Etw.cardinality()
    order_Etw = points_num % r == 0
    if order_Etw:
        return Etw, xi, abtw, False
    else:
        raise Exception("Twist curve is not exist. xi = {}".format(xi))
