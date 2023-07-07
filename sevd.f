program rank7_array

implicit none

integer,parameter :: dims(7) = (1,2,3,4,5,6,7)
integer,dimension(dims) :: array

do i = 1,prod(dims)
  array(i) = i
end do

write(*,*) "The array has ",prod(dims)," elements."
write(*,*) "The first element is ",array(1)
write(*,*) "The last element is ",array(prod(dims))

end program rank7_array
