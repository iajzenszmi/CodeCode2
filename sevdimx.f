! Programmed by Ian Martin Ajzenszmidt
! Melbourne Australia
! 21 April 2023
! assisted by chat.openai.com 
program seven_dim_array
    implicit none

    integer, parameter :: n1 = 3, n2 = 2, n3 = 2, n4 = 2, n5 = 2, n6 = 2, n7 = 2
    integer, dimension(n1, n2, n3, n4, n5, n6, n7) :: arr

    integer :: i1=0, i2=0, i3=0, i4=0, i5=0, i6=0, i7 =0
    integer :: ins_val, pos(7)

    ! Initialize the 7-dimensional array
    arr = 0
   ! Define the position and value to insert
    ins_val = 100
    pos = [1, 1, 1, 1, 1, 1, 2]

    ! Call the insert subroutine
    call insert_element(arr, ins_val, pos)
    print *,arr
    print *,i1,i2,i3,i4,i5,i6,i7
contains
    subroutine insert_element(arr, ins_val, pos)
        integer, dimension(:,:,:,:,:,:,:), intent(inout) :: arr
        integer, intent(in) :: ins_val
        integer, dimension(7), intent(in) :: pos

        integer :: i1, i2, i3, i4, i5, i6, i7
        integer :: max_i1, max_i2, max_i3, max_i4, max_i5, max_i6, max_i7

        ! Get the maximum index values for each dimension
        max_i1 = size(arr, 1)
        max_i2 = size(arr, 2)
        max_i3 = size(arr, 3)
        max_i4 = size(arr, 4)
        max_i5 = size(arr, 5)
        max_i6 = size(arr, 6)
        max_i7 = size(arr, 7)

        ! Shift elements to the right
        do i1 = max_i1, pos(1), -1 
            do i2 = max_i2, pos(2), -1
                do i3 = max_i3, pos(3), -1
                    do i4 = max_i4, pos(4), -1
                        do i5 = max_i5, pos(5), -1
                            do i6 = max_i6, pos(6), -1
                                do i7 = max_i7, pos(7), -1
                                    if (i7 > pos(7)) then
                                        arr(i1, i2, i3, i4, i5, i6, i7) = arr(i1, i2, i3, i4, i5, i6, i7 - 1)
                                    end if
                                end do
                            end do
                        end do 
                    end do
                end do
            end do
        end do

        ! Insert the new value
        arr(pos(1), pos(2), pos(3), pos(4), pos(5), pos(6), pos(7)) = ins_val

    end subroutine insert_element
end program seven_dim_array

