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

int main() {
  int i;
  
  /* main loop */
  for (i = 0; i < passengers; i++) {
    setElevatorDirection();
    moveElevator1();
    moveElevator2();
  }
  
  return 0;
}

/* move elevator 1 */
void moveElevator1() {
  elevator1.move();
  elevator1.boardPassengers();
  elevator1.dropOffPassengers();
}

/* move elevator 2 */
void moveElevator2() {
  elevator2.move();
  elevator2.boardPassengers();
  elevator2.dropOffPassengers();
}

/* set elevator direction */
void setElevatorDirection() {
  /* check if elevator 1 is at the top or bottom floor */
  if (elevator1.currentFloor == 0) {
    elevator1.direction = 1;
  } else if (elevator1.currentFloor == floors - 1) {
    elevator1.direction = -1;
  }
  
  /* check if elevator 2 is at the top or bottom floor */
  if (elevator2.currentFloor == 0) {
    elevator2.direction = 1;
  } else if (elevator2.currentFloor == floors - 1) {
    elevator2.direction = -1;
  }
}
