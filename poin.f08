program TrivialFundamentalGroup
   implicit none

   integer :: i, H(5)
   logical :: M_homeomorphic_3sphere

   !Set H_i to the given values
   do i =1,4
      if (i.eq.0 .or. i.eq.3) then
         H(i) = 1
      else
         H(i) = 0
      end if
   end do

   !Check if M is homeomorphic to the 3-sphere
   if (H(1).eq.1 .and. H(2).eq.0 .and. H(3).eq.0 .and. H(4).eq.1) then
      M_homeomorphic_3sphere = .true.
   else
      M_homeomorphic_3sphere = .false.
   end if

   if (M_homeomorphic_3sphere) then
      write (*,*) 'M is homeomorphic to the 3-sphere.'
   else
      write (*,*) 'M is not homeomorphic to the 3-sphere.'
   end if

end program TrivialFundamentalGroup
