//fibonacci-series.c - Calculate the fibonacci series
//
// Compile: gcc fibonacci-series.c -o fibonacci-series
// // Run: ./fibonacci-series
//
//Input: None
//Output: The fibonacci series
//
//Algorithm:
////1. Declare a variable called n and assign it the value of 0
//
//////2. Declare a variable called a and assign it the value of 0
//
////////3. Declare a variable called b and assign it the value of 1
//
////////4. Declare a variable called c and assign it the value of 0


//5. Declare a variable called i and assign it the value of 0
//
////6. Declare a variable called sum and assign it the value of 0
//
/////7. Declare a variable called temp and assign it the value of 0
//
////////8. Declare a variable called temp2 and assign it the value of 0
//
////////////9. Declare a variable called temp3 and assign it the value of 0
//
////////////////10. Declare a variable called temp4 and assign it the value of 0
//
#include <stdio.h>



int  main()                                                                                                                                    
{                                                                                                                                             
        int n = 0;                                                                                                                            
        int a = 0;                                                                                                                            
        int b = 1;                                                                                                                            
        int c = 0;                                                                                                                            
        int i = 0;                                                                                                                            
        int sum = 0;                                                                                                                          
        int temp = 0;                                                                                                                         
        int temp2 = 0;                                                                                                                        
        int temp3 = 0;                                                                                                                        
        int temp4 = 0;                                                                                                                        
                                                                                                                                              
        printf("Enter the number of terms in the fibonacci series: ");                                                                        
        scanf("%d", &n);                                                                                                                      
                                                                                                                                              
        for(i = 0; i < n; i++)                                                                                                                
        {                                                                                                                                     
                sum = a + b;                                                                                                                  
                a = b;                                                                                                                        
                b = sum;                                                                                                                      
                printf("%d\n", sum);                                                                                                          
        }                                                                                                                                     
                                                                                                                                              
        return 0;                                                                                                                             
}                                                                                                                                             
//

//
//
