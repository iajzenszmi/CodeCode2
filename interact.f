   character(len=80)inputrequest/"Enter persno, name blank separated"/
   character(len=20) firstname(20)/20* " "/,middlename(20)/20 * " "/
   character(len=20) surname(20) /20 * " "/
   character(len=72) filename /"persfile.txt"/
          integer persno /1/, persct /1/
      print *,inputrequest
      open(10,file=filename)
      do while(persno .ne.99      )
      read *,persno,firstname(persno),middlename(persno),surname(persno)
  write(10,*)persno,firstname(persno),middlename(persno),surname(persno)
    print *,persno,firstname(persno),middlename(persno),surname(persno)
    do persct = 1, 20, 1
    print *,persct,firstname(persct),middlename(persct),surname(persct)
    enddo  
    enddo          
    end program
