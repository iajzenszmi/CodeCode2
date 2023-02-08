#include <math.h>
#include <stdio.h>
#define N 100

int main(void)
{
  int i;
  double x[N], y[N];
  FILE *fp;

  for(i=0; i<N; i++){
    x[i] = (double)i/10.0;
    y[i] = x[i]*x[i];
  }

  fp = fopen("fortransub.dat", "w");
  if(fp == NULL){
    printf("cannot open file\n");
    exit(1);
  }

  for(i=0; i<N; i++){
    fprintf(fp, "%f %f\n", x[i], y[i]);
  }

  fclose(fp);

  return 0;

}
