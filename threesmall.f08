           ! program to find the three smallest numbers 
           ! programmmer Ian Martin Ajzenszmidt who resides in Melbourne Australia
           ! Date Tuesday 22 November 2022
             program threesmall
             integer first 
             integer second
             integer third
             integer arraya(5) 
             integer current
             integer i
             first = huge(i)
             second = huge(i)
             third = huge(i)
             arraya(1) = 67
             arraya(2) = 24
             arraya(3) = 87
             arraya(4) = 93
             arraya(5) = 21
             do i = 1 ,5,1
                current = arraya(i)
                if (first .gt. current) then
                    third = second
                    second = first
                    first = current
                    else if(second .gt. current) then
                    third = second
                    second = current
                    else if(third .gt. current) then
                    third = current
               endif
               end do
               print *, "least three elements are ", first, second, third                 
               end program  
