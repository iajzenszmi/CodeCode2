                subroutine nsevdim3
                integer e,f,g,narray, i, nrec3
                 real hcube3(3,3,3)
!                 read(5,9000) narray 
! 9000            format(3I10)                 
                 open(unit=7,file='hcube3.bin',status='unknown') 
                  nrec3 = 1
!                do i = 1, narray, 1
                
                
                 do   e = 1,3
                 do  f = 1,3
                 do  g= 1,3
                                  
                         
       hcube3(e,f,g) = 8*e+4*f+2*g
       nrec3 = nrec3 + 1
       print *,hcube3(e,f,g), " ", nrec3
       write(7,7000) hcube3(e,f,g)
 7000  format(3f16.10)
                                  end do          
                         end do
                      end do                                           
                                             
                  
                       !           print *,hcube, a,b,c,d,e,f,g
                 
      !               print *,hcube, a,b,c, d, e, f, g
!             enddo
                end subroutine

          
