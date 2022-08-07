                subroutine nsevdim4
                integer d,e,f,g,narray, i, nrec4
                 real hcube4(4,4,4,4)
!                read(5,9000) narray 
! 9000            format(4I10)                 
                 open(unit=7,file='hcube4.bin',status='unknown') 
                  nrec4 = 0
!                do i = 1, narray, 1
                
                
                 do   g = 1,4
                 do  f = 1,4
                 do  e = 1,4
                 do  d = 1,4
                   
                         
       hcube4(d,e,f,g) = 16*d+8*e+4*f+2*g
       nrec4 = nrec4 + 1
       print *,hcube4(d,e,f,g), " ", nrec4
       write(7,7000) hcube4(d,e,f,g)
 7000  format(4f16.10)
                                  end do          
                         end do
                      end do                                                       
                   end do  
                  
       !           print *,hcube, a,b,c,d,e,f,g
                 
      !               print *,hcube, a,b,c, d, e, f, g
!             enddo
                end subroutine

          
