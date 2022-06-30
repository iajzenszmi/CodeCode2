#quadrature-integration.py
#quadrature-integration.py -n <n> -a <a> -b <b> -f <f>
#


import sys
import numpy as np
import matplotlib.pyplot as plt
import math
import argparse
import string

def f(x):
    return x**2


def trapezoidal(f, a, b, n):
    h = (b - a) / n                                                    
    sum = 0.5 * (f(a) + f(b))
    for i in range(1, n):                                               
        sum += f(a + i * h)                                             
    return h * sum



def simpson(f, a, b, n): 
    h = (b - a) / n                                                    
    sum = f(a) + f(b)                                                   
    for i in range(1, n, 2):                                            
        sum += 4 * f(a + i * h)                                         
    for i in range(2, n, 2):                                            
        sum += 2 * f(a + i * h)                                         
    return h * sum / 3                                                  




def main():
    parser = argparse.ArgumentParser(description='Quadrature integration')
    parser.add_argument('-n', type=int, default=10, help='number of inte')
    parser.add_argument('-a', type=float, default=0, help='left endpoint')
    parser.add_argument('-b', type=float, default=1, help='right endpoint')
    parser.add_argument('-f', type=str, default='x**2', help='function')
    args = parser.parse_args()                                          
    n = args.n                
    a = args.a   
    b = args.b
    f = args.f 
    print('Trapezoidal:', trapezoidal(f, a, b, n))
    print('Simpson:', simpson(f, a, b, n))
       
def plot(f, a, b, n):
    x = np.linspace(a, b, n)                   
    y = [f(i) for i in x]
    plt.plot(x, y)                                                           
    plt.show()  
    return 0


f=lambda x:x**2
a=0 #left endpoint
b=1 #right endpoint
n=10 #number of integrals
print('Trapezoidal:', trapezoidal(f, a, b, n))
print('Simpson:', simpson(f, a, b, n))
plot(f, a, b, n)

main()


 





















ian@ian-HP-Stream-Laptop-11-y0XX:~$ ls qu*
quadrature-integration.py
ian@ian-HP-Stream-Laptop-11-y0XX:~$ cat quadrature-integration.py
#quadrature-integration.py
#quadrature-integration.py -n <n> -a <a> -b <b> -f <f>
#


import sys
import numpy as np
import matplotlib.pyplot as plt
import math
import argparse
import string

def f(x):
    return x**2


def trapezoidal(f, a, b, n):
    h = (b - a) / n                                                    
    sum = 0.5 * (f(a) + f(b))
    for i in range(1, n):                                               
        sum += f(a + i * h)                                             
    return h * sum



def simpson(f, a, b, n): 
    h = (b - a) / n                                                    
    sum = f(a) + f(b)                                                   
    for i in range(1, n, 2):                                            
        sum += 4 * f(a + i * h)                                         
    for i in range(2, n, 2):                                            
        sum += 2 * f(a + i * h)                                         
    return h * sum / 3                                                  




def main():
    parser = argparse.ArgumentParser(description='Quadrature integration')
    parser.add_argument('-n', type=int, default=10, help='number of inte')
    parser.add_argument('-a', type=float, default=0, help='left endpoint')
    parser.add_argument('-b', type=float, default=1, help='right endpoint')
    parser.add_argument('-f', type=str, default='x**2', help='function')
    args = parser.parse_args()                                          
    n = args.n                
    a = args.a   
    b = args.b
    f = args.f 
    print('Trapezoidal:', trapezoidal(f, a, b, n))
    print('Simpson:', simpson(f, a, b, n))
       
def plot(f, a, b, n):
    x = np.linspace(a, b, n)                   
    y = [f(i) for i in x]
    plt.plot(x, y)                                                           
    plt.show()  
    return 0


f=lambda x:x**2
a=0 #left endpoint
b=1 #right endpoint
n=10 #number of integrals
print('Trapezoidal:', trapezoidal(f, a, b, n))
print('Simpson:', simpson(f, a, b, n))
plot(f, a, b, n)

main()


 





















ian@ian-HP-Stream-Laptop-11-y0XX:~$ ipython3 quadrature-integration.py
Trapezoidal: 0.3350000000000001
Simpson: 0.3333333333333335
                

