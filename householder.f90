        
        PROGRAM HouseholderReduction
  IMPLICIT NONE
  INTEGER, PARAMETER :: N = 4
  REAL(8) :: A(N,N), V(N,N), d(N), e(N)
  INTEGER :: i, j

  ! Example symmetric matrix
  DATA A / 4.0D0, 2.0D0, 2.0D0, 2.0D0, &
             2.0D0, 3.0D0, 1.0D0, 1.0D0, &
             2.0D0, 1.0D0, 3.0D0, 1.0D0, &
             2.0D0, 1.0D0, 1.0D0, 3.0D0 /

  ! Print initial matrix
  PRINT *, "Initial Matrix:"
  DO i = 1, N
     PRINT *, (A(i,j), j = 1, N)
  END DO

  CALL Householder(A, N, d, e, V)

  ! Print tridiagonal elements
  PRINT *, "Diagonal elements (d):", d
  PRINT *, "Off-diagonal elements (e):", e

  ! Print orthogonal matrix V
  PRINT *, "Orthogonal Matrix (V):"
  DO i = 1, N
     PRINT *, (V(i,j), j = 1, N)
  END DO

CONTAINS

  SUBROUTINE Householder(A, n, d, e, V)
    REAL(8), INTENT(IN) :: A(n,n)
    REAL(8), INTENT(OUT) :: d(n), e(n), V(n,n)
    REAL(8) :: scale, h, f, g, r
    INTEGER :: i, j, k, l,n

    V = A

    DO i = n, 2, -1
      l = i - 1
      h = 0.0D0
      scale = 0.0D0

      IF (l > 1) THEN
        DO k = 1, l
          scale = scale + ABS(V(i,k))
        END DO

        IF (scale == 0.0D0) THEN
          e(i) = V(i,l)
        ELSE
          DO k = 1, l
            V(i,k) = V(i,k) / scale
            h = h + V(i,k) * V(i,k)
          END DO

          f = V(i,l)
          g = -DSIGN(SQRT(h), f)
          e(i) = scale * g
          h = h - f * g
          V(i,l) = f - g
          f = 0.0D0

          DO j = 1, l
            V(j,i) = V(i,j) / h
            g = 0.0D0
            DO k = 1, j
              g = g + V(j,k) * V(i,k)
            END DO
            DO k = j+1, l
              g = g + V(k,j) * V(i,k)
            END DO
            e(j) = g / h
            f = f + e(j) * V(i,j)
          END DO

          h = f / (h + h)
          DO j = 1, l
            f = V(i,j)
            e(j) = e(j) - h * f
            DO k = 1, j
              V(j,k) = V(j,k) - f * e(k) - V(i,k) * e(j)
            END DO
          END DO
        END IF

        d(i) = h

      ELSE
        d(i) = 0.0D0
        e(i) = 0.0D0
      END IF
    END DO

    d(1) = 0.0D0
    e(1) = 0.0D0

    ! Form V
    DO i = 1, n
      l = i - 1

      IF (d(i) /= 0.0D0) THEN
        DO j = 1, l
          g = 0.0D0
          DO k = 1, l
            g = g + V(i,k) * V(k,j)
          END DO

          DO k = 1, l
            V(k,j) = V(k,j) - g * V(k,i)
          END DO
        END DO
      END IF

      d(i) = V(i,i)
      V(i,i) = 1.0D0

      DO j = 1, l
        V(i,j) = 0.0D0
        V(j,i) = 0.0D0
      END DO

    END DO

  END SUBROUTINE Householder

END PROGRAM HouseholderReduction
