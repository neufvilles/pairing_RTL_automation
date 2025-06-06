from sage.all import Integer


def test_order(E, order):
    """Test with 10 random points that the curve order corresponds

    INPUT:
    - `E`: elliptic curve (EllipticCurve class instance)
    - `order`: Integer

    RETURNS: True/False
    """
    ok = True
    i = 0
    while ok and i < 10:
        P = E.random_element()
        ok = order * P == E(0)
        i += 1
    print("{}".format(ok))
    return ok


def double_line_h_a0_twist6_aklgl(S, P, BT, D_twist=False):
    """
    Computes 2*S and l_{S,S}(P) in Homogeneous coordinates (X,Y,Z) and (x,y) = (X/Z,Y/Z)

    b' is the curve parameter for E', the sextic twist of E.
    E': y^2 = x^3 + b' = x^3 + b/xi and E' is a D-twist of E
    xi is the non-residue s.t. Fp6 = Fq[w]/(w^6-xi)

    For BLS12 curves, xi in Fp2
    For BW6_761 curve, xi in Fp.
    Faster Explicit Formulas for Computing Pairings over Ordinary Curves
    Catherine H. Gebotys, Koray Karabina, Patrick Longa, Julio Lopez, Diego F. Aranha
    http://www.iacr.org/archive/eurocrypt2011/66320047/66320047.pdf
    https://eprint.iacr.org/2010/526 Section 4 [Aranha Karabina Longa Gebotys Lopez Eurocrypt'11]
    Fp2 = Fp[i]/(i^2-beta), beta = -1
    Fp6 = Fp2[v]/(v^3-xi), xi = (1+i)
    Fp12 = Fp6[w]/(w^2 - v)
    E:  y^2 = x^3 + 2
    xi = (1+i)
    E': y^2 = x^3 + 2/(1+i) = x^3 + (1-i) -> b' = 1-i and E' is a D-twist
    G2 x G1 pairing:
    3m_{k/d} + 6s_{k/d} + 2*k/d*m
    G1 x G2 pairing:
    3m + 6s + 2*k/d*m

    """
    X1, Y1, Z1 = S
    xP, yP = P
    # Homogeneous coordinates: Z*Y^2 = X^3 + b'*Z^3 <=> (Y/Z)^2 = (X/Z)^3 + b'
    # note that Y^2 - b'*Z^2 = X^3/Z
    # D-twist: y^2 = x^3 + b/xi (multiply by xi=w^6) => w^6*y^2 = w^6*x^3 + b
    #                                                  <=> (w^3*y)^2 = (w^2*x)^3+b
    # psi: (x',y') -> (x'*w^2,y'*w^3) <-> (x',y'*w,1/w^2)
    # so that Y^2*Z is in Fq (no w^i term)
    # X3 = X1*Y1/2 * (Y1**2-9*b'*Z1**2)
    # Y3 = ((Y1**2+9*b'*Z1**2)/2)**2 - 27*b'**2*Z1**4
    # Z3 = 2*Y1**3*Z1
    # ln = ((-2*Y1*Z1*yP)*v*w + (3*X1**2*xP)*v**2 + xi*(3*b'*Z1**2-Y1**2))
    # with v=w^2, xi = w^6, this is
    # ln = xi*(3*b'*Z1**2-Y1**2) + (-2*Y1*Z1*yP)*w^3 + (3*X1**2*xP)*w**4

    A = X1 * Y1 / 2  # M
    B = Y1**2  # S
    C = Z1**2  # S
    D = 3 * C  # 3*Z1^2
    E = BT * D  # 3*BT*Z1^2
    F = 3 * E  # 9*BT*Z1^2
    X3 = A * (B - F)  # M   A*(B-9*BT*C) = X1*Y1/2*(Y1^2-9*BT*Z1^2)
    G = (B + F) / 2  # (Y1^2 + 9*BT*Z1^2)/2
    Y3 = G**2 - 3 * E**2  # 2S  (Y1^2 + 9*BT*Z1^2)^2/4 -3*(3*BT*Z1^2)^2
    H = (Y1 + Z1) ** 2 - (B + C)  # S   2*Y1*Z1
    Z3 = B * H  # M   2*Y1^3*Z1
    I = E - B  # 3*BT*Z1^2-Y1^2
    J = X1**2  # S
    l3 = I
    l0 = H * (-yP)  # k/d*m
    l1 = 3 * J * xP  # k/d*m
    if D_twist:
        ln = [l0, l1, 0, l3, 0, 0]
        # AKLGL: multiply line by w^3 i.e. rotate by 3 to the right the vector -> now we have l3*w^6 = l3*xi at position 0
        # ln = (l3*xi,0,0,l0,l1,0)
        # and (l3*xi,0,l1) + (0,l0,0) as (Fq3)^2
        #     (l3*xi,0,xP*ll1) + (0,-yP*ll0,0)
    else:
        ln = [l3, 0, l1, l0, 0, 0]
    return ln, (X3, Y3, Z3)  # 3M + 6S + 2*k/d*m


