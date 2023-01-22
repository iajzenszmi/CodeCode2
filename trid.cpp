//generate a program to demonstrate the reduction of a symmetric matrix to tridiagnol form

#include <stdio.h>
#include <stdlib.h>
 
// Function to reduce matrix to tridiagonal form
void tridiagonal(int n, float a[][])
{
    int i, j, k;
    float m;
 
    for (k = 1; k < n - 1; k++) {
        for (i = k + 1; i < n; i++) {
            m = a[i][k] / a[k][k];
 
            for (j = k; j < n; j++)
                a[i][j] -= m * a[k][j];
 
            a[i][k] = 0;
        }
    }
}
 
// Function to print the tridiagonal matrix
void printMatrix(int n, float a[][])
{
    int i, j;
    for (i = 0; i < n; i++) {
        for (j = 0; j < n; j++)
            printf("%.2f\t", a[i][j]);
        printf("\n");
   
}
}
