#include <stdio.h>
#define STEPS 1000000
int main()
{
int i;
double p=2;
for (i=0;i<STEPS;i++)
{
p*=((double)(((int)((i+2)/2))*2))/(((int)((i+1)/2))*2+1);
}
printf("Pi = %f\n",p);
getchar();
return 0;
}
