
PROGRAM MatrixMultiplication

IMPLICIT NONE

REAL, ALLOCATABLE :: A(:,:), B(:,:), C(:,:)
INTEGER :: i, j, k, n, m, p

! Define the dimensions of the matrices
n = 3 ! Number of rows of matrix A
m = 3 ! Number of columns of matrix A and rows of matrix B
p = 3 ! Number of columns of matrix B

! Allocate memory for the matrices
ALLOCATE(A(n,m), B(m,p), C(n,p))

! Initialize matrix A
A = RESHAPE([1.0, 2.0, 3.0, &
             4.0, 5.0, 6.0, &
             7.0, 8.0, 9.0], [n, m])

! Initialize matrix B
B = RESHAPE([9.0, 8.0, 7.0, &
             6.0, 5.0, 4.0, &
             3.0, 2.0, 1.0], [m, p])

! Perform matrix multiplication
C = 0.0 ! Initialize result matrix to zero
DO i = 1, n
   DO j = 1, p
      DO k = 1, m
         C(i,j) = C(i,j) + A(i,k) * B(k,j)
      END DO
   END DO
END DO

! Print the result
PRINT *, 'Matrix C = '
DO i = 1, n
   PRINT *, (C(i,j), j=1,p)
END DO

END PROGRAM MatrixMultiplication
