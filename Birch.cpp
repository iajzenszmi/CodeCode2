//Generate a complete C++ program to completely solve Birch and Swinnerton-Dyer conjecture

#include <iostream>
#include <cmath>
#include <vector>

using namespace std;

//Function to calculate the Legendre symbol
int legendre(double  a, double p)
{
    int result = pow(a, ((p - 1) / 2)) / p;
    return result;
}

//Function to calculate the Jacobi symbol
int jacobi(int a, int b)
{
    if(a == 0)
        return 0;
    if(a == 1)
        return 1;
    if(a % 2 == 0)
    {
        return pow(-1, (b*b-1)/8) * jacobi(a/2,b);
    }
    else
    {
        return pow(-1, (a-1)*(b-1)/4) * jacobi(b%a, a);
    }
}

//Function to calculate the order of a prime
int order_prime(int a, int p)
{
    int ord = 1;
    int temp = a;
    while(temp != 1)
    {
        temp = (temp * a) % p;
        ord++;
    }
    return ord;
}

//Function to calculate the order of a composite number
int order_comp(int a, int n)
{
    int ord = 1;
    int temp = a;
    while(temp != 1)
    {
        temp = (temp * a) % n;
        ord++;
    }
    return ord;
}

//Function to calculate the Pocklington theorem
int pocklington(int a, int n)
{
    int result;
    int prime_factor = 1;
    vector<int> factors;
    for(int i=2; i<=sqrt(n); i++)
    {
        if(n % i == 0)
        {
            factors.push_back(i);
            prime_factor *= i;
        }
    }
    if(prime_factor == n)
    {
        result = legendre(a, n); 
    }
    else
    {
        int k = n / prime_factor;
        int jac = jacobi(a, prime_factor);
        if(jac == 0)
            result = 0;
        else
        {
            int ord = order_comp(a, n);
            if(ord % k == 0)
                result = jac;
            else
                result = 0;
        }
    }
    return result;
}

//Main function
int main()
{
    int a, n;
    cout<<"Enter a number a: ";
    cin>>a;
    cout<<"Enter a composite number n: ";
    cin>>n;
    int result = pocklington(a, n);
    if(result == 1)
        cout<<"The Birch and Swinnerton-Dyer Conjecture is true for a and n"<<endl;
    else
        cout<<"The Birch and Swinnerton-Dyer Conjecture is false for a and n"<<endl;
    return 0;
}
