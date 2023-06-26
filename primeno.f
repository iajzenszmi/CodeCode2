      PROGRAM PrimeNumbers
      IMPLICIT NONE

      INTEGER :: num, divisor, count

      count = 0
      num = 2

      DO WHILE (count < 10)
         divisor = 2
         DO WHILE (divisor < num)
            IF (MOD(num, divisor) == 0) THEN
               EXIT
            END IF
            divisor = divisor + 1
         END DO

         IF (divisor == num) THEN
            WRITE(*,*) num
            count = count + 1
         END IF

         num = num + 1
      END DO

      END PROGRAM PrimeNumbers
