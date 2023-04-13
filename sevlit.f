       integer anumba /22/
       do while (anumba .ne. 89)
       print *, "read a digit between 0 and 9"
       read *,anumba
       if (anumba .eq. 1) print *, "one"
       if (anumba .eq. 2) print *, "two"
       if (anumba .eq. 3) print *, "three"
       if (anumba .eq. 4) print *, "four"
       if (anumba .eq. 5) print *, "five"
       if (anumba .eq. 6) print *, "six"
       if (anumba .eq. 7) print *, "seven"
       if (anumba .eq. 8) print *, "eight"
       if (anumba .eq. 9) print *, "nine"
       if (anumba .eq. 0) print *, "zero"
       end do
       end program