def sparse_mult_m6_twist(l0, l2, l3, f, xi, Fq6):
    """
    cost 13 mult in Fq
    source: PhD thesis A. Guillevic 2013 p. 91 Sect. 3.2.2
    https://tel.archives-ouvertes.fr/tel-00921940

    Tate pairing: l0 in Fp instead of Fq. Replace 3 me by 2*3*m = 6m
    """
    # print("f= {}\nf.polynomial()={}\nf.polynomial().list()={}\n".format(f, f.polynomial(), f.polynomial().list()))
    # problem of type in Python sometimes here
    if Fq6.base_ring().degree() == 1:
        coeffs = f.polynomial().list()
    else:
        coeffs = f.list()
    if len(coeffs) < 6:
        coeffs += [0] * (6 - len(coeffs))
    (f0, f1, f2, f3, f4, f5) = coeffs
    l0f0 = l0 * f0
    l2f2 = l2 * f2
    l3f5 = l3 * f5
    h2 = xi * l3f5 + (l0 + l2) * (f0 + f2) - l0f0 - l2f2
    l2f4 = l2 * f4
    l3f3 = l3 * f3
    h0 = l0f0 + xi * (l2f4 + l3f3)
    l2f1 = l2 * f1
    h3 = l2f1 + (l0 + l3) * (f0 + f3) - l0f0 - l3f3
    l0f4 = l0 * f4
    l3f1 = l3 * f1
    h4 = l2f2 + l0f4 + l3f1
    l0f5 = l0 * f5
    h5 = l0f5 + (l2 + l3) * (f2 + f3) - l2f2 - l3f3
    h1 = (
        (l0 + l2 + l3) * (f1 + xi * (f4 + f5))
        - xi * (l0f4 + l0f5 + l2f4 + l3f5)
        - l2f1
        - l3f1
    )
    return Fq6([h0, h1, h2, h3, h4, h5])


def sparse_mult_d6_twist(l0, l1, l3, f, xi, Fq6):
    """
    cost 13 mult in Fq
    source: PhD thesis A. Guillevic 2013 p. 91 Sect. 3.2.2
    https://tel.archives-ouvertes.fr/tel-00921940
    """
    # print("f= {}\nf.polynomial()={}\nf.polynomial().list()={}\n".format(f, f.polynomial(), f.polynomial().list()))
    if Fq6.base_ring().degree() == 1:
        coeffs = f.polynomial().list()
    else:
        coeffs = f.list()
    if len(coeffs) < 6:
        coeffs += [0] * (6 - len(coeffs))
    (f0, f1, f2, f3, f4, f5) = coeffs
    l1f5 = l1 * f5
    l0f0 = l0 * f0
    l3f3 = l3 * f3
    h0 = l0f0 + xi * (l1f5 + l3f3)
    l1f1 = l1 * f1
    l3f4 = l3 * f4
    h1 = (l0 + l1) * (f0 + f1) - l0f0 - l1f1 + xi * l3f4
    l0f2 = l0 * f2
    l3f5 = l3 * f5
    h2 = l0f2 + l1f1 + xi * l3f5
    l1f2 = l1 * f2
    h3 = l1f2 + (l0 + l3) * (f0 + f3) - l0f0 - l3f3
    l0f4 = l0 * f4
    h4 = l0f4 + (l1 + l3) * (f1 + f3) - l1f1 - l3f3
    h5 = (l0 + l1 + l3) * (f2 + f4 + f5) - (l0f4 + l1f2 + l1f5 + l3f4 + l0f2 + l3f5)
    return Fq6([h0, h1, h2, h3, h4, h5])


