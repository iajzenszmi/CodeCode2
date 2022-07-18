       !program to print count and tangent "tan" of count
       !
       integer count1
       real result1
       print *, "Program by Ian Martin Ajzenszmidt, Melbourne AU 190722"
       print *,"         count"," ","result"
       print *,"       -----------------------"
       do count1 = 1, 10, 1
            result1 = (tan(real(count1)))
            print *,count1," ", result1
       enddo
       end program
            
