       integer icount2(10) /1,2,3,4,5,6,7,8,9,0/,icount
       write(6,9000) (icount2(icount),icount=1,10)
 9000  format(" ",10(I2,X))
       end program
