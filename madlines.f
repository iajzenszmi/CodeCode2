          character(len=80) madline
          integer madcount 
           madline = "I must not be insane"
           do madcount=1,10,1
           write(6,9000) madcount, madline
 9000      format(" ",i10," ",a80)
           end do
           end program   
