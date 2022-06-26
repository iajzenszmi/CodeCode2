// function to calculate volume of a sphere
// volume of a sphere = 4/3 * pi * r^3
// r is the radius of the sphere
// pi is the value of pi
// r is a floating point number
// pi is a floating point number
// volume is a floating point number
//
// Input:
// r: radius of the sphere
// pi: value of pi
//
//Output:
// volume: volume of the sphere
//
//
// Algorithm:
// 1. Declare variables
// 2. Calculate volume
// 3. Return volume

//float volume(float r, float pi)
    
#include <iostream>
#include <cmath>
#include <cstdlib>
using namespace std;
                                                                         
       
                                                                                                  
                                                                                            
    int main(){ 
    float r, pi, volume2;
    
    cout << "Enter the radius of the sphere: "<< std::endl; 
                                                                                                  
    cin >> r;
   
                                                                                                       
    pi = 3.12; 
                                                                                                                                   
    volume2 =   (4.0/3.0) * pi * pow(r,2)  ;                                                   

    cout << "The volume of the sphere is: " << volume2 << std::endl;
                                                                                
    return  0;         
    
                                                                                                                            
}          

