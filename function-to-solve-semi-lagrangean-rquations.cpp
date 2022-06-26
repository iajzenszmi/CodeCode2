/* function to solve semi-lagrangean equations */
#include <iostream>
#include <cmath>
#include <cstdio>
#include <cstdlib>



using namespace std;
         
double f(double x)
{
        return x*x;                                                                                                                           
}


double df(double x)
{
        return 2*x;                                                                                                                           
}


double ddf(double x)
{
        return 2;                                                                                                                             
}
int main(){
	double x0 = 1;
        double x1 = 2;
        double x2 = 3;
        double x3 = 4;
        double x4 = 5;
        double x5 = 6;

	double y0 = f(x0);
	                                                                                                                   
        double y1 = f(x1);                                                                                                                    
        double y2 = f(x2);
        double y3 = f(x3);
        double y4 = f(x4);
        double y5 = f(x5);



double dydx0 = df(x0);
 double dydx1 = df(x1);                                                                                                                
        double dydx2 = df(x2);                                                                                                                
        double dydx3 = df(x3);                                                                                                                
        double dydx4 = df(x4); 
 double dydx5 = df(x5);                                                                                                                

                                                                                                                                                                                                                  

                                                                                                                
                                                                                                                
           

cout << "y0 = " << y0 << endl;
cout << "y1 = " << y1 << endl;
cout << "y2 = " << y2 << endl;
cout << "y3 = " << y3 << endl;
cout << "y4 = " << y4 << endl;
cout << "y5 = " << y5 << endl;


cout << "dydx0 = " << dydx0 << endl;
cout << "dydx1 = " << dydx1 << endl;
cout << "dydx2 = " << dydx2 << endl;
cout << "dydx3 = " << dydx3 << endl;
cout << "dydx4 = " << dydx4 << endl;
cout << "dydx5 = " << dydx5 << endl;





}









