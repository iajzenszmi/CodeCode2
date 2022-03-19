integer iarray(823542)
integer icount 
do icount = 0,823542,1
      iarray(icount) = icount
enddo      
write(6,*),(iarray(icount),icount=1,100,1)
icount = 7*6*4*3*7*2*6
iarray(icount)=999999
write(6,9000),iarray(icount), icount
9000 format(" ",i10,i10)
end program
