                 subroutine nsevdim1
                integer g,narray, i, nrec1
                 real hcube1(1)
!                 read(5,9000) narray 
! 9000            format(I10)                 
                 open(unit=7,file='hcube1.bin',status='unknown') 
                  nrec1 = 0
!                do i = 1, narray, 1
                
                
                 do   g = 1,1
                 
                                  
                                     
                         
       hcube1(g) =2*g
       nrec1 = nrec1 + 1
       print *,hcube1(g), " ", nrec1
       write(7,7000) hcube1(g)
 7000  format(f16.10)
                                  end do          
                 
                                                            
                                                                        
                 
                        !           print *,hcube, a,b,c,d,e,f,g
                 
      !               print *,hcube, a,b,c, d, e, f, g
!             enddo
                end subroutine

          
