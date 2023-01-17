#!gams: C7e
#title: GRATIO and GAMINV
#for: incomplete gamma function ratios and their inverse
#by: A. R. DiDonato and A. H. Morris, Jr.
#ref: ACM TOMS 13 (1987) 318-319
#implement in python3 and debug syntax and runtime errors
#gams: C7e
#title: GRATIO and GAMINV
#for: incomplete gamma function ratios and their inverse
#by: A. R. DiDonato and A. H. Morris, Jr.
#ref: ACM TOMS 13 (1987) 318-319
#
#subroutine gaminv(p,x,q)

#def gaminv(p,x,q,results):
"""
    Calculate GRATIO and GAMINV.

    Parameters
    ----------
    p : float
        The value of p.
    x : float
        The value of x.
    q : float
        The value of q.

    Returns
    -------
    result : float
        The result of the GRATIO and GAMINV calculation.
"""
a = 0.0
b = 0.0
c = 0.0
d = 0.0
e = 0.0
f = 0.0
g = 0.0
h = 0.0
j = 0.0
k1 = 0.0
k2 = 0.0
if p < 0 or q < 0 or (x < 0 and p + q > 1):
        result = 0.0
    else:
        if p + q > 1:
            if x > 0:
                a = 1 - p - q
                b = a + x + 1
                c = 0
            else:
                a = p + q - 1
                b = a + x + 1
        else:
            a = 1 - p - q
            b = a + x + 1
            c = 0
        d = 15 * (a + b + c)
        e = d - 15
        f = 0
        g = 1
        h = 1
        k1 = 0
        j = 1
        while g != 0:
            k2 = k1
            k1 = h
            h = j * (q - j) * x / ((a + 2 * j) * (a + 2 * j + 1))
            f = f + h
            g = abs(h / k1)
            j = j + 1
            if j > e:
                result = k2 * (1 - p - q + x) ** a * x ** (-x) * f
                break
                gaminv(4.0,5.8,6.9,results)
                print(results)
                return 
#gaminv(4.0,7.0,8.0,results)
