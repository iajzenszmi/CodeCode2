       program testgen
!      programmer Ian Martin Ajzenszmidt Melbourne Australia.
!      programmed  for entertainment purposes only.               
       integer ndim,i
       integer narray
       integer arraycnt1
       integer arrayparam(10)
       ndim = 1
       read *,(arrayparam(i),i=1,9)
!       read(5,9018) ndim
       narray = arrayparam(1)
       ndim = arrayparam(2)
       do arraycnt1 = 1, narray, 1
!    do i = 2,8,1
!     if(arrayparam(i).ge.1)  then
!       if(arrayparam(i) .le. 823543) then
!      ndim =ndim +1
!      endif
!     endif
!      enddo
        do i = 1,ndim,1
        arrayprod = arrayprod * arrayparam(i)
        enddo
!        if(arrayprod .ge. 823543) then
!         print *,"array overflow"
!         stop
 !        endif
! 9018  format(i10)      
       if (ndim.eq. 1) call nsevdim1(arraycnt1)
       if (ndim. eq. 2) call nsevdim2(arraycnt1)
       if (ndim .eq.3)  call nsevdim3(arraycnt1)
       if (ndim .eq. 4)  call nsevdim4(arraycnt1)
       if (ndim .eq. 5)  call nsevdim5(arraycnt1)
       if (ndim .eq. 6)  call nsevdim6(arraycnt1)
       if (ndim .eq. 7)  call nsevdim7(arraycnt1)
       end do
       end program
                 subroutine nsevdim1(arraycnt)
                integer g,narray, i, nrec1, arraycnt
                 real hcube1(7,7,7,7,7,7,7)
!                 read(5,9000) narray 
! 9000            format(I10)                 
                 open(unit=7,file='hcube1.bin',status='unknown') 
                  nrec1 = 0
!                do i = 1, narray, 1
                 a = 1
                 b = 1
                 c = 1
                 d = 1
                 e = 1
                 f = 1
                 g = 1
                
                 do   g = 1,1
                 
                                  
                                     
                         
       hcube1(a,b,c,d,e,f,g) =2*g
       nrec1 = nrec1 + 1
       print *,hcube1(a,b,c,d,e,f,g), " ", nrec1, arraycnt
       write(7,7000) hcube1(a,b,c,d,e,f,g)
 7000  format(f16.10)
                                  end do          
                 
                                                            
                                                                        
                 
                        !           print *,hcube, a,b,c,d,e,f,g
                 
      !               print *,hcube, a,b,c, d, e, f, g
!             enddo
                return
              
                end subroutine

          
                 subroutine nsevdim2(arraycnt)
                         integer f, g, narray, i, nrec2,arraycnt
                 real hcube2(7,7,7,7,7,7,7)
!                 read(5,9000) narray 
! 9000            format(I10)                 
                 open(unit=7,file='hcube2.bin',status='unknown') 
                  nrec2 = 0
!                do i = 1, narray, 1
                a = 1
                b = 1
                c = 1
                d = 1
                e = 1
                f = 1
                g = 1
                
                 do   g = 1,2
                 do  f = 1,2
                                                        
       hcube2(a,b,c,d,e,f,g) = f+2*g
       nrec2 = nrec2 + 1
       print *,hcube2(a,b,c,d,e,f,g), " ", nrec2, arraycnt
       write(7,7000) hcube2(a,b,c,d,e,f,g)
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
          
                subroutine nsevdim3(arraycnt)
                integer e,f,g,narray, i, nrec3, arraycnt
                 real hcube3(7,7,7,7,7,7,7)
!                 read(5,9000) narray 
! 9000            format(3I10)                 
                 open(unit=7,file='hcube3.bin',status='unknown') 
                  nrec3 = 1
