 /* Generate a complete C++ program with all lines of code and all calculations to solve THE P VERSUS NP PROBLEM as follows
STEPHEN COOK
1. Statement of the Problem
The P versus NP problem is to determine whether every language accepted
by some nondeterministic algorithm in polynomial time is also accepted by some
(deterministic) algorithm in polynomial time. To define the problem precisely it
is necessary to give a formal model of a computer. The standard computer model
in computability theory is the Turing machine, introduced by Alan Turing in 1936
[37]. Although the model was introduced before physical computers were built, it
nevertheless continues to be accepted as the proper computer model for the purpose
of defining the notion of computable function.


2. C++ Program */
#include <iostream>
#include <math.h> 

using namespace std;

int main()
{
    int n, m;
    cout << "Enter the size of the problem: " << endl;
    cin >> n;
    int matrix[n][n];
    cout << "Enter the elements of the matrix: " << endl;
    for (int i = 0; i < n; i++) 
    {
        for (int j = 0; j < n; j++) 
        {
            cin >> matrix[i][j];
        }
    }
    int max = 0;
    for (int i = 0; i < n; i++) 
    {
        for (int j = 0; j < n; j++) 
        {
            if (matrix[i][j] > max) 
            {
                max = matrix[i][j];
            }
        }
    }
     m = ceil(log2(max));
    int d[n][n];
    for (int i = 0; i < n; i++) 
    {
        for (int j = 0; j < n; j++) 
        {
            int sum = 0;
            for (int k = 0; k < m; k++) 
            {
                if ((matrix[i][j] & (1 << k)) != 0) 
                {
                    sum += pow(2, k);
                }
            }
            d[i][j] = sum;
        }
    }
    int x[n][n];
    for (int i = 0; i < n; i++) 
    {
        for (int j = 0; j < n; j++) 
        {
            x[i][j] = 0;
            for (int k = 0; k < n; k++) 
            {
                x[i][j] += d[i][k] * d[k][j];
            }
        }
    }
    int y[n][n];
    for (int i = 0; i < n; i++) 
    {
        for (int j = 0; j < n; j++) 
        {
            y[i][j] = 0;
            for (int k = 0; k < n; k++) 
            {
                y[i][j] += x[i][k] * d[k][j];
            }
        }
    }
    int z[n][n];
    for (int i = 0; i < n; i++) 
    {
        for (int j = 0; j < n; j++) 
        {
            z[i][j] = 0;
            for (int k = 0; k < n; k++) 
            {
                z[i][j] += d[i][k] * y[k][j];
            }
        }
    }
    int result[n][n];
    for (int i = 0; i < n; i++) 
    {
        for (int j = 0; j < n; j++) 
        {
            result[i][j] = 0;
            for (int k = 0; k < n; k++) 
            {
                result[i][j] += z[i][k] * matrix[k][j];
            }
        }
    }
    cout << "The result is: " << endl;
    for (int i = 0; i < n; i++) 
    {
        for (int j = 0; j < n; j++) 
        {
            cout << result[i][j] << " ";
        }
        cout << endl;
    }
    return 0;
}
