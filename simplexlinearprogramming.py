# Example
# See also: Revised simplex algorithm § Numerical example

#Consider the linear program

 #   Minimize

  #      Z = − 2 x − 3 y − 4 z {\displaystyle Z=-2x-3y-4z\,} Z=-2x-3y-4z\,

   # Subject to

    #    3 x + 2 y + z ≤ 10 2 x + 5 y + 3 z ≤ 15 x , y , z ≥ 0 {\displaystyle {\begin{aligned}3x+2y+z&\leq 10\\2x+5y+3z&\leq 15\\x,\,y,\,z&\geq 0\end{aligned}}} {\begin{aligned}3x+2y+z&\leq 10\\2x+5y+3z&\leq 15\\x,\,y,\,z&\geq 0\end{aligned}}

#With the addition of slack variables s and t, this is represented by the canonical tableau

 #   [ 1 2 3 4 0 0 0 0 3 2 1 1 0 10 0 2 5 3 0 1 15 ] {\displaystyle {\begin{bmatrix}1&2&3&4&0&0&0\\0&3&2&1&1&0&10\\0&2&5&3&0&1&15\end{bmatrix}}} {\begin{bmatrix}1&2&3&4&0&0&0\\0&3&2&1&1&0&10\\0&2&5&3&0&1&15\end{bmatrix}}

#where columns 5 and 6 represent the basic variables s and t and the corresponding basic feasible solution is

 #   x = y = z = 0 , s = 10 , t = 15. {\displaystyle x=y=z=0,\,s=10,\,t=15.} x=y=z=0,\,s=10,\,t=15.

#Columns 2, 3, and 4 can be selected as pivot columns, for this example column 4 is selected. The values of z resulting from the choice of rows 2 and 3 as pivot rows are 10/1 = 10 and 15/3 = 5 respectively. Of these the minimum is 5, so row 3 must be the pivot row. Performing the pivot produces

 #   [ 3 − 2 − 11 0 0 − 4 − 60 0 7 1 0 3 − 1 15 0 2 5 3 0 1 15 ] {\displaystyle {\begin{bmatrix}3&-2&-11&0&0&-4&-60\\0&7&1&0&3&-1&15\\0&2&5&3&0&1&15\end{bmatrix}}} {\displaystyle {\begin{bmatrix}3&-2&-11&0&0&-4&-60\\0&7&1&0&3&-1&15\\0&2&5&3&0&1&15\end{bmatrix}}}

#Now columns 4 and 5 represent the basic variables z and s and the corresponding basic feasible solution is

 #   x = y = t = 0 , z = 5 , s = 5. {\displaystyle x=y=t=0,\,z=5,\,s=5.} x=y=t=0,\,z=5,\,s=5.

#For the next step, there are no positive entries in the objective row and in fact

 #   Z = − 60 + 2 x + 11 y + 4 t 3 = − 20 + 2 x + 11 y + 4 t 3 {\displaystyle Z={\frac {-60+2x+11y+4t}{3}}=-20+{\frac {2x+11y+4t}{3}}} {\displaystyle Z={\frac {-60+2x+11y+4t}{3}}=-20+{\frac {2x+11y+4t}{3}}}

#so the minimum value of Z is −20.
 
#

#
#   Minimize

import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
import scipy.optimize as sco
import scipy.io as sio
import scipy.io as si



def generate_simplex_programming_test_data_from_random_numbers():
    data = np.random.rand(12,12)                                                       
    return data  
#def generate_simplex_programming_test_datadef generate_simplex_programming_test_data():
#data = sio.loadmat('simplexlinearprogramming.mat')
def generate_tableau(data):
#    data = data['simplexlinearprogramming']
    data = np.array(data)                                                                                                                             
    return data 
def generate_tableau(data):
#   data = data['simplexlinearprogramming']
    data = np.array(data)                                                                                                                             
    return data 
def calculate_pivot_row(data): 
    pivot_row = np.argmin(data[:,4])                                                                                                              
    return pivot_row  


def  calculate_pivot_column(data):
     pivot_column = np.argmin(data[:,4])                                                                                                           
     return pivot_column 

#data = sio.loadmat('simplexlinearprogramming.mat')
def  calculate_pivot_value(data, pivot_row, pivot_column):
     pivot_value = data[pivot_row, pivot_column]
     return pivot_value



#import scipy.optimize as sco
#linearprogramming = sio.loadmat('simplexlinearprogramming.mat')
# Load data # Load data from matlab file

#def  load_data(data):
#     data = data['simplexlinearprogramming']                                                                                                   
#     return data

def  calculate_pivot_row(data):
     pivot_row = np.argmin(data[:,4])
     return pivot_row

def  calculate_pivot_column(data):
     pivot_column = np.argmin(data[:,4])                                                                                                      
     return pivot_column


def  calculate_pivot_value(data, pivot_row, pivot_column):
          pivot_value = data[pivot_row, pivot_column]
          return pivot_value




def  print_tableau(data):
     print('Tableau:')
     print(data)                                                                                                                              
     print('\n') 

def  print_pivot_row(data, pivot_row):
     print('Pivot row:')                                                                                                                              
     print(data[pivot_row,:])                                                                                                                         
     print('\n') 


def  calculate_basic_variables(data):
     basic_variables = np.where(data[:,4] == 0)                                                                                               
     return basic_variables




def  calculate_nonbasic_variables(data):
         nonbasic_variables = np.where(data[:,4] != 0)
         return nonbasic_variables


def  calculate_basic_variables_values(data, basic_variables):
     basic_variables_values = data[:,basic_variables]
     return basic_variables_values


def  calculate_nonbasic_variables_values(data, nonbasic_variables):  
      #  calculate_nonbasic_variables_values(data, nonbasic_variables):
      #  nonbasic_variables_values = data[:,nonbasic_variables]
      return nonbasic_variables_values  

def  calculate_nonbasic_variables_values(data, nonbasic_variables):
      nonbasic_variables_values = data[:,nonbasic_variables]
      return nonbasic_variables_values  





array = np.array([[1,2,3],[4,5,6],[7,8,9]])
data = np.array([[1,2,3,4,5,6,7,8,9,10,11,12],[13,14,15,16,17,18,19,20,21,22,23,24],[25,26,27,28,29,30,31,32,33,34,35,36]])
#generate_simplex_programming_test_data_from_random_numbers()
generate_tableau(data)
#pivot_value = data[pivot_row, pivot_column]
pivot_row = np.argmin(data[:,4])
pivot_column = np.argmin(data[:,4])
pivot_value = data[pivot_row, pivot_column]

#calculate_pivot_row(data)
#calculate_pivot_column(data)
calculate_pivot_value(data, pivot_row, pivot_column)
print_tableau(data)
print_pivot_row(data, pivot_row)
basic_variables = np.where(data[:,4] == 0)
nonbasic_variables = np.where(data[:,4] != 0)
calculate_basic_variables(data)
calculate_nonbasic_variables(data)
calculate_basic_variables_values(data, basic_variables)
calculate_nonbasic_variables_values(data, nonbasic_variables)


print(data)
print(data[:,4])
print(data[:,4] == 0)
print(data[:,4] != 0)





























# Load data from matlab file
















