/* create and debug  elevator control and reporting  program in c++ 11 for 8 floors 2 lifts and 100 passengers */

// Elevator object
 elevator = {
  currentFloor: 0, // Current Floor of the elevator
  maxFloors: 8, // Maximum Floors
  passengers: 100, // Maximum passengers supported
  passengersOnBoard: 0, // Passengers currently on board 
  // Method to move the elevator
  move: function(destinationFloor) {
    console.log('Elevator is moving from floor ${this.currentFloor} to floor ${destinationFloor}');
    this.currentFloor = destinationFloor;
  },
  // Method to pick up passengers
  pickUp: function(passengerCount) {
    this.passengersOnBoard += passengerCount;
    console.log('${passengerCount} passengers have been picked up. Total passengers on board: ${this.passengersOnBoard}');
  },
  // Method to drop off passengers
  dropOff: function(passengerCount) {
    this.passengersOnBoard -= passengerCount;
    console.log('${passengerCount} passengers have been dropped off. Total passengers on board: ${this.passengersOnBoard}');
  },
  // Method to report current status
  reportStatus: function() {
    console.log('Elevator is currently at floor ${this.currentFloor}, with ${this.passengersOnBoard} passengers on board.');
  }
};

// USAGE

//elevator.move(3);
//elevator.pickUp(10);
//elevator.move(5);
//elevator.dropOff(7);
//elevator.reportStatus();

// Output
// Elevator is moving from floor 0 to floor 3
// 10 passengers have been picked up. Total passengers on board: 10
// Elevator is moving from floor 3 to floor 5
// 7 passengers have been dropped off. Total passengers on board: 3
// Elevator is currently at floor 5, with 3 passengers on board.:/* create and debug  elevator control and reporting  program in c++ 11 for 8 floors 2 lifts and 100 passengers */

// Elevator object
  elevator = {
  currentFloor: 0, // Current Floor of the elevator
  maxFloors: 8, // Maximum Floors
  passengers: 100, // Maximum passengers supported
  passengersOnBoard: 0, // Passengers currently on board 
  // Method to move the elevator
  move: function(destinationFloor) {
    console.log('Elevator is moving from floor ${this.currentFloor} to floor ${destinationFloor}');
    this.currentFloor = destinationFloor;
  },
  // Method to pick up passengers
  pickUp: function(passengerCount) {
    this.passengersOnBoard += passengerCount;
    console.log('${passengerCount} passengers have been picked up. Total passengers on board: ${this.passengersOnBoard}');
  },
  // Method to drop off passengers
  dropOff: function(passengerCount) {
    this.passengersOnBoard -= passengerCount;
    console.log('${passengerCount} passengers have been dropped off. Total passengers on board: ${this.passengersOnBoard}');
  },
  // Method to report current status
  reportStatus: function() {
    console.log('Elevator is currently at floor ${this.currentFloor}, with ${this.passengersOnBoard} passengers on board.');
  }
};

// USAGE

//elevator.move(3);
//elevator.pickUp(10);
//elevator.move(5);
//elevator.dropOff(7);
//elevator.reportStatus();

// Output
// Elevator is moving from floor 0 to floor 3
// 10 passengers have been picked up. Total passengers on board: 10
// Elevator is moving from floor 3 to floor 5
// 7 passengers have been dropped off. Total passengers on board: 3
// Elevator is currently at floor 5, with 3 passengers on board.:
