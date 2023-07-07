program seven_dimensional_array
    implicit none
    integer, dimension(7, 7, 7, 7, 7, 7, 7) :: array7D
    integer :: i, j, k, l, m, n, p, reccnt
    reccnt = 0

    ! Initialize the array with some values
    do i = 1, 7
        do j = 1, 7
            do k = 1, 7
                do l = 1, 7
                    do m = 1, 7
                        do n = 1, 7
                            do p = 1, 7
                                array7D(i, j, k, l, m, n, p) = i + j + k + l + m + n + p
                            end do
                        end do
                    end do
                end do
            end do
        end do
    end do

    ! Print the values
    do i = 1, 7
        do j = 1, 7
            do k = 1, 7
                do l = 1, 7
                    do m = 1, 7
                        do n = 1, 7
                            do p = 1, 7
                                print *, 'array7D(',i,',',j,',',k,',',l,',',m,',',n,',',p,') = ', array7D(i, j, k, l, m, n, p)
        reccnt = reccnt + 1
                            end do
                        end do
                    end do
                end do
            end do
        end do
    end do
    print *," record count", reccnt
end program seven_dimensional_array
