#include<stdio.h>

int main()
{
    //let's assume the maximum array size as 100.
    //initialize sum as 0. Otherwise, it will take some garbage value.
    int size, i;
    long int  sum = 0;
    long int arr[100];
    
    //Get size input from user
//    printf("Enter array size\n");
    scanf("%d",&size);
    
    //Get all elements using for loop and store it in array
//    printf("Enter array elements\n");
    for(i = 0; i < size; i++)
          scanf("%ld",&arr[i]);
          
//    add all elements to the variable sum.
    for(i = 0; i < size; i++)
          sum = sum + arr[i]; // same as sum += arr[i];
    
    //print the result
 //   printf("Sum of the array = %d\n",sum);
    printf("%ld\n",sum);
    
    return 0;
}
