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
