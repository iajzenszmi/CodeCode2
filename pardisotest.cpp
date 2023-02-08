//Example C-7. pardiso_sym.c for Symmetric Linear Systems
/* --------------------------------------------------------------------*/
/* Example program to show the use of the "PARDISO" routine */
/* on symmetric linear systems*/
/* --------------------------------------------------------------------*/
/* This program can be downloaded from the following site: */
/* http://www.computational.unibas.ch/cs/scicomp*/
/* */
/* (C) Olaf Schenk, Department of Computer Science, */
/* University of Basel, Switzerland.*/
/* Email: olaf.schenk@unibas.ch*/
/* --------------------------------------------------------------------*/
#include <stdio.h>
// #include <stdlib.h>
#include <math.h>
// #include <cstdlib>
// #include <cmath>
extern int omp_get_max_threads();
/* PARDISO prototype. */
extern int PARDISO
(void *, int *, int *, int *, int *, int *,
double *, int *, int *, int*, int *, int *,
int *, double *, double *, int*);
int main( void ) {
/* Matrix data. */
int n = 8;
int ia[ 9] = { 1, 5, 8, 10, 12, 15, 17, 18, 19 };
int ja[18] = { 1, 3, 6, 7,2, 3, 5,3, 8,4, 7,5, 6, 7,6, 8,7,8 };
double a[18] = { 7.0, 1.0, 2.0, 7.0,-4.0, 8.0, 2.0,
1.0, 5.0,
7.0, 9.0,
5.0, 1.0, 5.0,
-1.0, 5.0,
11.0,
5.0 };
int mtype = -2; /* Real symmetric matrix */
/* RHS and solution vectors.*/
double b[8], x[8];
int nrhs = 1; /* Number of right hand sides. */
/* Internal solver memory pointer pt, */
/* 32-bit: int pt[64]; 64-bit: long int pt[64] */
/* or void *pt[64] should be OK on both architectures */
void *pt[64];
/* Pardiso control parameters.*/
int iparm[64];
int maxfct, mnum, phase, error, msglvl;
/* Auxiliary variables. */
int i;
double ddum; /* Double dummy*/
//2798
//C Intel® Math Kernel Library Reference Manual
int idum; /* Integer dummy.*/
/* --------------------------------------------------------------------*/
/* .. Setup Pardiso control parameters.*/
/* --------------------------------------------------------------------*/
for (i = 0; i < 64; i++) {
iparm[i] = 0;
}
iparm[0] = 1; /* No solver default*/
iparm[1] = 2; /* Fill-in reordering from METIS */
/* Numbers of processors, value of OMP_NUM_THREADS */
iparm[2] = omp_get_max_threads();
iparm[3] = 0; /* No iterative-direct algorithm */
iparm[4] = 0; /* No user fill-in reducing permutation */
iparm[5] = 0; /* Write solution into x */
iparm[6] = 16; /* Default logical fortran unit number for output */
iparm[7] = 2; /* Max numbers of iterative refinement steps */
iparm[8] = 0; /* Not in use*/
iparm[9] = 13; /* Perturb the pivot elements with 1E-13 */
iparm[10] = 1; /* Use nonsymmetric permutation and scaling MPS */
iparm[11] = 0; /* Not in use*/
iparm[12] = 0; /* Not in use*/
iparm[13] = 0; /* Output: Number of perturbed pivots */
iparm[14] = 0; /* Not in use*/
iparm[15] = 0; /* Not in use*/
iparm[16] = 0; /* Not in use*/
iparm[17] = -1; /* Output: Number of nonzeros in the factor LU */
iparm[18] = -1; /* Output: Mflops for LU factorization */
iparm[19] = 0; /* Output: Numbers of CG Iterations */
//2799
//Code Examples C
maxfct = 1; /* Maximum number of numerical factorizations. */
mnum = 1; /* Which factorization to use. */
msglvl = 0; /* Don't print statistical information in file */
error = 0; /* Initialize error flag */
/* --------------------------------------------------------------------*/
/* .. Initialize the internal solver memory pointer. This is only */
/* necessary for the FIRST call of the PARDISO solver. */
/* --------------------------------------------------------------------*/
for (i = 0; i < 64; i++) {
pt[i] = 0;
}
/* --------------------------------------------------------------------*/
/* .. Reordering and Symbolic Factorization. This step also allocates */
/* all memory that is necessary for the factorization. */
/* --------------------------------------------------------------------*/
phase = 11;
PARDISO (pt, &maxfct, &mnum, &mtype, &phase,
&n, a, ia, ja, &idum, &nrhs,
iparm, &msglvl, &ddum, &ddum, &error);
if (error != 0) {
printf("\nERROR during symbolic factorization: %d", error);
return(1);
}
printf("\nReordering completed ... ");
printf("\nNumber of nonzeros in factors = %d", iparm[17]);
printf("\nNumber of factorization MFLOPS = %d", iparm[18]);
/* --------------------------------------------------------------------*/
/* .. Numerical factorization.*/
//2800
//C Intel® Math Kernel Library Reference Manual
/* --------------------------------------------------------------------*/
phase = 22;
PARDISO (pt, &maxfct, &mnum, &mtype, &phase,
&n, a, ia, ja, &idum, &nrhs,
iparm, &msglvl, &ddum, &ddum, &error);
if (error != 0) {
printf("\nERROR during numerical factorization: %d", error);
return(2);
}
printf("\nFactorization completed ... ");
/* --------------------------------------------------------------------*/
/* .. Back substitution and iterative refinement. */
/* --------------------------------------------------------------------*/
phase = 33;
iparm[7] = 2; /* Max numbers of iterative refinement steps. */
/* Set right hand side to one.*/
for (i = 0; i < n; i++) {
b[i] = 1;
}
PARDISO (pt, &maxfct, &mnum, &mtype, &phase,
&n, a, ia, ja, &idum, &nrhs,
iparm, &msglvl, b, x, &error);
if (error != 0) {
printf("\nERROR during solution: %d", error);
return(3);
}
printf("\nSolve completed ... ");
printf("\nThe solution of the system is: ");
//2801
//Code Examples C
for (i = 0; i < n; i++) {
printf("\n x [%d] = % f", i, x[i] );
}
printf ("\n");
/* --------------------------------------------------------------------*/
/* .. Termination and release of memory. */
/* --------------------------------------------------------------------*/
phase = -1; /* Release internal memory. */
PARDISO (pt, &maxfct, &mnum, &mtype, &phase,
&n, &ddum, ia, ja, &idum, &nrhs,
iparm, &msglvl, &ddum, &ddum, &error);
return 0;
}

