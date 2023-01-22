//generate  program to calculate pi to 300 decimal places

#include <stdio.h>
#include <math.h>
 
int main()
{
    long double pi = 0;
    int n;
 
    printf("Calculating PI to 300 decimal places\n");
    for (n = 0; n < 300; n++)
    {
        pi += (long double)(pow(-1.0, n)/(2.0*n + 1.0));
    }
 
    printf("PI = %.300Lf\n", pi*4);
    return 0;
}
