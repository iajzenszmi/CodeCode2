!ND<<<<<<< A SHAR FILE CONTAINING A C VERSION
!<<<<<<<< LOOK FOR <<<<<< AS A SEPARATOR
!
!<<< C version also provided by Larry Weissman >>>
!
!Subject: Re: TOMS algorithm 322
!Date: Tue, 29 Mar 94 15:34:51 -0800
!From: Larry Weissman 5-2011 <larryw@nsr.bioeng.washington.edu>
!To: ehg@research.att.com
!
!In netlib.att.com:/netlib/toms/322.Z:
!
!> Sorry, netlib does not have this algorithm online.  If you locate it
!> elsewhere, please email a copy to ehg@research.att.com.
!
!Below is a Fortran '77 coding of this algorithm, followed by a test program.
!
!Larry Weissman                         Center for Bioengineering, WD-12
!larryw@nsr.bioeng.washington.edu       Univ of Washington, Seattle WA 98195
!Phone: (206)685-2011                   FAX: (206)685-3300
!---------------------------------------------------------------------------

      FUNCTION PROB(LM,LN,X)
C
C          Probabilities in several variance distributions
C
C  References:
C     Egon Dorrer, "Algorithm 322: F-Distribution [S14]",
C         Communications of the ACM, Vol 11(2), 1968, p116-117.
C     J.B.F. Field, "Certification of Algorithm 322",
C         Communications of the ACM, Vol 12(1), 1969, p39.
C     Hubert Tolman, "Remark on Algorithm 322 [S14]",
C         Communications of the ACM, Vol 14(2), 1979, p117.
C
C  Probabilities are returned as the integral of P(q)dq for q
C  in the range zero to X (F-ratio and chi-square) or from -X to +X
C  (Student's t and Normal).
C
C  For F-ratios:
C     M = numerator degrees of freedom
C     N = denominator degrees of freedom
C     X = F-ratio
C  For Student's t (two tailed):
C     M = 1
C     N = Degrees of freedom
C     X = The square of t
C  For normal deviates (two tailed):
C     M = 1
C     N = 5000
C     X = The square of the deviate
C  For chi-square:
C     M = Degrees of freedom
C     N = 5000
C     X = Chi-square/M
C
C  The returned probability will be in the range 0 to 1, unless an error
C  occurred, in which case -1.0 is returned.
C  Recoded by LW, 28-Mar-94.
C
      INTEGER M,N,LM,LN,A,B,I,J
      REAL    X,W,Y,Z,D,P,ZK
C
      M  = MIN(LM,300)
      N  = MIN(LN,5000)
      IF(MIN(M,N) .LT. 1) THEN
          PROB = -1.0
          RETURN
      ENDIF
C
      A = 2*(M/2)-M+2
      B = 2*(N/2)-N+2
      W = X*FLOAT(M)/FLOAT(N)
      Z = 1.0/(1.0+W)
      IF(A .EQ. 1) THEN
          IF(B .EQ. 1)THEN
              P=SQRT(W)
              Y=0.3183098862
              D=Y*Z/P
              P=2.0*Y*ATAN(P)
          ELSE
              P=SQRT(W*Z)
              D=P*Z/(2.0*W)
          ENDIF
      ELSE
          IF(B .EQ. 1)THEN
              P=SQRT(Z)
              D=Z*P/2.0
              P=1.0-P
          ELSE
              D=Z*Z
              P=W*Z
          ENDIF
      ENDIF
      Y = 2.0*W/Z
      IF(A .EQ. 1) THEN
          DO 10 J=B+2,N,2
              D = (1.0 + FLOAT(A)/FLOAT(J-2)) * D * Z
              P = P + D * Y/FLOAT(J-1)
10        CONTINUE
      ELSE
          ZK = Z**((N-1)/2)
          D  = D * ZK * N/B
          P  = P * ZK + W * Z * (ZK-1.0)/(Z-1.0)
      ENDIF
      Y = W * Z
      Z = 2.0/Z
      B = N-2
      DO 20 I=A+2,M,2
          J = I + B
          D = (Y*D*FLOAT(J))/FLOAT(I-2)
20        P = P - Z * D/FLOAT(J)
      PROB = MAX(0.0,MIN(1.0,P))
      RETURN
      END

!-------------


      PROGRAM tstprob
c
c  Test function prob() that generates critical values of standard
c  probability functions
c
c  L. Weissman 29-Mar-94  larryw@bioeng.washington.edu
c
      PARAMETER (NZ=13)
      REAL      z(NZ),pz(NZ)
      PARAMETER (NT=25)
      REAL      t(NT),pt(NT)
      INTEGER   nut(NT)
      PARAMETER (NX=25)
      REAL      x(NX),px(NX)
      INTEGER   nux(NX)
      PARAMETER (NF=100)
      REAL      f(NF),pf(NF)
      INTEGER   nf1(NF),nf2(NF)
c
      DATA  z/4.417, 3.891, 3.291, 2.576, 2.241,
     1        1.960, 1.645, 1.150, 0.674, 0.319,
     2        0.126, 0.063, 0.0125/
      DATA pz/1.e-5, 1.e-4, 1.e-3, 1.e-2, 0.025,
     1        0.050, 0.100, 0.250, 0.500, 0.750,
     2        0.900, 0.950, 0.990/
c
      DATA   t/1.000, 0.817, 0.700, 0.687, 0.677,
     1         6.314, 2.920, 1.813, 1.725, 1.658,
     2        12.706, 4.303, 2.228, 2.086, 1.980,
     3        63.657, 9.925, 3.169, 2.845, 2.617,
     4        127.32,14.089, 3.581, 3.153, 2.860/
      DATA nut/    1,     2,    10,    20,   120,
     1             1,     2,    10,    20,   120,
     2             1,     2,    10,    20,   120,
     3             1,     2,    10,    20,   120,
     4             1,     2,    10,    20,   120/
      DATA  pt/0.500, 0.500, 0.500, 0.500, 0.500,
     1         0.100, 0.100, 0.100, 0.100, 0.100,
     2         0.050, 0.050, 0.050, 0.050, 0.050,
     3         0.010, 0.010, 0.010, 0.010, 0.010,
     4         0.005, 0.005, 0.005, 0.005, 0.005/
c
      DATA   x/ 0.45,  1.39,  9.34, 19.34, 99.33,
     1          3.84,  5.99, 18.31, 31.41,124.34,
     2          5.02,  7.38, 20.48, 34.17,129.56,
     3          6.63,  9.21, 23.21, 37.57,135.81,
     4          7.88, 10.60, 25.19, 40.00,140.17/
      DATA nux/    1,     2,    10,    20,   100,
     1             1,     2,    10,    20,   100,
     2             1,     2,    10,    20,   100,
     3             1,     2,    10,    20,   100,
     4             1,     2,    10,    20,   100/
      DATA  px/0.500, 0.500, 0.500, 0.500, 0.500,
     1         0.050, 0.050, 0.050, 0.050, 0.050,
     2         0.025, 0.025, 0.025, 0.025, 0.025,
     3         0.010, 0.010, 0.010, 0.010, 0.010,
     4         0.005, 0.005, 0.005, 0.005, 0.005/
c
      DATA   f/ 16211.,198.50,12.826,9.9439,8.1790,
     1          20000.,199.00,9.4270,6.9865,5.5393,
     2          24224.,199.40,5.8467,3.8470,2.7052,
     3          24836.,199.45,5.2740,3.3178,2.1881,
     4          25359.,199.49,4.7501,2.8058,1.6055,

     5          4052.2,98.503,10.044,8.0960,6.8510,
     6          4999.5,99.000,7.5594,5.8489,4.7865,
     7          6055.8,99.399,4.8492,3.3682,2.4721,
     8          6208.7,99.490,4.4054,2.9377,2.0346,
     9          6339.4,99.491,3.9965,2.5168,1.5330,

     A          161.45,18.513,4.9646,4.3513,3.9201,
     B          199.50,19.000,4.1028,3.4928,3.0718,
     C          241.88,19.396,2.9782,2.3479,1.9105,
     D          248.01,19.446,2.7740,2.1242,1.6587,
     E          253.25,19.487,2.5801,1.8963,1.3519,

     F          1.0000,.66667,.48973,.47192,.45774,
     G          1.5000,1.0000,.74349,.71773,.69717,
     H          2.0419,1.3450,1.0000,.96626,.93943,
     I          2.1190,1.3933,1.0349,1.0000,.97228,
     J          2.1848,1.4344,1.0645,1.0285,1.0000/
      DATA nf1/ 5* 1, 5  *2, 5* 10, 5* 20, 5*120,
     1          5* 1, 5  *2, 5* 10, 5* 20, 5*120,
     2          5* 1, 5  *2, 5* 10, 5* 20, 5*120,
     3          5* 1, 5  *2, 5* 10, 5* 20, 5*120/
      DATA nf2/1,2,10,20,120,1,2,10,20,120,1,2,10,20,120,1,2,10,20,120,
     1         1,2,10,20,120,1,2,10,20,120,1,2,10,20,120,1,2,10,20,120,
     2         1,2,10,20,120,1,2,10,20,120,1,2,10,20,120,1,2,10,20,120,
     3         1,2,10,20,120,1,2,10,20,120,1,2,10,20,120,1,2,10,20,120,
     4         1,2,10,20,120,1,2,10,20,120,1,2,10,20,120,1,2,10,20,120/
      DATA  pf/25*0.005, 25*0.01, 25*0.05, 25*0.50/
c
10    FORMAT(/15x,a//4x,
     1'n1   n2       x      p-exp       p-calc      e-diff     e-rel'/
     22x,
     3'---- ----    ------  ----------  ----------  ----------   -----')
c
      WRITE(*,10)'Testing two-tailed normal distribution'
      DO 20 i=1,NZ
          p=1.0-prob(1,5000,z(i)**2)
          CALL report(1,5000,z(i),pz(i),p)
20    CONTINUE
c
      WRITE(*,10)'Testing two-tailed Student''s t'
      DO 30 i=1,NT
          p=1.0-prob(1,nut(i),t(i)**2)
          CALL report(1,nut(i),t(i),pt(i),p)
30    CONTINUE
c
      WRITE(*,10)'Testing chi-square distribution'
      DO 40 i=1,NX
          p=1.0-prob(nux(i),5000,x(i)/nux(i))
          CALL report(nux(i),5000,x(i),px(i),p)
40    CONTINUE
c
      WRITE(*,10)'Testing F distribution'
      DO 50 i=1,NF
          p=1.0-prob(nf1(i),nf2(i),f(i))
          CALL report(nf1(i),nf2(i),f(i),pf(i),p)
50    CONTINUE
      STOP
      END

      SUBROUTINE report(n1,n2,x,pexp,pcalc)
c
c  Report the difference between the expected probability pexp and
c  the calculated probability pcalc. Also report the relative error.
c
      pdiff = ABS(pexp-pcalc)
      prel  = 0.0
      IF(ABS(pexp) .GT. 1.e-30) prel = pdiff/pexp
      WRITE(*,10)n1,n2,x,pexp,pcalc,pdiff,prel
10    FORMAt(1x,i5,i5,f10.4,3g12.4,f8.3)
      RETURN
      END
