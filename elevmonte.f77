!Write a monte carlo elevator simulation with reporting in gfortran 77

program montecarlo_elevator

implicit none

integer, parameter :: num_floors = 10

real, parameter :: probability_up = 0.5

integer :: current_floor = 1

integer :: next_floor

integer :: i

real :: seed

!The seed of the random number generator

seed = 100

!Set the seed of the random number generator

call random_seed(seed)

!Loop until the elevator reaches the 10th floor

do while (current_floor <= num_floors) 

!Generate a random number between 0 and 1

next_floor = random_number()

!If the random number is less than the probability of going up, then the elevator goes up

if (next_floor < probability_up) then 

current_floor = current_floor + 1

else

current_floor = current_floor - 1

endif

!Print the current floor

write(*,*) 'The elevator is currently on floor ', current_floor

enddo

end program montecarlo_elevator
