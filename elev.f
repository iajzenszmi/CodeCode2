!/* create and debug  elevator control and reporting  program in fortran for 8 floors 2 lifts and 100 passengers */

Program Elevator_Control_Reporting

! This program is designed to simulate the control and reporting of two elevators in a building with 8 floors and 100 passengers.

! Declare Variables

integer:: i, j, floor_number, total_passengers, lift_number

! Initialize Variables

floor_number = 1
total_passengers = 100
lift_number = 1

! Start Loop

do i = 1, 8

floor_number = i

! Start Loop

do j = 1, 2

lift_number = j

! Check Status

if (total_passengers .gt. 0) then

! Call Lift 

  call lift(floor_number, lift_number)

total_passengers = total_passengers - 1

end if

end do

end do
end program
! Lift Function

subroutine lift(floor_number, lift_number)
integer floor_number, lift_number
! Increment Floor

floor_number = floor_number + 1

! Print Report

print *, "Lift number", lift_number, "has arrived at floor number",  &
      floor_number

end subroutine 