def add_line_h_a0_twist6_aklgl(S, Q, P, D_twist=False):
    """computes S+Q and l_{S,Q}(P), Q,S in Homogeneous coordinates, P affine

    INPUT:
    - `S`: point in Homogeneous coordinates (X, Y, Z)
    - `Q`: point in affine coordinates (xQ, yQ)
    - `P`: point in affine coordinates (xP, yP)

    RETURN: line through S, Q evaluated at P, point S+Q=(X',Y',Z')
    affine coordinates satisfy (x,y) = (X/Z,Y/Z)
    If S,Q have coordinates in F_{p^k/d} and P has coordinates in F_p, it costs
    G2 x G1 pairing:
    11*m_{k/d} + 2*s_{k/d} + 2*k/d*m_1
    G1 x G2 pairing:
    11*m + 2*s + 2*k/d*m

    Algorithm 12 in eprint 2010/526
    """
    (X1, Y1, Z1) = S
    (X2, Y2) = Q
    (xP, yP) = P
    t1 = Z1 * X2
    t2 = Z1 * Y2  # 2M
    t1 = X1 - t1
    t2 = Y1 - t2
    # D = X1 - Z1*X2 -> t1
    # E = Y1 - Y2*Z1 -> t2
    t3 = t1**2  # S
    # F = D^2 -> t1^2 -> t3
    X3 = t3 * X1
    t4 = t2**2  # M+S
    # I = X1*F -> X3
    # G = E^2 -> t2^2 -> t4
    t3 = t1 * t3
    t4 = t4 * Z1  # 2M
    # H = D*F -> t1*t3 -> t3
    # J = H + Z1*G - 2*I -> t3 + t4 -2*X3
    t4 = t4 + t3
    t4 = t4 - X3
    t4 = t4 - X3  # J -> t4
    X3 = X3 - t4
    T1 = t2 * X3
    T2 = t3 * Y1  # 2M
    T2 = T1 - T2
    Y3 = T2
    X3 = t1 * t4
    Z3 = t3 * Z1  # 2M
    lx = -t2 * xP  # k/d*m  lx=-(Y1-Z1*Y2)*xP
    T1 = t2 * X2  # M
    T2 = t1 * Y2  # M
    l0 = T1 - T2  # l0=(Y1-Z1*Y2)*X2-(X1-Z1*X2)*Y2
    ly = t1 * yP  # k/d*m  ly=(X1-Z1*X2)*yP
    if D_twist:
        ln = [ly, lx, 0, l0, 0, 0]  # *w^3 -> (l0*xi,0,0,ly,lx,0)
    else:
        ln = [l0, 0, lx, ly, 0, 0]
    return ln, (X3, Y3, Z3)  # 11M + 2S + 2*k/d*m


