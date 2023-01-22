//Generate C++ Program to output an example of a bessel function

#include <iostream>
#include <cmath>
 
using namespace std;
 
double bessel(double x, int n)
{
    double j0 = 1.0;
    double j1 = 0.0;
    double sum = 0.0;
    double factorial = 1.0;
    double x_pow = 1.0;
 
    for (int i = 1; i <= n; i++)
    {
        double j = j0 + j1;
        j0 = j1;
        j1 = j;
        factorial *= (2 * i - 1) * (2 * i);
        x_pow *= x * x;
        sum += j * x_pow / factorial;
    }
 
    return sum;
}
 
int main()
{
    int n = 15;
    double x = 0.5;
 
    cout << "The Bessel function of order " << n << " is " << bessel(x, n) << endl;
 
    return 0;
}
