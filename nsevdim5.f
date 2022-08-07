                subroutine      nsevdim5
                integer c,d,e,f,g ,narray, i, nrec5
                 real hcube5(5,5,5,5,5)
!                 read(5,9000) narray 
! 9000            format(I10)                 
                 open(unit=7,file='hcube5.bin',status='unknown') 
                  nrec5 = 0
!                 do i = 1, narray, 1
                
                
                 do   g = 1,5
                 do  f = 1,5
                 do  e = 1,5
                 do  d = 1,5
                   do  c = 1,5
                    
                         
       hcube5(c,d,e,f,g) = 32*c+16*d+8*e+4*f+2*g
       nrec5 = nrec5 + 1
       print *,hcube5(c,d,e,f,g), " ", nrec5
       write(7,7000) hcube5(c,d,e,f,g)
 7000  format(5f16.1)
                                  end do          
                         end do
                      end do                                           
                   end do                                                       
               end do  
                   !           print *,hcube, a,b,c,d,e,f,g
                 
      !               print *,hcube, a,b,c, d, e, f, g
!             enddo
                end subroutine

          