def miller_function_ate_aklgl(Q, P, BT, T, Fq6, D_twist=False, m0=1, xi=None):
    """
    If T < 0, then f_{|T|, -Q}(P) is computed thanks to the formula
    f_{uv,Q} = f_{u,Q}^v*f_{v,[u]Q} and with u=-1, v=|T|:
    f_{-|T|,Q} = f_{-1,Q}^|T|*f_{|T|,-Q} and since f_{-1,Q} is a vectical line,
    it is discarded: f_{-|T|,Q} = f_{|T|,-Q}.
    """
    if xi is None:
        # xi = -Fq6.polynomial().constant_coefficient() # works only for absolute extensions on prime fields
        xi = (
            -Fq6.modulus().constant_coefficient()
        )  # works with absolute and towering of extension
    m = m0
    with_m0 = m0 != 1
    S = (Q[0], Q[1], 1)
    QQ = (Q[0], Q[1])
    PP = (P[0], P[1])
    negative_T = T < 0
    if negative_T:
        T = -T
        QQ = (Q[0], -Q[1])
        S = (Q[0], -Q[1], 1)
    loop = Integer(T).digits(2)
    # very first step: no "m = m**2" needed
    bi = loop[len(loop) - 2]
    ln, S = double_line_h_a0_twist6_aklgl(S, PP, BT, D_twist=D_twist)
    if with_m0:
        m = m**2
        if D_twist:
            l0 = ln[0]
            l1 = ln[1]
            l3 = ln[3]
            m = sparse_mult_d6_twist(l0, l1, l3, m, xi, Fq6)
        else:
            l0 = ln[0]
            l2 = ln[2]
            l3 = ln[3]
            m = sparse_mult_m6_twist(l0, l2, l3, m, xi, Fq6)
    else:
        m = Fq6(ln)
    if bi == 1:
        if with_m0:
            m = m * m0
        ln, S = add_line_h_a0_twist6_aklgl(S, QQ, PP, D_twist=D_twist)
        if D_twist:
            l0 = ln[0]
            l1 = ln[1]
            l3 = ln[3]
            m = sparse_mult_d6_twist(l0, l1, l3, m, xi, Fq6)
        else:
            l0 = ln[0]
            l2 = ln[2]
            l3 = ln[3]
            m = sparse_mult_m6_twist(l0, l2, l3, m, xi, Fq6)
    for i in range(len(loop) - 3, -1, -1):
        bi = loop[i]
        ln, S = double_line_h_a0_twist6_aklgl(S, PP, BT, D_twist=D_twist)
        m = m**2
        if D_twist:
            l0 = ln[0]
            l1 = ln[1]
            l3 = ln[3]
            m = sparse_mult_d6_twist(l0, l1, l3, m, xi, Fq6)
        else:
            l0 = ln[0]
            l2 = ln[2]
            l3 = ln[3]
            m = sparse_mult_m6_twist(l0, l2, l3, m, xi, Fq6)
        if bi == 1:
            if with_m0:
                m = m * m0
            ln, S = add_line_h_a0_twist6_aklgl(S, QQ, PP, D_twist=D_twist)
            if D_twist:
                l0 = ln[0]
                l1 = ln[1]
                l3 = ln[3]
                m = sparse_mult_d6_twist(l0, l1, l3, m, xi, Fq6)
            else:
                l0 = ln[0]
                l2 = ln[2]
                l3 = ln[3]
                m = sparse_mult_m6_twist(l0, l2, l3, m, xi, Fq6)
    return m, S


def final_exp_easy_k12(m):
    # embedding degree k=12, easy part is (p^12-1)/Phi_12(p) = (p^6-1)*(p^2+1)
    mp6 = m.frobenius(6)
    im = 1 / m
    f = mp6 * im  # m^(q^6-1)
    f = f * f.frobenius(2)  # m^((q^6-1)*(q^2+1))
    return f


def final_exp_hard_bls12(m, u):
    """
    https://eprint.iacr.org/2020/875
    Efficient Final Exponentiation via Cyclotomic Structure for
    Pairings over Families of Elliptic Curves
    Daiki Hayashida, Kenichiro Hayasaka, and Tadanori Teruya
    page 14

    exponent = (u-1)^2/3 * (q + x) * (q^2 + u^2 - 1) + 1
    3*exponent = (u-1)^2 * (q + x) * (q^2 + u^2 - 1) + 3
    cost 2*exp(u-1) + 3*exp(u) + 5 M + S + 2f + f6
    """
    m1 = m ** (u - 1)
    m1 = m1 ** (u - 1)
    m2 = m1**u
    m1 = m1.frobenius() * m2
    m1 = m1.frobenius(2) * (m1**u) ** u * m1.frobenius(6)
    return m1 * m**2 * m


def final_exp_bls12(m, u):
    f = final_exp_easy_k12(m)
    g = final_exp_hard_bls12(f, u)
    return g


def ate_pairing_bls12_aklgl(Q, P, BT, u0, Fq6, map_Fp12_Fp12_A, D_twist=False):
    m, S = miller_function_ate_aklgl(Q, P, BT, u0, Fq6, D_twist=D_twist, m0=1)
    # convert m from tower field to absolute field
    m = map_Fp12_Fp12_A(m)
    f = final_exp_bls12(m, u0)
    return f


