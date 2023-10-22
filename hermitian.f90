
    program hermitian_check
    implicit none
    integer, parameter :: n = 3
    complex :: matrix(n,n), conj_transpose(n,n)
    integer :: i, j
    logical :: isHermitian

    ! Define a 3x3 Hermitian matrix
    matrix = reshape((/ (1.0, 0.0), (2.0, -2.0), (3.0, 0.0), &
                       (2.0, 2.0), (4.0, 0.0), (5.0, -5.0), &
                       (3.0, 0.0), (5.0, 5.0), (6.0, 0.0) /), [n,n])

    ! Compute the conjugate transpose
    do i = 1, n
        do j = 1, n
            conj_transpose(j,i) = conjg(matrix(i,j))
        end do
    end do

    ! Check if the matrix is Hermitian
    isHermitian = .true.
    do i = 1, n
        do j = 1, n
            if (matrix(i,j) /= conj_transpose(i,j)) then
                isHermitian = .false.
                exit
            end if
        end do
        if (.not. isHermitian) exit
    end do

    ! Output the result
    if (isHermitian) then
        print *, "The matrix is Hermitian!"
    else
        print *, "The matrix is not Hermitian!"
    end if

        end program hermitian_check
