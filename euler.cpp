eulers theorem demo
+
#include <iostream>
#include <cmath>

using namespace std;

int main()
{
    int n,k;
    cout<<"Enter n and k: ";
    cin>>n>>k;
    int a=pow(n,k);
    cout<<"n^k = "<<a<<endl;
    int b=pow(n,k-1);
    cout<<"n^(k-1) = "<<b<<endl;
    int c=a%n;
    cout<<"n^k%n = "<<c<<endl;
    int d=b%n;
    cout<<"n^(k-1)%n = "<<d<<endl;
    int e=c*d;
    cout<<"n^k%n * n^(k-1)%n = "<<e<<endl;
    int f=e%n;
    cout<<"n^k%n * n^(k-1)%n %n = "<<f<<endl;
    return 0;
}
