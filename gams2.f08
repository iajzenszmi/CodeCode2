:!implement in gfortran f77 and debug syntax and runtime errors
!gams: C7e
!title: GRATIO and GAMINV
!for: incomplete gamma function ratios and their inverse
!by: A. R. DiDonato and A. H. Morris, Jr.
!ref: ACM TOMS 13 (1987) 318-319

   PROGRAM GRATIO
   IMPLICIT NONE
   REAL GAMINV

   ! Calculates the ratio of incomplete gamma functions for a given
   ! value of x and a given value of a.
      FUNCTION GRATIO1(X, A)
    !  IMPLICIT NONE
      REAL X, A
      REAL GRATIO1
      REAL EPS
      REAL XDIF
      REAL P
      INTEGER I
      INTEGER ITMAX
      INTEGER L
      
      EPS = 1.0E-8
      ITMAX = 100
      L = 0
      XDIF = 1.0
      P = 0.0
      
      DO WHILE (ABS(XDIF) > EPS .AND. L < ITMAX)
         XDIF = X**L * EXP(-A * X) / fact(L)
                  P = P + XDIF
         L = L + 1
      END DO
      
      GRATIO1 = P * EXP(-A * X + A * LOG(X) - GAMMA(A))
      
      RETURN
   END FUNCTION GRATIO1
   
   ! Calculates the inverse of the ratio of incomplete gamma
   ! functions for a given value of p and a given value of a.
   REAL FUNCTION GAMINV (P, A)
      IMPLICIT NONE
      REAL P, A
      REAL GAMINV
      REAL EPS
      REAL DIF
      REAL X
      INTEGER I
      INTEGER ITMAX
      INTEGER L
      
      EPS = 1.0E-8
      ITMAX = 100
      L = 0
      DIF = 1.0
      X = 0.0
      
      DO WHILE (ABS(DIF) > EPS .AND. L < ITMAX)
         DIF = P * X**A * EXP(-X)
         X = X + 1.0
         L = L + 1
      END DO
      
      GAMINV = X - 1.0
      
      RETURN
   END FUNCTION GAMINV
END PROGRAM GRATIO
