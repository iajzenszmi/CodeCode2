program EightDimensionalArray
  implicit none
  
  ! Constants
  integer, parameter :: dim1 = 8
  integer, parameter :: dim2 = 8
  integer, parameter :: dim3 = 8
  integer, parameter :: dim4 = 8
  integer, parameter :: dim5 = 8
  integer, parameter :: dim6 = 8
  integer, parameter :: dim7 = 8
  integer, parameter :: dim8 = 8
  
  ! Variables
  integer :: array(dim1, dim2, dim3, dim4, dim5, dim6, dim7, dim8)
  integer :: i, j, k, l, m, n, p, q
  integer :: reccnt
  reccnt = 0
  ! Fill the array with values
  do i = 1, dim1
    do j = 1, dim2
      do k = 1, dim3
        do l = 1, dim4
          do m = 1, dim5
            do n = 1, dim6
              do p = 1, dim7
                do q = 1, dim8
                  array(i, j, k, l, m, n, p, q) = i + j + k + l + m + n + p + q
                end do
              end do
            end do
          end do
        end do
      end do
    end do
  end do
  
  ! Display the array
  do i = 1, dim1
    do j = 1, dim2
      do k = 1, dim3
        do l = 1, dim4
          do m = 1, dim5
            do n = 1, dim6
              do p = 1, dim7
                do q = 1, dim8
                  write(*, '(A, I2, A, I2, A, I2, A, I2, A, I2, A, I2, A, I2, A, I2, A, I2, A, I2, A, I2, A, I2, A, I2, A, I2)') &
                    "array(", i, ",", j, ",", k, ",", l, ",", m, ",", n, ",", p, ",", q, ") =", array(i, j, k, l, m, n, p, q)
                reccnt = reccnt + 1
                end do
              end do
            end do
          end do
        end do
      end do
    end do
  end do
  print *, " record count ", reccnt
end program EightDimensionalArray
