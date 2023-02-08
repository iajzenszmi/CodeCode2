//generate a program which demonstrates  reduction of a symmertic matrix to tridiagonal form

#include <cstdio> 
#include <cmath> 
#include <iostream>  
#define SIZE 4 
  
// function for reduction into tridiagonal form 
void reductionToTridiagonal(int mat[4][4]) 
{ 
    for (int k = 1; k < SIZE - 2; k++) { 
        // loop to perform the gauss elimination 
        for (int i = k + 2; i < SIZE; i++) {
		std::cout << i << std::endl;
		std::cout << k << std::endl;
            float f = mat[i][k] / mat[k + 1][k]; 
  
            // loop to modify all elements of the 
            // corresponding row 
            for (int j = k + 1; j < SIZE; j++) 

                mat[i][j] -= mat[k + 1][j] * f; 
  
            // filling lower triangular matrix with zeros 
            mat[i][k] = 0.0;   
	} 
    } 
} 
  
// function to print the matrix 
void printTridiagonal(int mat[SIZE][SIZE]) 
{ 
    for (int i = 1; i < SIZE; i++) { 
        for (int j = 1; j < SIZE; j++) 
            printf("%d ", mat[i][j]); 
        printf("\n"); 
    } 
} 
  
// Driver function 
int main() 
{ 
    int mat[4][4] = { 
        { 25, 15, -5, -15 }, 
        { 15, 18, 0, -9 }, 
        { -5, 0, 11, 5 }, 
        { -15, -9, 5, 20 } 
    }; 
  
    reductionToTridiagonal(mat); 
    printf("Tridiagonal matrix after reduction: \n"); 
    printTridiagonal(mat); 
  
    return 0; 
}
