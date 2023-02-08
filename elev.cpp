/* elevator control program 4 floors 2 elevators 60 passengers */

#include <stdio.h>

/* global variables */
int floors = 4;
int elevators = 2;
int passengers = 60;

/* elevator class */
class Elevator {
  public:
    int currentFloor;
    int direction;
    int passengers;
    
    Elevator() {
      currentFloor = 0;
      direction = 0;
      passengers = 0;
    }
    
    void move() {
      if (direction == 1) {
        currentFloor++;
      } else if (direction == -1) {
        currentFloor--;
      }
    }
    
    void stop() {
      direction = 0;
    }
    
    void boardPassengers() {
      passengers += 5;
    }
    
    void dropOffPassengers() {
      passengers -= 5;
    }
};

/* create elevators */
Elevator elevator1;
Elevator elevator2;

/* function prototypes */
void moveElevator1();
void moveElevator2();
void setElevatorDirection();
