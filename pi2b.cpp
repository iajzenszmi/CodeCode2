//generate a program that uses the Gottfried Leibniz formula for calculation of π to 3000 places



#include <stdio.h>
#include <math.h>

int main(){
	int n;
	double pi,term;
	printf("Enter the number of terms to compute pi to 3000 places: ");
	scanf("%d",&n);
	pi=0.0;
	for(int i=0;i<n;i++)
	{
		term=(pow(-1,i))/(2*i + 1);
		pi = pi + term;
	}
	pi = pi*4;
	printf("The calculated value of pi is %f\n",pi);
	return 0;
}
