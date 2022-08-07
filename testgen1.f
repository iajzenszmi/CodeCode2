       program testgen
!      programmer Ian Martin Ajzenszmidt Melbourne Australia.
!      programmed  for entertainment purposes only.               
       integer ndim
       read(5,9018) ndim
 9018  format(i10)      
       if (ndim.eq. 1) call nsevdim1
       if (ndim. eq. 2) call nsevdim2
       if (ndim .eq.3)  call nsevdim3
       if (ndim .eq. 4)  call nsevdim4
       if (ndim .eq. 5)  call nsevdim5
       if (ndim .eq. 6)  call nsevdim6
       if (ndim .eq. 7)  call nsevdim7
       end program
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

          

                 subroutine nsevdim6
                integer b,c,d,e,f,g, narray, i, nrec6
                 real hcube6(7,7,7,7,7,7)
!                 read(5,9000) narray 
! 9000            format(I10)                 
                 open(unit=7,file='hcube6.bin',status='unknown') 
                  nrec6= 0
!                do i = 1, narray, 1
                
                
                 do   g = 1,7
                 do  f = 1,7
                 do  e = 1,7
                 do  d = 1,7
                   do  c = 1,7
                      do  b = 1,7
                      
                         
       hcube6(b,c,d,e,f,g) = 64*b+32*c+16*d+8*e+4*f+2*g
       nrec6 = nrec6 + 1
       print *,hcube6(b,c,d,e,f,g), " ", nrec6
       write(7,7000) hcube6(b,c,d,e,f,g)
 7000  format(f16.10)
                                  end do          
                         end do
                      end do                                           
                   end do                                                       
                   end do  
                  end do
                         !           print *,hcube, a,b,c,d,e,f,g
                 
      !               print *,hcube, a,b,c, d, e, f, g
!             enddo
                end subroutine

          
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

          
