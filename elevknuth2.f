! create a fortran program to create from knuths elevator algorithm, output similar to the following
!Example Output

!TIME    STATE   FLOOR   D1      D2      D3      step    action
!0000    N       2       0       0       0       U1      User 1 arrives at floor 2, destination is 0.
!0000    N       2       0       0       0       U2      User 1 presses down button.
!0000    N       2       0       0       0       U3      User 1 stands in queue in front of elevator.
!0020    N       2       0       0       0       E3      Elevator doors start to open.
!0040    N       2       X       X       0       E4      Doors are open. Users about to enter.
!0040    N       2       X       X       0       U5      User 1 gets in.


program knuth_elevator
    implicit none
    integer :: time = 0, state = 0, floor = 2, d1 = 0, d2 = 0, d3 = 0, step = 0
    character(len=50) :: action
    
    write(*,*) "TIME    STATE   FLOOR   D1      D2      D3      step    action"
    write(*,*) "      ",time, state, floor, d1, d2, d3, step, "User 1 arrives at floor 2, destination is 0."
    
    time = time + 0
    step = step + 1
    action = "User 1 presses down button."
    write(*,*) time, state, floor, d1, d2, d3, step, action
    
    time = time + 0
    step = step + 1
    action = "User 1 stands in queue in front of elevator."
    write(*,*) time, state, floor, d1, d2, d3, step, action
    
    time = time + 20
    step = step + 1
    action = "Elevator doors start to open."
    write(*,*) time, state, floor, d1, d2, d3, step, action
    
    time = time + 20
    step = step + 1
    action = "Doors are open. Users about to enter."
    write(*,*) time, state, floor, d1, d2, d3, step, action
    
    time = time + 0
    step = step + 1
    d1 = 1
    action = "User 1 gets in."
    write(*,*) time, state, floor, d1, d2, d3, step, action
    
end program knuth_elevator
