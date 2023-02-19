ian@ian-HP-Convertible-x360-11-ab1XX:~$ gfortran count1010.f -o c1010
ian@ian-HP-Convertible-x360-11-ab1XX:~$ ./c1010
           1
           2
           3
           4
           5
           6
           7
           8
           9
          10
ian@ian-HP-Convertible-x360-11-ab1XX:~$ cat count1010.f 
         integer icount
         do icount = 1, 10, 1
            print *, icount
         end do
         end program   
ian@ian-HP-Convertible-x360-11-ab1XX:~$ 