!                do i = 1, narray, 1
                 a = 1
                 b = 1
                 c = 1
                 d = 1
                 e = 1
                 f = 1
                 g = 1
                
                 do   e = 1,3
                 do  f = 1,3
                 do  g= 1,3
                                  
                         
       hcube3(a,b,c,d,e,f,g) = 8*e+4*f+2*g
       nrec3 = nrec3 + 1
       print *,hcube3(a,b,c,d,e,f,g), " ", nrec3, arraycnt
       write(7,7000) hcube3(a,b,c,d,e,f,g)
 7000  format(3f16.10)
                                  end do          
                         end do
                      end do                                           
                                             
                  
                       !           print *,hcube, a,b,c,d,e,f,g
                 
      !               print *,hcube, a,b,c, d, e, f, g
!             enddo
                end subroutine

          
                subroutine nsevdim4(arraycnt)
                integer d,e,f,g,narray, i, nrec4, arraycnt
                 real hcube4(7,7,7,7,7,7,7)
!                read(5,9000) narray 
! 9000            format(4I10)                 
                 open(unit=7,file='hcube4.bin',status='unknown') 
                  nrec4 = 0
!                do i = 1, narray, 1
                
                 a = 1
                 b= 1
                 c = 1
                 d = 1
                 e = 1
                 f = 1
                 g = 1

                 do   g = 1,4
                 do  f = 1,4
                 do  e = 1,4
                 do  d = 1,4
                   
                         
       hcube4(7,7,7,7,7,7,7) = 16*d+8*e+4*f+2*g
       nrec4 = nrec4 + 1
       print *,hcube4(a,b,c,d,e,f,g), " ", nrec4, arraycnt
       write(7,7000) hcube4(a,b,c,d,e,f,g)
 7000  format(4f16.10)
                                  end do          
                         end do
                      end do                                                       
                   end do  
                  
       !           print *,hcube, a,b,c,d,e,f,g
                 
      !               print *,hcube, a,b,c, d, e, f, g
!             enddo
                end subroutine

          
                subroutine      nsevdim5(arraycnt)
                integer c,d,e,f,g ,narray, i, nrec5, arraycnt
                 real hcube5(7,7,7,7,7,7,7)
!                 read(5,9000) narray 
! 9000            format(I10)                 
                 open(unit=7,file='hcube5.bin',status='unknown') 
                  nrec5 = 0
!                 do i = 1, narray, 1
                
                a = 1
                b = 1
                c = 1
                d = 1
                e = 1
                f = 1
                g = 1
                 do   g = 1,5
                 do  f = 1,5
                 do  e = 1,5
                 do  d = 1,5
                   do  c = 1,5
                    
                         
       hcube5(a,b,c,d,e,f,g) = 32*c+16*d+8*e+4*f+2*g
       nrec5 = nrec5 + 1
       print *,hcube5(a,b,c,d,e,f,g), " ", nrec5, arraycnt
       write(7,7000) hcube5(a,b,c,d,e,f,g)
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

          

                 subroutine nsevdim6(arraycnt)
                         integer b,c,d,e,f,g, narray, i, nrec6
                         integer arraycnt
                 real hcube6(7,7,7,7,7,7,7)
!                 read(5,9000) narray 
! 9000            format(I10)                 
                 open(unit=7,file='hcube6.bin',status='unknown') 
                  nrec6= 0
!                do i = 1, narray, 1
                
                 a = 1
                 do   g = 1,7
                 do  f = 1,7
                 do  e = 1,7
                 do  d = 1,7
                   do  c = 1,7
                      do  b = 1,7
                      
                         
       hcube6(a,b,c,d,e,f,g) = 64*b+32*c+16*d+8*e+4*f+2*g
       nrec6 = nrec6 + 1
       print *,hcube6(a,b,c,d,e,f,g), " ", nrec6, arraycnt
       write(7,7000) hcube6(a,b,c,d,e,f,g)
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

          
                subroutine nsevdim7(arraycnt)
                integer a,b,c,d,e,f,g, narray, i, nrec7
                integer arraycnt
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
       print *,hcube7(a,b,c,d,e,f,g), " ", nrec7, arraycnt
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

          
