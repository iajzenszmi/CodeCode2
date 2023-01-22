//generate a C++ program to calculate and display parzen windows

#include <iostream>
#include <random>
#include <math.h>

using namespace std;

int main()
{
	// define the variables
	int n, h, i;
	float x, result;
	
	// get the input from the user
	cout << "Enter the value of n: ";
	cin >> n;
	
	cout << "Enter the value of h: ";
	cin >> h;
	
	// generate random numbers
	default_random_engine generator;
	uniform_real_distribution<float> distribution(0.0,1.0);
	
	// calculate the parzen window
	for (i = 0; i < n; i++)
	{
		x = distribution(generator);
		result += (1/(n*h)) * exp(-(x*x)/(2*h*h));
	}
	
	// display the result
	cout << "The result of the Parzen window is " << result << endl;
	
	return 0;
}//
