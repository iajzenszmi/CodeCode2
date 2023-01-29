!      programmer Ian Martin Ajzenszmidt 30/01/2023
       real x,y,z,j
       integer i, k
       integer sum1
       sum1 = 0
       do i= 1,10,1
       j = real(i)
       k = i
       x=sin(j)
       y=cos(j)
       z=tan(j)
       sum1 = sum1 + k
       print *, "number = ",k," sine = ",x,"cosine = ",y,"tan = ",z, &
      & " sum  of series = ",sum1
       end do
       end program
       
