                subroutine nsevdim7
                integer a,b,c,d,e,f,g, narray, i, nrec7
                 real hcube7(7,7,7,7,7,7,7)
!                 read(5,9000) narray 
! 9000            format(I10)                 
                 open(unit=7,file='hcube7.bin',status='unknown') 
                  nrec7 = 0
!                do i = 1, narray, 1
                
                
                 do   g = 1,7
                 do  f = 1,7
                 do  e = 1,7
                 do  d = 1,7
                   do  c = 1,7
                      do  b = 1,7
                         do  a = 1,7

       hcube7(a,b,c,d,e,f,g) = 128*a+64*b+32*c+16*d+8*e+4*f+2*g
       nrec7 = nrec7 + 1
       print *,hcube7(a,b,c,d,e,f,g), " ", nrec7
       write(7,7000) hcube7(a,b,c,d,e,f,g)
 7000  format(f16.10)
                                  end do          
                          end do
                   end do                                           
                   end do                                                       
                   end do  
                  end do
                  end do
       !           print *,hcube, a,b,c,d,e,f,g
                 
      !               print *,hcube, a,b,c, d, e, f, g
!             
                end subroutine

          
