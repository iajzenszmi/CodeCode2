//generate a program to output a ball bouncing around a surface
//generate a program to demonstrate a ball rolling on a surface

#include <iostream>
#include <vector>
#include <cmath>

using namespace std;

const double GRAVITY = 9.8;			// gravitational pull in m/s^2
const double TIME_INCREMENT = 0.2;	// time increment in seconds

struct Coordinates {
	double x;
	double y;
};

// class to represent a ball
class Ball
{
private:
	double radius;				// radius of the ball in meters
	double mass;				// mass of the ball in kilograms
	Coordinates position;		// current position of the ball in meters
	Coordinates velocity;		// current velocity of the ball in meters/second

public:
	// Constructor
	Ball(double r, double m) {
		radius = r;
		mass = m;
		position = { 0.0, 0.0 };
		velocity = { 0.0, 0.0 };
	}

	// Getters
	double getRadius() { return radius; }
	double getMass() { return mass; }
	Coordinates getPosition() { return position; }
	Coordinates getVelocity() { return velocity; }

	// Setters
	void setPosition(double x, double y) {
		position.x = x;
		position.y = y;
	}
	void setVelocity(double x, double y) {
		velocity.x = x;
		velocity.y = y;
	}

	// Functions
	void roll(double time) {
		// update the position
		position.x += velocity.x * time;
		position.y += velocity.y * time;

		// update the velocity
		velocity.y -= GRAVITY * time;
	}
};

int main()
{
	// create a ball
	Ball ball(0.1, 1.0);

	// set the initial velocity
	ball.setVelocity(5.0, 5.0);

	// simulate the ball rolling
	double time = 0.0;
	vector<Coordinates> path;
	while (ball.getPosition().y >= 0)
	{
		// add the current position to the path
		path.push_back(ball.getPosition());

		// move the ball
		ball.roll(TIME_INCREMENT);
		time += TIME_INCREMENT;
	}

	// print out the path
	cout << "Path of the ball:\n";
	for (auto pos : path)
	std::cout << "(" << pos.x << ", " << pos.y << ")\n";

	std::cout << "Time taken: " << time << "s\n";

	return 0;
}
