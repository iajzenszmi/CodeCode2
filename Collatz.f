!Collatz.f by Ian Martin Ajzenzmidt, Melbourne 
            integer n
            integer a1
            integer a2
            integer nover2ifeven
            integer  n3nplus1ifodd
            print *,"Collatz.f by Ian Martin Ajzenszmidt"
            do n=2,10,2
              a1 = n
              nover2ifeven = a1 / 2
              print *, a1, nover2ifeven
            end do
            do n=1,10,2
               a2 = n
               n3nplus1ifodd= (3* a2)+1
              print *,a2, n3nplus1ifodd
            end do
            end program  
