                 subroutine nsevdim2
                integer f, g, narray, i, nrec2
                 real hcube2(2,2)
!                 read(5,9000) narray 
! 9000            format(I10)                 
                 open(unit=7,file='hcube2.bin',status='unknown') 
                  nrec2 = 0
!                do i = 1, narray, 1
                
                
                 do   g = 1,2
                 do  f = 1,2
                                                        
       hcube2(f,g) = f+2*g
       nrec2 = nrec2 + 1
       print *,hcube2(f,g), " ", nrec2
       write(7,7000) hcube2(f,g)
 7000  format(f16.10)
               !                   end do          
                !         end do
                !      end do                                           
                   end do                                                       
                   end do  
              ! print *,hcube, a,b,c,d,e,f,g
                 
      !               print *,hcube, a,b,c, d, e, f, g
!             enddo
                end subroutine
          
