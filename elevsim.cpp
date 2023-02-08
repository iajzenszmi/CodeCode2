//elevator simulation in c++ for 10 floor building with 3 elevators


//Include necessary libraries
#include<iostream>
#include<string>
#include<vector>

//Create an Elevator class
class Elevator 
{
private:
    int currentFloor;
    int capacity;
    int numOfRiders;
    bool isFull;
    std::vector<int> destinationFloors;
    
public:
    Elevator(int currentFloor, int capacity) 
    {
        this->currentFloor = currentFloor;
        this->capacity = capacity;
        this->numOfRiders = 0;
        this->isFull = false;
    }
    
    int getCurrentFloor() 
    {
        return currentFloor;
    }
    
    int getCapacity() 
    {
        return capacity;
    }
    
    int getNumOfRiders() 
    {
        return numOfRiders;
    }
    
    bool getIsFull() 
    {
        return isFull;
    }
    
 
    

