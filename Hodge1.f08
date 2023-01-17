!Hodge conjecture as gfortran program 


!The Hodge conjecture is that for projective algebraic varieties, Hodge cycles are rational
!linear combinations of algebraic cycles.

! Hdg k ⁡ ( X ) = H 2 k ( X , Q ) ∩ H k , k ( X ) . {\displaystyle \operatorname {Hdg} ^{k}
!        (X)=H^{2k}(X,\mathbb {Q} )\cap H^{k,k}(X).}

!We call this the group of Hodge classes of degree 2k on X.

!The modern statement of the Hodge conjecture is:

 !       Let X be a non-singular complex projective manifold. Then every Hodge class on X is a linear combination with rational coefficients of the cohomology classes of complex subvarieties of X.

      program Hodge_Conjecture
      implicit none
  
!Declare variables
      integer :: X !Non-singular complex projective manifold
      real :: Hdg !Group of Hodge classes of degree 2k on X
      real :: H !Cohomology classes of complex subvarieties of X
      real :: c !Rational coefficients 

!Calculate Hodge classes
      Hdg = H**2k(X,Q) ∩ H**k,k(X)

!Calculate linear combination
      c = Hdg*H 

!Print result
      print *, "Every Hodge class on X is a linear combination"
      print *," with rational coefficients of the cohomology"
      print *," classes of complex subvarieties of X."

      end program Hodge_Conjecture
