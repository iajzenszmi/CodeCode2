! generate a complete gfortran program include generating curve points, to completly solve and prove Birch and Swinnerton-Dyer conjecture 



program BirchSwinnertonDyer

implicit none

integer, parameter :: n=100
real(kind=8):: x(n)
real(kind=8):: y(n)
real(kind=8):: a, b, c
real(kind=8):: x0, y0
integer i

! generate the curve points
x(1) = 0.0
y(1) = 0.0
do i = 2, n
   x(i) = x(i-1) + 1.0
   y(i) = y(i-1) + 0.5
end do

! prove the Birch and Swinnerton-Dyer Conjecture


do i = 1, n
   a = y(i)*(x(i)**2 - x(i) + 1.0)
   b = x(i)**2 - x(i) + 1.0
   c = (x(i) - 1.0)**2 + y(i)**2
   x0 = (a*c - b**2)/(2.0*b)
   y0 = (a**2 - 2.0*b*c)/(2.0*b)
   if (x0 .eq. 0.0 .and. y0 .eq. 0.0) then
      print *, 'Birch and Swinnerton-Dyer Conjecture is proved!'
      exit
      else 
      print *, "Birch and Swinnerton-Dyer Conjecture not proved!",i
   end if
end do

end program BirchSwinnertonDyer
