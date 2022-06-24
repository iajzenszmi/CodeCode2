 // A program that prints the numbers from 1 to 15, one per line
 //
 // Compile: gcc countto15.c -o countto15
 // Run: ./countto15
 // Expected Output:
 // 1
 // 2
 // 3
 // 4
 // 5
 // 6
 // 7
 // 8
 // 9
 // 10
 // 11
 // 12
 // 13
 // 14
 // 15
#include <stdio.h>
int main()
{
	int i;
	for (i=1; i<=15; i++)
	{
		printf("%d\n",i);
	}
	return 0;
}
