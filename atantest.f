ian@ian-HP-Convertible-x360-11-ab1XX:~$ gfortran atantest.f -o atantest
ian@ian-HP-Convertible-x360-11-ab1XX:~$ ./atantest
   1.2350854374578792       0.89019247921008471     
ian@ian-HP-Convertible-x360-11-ab1XX:~$ cat  atantest.f
            program test_atan
            real( 8 ) :: x = 2.866_8
            x = atan( x )
            print *,x,atan( x )
            end program test_atan
ian@ian-HP-Convertible-x360-11-ab1XX:~$ 
