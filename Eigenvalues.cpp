//createand debug  eigenvalues program
 
#include <iostream> 
#include <math.h> 
using namespace std; 

// function to find the discriminant of a quadratic equation
double findDiscriminant(double a, double b, double c) 
{ 
    return b * b - 4 * a * c; 
} 

// Function to find the roots of a quadratic equation
void findRoots(double a, double b, double c) 
{ 
    double discriminant = findDiscriminant(a, b, c); 
    if (discriminant > 0) { 
        double root1 = (-b + sqrt(discriminant)) / (2 * a); 
        double root2 = (-b - sqrt(discriminant)) / (2 * a); 
        cout << "Root 1 = " << root1 << endl; 
        cout << "Root 2 = " << root2 << endl; 
    } 
    else if (discriminant == 0) { 
        double root1 = -b / (2 * a); 
        cout << "Root 1 = Root 2 =" << root1 << endl; 
    } 
    else { 
        cout << "No real roots" << endl; 
    } 
} 

// Function to find the eigenvalues of a matrix
void findEigenvalues(double a, double b, double c) 
{ 
    double discriminant = findDiscriminant(a, b, c); 
    double eigenvalue1 = (-b + sqrt(discriminant)) / (2 * a); 
    double eigenvalue2 = (-b - sqrt(discriminant)) / (2 * a); 
    cout << "Eigenvalue 1 = " << eigenvalue1 << endl; 
    cout << "Eigenvalue 2 = " << eigenvalue2 << endl; 
} 

// Driver program
int main() 
{ 
    double a, b, c; 
    cout << "Enter the coefficient of x^2: "; 
    cin >> a; 
    cout << "Enter the coefficient of x: "; 
    cin >> b; 
    cout << "Enter the coefficient of 1: "; 
    cin >> c; 

    // finding roots 
    findRoots(a, b, c); 

    // finding eigenvalues 
    findEigenvalues(a, b, c); 
  
    return 0; 
}
