!Donald Knuth's elevator algorithm in Fortran, with 8 floors, 2 elevators and 100 passengers:

!Declare variables

integer :: closest_elevator

integer :: passengers = 100, elevators = 2

!Initialize array that contains the floor number for each passenger

integer, dimension(1) :: passenger_floors(8) = [1,1,1,1,1,1,1,1]

!Initialize the current floor for each elevator

integer, dimension(2) :: elevator_floors = [ 1, 1 ]

!Initialize the destination floor for each elevator

integer, dimension(2) :: elevator_destinations = [ 0, 0 ]

!Loop through passengers and assign them to an elevator

do passenger = 1, passengers
   
   !First, determine which elevator is closest to the passenger's floor
 !  integer :: closest_elevator
   
   if (abs(elevator_floors(1) - passenger_floors(passenger)) < abs(elevator_floors(2) - passenger_floors(passenger))) then
      closest_elevator = 1
   else
      closest_elevator = 2
   end if
   print *, "closest elevator ",closest_elevator
   !Then, set the elevator's destination to the passenger's floor
   elevator_destinations(closest_elevator) = passenger_floors(passenger)
   print *,"elevator destinations", elevator_destinations
   
        end do

!Loop through elevators and move them to their destinations

do elevator = 1, elevators
   print *," elevator ",elevator
   !Loop until elevator reaches its destination
   do while (elevator_floors(elevator) /= elevator_destinations(elevator))
      !Move the elevator one floor closer to its destination
      if (elevator_floors(elevator) < elevator_destinations(elevator)) then
         elevator_floors(elevator) = elevator_floors(elevator) + 1
      else
         elevator_floors(elevator) = elevator_floors(elevator) - 1
      endif
      print *,"elevator_floors ", elevator_floors
   end do
   
end do
end program
