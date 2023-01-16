!Write a monte carlo elevator simulation with reporting in fortran

program elevator
    implicit none
    integer, parameter :: num_floors = 10
    real random
    integer :: num_people, current_floor, next_floor, i
    integer :: num_trips = 0, total_people = 0

    !initialize random number generator
    call random_seed()

    do
        !pick a random number of people
        num_people = int(random()*10 + 1)
        total_people = total_people + num_people

        !pick a random starting floor
        current_floor = int(random()*num_floors + 1)

        !take the people to their floors
        do i = 1, num_people
            next_floor = int(random()*num_floors + 1)

            !if someone needs to go to a different floor, move the elevator
            if (current_floor /= next_floor) then
                num_trips = num_trips + 1
                current_floor = next_floor
            endif
        end do
    end do

    !print out the results
    print *, 'Number of trips: ', num_trips
    print *, 'Total people: ', total_people

end program elevator