def test_ate_pairing_bls12_aklgl(
    E, E2, r, c, c2, t_1, Fq6, map_Fp12_Fp12_A, D_twist=False
):
    P = c * E.random_element()
    while P == E(0) or r * P != E(0):
        P = c * E.random_element()
    Q = c2 * E2.random_element()
    while Q == E2(0) or r * Q != E2(0):
        Q = c2 * E2.random_element()
    f = ate_pairing_bls12_aklgl(
        Q, P, E2.a6(), t_1, Fq6, map_Fp12_Fp12_A, D_twist=D_twist
    )
    ok = True
    bb = 1
    while ok and bb < 4:
        Qb = bb * Q
        aa = 1
        while ok and aa < 4:
            Pa = aa * P
            fab = ate_pairing_bls12_aklgl(
                Qb, Pa, E2.a6(), t_1, Fq6, map_Fp12_Fp12_A, D_twist=D_twist
            )
            fab_expected = f ** (aa * bb)
            ok = fab == fab_expected
            aa += 1
        bb += 1
    print(
        "test_ate_pairing_bls12_aklgl (bilinear): {} ({} tests)".format(
            ok, (aa - 1) * (bb - 1)
        )
    )
    return ok


def final_exp_easy_k24(m):
    # embedding degree k=24, easy part is (p^24-1)/Phi_24(p) = (p^12-1)*(p^4+1)
    mp12 = m.frobenius(12)
    im = 1 / m
    f = mp12 * im  # m^(q^12-1)
    f = f * f.frobenius(4)  # m^((q^12-1)*(q^4+1))
    return f


def final_exp_hard_bls24(m, u):
    """
    https://eprint.iacr.org/2020/875
    Efficient Final Exponentiation via Cyclotomic Structure for
    Pairings over Families of Elliptic Curves
    Daiki Hayashida, Kenichiro Hayasaka, and Tadanori Teruya
    page 15

    (p^8-p^4+1)/r = (u-1)^2/3*(u+p)*(u^2+p^2)*(u^4+p^4-1) + 1
    cost exp(|u-1|) + exp(|u-1|/3) + 7*exp(|u|) + 5 M + f + f2 + f4 (+ cj if u<0)
    """
    u_ = abs(u)
    u1 = abs(u - 1)
    u3 = u1 // 3
    m1 = m**u1  # exp(|u-1|)
    m1 = m1**u3  # exp(|u-1|/3)
    mu = m1**u_  # exp(|u|)
    if u < 0:
        mu = mu.conjugate()  # if u<0: cj
    m1 = m1.frobenius() * mu  # M + f
    m1 = m1.frobenius(2) * (m1**u_) ** u_  # 2 exp(|u|) + M + f2
    m1 = (
        (((m1**u_) ** u_) ** u_) ** u_ * m1.frobenius(4) * m1.conjugate()
    )  # 4 exp(|u|) + 2 M + f4 + cj
    return m1 * m


def final_exp_bls24(m, u):
    f = final_exp_easy_k24(m)
    g = final_exp_hard_bls24(f, u)
    return g


def ate_pairing_bls24_aklgl(Q, P, BT, u0, Fq6, map_Fp24_Fp24_A, D_twist=False):
    m, S = miller_function_ate_aklgl(Q, P, BT, u0, Fq6, D_twist=D_twist, m0=1)
    # convert m from tower field to absolute field
    m = map_Fp24_Fp24_A(m)
    f = final_exp_bls24(m, u0)
    return f


def test_ate_pairing_bls24_aklgl(
    E, E2, r, c, c2, t_1, Fq6, map_Fp24_Fp24_A, D_twist=False
):
    P = c * E.random_element()
    while P == E(0) or r * P != E(0):
        P = c * E.random_element()
    Q = c2 * E2.random_element()
    while Q == E2(0) or r * Q != E2(0):
        Q = c2 * E2.random_element()
    f = ate_pairing_bls24_aklgl(
        Q, P, E2.a6(), t_1, Fq6, map_Fp24_Fp24_A, D_twist=D_twist
    )
    ok = True
    bb = 1
    while ok and bb < 4:
        Qb = bb * Q
        aa = 1
        while ok and aa < 4:
            Pa = aa * P
            fab = ate_pairing_bls24_aklgl(
                Qb, Pa, E2.a6(), t_1, Fq6, map_Fp24_Fp24_A, D_twist=D_twist
            )
            fab_expected = f ** (aa * bb)
            ok = fab == fab_expected
            aa += 1
        bb += 1
    print(
        "test_ate_pairing_bls24_aklgl (bilinear): {} ({} tests)".format(
            ok, (aa - 1) * (bb - 1)
        )
    )
    return ok
