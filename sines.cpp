/* create and debug  a program to output a table of sine values from 1 to 360 degrees */

#include <iostream>
#include <cmath>
using namespace std;

// Function to calculate sine value
double Sine(double x) 
{  
    return sin(x * M_PI / 180.0); 
}

int main()
{
	const int MAX_DEGREE = 360;
	
	cout << "Degree\tSine" << endl;
	
	for (int i = 1; i<=MAX_DEGREE; i++)
	{
		cout << i << "\t" << Sine(i) << endl;
	}
	
	return 0;
}
