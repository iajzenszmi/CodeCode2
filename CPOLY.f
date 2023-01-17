!cpoly from calgo
!
!produce in gfortran and debug
!keywords: polynomial zeros
!title: CPOLY
!for: zeros of a complex polynomial
!alg: Jenkins and Traub
!ref: Comm. ACM 15 (1972) 97-99

      program CPOLY
   implicit none
   integer i, j, k, l, m, n
   double precision, dimension(:), allocatable :: P  ! Polynomial Coefficients
   double precision, dimension(:), allocatable :: Z   !Computed Roots
   double precision A, B, C, D, E, F, G, H, P1, P2, Q1, R1, S1, T1, U1, U2, V1, X, Y, error
   double precision  delta, eta, radius, theta, x1

   ! Get the degree of the polynomial
   print *, 'Enter degree of the polynomial: '
   read *, N

   ! Allocate arrays
   allocate(P(N+1), Z(N))

   ! Get the polynomial coefficients
   print *, 'Enter polynomial coefficients in decreasing order:'
   do i = 1, N-1
      read *, P(i)
   end do

   ! Initialize the output root array
   do i = 1, N
      Z(i) = 0.d0
   end do

   ! Begin the Jenkins and Traub algorithm
   P1 = 0.d0
   P2 = 0.d0
   Q1 = 0.d0
   R1 = 0.d0
   S1 = 0.d0
   T1 = 0.d0
   U1 = 0.d0
   U2 = 0.d0
   V1 = 0.d0
   delta = 0.d0
   eta = 0.d0
   error = 0.d0
   theta = 0.d0
   radius = 0.d0

   do l = 1, N
      ! Compute the first two initial approximations
      if ( l .eq. 1 ) then
         P1 = P(N)
         P2 = P(N-1) + P1
         X = 0.d0
      elseif ( l .eq. 2 ) then
         P1 = P(N)
         P2 = P(N-1) + P1
         Q1 = P(N-2) + P2
         X = -P2/Q1
      else
         ! Compute polynomial and its first two derivatives
         P1 = P(N)
         P2 = P(N-1) + P1
         Q1 = P(N-2) + P2
         R1 = P(N-3) + Q1
         S1 = P(N-4) + R1
         do i = 5, N
            T1 = P(N-i) + S1
            U1 = P1/S1
            U2 = Q1/S1
            V1 = R1/S1
            A = U2
            B = U1 - V1*A
            C = Q1 - V1*B
            D = P1 - V1*C
            E = T1 - V1*D
            F = (A**2 - 3.d0*B)/9.d0
            G = (2.d0*A**3 - 9.d0*A*B + 27.d0*C)/54.d0
            H = G**2 + (F**3 - 4.d0*F*G)
            if ( ABS(H) .lt. 1.d-14 ) then
               ! Compute the root
               theta = atan(sqrt(-H), -G)
               delta = -2.d0*sqrt(-F)*cos((theta/3.d0))
               X = X + delta
               ! Compute the error
               error = E/S1
            elseif ( H .gt. 0.d0 ) then
               ! Compute the root
               radius = sqrt(H)
               x1 = (sqrt(H)*G)
               delta = (-2.d0*sqrt(F)*cos(atan(x1, -A))*3.d0)
               X = X + delta
               ! Compute the error
               error = E/S1
            else
               ! Compute the root
               eta = acos(abs(G)/sqrt(-F**3))
               delta = -2.d0*sqrt(-F)*cosh((eta/3.d0))
               X = X + delta
               ! Compute the error
               error = E/S1
            end if
            ! Check the convergence
            if ( abs(error) .lt. 10 ) then
               Z(l) = X
            else
               ! Update polynomial coefficients
               P1 = X*S1 + D
               P2 = C + X*P1
               Q1 = B + X*P2
               S1 = A + X*Q1
            end if
         end do
      end if 
      Q1 = B + X*P2
   end do

   ! Print the roots
   print *
   print *, 'The roots of the polynomial are:'
   do k = 1, N
      print *, 'Root ' , k, ' = ', Z(k)
   end do

   deallocate(P, Z)

end program CPOLY
