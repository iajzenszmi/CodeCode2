#calculates the sine transform of a set of N real-valued data points stored in array Y. The anumber N must be a power of 2. On exit Y is replaced by its transform. This program also calculates the invers sine transform.in this casethe output array should be multiplied by 2/N.
#The program uses the FFT algorithm.
#The program is a translation of the Fortran program of the same name by D. E. S
#Patt, and is based on the algorithm of G. W. B. Malcolm, "An Algorithm for the
#Sine Transform and its Inverse", IEEE
#Transactions on Circuits and Systems, CAS-32, 3, 1977, pp. 477-483


import numpy as np
import matplotlib.pyplot as plt
import math


def sinetransform(y):
    n = 10                                                                
    if n == 1:
        return y                                                                
    else:                                                                       
        n2 = int(n / 2)                                                         
        y1 = y[0:n2]                                                            
        y2 = y[n2:n]                                                            
      #  y1 = sinetransform(y1)                                                  
       # y2 = sinetransform(y2)                                                  
        c = math.cos(math.pi / n)                                               
        s = math.sin(math.pi / n)                                               
        c1 = 1.0 - c                                                            
        s1 = -s      
        
        

        for i in range(n2):                                                     
            t = y1[i]                                                           
            y1[i] = t * c + y2[i] * s                                           
            y2[i] = t * s + y2[i] * c                                           
        return np.concatenate((y1, y2)) 
    n = 10
    if n == 1:
        return  y                                                               
    else:                                                                       
        n2 =int( n / 2 )                                                            
        y0 = y[:n2]                                                             
        y1 = y[n2:]                                                             
     #   y0 = sinetransform(y0)                                                  
      #  y1 = sinetransform(y1)                                                  
        y = np.zeros(n)                                                         
        for k in range(n2):                                                     
            t = math.cos(math.pi * k / n2) * y1[k] - math.sin(math.pi * k / n2) 
            y[k] = t                                                            
            y[k + n2] = math.sin(math.pi * k / n2) * y1[k] + math.cos(math.pi * k / n2) * y0[k]
        return y
                    


def sinetransform_inverse(y):



    n = 10                                                                  
    if n == 1:
        return y                                                              
    else:                                                                       
        n2 = int(n / 2)                                                             
        y0 = y[:n2]                                                             
        y1 = y[n2:]                                                             
 #       y0 = sinetransform_inverse(y0)                                          
 #       y1 = sinetransform_inverse(y1)                                          
        y = np.zeros(n)                                                         
        for k in range(n2):                                                     
            t = math.cos(math.pi * k / n2) * y1[k] - math.sin(math.pi * k / n2) 
            y[k] = t                                                            
            y[k + n2] = math.sin(math.pi * k / n2) * y1[k] + math.cos(math.pi * k / n2) * y0[k]
        return y

def  print_array(y):
      for i in range(len(y)):
          print(y[i])




y = np.array([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
print("Original array:")
print_array(y)
#sinetransform(y
print("Sine transform:")
print_array(sinetransform(y))
print("Inverse sine transform:")
print_array(sinetransform_inverse(y))
plt.plot(y)
plt.plot(sinetransform(y))
plt.plot(sinetransform_inverse(y)) # inverse of the sine transform
plt.show()
 
#for i in range(len(y)):     
#  print(y[i])
#netransform_inverse(y)
#print_array(y)
#for i in range(len(y)):     
#        print(y[i])  
#        plt.plot(y)                                                             
#        plt.show()
       

        

















































