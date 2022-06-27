# :Householder reduction of a real symmetric n by n matrix a stored in an np by np physical array on output a is replaced by the orthoganal matrix #
# Q effecting the transformation. D returns the diagonal elements of the tridiagonalmatrix, and E the off-diagonal elements with E(1) = 0 
import numpy as np
import matplotlib.pyplot as plt
import scipy.linalg as la
import scipy.sparse as sp
import scipy.sparse.linalg as sla


def householder(a):
    n = a.shape[0]
 #   n = a.shape[100]
    d = np.zeros(n)
    e = np.zeros(n)                                                                                                                           
    for i in range(n - 1):                                                                                                                    
        h = np.eye(n)                                                                                                                         
        h[i:, i] = -np.sign(a[i, i]) * np.linalg.norm(a[i:, i])                                                                               
        h[i, i] += 1                                                                                                                          
        a = h @ a @ h.T                                                                                                                       
        d[i] = a[i, i]                                                                                                                        
        e[i] = a[i, i + 1]                                                                                                                    
    d[n - 1] = a[n - 1, n - 1]                                                                                                                
    e[n - 1] = 0      
    return a, d, e

def  print_matrix(a):
    for i in range(a.shape[0]):                                                                                                               
        print(a[i, :])                                                                                                                        
    print("\n") 


useuser_input = input("Enter the number of rows and columns of the matrix: ")
rows = int(useuser_input.split()[0])
cols = int(useuser_input.split()[1])


a = np.random.rand(rows, cols)
a = np.tril(a)
a = a + a.T
print("The matrix is: ")
print_matrix(a)




a, d, e = householder(a)
print("The matrix after householder reduction is: ")
print_matrix(a)
print("The diagonal elements of the tridiagonal matrix are: ")
print(d)
print("The off-diagonal elements of the tridiagonal matrix are: ")
print(e)


# Plot the eigenvalues of the tridiagonal matrix
plt.plot(d)
plt.show()
plt.plot(e)
plt.show()




