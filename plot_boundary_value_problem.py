#plot boundary value problem
def plot_boundary_value_problem():

    import matplotlib.pyplot as plt
    import numpy as np 
    x=np.linspace(-1,1,100)
    y=np.linspace(-1,1,100)
    u = np.zeros((len(x), len(y)))
    x_min = np.min(x)
    x_max = np.max(x)
    y_min = np.min(y)
    y_max = np.max(y)
    x = np.linspace(x_min, x_max, 100)
    y = np.linspace(y_min, y_max, 100)        
    levels=np.linspace(-1, 1, 30)


# Plot the solution
    plt.figure(figsize=(10, 10))
    plt.contourf(x, y, u, 100, cmap='jet')                                                                                                    
    plt.colorbar()                                                                                                                            
    plt.xlabel('x')                                                                                                                           
    plt.ylabel('y')                                                                                                                           
    plt.title('Boundary value problem')                                                                                                       
    plt.xlim(x_min, x_max)                                                                                                                    
    plt.ylim(y_min, y_max)                                                                                                                    
    plt.show()                                                                                                                                
    plt.savefig('boundary_value_problem.png')                                                                                                 
    plt.close()                                                                                                                               
    return 0


plot_boundary_value_problem()






























