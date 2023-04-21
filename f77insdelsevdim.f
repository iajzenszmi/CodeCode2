      PROGRAM ARRAY_MANIPULATION
      IMPLICIT NONE

      INTEGER A(2, 2, 2, 2, 2, 2, 2)
      INTEGER I, J, K, L, M, N, O
      INTEGER INSERT_POSITION, NEW_VALUE

      ! Initialize the array
      DO I = 1, 2
        DO J = 1, 2
          DO K = 1, 2
            DO L = 1, 2
              DO M = 1, 2
                DO N = 1, 2
                  DO O = 1, 2
                    A(I, J, K, L, M, N, O) = (I * 1000000) + (J * 100000) + (K * 10000) + (L * 1000) + (M * 100) + (N * 10) + O
                  END DO
                END DO
              END DO
            END DO
          END DO
        END DO
       END DO
      ! Insert a value at a specific position
      INSERT_POSITION = 1
      NEW_VALUE = 999
      print *, I, J,K,L, M, N, O
      print *,A
      print *,"------------------------------------------------"
          ! Simulate insertion by shifting elements forward
      DO I = 2, 1, -1
        DO J = 2, 1, -1
          DO K = 2, 1, -1
            DO L = 2, 1, -1
              DO M = 2, 1, -1
                DO N = 2, 1, -1
                  DO O = 2, 1, -1
                    IF ((I * J * K * L * M * N * O) .GT. INSERT_POSITION) THEN
                      A(I, J, K, L, M, N, O) = A(I - 1, J - 1, K - 1, L - 1, M - 1, N - 1, O - 1)
                    END IF
                  END DO
                END DO
              END DO
            END DO
          END DO
        END DO
      END DO

      A(1, 1, 1, 1, 1, 1, 1) = NEW_VALUE
      PRINT *,I,J,K,L,M,N,O
      print *,A
      PRINT *,"**********************************************"
      ! Simulate deletion by shifting elements backward
      INSERT_POSITION = 1

      DO I = 1, 2
        DO J = 1, 2
          DO K = 1, 2
            DO L = 1, 2
              DO M = 1, 2
                DO N = 1, 2
                  DO O = 1, 2
                    IF ((I * J * K * L * M * N * O) .GT. INSERT_POSITION) THEN
                      A(I - 1, J - 1, K - 1, L - 1, M - 1, N - 1, O - 1) = A(I, J, K, L, M, N, O)
                    END IF
                  END DO
                END DO
               END DO
             END DO
            END DO
           END DO
          END DO
          
          print *,A
          end program
