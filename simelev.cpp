elevator simulation in c for 10 floor building with 3 elevators

#include<stdio.h>
#include<conio.h>
#include<stdlib.h>
#include<string.h>

//structure to store the details of the elevator
struct elevator {
	int id;
	int current_floor;
	int direction;
	int target_floor;
	int active;
}elevator[3];

//function to start elevator
void start_elevator(){
	
	int i;
	
	//Initialize elevator to idle state
	for(i=0;i<3;i++){
		elevator[i].id = i+1;
		elevator[i].current_floor = 1;
		elevator[i].direction = 0;
		elevator[i].target_floor = 0;
		elevator[i].active = 0;
		printf("Elevator %d is idle\n",elevator[i].id);
	}
}

//function to find the shortest path
int shortest_path(int current_floor, int
