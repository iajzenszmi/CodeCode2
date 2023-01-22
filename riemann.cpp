//Generate a program to solve Riemann Hypothesis

#include <iostream> 
#include <cmath> 

using namespace std; 

//Function to check if a number is prime 
bool isPrime(int n) 
{ 
    // Corner cases 
    if (n <= 1)  return false; 
    if (n <= 3)  return true; 
  
    // This is checked so that we can skip  
    // middle five numbers in below loop 
    if (n%2 == 0 || n%3 == 0) return false; 
  
    for (int i=5; i*i<=n; i=i+6) 
        if (n%i == 0 || n%(i+2) == 0) 
           return false; 
  
    return true; 
} 

//Function to check if a number is a solution to the Riemann hypothesis 
bool isSolution(int n) 
{ 
    //Check if n is a prime 
    if (!isPrime(n)) 
        return false; 
  
    //Calculate the sum of the prime numbers 
    int sum = 0; 
    for (int i=1; i<=n; i++) 
        if (isPrime(i)) 
            sum += i; 
  
    //Check if the sum of prime numbers is equal to n 
    if (sum == n) 
        return true; 
  
    return false; 
} 

int main() 
{ 
    //Check if any number is a solution to the Riemann Hypothesis 
    for (int i=1; i<=1000; i++) 
    { 
        if (isSolution(i)) 
            cout << i << " is a solution to the Riemann Hypothesis\n"; 
    } 
  
    return 0; 
}
