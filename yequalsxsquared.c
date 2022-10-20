//Plot function x ^ 2
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
int main()
{
    int x;
    int y;
//    printf("Enter x: ");
    for (x = 1; x <= 10; x++)
    {
        y=x*x;
        printf(" x = %d, y = %d ", x, y);
        }
    //printf("x ^ 2 = %d", x * x);
    return 0;
}