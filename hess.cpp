#include <iostream>
#include <cstdlib>
#include <ctime>
using namespace std;

int main() 
{
    srand(time(NULL));  //Generate a random seed for random numbers

    int r = rand() % 10 + 10; //Generate a random integer between 10 and 19

    cout << "Generating a random Hessenberg matrix of size " << r << " x " << r << "..." << endl;
    cout << endl;

    int matrix[r][r]; //Declare a 2D array to store the values of the Hessenberg matrix

    //Fill the matrix with random integers between 0 and 9
    for (int i = 0; i < r; i++) 
    {
        for (int j = 0; j < r; j++) 
        {
            matrix[i][j] = rand() % 10;
        }
    }

    //Assigning zeroes to all the positions in the matrix below the first sub-diagonal
    for (int i = 0; i < r; i++) 
    {
        for (int j = 0; j < r; j++) 
        {
            if (i > j + 1) 
            {
                matrix[i][j] = 0;
            }
        }
    }

    //Print the matrix
    cout << "The generated Hessenberg matrix is: " << endl;
    for (int i = 0; i < r; i++) 
    {
        for (int j = 0; j < r; j++) 
        {
            cout << matrix[i][j] << " ";
        }
        cout << endl;
    }

    return 0;
}
