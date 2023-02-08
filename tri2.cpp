generate a program which demonstrates  reduction of a symmertic matrix to tridiagonal matrix  form

#include<iostream>
#include<math.h>
using namespace std;
 
// Function to get cofactor of A[p][q] in temp[][]. n is current
// dimension of A[][]
void getCofactor(int A[][20], int temp[][20], int p, int q, int n)
{
    int i = 0, j = 0;
 
    // Looping for each element of the matrix
    for (int row = 0; row < n; row++)
    {
        for (int col = 0; col < n; col++)
        {
            // Copying into temporary matrix only those element
            // which are not in given row and column
            if (row != p && col != q)
            {
                temp[i][j++] = A[row][col];
 
                // Row is filled, so increase row index and
                // reset col index
                if (j == n - 1)
                {
                    j = 0;
                    i++;
                }
            }
        }
    }
}
 
/* Recursive function for finding determinant of matrix.
   n is current dimension of A[][]. */
int determinant(int A[][20], int n)
{
    int D = 0; // Initialize result
 
    // Base case : if matrix contains single element
    if (n == 1)
        return A[0][0];
 
    int temp[20][20]; // To store cofactors
 
    int sign = 1;  // To store sign multiplier
 
     // Iterate for each element of first row
    for (int f = 0; f < n; f++)
    {
        // Getting Cofactor of A[0][f]
        getCofactor(A, temp, 0, f, n);
        D += sign * A[0][f] * determinant(temp, n - 1);
 
        // terms are to be added with alternate sign
        sign = -sign;
    }
 
    return D;
}
 
// Function to get adjoint of A[N][N] in adj[N][N].
void adjoint(int A[][20],int adj[][20],int N)
{
    if (N == 1)
    {
        adj[0][0] = 1;
        return;
    }
 
    // temp is used to store cofactors of A[][]
    int sign = 1, temp[20][20];
 
    for (int i=0; i<N; i++)
    {
        for (int j=0; j<N; j++)
        {
            // Get cofactor of A[i][j]
            getCofactor(A, temp, i, j, N);
 
            // sign of adj[j][i] positive if sum of row
            // and column indexes is even.
            sign = ((i+j)%2==0)? 1: -1;
 
            // Interchanging rows and columns to get the
            // transpose of the cofactor matrix
            adj[j][i] = (sign)*(determinant(temp, N-1));
        }
    }
}
 
// Function to calculate and store inverse, returns false if
// matrix is singular
bool inverse(int A[][20], float inverse[][20], int N)
{
    // Find determinant of A[][]
    int det = determinant(A, N);
    if (det == 0)
    {
        cout << "Singular matrix, can't find its inverse";
        return false;
    }
 
    // Find adjoint
    int adj[20][20];
    adjoint(A, adj, N);
 
    // Find Inverse using formula "inverse(A) = adj(A)/det(A)"
    for (int i=0; i<N; i++)
        for (int j=0; j<N; j++)
            inverse[i][j] = adj[i][j]/float(det);
 
    return true;
}
 
// Function to reduce matrix to tridiagonal form
void toTridiagonal(float A[][20], float D[20], float E[20], int N)
{
    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < N; j++)
        {
            if(j != i && j != i+1)
            {
                A[i][j] = 0;
            }
        }
    }
 
    for (int i = 0; i < N; i++)
    {
        D[i] = A[i][i];
        E[i] = A[i][i + 1];
    }
}
 
// Driver program
int main()
{
    int N;
 
    cout << "Enter the size of the square matrix: ";
    cin >> N;
 
    int A[20][20];
    float A1[20][20];
    float D[20], E[20], inverse[20][20];
 
    cout << "Enter the elements of the matrix: " << endl;
    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < N; j++)
        {
            cin >> A[i][j];
            A1[i][j] = A[i][j];
        }
    }
 
    toTridiagonal(A1, D, E, N);
 
    cout << endl << "The Tridiagonal Matrix is: " << endl;
    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < N; j++)
        {
            cout << A1[i][j] << "\t";
        }
        cout << endl;
    }
 
    cout << endl << "The Diagonal Array is: " << endl;
    fo (int i = 0; i < N; i++)
    {
        cout << D[i] << "\t";
    }
 
    cout << endl << "The Subdiagonal Array is: " << endl;
    for (int i = 0; i < N - 1; i++)
    {
        cout << E[i] << "\t";
    }
 
    if (inverse(A, inverse, N))
    {
        cout << endl << "The Inverse is: " << endl;
        for (int i=0; i<N; i++)
        {
            for (int j=0; j<N; j++)
            {
                cout << inverse[i][j] << "\t";
            }
            cout << endl;
        }
    }
 
    return 0;
}r
