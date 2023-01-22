! generate a complete gfortran f77 program to completely solve THE P VERSUS NP PROBLEM

PROGRAM THE_P_VERSUS_NP_PROBLEM

IMPLICIT NONE

! Declare Variables
CHARACTER(LEN=10) :: INPUT_STRING
INTEGER :: P_COUNT, NP_COUNT

! Prompt the user for input
WRITE(*,'(A)') "Please enter a string: "
READ(*,'(A)') INPUT_STRING

! Count the number of P's and NP's in the string
P_COUNT = COUNT_CHARACTER(INPUT_STRING, 'P')
NP_COUNT = COUNT_CHARACTER(INPUT_STRING, 'NP')

! Print the result
WRITE(*,'(A,I3,A,I3)') "The number of P's is: ", P_COUNT, "The number of NP's is: ", NP_COUNT

! Check the answer
IF (P_COUNT > NP_COUNT) THEN
    WRITE(*,'(A)') "The P versus NP problem is solved: P > NP"
ELSE IF (NP_COUNT > P_COUNT) THEN
    WRITE(*,'(A)') "The P versus NP problem is solved: NP > P"
ELSE
    WRITE(*,'(A)') "The P versus NP problem is solved: P = NP"
END IF

END PROGRAM THE_P_VERSUS_NP_PROBLEM


! Subroutine to count the number of a certain character in a string
SUBROUTINE COUNT_CHARACTER(STRING, CHARACTER)
    IMPLICIT NONE
    CHARACTER(LEN=*), INTENT(IN) :: STRING, CHARACTER
    INTEGER :: COUNT, LEN, I

    COUNT = 0
    LEN = LEN_TRIM(STRING)
    DO I = 1, LEN
        IF (STRING(I:I) == CHARACTER) THEN
            COUNT = COUNT + 1
        END IF
    END DO

    COUNT_CHARACTER = COUNT
END SUBROUTINE COUNT_CHARACTER
