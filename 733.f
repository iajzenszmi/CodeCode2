C      ALGORITHM 733, COLLECTED ALGORITHMS FROM ACM.
C      THIS WORK PUBLISHED IN TRANSACTIONS ON MATHEMATICAL SOFTWARE,
C      VOL. 20, NO. 3, SEPTEMBER, 1994, PP. 262-281.
C File TOMP.TXT
C=============
C
C The file TOMP.FOR contains the following groups of subroutines
C for solving optimal control problems as described in [1].
C
C   1. A SIMULATOR, in which initial-value problems are solved
C      for given parameter values.
C      Cost function and constraint vector together with gradient
C      vector and Jacobi matrix are evaluated.
C
C  2. An OPTIMIZER, in which new parameter values are proposed
C      as a result of the SIMULATOR output.
C
C   3. A test driver which solves the state-constrained
C      brachistochrone problem.
C      Test results for a couple of other problems can be found in [1].
C
C
C Only a double precision version exists at the moment.
C Creating of a single precision version should not be to difficult,
Cas ALL variables are explicitely declared in TYPE statements.
C All major subroutines are carefully commented
C The heading comments (parameter description, dimensioning, etc.)
C are also given in the appendices to [1].
CThe optimizer makes havy use of some level 1 Blas [2] routines which are
Cincluded. Also modified versions of the routines HFTI, LDP and NNLS
Cfrom [3], RKF45 from [4], LEFT from [5], and FMIN from [6] are included.
CI acknowledge the influence of these examplary software projects
Con my programming style.
C
CThe sample data for the test driver are included by parameter,
Cdata, or assignment statements within the driver.
CThe execution output from file TOMP.OUT follows at the end of this file.
CAlso included is the output from file TOMP.M for graphical postprocessing
Cwith MATLAB [7]. If MATLAB is available to you, just type (at the DOS prompt):
CMATLAB
Cand then (at the Matlab prompt)
C>tomp
C>plot(x1,-x2), grid
C(and you should see fig.2 of accompanying VDI-report on screen)
C
CThis output has been produced on a Compaq DeskPro 486/33L with the
Cintegrated Intel Co-Processor, using version 2.5 of the 32-bit compiler
CFTN77 of the University of Salford.
CThe program has been run under a series of other compilers including
CFORTRAN/2 Version 1.04, LAHEY F77L32 Version 3.0,
CMICROSOFT FORTRAN Version 5.0, MICROWAY NDPF486 Version 3.2,
CWATCOM WATFOR78 Version 3.1, WATCOM WFL386 Version 8.0.
C
C[1] D. Kraft: TOMP -- FORTRAN Modules for Optimal Control Calculations.
CFortschritt-Berichte VDI Reihe 8 Nr. 254. VDI-Verlag, Dsseldorf, 1991.
C
C[2] C.L. Lawson, R.J. Hanson, D.R. Kincaid, F.T. Krogh:
CBasic Linear Algebra Subprograms for FORTRAN Usage.
CSandia Laboratories Tech. Rept. SAND77-0898, and
CACM Trans. Math. Softw. 5 (1979) 324-325.
C
C[3] C.L. Lawson, R.J. Hanson: Solving Least Squares Problems.
CPrentice Hall, Englewood Cliffs, New Jersey, 1974.
C
C[4] L.F. Shampine, H.A. Watts: The Art of Writing a Runge-Kutta Code
CAppl. Math. Comp. 5 (1979) 93-121.
C
C[5] C. de Boor: A Practical Guide to Splines. Springer, New York, 1978.

C[6] R.P.Brent: Algorithms for Minimization without Derivatives.
C Prentice-Hall, Englewood Cliffs, 1973.
C
C [7] J. Little, C. Moler: 386-MATLAB User's Guide.
C The MathWorks, Natick, MA, 1989.
C
C
CFile TOMP.OUT:
C==============

C   TOMP: FORTRAN MODULES for OPTIMAL CONTROL CALCULATIONS

c   you will find the  test driver at the end of this file
c   corresponding results have been written to the accompanying
c   file tomp.txt. In that file also some remarks concerning
c   TOMP have been included.

C   Dieter Kraft
C   Fachhochschule Mnchen


************************************************************************
*                              SIMULATOR                               *
************************************************************************

      SUBROUTINE d_TOMP (SLV, RHS, VALUES, OUTPUT, IV, X, Y,
     *                   Z, Z0, Z1, ACC, F, C, DF, DC, LC)

C   d_TOMP    EVALUATION OF COST FUNCTION F(X) AND CONSTRAINT VECTOR
C             C(X), TOGETHER WITH GRADIENT DF(X) AND JACOBIAN DC(X).


C   USAGE :
C     CALL d_TOMP (SLV, RHS, VALUES, OUTPUT, IV, X, Y,
C    *              Z, Z0, Z1, ACC, F, C, DF, DC, LC)

C   PURPOSE :
C                    SIMULATES SYSTEM GIVEN IN RHS
C          FOR GIVEN INITIAL CONDITIONS Z0 AND GIVEN CONTROLS X
C     EVALUATES DEVIATIONS FROM FINAL CONDITIONS Z1 AND FROM TRAJEC-
C     TORY CONSTRAINTS SPECIFIED IN USER SUPPLIED SUBROUTINE VALUES;
C     ALSO PARTIAL DERIVATIVES OF Z WITH RESPECT TO X ARE GENERATED.

C   INPUT ARGUMENTS :
C     FIRST FOUR ARGUMENTS ARE SUBROUTINES WHICH HAVE TO BE DECLARED
C     EXTERNAL IN THE CALLING PROGRAM.
C     THE CALLING SEQUENCE CAN BE FOUND AT THE RESPECTIVE LINES IN TOMP.
C     SLV :    INITIAL VALUE SOLVER
C              USAGE:
C              CALL SLV(RHS, NZ, Z, T0, T1, RE, AE, IFLAG, W, IW, X, IV)
C              PARAMETER DESCRIPTION TO BE FOUND IN THE DESCRIPTION OF
C              SUBROUTINE SLV later in this PACKAGE
C     RHS :    RHS(T,Z,ZDOT,X,IV) DESCRIBES THE SIMULATED SYSTEM OF
C              ORDINARY DIFFERENTIAL EQUATIONS ZDOT(T)=PHI(T,Z,X,IV).
C     VALUES : USER SUPPLIED SUBROUTINE WHICH
C              EVALUATES BOUNDARY CONDITIONS, TRAJECTORY CONSTRAINTS,
C              AND COST. FURTHER INFORMATION CAN BE TAKEN FROM THE
C              EXAMPLE PROBLEM.
C              USAGE:
C              CALL VALUES (RHS, IV, T0, X, Y, Z, Z0, Z1, W, F, C, j)
C              PARAMETERS ARE AS DESCRIBED IN THE PRESENT DESCRIPTION
C                 INPUT: RHS, IV, T0, X, Y, Z, j
C                        WHERE T0 IS THE CURRENT TIME IN d_TOMP,
C                        j MUST BE ZERO FOR THE FIRST CALL AFTERWARDS
C                        j IS THE INDEX OF THE COMMUNICATION INTERVAL
C                        SET BY d_TOMP.
C                 OUTPUT: Z0, Z1 MUST BE GIVEN BY THE USER FOR j=0
C                        COST F and BOUNDARY VALUES C MUST BE FORMUL-
C                        ATED FOR THE LAST COMMUNICATION POINT
C                        INTERMEDIATE VALUES OF C CAN BE FORMULATED
C                        FOR POINTWISE SATISFACTION OF STATE CONSTRAINTS
C                 IN/OUT: W WORK ARRAY of DIMENSION as in SLV
C     OUTPUT : PRINT-OUT SUBROUTINE TO BE FURNISHED BY USER.
C              PARAMETERS ARE AS DESCRIBED IN THE PRESENT DESCRIPTION
C              USAGE:
C              CALL OUTPUT (T, K, G, LONG, NO, Z, X, IV)
C                 INPUT: T, K, G, LONG, Z, X, IV
C                        WHERE T IS THE CURRENT TIME set by d_TOMP,
C                        K IS THE INDEX OF THE INTEGRATION INTERVAL
C                        set by d_TOMP, G(LONG, BROAD) is a REAL*4
C                        ARRAY to store VALUES FOR PLOTTING, see later
C                        COLUMNS NO-(NU+NZ) CAN BE ATTACHED TO G by USER
C                 OUTPUT: NO see last line of INPUT

C     IV :     INTEGER ARRAY OF LENGTH 20, CONTAINING:
C              NI(1) = IV(1)
C                 .
C                 .       NUMBER OF BREAKPOINTS OF AT MOST 6 CONTROLS,
C                 .
C              NI(NU) = IV(NU)
C              NI(NU+1) = IV(NU+1)
C                 .
C                 .       INTERPOLATION MODEs OF AT MOST 6 CONTROLS,
C                 .
C              NI(2*NU) = IV(2*NU)
C                         MODE  : INDICATES ORDER OF INTERPOLATION:
C                             1 = PIECEWISE CONSTANT
C                             2 = PIECEWISE LINEAR
C                             3 = PIECEWISE CUBIC SPLINE
C                             4 = PIECEWISE EXPONENTIAL SPLINE
C                                   TENSIONS ARE BEING CALCULATED
C                             5 = PIECEWISE EXPONENTIAL SPLINE
C                                   TENSIONS ARE GIVEN BY USER
C                             6 = AKIMA'S INTERPOLANT
C              NP    = IV(13) NUMBER OF DESIGN PARAMETERS PI,
C              NU    = IV(14) ACTUAL NUMBER OF CONTROL VARIABLES U,
C              NY    = IV(15) NUMBER OF COMMUNICATION POINTS Y,
C              NZ    = IV(16) NUMBER OF STATE VARIABLES Z,
C              M     = IV(17) TOTAL NUMBER OF CONSTRAINTS C,
C                             EQUALITY CONSTRAINTS (BOUNDARY VALUES)
C                             MUST BE PLACED FIRST IN C.
C              MODE  = IV(18) OPTIMISATION CHOICE:
C                             MODE = 1 : DATA ARE FREE FOR OPTIMIZATION,
c                                        including np design parameters,
C                             MODE = 2 : ALSO BREAKPOINTS ARE FREE FOR
C                                        OPTIMIZATION,
C                             MODE = 3 : ALSO TENSIONS ARE FREE FOR
C                                        OPTIMIZATION,
C              ISW   = IV(19) FLAG TO CONTROL CALCULATIONS:
C                             ISW = 0 : CALCULATES FUNCTIONS
C                                       AND DERIVATIVES,
C                             ISW = 1 : CALCULATES FUNCTIONS ONLY,
C                             ISW =-1 : CALCULATES DERIVATIVES ONLY,
C                             ISW =-2 : PRINTS TRAJECTORY
C                                       VIA OUTPUT AND STORES DATA FOR
C                                       PLOTTING VIA  R A S P  FORMAT
C                                       OR VIA  M A T L A B  FORMAT
C                             ISW =-3 : INTEGRATES IN ONE-STEP-MODE
C                                       TO DISPLAY HARD INTEGRATION WORK
C                                       IN FUNCTION GENERATION
C                             ISW =-4 : INTEGRATES IN ONE-STEP-MODE
C                                       TO DISPLAY HARD INTEGRATION WORK
C                                       IN GRADIENT GENERATION
C              IP    = IV(20) ON ENTRY UNIT-NUMBER for STORING PLOT DATA
C                             ON EXIT
C                             COUNTER FOR RIGHT-HAND-SIDE EVALUATION.

C     X   : DOUBLE PRECISION ARRAY OF LENGTH NP + SUM OVER J (6*NI(J))
C           J=1, ... , NU, WHERE NU IS AT MOST 6,
C           THE ORDER OF WHICH IS THE FOLLOWING:

C           CONTAINS DATA
C           X(1), ... , X(NI(1)),  OF THE FIRST
C           X(NI(1)+1), ... , X(NI(1)+NI(2)), SECOND
C           X(NI(1)+NI(2)+1), ..., X(NI(1)+NI(2)+ ... +NI(NU))
C           NU-th CONTROL,

C           X(... +NI(NU)+1, ... ,NI(NU)+NP) CONTAINS FREE FINAL TIME,
C           AND OTHER DESIGN PARAMETERS NOT DEPENDING ON TIME,
C           FREE FINAL TIME must BE THE FIRST DESIGN PARAMETER

C           X(NI(1)+NI(2)+ ... +NI(NU)+NP+1) , ... ,
C           X(2*(NI(1)+NI(2)+ ... +NI(NU))+NP) , ... ,
C           CONTAINS BREAKPOINT SEQUENCE 1, ... , NU,
C           OF SPLINE FUNCTION WHERE THE DATA ARE GIVEN,

C           X(2*(NI(1)+NI(2)+ ... +NI(NU))+NP+1) , ... ,
C           X(3*(NI(1)+NI(2)+ ... +NI(NU))+NP) , ... ,
C           CONTAINS TENSION PARAMETERS
C           FOR THE SPLINE FUNCTION, 1, ..., NU,

C           X(4*(NI(1)+NI(2)+ ... +NI(NU))+NP+1) , ... ,
C           X(6*(NI(1)+NI(2)+ ... +NI(NU))+NP) , ... ,
C           CONTAINS NU SETS OF COEFFICIENTS A, B, C,
C           TO BE EVALUATED IN SUBROUTINE SPLINE.

C     Y   : DOUBLE PRECISION ARRAY OF LENGTH NY OF COMMUNICATION POINTS
C           AT WHICH THE USER 'COMMUNICATES' WITH THE PROBLEM VIA VALUES
C     Z   : DOUBLE PRECISION ARRAY OF LENGTH NZ OF STATE VARIABLES.
C     Z0  : DOUBLE PRECISION ARRAY OF LENGTH NZ OF INITIAL VALUES.
C     Z1  : DOUBLE PRECISION ARRAY OF LENGTH NZ OF FINAL VALUES.
C     ACC : DOUBLE PRECISION VALUE OF RELATIVE AND ABSOLUTE ACCURACY OF
C           THE INITIAL VALUE SOLVER.
C     LC  : INTEGER VARIABLE INDICATING LEADING DIMENSION OF DC(LC,N+1).

C   OUTPUT ARGUMENTS :
C     F   : DOUBLE PRECISION VARIABLE CONTAINING THE CALCULATED COST.
C     C   : DOUBLE PRECISION ARRAY OF LENGTH M CONTAINING THE
C           CONSTRAINTS.
C     DF  : DOUBLE PRECISION ARRAY OF LENGTH N CONTAINING THE GRADIENT.
C           OF THE COST FUNCTION.
C     DC  : DOUBLE PRECISION MATRIX OF LENGTH (LC,N) CONTAINING THE
C           JACOBIAN OF THE CONSTRAINTS.
C     IFC   = IV(20) COUNTER FOR RIGHT-HAND-SIDE EVALUATION.

C   DUMMY ARGUMENTS :
C     W   : DOUBLE PRECISION ARRAY USED FOR SLV, THE LENGTH LW OF WHICH
C           SHOULD AT LEAST BE 13*NZ + 3  + M  FOR RK87 AS SLV,
C           AND 7*NZ + 3  + M FOR RK54 AS SLV, RESPECTIVELY.
C           IN THE PRESENT IMPLEMENTATION W IS FIXED AT 250,
C           See PARAMETER Statement.
C           W(13*NZ+4) ,..., W(13*NZ+3+M)  D.P. ARRAY, STORING THE
C           PERTURBED CONSTRAINTS; IF YOUR PROBLEM GENERATES MORE
C           THEN 250-13*NZ+3 CONSTRAINTS ENLARGE W ACCORDINGLY.
C     G   : SINGLE PRECISION DOUBLE INDEXED ARRAY OF FIXED LENGTH
C           (LONG, BROAD) IN WHICH TRAJECTORY INFORMATION FOR  R A S P
C           PLODAT AND PLOTHP or  M A T L A B  IS STORED.
C           The Array DIMENSION can be taken from the
C           PARAMETER Statement.

C   ERROR NUMBERS :
C     NONE; THE PROGAM STOPS IF THERE ARE FAULT CONDITIONS IN SLV;
C     RELEVANT INFORMATION WILL BE GIVEN.

C   METHOD :
C     FUNCTION-GENERATOR FOR DIRECT SHOOTING DESCRIBED IN:
C     D. KRAFT: 'ON CONVERTING OPTIMAL CONTROL PROBLEMS INTO
C                MATHEMATICAL PROGRAMMING PROBLEMS'.
C     IN: K. SCHITTKOWSKI (ED.): COMPUTATIONAL MATHEMATICAL PROGRAMMING,
C                                SPRINGER, BERLIN 1985.
C     D. KRAFT: 'TOMP - FORTRAN MODULES FOR OPTIMAL CONTROL CALCULATIONS'
C                FORTSCHRITT-BERICHT xxx, VDI-VERLAG, DSSELDORF, 1991.

C   REMARKS :
C     TOMP HAS BEEN TESTED ON VARIOUS REAL-LIFE PROBLEMS
C     INCLUDING AEROSPACE & ROBOTICS PATH PLANNING
C     USING THE FOLLOWING COMPILERS:
C     FORTRAN/2 VERSION 1.04
C     LAHEY F77L32 VERSION 3.0
C     MICROSOFT FORTRAN VERSION 5.0
C     MICROWAY NDPF486 VERSION 3.2
C     SALFORD FTN77 VERSION 2.5
C     WATCOM WATFOR78 VERSION 3.1
C     WATCOM WFL386 VERSION 8.0

C   AUTHOR :
C     DIETER KRAFT,
C     DEUTSCHE FORSCHUNGS- UND VERSUCHSANSTALT FUER LUFT- UND RAUMFAHRT,
C     OBERPFAFFENHOFEN,
C     INSTITUT FUER DYNAMIK DER FLUGSYSTEME,
C     MNCHNER STRASSE 20
C     D-8031 WESSLING
C     TEL. 08153 / 28443
C     26. 1. 1985

C     now at:
C     FACHHOCHSCHULE MNCHEN
C     FACHBEREICH MASCHINENBAU
C     DACHAUERSTRASSE 98 B
C     D-8000 MNCHEN 2
C     TEL. 089 / 1265 1108
C     FAX. 089 / 1265 1490
C     EMAIL: kraf@maschinenbau.fh-muenchen.dbp.de

C   COPYRIGHT :    Dieter Kraft   c/o
C     ***************************************
C     **************   D L R   **************
C     **************  1 9 8 6  **************
C     ***************************************
C     **************   F H M   **************
C     **************  1 9 9 1  **************
C     ***************************************

C   MODIFICATIONS :
C     ARRAY G CHANGED TO SINGLE PRECISION
C     IN THIS CASE PLODAT MUST READ SINGLE PRECISION ARRAY X
C     CHANGED ON 18/02/85

C     PLODAT INCORPORATED INTO TOMP, NAMELIST AS LOCAL DUMPING
C     POSSIBILITY ESTABLISHED
C     CHANGED ON 09/03/85

C     INCORPORATE HANDLING OF NP DESIGN PARAMETERS
C     AND HANDLING OF  PIECEWISE CONSTANT CONTROLS
C     ADAPTATION TO LANGUAGE LEVEL 77 OF FORTRAN 77 COMPILERS
C     MAKES NECESSARY A MODIFICATION (AUGMENTATION) OF PARAMETER LIST
C     CHANGED ON 31/01/86

C     CHANGED TO IBM PS/2 STANDARD WITH MICROSOFT FORTRAN VERSION 4.01
C     CHANGED TO IBM PS/2 STANDARD WITH FORTRAN/2 RYAN-McFARLAND V.1.0
C     NAMELIST STATEMENT ELIMINATED, AS NOT ALLOWED WITHIN MS-FORTRAN
C     ZTIME REPLACED BY GETTIM AND GETDAT
C     INTEGER VECTOR IV(20) RE-SORTED
C     CHANGED ON 24/01/89  &  9/04/89

C     INTEGRATION OF MATLAB PLOTting FACILITY
C     CREATION OF TOMP.M FILE WITH TRAJECTORIES
C     COMMON /CXTOMP/ has been de-activated
C     CHANGED ON 14/02/89

C     INTERRUPT INTEGRATION IF ERROR-FLAG CONTINUOUSLY SET
C     RETURN WITH F = FLARGE
C     CHANGED ON 20/05/89

C     MAXIMUM NUMBER OF CONTROLS CHANGED TO SIX
C     BECAUSE OF APPLICATIONS IN ROBOTICS
C     CHANGED ON 07/04/91

C     INCORPORATION OF CALCULATION OF VISUALLY PLEASING
C     EXPONENTIAL SPLINE INTERPOLANTS OF RENTROP & WEVER
C     CHANGED ON 16/06/91

C   DATE :
C            16/06/91

C   REQD. COMMON BLOCKS :
C     COMMON /CXTOMP/ STORES THE PLOT-RELEVANT DATA G, TANF, TEND, HSP.
C     ALL RELEVANT INFORMATION FOR THE CONTROLS
C     IS GIVEN IN THE PAIR (X, IV).
C     COMMON /CXTOMP/ has been de-activated

C   REQD. RASP-ROUTINES :   * = DIRECT CALL
C     *SLV,*SPLINE,*SPLINT

C   REQD. GRAPHIC ROUTINES :   * = DIRECT CALL
C     NO GRAPHIC ROUTINES

C   REQD. USER-ROUTINES :   * = DIRECT CALL
C     *OUTPUT,*VALUES,*RHS

C   REQD. LIBRARY-ROUTINES :   * = DIRECT CALL
C     *SPLINE,*SLV,*GETDAT,*GETTIM
C     ALTERNATIVES FOR SLV : RK87, RK54, and respective CORE-
C     routines; SPLINE. Euler-Cauchy in-line coded.
C     GETDAT, GETTIM are compiler-depending date and time routines
C     both are available or are emulated with identical I/O in the
C     following compiler for microcomputers: FORTRAN/2, MS-FORTRAN,
C     WATCOM-WATFOR77
C     date and time routines are de-activated

C-----------------------------------------------------------------------

C   DECLARATION OF VARIABLES , ARRAYS , COMMON AND NAMELIST
C   IBM-MAINFRAME NAMELIST DEACTIVATED

      INTEGER*2 IHR, IMIN, ISEC, IHUN, IYR, IMON, IDAY
      INTEGER IV(20), IW(5)
      INTEGER I, MODE, IFLAG, IG, IP, IPL, IPLOT, IS, ISW, I1, IVI,
     *  J, JSW, J1, J2, K, KP, K1, L, LC, LW, LEND, LONG, M, N, NI,
     *  NJ, NK, NO, NP, NUMBER, NY, NU, NW, NZ, N1, N2, N3, N4, N5,
     *  O, IDUMMY, IANF, BROAD, LONG1, JFLAG, IFC, IVJ

      PARAMETER (LW = 750, LONG = 501, LONG1 = LONG-1, BROAD = 18)

      DOUBLE PRECISION F, C(*), DF(*), DC(LC,*), W(LW), X(*), Y(*),
     *  Z(*), Z0(*), Z1(*), E, H, T, T0, T1, TF, RE, AE, ACC, DEL, EPS,
     *  EPMACH, RTEPS, ZERO, TEN, FLARGE, SPLINT, DFLOAT

      REAL G(LONG,BROAD), TANF, TEND, HSP

      LOGICAL ONESTP, MATLAB, RASP

      EXTERNAL RHS, SLV, VALUES, OUTPUT

      INTRINSIC ABS, MAX, MIN, SQRT

*     COMMON /CXTOMP/  G, TANF, TEND, HSP

CONTROLS FORWARD DIFFERENCE INTERVAL; FOR TESTING PURPOSES ONLY
*     DOUBLE PRECISION DEL1
*     COMMON /CDTOMP/  DEL1, IDEL1

*     NAMELIST /NXTOMP/ IFLAG, IPLOT, K, KP, LEND, N, NUMBER,
*    *                  E, H, T, T0, T1, TF, DEL, EPS, W, G

      DATA EPMACH /2.22D-16/, ZERO /0.0D+00/, TEN /10.0D+00/
      DATA FLARGE /1.00D+12/
      DATA IS /06/, IP/110/, IANF /1/, MATLAB /.TRUE./
      DATA IHR, IMIN, ISEC, IHUN, IYR, IMON, IDAY /7*0/

C-----------------------------------------------------------------------
C  EXTRACT PLOT INDICES FROM IP

      IF (IANF .EQ. 1) THEN
         IP = IV(20)
         IPL = IP/10
         IPLOT = IP - IPL*10
         IANF = 0
         IV(20) = 0
         OPEN (UNIT=IPL, FILE='TOMP.M')
      END IF

C  MATLAB or RASP GRAPHICS?

      RASP = .NOT. MATLAB

C  SET INTEGRATION ACCURACY

      RE = ACC
      AE = ACC
      RTEPS = SQRT(EPMACH)

C  LOWER BOUND FOR PERTURBATION

      EPS = MAX(RTEPS,ACC/TEN)

C  RECOVER FROM
C  INTEGER ARRAY IV(I), I=1, ..., 20, WHICH CONTAINS
C     NI(I), I=1, ... , 6, NUMBER OF BREAKPOINTS FOR MAXIMAL 6 CONTROLS
C     NI(I+NU), I=1, ... , 6, INTERPOLATION MODE OF MAXIMAL 6 CONTROLS
C     NP NUMBER OF DESIGN PARAMETERS (INCLUDING FREE FINAL TIME)
C     NU NUMBER OF CONTROLS
C     NY NUMBER OF COMMUNICATION POINTS
C     NZ NUMBER OF STATES
C     M  NUMBER OF CONSTRAINTS(BOUNDARY VALUES + TRAJECTORY CONSTRAINTS)
C     ISW  SIMULATION SWITCH
C     MODE  OPTIMIZATION ALTERNATIVES (SEE COMMENT IMMEDIATELY AFTER
C        LABEL 220)
C     IFC NUMBER OF RHS-EVALUATIONS

      NP = IV(13)
      NU = IV(14)
      NY = IV(15)
      NZ = IV(16)
      M  = IV(17)
      MODE = IV(18)
      ISW = IV(19)
      IFC = IV(20)

      IF (NP .LT. 0) THEN
         WRITE (IS, 9830) NP
         STOP
      END IF

      IF (NU .LT. 1 .OR. NU .GT. 6) THEN
         WRITE (IS, 9840) NU
         STOP
      END IF

      IF (NY .LT. 2) THEN
         WRITE (IS, 9850) NY
         STOP
      END IF

      IF (NZ .LT. 1) THEN
         WRITE (IS, 9860) NZ
         STOP
      END IF

      IF (MODE .LT. 1 .OR. MODE .GT. 3) THEN
         WRITE (IS, 9870) MODE
         STOP
      END IF

      IF (ISW .LT. -4 .OR. ISW .GT. 1) THEN
         WRITE (IS, 9880) ISW
         STOP
      END IF

      I = NU+NZ
      IF (I .GT. BROAD) THEN
         WRITE (IS, 9890) I
         PAUSE
     +   'PAUSE: YOU MAY INVOKE A DEBUGGER DISPLAY HERE BEFORE STOP'
         STOP
      END IF

      I = M + 13*NZ + 3
      IF (I .GT. LW) THEN
         WRITE (IS, 9900) I
         PAUSE
     +  'PAUSE: YOU MAY INVOKE A DEBUGGER DISPLAY HERE BEFORE STOP'
         STOP
      END IF

C  SUM UP TOTAL NUMBER N OF SPLINE-BREAKPOINTS

      N = 0
      DO 10 I=1,NU
         IVI = IV(I)
         IVJ = IV(NU+I)
         N = N + IVI
         IF (IVJ .EQ. 1 .AND. IVI .LT. 1
     +  .OR. IVJ .EQ. 2 .AND. IVI .LT. 2
     +  .OR. IVJ .GE. 3 .AND. IVI .LT. 4) THEN
            WRITE (IS, 9902) I
            PAUSE
     +     'PAUSE: YOU MAY INVOKE A DEBUGGER DISPLAY HERE BEFORE STOP'
            STOP
         END IF
         IVI = IV(NU+I)
         IF (IVI .LT. 1 .OR. IVI .GT. 6) THEN
            WRITE (IS, 9904) I
            PAUSE
     +     'PAUSE: YOU MAY INVOKE A DEBUGGER DISPLAY HERE BEFORE STOP'
            STOP
         END IF
   10 CONTINUE
      N1 = N + NP
      N2 = N + N1
      N3 = N + N2
      N4 = N + N3
      N5 = N + N4
      NW = 13*NZ + 3
      J = 1
      DO 15 I=1,NU-1
         IF (ABS(X(N1+J+IV(I))-X(N1+J)).GT.EPMACH) THEN
            WRITE (IS, 9906)
            PAUSE
     +     'PAUSE: YOU MAY INVOKE A DEBUGGER DISPLAY HERE BEFORE STOP'
            STOP
         END IF
         IF (ABS(X(N1+J+IV(I)+IV(I+1)-1)-X(N1+J+IV(I)-1)).GT.EPMACH)
     +   THEN
            WRITE (IS, 9906)
            PAUSE
     +     'PAUSE: YOU MAY INVOKE A DEBUGGER DISPLAY HERE BEFORE STOP'
            STOP
         END IF
         J = J + IV(I)
   15 CONTINUE

      IF (ISW.EQ.(-1)) GO TO 220

C  ONE-STEP INTEGRATION MODE?

      ONESTP = .FALSE.
      ONESTP = ISW.LE.(-3)

C-----------------------------------------------------------------------

C          FUNCTIONS  BY  TRAJECTORY SIMULATION WITH BASIS FUNCTIONS
C                             FROM SPLINE AS CONTROLS

C-----------------------------------------------------------------------

C  COMPUTE SPLINE COEFFICIENTS X(N1+N+N+J) .... X(N1+N+N+N+J)
C  FOR GIVEN BREAKPOINTS X(N1+J), DATA X(J), AND TENSIONS X(N1+N+J),
C  J=1, ... , IV(I), I=1, ... , NU.
C  EVALUATE SPLINES IN SUBROUTINE RHS FOR GIVEN TIME T.

      J = 1
      DO 20 I=1,NU
         CALL SPLINE (IV(NU+I), IV(I), X(N1+J), X(   J),
     *               X(N2+J), X(N3+J), X(N4+J), X(N5+J))
         J = J + IV(I)
C        TENSIONS HAVE BEEN CALCULATED;
C        NOW RESET INTERPOLATION MODE
         IF (IV(NU+I) .EQ. 4) IV(NU+I) = 5
   20 CONTINUE

C  INITIAL CONDITIONS ARE IN Z0(I), I=1, ... , NZ,
C  OR ARE FREE PARAMETERS IN X AND WILL BE SWAPPED FROM
C  X TO Z0 IN VALUES FOR MODE = 0.
C  ALSO VECTOR Y OF COMMUNICATION POINTS MAY BE ASSIGNED IN VALUES
C  FOR MODE = 0.

   30 CALL VALUES (RHS, IV, T0, X, Y, Z, Z0, Z1, W, F, C, 0)

      T0 = Y(1)
      DO 40 I=1,NZ
         Z(I) = Z0(I)
   40 CONTINUE

C  IS GRAPH OF TRAJECTORIES WANTED ONLY?

      IF (ISW.EQ.(-2)) GO TO 530
      IFLAG = 1
      IF (.NOT.ONESTP) GO TO 50

C  ONE-STEP-INTEGRATION-MODE

      IFLAG = -1
      WRITE (IS, 9760)

C  INTEGRATE SYSTEM GIVEN IN RHS BY INITIAL-VALUE-SOLVER SLV
C  WITH SPLINE-BREAKPOINTS X(N1+J), J=1, ... , IV(I), I=1, ... , NU,
C  AND COMMUNICATION POINTS Y(I), I=1, ... , NY, AS OUTPUT INTERVALS.

   50 DO 210 I=1,NY

C  FIND LEFTMOST BREAKPOINT LARGER THAN T0

   60    K1 = N1
         TF = Y(NY)
         DO 90 I1=1,NU
            J2 = IV(I1)
            DO 70 J1=1,J2
               T = X(K1+J1)
               IF (T.GT.T0) GO TO 80
   70       CONTINUE
   80       IF (T.LT.TF) TF = T
            K1 = K1 + J2
   90    CONTINUE
         T1 = Y(I)

C  IS NEXT COMMUNICATION POINT SMALLER THAN BREAKPOINT FOUND ?

         IF (TF.LT.T1) T1 = TF

C  RESET CONTINUATION FLAG FOR ERROR CONDITIONS IN SLV

         JFLAG = 0

C  INITIAL VALUE SOLVER; TAKE HIGH ORDER FORMULAE (E.G. 8(7)) FOR
C  SPARSE OUTPUT, AND LOW ORDER FORMULAE (E.G. 5(4)) FOR DENSE OUTPUT.

  100    CALL SLV(RHS, NZ, Z, T0, T1, RE, AE, IFLAG, W, IW, X, IV)

         IF (ONESTP) GO TO 180

C  INTEGRATION OUTPUT FLAG OK FOR CONTINUATION ?

         IF (ABS(IFLAG).EQ.2) GO TO 200
         J = 1
         DO 110 K=1,NU
            W(LW-K) = SPLINT (IV(NU+K), IV(K), X(N1+J), X(J),
     *                X(N2+J), X(N3+J), X(N4+J), X(N5+J), T0)
            J = J + IV(K)
  110    CONTINUE
         JFLAG = JFLAG + 1
         IF (JFLAG .GT. 2) THEN
            K = -1
            CALL VALUES (RHS, IV, T0, X, Y, Z, Z0, Z1, W, F, C, K)
            CALL OUTPUT(T0, K, G, LONG, NO, Z, X, IV)
            F = FLARGE
            DO 115, J=1, M
               C(J) = -FLARGE
  115       CONTINUE
            WRITE (IS, 9680)
            GO TO 600
         END IF
         WRITE (IS, 9690) IFLAG
         WRITE (IS, 9780) T0, T1, T, TF, Y(I)
         WRITE (IS, 9780) (Z(J),J=1,NZ)
         WRITE (IS, 9780) (W(LW-J),J=1,NU)
         GO TO (170, 200, 120, 130, 140, 150, 160, 170), IFLAG
  120    WRITE (IS, 9700)
         GO TO 100
  130    WRITE (IS, 9710)
         GO TO 100
  140    WRITE (IS, 9720)
         AE = RTEPS
         GO TO 100
  150    WRITE (IS, 9730)
         AE = TEN*AE
         RE = TEN*RE
         IFLAG = 2
         GO TO 100
  160    WRITE (IS, 9740)
         ONESTP = .TRUE.
         GO TO 30
  170    WRITE (IS, 9750)
         PAUSE
     *  'PAUSE: YOU MAY INVOKE A DEBUGGER DISPLAY HERE BEFORE STOP'
         STOP

C  IN ONE-STEP-INTEGRATION-MODE PRINT STATES AND CONTROLS

  180    J = 1
         DO 190 K=1,NU
            W(LW-K) = SPLINT (IV(NU+K), IV(K), X(N1+J), X(J),
     *                X(N2+J), X(N3+J), X(N4+J), X(N5+J), T0)
            J = J + IV(K)
  190    CONTINUE
         WRITE (IS, 9780) T0, T1, (Z(J),J=1,NZ), (W(LW-J),J=1,NU)
         IF (IFLAG.EQ.(-2)) GO TO 100
         IFLAG = -2

C  COMMUNICATION POINT REACHED ?

  200    IF (T1.LT.Y(I)) GO TO 60

C  CALLS BOUNDARY VALUES, TRAJECTORY CONSTRAINTS, AND COST FUNCTION

         CALL VALUES (RHS, IV, T0, X, Y, Z, Z0, Z1, W, F, C, I)
  210 CONTINUE

C  THIS ENDS INTEGRATION LOOP; RHS-EVALUATIONS ARE ACCUMULATED
         IFC = IFC + IW(1)

C  IF FUNCTIONS ARE REQUIRED ONLY RETURN, ELSE CONTINUE.

      IF (ISW.EQ.(+1)) GO TO 600
      IF (ISW.EQ.(-3)) GO TO 600

C-----------------------------------------------------------------------

C          GRADIENTS  BY  FORWARD DIFFERENCES

C-----------------------------------------------------------------------

C  ALL COMMENTS FROM ABOVE ARE VALID HERE AS PERTURBED TRAJECTORIES
C  ARE INTEGRATED

  220 DO 520 JSW = 1, MODE

C  MODE = 1 : GRADIENTS FOR OPTIMAL DATA, INCLUDING DESIGN PARAMETERS
C       = 2 : GRADIENTS FOR OPTIMAL BREAKPOINTS
C       = 3 : GRADIENTS FOR OPTIMAL TENSIONS

         GO TO (230, 240, 250), JSW

C  INITIALIZE PARAMETER INDEX KP

  230    KP = 0
         LEND = N1
         GO TO 260
  240    LEND = N
         GO TO 260
  250    LEND = N
  260    IG = 1
         NJ = 1
         ONESTP = .FALSE.
         ONESTP = ISW.EQ.(-4)

C  START LOOP OVER ALL PARAMETERS

         DO 510 L=1,LEND
            IF (IG.GT.NU) GO TO 270
            NI = IV(IG)
            NK = IV(IG+NU)
  270       O = NI + NJ - 1
            KP = KP + 1
            H = X(KP)

C  FIRST AND LAST BREAKPOINT OF A CONTROL REMAIN UNPERTURBED

            IF (JSW.EQ.2 .AND. (L.EQ.NJ .OR. L.EQ.O)) GO TO 480

C  PERTURBATION OF PARAMETER X(KP)

            DEL = MAX(EPS,ABS(H)*EPS)
****TEST    IF (IDEL1 .EQ. 1) DEL = DEL1
            X(KP) = H + DEL

C  DO NOT EVALUATE SPLINE FOR FREE ENDTIME X(N+1),
C  AND OTHER FREE DESIGN PARAMETERS.

            IF (L.GT.N) GO TO 280
            CALL SPLINE  (NK, NI, X(N1+NJ), X(   NJ), X(N2+NJ),
     *                            X(N3+NJ), X(N4+NJ), X(N5+NJ))
            IF (NK .EQ. 4) IV(IG+NU) = 5

C  INITIAL CONDITIONS ARE IN Z0(I), I=1, ... , NZ.

  280       CALL VALUES (RHS, IV, T0, X, Y, Z, Z0, Z1, W, E, W(NW+1), 0)
            T0 = Y(1)
            DO 290 I=1,NZ
               Z(I) = Z0(I)
  290       CONTINUE
            IFLAG = 1
            IF (.NOT.ONESTP) GO TO 300
            IFLAG = -1
            WRITE (IS, 9770)

C  HERE LOOP 210 IS REPEATED EXACTLY IN LOOP 460

  300       DO 460 I=1,NY

C  FIND LEFTMOST BREAKPOINT LARGER THAN T0

  310          K1 = N1
               TF = Y(NY)
               DO 340 I1=1,NU
                  J2 = IV(I1)
                  DO 320 J1=1,J2
                     T = X(K1+J1)
                     IF (T.GT.T0) GO TO 330
  320             CONTINUE
  330             IF (T.LT.TF) TF = T
                  K1 = K1 + J2
  340          CONTINUE
               T1 = Y(I)

C  IS NEXT COMMUNICATION POINT SMALLER THAN BREAKPOINT FOUND ?

               IF (TF.LT.T1) T1 = TF

C  INITIAL VALUE SOLVER; TAKE HIGH ORDER FORMULAE (E.G. 8(7)) FOR
C  SPARSE OUTPUT, AND LOW ORDER FORMULAE (E.G. 5(4)) FOR DENSE OUTPUT.

  350          CALL SLV(RHS, NZ, Z, T0, T1, RE, AE, IFLAG, W, IW, X, IV)

               IF (ONESTP) GO TO 430

C  INTEGRATION OUTPUT FLAG OK FOR CONTINUATION ?

               IF (ABS(IFLAG).EQ.2) GO TO 450
               J = 1
               DO 360 K=1,NU
                  W(LW-K) = SPLINT (IV(NU+K), IV(K), X(N1+J), X(J),
     *                      X(N2+J), X(N3+J), X(N4+J), X(N5+J), T0)
                  J = J + IV(K)
  360          CONTINUE
               J = -IFLAG
               WRITE (IS, 9690) J
               WRITE (IS, 9780) T0, T1, T, TF, Y(I)
               WRITE (IS, 9780) (Z(J),J=1,NZ)
               WRITE (IS, 9780) (W(LW-J),J=1,NU)
               GO TO (420, 450, 370, 380, 390, 400, 410, 420), IFLAG
  370          WRITE (IS, 9700)
               GO TO 350
  380          WRITE (IS, 9710)
               GO TO 350
  390          WRITE (IS, 9720)
               AE = RTEPS
               GO TO 350
  400          WRITE (IS, 9730)
               AE = TEN*AE
               RE = TEN*RE
               IFLAG = 2
               GO TO 350
  410          WRITE (IS, 9740)
               ONESTP = .TRUE.
               GO TO 280
  420          WRITE (IS, 9750)
               PAUSE
     *        'PAUSE: YOU MAY INVOKE A DISPLAY HERE BEFORE STOP'
               STOP

C  IN ONE-STEP-INTEGRATION-MODE PRINT STATES AND CONTROLS

  430          J = 1
               DO 440 K=1,NU
                  W(LW-K) = SPLINT (IV(NU+K), IV(K), X(N1+J), X(J),
     *                      X(N2+J), X(N3+J), X(N4+J), X(N5+J), T0)
                  J = J + IV(K)
  440          CONTINUE
               WRITE (IS, 9780) T0, T1, (Z(J),J=1,NZ),
     *                            (W(LW-J), J=1,NU)
               IF (IFLAG.EQ.(-2)) GO TO 350
               IFLAG = -2

C  COMMUNICATION POINT REACHED ?

  450          IF (T1.LT.Y(I)) GO TO 310

C  CALLS BOUNDARY VALUES, TRAJECTORY CONSTRAINTS, AND COST FUNCTION
C  OF PERTURBED TRAJECTORY

            CALL VALUES (RHS, IV, T0, X, Y, Z, Z0, Z1, W, E, W(NW+1), I)
  460       CONTINUE
            IFC = IFC + IW(1)

C  FORWARD DIFFERENCES APPROXIMATE THE GRADIENT

            DF(KP) = (E-F)/DEL
            DO 470 I=1,M
               DC(I,KP) = (W(NW+I)-C(I))/DEL
  470       CONTINUE
            GO TO 500

C  GRADIENT FOR INITIAL AND FINAL BREAKPOINT OF A CONTROL SEQUENCE

  480       DF(KP) = ZERO
            DO 490 I=1,M
               DC(I,KP) = ZERO
  490       CONTINUE

C  RESET PERTURBATION

  500       X(KP) = H
            IF (L.GT.N) GO TO 505
            IF (L.NE.O) GO TO 505

C  EVALUATE SPLINE AFTER RESETTING OF PERTURBATION FOR LAST
C  BREAKPOINT OF A CONTROL FUNCTION ONLY

            CALL SPLINE  (NK, NI, X(N1+NJ), X(   NJ), X(N2+NJ),
     *                            X(N3+NJ), X(N4+NJ), X(N5+NJ))
            NJ = NJ + NI
            IG = IG + 1
  505       IF (L.GT.N .AND. L.LE.N1)
     *      CALL VALUES (RHS, IV, T0, X, Y, Z, Z0, Z1, W, F, C, 0)
  510    CONTINUE
  520 CONTINUE

      GO TO 600

C-----------------------------------------------------------------------

C          GRAPH  VIA  PLODAT & PLOTHP  FROM  R A S P
C     OR   GRAPH  VIA  M A T L A B  PLOTTING FACILITY

C-----------------------------------------------------------------------

  530 IF (MATLAB) L = LONG1
      IF (RASP)   L = LONG
      T1 = Y(NY)

C  INTEGRATION WITH FIXED STEP SIZE H

      H = (T1-T0)/DFLOAT(L-1)
      T = T0
      TANF = SNGL(T0)
      TEND = SNGL(T1)
      HSP = SNGL(H)
      IF (NP .GT. 0) THEN
         TEND = SNGL(X(N1)*T1)
         HSP = SNGL(H)*TEND
      END IF
      K = 1

C  STORE INITIAL STATES

      DO 535 I=1,NZ
         E = Z(I)
         G(K,I) = SNGL(E)
  535 CONTINUE

C  STORE INITIAL CONTROLS

      J = 1
      DO 540 I=1,NU
         E = X(J)
         G(K,NZ+I) = SNGL(E)
         J = J + IV(I)
  540 CONTINUE
      NO = NU + NZ

C  THE TRAJECTORIES CAN BE DISPLAYED IN USER SUPPLIED SUBROUTINE
C  OUTPUT ON ANY DEVICE (HERE FOR INITIAL VALUES AT T0)
C  NO MAY BE CHANGED IN OUTPUT TO CATER FOR ADDITIONAL FUNCTIONS
C  WHICH ARE NEITHER STATES NOR CONTROLS

      CALL OUTPUT(T, K, G, LONG, NO, Z, X, IV)
      NO = MIN(NO, BROAD)

C  ENTRY POINT FOR INTEGRATION LOOP

  545 K = K + 1
      TF = DFLOAT(K)*EPMACH

C  EULER-CAUCHY (SECOND-ORDER RUNGE-KUTTA) FORMULAE
C  ARE USED FOR STATE INTEGRATION WITH
C  EXTREMELY DENSE OUTPUT (IN-LINE CODED)

      DO 550 I=1,NZ
         W(I) = Z(I)
  550 CONTINUE
      CALL RHS (T, Z, W(NZ+1), X, IV)
      DO 555 I=1,NZ
         Z(I) = Z(I) + H*W(NZ+I)
  555 CONTINUE
      T = T + H
      CALL RHS (T, Z, W(NZ+NZ+1), X, IV)
      E = 0.5D0*H
      DO 560 I=1,NZ
         Z(I) = W(I) + E*(W(NZ+I)+W(NZ+NZ+I))
  560 CONTINUE

C  STORE STATES

      DO 565 I=1,NZ
         E = Z(I)
         G(K,I) = SNGL(E)
  565 CONTINUE

C  STORE CONTROLS

      J = 1
      DO 570 I=1,NU
         E = SPLINT (IV(NU+I), IV(I), X(N1+J), X(J),
     *       X(N2+J), X(N3+J), X(N4+J), X(N5+J), T)
         G(K,NZ+I) = SNGL(E)
         J = J + IV(I)
  570 CONTINUE

C  THE TRAJECTORIES CAN BE DISPLAYED IN USER SUPPLIED SUBROUTINE
C  OUTPUT ON ANY DEVICE

      CALL OUTPUT(T, K, G, LONG, IDUMMY, Z, X, IV)

      IF ((T+H).GT.T1) H = T1 - T

C  HAS THE ENDPOINT BEEN REACHED?

      IF (K.LT.L) GO TO 545

C  IN CASE OF UNCERTAINTY PRINT NAMELIST AS LOCAL DUMP

*     IF (IPL.LT.10) WRITE (IPL, NXTOMP)

C  IS  R A S P  AVAILABLE ?

      IF (IPL.LT.10) GO TO 600

C  BY CALLING PLODAT
C  STORE DATA ON FILE IPL IN R A S P - FORMAT
C  FOR PLOTTING IN SEPERATE JOB USING PLOTHP
C  ARRAY G MUST BE DECLARED SINGLE PRECISION WITHIN PLODAT

C  MS-FORTRAN & RYAN-MCFARLAND TIME & DATE

*     CALL GETTIM (IHR, IMIN, ISEC, IHUN)
*     CALL GETDAT (IYR, IMON, IDAY)

C     OPEN ONLY ONCE AT THE BEGINNING
*     OPEN (UNIT=IPL, FILE='TOMP.DAT')

      IF (RASP) THEN
         J = IPLOT*NO
         DO 580 I=1,NO
            NUMBER = J + I
            WRITE (IPL, 9790) IDAY, IMON, IYR, IHR, IMIN, ISEC, IHUN
            WRITE (IPL, 9800) NUMBER
            WRITE (IPL, 9810) TANF, HSP, K
            WRITE (IPL, 9820) (G(L,I), L=1,K)
  580    CONTINUE
      ELSE IF (MATLAB) THEN

C  MATLAB METACOMMANDS TO BE WRITTEN INTO TOMP.M-FILE

         J = IPLOT*NO
         DO 590 I=1,NO
            NUMBER = J + I
            IF (NUMBER .LE. 9) THEN
               WRITE (IPL, 9910) NUMBER
            ELSE
               WRITE (IPL, 9920) NUMBER
            END IF
            WRITE (IPL, 9930) (G(L,I), L=1,K)
            WRITE (IPL, 9940)
            IF (NUMBER .LE. 9) THEN
               WRITE (IPL, 9950) NUMBER, NUMBER
            ELSE
               WRITE (IPL, 9960) NUMBER, NUMBER
            END IF
  590    CONTINUE
         WRITE (IPL, 9970) TANF, HSP, TEND
         WRITE (IPL, 9971)
         WRITE (IPL, 9972)
         WRITE (IPL, 9973)
         WRITE (IPL, 9974) HSP
         WRITE (IPL, 9975)
         DO 595 I=1,NO
            NUMBER = J + I
            IF (NUMBER .LE. 9) THEN
               WRITE (IPL, 9980) NUMBER
            ELSE
               WRITE (IPL, 9990) NUMBER
            END IF
  595    CONTINUE

      ELSE

         WRITE (*,*) '==> NO PLOTTING PROVIDED IN TOMP'

      END IF

C     CLOSE (UNIT=IPL)

C  COUNT UP TRAJECTORY NUMBER INDICATOR FOR NEXT GRAPHING

      IPLOT = IPLOT + 1

C-----------------------------------------------------------------------
  600 CONTINUE

      IV(20) = IFC

C          END TOMP

C-----------------------------------------------------------------------

C  FORMAT STATEMENTS

 9680 FORMAT (39H  INTERRUPT INTEGRATION WITH F = FLARGE)
 9690 FORMAT (25H0 PROBLEMS IN RK> FLAG IS, I2, 19H;  T's, Z, U  ARE :)
 9700 FORMAT (41H  TOLERANCES NOT APPROPRIATE; RESET BY RK)
 9710 FORMAT (46H  500 STEPS TAKEN; TRY ANOTHER 500, THEN STOP.)
 9720 FORMAT (46H  VANISHING SOLUTION NEEDS ABSOLUTE ERROR TEST)
 9730 FORMAT (43H  TOLERANCES NOT APPROPRIATE; RESET BY TOMP)
 9740 FORMAT (52H  TOO MUCH OUTPUT RESTRICTS NATURAL STEP-SIZE; CONTI,
     *        24HNUATION IN ONE-STEP MODE)
 9750 FORMAT (39H0 TOMP: IMPROPER INPUT PARAMETERS; STOP)
 9760 FORMAT (52H1 IN ONE-STEP-MODE T, Z & U HAVE THE FOLLOWING VALUE,
     *        26HS FOR BASIC TRAJECTORIES :)
 9770 FORMAT (52H1 IN ONE-STEP-MODE T, Z & U HAVE THE FOLLOWING VALUE,
     *        30HS FOR PERTURBED TRAJECTORIES :)
 9780 FORMAT (3(D24.16))
 9790 FORMAT (16HC         DATE: , I2.2, 1H/, I2.2, 1H/, I4.4,
     *        23H              TIME:    ,
     *        I2.2, 1H:, I2.2, 1H:, I2.2, 1H., I2.2)
 9800 FORMAT (1HC/40HC        INITIAL TIME       STEP SIZE   ,
     *        20H            NUMBER  /1HT, I2)
 9810 FORMAT (2(8X, 1PE12.5), 10X, I10)
 9820 FORMAT (6(1PE12.5))
 9830 FORMAT (41H TOMP: WRONG NUMBER OF DESIGN PARAMETERS:, I3)
 9840 FORMAT (41H TOMP: WRONG NUMBER OF CONTROL VARIABLES:, I3)
 9850 FORMAT (44H TOMP: WRONG NUMBER OF COMMUNICATION POINTS:, I3)
 9860 FORMAT (39H TOMP: WRONG NUMBER OF STATE VARIABLES:, I3)
 9870 FORMAT (41H TOMP: WRONG NUMBER OF OPTIMIZATION MODE:, I3)
 9880 FORMAT (42H TOMP: WRONG NUMBER OF INTEGRATION SWITCH:, I3)
 9890 FORMAT (42H TOMP: ENLARGE AUXILIARY ARRAY G TO len_G:, I3)
 9900 FORMAT (42H TOMP: ENLARGE AUXILIARY ARRAY W TO len_W:, I3)
 9902 FORMAT (39H TOMP: INCREASE BREAKPOINTS OF CONTROL:, I3)
 9904 FORMAT (43H TOMP: WRONG INTERPOLATION MODE OF CONTROL:, I3)
 9906 FORMAT (41H TOMP: INITIAL AND/OR FINAL POINT DEVIATE)

C     FORMAT STATEMENTS FOR MATLAB META-COMMANDS

 9910 FORMAT (1Ho,I1,2H=[)
 9920 FORMAT (1Ho,I2,2H=[)
 9930 FORMAT (5(1PE14.6))
 9940 FORMAT (3H]';)
 9950 FORMAT (1Hx,I1,2H=o,I1,4H(:);)
 9960 FORMAT (1Hx,I2,2H=o,I2,4H(:);)
 9970 FORMAT (2Ht=,1PE14.7,1H:,1PE14.7,1H:,1PE14.7,1H;)
 9971 FORMAT (12Hi=length(t);)
 9972 FORMAT (13Hj=length(x1);)
 9973 FORMAT (8Hif i < j)
 9974 FORMAT (13Ht(j) = t(i) +,1PE14.7,1H;)
 9975 FORMAT (3Hend)
 9980 FORMAT (7Hclear o,I1)
 9990 FORMAT (7Hclear o,I2)

C-----------------------------------------------------------------------

      END

      SUBROUTINE CONTRL (T,X,IV,Y)

C  COMPLEMENT TO SUBROUTINE D_TOMP:
C  EVALUATES Y FOR GIVEN T,X,IV
C  USED TO EVALUATE BASIS FUNCTION
C  IN COMBINATION WITH D_TOMP AND SPLINE
C  CODED: DIETER KRAFT, 17.02.89

      INTEGER          IV(20),N,N1,N2,N3,N4,N5,NP,NU,I,J
      DOUBLE PRECISION T,X(*),Y(*),SPLINT

C  SUM UP TOTAL NUMBER N OF SPLINE-BREAKPOINTS

      N = 0
      NP = IV(13)
      NU = IV(14)
      DO 10 I=1,NU
         N = N + IV(I)
   10 CONTINUE

C  CALCULATE ADDRESSES IN ARRAY X

      N1 = N + NP
      N2 = N + N1
      N3 = N + N2
      N4 = N + N3
      N5 = N + N4

C  EVALUATE CONTROL VECTOR Y

      J = 1
      DO 20 I=1,NU
         Y(I)=SPLINT (IV(NU+I), IV(I), X(N1+J), X(   J),
     *               X(N2+J), X(N3+J), X(N4+J), X(N5+J), T)
         J = J + IV(I)
   20 CONTINUE

      END


      SUBROUTINE SPLINE (MODE, N, X, Y, P, A, B, C)

C   SPLINE  CALCULATES COEFFICIENT SETS FOR LINEAR, CUBIC OR EXPONENTIAL
C           INTERPOLATING SPLINES

C   PURPOSE:
C     CALCULATION OF COEFFICIENT SETS FOR LINEAR, CUBIC, OR EXPONENTIAL
C     INTERPOLATING SPLINES.
C     ALSO TENSION PARAMETERS FOR VISUALLY PLEASING EXPONENTIAL SPLINE
C     INTERPOLANTS ARE CALCULATED.
C     TO BE USED FOR INTERPOLATION IN CONNECTION WITH FUNCTION SPLINT

C   INPUT ARGUMENTS:
C     MODE  : INDICATES ORDER OF INTERPOLATION:
C             1 = PIECEWISE CONSTANT
C             2 = PIECEWISE LINEAR
C             3 = PIECEWISE CUBIC SPLINE
C             4 = PIECEWISE EXPONENTIAL SPLINE
C                 WITH TENSIONS A PRIORI CALCULATED
C             5 = PIECEWISE EXPONENTIAL SPLINE
C                 WITH TENSIONS GIVEN BY USER
C             6 = AKIMA'S INTERPOLANT
C     N     : NUMBER OF DATA FOR WHICH THE COEFFICIENT SET IS TO BE
C             CALCULATED
C     X     : VECTOR OF LENGTH N STORING THE ABSCISSAE
C     Y     : VECTOR OF LENGTH N STORING THE DATA POINTS
C     P     : VECTOR OF LENGTH N STORING THE STIFFNESS PARAMETERS

C   OUTPUT ARGUMENTS:
C     A,B,C : VECTOR OF LENGTH N EACH STORING THE COEFFICIENT SET
C             TO BE USED FOR INTERPOLATION IN FUNCTION SPLINT.
C             THESE TOGETHER WITH X,Y AND P ARE INPUT ARGUMENTS TO
C             SPLINT AND MAY NOT BE CHANGED BY THE USER BETWEEN CALLS.

C   REMARK:
C     A PRACTICAL WAY TO FIND SUITABLE STIFFNESS PARAMETERS
C     IS DESCRIBED IN /2/ AND IS IMPLEMENTED IN SUBROUTINE GENERA

C   METHOD:
C     THAT OF CHR. REINSCH AND P. RENTROP AS DESCRIBED IN:
C     /1/ BULIRSCH,R.,RUTISHAUSER,H.: INTERPOLATION UND GENAEHERTE
C           QUADRATUR. IN:SAUER,R.,SZABO,I.(EDS.) MATHEMATISCHE HILFS-
C           MITTEL DES INGENIEURS,VOL.III. BERLIN-HEIDELBERG-NEW YORK:
C           SPRINGER, 1968.
C     /2/ RENTROP,P.: AN ALGORITHM FOR THE COMPUTATION OF THE
C           EXPONENTIAL SPLINE. NUMER. MATH. 35 (1980) 81-93.
C     /3/ RENTROP,P.,WEVER,U.: THEORY AND APPLICATION OF THE
C           EXPONENTIAL SPLINE. REP. 282, MATH. INST. TU MNCHEN, 1991.
C     /4/ AKIMA, H: A NEW METHOD OF INTERPOLATION AND SMOOTH CURVE FITTING
C           BASED ON LOCAL PROCEDURES. J. ACM 17 (1970) 589-602.

C   IMPLEMENTED BY:
C      KRAFT,D., DLR - INSTITUT FUER DYNAMIK DER FLUGSYSTEME
C                D-8031 OBERPFAFFENHOFEN

C   COPYRIGHT :
C     **************   D L R   **************
C     **************  1 9 8 6  **************
C     **************   F H M   **************
C     **************  1 9 9 1  **************

C   CHANGES:
C   INCORPORATION OF ZERO-ORDER SPLINES
C   TOGETHER WITH PARAMETER MODE FOR SPLINE SELECTION
C   31. JANUAR 1986
C   INCORPORATION OF AKIMA'S INTERPOLANT
C   14. JUNI 1989
C   INCORPORATION OF VISUALLY PLEASING INTERPOLANT
C   OF RENTROP & WEVER
C   16. JUNI 1991

C   STATUS: 16. JUNI 1991

C   SUBROUTINES REQUIRED: NONE

      INTEGER
     .I,IBACK,IS,MODE,N
      DOUBLE PRECISION
     .X(N),Y(N),P(N),A(N),B(N),C(N),C1,C2,D1,D2,H,HP,U,V,W,Z,
     .PHI,ZERO,ONE,TWO,THREE,HALF,QUART,A1,A2,A3,A4,UMAX
      DATA
     .ZERO/0D0/,ONE/1D0/,TWO/2D0/,THREE/3D0/,HALF/.5D0/,QUART/.25D0/,
     .A1/.166666666657193D+0/, A2/.833333363787823D-2/,
     .A3/.198409277128940D-3/, A4/.277139911687000D-5/,
     .UMAX/2.5D+01/,IS/6/

C**  AUXILIARY FUNCTION PHI WITH BEST APPROXIMATION FOR SINH  **

      PHI(Z) = A1+(A2+(A3+A4*Z)*Z)*Z

C**  Is MODE in it's range?  **

      if (MODE .lt. 1 .or. MODE .gt. 6) then
      write (IS,*) 'SPLINE: MODE not in its range; MODE=', MODE
      stop 'STOP SPLINE 01'
      endif

C**  DO YOU HAVE MONOTONE ABSCISSAE?  **

      DO 10 I=1,N-1
          IF (X(I) .ge. X(I+1)) GOTO 20
   10 CONTINUE
                          GOTO 40
   20 DO 30 I=1,N-1
          IF (X(I) .le. X(I+1)) Then
          WRITE (IS,*)
     .   'SPLINE: non-monotonic abscissae:', X(I), X(I+1)
          STOP 'STOP SPLINE 02'
          ENDIF
   30 CONTINUE

C**  CHOOSE INTERPOLATION ORDER  **

   40 GO TO (50, 60, 80, 130, 138, 180), MODE
   50                     GOTO 220

C**  LINEAR SPLINE COEFFICIENTS  **

   60 DO 70 I=1,N-1
   70     A(I) = (Y(I+1)-Y(I))/(X(I+1)-X(I))
                          GOTO 220

C**  CUBIC SPLINE COEFFICIENTS  **

C**  COMPUTATION OF THE ELEMENTS OF THE TRIDIAGONAL SYSTEM  **

   80 V = ZERO
      DO 90 I = 1,N-1
          C(I) = X(I+1)-X(I)
          U = (Y(I+1)-Y(I))/C(I)
          B(I) = U-V
   90     V = U
      U = ZERO
      V = U
      B(1) = V
      DO 100 I = 2,N-1
          B(I) = B(I)+U*B(I-1)
          A(I) = TWO*(X(I-1)-X(I+1))-U*V
          V = C(I)
  100     U = V/A(I)

C**  SOLUTION OF THE TRIDIAGONAL SYSTEM  **

      A(N) = ZERO
      B(N) = ZERO
      C(N) = ZERO
      DO 110 I = 2,N-1
          IBACK = N+1-I
  110     B(IBACK) = (C(IBACK)*B(IBACK+1)-B(IBACK))/A(IBACK)
      DO 120 I = 1,N-1
          V = C(I)
          U = B(I+1)-B(I)
          C(I) = U/V
          B(I) = THREE*B(I)
  120     A(I) = (Y(I+1)-Y(I))/V-(B(I)+U)*V
                          GOTO 220

C**  EXPONENTIAL SPLINE COEFFICIENTS  **

C**  A PRIORI COMPUTATION OF THE TENSION PARAMETERS  **

  130 DO 132 I = 1,N-1
  132     C(I) = X(I+1)-X(I)
      DO 134 I = 2,N-1
  134     B(I) = (Y(I+1)-Y(I))/C(I)-(Y(I)-Y(I-1))/C(I-1)
      DO 135 I = 2,N-2
          IF (B(I)*B(I+1) .EQ. ZERO) THEN
C             ABNORMAL CASE
              A(I) = UMAX
          ELSE IF (B(I)*B(I+1) .LT. ZERO) THEN
C             MONOTONICITY
              IF (Y(I+1) .EQ. Y(I)) THEN
                  A(I) = UMAX
              ELSE
                  A(I) = C(I)*ABS((B(I+1)-B(I))/(Y(I+1)-Y(I)))
              END IF
          ELSE
C             CONVEXITY
              H = ABS(B(I)/B(I+1))
              A(I) = MAX(H,ONE/H)
          END IF
          A(I) = MIN(UMAX,A(I))
          IF (A(I) .LT. THREE) A(I) = ZERO
  135 CONTINUE
      A(1) = A(2)
      A(N-1) = A(N-2)
      DO 136 I = 1,N-1
  136    P(I) = A(I)/C(I)

C**  COMPUTATION OF THE ELEMENTS OF THE TRIDIAGONAL SYSTEM  **

  138 U = Y(1)
      DO 140 I = 2,N
          V = Y(I)
          H = X(I)-X(I-1)
          C(I) = (V-U)/H
          U = V
          HP = H*P(I-1)
          IF (HP.GT.HALF) THEN
              D1 = EXP(-HP)
              D2 = D1*D1
              W = ONE-D2
              C1 = W*HP
              C2 = W/HP
              W = H/C1
              A(I) = (ONE-C2+D2)*W
              B(I) = (C2-TWO*D1)*W
          ELSE
              HP = HP*HP
              C1 = PHI(HP)
              W = H/(ONE+HP*C1)
              HP = QUART*HP
              C2 = ONE+HP*PHI(HP)
              A(I) = (HALF*C2*C2-C1)*W
              B(I) = C1*W
          ENDIF
  140 CONTINUE

C**  GENERATE THE TRIDIAGONAL SYSTEM  **

      U = ZERO
      C(1) = U
      DO 150 I = 2,N-1
          A(I) = A(I)+A(I+1)-U*B(I)
          C(I) = C(I+1)-C(I)-U*C(I-1)
  150     U = B(I+1)/A(I)

C**  SOLUTION OF THE TRIDIAGONAL SYSTEM  **

      C(N) = ZERO
      DO 160 I = 2,N-1
          IBACK = N+1-I
  160     C(IBACK) = (C(IBACK)-B(IBACK+1)*C(IBACK+1))/A(IBACK)

C**  STORE AUXILIARY TERMS FOR SPLINT & DSPLNT IN A & B  **

      DO 170 I = 1,N-1
          H = X(I+1)-X(I)
          HP = H*P(I)
          IF(HP.GT.HALF) THEN
              D1 = EXP(-HP)
              A(I) = ONE/(ONE-D1*D1)
              B(I) = ONE/(P(I)*P(I))
          ELSE
              HP = HP*HP
              D1 = PHI(HP)
              D2 = H*H/(ONE+HP*D1)
              A(I) = D2
              B(I) = D1
          ENDIF
  170 CONTINUE
                          GOTO 220

C**  AKIMA SPLINE COEFFICIENTS  **

  180 DO 190 I=1,N-1
  190     P(I) = (Y(I+1)-Y(I))/(X(I+1)-X(I))

C**  SLOPES AT NODES  **

      DO 200 I=3,N-2
          IF (P(I-2).EQ.P(I-1).AND.P(I).EQ.P(I+1)) THEN
              IF (P(I-1).NE.P(I)) THEN
                  A(I) = HALF*(P(I-1)+P(I))
              ELSE
                  A(I) = P(I)
              ENDIF
          ELSE
              U=ABS(P(I+1)-P(I))
              V=ABS(P(I-1)-P(I-2))
              A(I) = (U*P(I-1)+V*P(I))/(U+V)
          ENDIF
  200 CONTINUE

C**  BACKWARD EXTRAPOLATION  **

      U = X(1)+X(2)-X(3)
      H = U-X(1)
      C1 = Y(1)+H*(P(1)+P(1)-P(2))
      D1 = (C1-Y(1))/H
      V = U+X(1)-X(2)
      H = V-U
      C2 = C1+H*(D1+D1-P(1))
      D2 = (C2-C1)/H

      IF (D2.EQ.D1.AND.P(1).EQ.P(2)) THEN
          IF (D1.NE.P(1)) THEN
              A(1) = HALF*(D1+P(1))
          ELSE
              A(1) = P(1)
          ENDIF
      ELSE
          U = ABS(P(2)-P(1))
          V = ABS(D1-D2)
          A(1) = (U*D1+V*P(1))/(U+V)
      ENDIF
      IF (D1.EQ.P(1).AND.P(2).EQ.P(3)) THEN
          IF (P(1).NE.P(2)) THEN
              A(2) = HALF*(P(1)+P(2))
          ELSE
              A(2) = P(2)
          ENDIF
      ELSE
          U = ABS(P(3)-P(2))
          V = ABS(P(1)-D1)
          A(2) = (U*P(1)+V*P(2))/(U+V)
      ENDIF

C**  FORWARD EXTRAPOLATION  **

      U = X(N)+X(N-1)-X(N-2)
      H = U-X(N)
      C1 = Y(N)+H*(P(N-1)+P(N-1)-P(N-2))
      D1 = (C1-Y(N))/H
      V = U+X(N)-X(N-1)
      H = V-U
      C2 = C1+H*(D1+D1-P(N-1))
      D2 = (C2-C1)/H

      IF (P(N-3).EQ.P(N-2).AND.P(N-1).EQ.D1) THEN
          IF (P(N-2).NE.P(N-1)) THEN
              A(N-1) = HALF*(P(N-2)+P(N-1))
          ELSE
              A(N-1) = P(N-1)
          ENDIF
      ELSE
          U = ABS(P(N-1)-D1)
          V = ABS(P(N-2)-P(N-3))
          A(N-1) = (U*P(N-2)+V*P(N-1))/(U+V)
      ENDIF
      IF (P(N-2).EQ.P(N-1).AND.D1.EQ.D2) THEN
          IF (P(N-1).NE.D1) THEN
              A(N) = HALF*(P(N-1)+D1)
          ELSE
              A(N) = D1
          ENDIF
      ELSE
          U = ABS(D1-D2)
          V = ABS(P(N-1)-P(N-2))
          A(N) = (U*P(N-1)+V*D1)/(U+V)
      ENDIF

      DO 210 I=1,N-1
          H = X(I+1)-X(I)
          B(I) = (P(I)+P(I)+P(I)-A(I)-A(I)-A(I+1))/H
  210     C(I) = (A(I)+A(I+1)-P(I)-P(I))/(H*H)

  220                     RETURN

C  END OF SPLINE

      END


      DOUBLE PRECISION FUNCTION SPLINT (MODE,N,X,Y,P,A,B,C,XS)
C   SPLINT  INTERPOLATES IN THE RANGE OF COEFFICIENT SETS FOR CUBIC
C           OR EXPONENTIAL SPLINES ESTABLISHED IN SUBROUTINE SPLINE

C   PURPOSE:
C     INTERPOLATION  WITHIN COEFFICIENT SETS FOR CUBIC OR EXPONENTIAL
C     SPLINES

C   INPUT ARGUMENTS:
C     MODE  : INDICATES ORDER OF INTERPOLATION:
C             1 = PIECEWISE CONSTANT
C             2 = PIECEWISE LINEAR
C             3 = PIECEWISE CUBIC SPLINE
C             4 = PIECEWISE EXPONENTIAL SPLINE
C                 WITH TENSIONS A PRIORI CALCULATED
C             5 = PIECEWISE EXPONENTIAL SPLINE
C                 WITH TENSIONS GIVEN BY USER
C             6 = AKIMA'S INTERPOLANT
C     N     : NUMBER OF DATA FOR WHICH THE COEFFICIENT SET HAS BEEN
C             CALCULATED IN SUBROUTINE SPLINE PREVIOUSLY
C     X     : VECTOR OF LENGTH N STORING THE ABSCISSAE
C     Y     : VECTOR OF LENGTH N STORING THE DATA POINTS
C     P     : VECTOR OF LENGTH N STORING THE STIFFNESS PARAMETERS
C     A,B,C : VECTOR OF LENGTH N EACH STORING THE COEFFICIENT SET
C     XS    : ABSCISSA AT WHICH INTERPOLATION IS REQUIRED

C   OUTPUT ARGUMENTS:
C     SPLINT: VALUE OF THE INTERPOLATING ORDINATE AT ABSCISSA XS

C   METHOD:
C     THAT OF CHR. REINSCH, P. RENTROP & D. KRAFT AS DESCRIBED IN:
C     /1/ BULIRSCH,R.,RUTISHAUSER,H.: INTERPOLATION UND GENAEHERTE
C           QUADRATUR. IN:SAUER,R.,SZABO,I.(EDS.) MATHEMATISCHE HILFS-
C           MITTEL DES INGENIEURS,VOL.III. BERLIN-HEIDELBERG-NEW YORK:
C           SPRINGER, 1968.
C     /2/ RENTROP,P.: AN ALGORITHM FOR THE COMPUTATION OF THE
C           EXPONENTIAL SPLINE. NUMER. MATH. 35 (1980) 81-93.
C     /3/ KRAFT,D.: FIRST DERIVATIVES OF EXPONENTIAL SPLINES.
C                   UNPUBLISHED MANUSCRIPT (1984).
C     /4/ AKIMA, H: A NEW METHOD OF INTERPOLATION AND SMOOTH CURVE FITTING
C           BASED ON LOCAL PROCEDURES. J. ACM 17 (1970) 589-602.

C   IMPLEMENTED BY:
C      KRAFT,D., DLR - INSTITUT FUER DYNAMIK DER FLUGSYSTEME
C                D-8031 OBERPFAFFENHOFEN

C   STATUS: 14. JUNI 1989
C   SUBROUTINES REQUIRED: * = DIRECT CALL
C      * LEFT

      INTEGER
     .IP,IS,LEFT,MFLAG,MODE,N
      DOUBLE PRECISION
     .X(N),Y(N),P(N),A(N),B(N),C(N),H,U,V,Z,D1,D2,HP,XS,XT,
     .PHI,DPHI,ZERO,ONE,HALF,A1,A2,A3,A4,DSPLNT
      DATA ZERO/0.D0/,ONE/1.D0/,HALF/.5D0/,
     .A1/.166666666657193D+0/, A2/.833333363787823D-2/,
     .A3/.198409277128940D-3/, A4/.277139911687000D-5/

C**  AUXILIARY FUNCTION PHI WITH BEST APPROXIMATION FOR SINH  **

      PHI(Z) = A1+(A2+(A3+A4*Z)*Z)*Z
      DPHI(Z) = (Z+Z)*(A2+Z*Z*(A3+A3+(A4+A4+A4)*Z*Z))

C**  FIND INDEX OF ABSCISSA WHICH LIES IMMEDIATELY LEFT OF XS **

      IS = LEFT(N,X,XS,MFLAG)
      XT = XS
      IF(MFLAG.EQ.-1) XT = X(1)
      IF(MFLAG.EQ. 1) XT = X(N)

C**  CHOOSE INTERPOLATION ORDER  **

      GO TO (10, 15, 20, 25, 25, 20), MODE

C**  CONSTANT SPLINE  **

   10 IF(MFLAG.EQ. 1) IS = IS-1
      SPLINT = Y(IS)
                       GOTO 70

C**  LINEAR SPLINE  **

   15 SPLINT = Y(IS)
      U = XT-X(IS)
      IF(U.EQ.ZERO)    GOTO 70
      SPLINT = SPLINT+A(IS)*U
                       GOTO 70

C**  CUBIC SPLINE  & AKIMA SPLINE **

   20 SPLINT = Y(IS)
      U = XT-X(IS)
      IF(U.EQ.ZERO)    GOTO 70
      SPLINT = SPLINT+(A(IS)+(B(IS)+C(IS)*U)*U)*U
                       GOTO 70

C**  EXPONENTIAL SPLINE **

   25 SPLINT = Y(IS)
      U = XT-X(IS)
      IF(U.EQ.ZERO)    GOTO 70
      IP = IS+1
      H = X(IP)-X(IS)
      U = U/H
      V = ONE-U
      HP = H*P(IS)
      IF(HP.LE.HALF)   GOTO 30
      D1 = EXP(-HP*U)
      D2 = EXP(-HP*V)
      SPLINT = U*Y(IP)+(A(IS)*D2*(ONE-D1*D1)-U)*B(IS)*C(IP)
     .       + V*Y(IS)+(A(IS)*D1*(ONE-D2*D2)-V)*B(IS)*C(IS)
                       GOTO 70
   30 HP = HP*HP
      D1 = U*U
      D2 = V*V
      SPLINT = U*(Y(IP)+A(IS)*C(IP)*(D1*PHI(HP*D1)-B(IS)))
     .       + V*(Y(IS)+A(IS)*C(IS)*(D2*PHI(HP*D2)-B(IS)))
                       GOTO 70

C   END OF SPLINT

      ENTRY         DSPLNT   (N,X,Y,P,A,B,C,XS)

C**  FIRST DERIVATIVE OF SPLINE FUNCTION  **

      IS = LEFT(N,X,XS,MFLAG)
      XT = XS
      IF(MFLAG.EQ.-1) XT = X(1)
      IF(MFLAG.EQ. 1) XT = X(N)
      IF(MFLAG.EQ. 1) IS = IS-1
      GO TO (40, 45, 50, 55, 55, 50), MODE

C**  CONSTANT SPLINE  **

   40 DSPLNT = ZERO
                       GOTO 70

C**  LINEAR SPLINE  **

   45 DSPLNT = A(IS)
                       GOTO 70

C**  CUBIC & AKIMA SPLINE  **

   50 DSPLNT = A(IS)
      U = XT-X(IS)
      IF(U.EQ.ZERO)    GOTO 70
      DSPLNT = DSPLNT+(2*B(IS)+3*C(IS)*U)*U
                       GOTO 70

C**  EXPONENTIAL SPLINE  **

   55 IP = IS+1
      U = XT-X(IS)
      H = X(IP)-X(IS)
      U = U/H
      V = ONE-U
      HP = H*P(IS)
      IF(HP.LE.HALF)   GOTO 60
      D1 = EXP(-HP*U)
      D2 = EXP(-HP*V)
      DSPLNT = Y(IP)+(A(IS)*HP*D2*(ONE+D1*D1)-ONE)*B(IS)*C(IP)
     .       - Y(IS)-(A(IS)*HP*D1*(ONE+D2*D2)-ONE)*B(IS)*C(IS)
                       GOTO 65
   60 D1 = U*U
      D2 = V*V
      U = HP*U
      V = HP*V
      HP = HP*HP
      DSPLNT = Y(IP)+A(IS)*C(IP)*(D1*(3*PHI(HP*D1)+U*DPHI(U))-B(IS))
     .       - Y(IS)-A(IS)*C(IS)*(D2*(3*PHI(HP*D2)+V*DPHI(V))-B(IS))
   65 DSPLNT = DSPLNT/H
   70                  RETURN

C   END OF DSPLNT

      END


      SUBROUTINE GENERA(N,X,Y,P,D)
C   GENERA  GENERATES A POSTERIORI STIFFNES PARAMETERS
C           FOR EXPONENTIAL SPLINES

C   PURPOSE:
C     GENERATES STIFFNES PARAMETERS FOR EXPONENTIAL SPLINES
C     TO BE USED FOR INTERPOLATION IN CONNECTION WITH
C     SUBROUTINE SPLINE AND FUNCTION SPLINT

C   INPUT ARGUMENTS:
C     N     : NUMBER OF DATA FOR WHICH THE STIFFNESS PARAMETERS
C             ARE TO BE CALCULATED
C     X     : VECTOR OF LENGTH N STORING THE ABSCISSAE
C     Y     : VECTOR OF LENGTH N STORING THE DATA POINTS
C     D     : VECTOR OF LENGTH N STORING THE SECOND DERIVATIVES OF DATA

C   OUTPUT ARGUMENTS:
C     P     : VECTOR OF LENGTH N STORING THE STIFFNESS PARAMETERS

C   METHOD:
C     THAT OF P. RENTROP AS DESCRIBED IN:
C         RENTROP,P. (1979) AN ALGORITHM FOR THE COMPUTATION OF THE
C           EXPONENTIAL SPLINE. NUMER. MATH. 35 (1980) 81-93.

C   IMPLEMENTED BY:
C      KRAFT,D., DLR - INSTITUT FUER DYNAMIK DER FLUGSYSTEME
C                D-8031 OBERPFAFFENHOFEN

C   STATUS: 15. JANUARY 1980

C   SUBROUTINES REQUIRED: NONE

      INTEGER          N,I
      DOUBLE PRECISION X(N),Y(N),P(N),D(N),A,C,HM,YM,HI,YI,HP,YP,EPMACH
      DATA             EPMACH/2.22D-16/

      DO 10 I=2,N-2
      P(I)=EPMACH
      A=D(I)*D(I+1)
      IF(A.GT.0D0 .AND. ABS(A).GT.EPMACH) GOTO 10
      HM=X(I)-X(I-1)
      YM=Y(I)-Y(I-1)
      HI=X(I+1)-X(I)
      YI=Y(I+1)-Y(I)
      HP=X(I+2)-X(I+1)
      YP=Y(I+2)-Y(I+1)
      A=(HM*YI-HI*YM)/HI
      A=A*(HI*YP-HP*YI)/HP
      IF(A.LT.0D0 .AND. ABS(A).GT.EPMACH) GOTO 10
      IF(ABS(Y(I)).EQ.0D0 .AND. ABS(Y(I+1)).EQ.0D0) THEN
         P(I)=15D0/HI
      ELSE
         C=.1D0+ABS(YI)/DMAX1(ABS(Y(I+1)),ABS(Y(I)))
         P(I)=(4D0+1D0/C)/HI
      END IF
   10 CONTINUE
      P(1)=P(2)
      P(N-1)=P(N-2)
      RETURN

C   END OF GENERA

      END


      INTEGER FUNCTION LEFT(LXT,XT,X,MFLAG)
C   LEFT    FINDS INDEX LEFT OF AN ARRAY XT FOR WHICH XT(LEFT)
C           LIES IMMEDIATELY LEFT OF X

C   PURPOSE:
C           FINDS INDEX LEFT OF AN ARRAY XT FOR WHICH XT(LEFT)
C           LIES IMMEDIATELY LEFT OF X

C   INPUT ARGUMENTS:
C     LXT   : NUMBER OF ELEMENTS IN VECTOR XT
C     XT    : VECTOR OF LENGTH LXT STORING THE ABSCISSAE
C     X     : X-VALUE FOR WHICH THE INDEX LEFT IS TO BE FOUND

C   OUTPUT ARGUMENTS:
C     LEFT  : INDEX FOR WHICH XT(LEFT) LIES IMMEDIATELY LEFT OF X
C     MFLAG : FLAG SET IN THE FOLLOWING MANNER
C             LEFT  MFLAG
C              1     -1     IF               X .LT. XT(1)
C              I      0     IF  XT(I)   .LE. X .LT. XT(I+1)
C             LXT     1     IF  XT(LXT) .LE. X

C   METHOD:
C     THAT OF CARL DE BOOR AS DESCRIBED ON PAGE 91 FF. IN:
C     /1/ DE BOOR,C. (1978) A PRACTICAL GUIDE TO SPLINES.
C         APPLIED MATHEMATICAL SCIENCES, VOLUME 27.
C         NEW-YORK-HEIDELBERG-BERLIN: SPRINGER.

C   IMPLEMENTED BY:
C      KRAFT,D., DLR - INSTITUT FUER DYNAMIK DER FLUGSYSTEME
C                D-8031 OBERPFAFFENHOFEN

C   STATUS: 15. JANUARY 1980

C   SUBROUTINES REQUIRED: NONE

      INTEGER LXT,MFLAG,IHI,ILO,ISTEP,MIDDLE
      DOUBLE PRECISION X,XT(LXT)
      SAVE ILO
      DATA ILO/1/

      IHI=ILO+1
      IF(IHI.LT.LXT)                   GOTO  10
      IF(X.GE.XT(LXT))                 GOTO 110
      IF(LXT.LE.1)                     GOTO  90
      ILO=LXT-1
      IHI=LXT
   10 IF(X.GE.XT(IHI))                 GOTO  40
      IF(X.GE.XT(ILO))                 GOTO 100
      ISTEP=1
   20 IHI=ILO
      ILO=IHI-ISTEP
      IF(ILO.LE.1)                     GOTO  30
      IF(X.GE.XT(ILO))                 GOTO  70
      ISTEP=ISTEP+ISTEP
                                       GOTO  20
   30 ILO=1
      IF(X.LT.XT(1))                   GOTO  90
                                       GOTO  70
   40 ISTEP=1
   50 ILO=IHI
      IHI=ILO+ISTEP
      IF(IHI.GE.LXT)                   GOTO  60
      IF(X.LT.XT(IHI))                 GOTO  70
      ISTEP=ISTEP+ISTEP
                                       GOTO  50
   60 IF(X.GE.XT(LXT))                 GOTO 110
      IHI=LXT
   70 MIDDLE=(ILO+IHI)/2
      IF(MIDDLE.EQ.ILO)                GOTO 100
      IF(X.LT.XT(MIDDLE))              GOTO  80
      ILO=MIDDLE
                                       GOTO  70
   80 IHI=MIDDLE
                                       GOTO  70
   90 MFLAG=-1
      LEFT=1
                                       GOTO 120
  100 MFLAG=0
      LEFT=ILO
                                       GOTO 120
  110 MFLAG=1
      LEFT=LXT
  120                                  RETURN

C   END OF LEFT

      END


      SUBROUTINE RK54 (F,N,Y,T,TOUT,RELERR,ABSERR,IFLAG,WORK,IWORK,W,IW)
C   RK54   INITIAL VALUE SOLVER BASED ON HIGH ORDER RUNGE-KUTTA FORMULAE

C   ADAPTATION OF THE IMPLEMENTATION OF
C   FEHLBERG'S FOURTH-FIFTH ORDER RUNGE-KUTTA METHOD
C   WRITTEN BY
C                 L.F.SHAMPINE & H.A.WATTS
C                   SANDIA LABORATORIES
C                 ALBUQUERQUE, NEW MEXICO

C   TO THE MORE ACCURATE PRINCE/DORMAND FOURTH-FIFTH ORDER FORMULAE
C   BY
C                        D.KRAFT
C          INSTITUT FUER DYNAMIK DER FLUGSYSTEME
C                  DLR OBERPFAFFENHOFEN

C   STATUS: 27. JANUARY 1985

C   RK54 IS PRIMARILY DESIGNED TO SOLVE NON-STIFF AND MILDLY STIFF
C   DIFFERENTIAL EQUATIONS WITH MEDIUM TO HIGH ACCURACY & LOW OUTPUT

C-----------------------------------------------------------------------
C   ABSTRACT
C-----------------------------------------------------------------------

C   SUBROUTINE RK54 INTEGRATES A SYSTEM OF N FIRST ORDER
C   ORDINARY DIFFERENTIAL EQUATIONS OF THE FORM
C              DY(I)/DT = F(T,Y(1),Y(2),...,Y(N))
C              WHERE THE Y(I) ARE GIVEN AT T .
C   TYPICALLY THE SUBROUTINE IS USED TO INTEGRATE FROM T TO TOUT BUT
C   IT CAN BE USED AS A ONE-STEP INTEGRATOR TO ADVANCE THE SOLUTION A
C   SINGLE STEP IN THE DIRECTION OF TOUT. ON RETURN THE PARAMETERS IN
C   THE CALL LIST ARE SET FOR CONTINUING THE INTEGRATION. THE USER HAS
C   ONLY TO CALL RK54 AGAIN (AND PERHAPS DEFINE A NEW VALUE FOR TOUT).
C   ACTUALLY, RK54 IS AN INTERFACING ROUTINE WHICH CALLS SUBROUTINE
C   RKC54 FOR THE SOLUTION. RKC54 IN TURN CALLS SUBROUTINE CORE WHICH
C   COMPUTES AN APPROXIMATE SOLUTION OVER ONE STEP.

C   RKF45 USES THE RUNGE-KUTTA-FEHLBERG (4,5) METHOD DESCRIBED IN
C   THE REFERENCES
C   E. FEHLBERG, LOW-ORDER CLASSICAL RUNGE-KUTTA FORMULAS WITH STEPSIZE
C                  CONTROL, NASA TR R-315.
C                  ALSO IN COMPUTING 6 (1970) 61-71.

C   L.F. SHAMPINE AND H.A. WATTS, PRACTICAL SOLUTION OF ORDINARY
C                  DIFFERENTIAL EQUATIONS BY RUNGE-KUTTA METHODS.
C                  SANDIA LABORATORIES REPORT SAND76-0585.

C   L.F. SHAMPINE AND H.A. WATTS, THE ART OF WRITING A RUNGE-KUTTA CODE
C                  APPL. MATH. COMP. 5 (1979) 93-121.

C   THE PERFORMANCE OF RKF45 IS ILLUSTRATED IN THE REFERENCE
C   L.F. SHAMPINE, H.A. WATTS, S. DAVENPORT, SOLVING NON-STIFF ORDINARY
C                  DIFFERENTIAL EQUATIONS-THE STATE OF THE ART.
C                  SANDIA LABORATORIES REPORT SAND78-0182 .  ALSO IN
C                  SIAM REVIEW 18 (1976) 376-411.

C   RK54  USES THE RUNGE-KUTTA (5,4) METHOD DESCRIBED IN
C   P.J. PRINCE, J.R. DORMAND 'A FAMILY OF EMBEDED RUNGE-KUTTA FORMULAE'
C                J. COMP. APPL. MATH. 6 (1980) 19-26.

C   THE PARAMETERS REPRESENT
C   F -- SUBROUTINE F(T,Y,YP) TO EVALUATE DERIVATIVES YP(I)=DY(I)/DT
C   N -- NUMBER OF EQUATIONS TO BE INTEGRATED
C   Y( ) -- SOLUTION VECTOR AT T
C   T -- INDEPENDENT VARIABLE
C   TOUT -- OUTPUT POINT AT WHICH SOLUTION IS DESIRED
C   RELERR,ABSERR -- RELATIVE AND ABSOULTE ERROR TOLERANCES FOR LOCAL
C           ERROR TEST. AT EACH STEP THE CODE REQUIRES THAT
C           ABS(LOCAL ERROR) .LE. RELERR*ABS(Y) + ABSERR
C           FOR EACH COMPONENT OF THE LOCAL ERROR AND SOLUTION VECTORS
C   IFLAG -- INDICATOR FOR STATUS OF INTEGRATION
C   WORK( ) -- ARRAY TO HOLD INFORMATION INTERNAL TO RK54 WHICH IS
C           NECESSARY FOR SUBSEQUENT CALLS.  MUST BE DIMENSIONED
C           AT LEAST 7*N + 3
C   IWORK( ) -- INTEGER ARRAY USED TO HOLD INFORMATION INTERNAL TO
C           RK54 WHICH IS NECESSARY FOR SUBSEQUENT CALLS.   MUST BE
C           DIMENSIONED AT LEAST 5

C----------------------------------------------------------------------
C   FIRST CALL TO RK54
C----------------------------------------------------------------------

C   THE USER MUST PROVIDE STORAGE IN HIS CALLING PROGRAM FOR THE ARRAY
C   IN THE CALL LIST  -  Y(N), WORK(3+12*N), IWORK(5),
C   DECLARE F IN AN EXTERNAL STATEMENT, SUPPLY SUBROUTINE F(T,Y,YP)
C   AND INITIALIZE THE FOLLOWING PARAMETERS
C   N -- NUMBER OF EQUATIONS TO BE INTEGRATED.       (N .GE. 1)
C   Y( ) -- VECTOR OF INITIAL CONDITIONS
C   T -- STARTING POINT OF INTEGRATION, MUST BE A VARIABLE
C        T=TOUT IS ALLOWED ON THE FIRST CALL ONLY, IN WHICH CASE
C        RK54 RETURNS WITH IFLAG=2 IF CONTINUATION IS POSSIBLE.
C   RELERR,ABSERR -- RELATIVE AND ABSOLUTE LOCAL ERROR TOLERANCES
C        WHICH MUST BE NON-NEGATIVE.  RELERR MUST BE A VARIABLE WHILE
C        ABSERR MAY BE A CONSTANT.  THE CODE SHOULD NORMALLY NOT BE
C        USED WITH RELATIVE ERROR CONTROL SMALLER THAN ABOUT 1.D-11.
C        TO AVOID LIMITING PRECISION DIFFICULTIES THE CODE REQUIRES
C        RELERR TO BE LARGER THAN AN INTERNALLY COMPUTED RELATIVE
C        ERROR PARAMETER WHICH IS MACHINE DEPENDENT.  IN PARTICULAR,
C        PURE ABSOLUTE ERROR IS NOT PERMITTED.  IF A SMALLER THAN
C        ALLOWABLE VALUE OF RELERR IS ATTEMPTED, RK54 INCREASES
C        RELERR APPROPRIATELY AND RETURNS CONTROL TO THE USER BEFORE
C        CONTINUING THE INTEGRATION.
C   IFLAG -- +1,-1 INDICATOR TO INITIALIZE THE CODE FOR EACH NEW
C        PROBLEM.  NORMAL INPUT IS +1.  THE USER SHOULD SET IFLAG=-1
C        ONLY WHEN ONE-STEP INTEGRATOR CONTROL IS ESSENTIAL.  IN THIS
C        CASE, RK54 ATTEMPTS TO ADVANCE THE SOLUTION A SINGLE STEP
C        IN THE DIRECTION OF TOUT EACH TIME IT IS CALLED.  SINCE THIS
C        MODE OF OPERATION RESULTS IN EXTRA COMPUTING OVERHEAD, IT
C        SHOULD BE AVOIDED UNLESS NEEDED.

C-----------------------------------------------------------------------
C   OUTPUT FROM RK54
C-----------------------------------------------------------------------

C   Y( ) -- SOLUTION AT T
C   T -- LAST POINT REACHED IN INTEGRATION.
C   IFLAG   = 2 -- INTEGRATION REACHED TOUT. INDICATES SUCCESSFUL RETURN
C                  AND IS THE NORMAL MODE FOR CONTINUING INTEGRATION.
C           =-2 -- A SINGLE SUCCESSFUL STEP IN THE DIRECTION OF TOUT
C                  HAS BEEN TAKEN.  NORMAL MODE FOR CONTINUING
C                  INTEGRATION ONE STEP AT A TIME.
C           = 3 -- INTEGRATION WAS NOT COMPLETED BECAUSE RELATIVE ERROR
C                  TOLERANCE WAS TOO SMALL. RELERR HAS BEEN INCREASED
C                  APPROPRIATELY FOR CONTINUING.
C           = 4 -- INTEGRATION WAS NOT COMPLETED BECAUSE MORE THAN
C                  3000 DERIVATIVE EVALUATIONS WERE NEEDED.  THIS
C                  IS APPROXIMATELY 500 STEPS
C           = 5 -- INTEGRATION WAS NOT COMPLETED BECAUSE SOLUTION
C                  VANISHED MAKING A PURE RELATIVE ERROR TEST
C                  IMPOSSIBLE.  MUST USE NON-ZERO ABSERR TO CONTINUE.
C                  USING THE ONE-STEP INTEGRATION MODE FOR STEP
C                  IS A GOOD WAY TO PROCEED.
C           = 6 -- INTEGRATION WAS NOT COMPLETED BECAUSE REQUESTED
C                  ACCURACY COULD NOT BE ACHIEVED USING SMALLEST
C                  ALLOWABLE STEPSIZE. USER MUST INCREASE THE ERROR
C                  TOLERANCE BEFORE CONTINUED INTEGRATION CAN BE
C                  ATTEMPTED.
C           = 7 -- IT IS LIKELY THAT RK54 IS INEFFICIENT FOR SOLVING
C                  THIS PROBLEM.  TOO MUCH OUTPUT IS RESTRICTING THE
C                  NATURAL STEPSIZE CHOICE. USE THE ONE-STEP INTEGRATOR
C                  MODE.
C           = 8 -- INVALID INPUT PARAMETERS
C                  THIS INDICATOR OCCURS IF ANY OF THE FOLLOWING IS
C                  SATISFIED - N .LE. 0
C                              T=TOUT AND IFLAG .NE. +1 OR -1
C                              RELERR OR ABSERR .LT. 0.
C                              IFLAG .EQ. 0 OR .LT. -2 OR .GT.8
C   WORK( ),IWORK( ) -- INFORMATION WHICH IS USUALLY OF NO INTEREST
C                  TO THE USER BUT NECESSARY FOR SUBSEQUENT CALLS
C                  WORK(1),...,WORK(N) CONTAINS THE FIRST DERIVATIVES
C                  OF THE SOLUTION VECTOR Y AT T. WORK(N+1) CONTAINS
C                  THE STEP SIZE H TO BE ATTEMPTED ON THE NEXT STEP.
C                  IWORK(1) CONTAINS THE DERIVATIVE EVALUATION COUNTER.

C-----------------------------------------------------------------------
C   SUBSEQUENT CALLS TO RK54
C-----------------------------------------------------------------------

C   SUBROUTINE RK54 RETURNS WITH ALL INFORMATION NEEDED TO CONTINUE
C   THE INTEGRATION. IF THE INTEGRATION REACHED TOUT, THE USER NEED ONLY
C   DEFINE A NEW TOUT AND CALL RK54 AGAIN. IN THE ONE-STEP INTEGRATOR
C   MODE (IFLAG=-2) THE USER MUST KEEP IN MIND THAT EACH STEP TAKEN IS
C   IN THE DIRECTION OF THE CURRENT TOUT. UPON REACHING TOUT (INDICATED
C   BY CHANGING IFLAG TO 2), THE USER MUST THEN DEFINE A NEW TOUT AND
C   RESET IFLAG TO -2 TO CONTINUE IN THE ONE STEP INTEGRATOR MODE.

C   IF THE INTEGRATION WAS NOT COMPLETED BUT THE USER STILL WANTS TO
C   CONTINUE (IFLAG=3,4 CASES), HE JUST CALLS RK54 AGAIN. WITH IFLAG=3
C   THE RELERR PARAMETER HAS BEEN ADJUSTED APPROPTIATELY FOR CONTINUING
C   THE INTEGRATION.   IN THE CASE OF IFLAG=4 THE FUNCTION COUNTER WILL
C   BE RESET TO 0 AND ANOTHER 6000 FUNCTION EVALUATIONS ARE ALLOWED.

C   HOWEVER, IN THE CASE IFLAG=5, THE USER MUST FIRST ALTER THE ERROR
C   CRITERION TO USE A POSITIVE VALUE OF ABSERR BEFORE INTEGRATION CAN
C   PROCEED.    IF HE DOES NOT, EXECUTION IS TERMINATED.

C   ALSO, IN THE CASE IFLAG=6, IT IS NECESSARY FOR THE USER TO RESET
C   IFLAG TO 2 (OR -2 WHEN THE ONE-STEP INTEGRATION MODE IS BEING USED)
C   AS WELL AS INCREASING EITHER ABSERR, RELERR OR BOTH BEFORE THE
C   INTEGRATION CAN BE CONTINUED.  IF THIS IS NOT DONE, EXECUTION WILL
C   BE TERMINATED.  THE OCCURRENCE OF IFLAG=6 INDICATES A TROUBLE SPOT
C   (SOLUTION IS CHANGING RAPIDLY, SINGULARITY MAY BE PRESENT) AND IT
C   OFTEN IS INADVISABLE TO CONTINUE.

C   IF IFLAG=7 IS ENCOUNTERED, THE USER SHOULD USE THE ONE-STEP
C   INTEGRATION MODE WITH THE STEPSIZE DETERMINED BY THE CODE OR
C   CONSIDER SWITCHING TO THE ADAMS CODES DE,STEP,INTRP.  IF THE USER
C   INSISTS UPON CONTINUING THE INTEGRATION WITH RK54, HE MUST RESET
C   IFLAG TO 2 BEFORE CALLING RK54 AGAIN.   OTHERWISE, EXECUTION WILL
C   BE TERMINATED.

C   IF IFLAG=8 IS OBTAINED, INTEGRATION CANNOT BE CONTINUED UNLESS
C   THE INVALID INPUT PARAMETERS ARE CORRECTED.

C   IT SHOULD BE NOTED THAT THE ARRAYS WORK,IWORK CONTAIN INFORMATION
C   REQUIRED FOR SUBSEQUENT INTEGRATION.  ACCORDINGLY, WORK AND IWORK
C   SHOULD NOT BE ALTERED.

C-----------------------------------------------------------------------

      INTEGER IFLAG, K1, K2, K3, K4, K5, K6, K7, K8, K1M, N
      INTEGER IWORK(5), IW(*)
      DOUBLE PRECISION Y(N), WORK(*), W(*), T, TOUT, ABSERR, RELERR
      EXTERNAL F

C   COMPUTE INDICES FOR THE SPLITTING OF THE WORK ARRAY

      K1M = N + 1
      K1 = K1M + 1
      K2 = K1 + N
      K3 = K2 + N
      K4 = K3 + N
      K5 = K4 + N
      K6 = K5 + N
      K7 = K6 + N
      K8 = K7 + N

C-----------------------------------------------------------------------
C   THIS INTERFACING ROUTINE MERELY RELIEVES THE USER OF A LONG
C   CALLING LIST VIA THE SPLITTING APART OF TWO WORKING STORAGE
C   ARRAYS.   IF THIS IS NOT COMPATIBLE WITH THE USERS COMPILER,
C   HE MUST USE RKC54 DIRECTLY.
C-----------------------------------------------------------------------

      CALL RKC54(F,N,Y,T,TOUT,RELERR,ABSERR,IFLAG,WORK(1),WORK(K1M),WORK
     1(K1),WORK(K2),WORK(K3),WORK(K4),WORK(K5),WORK(K6),WORK(K7),WORK
     3(K8),WORK(K8+1),IWORK(1),IWORK(2),IWORK(3),IWORK(4),IWORK(5),W,IW)
      RETURN
      END


      SUBROUTINE RKC54(F,N,Y,T,TOUT,RELERR,ABSERR,IFLAG,YP,H,F1,F2,F3,
     1 F4,F5,F6,F7,SAVRE,SAVAE,NFE,KOP,INIT,JFLAG,KFLAG,W,IW)

C   PRINCE/DORMAND 5(4) ORDER RUNGE-KUTTA METHOD

C   RKC54 INTEGRATES A SYSTEM OF FIRST ORDER ORDINARY DIFFERENTIAL
C   EQUATIONS AS DESCRIBED IN THE COMMENTS FOR RK54 .
C   THE ARRAYS YP,F1,....,F10 AND F11 (OF DIMENSION AT LEAST N) AND
C   THE VARIABLES H,SAVRE,SAVAE,NFE,KOP,INIT,JFLAG,AND KFLAG ARE USED
C   INTERNALLY BY THE CODE AND APPEAR IN THE CALL LIST TO ELIMINATE
C   LOCAL RETENTION OF VARIABLES BETWEEN CALLS.    ACCORDINGLY, THEY
C   SHOULD NOT BE ALTERED.    ITEMS OF POSSIBLE INTEREST ARE :
C       YP - DERIVATIVE OF SOLUTION VECTOR AT T
C       H  - AN APPROPRIATE STEP SIZE TO BE USED FOR THE NEXT STEP
C       NFE- COUNTER ON THE NUMBER OF DERIVATIVE FUNCTION EVALUATIONS

C-----------------------------------------------------------------------

      INTEGER          IW(*)
      INTEGER          IFLAG, INIT, JFLAG, K, KFLAG, KOP,
     1                 MAXNFE, MFLAG, N, NFE
      DOUBLE PRECISION Y(N),YP(N),F1(N),F2(N),F3(N),F4(N),F5(N),F6(N),
     1                 F7(N),W(*),A,ABSERR,AE,ALF,TOL,TOLN,YPK,
     2                 DT,EE,EEOET,ESTOLD,ESTTOL,ET,H,HMIN,HOLD,
     3                 RELERR,REMIN,RE,S,SAVAE,SAVRE,SCALE,T,TOUT,U,U26
      LOGICAL          FIRST,HFAILD,OUTPUT
      EXTERNAL         F

C-----------------------------------------------------------------------
C   THE COMPUTER UNIT ROUND OFF ERROR U IS THE SMALLEST POSITIVE VALUE
C   REPRESENTABLE IN THE MACHINE SUCH THAT 1.+U .GT. 1.
C                     VALUES TO BE USED ARE
C                 U = 9.5D-7          FOR IBM 360/370
C                 U = 1.5D-8          FOR UNIVAC 1108
C                 U = 7.5D-9          FOR PDP-10
C                 U = 7.1D-15         FOR CDC 6000 SERIES
C                 U = 2.2D-16         FOR IBM 360/370 DOUBLE PRECISION
C                 U = 2.2D-16         FOR IBM PS/2 MODEL 70 D.P.
      DATA        U  /2.22D-16/

C-----------------------------------------------------------------------
C   REMIN IS A TOLERANCE THRESHOLD WHICH IS ALSO DETERMINED BY THE
C   INTEGRATION METHOD.
      DATA REMIN /1.D-14/
C-----------------------------------------------------------------------
      DATA MAXNFE /3000/

C   CHECK INPUT PARAMETERS

      IF (N .LT. 1) GO TO 10
      IF (RELERR .LT. 0.D0 .OR. ABSERR .LT. 0.D0) GO TO 10
      MFLAG = ABS(IFLAG)
      IF (MFLAG .GE. 1 .AND. MFLAG .LE. 8) GO TO 50

C   INVALID INPUT

   10 IFLAG = 8
      GO TO 290

C   IS THIS THE FIRST CALL ?

   50 IF (MFLAG .EQ. 1) GO TO 100

C   CHECK CONTINUATION POSSIBILITIES

      IF (T .EQ. TOUT .AND. KFLAG .NE. 3) GO TO 10
      IF (MFLAG .NE. 2) GO TO 60

C   IFLAG = +2 OR -2

      IF (KFLAG .EQ. 3) GO TO 90
      IF (INIT .EQ. 0)  GO TO 90
      IF (KFLAG .EQ. 4) GO TO 80
      IF (KFLAG .EQ. 5 .AND. ABSERR .EQ. 0.D0) GO TO 70
      IF (KFLAG .EQ. 6 .AND. RELERR .LE. SAVRE .AND. ABSERR .LE. SAVAE)
     +GO TO 70
      GO TO 100

C   IFLAG = 3,4,5,6,7, OR 8

   60 IF (IFLAG .EQ. 3) GO TO 90
      IF (IFLAG .EQ. 4) GO TO 80
      IF (IFLAG .EQ. 5 .AND. ABSERR .GT. 0.D0) GO TO 90

C   INTEGRATION CANNOT BE CONTINUED SINCE USER DID NOT RESPOND TO
C   THE INSTRUCTIONS PERTAINING TO IFLAG=5,6,7, OR 8

   70 STOP

C   RESET FUNCTION EVALUATION COUNTER

   80 NFE = 0
      IF (MFLAG .EQ. 2) GO TO 100

C   RESET FLAG VALUE FROM PREVIOUS CALL

   90 IFLAG = JFLAG
      IF (KFLAG .EQ. 3) MFLAG = ABS(IFLAG)

C   SAVE INPUT IFLAG AND SET CONTINUATION FLAG FOR SUBSEQUENT
C   INPUT CHECKING

  100 JFLAG = IFLAG
      KFLAG = 0

C   SAVE RELERR AND ABSERR FOR CHECKING INPUT ON SUBSEQUENT CALLS

      SAVRE = RELERR
      SAVAE = ABSERR

C   RESTRICT RELATIVE ERROR TOLERANCE TO BE AT LEAST AS LARGE AS
C   2U+REMIN TO AVOID LIMITING PRECISION DIFFICULTIES ARRISING FROM
C   IMPOSSIBLE ACCURACY REQUESTS

      RE = 2.D0*U + REMIN
      IF (RELERR .GE. RE) GO TO 110

C   RELATIVE ERROR TOLERANCE TOO SMALL

      RELERR = RE
      IFLAG = 3
      KFLAG = 3
      GO TO 290
  110 U26 = 26.D0*U
      ALF = -0.1D0*LOG10(RELERR)
      DT = TOUT - T
      IF (MFLAG .EQ. 1) GO TO 120
      IF (INIT .EQ. 0) GO TO 130
      GO TO 140

C-----------------------------------------------------------------------
C   INITIALIZATION --
C-----------------------------------------------------------------------

C     SET INITIALIZATION COMPLETION INDICATOR, INIT
C     SET INDICATOR FOR TOO MANY OUTPUT POINTS, KOP
C     EVALUATE INITIAL DERIVATIVES
C     SET COUNTER FOR FUNCTION EVALUATIONS, NFE
C     ESTIMATE STARTING STEPSIZE

  120 INIT = 0
      KOP = 0
      FIRST = .TRUE.
      A = T
      CALL F(A,Y,YP,W,IW)
      NFE = 1
      IF (T .NE. TOUT) GO TO 130
      IFLAG = 2
      GO TO 290
  130 INIT = 1
      TOLN = 0.5D+00*(RELERR + ABSERR)
C     H = HSTART(F, N, A, TOUT, Y, YP, TOLN, 5, F2, F3, F4, F5, W, IW)
C     NFE = NFE + 4
      H = ABS(DT)
      TOLN = 0.0D+00
      DO 135 K=1,N
      TOL = RELERR*ABS(Y(K)) + ABSERR
      IF (TOL .LE. 0.0D+00) GOTO 135
      TOLN = TOL
      YPK = ABS(YP(K))
      IF (YPK*H**5 .GT. TOL) H = (TOL/YPK)**0.2D+00
  135 CONTINUE
      IF (TOLN .LE. 0.0D+00) H = 0.0D+00
      A = MAX(ABS(T),ABS(DT))
      H = MAX(H,U26*A)
      JFLAG = SIGN(2,IFLAG)

C-----------------------------------------------------------------------
C   SET STEP SIZE FOR INTEGRATION IN THE DIRECTION FROM T TO TOUT
C-----------------------------------------------------------------------

  140 H = SIGN(H,DT)

C   TEST TO SEE IF RK54 IS BEING SEVERELY IMPACTED BY TOO MANY
C   OUTPUT POINTS

      IF (ABS(H) .GE. 2.D0*ABS(DT)) KOP = KOP + 1
      IF (KOP .NE. 100)  GO TO 150

C   UNNECESSARY FREQUENCY OF OUTPUT

      KOP = 0
      IFLAG = 7
      GO TO 290
  150 IF (ABS(DT) .GT. U26*ABS(T)) GO TO 170

C   IF TOO CLOSE TO OUTPUT POINT, EXTRAPOLATE AND RETURN

      DO 160 K = 1,N
  160 Y(K) = Y(K) + DT*YP(K)
      A = TOUT
      CALL F(A,Y,YP,W,IW)
      T = TOUT
      NFE = NFE + 1
      GO TO 290

C   INITIALIZE OUTPUT INDICATOR

  170 OUTPUT = .FALSE.

C   TO AVOID PREMATURE UNDERFLOW IN THE TOLERANCE FUNCTION,
C   SCALE THE ERROR TOLERANCES

      SCALE = 2.D0/RELERR
      AE = SCALE*ABSERR

C-----------------------------------------------------------------------
C   STEP BY STEP INTEGRATION
C-----------------------------------------------------------------------

  180 HFAILD = .FALSE.

C   SET SMALLEST ALLOWABLE STEPSIZE
C     THIS STRATEGY IS THEORETICAL JUSTIFIED FOR
C     RKF45 (SEE SHAMPINE & WATTS); IT IS HEURISTICALLY
C     USEFUL FOR RK54, TOO.

      HMIN = U26*ABS(T)

C   ADJUST STEPSIZE IF NECESSARY TO HIT THE OUTPUT POINT.
C   LOOK AHEAD TWO STEPS TO AVOID DRASTIC CHANGES IN THE STEPSIZE
C   AND THUS LESSEN THE IMPACT OF OUTPUT POINTS ON THE CODE.

      DT = TOUT - T
      IF (ABS(DT) .GE. 2.D0*ABS(H)) GO TO 200
      IF (ABS(DT) .GT. ABS(H)/0.9D0) GO TO 190

C   THE NEXT SUCCESSFUL STEP WILL COMPLETE THE INTEGRATION
C   TO THE OUTPUT POINT

      OUTPUT = .TRUE.
      H = DT
      GO TO 200

  190 H = 0.5D0*DT

C-----------------------------------------------------------------------
C   CORE INTEGRATOR FOR TAKING A SINGLE STEP
C-----------------------------------------------------------------------

C   THE TOLERANCES HAVE BEEN SCALED TO AVOID PREMATURE UNDERFLOW IN
C   COMPUTING THE ERROR TOLERANCE FUNCTION ET.
C   TO AVOID PROBLEMS WITH ZERO CROSSINGS, RELATIVE ERROR IS MEASURED
C   USING THE AVERAGE OF THE MAGNITUDES OF THE SOLUTION AT THE
C   BEGINNING AND END OF A STEP.
C   TO DISTINGUISH THE VARIOUS ARGUMENTS, H IS NOT PERMITTED
C   TO BECOME SMALLER THAN 26 UNITS OF ROUND-OFF IN T.
C   PRACTICAL LIMITS ON THE CHANGE IN THE STEP SIZE ARE ENFORCED TO
C   SMOOTH THE STEP SIZE SELECTION PROCESS AND TO AVOID EXCESSIVE
C   CHATTERING ON PROBLEMS HAVING DISCONTINUITIES.
C   TO PREVENT UNNECESSARY FAILURES, THE CODE USES 9/10 THE STEP SIZE
C   IT ESTIMATES WILL SUCCEED.
C   AFTER A STEPFAILURE, THE STEPSIZE IS NOT ALLOWED TO INCREASE FOR
C   THE NEXT ATTEMPTED STEP. THIS MAKES THE CODE MORE EFFICIENT ON
C   PROBLEMS HAVING DISCONTINUITIES AND MORE EFFECTIVE IN GENERAL
C   SINCE LOCAL EXTRAPOLATION IS BEING USED AND EXTRA CAUTION SEEMS
C   WARRANTED.
C-----------------------------------------------------------------------

C   TEST NUMBER OF DERIVATIVE FUNCTION EVALUATIONS
C   IF OKAY, TRY TO ADVANCE THE INTEGRATION FROM T TO T + H

  200 IF (NFE .LE. MAXNFE)  GO TO 210

C   TOO MUCH WORK

      IFLAG = 4
      KFLAG = 4
      GO TO 290

C   ADVANCE AN APPROXIMATE SOLUTION OVER ONE STEP OF LENGTH H

  210 CALL PD54 (F,N,Y,T,H,YP,F1,F2,F3,F4,F5,F6,F7,F1,W,IW)
      NFE = NFE + 5

C   COMPUTE AND TEST ALLOWABLE TOLERANCES VERSUS LOCAL ERROR
C   ESTIMATES AND REMOVE SCALING OF TOLERANCES. NOTE THAT RELATIVE
C   ERROR IS MEASURED WITH RESPECT TO THE AVERAGE OF THE MAGNITUDES
C   OF THE SOLUTION AT THE BEGINNING AND END OF THE STEP.

      EEOET = 0.D0
      DO 230 K = 1,N
      ET = ABS(Y(K)) + ABS(F1(K)) + AE
      IF (ET .GT. 0.D0) GO TO 220

C   INAPPROPRIATE ERROR TOLERANCE

      IFLAG = 5
      KFLAG = 5
      GO TO 290
  220 EE = ABS(F7(K))
  230 EEOET = MAX(EEOET,EE/ET)
      ESTTOL = ABS(H)*EEOET*SCALE
      IF (ESTTOL .LE. 1.D0) GO TO 240

C   UNSUCESSFUL STEP
C     REDUCE THE STEP SIZE, TRY AGAIN
C     THE DECREASE IS LIMITED TO A FACTOR OF 1/10

      HFAILD = .TRUE.
      OUTPUT = .FALSE.
      S = 0.1D0
      IF (ESTTOL .LT. 5.9049D+04) S = 0.9D0/ESTTOL**0.2D+00
      H = S*H
      IF (ABS(H) .GT. HMIN) GO TO 200

C   REQUESTED ERROR UNATTAINABLE AT SMALLEST ALLOWABLE STEP SIZE

      IFLAG = 6
      KFLAG = 6
      GO TO 290

C   SUCCESSFUL STEP
C     STORE SOLUTION AT T + H
C     AND EVALUATE DERIVATIVES THERE

  240 T = T + H
      DO 250 K = 1,N
  250 Y(K) = F1(K)
      A = T
      CALL F(A,Y,YP,W,IW)
      NFE = NFE + 1

C   CHOOSE NEXT STEP SIZE
C     THE INCREASE IS LIMITED TO A FACTOR OF 10
C     IF STEP FAILURE HAS JUST OCCURRED, NEXT
C     STEP SIZE IS NOT ALLOWED TO INCREASE

      FIRST = .TRUE.
      IF (.NOT. FIRST) GO TO 260
      FIRST = .FALSE.
      S = 1000D0
      IF (ESTTOL .GT. 1.889568D-04) S = 0.9D0/ESTTOL**0.2D+00
      GO TO 270
C   MODIFIED STEP-SIZE CONTROL DUE TO WATTS
  260 ESTTOL = MAX(ESTTOL, 1.889568D-04)
      S = (ALF/ESTTOL*ESTOLD/ESTTOL)**0.2D+00*H/HOLD
      S = MIN(S,10.0D0)
  270 IF (HFAILD) S = MIN(S,1.D0)
      HOLD = H
      ESTOLD = ESTTOL
      H = SIGN(MAX(S*ABS(H),HMIN),H)

C-----------------------------------------------------------------------
C   END OF CORE INTEGRATOR
C-----------------------------------------------------------------------

C   SHOULD WE TAKE ANOTHER STEP ?

      IF (OUTPUT) GO TO 280
      IF (IFLAG .GT. 0) GO TO 180

C-----------------------------------------------------------------------
C   INTEGRATION SUCCESSFULLY COMPLETED
C-----------------------------------------------------------------------

C   ONE-STEP MODE

      IFLAG = -2
      GO TO 290

C   INTERVAL MODE

  280 T = TOUT
      IFLAG = 2

  290 RETURN

C   END OF RKC54

      END


      SUBROUTINE PD54(F, N, Y, T, H, F1, F2, F3, F4, F5, F6, F7,
     .                E, S, W, IW)

C   PRINCE - DORMAND  FIFTH-(FOURTH)-ORDER RUNGE-KUTTA FORMULAE

C-----------------------------------------------------------------------
C   CORE INTEGRATES A SYSTEM OF N FIRST ORDER
C   ORDINARY DIFFERENTIAL EQUATIONS OF THE FORM
C              DY(I)/DT = F(T,Y(1),---,Y(N))
C   WHERE THE INITIAL VALUES Y(I) AND THE INITIAL DERIVATIVES
C   F1(I) ARE SPECIFIED AT THE STARTING POINT T. CORE ADVANCES
C   THE SOLUTION OVER THE FIXED STEP H AND RETURNS
C   THE FITH ORDER (SIXTH ORDER ACCURATE LOCALLY) SOLUTION
C   APPROXIMATION AT T+H IN ARRAY S(I)
C-----------------------------------------------------------------------

C-----------------------------------------------------------------------

C   REFERENCE:

C   P.J. PRINCE, J.R. DORMAND 'A FAMILY OF EMBEDED RUNGE-KUTTA FORMULAE'
C                J. COMP. APPL. MATH. 6 (1980) 19-26.

C-----------------------------------------------------------------------

      INTEGER IW(*)
      INTEGER I, N
      DOUBLE PRECISION T, H, Y(N), E(N), S(N), W(*),
     .                 F1(N), F2(N), F3(N), F4(N), F5(N), F6(N), F7(N),
     .                 T1, T2, T3, T4, T5, T6
      EXTERNAL F

C   RUNGE-KUTTA FORMULAE

      T1=  (           1.0D0
     .     /           5.0D0) * H
      DO 10 I=1,N
   10 E(I) = Y(I)+T1*F1(I)
      CALL F (T+(1.0D0/5.0D0)*H, E, F2, W, IW)
      T1 = (           3.0D0
     .     /          40.0D0) * H
      T2 = (           9.0D0
     .     /          40.0D0) * H
      DO 20 I=1,N
   20 E(I) = Y(I)+T1*F1(I)+T2*F2(I)
      CALL F (T+(3.0D0/10.0D0)*H, E, F3, W, IW)
      T1 = (          44.0D0
     .     /          45.0D0) * H
      T2 = (         -56.0D0
     .     /          15.0D0) * H
      T3 = (          32.0D0
     .     /           9.0D0) * H
      DO 30 I=1,N
   30 E(I) = Y(I)+T1*F1(I)+T2*F2(I)+T3*F3(I)
      CALL F (T+(4.0D0/5.0D0)*H, E, F4, W, IW)
      T1 = (       19372.0D0
     .     /        6561.0D0) * H
      T2 = (      -25360.0D0
     .     /        2187.0D0) * H
      T3 = (       64448.0D0
     .     /        6561.0D0) * H
      T4 = (        -212.0D0
     .     /         729.0D0) * H
      DO 40 I=1,N
   40 E(I) = Y(I)+T1*F1(I)+T2*F2(I)+T3*F3(I)+T4*F4(I)
      CALL F (T+(8.0D0/9.0D0)*H, E, F5, W, IW)
      T1 = (        9017.0D0
     .     /        3168.0D0) * H
      T2 = (        -355.0D0
     .     /          33.0D0) * H
      T3 = (       46732.0D0
     .     /        5247.0D0) * H
      T4 = (          49.0D0
     .     /         176.0D0) * H
      T5 = (       -5103.0D0
     .     /       18656.0D0) * H
      DO 50 I=1,N
   50 E(I) = Y(I)+T1*F1(I)+T2*F2(I)+T3*F3(I)+T4*F4(I)+T5*F5(I)
      CALL F (T+H, E, F6, W, IW)
      T1 = (          35.0D0
     .     /         384.0D0) * H
      T3 = (         500.0D0
     .     /        1113.0D0) * H
      T4 = (         125.0D0
     .     /         192.0D0) * H
      T5 = (       -2187.0D0
     .     /        6784.0D0) * H
      T6 = (          11.0D0
     .     /          84.0D0) * H
      DO 60 I=1,N
   60 E(I) = Y(I)+T1*F1(I)+T3*F3(I)+T4*F4(I)+T5*F5(I)+T6*F6(I)
      CALL F (T+H, E, F7, W, IW)

C   LOCALLY EXTRAPOLATED SOLUTION & ERROR

      DO 70 I=1,N
      S(I)=(          35.0D0
     .     /         384.0D0) * F1(I)
     .   + (         500.0D0
     .     /        1113.0D0) * F3(I)
     .   + (         125.0D0
     .     /         192.0D0) * F4(I)
     .   + (       -2187.0D0
     .     /        6784.0D0) * F5(I)
     .   + (          11.0D0
     .     /          84.0D0) * F6(I)
      E(I)=S(I)-
     .    ((        5179.0D0
     .     /       57600.0D0) * F1(I)
     .   + (        7571.0D0
     .     /       16695.0D0) * F3(I)
     .   + (         393.0D0
     .     /         640.0D0) * F4(I)
     .   + (      -92097.0D0
     .     /      339200.0D0) * F5(I)
     .   + (         187.0D0
     .     /        2100.0D0) * F6(I)
     .   + (           1.0D0
     .     /          40.0D0) * F7(I))
   70 S(I) = Y(I)+H*S(I)
      RETURN
      END


      SUBROUTINE RK87 (F,N,Y,T,TOUT,RELERR,ABSERR,IFLAG,WORK,IWORK,W,IW)
C   RK87   INITIAL VALUE SOLVER BASED ON HIGH ORDER RUNGE-KUTTA FORMULAE

C   ADAPTATION OF THE IMPLEMENTATION OF
C   FEHLBERG'S FOURTH-FIFTH ORDER RUNGE-KUTTA METHOD
C   WRITTEN BY
C                 L.F.SHAMPINE & H.A.WATTS
C                   SANDIA LABORATORIES
C                 ALBUQUERQUE, NEW MEXICO

C   TO THE MORE ACCURATE PRINCE/DORMAND SEVENTH-EIGHTH ORDER FORMULAE
C   BY
C                        D.KRAFT
C          INSTITUT FUER DYNAMIK DER FLUGSYSTEME
C                  DLR OBERPFAFFENHOFEN

C   STATUS: 20. OCTOBER 1984

C   RK87 IS PRIMARILY DESIGNED TO SOLVE NON-STIFF AND MILDLY STIFF
C   DIFFERENTIAL EQUATIONS WITH MEDIUM TO HIGH ACCURACY & LOW OUTPUT

C-----------------------------------------------------------------------
C   ABSTRACT
C-----------------------------------------------------------------------

C   SUBROUTINE RK87 INTEGRATES A SYSTEM OF N FIRST ORDER
C   ORDINARY DIFFERENTIAL EQUATIONS OF THE FORM
C              DY(I)/DT = F(T,Y(1),Y(2),...,Y(N))
C              WHERE THE Y(I) ARE GIVEN AT T .
C   TYPICALLY THE SUBROUTINE IS USED TO INTEGRATE FROM T TO TOUT BUT
C   IT CAN BE USED AS A ONE-STEP INTEGRATOR TO ADVANCE THE SOLUTION A
C   SINGLE STEP IN THE DIRECTION OF TOUT. ON RETURN THE PARAMETERS IN
C   THE CALL LIST ARE SET FOR CONTINUING THE INTEGRATION. THE USER HAS
C   ONLY TO CALL RK87 AGAIN (AND PERHAPS DEFINE A NEW VALUE FOR TOUT).
C   ACTUALLY, RK87 IS AN INTERFACING ROUTINE WHICH CALLS SUBROUTINE
C   RKC87 FOR THE SOLUTION. RKC87 IN TURN CALLS SUBROUTINE CORE WHICH
C   COMPUTES AN APPROXIMATE SOLUTION OVER ONE STEP.

C   RKF45 USES THE RUNGE-KUTTA-FEHLBERG (4,5) METHOD DESCRIBED IN
C   THE REFERENCES
C   E. FEHLBERG, LOW-ORDER CLASSICAL RUNGE-KUTTA FORMULAS WITH STEPSIZE
C                  CONTROL, NASA TR R-315.
C                  ALSO IN COMPUTING 6 (1970) 61-71.

C   L.F. SHAMPINE AND H.A. WATTS, PRACTICAL SOLUTION OF ORDINARY
C                  DIFFERENTIAL EQUATIONS BY RUNGE-KUTTA METHODS.
C                  SANDIA LABORATORIES REPORT SAND76-0585.

C   L.F. SHAMPINE AND H.A. WATTS, THE ART OF WRITING A RUNGE-KUTTA CODE
C                  APPL. MATH. COMP. 5 (1979) 93-121.

C   THE PERFORMANCE OF RKF45 IS ILLUSTRATED IN THE REFERENCE
C   L.F. SHAMPINE, H.A. WATTS, S. DAVENPORT, SOLVING NON-STIFF ORDINARY
C                  DIFFERENTIAL EQUATIONS-THE STATE OF THE ART.
C                  SANDIA LABORATORIES REPORT SAND78-0182 .  ALSO IN
C                  SIAM REVIEW 18 (1976) 376-411.

C   RK87  USES THE RUNGE-KUTTA (8,7) METHOD DESCRIBED IN
C   P.J. PRINCE, J.R. DORMAND 'HIGH ORDER EMBEDDED RUNGE-KUTTA FORMULAE'
C                J. COMP. APPL. MATH. 7 (1981) 67-75.

C   THE PARAMETERS REPRESENT
C   F -- SUBROUTINE F(T,Y,YP) TO EVALUATE DERIVATIVES YP(I)=DY(I)/DT
C   N -- NUMBER OF EQUATIONS TO BE INTEGRATED
C   Y( ) -- SOLUTION VECTOR AT T
C   T -- INDEPENDENT VARIABLE
C   TOUT -- OUTPUT POINT AT WHICH SOLUTION IS DESIRED
C   RELERR,ABSERR -- RELATIVE AND ABSOULTE ERROR TOLERANCES FOR LOCAL
C           ERROR TEST. AT EACH STEP THE CODE REQUIRES THAT
C           ABS(LOCAL ERROR) .LE. RELERR*ABS(Y) + ABSERR
C           FOR EACH COMPONENT OF THE LOCAL ERROR AND SOLUTION VECTORS
C   IFLAG -- INDICATOR FOR STATUS OF INTEGRATION
C   WORK( ) -- ARRAY TO HOLD INFORMATION INTERNAL TO RK87 WHICH IS
C           NECESSARY FOR SUBSEQUENT CALLS.  MUST BE DIMENSIONED
C           AT LEAST 12*N + 3
C   IWORK( ) -- INTEGER ARRAY USED TO HOLD INFORMATION INTERNAL TO
C           RK87 WHICH IS NECESSARY FOR SUBSEQUENT CALLS.   MUST BE
C           DIMENSIONED AT LEAST 5

C----------------------------------------------------------------------
C   FIRST CALL TO RK87
C----------------------------------------------------------------------

C   THE USER MUST PROVIDE STORAGE IN HIS CALLING PROGRAM FOR THE ARRAY
C   IN THE CALL LIST  -  Y(N), WORK(3+12*N), IWORK(5),
C   DECLARE F IN AN EXTERNAL STATEMENT, SUPPLY SUBROUTINE F(T,Y,YP)
C   AND INITIALIZE THE FOLLOWING PARAMETERS
C   N -- NUMBER OF EQUATIONS TO BE INTEGRATED.       (N .GE. 1)
C   Y( ) -- VECTOR OF INITIAL CONDITIONS
C   T -- STARTING POINT OF INTEGRATION, MUST BE A VARIABLE
C        T=TOUT IS ALLOWED ON THE FIRST CALL ONLY, IN WHICH CASE
C        RK87 RETURNS WITH IFLAG=2 IF CONTINUATION IS POSSIBLE.
C   RELERR,ABSERR -- RELATIVE AND ABSOLUTE LOCAL ERROR TOLERANCES
C        WHICH MUST BE NON-NEGATIVE.  RELERR MUST BE A VARIABLE WHILE
C        ABSERR MAY BE A CONSTANT.  THE CODE SHOULD NORMALLY NOT BE
C        USED WITH RELATIVE ERROR CONTROL SMALLER THAN ABOUT 1.D-11.
C        TO AVOID LIMITING PRECISION DIFFICULTIES THE CODE REQUIRES
C        RELERR TO BE LARGER THAN AN INTERNALLY COMPUTED RELATIVE
C        ERROR PARAMETER WHICH IS MACHINE DEPENDENT.  IN PARTICULAR,
C        PURE ABSOLUTE ERROR IS NOT PERMITTED.  IF A SMALLER THAN
C        ALLOWABLE VALUE OF RELERR IS ATTEMPTED, RK87 INCREASES
C        RELERR APPROPRIATELY AND RETURNS CONTROL TO THE USER BEFORE
C        CONTINUING THE INTEGRATION.
C   IFLAG -- +1,-1 INDICATOR TO INITIALIZE THE CODE FOR EACH NEW
C        PROBLEM.  NORMAL INPUT IS +1.  THE USER SHOULD SET IFLAG=-1
C        ONLY WHEN ONE-STEP INTEGRATOR CONTROL IS ESSENTIAL.  IN THIS
C        CASE, RK87 ATTEMPTS TO ADVANCE THE SOLUTION A SINGLE STEP
C        IN THE DIRECTION OF TOUT EACH TIME IT IS CALLED.  SINCE THIS
C        MODE OF OPERATION RESULTS IN EXTRA COMPUTING OVERHEAD, IT
C        SHOULD BE AVOIDED UNLESS NEEDED.

C-----------------------------------------------------------------------
C   OUTPUT FROM RK87
C-----------------------------------------------------------------------

C   Y( ) -- SOLUTION AT T
C   T -- LAST POINT REACHED IN INTEGRATION.
C   IFLAG   = 2 -- INTEGRATION REACHED TOUT. INDICATES SUCCESSFUL RETURN
C                  AND IS THE NORMAL MODE FOR CONTINUING INTEGRATION.
C           =-2 -- A SINGLE SUCCESSFUL STEP IN THE DIRECTION OF TOUT
C                  HAS BEEN TAKEN.  NORMAL MODE FOR CONTINUING
C                  INTEGRATION ONE STEP AT A TIME.
C           = 3 -- INTEGRATION WAS NOT COMPLETED BECAUSE RELATIVE ERROR
C                  TOLERANCE WAS TOO SMALL. RELERR HAS BEEN INCREASED
C                  APPROPRIATELY FOR CONTINUING.
C           = 4 -- INTEGRATION WAS NOT COMPLETED BECAUSE MORE THAN
C                  6500 DERIVATIVE EVALUATIONS WERE NEEDED.  THIS
C                  IS APPROXIMATELY 500 STEPS
C           = 5 -- INTEGRATION WAS NOT COMPLETED BECAUSE SOLUTION
C                  VANISHED MAKING A PURE RELATIVE ERROR TEST
C                  IMPOSSIBLE.  MUST USE NON-ZERO ABSERR TO CONTINUE.
C                  USING THE ONE-STEP INTEGRATION MODE FOR STEP
C                  IS A GOOD WAY TO PROCEED.
C           = 6 -- INTEGRATION WAS NOT COMPLETED BECAUSE REQUESTED
C                  ACCURACY COULD NOT BE ACHIEVED USING SMALLEST
C                  ALLOWABLE STEPSIZE. USER MUST INCREASE THE ERROR
C                  TOLERANCE BEFORE CONTINUED INTEGRATION CAN BE
C                  ATTEMPTED.
C           = 7 -- IT IS LIKELY THAT RK87 IS INEFFICIENT FOR SOLVING
C                  THIS PROBLEM.  TOO MUCH OUTPUT IS RESTRICTING THE
C                  NATURAL STEPSIZE CHOICE. USE THE ONE-STEP INTEGRATOR
C                  MODE.
C           = 8 -- INVALID INPUT PARAMETERS
C                  THIS INDICATOR OCCURS IF ANY OF THE FOLLOWING IS
C                  SATISFIED - N .LE. 0
C                              T=TOUT AND IFLAG .NE. +1 OR -1
C                              RELERR OR ABSERR .LT. 0.
C                              IFLAG .EQ. 0 OR .LT. -2 OR .GT.8
C   WORK( ),IWORK( ) -- INFORMATION WHICH IS USUALLY OF NO INTEREST
C                  TO THE USER BUT NECESSARY FOR SUBSEQUENT CALLS
C                  WORK(1),...,WORK(N) CONTAINS THE FIRST DERIVATIVES
C                  OF THE SOLUTION VECTOR Y AT T. WORK(N+1) CONTAINS
C                  THE STEP SIZE H TO BE ATTEMPTED ON THE NEXT STEP.
C                  IWORK(1) CONTAINS THE DERIVATIVE EVALUATION COUNTER.

C-----------------------------------------------------------------------
C   SUBSEQUENT CALLS TO RK87
C-----------------------------------------------------------------------

C   SUBROUTINE RK87 RETURNS WITH ALL INFORMATION NEEDED TO CONTINUE
C   THE INTEGRATION. IF THE INTEGRATION REACHED TOUT, THE USER NEED ONLY
C   DEFINE A NEW TOUT AND CALL RK87 AGAIN. IN THE ONE-STEP INTEGRATOR
C   MODE (IFLAG=-2) THE USER MUST KEEP IN MIND THAT EACH STEP TAKEN IS
C   IN THE DIRECTION OF THE CURRENT TOUT. UPON REACHING TOUT (INDICATED
C   BY CHANGING IFLAG TO 2), THE USER MUST THEN DEFINE A NEW TOUT AND
C   RESET IFLAG TO -2 TO CONTINUE IN THE ONE STEP INTEGRATOR MODE.

C   IF THE INTEGRATION WAS NOT COMPLETED BUT THE USER STILL WANTS TO
C   CONTINUE (IFLAG=3,4 CASES), HE JUST CALLS RK87 AGAIN. WITH IFLAG=3
C   THE RELERR PARAMETER HAS BEEN ADJUSTED APPROPTIATELY FOR CONTINUING
C   THE INTEGRATION.   IN THE CASE OF IFLAG=4 THE FUNCTION COUNTER WILL
C   BE RESET TO 0 AND ANOTHER 6000 FUNCTION EVALUATIONS ARE ALLOWED.

C   HOWEVER, IN THE CASE IFLAG=5, THE USER MUST FIRST ALTER THE ERROR
C   CRITERION TO USE A POSITIVE VALUE OF ABSERR BEFORE INTEGRATION CAN
C   PROCEED.    IF HE DOES NOT, EXECUTION IS TERMINATED.

C   ALSO, IN THE CASE IFLAG=6, IT IS NECESSARY FOR THE USER TO RESET
C   IFLAG TO 2 (OR -2 WHEN THE ONE-STEP INTEGRATION MODE IS BEING USED)
C   AS WELL AS INCREASING EITHER ABSERR, RELERR OR BOTH BEFORE THE
C   INTEGRATION CAN BE CONTINUED.  IF THIS IS NOT DONE, EXECUTION WILL
C   BE TERMINATED.  THE OCCURRENCE OF IFLAG=6 INDICATES A TROUBLE SPOT
C   (SOLUTION IS CHANGING RAPIDLY, SINGULARITY MAY BE PRESENT) AND IT
C   OFTEN IS INADVISABLE TO CONTINUE.

C   IF IFLAG=7 IS ENCOUNTERED, THE USER SHOULD USE THE ONE-STEP
C   INTEGRATION MODE WITH THE STEPSIZE DETERMINED BY THE CODE OR
C   CONSIDER SWITCHING TO THE ADAMS CODES DE,STEP,INTRP.  IF THE USER
C   INSISTS UPON CONTINUING THE INTEGRATION WITH RK87, HE MUST RESET
C   IFLAG TO 2 BEFORE CALLING RK87 AGAIN.   OTHERWISE, EXECUTION WILL
C   BE TERMINATED.

C   IF IFLAG=8 IS OBTAINED, INTEGRATION CANNOT BE CONTINUED UNLESS
C   THE INVALID INPUT PARAMETERS ARE CORRECTED.

C   IT SHOULD BE NOTED THAT THE ARRAYS WORK,IWORK CONTAIN INFORMATION
C   REQUIRED FOR SUBSEQUENT INTEGRATION.  ACCORDINGLY, WORK AND IWORK
C   SHOULD NOT BE ALTERED.

C-----------------------------------------------------------------------

      INTEGER IWORK(5), IW(*)
      INTEGER IFLAG, K1, K2, K3, K4, K5, K6, K7, K8,
     1        K9, K10, K11, K12, K1M, N
      DOUBLE PRECISION Y(N), WORK(*), W(*), T, TOUT, ABSERR, RELERR
      EXTERNAL F

C   COMPUTE INDICES FOR THE SPLITTING OF THE WORK ARRAY

      K1M = N + 1
      K1 = K1M + 1
      K2 = K1 + N
      K3 = K2 + N
      K4 = K3 + N
      K5 = K4 + N
      K6 = K5 + N
      K7 = K6 + N
      K8 = K7 + N
      K9 = K8 + N
      K10 = K9 + N
      K11 = K10 + N
      K12 = K11 + N

C-----------------------------------------------------------------------
C   THIS INTERFACING ROUTINE MERELY RELIEVES THE USER OF A LONG
C   CALLING LIST VIA THE SPLITTING APART OF TWO WORKING STORAGE
C   ARRAYS.   IF THIS IS NOT COMPATIBLE WITH THE USERS COMPILER,
C   HE MUST USE RKC87 DIRECTLY.
C-----------------------------------------------------------------------

      CALL RKC87(F,N,Y,T,TOUT,RELERR,ABSERR,IFLAG,WORK(1),WORK(K1M),
     1  WORK(K1),WORK(K2),WORK(K3),WORK(K4),WORK(K5),WORK(K6),
     2  WORK(K7),WORK(K8),WORK(K9),WORK(K10),WORK(K11),WORK(K12),
     3  WORK(K12+1),IWORK(1),IWORK(2),IWORK(3),IWORK(4),IWORK(5),W,IW)
      RETURN
      END


      SUBROUTINE RKC87(F,N,Y,T,TOUT,RELERR,ABSERR,IFLAG,YP,H,F1,F2,F3,F4
     1,F5,F6,F7,F8,F9,F10,F11,SAVRE,SAVAE,NFE,KOP,INIT,JFLAG,KFLAG,W,IW)

C   PRINCE/DORMAND 8(7) ORDER RUNGE-KUTTA METHOD

C   RKC87 INTEGRATES A SYSTEM OF FIRST ORDER ORDINARY DIFFERENTIAL
C   EQUATIONS AS DESCRIBED IN THE COMMENTS FOR RK87 .
C   THE ARRAYS YP,F1,....,F10 AND F11 (OF DIMENSION AT LEAST N) AND
C   THE VARIABLES H,SAVRE,SAVAE,NFE,KOP,INIT,JFLAG,AND KFLAG ARE USED
C   INTERNALLY BY THE CODE AND APPEAR IN THE CALL LIST TO ELIMINATE
C   LOCAL RETENTION OF VARIABLES BETWEEN CALLS.    ACCORDINGLY, THEY
C   SHOULD NOT BE ALTERED.    ITEMS OF POSSIBLE INTEREST ARE :
C       YP - DERIVATIVE OF SOLUTION VECTOR AT T
C       H  - AN APPROPRIATE STEP SIZE TO BE USED FOR THE NEXT STEP
C       NFE- COUNTER ON THE NUMBER OF DERIVATIVE FUNCTION EVALUATIONS

C-----------------------------------------------------------------------

      INTEGER          IW(*)
      INTEGER          IFLAG, INIT, JFLAG, K, KFLAG, KOP,
     1                 MAXNFE, MFLAG, N, NFE
      DOUBLE PRECISION Y(N),YP(N),F1(N),F2(N),F3(N),F4(N),F5(N),F6(N),
     1                 F7(N),F8(N),F9(N),F10(N),F11(N),A,ABSERR,AE,ALF,
     2                 DT,EE,EEOET,ESTOLD,ESTTOL,ET,H,HMIN,HOLD,
     3                 RELERR,REMIN,RE,S,SAVAE,SAVRE,SCALE,T,TOUT,U,U26,
     4                 TOL,TOLN,YPK,W(*)
      LOGICAL          FIRST,HFAILD,OUTPUT
      EXTERNAL         F

C-----------------------------------------------------------------------
C   THE COMPUTER UNIT ROUND OFF ERROR U IS THE SMALLEST POSITIVE VALUE
C   REPRESENTABLE IN THE MACHINE SUCH THAT 1.+U .GT. 1.
C                     VALUES TO BE USED ARE
C                 U = 9.5D-7          FOR IBM 360/370
C                 U = 1.5D-8          FOR UNIVAC 1108
C                 U = 7.5D-9          FOR PDP-10
C                 U = 7.1D-15         FOR CDC 6000 SERIES
C                 U = 2.2D-16         FOR IBM 360/370 DOUBLE PRECISION
C                 U = 2.2D-16         FOR IBM PS/2 Model 70 D. PRECISION
      DATA        U  /2.22D-16/

C-----------------------------------------------------------------------
C   REMIN IS A TOLERANCE THRESHOLD WHICH IS ALSO DETERMINED BY THE
C   INTEGRATION METHOD.
      DATA REMIN /1.D-14/
C-----------------------------------------------------------------------
      DATA MAXNFE /6500/

C   CHECK INPUT PARAMETERS

      IF (N .LT. 1) GO TO 10
      IF (RELERR .LT. 0.D0 .OR. ABSERR .LT. 0.D0) GO TO 10
      MFLAG = ABS(IFLAG)
      IF (MFLAG .GE. 1 .AND. MFLAG .LE. 8) GO TO 50

C   INVALID INPUT

   10 IFLAG = 8
      GO TO 290

C   IS THIS THE FIRST CALL ?

   50 IF (MFLAG .EQ. 1) GO TO 100

C   CHECK CONTINUATION POSSIBILITIES

      IF (T .EQ. TOUT .AND. KFLAG .NE. 3) GO TO 10
      IF (MFLAG .NE. 2) GO TO 60

C   IFLAG = +2 OR -2

      IF (KFLAG .EQ. 3) GO TO 90
      IF (INIT .EQ. 0)  GO TO 90
      IF (KFLAG .EQ. 4) GO TO 80
      IF (KFLAG .EQ. 5 .AND. ABSERR .EQ. 0.D0) GO TO 70
      IF (KFLAG .EQ. 6 .AND. RELERR .LE. SAVRE .AND. ABSERR .LE. SAVAE)
     1GO TO 70
      GO TO 100

C   IFLAG = 3,4,5,6,7, OR 8

   60 IF (IFLAG .EQ. 3) GO TO 90
      IF (IFLAG .EQ. 4) GO TO 80
      IF (IFLAG .EQ. 5 .AND. ABSERR .GT. 0.D0) GO TO 90

C   INTEGRATION CANNOT BE CONTINUED SINCE USER DID NOT RESPOND TO
C   THE INSTRUCTIONS PERTAINING TO IFLAG=5,6,7, OR 8

   70 STOP

C   RESET FUNCTION EVALUATION COUNTER

   80 NFE = 0
      IF (MFLAG .EQ. 2) GO TO 100

C   RESET FLAG VALUE FROM PREVIOUS CALL

   90 IFLAG = JFLAG
      IF (KFLAG .EQ. 3) MFLAG = ABS(IFLAG)

C   SAVE INPUT IFLAG AND SET CONTINUATION FLAG FOR SUBSEQUENT
C   INPUT CHECKING

  100 JFLAG = IFLAG
      KFLAG = 0

C   SAVE RELERR AND ABSERR FOR CHECKING INPUT ON SUBSEQUENT CALLS

      SAVRE = RELERR
      SAVAE = ABSERR

C   RESTRICT RELATIVE ERROR TOLERANCE TO BE AT LEAST AS LARGE AS
C   2U+REMIN TO AVOID LIMITING PRECISION DIFFICULTIES ARRISING FROM
C   IMPOSSIBLE ACCURACY REQUESTS

      RE = 2.D0*U + REMIN
      IF (RELERR .GE. RE) GO TO 110

C   RELATIVE ERROR TOLERANCE TOO SMALL

      RELERR = RE
      IFLAG = 3
      KFLAG = 3
      GO TO 290
  110 U26 = 26.D0*U
      ALF = -0.1D0*LOG10(RELERR)
      DT = TOUT - T
      IF (MFLAG .EQ. 1) GO TO 120
      IF (INIT .EQ. 0) GO TO 130
      GO TO 140

C-----------------------------------------------------------------------
C   INITIALIZATION --
C-----------------------------------------------------------------------

C     SET INITIALIZATION COMPLETION INDICATOR, INIT
C     SET INDICATOR FOR TOO MANY OUTPUT POINTS, KOP
C     EVALUATE INITIAL DERIVATIVES
C     SET COUNTER FOR FUNCTION EVALUATIONS, NFE
C     ESTIMATE STARTING STEPSIZE

  120 INIT = 0
      KOP = 0
      FIRST = .TRUE.
      A = T
      CALL F(A,Y,YP,W,IW)
      NFE = 1
      IF (T .NE. TOUT) GO TO 130
      IFLAG = 2
      GO TO 290
  130 INIT = 1
      TOLN = 0.5D+00*(RELERR + ABSERR)
C     H = HSTART(F, N, A, TOUT, Y, YP, TOLN, 8, F2, F3, F4, F5, W, IW)
      H = ABS(DT)
      TOLN = 0.0D+00
      DO 135 K=1,N
      TOL = RELERR*ABS(Y(K)) + ABSERR
      IF (TOL .LE. 0.0D+00) GOTO 135
      TOLN = TOL
      YPK = ABS(YP(K))
      IF (YPK*H**8 .GT. TOL) H = (TOL/YPK)**0.125D+00
  135 CONTINUE
      IF (TOLN .LE. 0.0D+00) H = 0.0D+00
      A = MAX(ABS(T),ABS(DT))
      H = MAX(H,U26*A)
C     NFE = NFE + 4
      JFLAG = SIGN(2,IFLAG)

C-----------------------------------------------------------------------
C   SET STEP SIZE FOR INTEGRATION IN THE DIRECTION FROM T TO TOUT
C-----------------------------------------------------------------------

  140 H = SIGN(H,DT)

C   TEST TO SEE IF RK87 IS BEING SEVERELY IMPACTED BY TOO MANY
C   OUTPUT POINTS

      IF (ABS(H) .GE. 2.D0*ABS(DT)) KOP = KOP + 1
      IF (KOP .NE. 100)  GO TO 150

C   UNNECESSARY FREQUENCY OF OUTPUT

      KOP = 0
      IFLAG = 7
      GO TO 290
  150 IF (ABS(DT) .GT. U26*ABS(T)) GO TO 170

C   IF TOO CLOSE TO OUTPUT POINT, EXTRAPOLATE AND RETURN

      DO 160 K = 1,N
  160 Y(K) = Y(K) + DT*YP(K)
      A = TOUT
      CALL F(A,Y,YP,W,IW)
      T = TOUT
      NFE = NFE + 1
      GO TO 290

C   INITIALIZE OUTPUT INDICATOR

  170 OUTPUT = .FALSE.

C   TO AVOID PREMATURE UNDERFLOW IN THE TOLERANCE FUNCTION,
C   SCALE THE ERROR TOLERANCES

      SCALE = 2.D0/RELERR
      AE = SCALE*ABSERR

C-----------------------------------------------------------------------
C   STEP BY STEP INTEGRATION
C-----------------------------------------------------------------------

  180 HFAILD = .FALSE.

C   SET SMALLEST ALLOWABLE STEPSIZE
C     THIS STRATEGY IS THEORETICAL JUSTIFIED FOR
C     RKF45 (SEE SHAMPINE & WATTS); IT IS HEURISTICALLY
C     USEFUL FOR RK87, TOO.

      HMIN = U26*ABS(T)

C   ADJUST STEPSIZE IF NECESSARY TO HIT THE OUTPUT POINT.
C   LOOK AHEAD TWO STEPS TO AVOID DRASTIC CHANGES IN THE STEPSIZE
C   AND THUS LESSEN THE IMPACT OF OUTPUT POINTS ON THE CODE.

      DT = TOUT - T
      IF (ABS(DT) .GE. 2.D0*ABS(H)) GO TO 200
      IF (ABS(DT) .GT. ABS(H)/0.9D0) GO TO 190

C   THE NEXT SUCCESSFUL STEP WILL COMPLETE THE INTEGRATION
C   TO THE OUTPUT POINT

      OUTPUT = .TRUE.
      H = DT
      GO TO 200

  190 H = 0.5D0*DT

C-----------------------------------------------------------------------
C   CORE INTEGRATOR FOR TAKING A SINGLE STEP
C-----------------------------------------------------------------------

C   THE TOLERANCES HAVE BEEN SCALED TO AVOID PREMATURE UNDERFLOW IN
C   COMPUTING THE ERROR TOLERANCE FUNCTION ET.
C   TO AVOID PROBLEMS WITH ZERO CROSSINGS, RELATIVE ERROR IS MEASURED
C   USING THE AVERAGE OF THE MAGNITUDES OF THE SOLUTION AT THE
C   BEGINNING AND END OF A STEP.
C   TO DISTINGUISH THE VARIOUS ARGUMENTS, H IS NOT PERMITTED
C   TO BECOME SMALLER THAN 26 UNITS OF ROUND-OFF IN T.
C   PRACTICAL LIMITS ON THE CHANGE IN THE STEP SIZE ARE ENFORCED TO
C   SMOOTH THE STEP SIZE SELECTION PROCESS AND TO AVOID EXCESSIVE
C   CHATTERING ON PROBLEMS HAVING DISCONTINUITIES.
C   TO PREVENT UNNECESSARY FAILURES, THE CODE USES 9/10 THE STEP SIZE
C   IT ESTIMATES WILL SUCCEED.
C   AFTER A STEPFAILURE, THE STEPSIZE IS NOT ALLOWED TO INCREASE FOR
C   THE NEXT ATTEMPTED STEP. THIS MAKES THE CODE MORE EFFICIENT ON
C   PROBLEMS HAVING DISCONTINUITIES AND MORE EFFECTIVE IN GENERAL
C   SINCE LOCAL EXTRAPOLATION IS BEING USED AND EXTRA CAUTION SEEMS
C   WARRANTED.
C-----------------------------------------------------------------------

C   TEST NUMBER OF DERIVATIVE FUNCTION EVALUATIONS
C   IF OKAY, TRY TO ADVANCE THE INTEGRATION FROM T TO T + H

  200 IF (NFE .LE. MAXNFE)  GO TO 210

C   TOO MUCH WORK

      IFLAG = 4
      KFLAG = 4
      GO TO 290

C   ADVANCE AN APPROXIMATE SOLUTION OVER ONE STEP OF LENGTH H

  210 CALL PD87(F,N,Y,T,H,YP,F1,F2,F3,F4,F5,F6,F7,F8,F9,F10,F11,F1,W,IW)
      NFE = NFE + 12

C   COMPUTE AND TEST ALLOWABLE TOLERANCES VERSUS LOCAL ERROR
C   ESTIMATES AND REMOVE SCALING OF TOLERANCES. NOTE THAT RELATIVE
C   ERROR IS MEASURED WITH RESPECT TO THE AVERAGE OF THE MAGNITUDES
C   OF THE SOLUTION AT THE BEGINNING AND END OF THE STEP.

      EEOET = 0.D0
      DO 230 K = 1,N
      ET = ABS(Y(K)) + ABS(F1(K)) + AE
      IF (ET .GT. 0.D0) GO TO 220

C   INAPPROPRIATE ERROR TOLERANCE

      IFLAG = 5
      KFLAG = 5
      GO TO 290
  220 EE = ABS(F11(K))
  230 EEOET = MAX(EEOET,EE/ET)
      ESTTOL = ABS(H)*EEOET*SCALE
      IF (ESTTOL .LE. 1.D0) GO TO 240

C   UNSUCESSFUL STEP
C     REDUCE THE STEP SIZE, TRY AGAIN
C     THE DECREASE IS LIMITED TO A FACTOR OF 1/10

      HFAILD = .TRUE.
      OUTPUT = .FALSE.
      S = 0.1D0
      IF (ESTTOL .LT. 4.3046721D+07) S = 0.9D0/ESTTOL**0.125D0
      H = S*H
      IF (ABS(H) .GT. HMIN) GO TO 200

C   REQUESTED ERROR UNATTAINABLE AT SMALLEST ALLOWABLE STEP SIZE

      IFLAG = 6
      KFLAG = 6
      GO TO 290

C   SUCCESSFUL STEP
C     STORE SOLUTION AT T + H
C     AND EVALUATE DERIVATIVES THERE

  240 T = T + H
      DO 250 K = 1,N
  250 Y(K) = F1(K)
      A = T
      CALL F(A,Y,YP,W,IW)
      NFE = NFE + 1

C   CHOOSE NEXT STEP SIZE
C     THE INCREASE IS LIMITED TO A FACTOR OF 10
C     IF STEP FAILURE HAS JUST OCCURRED, NEXT
C     STEP SIZE IS NOT ALLOWED TO INCREASE

      FIRST = .TRUE.
      IF (.NOT. FIRST) GO TO 260
      FIRST = .FALSE.
      S = 10.0D0
      IF (ESTTOL .GT. 4.3046721D-09) S = 0.9D0/ESTTOL**0.125D0
      GO TO 270
C   MODIFIED STEP-SIZE CONTROL DUE TO WATTS
  260 ESTTOL = MAX(ESTTOL, 4.3046721D-9)
      S = (ALF/ESTTOL*ESTOLD/ESTTOL)**0.125D0*H/HOLD
      S = MIN(S,10.0D0)
  270 IF (HFAILD) S = MIN(S,1.D0)
      HOLD = H
      ESTOLD = ESTTOL
      H = SIGN(MAX(S*ABS(H),HMIN),H)

C-----------------------------------------------------------------------
C   END OF CORE INTEGRATOR
C-----------------------------------------------------------------------

C   SHOULD WE TAKE ANOTHER STEP ?

      IF (OUTPUT) GO TO 280
      IF (IFLAG .GT. 0) GO TO 180

C-----------------------------------------------------------------------
C   INTEGRATION SUCCESSFULLY COMPLETED
C-----------------------------------------------------------------------

C   ONE-STEP MODE

      IFLAG = -2
      GO TO 290

C   INTERVAL MODE

  280 T = TOUT
      IFLAG = 2

  290 RETURN

C   END OF RKC87

      END


      SUBROUTINE PD87(F, N, Y, T, H, F1, F2, F3, F4, F5,
     .                F6, F7, F8, F9, F10, F11, E, S, W, IW)

C   PRINCE - DORMAND  SEVENTH-EIGHTH ORDER RUNGE-KUTTA FORMULAE

C-----------------------------------------------------------------------
C   CORE INTEGRATES A SYSTEM OF N FIRST ORDER
C   ORDINARY DIFFERENTIAL EQUATIONS OF THE FORM
C              DY(I)/DT = F(T,Y(1),---,Y(N))
C   WHERE THE INITIAL VALUES Y(I) AND THE INITIAL DERIVATIVES
C   F1(I) ARE SPECIFIED AT THE STARTING POINT T. CORE ADVANCES
C   THE SOLUTION OVER THE FIXED STEP H AND RETURNS
C   THE EIGHTH ORDER (NINTH ORDER ACCURATE LOCALLY) SOLUTION
C   APPROXIMATION AT T+H IN ARRAY S(I)
C-----------------------------------------------------------------------

C-----------------------------------------------------------------------

C   REFERENCE:

C   P.J. PRINCE, J.R. DORMAND 'HIGH ORDER EMBEDDED RUNGE-KUTTA FORMULAE'
C                              J. COMP. APPL. MATH. 7 (1981) 67-75.

C-----------------------------------------------------------------------

      INTEGER IW(*)
      INTEGER I, N
      DOUBLE PRECISION T, H, Y(N), E(N), S(N), W(*),
     .                 F1(N), F2(N), F3(N), F4(N), F5(N),
     .                 F6(N), F7(N), F8(N), F9(N), F10(N), F11(N),
     .                 T1, T2, T3, T4, T5, T6, T7, T8, T9
      EXTERNAL F

C   RUNGE-KUTTA FORMULAE

      T1=  (           1.0D0
     .     /          18.0D0) * H
      DO 10 I=1,N
   10 E(I) = Y(I)+T1*F1(I)
      CALL F (T+(1.0D0/18.0D0)*H, E, F2, W, IW)
      T1 = (           1.0D0
     .     /          48.0D0) * H
      T2 = (           1.0D0
     .     /          16.0D0) * H
      DO 20 I=1,N
   20 E(I) = Y(I)+T1*F1(I)+T2*F2(I)
      CALL F (T+(1.0D0/12.0D0)*H, E, F3, W, IW)
      T1 = (           1.0D0
     .     /          32.0D0) * H
      T2 = (           3.0D0
     .     /          32.0D0) * H
      DO 30 I=1,N
   30 E(I) = Y(I)+T1*F1(I)+T2*F3(I)
      CALL F (T+(1.0D0/8.0D0)*H, E, F2, W, IW)
      T1 = (           5.0D0
     .     /          16.0D0) * H
      T2 = (         -75.0D0
     .     /          64.0D0) * H
      T3 = (          75.0D0
     .     /          64.0D0) * H
      DO 40 I=1,N
   40 E(I) = Y(I)+T1*F1(I)+T2*F3(I)+T3*F2(I)
      CALL F (T+(5.0D0/16.0D0)*H, E, F3, W, IW)
      T1 = (           3.0D0
     .     /          80.0D0) * H
      T2 = (           3.0D0
     .     /          16.0D0) * H
      T3 = (           3.0D0
     .     /          20.0D0) * H
      DO 50 I=1,N
   50 E(I) = Y(I)+T1*F1(I)+T2*F2(I)+T3*F3(I)
      CALL F (T+(3.0D0/8.0D0)*H, E, F4, W, IW)
      T1 = (    29443841.0D0
     .     /   614563906.0D0) * H
      T2 = (    77736538.0D0
     .     /   692538347.0D0) * H
      T3 = (   -28693883.0D0
     .     /  1125000000.0D0) * H
      T4 = (    23124283.0D0
     .     /  1800000000.0D0) * H
      DO 60 I=1,N
   60 E(I) = Y(I)+T1*F1(I)+T2*F2(I)+T3*F3(I)+T4*F4(I)
      CALL F (T+(59.0D0/400.0D0)*H, E, F5, W, IW)
      T1 = (    16016141.0D0
     .     /   946692911.0D0) * H
      T2 = (    61564180.0D0
     .     /   158732637.0D0) * H
      T3 = (    22789713.0D0
     .     /   633445777.0D0) * H
      T4 = (   545815736.0D0
     .     /  2771057229.0D0) * H
      T5 = (  -180193667.0D0
     .     /  1043307555.0D0) * H
      DO 70 I=1,N
   70 E(I) = Y(I)+T1*F1(I)+T2*F2(I)+T3*F3(I)+T4*F4(I)+T5*F5(I)
      CALL F (T+(93.0D0/200.0D0)*H, E, F6, W, IW)
      T1 = (    39632708.0D0
     .     /   573591083.0D0) * H
      T2 = (  -433636366.0D0
     .     /   683701615.0D0) * H
      T3 = (  -421739975.0D0
     .     /  2616292301.0D0) * H
      T4 = (   100302831.0D0
     .     /   723423059.0D0) * H
      T5 = (   790204164.0D0
     .     /   839813087.0D0) * H
      T6 = (   800635310.0D0
     .     /  3783071287.0D0) * H
      DO 80 I=1,N
   80 E(I) = Y(I)+T1*F1(I)+T2*F2(I)+T3*F3(I)+T4*F4(I)+T5*F5(I)+T6*F6(I)
      CALL F (T+(5490023248.0D0/9719169821.0D0)*H, E, F7, W, IW)
      T1 = (   246121993.0D0
     .     /  1340847787.0D0) * H
      T2 = (-37695042795.0D0
     .     / 15268766246.0D0) * H
      T3 = (  -309121744.0D0
     .     /  1061227803.0D0) * H
      T4 = (   -12992083.0D0
     .     /   490766935.0D0) * H
      T5 = (  6005943493.0D0
     .     /  2108947869.0D0) * H
      T6 = (   393006217.0D0
     .     /  1396673457.0D0) * H
      T7 = (   123872331.0D0
     .     /  1001029789.0D0) * H
      DO 90 I=1,N
   90 E(I) = Y(I)+T1*F1(I)+T2*F2(I)+T3*F3(I)+T4*F4(I)+T5*F5(I)+T6*F6(I)
     .           +T7*F7(I)
      CALL F (T+(13.0D0/20.0D0)*H, E, F8, W, IW)
      T1 = ( -1028468189.0D0
     .     /   846180014.0D0) * H
      T2 = (  8478235783.0D0
     .     /   508512852.0D0) * H
      T3 = (  1311729495.0D0
     .     /  1432422823.0D0) * H
      T4 = (-10304129995.0D0
     .     /  1701304382.0D0) * H
      T5 = (-48777925059.0D0
     .     /  3047939560.0D0) * H
      T6 = ( 15336726248.0D0
     .     /  1032824649.0D0) * H
      T7 = (-45442868181.0D0
     .     /  3398467696.0D0) * H
      T8 = (  3065993473.0D0
     .     /   597172653.0D0) * H
      DO 100 I=1,N
  100 E(I) = Y(I)+T1*F1(I)+T2*F2(I)+T3*F3(I)+T4*F4(I)+T5*F5(I)+T6*F6(I)
     .           +T7*F7(I)+T8*F8(I)
      CALL F (T+(1201146811.0D0/1299019798.0D0)*H, E, F9, W, IW)
      T1 = (   185892177.0D0
     .     /   718116043.0D0) * H
      T2 = ( -3185094517.0D0
     .     /   667107341.0D0) * H
      T3 = (  -477755414.0D0
     .     /  1098053517.0D0) * H
      T4 = (  -703635378.0D0
     .     /   230739211.0D0) * H
      T5 = (  5731566787.0D0
     .     /  1027545527.0D0) * H
      T6 = (  5232866602.0D0
     .     /   850066563.0D0) * H
      T7 = ( -4093664535.0D0
     .     /   808688257.0D0) * H
      T8 = (  3962137247.0D0
     .     /  1805957418.0D0) * H
      T9 = (    65686358.0D0
     .     /   487910083.0D0) * H
      DO 110 I=1,N
  110 E(I) = Y(I)+T1*F1(I)+T2*F2(I)+T3*F3(I)+T4*F4(I)+T5*F5(I)+T6*F6(I)
     .           +T7*F7(I)+T8*F8(I)+T9*F9(I)
      CALL F (T+H, E, F10, W, IW)
      T1 = (   403863854.0D0
     .     /   491063109.0D0) * H
      T2 = ( -5068492393.0D0
     .     /   434740067.0D0) * H
      T3 = (  -411421997.0D0
     .     /   543043805.0D0) * H
      T4 = (   652783627.0D0
     .     /   914296604.0D0) * H
      T5 = ( 11173962825.0D0
     .     /   925320556.0D0) * H
      T6 = (-13158990841.0D0
     .     /  6184727034.0D0) * H
      T7 = (  3936647629.0D0
     .     /  1978049680.0D0) * H
      T8 = (  -160528059.0D0
     .     /   685178525.0D0) * H
      T9 = (   248638103.0D0
     .     /  1413531060.0D0) * H
      DO 120 I=1,N
  120 E(I) = Y(I)+T1*F1(I)+T2*F2(I)+T3*F3(I)+T4*F4(I)+T5*F5(I)+T6*F6(I)
     .           +T7*F7(I)+T8*F8(I)+T9*F9(I)
      CALL F (T+H, E, F11, W,IW)

C   LOCALLY EXTRAPOLATED SOLUTION & ERROR

      DO 130 I=1,N
      S(I)=(    14005451.0D0
     .     /   335480064.0D0) * F1(I)
     .   + (   -59238493.0D0
     .     /  1068277825.0D0) * F4(I)
     .   + (   181606767.0D0
     .     /   758867731.0D0) * F5(I)
     .   + (   561292985.0D0
     .     /   797845732.0D0) * F6(I)
     .   + ( -1041891430.0D0
     .     /  1371343529.0D0) * F7(I)
     .   + (   760417239.0D0
     .     /  1151165299.0D0) * F8(I)
     .   + (   118820643.0D0
     .     /   751138087.0D0) * F9(I)
     .   + (  -528747749.0D0
     .     /  2220607170.0D0) * F10(I)
     .   + (           1.0D0
     .     /           4.0D0) * F11(I)
      E(I)=S(I)-
     .    ((    13451932.0D0
     .     /   455176623.0D0) * F1(I)
     .   + (  -808719846.0D0
     .     /   976000145.0D0) * F4(I)
     .   + (  1757004468.0D0
     .     /  5645159321.0D0) * F5(I)
     .   + (   656045339.0D0
     .     /   265891186.0D0) * F6(I)
     .   + ( -3867574721.0D0
     .     /  1518517206.0D0) * F7(I)
     .   + (   465885868.0D0
     .     /   322736535.0D0) * F8(I)
     .   + (    53011238.0D0
     .     /   667516719.0D0) * F9(I)
     .   + (           2.0D0
     .     /          45.0D0) * F10(I))
  130 S(I) = Y(I)+H*S(I)
      RETURN
      END


************************************************************************
*                              OPTIMIZER                               *
************************************************************************

      SUBROUTINE SLSQP (M, MEQ, LA, N, X, XL, XU, F, C, G, A,
     *                  ACC, ITER, MODE, W, L_W, JW, L_JW)

C   SLSQP       S EQUENTIAL  L EAST  SQ UARES  P ROGRAMMING
C            TO SOLVE GENERAL NONLINEAR OPTIMIZATION PROBLEMS

C***********************************************************************
C*                                                                     *
C*                                                                     *
C*            A NONLINEAR PROGRAMMING METHOD WITH                      *
C*            QUADRATIC  PROGRAMMING  SUBPROBLEMS                      *
C*                                                                     *
C*                                                                     *
C*  THIS SUBROUTINE SOLVES THE GENERAL NONLINEAR PROGRAMMING PROBLEM   *
C*                                                                     *
C*            MINIMIZE    F(X)                                         *
C*                                                                     *
C*            SUBJECT TO  C (X) .EQ. 0  ,  J = 1,...,MEQ               *
C*                         J                                           *
C*                                                                     *
C*                        C (X) .GE. 0  ,  J = MEQ+1,...,M             *
C*                         J                                           *
C*                                                                     *
C*                        XL .LE. X .LE. XU , I = 1,...,N.             *
C*                          I      I       I                           *
C*                                                                     *
C*  THE ALGORITHM IMPLEMENTS THE METHOD OF HAN AND POWELL              *
C*  WITH BFGS-UPDATE OF THE B-MATRIX AND L1-TEST FUNCTION              *
C*  WITHIN THE STEPLENGTH ALGORITHM.                                   *
C*                                                                     *
C*    PARAMETER DESCRIPTION:                                           *
C*    ( * MEANS THIS PARAMETER WILL BE CHANGED DURING CALCULATION )    *
C*                                                                     *
C*    M              IS THE TOTAL NUMBER OF CONSTRAINTS, M .GE. 0      *
C*    MEQ            IS THE NUMBER OF EQUALITY CONSTRAINTS, MEQ .GE. 0 *
C*    LA             SEE A, LA .GE. MAX(M,1)                           *
C*    N              IS THE NUMBER OF VARIBLES, N .GE. 1               *
C*  * X()            X() STORES THE CURRENT ITERATE OF THE N VECTOR X  *
C*                   ON ENTRY X() MUST BE INITIALIZED. ON EXIT X()     *
C*                   STORES THE SOLUTION VECTOR X IF MODE = 0.         *
C*    XL()           XL() STORES AN N VECTOR OF LOWER BOUNDS XL TO X.  *
C*    XU()           XU() STORES AN N VECTOR OF UPPER BOUNDS XU TO X.  *
C*    F              IS THE VALUE OF THE OBJECTIVE FUNCTION.           *
C*    C()            C() STORES THE M VECTOR C OF CONSTRAINTS,         *
C*                   EQUALITY CONSTRAINTS (IF ANY) FIRST.              *
C*                   DIMENSION OF C MUST BE GREATER OR EQUAL LA,       *
C*                   which must be GREATER OR EQUAL MAX(1,M).          *
C*    G()            G() STORES THE N VECTOR G OF PARTIALS OF THE      *
C*                   OBJECTIVE FUNCTION; DIMENSION OF G MUST BE        *
C*                   GREATER OR EQUAL N+1.                             *
C*    A(),LA,M,N     THE LA BY N + 1 ARRAY A() STORES                  *
C*                   THE M BY N MATRIX A OF CONSTRAINT NORMALS.        *
C*                   A() HAS FIRST DIMENSIONING PARAMETER LA,          *
C*                   WHICH MUST BE GREATER OR EQUAL MAX(1,M).          *
C*    F,C,G,A        MUST ALL BE SET BY THE USER BEFORE EACH CALL.     *
C*  * ACC            ABS(ACC) CONTROLS THE FINAL ACCURACY.             *
C*                   IF ACC .LT. ZERO AN EXACT LINESEARCH IS PERFORMED,*
C*                   OTHERWISE AN ARMIJO-TYPE LINESEARCH IS USED.      *
C*  * ITER           PRESCRIBES THE MAXIMUM NUMBER OF ITERATIONS.      *
C*                   ON EXIT ITER INDICATES THE NUMBER OF ITERATIONS.  *
C*  * MODE           MODE CONTROLS CALCULATION:                        *
C*                   REVERSE COMMUNICATION IS USED IN THE SENSE THAT   *
C*                   THE PROGRAM IS INITIALIZED BY MODE = 0; THEN IT IS*
C*                   TO BE CALLED REPEATEDLY BY THE USER UNTIL A RETURN*
C*                   WITH MODE .NE. IABS(1) TAKES PLACE.               *
C*                   IF MODE = -1 GRADIENTS HAVE TO BE CALCULATED,     *
C*                   WHILE WITH MODE = 1 FUNCTIONS HAVE TO BE CALCULATED
C*                   MODE MUST NOT BE CHANGED BETWEEN SUBSEQUENT CALLS *
C*                   OF SQP.                                           *
C*                   EVALUATION MODES:                                 *
C*        MODE = -1: GRADIENT EVALUATION, (G&A)                        *
C*                0: ON ENTRY: INITIALIZATION, (F,G,C&A)               *
C*                   ON EXIT : REQUIRED ACCURACY FOR SOLUTION OBTAINED *
C*                1: FUNCTION EVALUATION, (F&C)                        *
C*                                                                     *
C*                   FAILURE MODES:                                    *
C*                2: NUMBER OF EQUALITY CONTRAINTS LARGER THAN N       *
C*                3: MORE THAN 3*N ITERATIONS IN LSQ SUBPROBLEM        *
C*                4: INEQUALITY CONSTRAINTS INCOMPATIBLE               *
C*                5: SINGULAR MATRIX E IN LSQ SUBPROBLEM               *
C*                6: SINGULAR MATRIX C IN LSQ SUBPROBLEM               *
C*                7: RANK-DEFICIENT EQUALITY CONSTRAINT SUBPROBLEM HFTI*
C*                8: POSITIVE DIRECTIONAL DERIVATIVE FOR LINESEARCH    *
C*                9: MORE THAN ITER ITERATIONS IN SQP                  *
C*             >=10: WORKING SPACE W OR JW TOO SMALL,                  *
C*                   W SHOULD BE ENLARGED TO L_W=MODE/1000             *
C*                   JW SHOULD BE ENLARGED TO L_JW=MODE-1000*L_W       *
C*  * W(), L_W       W() IS A ONE DIMENSIONAL WORKING SPACE,           *
C*                   THE LENGTH L_W OF WHICH SHOULD BE AT LEAST        *
C*                   (3*N1+M)*(N1+1)                        for LSQ    *
C*                  +(N1-MEQ+1)*(MINEQ+2) + 2*MINEQ         for LSI    *
C*                  +(N1+MINEQ)*(N1-MEQ) + 2*MEQ + N1       for LSEI   *
C*                  + N1*N/2 + 2*M + 3*N + 3*N1 + 1         for SLSQPB *
C*                   with MINEQ = M - MEQ + 2*N1  &  N1 = N+1          *
C*        NOTICE:    FOR PROPER DIMENSIONING OF W IT IS RECOMMENDED TO *
C*                   COPY THE FOLLOWING STATEMENTS INTO THE HEAD OF    *
C*                   THE CALLING PROGRAM (AND REMOVE THE COMMENT C)    *
c#######################################################################
C     INTEGER LEN_W, LEN_JW, M, N, N1, MEQ, MINEQ
C     PARAMETER (M=... , MEQ=... , N=...  )
C     PARAMETER (N1= N+1, MINEQ= M-MEQ+N1+N1)
C     PARAMETER (LEN_W=
c    $           (3*N1+M)*(N1+1)
c    $          +(N1-MEQ+1)*(MINEQ+2) + 2*MINEQ
c    $          +(N1+MINEQ)*(N1-MEQ) + 2*MEQ + N1
c    $          +(N+1)*N/2 + 2*M + 3*N + 3*N1 + 1,
c    $           LEN_JW=MINEQ)
C     DOUBLE PRECISION W(LEN_W)
C     INTEGER          JW(LEN_JW)
c#######################################################################
C*                   THE FIRST M+N+N*N1/2 ELEMENTS OF W MUST NOT BE    *
C*                   CHANGED BETWEEN SUBSEQUENT CALLS OF SLSQP.        *
C*                   ON RETURN W(1) ... W(M) CONTAIN THE MULTIPLIERS   *
C*                   ASSOCIATED WITH THE GENERAL CONSTRAINTS, WHILE    *
C*                   W(M+1) ... W(M+N(N+1)/2) STORE THE CHOLESKY FACTOR*
C*                   L*D*L(T) OF THE APPROXIMATE HESSIAN OF THE        *
C*                   LAGRANGIAN COLUMNWISE DENSE AS LOWER TRIANGULAR   *
C*                   UNIT MATRIX L WITH D IN ITS 'DIAGONAL' and        *
C*                   W(M+N(N+1)/2+N+2 ... W(M+N(N+1)/2+N+2+M+2N)       *
C*                   CONTAIN THE MULTIPLIERS ASSOCIATED WITH ALL       *
C*                   ALL CONSTRAINTS OF THE QUADRATIC PROGRAM FINDING  *
C*                   THE SEARCH DIRECTION TO THE SOLUTION X*           *
C*  * JW(), L_JW     JW() IS A ONE DIMENSIONAL INTEGER WORKING SPACE   *
C*                   THE LENGTH L_JW OF WHICH SHOULD BE AT LEAST       *
C*                   MINEQ                                             *
C*                   with MINEQ = M - MEQ + 2*N1  &  N1 = N+1          *
C*                                                                     *
C*  THE USER HAS TO PROVIDE THE FOLLOWING SUBROUTINES:                 *
C*     LDL(N,A,Z,SIG,W) :   UPDATE OF THE LDL'-FACTORIZATION.          *
C*     LINMIN(A,B,F,TOL) :  LINESEARCH ALGORITHM IF EXACT = 1          *
C*     LSQ(M,MEQ,LA,N,NC,C,D,A,B,XL,XU,X,LAMBDA,W,....) :              *
C*                                                                     *
C*        SOLUTION OF THE QUADRATIC PROGRAM                            *
C*                QPSOL IS RECOMMENDED:                                *
C*     PE GILL, W MURRAY, MA SAUNDERS, MH WRIGHT:                      *
C*     USER'S GUIDE FOR SOL/QPSOL:                                     *
C*     A FORTRAN PACKAGE FOR QUADRATIC PROGRAMMING,                    *
C*     TECHNICAL REPORT SOL 83-7, JULY 1983                            *
C*     DEPARTMENT OF OPERATIONS RESEARCH, STANFORD UNIVERSITY          *
C*     STANFORD, CA 94305                                              *
C*     QPSOL IS THE MOST ROBUST AND EFFICIENT QP-SOLVER                *
C*     AS IT ALLOWS WARM STARTS WITH PROPER WORKING SETS               *
C*                                                                     *
C*     IF IT IS NOT AVAILABLE USE LSEI, A CONSTRAINT LINEAR LEAST      *
C*     SQUARES SOLVER IMPLEMENTED USING THE SOFTWARE HFTI, LDP, NNLS   *
C*     FROM C.L. LAWSON, R.J.HANSON: SOLVING LEAST SQUARES PROBLEMS,   *
C*     PRENTICE HALL, ENGLEWOOD CLIFFS, 1974.                          *
C*     LSEI COMES WITH THIS PACKAGE, together with all necessary SR's. *
C*                                                                     *
C*     TOGETHER WITH A COUPLE OF SUBROUTINES FROM BLAS LEVEL 1         *
C*                                                                     *
C*     SQP IS HEAD SUBROUTINE FOR BODY SUBROUTINE SQPBDY               *
C*     IN WHICH THE ALGORITHM HAS BEEN IMPLEMENTED.                    *
C*                                                                     *
C*  IMPLEMENTED BY: DIETER KRAFT, DFVLR OBERPFAFFENHOFEN               *
C*  as described in Dieter Kraft: A Software Package for               *
C*                                Sequential Quadratic Programming     *
C*                                DFVLR-FB 88-28, 1988                 *
C*  which should be referenced if the user publishes results of SLSQP  *
C*                                                                     *
C*  DATE:           APRIL - OCTOBER, 1981.                             *
C*  STATUS:         DECEMBER, 31-ST, 1984.                             *
C*  STATUS:         MARCH   , 21-ST, 1987, REVISED TO FORTAN 77        *
C*  STATUS:         MARCH   , 20-th, 1989, REVISED TO MS-FORTRAN       *
C*  STATUS:         APRIL   , 14-th, 1989, HESSE   in-line coded       *
C*  STATUS:         FEBRUARY, 28-th, 1991, FORTRAN/2 Version 1.04      *
C*                                         accepts Statement Functions *
C*  STATUS:         MARCH   ,  1-st, 1991, tested with SALFORD         *
C*                                         FTN77/386 COMPILER VERS 2.40*
C*                                         in protected mode           *
C*                                                                     *
C***********************************************************************
C*                                                                     *
C*  Copyright 1991: Dieter Kraft, FHM                                  *
C*                                                                     *
C***********************************************************************

      INTEGER          IL, IM, IR, IS, ITER, IU, IV, IW, IX, L_W, L_JW,
     *                 JW(L_JW), LA, M, MEQ, MINEQ, MODE, N, N1

      DOUBLE PRECISION ACC, A(LA,N+1), C(LA), F, G(N+1),
     *                 X(N), XL(N), XU(N), W(L_W)

c     dim(W) =         N1*(N1+1) + MEQ*(N1+1) + MINEQ*(N1+1)  for LSQ
c                    +(N1-MEQ+1)*(MINEQ+2) + 2*MINEQ          for LSI
c                    +(N1+MINEQ)*(N1-MEQ) + 2*MEQ + N1        for LSEI
c                    + N1*N/2 + 2*M + 3*N +3*N1 + 1           for SLSQPB
c                      with MINEQ = M - MEQ + 2*N1  &  N1 = N+1

C   CHECK LENGTH OF WORKING ARRAYS

      N1 = N+1
      MINEQ = M-MEQ+N1+N1
      IL = (3*N1+M)*(N1+1) +
     .(N1-MEQ+1)*(MINEQ+2) + 2*MINEQ +
     .(N1+MINEQ)*(N1-MEQ)  + 2*MEQ +
     .N1*N/2 + 2*M + 3*N + 4*N1 + 1
      IM = MAX(MINEQ, N1-MEQ)
      IF (L_W .LT. IL .OR. L_JW .LT. IM) THEN
          MODE = 1000*MAX(10,IL)
          MODE = MODE+MAX(10,IM)
          RETURN
      ENDIF

C   PREPARE DATA FOR CALLING SQPBDY  -  INITIAL ADDRESSES IN W

      IM = 1
      IL = IM + MAX(1,M)
      IL = IM + LA
      IX = IL + N1*N/2 + 1
      IR = IX + N
      IS = IR + N + N + MAX(1,M)
      IS = IR + N + N + LA
      IU = IS + N1
      IV = IU + N1
      IW = IV + N1

      CALL SLSQPB  (M, MEQ, LA, N, X, XL, XU, F, C, G, A, ACC, ITER,
     * MODE, W(IR), W(IL), W(IX), W(IM), W(IS), W(IU), W(IV), W(IW), JW)

      END

      SUBROUTINE SLSQPB (M, MEQ, LA, N, X, XL, XU, F, C, G, A, ACC,
     *                   ITER, MODE, R, L, X0, MU, S, U, V, W, IW)

C   NONLINEAR PROGRAMMING BY SOLVING SEQUENTIALLY QUADRATIC PROGRAMS

C        -  L1 - LINE SEARCH,  POSITIVE DEFINITE  BFGS UPDATE  -

C                      BODY SUBROUTINE FOR SLSQP

      INTEGER          IW(*), I, IEXACT, INCONS, IRESET, ITER, ITERMX,
     *                 K, J, LA, LINE, M, MEQ, MODE, N, N1, N2, N3

      DOUBLE PRECISION A(LA,N+1), C(LA), G(N+1), L((N+1)*(N+2)/2),
     *                 MU(LA), R(M+N+N+2), S(N+1), U(N+1), V(N+1), W(*),
     *                 X(N), XL(N), XU(N), X0(N),
     *                 DDOT, DNRM2, LINMIN,
     *                 ACC, ALFMIN, ALPHA, F, F0, GS, H1, H2, H3, H4,
     *                 HUN, ONE, T, T0, TEN, TOL, TWO, ZERO

c     dim(W) =         N1*(N1+1) + MEQ*(N1+1) + MINEQ*(N1+1)  for LSQ
c                     +(N1-MEQ+1)*(MINEQ+2) + 2*MINEQ
c                     +(N1+MINEQ)*(N1-MEQ) + 2*MEQ + N1       for LSEI
c                      with MINEQ = M - MEQ + 2*N1  &  N1 = N+1

      SAVE             ALPHA, F0, GS, H1, H2, H3, H4, T, T0, TOL,
     *                 IEXACT, INCONS, IRESET, ITERMX, LINE, N1, N2, N3

      DATA             ZERO /0.0D0/, ONE /1.0D0/, ALFMIN /1.0D-1/,
     *                 HUN /1.0D+2/, TEN /1.0D+1/, TWO /2.0D0/

      IF (MODE) 260, 100, 220

  100 ITERMX = ITER
      IF (ACC.GE.ZERO) THEN
          IEXACT = 0
      ELSE
          IEXACT = 1
      ENDIF
      ACC = ABS(ACC)
      TOL = TEN*ACC
      ITER = 0
      IRESET = 0
      N1 = N + 1
      N2 = N1*N/2
      N3 = N2 + 1
      S(1) = ZERO
      MU(1) = ZERO
      CALL DCOPY(N, S(1),  0, S,  1)
      CALL DCOPY(M, MU(1), 0, MU, 1)

C   RESET BFGS MATRIX

  110 IRESET = IRESET + 1
      IF (IRESET.GT.5) GO TO 255
      L(1) = ZERO
      CALL DCOPY(N2, L(1), 0, L, 1)
      J = 1
      DO 120 I=1,N
         L(J) = ONE
         J = J + N1 - I
  120 CONTINUE

C   MAIN ITERATION : SEARCH DIRECTION, STEPLENGTH, LDL'-UPDATE

  130 ITER = ITER + 1
      MODE = 9
      IF (ITER.GT.ITERMX) GO TO 330

C   SEARCH DIRECTION AS SOLUTION OF QP - SUBPROBLEM

      CALL DCOPY(N, XL, 1, U, 1)
      CALL DCOPY(N, XU, 1, V, 1)
      CALL DAXPY(N, -ONE, X, 1, U, 1)
      CALL DAXPY(N, -ONE, X, 1, V, 1)
      H4 = ONE
      CALL LSQ (M, MEQ, N , N3, LA, L, G, A, C, U, V, S, R, W, IW, MODE)

C   AUGMENTED PROBLEM FOR INCONSISTENT LINEARIZATION

      IF (MODE.EQ.6) THEN
          IF (N.EQ.MEQ) THEN
              MODE = 4
          ENDIF
      ENDIF
      IF (MODE.EQ.4) THEN
          DO 140 J=1,M
             IF (J.LE.MEQ) THEN
                 A(J,N1) = -C(J)
             ELSE
                 A(J,N1) = MAX(-C(J),ZERO)
             ENDIF
  140     CONTINUE
          S(1) = ZERO
          CALL DCOPY(N, S(1), 0, S, 1)
          H3 = ZERO
          G(N1) = ZERO
          L(N3) = HUN
          S(N1) = ONE
          U(N1) = ZERO
          V(N1) = ONE
          INCONS = 0
  150     CALL LSQ (M, MEQ, N1, N3, LA, L, G, A, C, U, V, S, R,
     *              W, IW, MODE)
          H4 = ONE - S(N1)
          IF (MODE.EQ.4) THEN
              L(N3) = TEN*L(N3)
              INCONS = INCONS + 1
              IF (INCONS.GT.5) GO TO 330
              GOTO 150
          ELSE IF (MODE.NE.1) THEN
              GOTO 330
          ENDIF
      ELSE IF (MODE.NE.1) THEN
          GOTO 330
      ENDIF

C   UPDATE MULTIPLIERS FOR L1-TEST

      DO 160 I=1,N
         V(I) = G(I) - DDOT(M,A(1,I),1,R,1)
  160 CONTINUE
      F0 = F
      CALL DCOPY(N, X, 1, X0, 1)
      GS = DDOT(N, G, 1, S, 1)
      H1 = ABS(GS)
      H2 = ZERO
      DO 170 J=1,M
         IF (J.LE.MEQ) THEN
             H3 = C(J)
         ELSE
             H3 = ZERO
         ENDIF
         H2 = H2 + MAX(-C(J),H3)
         H3 = ABS(R(J))
         MU(J) = MAX(H3,(MU(J)+H3)/TWO)
         H1 = H1 + H3*ABS(C(J))
  170 CONTINUE

C   CHECK CONVERGENCE

      MODE = 0
      IF (H1.LT.ACC .AND. H2.LT.ACC) GO TO 330
      H1 = ZERO
      DO 180 J=1,M
         IF (J.LE.MEQ) THEN
             H3 = C(J)
         ELSE
             H3 = ZERO
         ENDIF
         H1 = H1 + MU(J)*MAX(-C(J),H3)
  180 CONTINUE
      T0 = F + H1
      H3 = GS - H1*H4
      MODE = 8
      IF (H3.GE.ZERO) GO TO 110

C   LINE SEARCH WITH AN L1-TESTFUNCTION

      LINE = 0
      ALPHA = ONE
      IF (IEXACT.EQ.1) GOTO 210

C   INEXACT LINESEARCH

  190     LINE = LINE + 1
          H3 = ALPHA*H3
          CALL DSCAL(N, ALPHA, S, 1)
          CALL DCOPY(N, X0, 1, X, 1)
          CALL DAXPY(N, ONE, S, 1, X, 1)
          MODE = 1
          GO TO 330
  200         IF (H1.LE.H3/TEN .OR. LINE.GT.10) GO TO 240
              ALPHA = MAX(H3/(TWO*(H3-H1)),ALFMIN)
              GO TO 190

C   EXACT LINESEARCH

  210 IF (LINE.NE.3) THEN
          ALPHA = LINMIN(LINE,ALFMIN,ONE,T,TOL)
          CALL DCOPY(N, X0, 1, X, 1)
          CALL DAXPY(N, ALPHA, S, 1, X, 1)
          MODE = 1
          GOTO 330
      ENDIF
      CALL DSCAL(N, ALPHA, S, 1)
      GOTO 240

C   CALL FUNCTIONS AT CURRENT X

  220     T = F
          DO 230 J=1,M
             IF (J.LE.MEQ) THEN
                 H1 = C(J)
             ELSE
                 H1 = ZERO
             ENDIF
             T = T + MU(J)*MAX(-C(J),H1)
  230     CONTINUE
          H1 = T - T0
          GOTO (200, 210) IEXACT+1

C   CHECK CONVERGENCE

  240 H3 = ZERO
      DO 250 J=1,M
         IF (J.LE.MEQ) THEN
             H1 = C(J)
         ELSE
             H1 = ZERO
         ENDIF
         H3 = H3 + MAX(-C(J),H1)
  250 CONTINUE
      IF ((ABS(F-F0).LT.ACC .OR. DNRM2(N,S,1).LT.ACC) .AND. H3.LT.ACC)
     *   THEN
            MODE = 0
         ELSE
            MODE = -1
         ENDIF
      GO TO 330

C   CHECK relaxed CONVERGENCE in case of positive directional derivative

  255 CONTINUE
      IF ((ABS(F-F0).LT.TOL .OR. DNRM2(N,S,1).LT.TOL) .AND. H3.LT.TOL)
     *   THEN
            MODE = 0
         ELSE
            MODE = 8
         ENDIF
      GO TO 330

C   CALL JACOBIAN AT CURRENT X

C   UPDATE CHOLESKY-FACTORS OF HESSIAN MATRIX BY MODIFIED BFGS FORMULA

  260 DO 270 I=1,N
         U(I) = G(I) - DDOT(M,A(1,I),1,R,1) - V(I)
  270 CONTINUE

C   L'*S

      K = 0
      DO 290 I=1,N
         H1 = ZERO
         K = K + 1
         DO 280 J=I+1,N
            K = K + 1
            H1 = H1 + L(K)*S(J)
  280    CONTINUE
         V(I) = S(I) + H1
  290 CONTINUE

C   D*L'*S

      K = 1
      DO 300 I=1,N
         V(I) = L(K)*V(I)
         K = K + N1 - I
  300 CONTINUE

C   L*D*L'*S

      DO 320 I=N,1,-1
         H1 = ZERO
         K = I
         DO 310 J=1,I - 1
            H1 = H1 + L(K)*V(J)
            K = K + N - J
  310    CONTINUE
         V(I) = V(I) + H1
  320 CONTINUE

      H1 = DDOT(N,S,1,U,1)
      H2 = DDOT(N,S,1,V,1)
      H3 = 0.2D0*H2
      IF (H1.LT.H3) THEN
          H4 = (H2-H3)/(H2-H1)
          H1 = H3
          CALL DSCAL(N, H4, U, 1)
          CALL DAXPY(N, ONE-H4, V, 1, U, 1)
      ENDIF
      CALL LDL(N, L, U, +ONE/H1, V)
      CALL LDL(N, L, V, -ONE/H2, U)

C   END OF MAIN ITERATION

      GO TO 130

C   END OF SLSQPB

  330 END


      SUBROUTINE LSQ(M,MEQ,N,NL,LA,L,G,A,B,XL,XU,X,Y,W,JW,MODE)

C   MINIMIZE with respect to X

C             ||E*X - F||
C                                      1/2  T
C   WITH UPPER TRIANGULAR MATRIX E = +D   *L ,

C                                      -1/2  -1
C                     AND VECTOR F = -D    *L  *G,

C  WHERE THE UNIT LOWER TRIDIANGULAR MATRIX L IS STORED COLUMNWISE
C  DENSE IN THE N*(N+1)/2 ARRAY L WITH VECTOR D STORED IN ITS
C 'DIAGONAL' THUS SUBSTITUTING THE ONE-ELEMENTS OF L

C   SUBJECT TO

C             A(J)*X - B(J) = 0 ,         J=1,...,MEQ,
C             A(J)*X - B(J) >=0,          J=MEQ+1,...,M,
C             XL(I) <= X(I) <= XU(I),     I=1,...,N,
C     ON ENTRY, THE USER HAS TO PROVIDE THE ARRAYS L, G, A, B, XL, XU.
C     WITH DIMENSIONS: L(N*(N+1)/2), G(N), A(LA,N), B(M), XL(N), XU(N)
C     THE WORKING ARRAY W MUST HAVE AT LEAST THE FOLLOWING DIMENSION:
c     DIM(W) =        (3*N+M)*(N+1)                        for LSQ
c                    +(N-MEQ+1)*(MINEQ+2) + 2*MINEQ        for LSI
c                    +(N+MINEQ)*(N-MEQ) + 2*MEQ + N        for LSEI
c                      with MINEQ = M - MEQ + 2*N
C     ON RETURN, NO ARRAY WILL BE CHANGED BY THE SUBROUTINE.
C     X     STORES THE N-DIMENSIONAL SOLUTION VECTOR
C     Y     STORES THE VECTOR OF LAGRANGE MULTIPLIERS OF DIMENSION
C           M+N+N (CONSTRAINTS+LOWER+UPPER BOUNDS)
C     MODE  IS A SUCCESS-FAILURE FLAG WITH THE FOLLOWING MEANINGS:
C          MODE=1: SUCCESSFUL COMPUTATION
C               2: ERROR RETURN BECAUSE OF WRONG DIMENSIONS (N<1)
C               3: ITERATION COUNT EXCEEDED BY NNLS
C               4: INEQUALITY CONSTRAINTS INCOMPATIBLE
C               5: MATRIX E IS NOT OF FULL RANK
C               6: MATRIX C IS NOT OF FULL RANK
C               7: RANK DEFECT IN HFTI

c     coded            Dieter Kraft, april 1987
c     revised                        march 1989

      DOUBLE PRECISION L,G,A,B,W,XL,XU,X,Y,
     .                 DIAG,ZERO,ONE,DDOT,XNORM

      INTEGER          JW(*),I,IC,ID,IE,IF,IG,IH,IL,IM,IP,IU,IW,
     .                 I1,I2,I3,I4,LA,M,MEQ,MINEQ,MODE,M1,N,NL,N1,N2,N3

      DIMENSION        A(LA,N), B(LA), G(N), L(NL),
     .                 W(*), X(N), XL(N), XU(N), Y(M+N+N)

      DATA             ZERO/0.0D0/, ONE/1.0D0/

      N1 = N + 1
      MINEQ = M - MEQ
      M1 = MINEQ + N + N

c  determine whether to solve problem
c  with inconsistent linerarization (n2=1)
c  or not (n2=0)

      N2 = N1*N/2 + 1
      IF (N2.EQ.NL) THEN
          N2 = 0
      ELSE
          N2 = 1
      ENDIF
      N3 = N-N2

C  RECOVER MATRIX E AND VECTOR F FROM L AND G

      I2 = 1
      I3 = 1
      I4 = 1
      IE = 1
      IF = N*N+1
      DO 10 I=1,N3
         I1 = N1-I
         DIAG = SQRT (L(I2))
         W(I3) = ZERO
         CALL DCOPY (I1  ,  W(I3), 0, W(I3), 1)
         CALL DCOPY (I1-N2, L(I2), 1, W(I3), N)
         CALL DSCAL (I1-N2,     DIAG, W(I3), N)
         W(I3) = DIAG
         W(IF-1+I) = (G(I) - DDOT (I-1, W(I4), 1, W(IF), 1))/DIAG
         I2 = I2 + I1 - N2
         I3 = I3 + N1
         I4 = I4 + N
   10 CONTINUE
      IF (N2.EQ.1) THEN
          W(I3) = L(NL)
          W(I4) = ZERO
          CALL DCOPY (N3, W(I4), 0, W(I4), 1)
          W(IF-1+N) = ZERO
      ENDIF
      CALL DSCAL (N, - ONE, W(IF), 1)

      IC = IF + N
      ID = IC + MEQ*N

      IF (MEQ .GT. 0) THEN

C  RECOVER MATRIX C FROM UPPER PART OF A

          DO 20 I=1,MEQ
              CALL DCOPY (N, A(I,1), LA, W(IC-1+I), MEQ)
   20     CONTINUE

C  RECOVER VECTOR D FROM UPPER PART OF B

          CALL DCOPY (MEQ, B(1), 1, W(ID), 1)
          CALL DSCAL (MEQ,   - ONE, W(ID), 1)

      ENDIF

      IG = ID + MEQ

      IF (MINEQ .GT. 0) THEN

C  RECOVER MATRIX G FROM LOWER PART OF A

          DO 30 I=1,MINEQ
              CALL DCOPY (N, A(MEQ+I,1), LA, W(IG-1+I), M1)
   30     CONTINUE

      ENDIF

C  AUGMENT MATRIX G BY +I AND -I

      IP = IG + MINEQ
      DO 40 I=1,N
         W(IP-1+I) = ZERO
         CALL DCOPY (N, W(IP-1+I), 0, W(IP-1+I), M1)
   40 CONTINUE
      W(IP) = ONE
      CALL DCOPY (N, W(IP), 0, W(IP), M1+1)

      IM = IP + N
      DO 50 I=1,N
         W(IM-1+I) = ZERO
         CALL DCOPY (N, W(IM-1+I), 0, W(IM-1+I), M1)
   50 CONTINUE
      W(IM) = -ONE
      CALL DCOPY (N, W(IM), 0, W(IM), M1+1)

      IH = IG + M1*N

      IF (MINEQ .GT. 0) THEN

C  RECOVER H FROM LOWER PART OF B

          CALL DCOPY (MINEQ, B(MEQ+1), 1, W(IH), 1)
          CALL DSCAL (MINEQ,       - ONE, W(IH), 1)

      ENDIF

C  AUGMENT VECTOR H BY XL AND XU

      IL = IH + MINEQ
      CALL DCOPY (N, XL, 1, W(IL), 1)
      IU = IL + N
      CALL DCOPY (N, XU, 1, W(IU), 1)
      CALL DSCAL (N, - ONE, W(IU), 1)

      IW = IU + N

      CALL LSEI (W(IC), W(ID), W(IE), W(IF), W(IG), W(IH), MAX(1,MEQ),
     .           MEQ, N, N, M1, M1, N, X, XNORM, W(IW), JW, MODE)

      IF (MODE .EQ. 1) THEN

c   restore Lagrange multipliers

          CALL DCOPY (M,  W(IW),     1, Y(1),      1)
          CALL DCOPY (N3, W(IW+M),   1, Y(M+1),    1)
          CALL DCOPY (N3, W(IW+M+N), 1, Y(M+N3+1), 1)

      ENDIF

C   END OF SUBROUTINE LSQ

      END


      SUBROUTINE LSEI(C,D,E,F,G,H,LC,MC,LE,ME,LG,MG,N,X,XNRM,W,JW,MODE)

C     FOR MODE=1, THE SUBROUTINE RETURNS THE SOLUTION X OF
C     EQUALITY & INEQUALITY CONSTRAINED LEAST SQUARES PROBLEM LSEI :

C                MIN ||E*X - F||
C                 X

C                S.T.  C*X  = D,
C                      G*X >= H.

C     USING QR DECOMPOSITION & ORTHOGONAL BASIS OF NULLSPACE OF C
C     CHAPTER 23.6 OF LAWSON & HANSON: SOLVING LEAST SQUARES PROBLEMS.

C     THE FOLLOWING DIMENSIONS OF THE ARRAYS DEFINING THE PROBLEM
C     ARE NECESSARY
C     DIM(E) :   FORMAL (LE,N),    ACTUAL (ME,N)
C     DIM(F) :   FORMAL (LE  ),    ACTUAL (ME  )
C     DIM(C) :   FORMAL (LC,N),    ACTUAL (MC,N)
C     DIM(D) :   FORMAL (LC  ),    ACTUAL (MC  )
C     DIM(G) :   FORMAL (LG,N),    ACTUAL (MG,N)
C     DIM(H) :   FORMAL (LG  ),    ACTUAL (MG  )
C     DIM(X) :   FORMAL (N   ),    ACTUAL (N   )
C     DIM(W) :   2*MC+ME+(ME+MG)*(N-MC)  for LSEI
C              +(N-MC+1)*(MG+2)+2*MG     for LSI
C     DIM(JW):   MAX(MG,L)
C     ON ENTRY, THE USER HAS TO PROVIDE THE ARRAYS C, D, E, F, G, AND H.
C     ON RETURN, ALL ARRAYS WILL BE CHANGED BY THE SUBROUTINE.
C     X     STORES THE SOLUTION VECTOR
C     XNORM STORES THE RESIDUUM OF THE SOLUTION IN EUCLIDIAN NORM
C     W     STORES THE VECTOR OF LAGRANGE MULTIPLIERS IN ITS FIRST
C           MC+MG ELEMENTS
C     MODE  IS A SUCCESS-FAILURE FLAG WITH THE FOLLOWING MEANINGS:
C          MODE=1: SUCCESSFUL COMPUTATION
C               2: ERROR RETURN BECAUSE OF WRONG DIMENSIONS (N<1)
C               3: ITERATION COUNT EXCEEDED BY NNLS
C               4: INEQUALITY CONSTRAINTS INCOMPATIBLE
C               5: MATRIX E IS NOT OF FULL RANK
C               6: MATRIX C IS NOT OF FULL RANK
C               7: RANK DEFECT IN HFTI

C     18.5.1981, DIETER KRAFT, DFVLR OBERPFAFFENHOFEN
C     20.3.1987, DIETER KRAFT, DFVLR OBERPFAFFENHOFEN

      INTEGER          JW(*),I,IE,IF,IG,IW,J,K,KRANK,L,LC,LE,LG,
     .                 MC,MC1,ME,MG,MODE,N
      DOUBLE PRECISION C(LC,N),E(LE,N),G(LG,N),D(LC),F(LE),H(LG),X(N),
     .                 W(*),T,DDOT,XNRM,DNRM2,EPMACH,ZERO
      DATA             EPMACH/2.22D-16/,ZERO/0.0D+00/

      MODE=2
      IF(MC.GT.N)                      GOTO 75
      L=N-MC
      MC1=MC+1
      IW=(L+1)*(MG+2)+2*MG+MC
      IE=IW+MC+1
      IF=IE+ME*L
      IG=IF+ME

C  TRIANGULARIZE C AND APPLY FACTORS TO E AND G

      DO 10 I=1,MC
          J=MIN(I+1,LC)
          CALL H12(1,I,I+1,N,C(I,1),LC,W(IW+I),C(J,1),LC,1,MC-I)
          CALL H12(2,I,I+1,N,C(I,1),LC,W(IW+I),E     ,LE,1,ME)
   10     CALL H12(2,I,I+1,N,C(I,1),LC,W(IW+I),G     ,LG,1,MG)

C  SOLVE C*X=D AND MODIFY F

      MODE=6
      DO 15 I=1,MC
          IF(ABS(C(I,I)).LT.EPMACH)    GOTO 75
          X(I)=(D(I)-DDOT(I-1,C(I,1),LC,X,1))/C(I,I)
   15 CONTINUE
      MODE=1
      W(MC1) = ZERO
      CALL DCOPY (MG-MC,W(MC1),0,W(MC1),1)

      IF(MC.EQ.N)                      GOTO 50

      DO 20 I=1,ME
   20     W(IF-1+I)=F(I)-DDOT(MC,E(I,1),LE,X,1)

C  STORE TRANSFORMED E & G

      DO 25 I=1,ME
   25     CALL DCOPY(L,E(I,MC1),LE,W(IE-1+I),ME)
      DO 30 I=1,MG
   30     CALL DCOPY(L,G(I,MC1),LG,W(IG-1+I),MG)

      IF(MG.GT.0)                      GOTO 40

C  SOLVE LS WITHOUT INEQUALITY CONSTRAINTS

      MODE=7
      K=MAX(LE,N)
      T=SQRT(EPMACH)
      CALL HFTI (W(IE),ME,ME,L,W(IF),K,1,T,KRANK,XNRM,W,W(L+1),JW)
      CALL DCOPY(L,W(IF),1,X(MC1),1)
      IF(KRANK.NE.L)                   GOTO 75
      MODE=1
                                       GOTO 50
C  MODIFY H AND SOLVE INEQUALITY CONSTRAINED LS PROBLEM

   40 DO 45 I=1,MG
   45     H(I)=H(I)-DDOT(MC,G(I,1),LG,X,1)
      CALL LSI
     . (W(IE),W(IF),W(IG),H,ME,ME,MG,MG,L,X(MC1),XNRM,W(MC1),JW,MODE)
      IF(MC.EQ.0)                      GOTO 75
      T=DNRM2(MC,X,1)
      XNRM=SQRT(XNRM*XNRM+T*T)
      IF(MODE.NE.1)                    GOTO 75

C  SOLUTION OF ORIGINAL PROBLEM AND LAGRANGE MULTIPLIERS

   50 DO 55 I=1,ME
   55     F(I)=DDOT(N,E(I,1),LE,X,1)-F(I)
      DO 60 I=1,MC
   60     D(I)=DDOT(ME,E(1,I),1,F,1)-DDOT(MG,G(1,I),1,W(MC1),1)

      DO 65 I=MC,1,-1
   65     CALL H12(2,I,I+1,N,C(I,1),LC,W(IW+I),X,1,1,1)

      DO 70 I=MC,1,-1
          J=MIN(I+1,LC)
          W(I)=(D(I)-DDOT(MC-I,C(J,I),1,W(J),1))/C(I,I)
   70 CONTINUE

C  END OF SUBROUTINE LSEI

   75                                  END


      SUBROUTINE LSI(E,F,G,H,LE,ME,LG,MG,N,X,XNORM,W,JW,MODE)

C     FOR MODE=1, THE SUBROUTINE RETURNS THE SOLUTION X OF
C     INEQUALITY CONSTRAINED LINEAR LEAST SQUARES PROBLEM:

C                    MIN ||E*X-F||
C                     X

C                    S.T.  G*X >= H

C     THE ALGORITHM IS BASED ON QR DECOMPOSITION AS DESCRIBED IN
C     CHAPTER 23.5 OF LAWSON & HANSON: SOLVING LEAST SQUARES PROBLEMS

C     THE FOLLOWING DIMENSIONS OF THE ARRAYS DEFINING THE PROBLEM
C     ARE NECESSARY
C     DIM(E) :   FORMAL (LE,N),    ACTUAL (ME,N)
C     DIM(F) :   FORMAL (LE  ),    ACTUAL (ME  )
C     DIM(G) :   FORMAL (LG,N),    ACTUAL (MG,N)
C     DIM(H) :   FORMAL (LG  ),    ACTUAL (MG  )
C     DIM(X) :   N
C     DIM(W) :   (N+1)*(MG+2) + 2*MG
C     DIM(JW):   LG
C     ON ENTRY, THE USER HAS TO PROVIDE THE ARRAYS E, F, G, AND H.
C     ON RETURN, ALL ARRAYS WILL BE CHANGED BY THE SUBROUTINE.
C     X     STORES THE SOLUTION VECTOR
C     XNORM STORES THE RESIDUUM OF THE SOLUTION IN EUCLIDIAN NORM
C     W     STORES THE VECTOR OF LAGRANGE MULTIPLIERS IN ITS FIRST
C           MG ELEMENTS
C     MODE  IS A SUCCESS-FAILURE FLAG WITH THE FOLLOWING MEANINGS:
C          MODE=1: SUCCESSFUL COMPUTATION
C               2: ERROR RETURN BECAUSE OF WRONG DIMENSIONS (N<1)
C               3: ITERATION COUNT EXCEEDED BY NNLS
C               4: INEQUALITY CONSTRAINTS INCOMPATIBLE
C               5: MATRIX E IS NOT OF FULL RANK

C     03.01.1980, DIETER KRAFT: CODED
C     20.03.1987, DIETER KRAFT: REVISED TO FORTRAN 77

      INTEGER          I,J,LE,LG,ME,MG,MODE,N,JW(LG)
      DOUBLE PRECISION E(LE,N),F(LE),G(LG,N),H(LG),X(N),W(*),
     .                 DDOT,XNORM,DNRM2,EPMACH,T,ONE
      DATA             EPMACH/2.22D-16/,ONE/1.0D+00/

C  QR-FACTORS OF E AND APPLICATION TO F

      DO 10 I=1,N
      J=MIN(I+1,N)
      CALL H12(1,I,I+1,ME,E(1,I),1,T,E(1,J),1,LE,N-I)
   10 CALL H12(2,I,I+1,ME,E(1,I),1,T,F     ,1,1 ,1  )

C  TRANSFORM G AND H TO GET LEAST DISTANCE PROBLEM

      MODE=5
      DO 30 I=1,MG
          DO 20 J=1,N
              IF (ABS(E(J,J)).LT.EPMACH) GOTO 50
   20         G(I,J)=(G(I,J)-DDOT(J-1,G(I,1),LG,E(1,J),1))/E(J,J)
   30     H(I)=H(I)-DDOT(N,G(I,1),LG,F,1)

C  SOLVE LEAST DISTANCE PROBLEM

      CALL LDP(G,LG,MG,N,H,X,XNORM,W,JW,MODE)
      IF (MODE.NE.1)                     GOTO 50

C  SOLUTION OF ORIGINAL PROBLEM

      CALL DAXPY(N,ONE,F,1,X,1)
      DO 40 I=N,1,-1
          J=MIN(I+1,N)
   40     X(I)=(X(I)-DDOT(N-I,E(I,J),LE,X(J),1))/E(I,I)
      J=MIN(N+1,ME)
      T=DNRM2(ME-N,F(J),1)
      XNORM=SQRT(XNORM*XNORM+T*T)

C  END OF SUBROUTINE LSI

   50                                    END

      SUBROUTINE LDP(G,MG,M,N,H,X,XNORM,W,INDEX,MODE)

C                     T
C     MINIMIZE   1/2 X X    SUBJECT TO   G * X >= H.

C       C.L. LAWSON, R.J. HANSON: 'SOLVING LEAST SQUARES PROBLEMS'
C       PRENTICE HALL, ENGLEWOOD CLIFFS, NEW JERSEY, 1974.

C     PARAMETER DESCRIPTION:

C     G(),MG,M,N   ON ENTRY G() STORES THE M BY N MATRIX OF
C                  LINEAR INEQUALITY CONSTRAINTS. G() HAS FIRST
C                  DIMENSIONING PARAMETER MG
C     H()          ON ENTRY H() STORES THE M VECTOR H REPRESENTING
C                  THE RIGHT SIDE OF THE INEQUALITY SYSTEM

C     REMARK: G(),H() WILL NOT BE CHANGED DURING CALCULATIONS BY LDP

C     X()          ON ENTRY X() NEED NOT BE INITIALIZED.
C                  ON EXIT X() STORES THE SOLUTION VECTOR X IF MODE=1.
C     XNORM        ON EXIT XNORM STORES THE EUCLIDIAN NORM OF THE
C                  SOLUTION VECTOR IF COMPUTATION IS SUCCESSFUL
C     W()          W IS A ONE DIMENSIONAL WORKING SPACE, THE LENGTH
C                  OF WHICH SHOULD BE AT LEAST (M+2)*(N+1) + 2*M
C                  ON EXIT W() STORES THE LAGRANGE MULTIPLIERS
C                  ASSOCIATED WITH THE CONSTRAINTS
C                  AT THE SOLUTION OF PROBLEM LDP
C     INDEX()      INDEX() IS A ONE DIMENSIONAL INTEGER WORKING SPACE
C                  OF LENGTH AT LEAST M
C     MODE         MODE IS A SUCCESS-FAILURE FLAG WITH THE FOLLOWING
C                  MEANINGS:
C          MODE=1: SUCCESSFUL COMPUTATION
C               2: ERROR RETURN BECAUSE OF WRONG DIMENSIONS (N.LE.0)
C               3: ITERATION COUNT EXCEEDED BY NNLS
C               4: INEQUALITY CONSTRAINTS INCOMPATIBLE

      DOUBLE PRECISION G,H,X,XNORM,W,U,V,
     .                 ZERO,ONE,FAC,RNORM,DNRM2,DDOT,DIFF
      INTEGER          INDEX,I,IF,IW,IWDUAL,IY,IZ,J,M,MG,MODE,N,N1
      DIMENSION        G(MG,N),H(M),X(N),W(*),INDEX(M)
      DIFF(U,V)=       U-V
      DATA             ZERO,ONE/0.0D0,1.0D0/

      MODE=2
      IF(N.LE.0)                    GOTO 50

C  STATE DUAL PROBLEM

      MODE=1
      X(1)=ZERO
      CALL DCOPY(N,X(1),0,X,1)
      XNORM=ZERO
      IF(M.EQ.0)                    GOTO 50
      IW=0
      DO 20 J=1,M
          DO 10 I=1,N
              IW=IW+1
   10         W(IW)=G(J,I)
          IW=IW+1
   20     W(IW)=H(J)
      IF=IW+1
      DO 30 I=1,N
          IW=IW+1
   30     W(IW)=ZERO
      W(IW+1)=ONE
      N1=N+1
      IZ=IW+2
      IY=IZ+N1
      IWDUAL=IY+M

C  SOLVE DUAL PROBLEM

      CALL NNLS (W,N1,N1,M,W(IF),W(IY),RNORM,W(IWDUAL),W(IZ),INDEX,MODE)

      IF(MODE.NE.1)                 GOTO 50
      MODE=4
      IF(RNORM.LE.ZERO)             GOTO 50

C  COMPUTE SOLUTION OF PRIMAL PROBLEM

      FAC=ONE-DDOT(M,H,1,W(IY),1)
      IF(DIFF(ONE+FAC,ONE).LE.ZERO) GOTO 50
      MODE=1
      FAC=ONE/FAC
      DO 40 J=1,N
   40     X(J)=FAC*DDOT(M,G(1,J),1,W(IY),1)
      XNORM=DNRM2(N,X,1)

C  COMPUTE LAGRANGE MULTIPLIERS FOR PRIMAL PROBLEM

      W(1)=ZERO
      CALL DCOPY(M,W(1),0,W,1)
      CALL DAXPY(M,FAC,W(IY),1,W,1)

C  END OF SUBROUTINE LDP

   50                               END


      SUBROUTINE NNLS (A, MDA, M, N, B, X, RNORM, W, Z, INDEX, MODE)

C     C.L.LAWSON AND R.J.HANSON, JET PROPULSION LABORATORY:
C     'SOLVING LEAST SQUARES PROBLEMS'. PRENTICE-HALL.1974

C      **********   NONNEGATIVE LEAST SQUARES   **********

C     GIVEN AN M BY N MATRIX, A, AND AN M-VECTOR, B, COMPUTE AN
C     N-VECTOR, X, WHICH SOLVES THE LEAST SQUARES PROBLEM

C                  A*X = B  SUBJECT TO  X >= 0

C     A(),MDA,M,N
C            MDA IS THE FIRST DIMENSIONING PARAMETER FOR THE ARRAY,A().
C            ON ENTRY A()  CONTAINS THE M BY N MATRIX,A.
C            ON EXIT A() CONTAINS THE PRODUCT Q*A,
C            WHERE Q IS AN M BY M ORTHOGONAL MATRIX GENERATED
C            IMPLICITLY BY THIS SUBROUTINE.
C            EITHER M>=N OR M<N IS PERMISSIBLE.
C            THERE IS NO RESTRICTION ON THE RANK OF A.
C     B()    ON ENTRY B() CONTAINS THE M-VECTOR, B.
C            ON EXIT B() CONTAINS Q*B.
C     X()    ON ENTRY X() NEED NOT BE INITIALIZED.
C            ON EXIT X() WILL CONTAIN THE SOLUTION VECTOR.
C     RNORM  ON EXIT RNORM CONTAINS THE EUCLIDEAN NORM OF THE
C            RESIDUAL VECTOR.
C     W()    AN N-ARRAY OF WORKING SPACE.
C            ON EXIT W() WILL CONTAIN THE DUAL SOLUTION VECTOR.
C            W WILL SATISFY W(I)=0 FOR ALL I IN SET P
C            AND W(I)<=0 FOR ALL I IN SET Z
C     Z()    AN M-ARRAY OF WORKING SPACE.
C     INDEX()AN INTEGER WORKING ARRAY OF LENGTH AT LEAST N.
C            ON EXIT THE CONTENTS OF THIS ARRAY DEFINE THE SETS
C            P AND Z AS FOLLOWS:
C            INDEX(1)    THRU INDEX(NSETP) = SET P.
C            INDEX(IZ1)  THRU INDEX (IZ2)  = SET Z.
C            IZ1=NSETP + 1 = NPP1, IZ2=N.
C     MODE   THIS IS A SUCCESS-FAILURE FLAG WITH THE FOLLOWING MEANING:
C            1    THE SOLUTION HAS BEEN COMPUTED SUCCESSFULLY.
C            2    THE DIMENSIONS OF THE PROBLEM ARE WRONG,
C                 EITHER M <= 0 OR N <= 0.
C            3    ITERATION COUNT EXCEEDED, MORE THAN 3*N ITERATIONS.

      INTEGER          I,II,IP,ITER,ITMAX,IZ,IZMAX,IZ1,IZ2,J,JJ,JZ,
     *                 K,L,M,MDA,MODE,N,NPP1,NSETP,INDEX(N)

      DOUBLE PRECISION A(MDA,N),B(M),X(N),W(N),Z(M),ASAVE,DIFF,
     *                 FACTOR,DDOT,ZERO,ONE,WMAX,ALPHA,
     *                 C,S,T,U,V,UP,RNORM,UNORM,DNRM2

      DIFF(U,V)=       U-V

      DATA             ZERO,ONE,FACTOR/0.0D0,1.0D0,1.0D-2/

c     revised          Dieter Kraft, March 1983

      MODE=2
      IF(M.LE.0.OR.N.LE.0)            GOTO 290
      MODE=1
      ITER=0
      ITMAX=3*N

C STEP ONE (INITIALIZE)

      DO 100 I=1,N
  100    INDEX(I)=I
      IZ1=1
      IZ2=N
      NSETP=0
      NPP1=1
      X(1)=ZERO
      CALL DCOPY(N,X(1),0,X,1)

C STEP TWO (COMPUTE DUAL VARIABLES)
C .....ENTRY LOOP A

  110 IF(IZ1.GT.IZ2.OR.NSETP.GE.M)    GOTO 280
      DO 120 IZ=IZ1,IZ2
         J=INDEX(IZ)
  120    W(J)=DDOT(M-NSETP,A(NPP1,J),1,B(NPP1),1)

C STEP THREE (TEST DUAL VARIABLES)

  130 WMAX=ZERO
      DO 140 IZ=IZ1,IZ2
      J=INDEX(IZ)
         IF(W(J).LE.WMAX)             GOTO 140
         WMAX=W(J)
         IZMAX=IZ
  140 CONTINUE

C .....EXIT LOOP A

      IF(WMAX.LE.ZERO)                GOTO 280
      IZ=IZMAX
      J=INDEX(IZ)

C STEP FOUR (TEST INDEX J FOR LINEAR DEPENDENCY)

      ASAVE=A(NPP1,J)
      CALL H12(1,NPP1,NPP1+1,M,A(1,J),1,UP,Z,1,1,0)
      UNORM=DNRM2(NSETP,A(1,J),1)
      T=FACTOR*ABS(A(NPP1,J))
      IF(DIFF(UNORM+T,UNORM).LE.ZERO) GOTO 150
      CALL DCOPY(M,B,1,Z,1)
      CALL H12(2,NPP1,NPP1+1,M,A(1,J),1,UP,Z,1,1,1)
      IF(Z(NPP1)/A(NPP1,J).GT.ZERO)   GOTO 160
  150 A(NPP1,J)=ASAVE
      W(J)=ZERO
                                      GOTO 130
C STEP FIVE (ADD COLUMN)

  160 CALL DCOPY(M,Z,1,B,1)
      INDEX(IZ)=INDEX(IZ1)
      INDEX(IZ1)=J
      IZ1=IZ1+1
      NSETP=NPP1
      NPP1=NPP1+1
      DO 170 JZ=IZ1,IZ2
         JJ=INDEX(JZ)
  170    CALL H12(2,NSETP,NPP1,M,A(1,J),1,UP,A(1,JJ),1,MDA,1)
      K=MIN(NPP1,MDA)
      W(J)=ZERO
      CALL DCOPY(M-NSETP,W(J),0,A(K,J),1)

C STEP SIX (SOLVE LEAST SQUARES SUB-PROBLEM)
C .....ENTRY LOOP B

  180 DO 200 IP=NSETP,1,-1
         IF(IP.EQ.NSETP)              GOTO 190
         CALL DAXPY(IP,-Z(IP+1),A(1,JJ),1,Z,1)
  190    JJ=INDEX(IP)
  200    Z(IP)=Z(IP)/A(IP,JJ)
      ITER=ITER+1
      IF(ITER.LE.ITMAX)               GOTO 220
  210 MODE=3
                                      GOTO 280
C STEP SEVEN TO TEN (STEP LENGTH ALGORITHM)

  220 ALPHA=ONE
      JJ=0
      DO 230 IP=1,NSETP
         IF(Z(IP).GT.ZERO)            GOTO 230
         L=INDEX(IP)
         T=-X(L)/(Z(IP)-X(L))
         IF(ALPHA.LT.T)               GOTO 230
         ALPHA=T
         JJ=IP
  230 CONTINUE
      DO 240 IP=1,NSETP
         L=INDEX(IP)
  240    X(L)=(ONE-ALPHA)*X(L) + ALPHA*Z(IP)

C .....EXIT LOOP B

      IF(JJ.EQ.0)                     GOTO 110

C STEP ELEVEN (DELETE COLUMN)

      I=INDEX(JJ)
  250 X(I)=ZERO
      JJ=JJ+1
      DO 260 J=JJ,NSETP
         II=INDEX(J)
         INDEX(J-1)=II
         CALL DROTG(A(J-1,II),A(J,II),C,S)
         T=A(J-1,II)
         CALL DROT(N,A(J-1,1),MDA,A(J,1),MDA,C,S)
         A(J-1,II)=T
         A(J,II)=ZERO
  260    CALL DROT(1,B(J-1),1,B(J),1,C,S)
      NPP1=NSETP
      NSETP=NSETP-1
      IZ1=IZ1-1
      INDEX(IZ1)=I
      IF(NSETP.LE.0)                  GOTO 210
      DO 270 JJ=1,NSETP
         I=INDEX(JJ)
         IF(X(I).LE.ZERO)             GOTO 250
  270 CONTINUE
      CALL DCOPY(M,B,1,Z,1)
                                      GOTO 180
C STEP TWELVE (SOLUTION)

  280 K=MIN(NPP1,M)
      RNORM=DNRM2(M-NSETP,B(K),1)
      IF(NPP1.GT.M) THEN
         W(1)=ZERO
         CALL DCOPY(N,W(1),0,W,1)
      ENDIF

C END OF SUBROUTINE NNLS

  290                                 END

      SUBROUTINE HFTI(A,MDA,M,N,B,MDB,NB,TAU,KRANK,RNORM,H,G,IP)

C     RANK-DEFICIENT LEAST SQUARES ALGORITHM AS DESCRIBED IN:
C     C.L.LAWSON AND R.J.HANSON, JET PROPULSION LABORATORY, 1973 JUN 12
C     TO APPEAR IN 'SOLVING LEAST SQUARES PROBLEMS', PRENTICE-HALL, 1974

C     A(*,*),MDA,M,N   THE ARRAY A INITIALLY CONTAINS THE M x N MATRIX A
C                      OF THE LEAST SQUARES PROBLEM AX = B.
C                      THE FIRST DIMENSIONING PARAMETER MDA MUST SATISFY
C                      MDA >= M. EITHER M >= N OR M < N IS PERMITTED.
C                      THERE IS NO RESTRICTION ON THE RANK OF A.
C                      THE MATRIX A WILL BE MODIFIED BY THE SUBROUTINE.
C     B(*,*),MDB,NB    IF NB = 0 THE SUBROUTINE WILL MAKE NO REFERENCE
C                      TO THE ARRAY B. IF NB > 0 THE ARRAY B() MUST
C                      INITIALLY CONTAIN THE M x NB MATRIX B  OF THE
C                      THE LEAST SQUARES PROBLEM AX = B AND ON RETURN
C                      THE ARRAY B() WILL CONTAIN THE N x NB SOLUTION X.
C                      IF NB>1 THE ARRAY B() MUST BE DOUBLE SUBSCRIPTED
C                      WITH FIRST DIMENSIONING PARAMETER MDB>=MAX(M,N),
C                      IF NB=1 THE ARRAY B() MAY BE EITHER SINGLE OR
C                      DOUBLE SUBSCRIPTED.
C     TAU              ABSOLUTE TOLERANCE PARAMETER FOR PSEUDORANK
C                      DETERMINATION, PROVIDED BY THE USER.
C     KRANK            PSEUDORANK OF A, SET BY THE SUBROUTINE.
C     RNORM            ON EXIT, RNORM(J) WILL CONTAIN THE EUCLIDIAN
C                      NORM OF THE RESIDUAL VECTOR FOR THE PROBLEM
C                      DEFINED BY THE J-TH COLUMN VECTOR OF THE ARRAY B.
C     H(), G()         ARRAYS OF WORKING SPACE OF LENGTH >= N.
C     IP()             INTEGER ARRAY OF WORKING SPACE OF LENGTH >= N
C                      RECORDING PERMUTATION INDICES OF COLUMN VECTORS

      INTEGER          I,J,JB,K,KP1,KRANK,L,LDIAG,LMAX,M,
     .                 MDA,MDB,N,NB,IP(N)
      DOUBLE PRECISION A(MDA,N),B(MDB,NB),H(N),G(N),RNORM(NB),FACTOR,
     .                 TAU,ZERO,HMAX,DIFF,TMP,DDOT,DNRM2,U,V
      DIFF(U,V)=       U-V
      DATA             ZERO/0.0D0/, FACTOR/1.0D-3/

      K=0
      LDIAG=MIN(M,N)
      IF(LDIAG.LE.0)                  GOTO 270

C   COMPUTE LMAX

      DO 80 J=1,LDIAG
          IF(J.EQ.1)                  GOTO 20
          LMAX=J
          DO 10 L=J,N
              H(L)=H(L)-A(J-1,L)**2
   10         IF(H(L).GT.H(LMAX)) LMAX=L
          IF(DIFF(HMAX+FACTOR*H(LMAX),HMAX).GT.ZERO)
     .                                GOTO 50
   20     LMAX=J
          DO 40 L=J,N
              H(L)=ZERO
              DO 30 I=J,M
   30             H(L)=H(L)+A(I,L)**2
   40         IF(H(L).GT.H(LMAX)) LMAX=L
          HMAX=H(LMAX)

C   COLUMN INTERCHANGES IF NEEDED

   50     IP(J)=LMAX
          IF(IP(J).EQ.J)              GOTO 70
          DO 60 I=1,M
              TMP=A(I,J)
              A(I,J)=A(I,LMAX)
   60         A(I,LMAX)=TMP
          H(LMAX)=H(J)

C   J-TH TRANSFORMATION AND APPLICATION TO A AND B

   70     I=MIN(J+1,N)
          CALL H12(1,J,J+1,M,A(1,J),1,H(J),A(1,I),1,MDA,N-J)
   80     CALL H12(2,J,J+1,M,A(1,J),1,H(J),B,1,MDB,NB)

C   DETERMINE PSEUDORANK

      DO 90 J=1,LDIAG
   90     IF(ABS(A(J,J)).LE.TAU)      GOTO 100
      K=LDIAG
      GOTO 110
  100 K=J-1
  110 KP1=K+1

C   NORM OF RESIDUALS

      DO 130 JB=1,NB
  130     RNORM(JB)=DNRM2(M-K,B(KP1,JB),1)
      IF(K.GT.0)                      GOTO 160
      DO 150 JB=1,NB
          DO 150 I=1,N
  150         B(I,JB)=ZERO
      GOTO 270
  160 IF(K.EQ.N)                      GOTO 180

C   HOUSEHOLDER DECOMPOSITION OF FIRST K ROWS

      DO 170 I=K,1,-1
  170     CALL H12(1,I,KP1,N,A(I,1),MDA,G(I),A,MDA,1,I-1)
  180 DO 250 JB=1,NB

C   SOLVE K*K TRIANGULAR SYSTEM

          DO 210 I=K,1,-1
              J=MIN(I+1,N)
  210         B(I,JB)=(B(I,JB)-DDOT(K-I,A(I,J),MDA,B(J,JB),1))/A(I,I)

C   COMPLETE SOLUTION VECTOR

          IF(K.EQ.N)                  GOTO 240
          DO 220 J=KP1,N
  220         B(J,JB)=ZERO
          DO 230 I=1,K
  230         CALL H12(2,I,KP1,N,A(I,1),MDA,G(I),B(1,JB),1,MDB,1)

C   REORDER SOLUTION ACCORDING TO PREVIOUS COLUMN INTERCHANGES

  240     DO 250 J=LDIAG,1,-1
              IF(IP(J).EQ.J)          GOTO 250
              L=IP(J)
              TMP=B(L,JB)
              B(L,JB)=B(J,JB)
              B(J,JB)=TMP
  250 CONTINUE
  270 KRANK=K
      END

      SUBROUTINE H12 (MODE,LPIVOT,L1,M,U,IUE,UP,C,ICE,ICV,NCV)

C     C.L.LAWSON AND R.J.HANSON, JET PROPULSION LABORATORY, 1973 JUN 12
C     TO APPEAR IN 'SOLVING LEAST SQUARES PROBLEMS', PRENTICE-HALL, 1974

C     CONSTRUCTION AND/OR APPLICATION OF A SINGLE
C     HOUSEHOLDER TRANSFORMATION  Q = I + U*(U**T)/B

C     MODE    = 1 OR 2   TO SELECT ALGORITHM  H1  OR  H2 .
C     LPIVOT IS THE INDEX OF THE PIVOT ELEMENT.
C     L1,M   IF L1 <= M   THE TRANSFORMATION WILL BE CONSTRUCTED TO
C            ZERO ELEMENTS INDEXED FROM L1 THROUGH M.
C            IF L1 > M THE SUBROUTINE DOES AN IDENTITY TRANSFORMATION.
C     U(),IUE,UP
C            ON ENTRY TO H1 U() STORES THE PIVOT VECTOR.
C            IUE IS THE STORAGE INCREMENT BETWEEN ELEMENTS.
C            ON EXIT FROM H1 U() AND UP STORE QUANTITIES DEFINING
C            THE VECTOR U OF THE HOUSEHOLDER TRANSFORMATION.
C            ON ENTRY TO H2 U() AND UP
C            SHOULD STORE QUANTITIES PREVIOUSLY COMPUTED BY H1.
C            THESE WILL NOT BE MODIFIED BY H2.
C     C()    ON ENTRY TO H1 OR H2 C() STORES A MATRIX WHICH WILL BE
C            REGARDED AS A SET OF VECTORS TO WHICH THE HOUSEHOLDER
C            TRANSFORMATION IS TO BE APPLIED.
C            ON EXIT C() STORES THE SET OF TRANSFORMED VECTORS.
C     ICE    STORAGE INCREMENT BETWEEN ELEMENTS OF VECTORS IN C().
C     ICV    STORAGE INCREMENT BETWEEN VECTORS IN C().
C     NCV    NUMBER OF VECTORS IN C() TO BE TRANSFORMED.
C            IF NCV <= 0 NO OPERATIONS WILL BE DONE ON C().

      INTEGER          INCR, ICE, ICV, IUE, LPIVOT, L1, MODE, NCV
      INTEGER          I, I2, I3, I4, J, M
      DOUBLE PRECISION U,UP,C,CL,CLINV,B,SM,ONE,ZERO
      DIMENSION        U(IUE,*), C(*)
      DATA             ONE/1.0D+00/, ZERO/0.0D+00/

      IF (0.GE.LPIVOT.OR.LPIVOT.GE.L1.OR.L1.GT.M) GOTO 80
      CL=ABS(U(1,LPIVOT))
      IF (MODE.EQ.2)                              GOTO 30

C     ****** CONSTRUCT THE TRANSFORMATION ******

          DO 10 J=L1,M
             SM=ABS(U(1,J))
   10     CL=MAX(SM,CL)
      IF (CL.LE.ZERO)                             GOTO 80
      CLINV=ONE/CL
      SM=(U(1,LPIVOT)*CLINV)**2
          DO 20 J=L1,M
   20     SM=SM+(U(1,J)*CLINV)**2
      CL=CL*SQRT(SM)
      IF (U(1,LPIVOT).GT.ZERO) CL=-CL
      UP=U(1,LPIVOT)-CL
      U(1,LPIVOT)=CL
                                                  GOTO 40
C     ****** APPLY THE TRANSFORMATION  I+U*(U**T)/B  TO C ******

   30 IF (CL.LE.ZERO)                             GOTO 80
   40 IF (NCV.LE.0)                               GOTO 80
      B=UP*U(1,LPIVOT)
      IF (B.GE.ZERO)                              GOTO 80
      B=ONE/B
      I2=1-ICV+ICE*(LPIVOT-1)
      INCR=ICE*(L1-LPIVOT)
          DO 70 J=1,NCV
          I2=I2+ICV
          I3=I2+INCR
          I4=I3
          SM=C(I2)*UP
              DO 50 I=L1,M
              SM=SM+C(I3)*U(1,I)
   50         I3=I3+ICE
          IF (SM.EQ.ZERO)                         GOTO 70
          SM=SM*B
          C(I2)=C(I2)+SM*UP
              DO 60 I=L1,M
              C(I4)=C(I4)+SM*U(1,I)
   60         I4=I4+ICE
   70     CONTINUE
   80                                             END

      SUBROUTINE LDL (N,A,Z,SIGMA,W)
C   LDL     LDL' - RANK-ONE - UPDATE

C   PURPOSE:
C           UPDATES THE LDL' FACTORS OF MATRIX A BY RANK-ONE MATRIX
C           SIGMA*Z*Z'

C   INPUT ARGUMENTS: (* MEANS PARAMETERS ARE CHANGED DURING EXECUTION)
C     N     : ORDER OF THE COEFFICIENT MATRIX A
C   * A     : POSITIVE DEFINITE MATRIX OF DIMENSION N;
C             ONLY THE LOWER TRIANGLE IS USED AND IS STORED COLUMN BY
C             COLUMN AS ONE DIMENSIONAL ARRAY OF DIMENSION N*(N+1)/2.
C   * Z     : VECTOR OF DIMENSION N OF UPDATING ELEMENTS
C     SIGMA : SCALAR FACTOR BY WHICH THE MODIFYING DYADE Z*Z' IS
C             MULTIPLIED

C   OUTPUT ARGUMENTS:
C     A     : UPDATED LDL' FACTORS

C   WORKING ARRAY:
C     W     : VECTOR OP DIMENSION N (USED ONLY IF SIGMA .LT. ZERO)

C   METHOD:
C     THAT OF FLETCHER AND POWELL AS DESCRIBED IN :
C     FLETCHER,R.,(1974) ON THE MODIFICATION OF LDL' FACTORIZATION.
C     POWELL,M.J.D.      MATH.COMPUTATION 28, 1067-1078.

C   IMPLEMENTED BY:
C     KRAFT,D., DFVLR - INSTITUT FUER DYNAMIK DER FLUGSYSTEME
C               D-8031  OBERPFAFFENHOFEN

C   STATUS: 15. JANUARY 1980

C   SUBROUTINES REQUIRED: NONE

      INTEGER          I, IJ, J, N
      DOUBLE PRECISION A(*), T, V, W(*), Z(*), U, TP, ONE, BETA, FOUR,
     *                 ZERO, ALPHA, DELTA, GAMMA, SIGMA, EPMACH
      DATA ZERO, ONE, FOUR, EPMACH /0.0D0, 1.0D0, 4.0D0, 2.22D-16/

      IF(SIGMA.EQ.ZERO)               GOTO 280
      IJ=1
      T=ONE/SIGMA
      IF(SIGMA.GT.ZERO)               GOTO 220
C PREPARE NEGATIVE UPDATE
      DO 150 I=1,N
  150     W(I)=Z(I)
      DO 170 I=1,N
          V=W(I)
          T=T+V*V/A(IJ)
          DO 160 J=I+1,N
              IJ=IJ+1
  160         W(J)=W(J)-V*A(IJ)
  170     IJ=IJ+1
      IF(T.GE.ZERO) T=EPMACH/SIGMA
      DO 210 I=1,N
          J=N+1-I
          IJ=IJ-I
          U=W(J)
          W(J)=T
  210     T=T-U*U/A(IJ)
  220 CONTINUE
C HERE UPDATING BEGINS
      DO 270 I=1,N
          V=Z(I)
          DELTA=V/A(IJ)
          IF(SIGMA.LT.ZERO) TP=W(I)
          IF(SIGMA.GT.ZERO) TP=T+DELTA*V
          ALPHA=TP/T
          A(IJ)=ALPHA*A(IJ)
          IF(I.EQ.N)                  GOTO 280
          BETA=DELTA/TP
          IF(ALPHA.GT.FOUR)           GOTO 240
          DO 230 J=I+1,N
              IJ=IJ+1
              Z(J)=Z(J)-V*A(IJ)
  230         A(IJ)=A(IJ)+BETA*Z(J)
                                      GOTO 260
  240     GAMMA=T/TP
          DO 250 J=I+1,N
              IJ=IJ+1
              U=A(IJ)
              A(IJ)=GAMMA*U+BETA*Z(J)
  250         Z(J)=Z(J)-V*U
  260     IJ=IJ+1
  270     T=TP
  280 RETURN
C END OF LDL
      END

      DOUBLE PRECISION FUNCTION LINMIN (MODE, AX, BX, F, TOL)
C   LINMIN  LINESEARCH WITHOUT DERIVATIVES

C   PURPOSE:

C  TO FIND THE ARGUMENT LINMIN WHERE THE FUNCTION F TAKES IT'S MINIMUM
C  ON THE INTERVAL AX, BX.
C  COMBINATION OF GOLDEN SECTION AND SUCCESSIVE QUADRATIC INTERPOLATION.

C   INPUT ARGUMENTS: (* MEANS PARAMETERS ARE CHANGED DURING EXECUTION)

C *MODE   SEE OUTPUT ARGUMENTS
C  AX     LEFT ENDPOINT OF INITIAL INTERVAL
C  BX     RIGHT ENDPOINT OF INITIAL INTERVAL
C  F      FUNCTION VALUE AT LINMIN WHICH IS TO BE BROUGHT IN BY
C         REVERSE COMMUNICATION CONTROLLED BY MODE
C  TOL    DESIRED LENGTH OF INTERVAL OF UNCERTAINTY OF FINAL RESULT

C   OUTPUT ARGUMENTS:

C  LINMIN ABSCISSA APPROXIMATING THE POINT WHERE F ATTAINS A MINIMUM
C  MODE   CONTROLS REVERSE COMMUNICATION
C         MUST BE SET TO 0 INITIALLY, RETURNS WITH INTERMEDIATE
C         VALUES 1 AND 2 WHICH MUST NOT BE CHANGED BY THE USER,
C         ENDS WITH CONVERGENCE WITH VALUE 3.

C   WORKING ARRAY:

C  NONE

C   METHOD:

C  THIS FUNCTION SUBPROGRAM IS A SLIGHTLY MODIFIED VERSION OF THE
C  ALGOL 60 PROCEDURE LOCALMIN GIVEN IN
C  R.P. BRENT: ALGORITHMS FOR MINIMIZATION WITHOUT DERIVATIVES,
C              PRENTICE-HALL (1973).

C   IMPLEMENTED BY:

C     KRAFT, D., DFVLR - INSTITUT FUER DYNAMIK DER FLUGSYSTEME
C                D-8031  OBERPFAFFENHOFEN

C   STATUS: 31. AUGUST  1984

C   SUBROUTINES REQUIRED: NONE

      INTEGER          MODE
      DOUBLE PRECISION F, TOL, A, B, C, D, E, P, Q, R, U, V, W, X, M,
     &                 FU, FV, FW, FX, EPS, TOL1, TOL2, ZERO, AX, BX
      DATA             C /0.381966011D0/, EPS /1.5D-8/, ZERO /0.0D0/

C  EPS = SQUARE - ROOT OF MACHINE PRECISION
C  C = GOLDEN SECTION RATIO = (3-SQRT(5))/2

      GOTO (10, 55), MODE

C  INITIALIZATION

      A = AX
      B = BX
      E = ZERO
      V = A + C*(B - A)
      W = V
      X = W
      LINMIN = X
      MODE = 1
      GOTO 100

C  MAIN LOOP STARTS HERE

   10 FX = F
      FV = FX
      FW = FV
   20 M = 0.5D0*(A + B)
      TOL1 = EPS*ABS(X) + TOL
      TOL2 = TOL1 + TOL1

C  TEST CONVERGENCE

      IF (ABS(X - M) .LE. TOL2 - 0.5D0*(B - A)) GOTO 90
      R = ZERO
      Q = R
      P = Q
      IF (ABS(E) .LE. TOL1) GOTO 30

C  FIT PARABOLA

      R = (X - W)*(FX - FV)
      Q = (X - V)*(FX - FW)
      P = (X - V)*Q - (X - W)*R
      Q = Q - R
      Q = Q + Q
      IF (Q .GT. ZERO) P = -P
      IF (Q .LT. ZERO) Q = -Q
      R = E
      E = D

C  IS PARABOLA ACCEPTABLE

   30 IF (ABS(P) .GE. 0.5D0*ABS(Q*R) .OR.
     &    P .LE. Q*(A - X) .OR. P .GE. Q*(B-X)) GOTO 40

C  PARABOLIC INTERPOLATION STEP

      D = P/Q

C  F MUST NOT BE EVALUATED TOO CLOSE TO A OR B

      IF (U - A .LT. TOL2) D = SIGN(TOL1, M - X)
      IF (B - U .LT. TOL2) D = SIGN(TOL1, M - X)
      GOTO 50

C  GOLDEN SECTION STEP

   40 IF (X .GE. M) E = A - X
      IF (X .LT. M) E = B - X
      D = C*E

C  F MUST NOT BE EVALUATED TOO CLOSE TO X

   50 IF (ABS(D) .LT. TOL1) D = SIGN(TOL1, D)
      U = X + D
      LINMIN = U
      MODE = 2
      GOTO 100
   55 FU = F

C  UPDATE A, B, V, W, AND X

      IF (FU .GT. FX) GOTO 60
      IF (U .GE. X) A = X
      IF (U .LT. X) B = X
      V = W
      FV = FW
      W = X
      FW = FX
      X = U
      FX = FU
      GOTO 85
   60 IF (U .LT. X) A = U
      IF (U .GE. X) B = U
      IF (FU .LE. FW .OR. W .EQ. X) GOTO 70
      IF (FU .LE. FV .OR. V .EQ. X .OR. V .EQ. W) GOTO 80
      GOTO 85
   70 V = W
      FV = FW
      W = U
      FW = FU
      GOTO 85
   80 V = U
      FV = FU
   85 GOTO 20

C  END OF MAIN LOOP

   90 LINMIN = X
      MODE = 3
  100 RETURN

C  END OF LINMIN

      END

C## Following a selection from BLAS Level 1

      SUBROUTINE DAXPY(N,DA,DX,INCX,DY,INCY)

C     CONSTANT TIMES A VECTOR PLUS A VECTOR.
C     USES UNROLLED LOOPS FOR INCREMENTS EQUAL TO ONE.
C     JACK DONGARRA, LINPACK, 3/11/78.

      DOUBLE PRECISION DX(*),DY(*),DA
      INTEGER I,INCX,INCY,IX,IY,M,MP1,N

      IF(N.LE.0)RETURN
      IF(DA.EQ.0.0D0)RETURN
      IF(INCX.EQ.1.AND.INCY.EQ.1)GO TO 20

C        CODE FOR UNEQUAL INCREMENTS OR EQUAL INCREMENTS
C        NOT EQUAL TO 1

      IX = 1
      IY = 1
      IF(INCX.LT.0)IX = (-N+1)*INCX + 1
      IF(INCY.LT.0)IY = (-N+1)*INCY + 1
      DO 10 I = 1,N
        DY(IY) = DY(IY) + DA*DX(IX)
        IX = IX + INCX
        IY = IY + INCY
   10 CONTINUE
      RETURN

C        CODE FOR BOTH INCREMENTS EQUAL TO 1

C        CLEAN-UP LOOP

   20 M = MOD(N,4)
      IF( M .EQ. 0 ) GO TO 40
      DO 30 I = 1,M
        DY(I) = DY(I) + DA*DX(I)
   30 CONTINUE
      IF( N .LT. 4 ) RETURN
   40 MP1 = M + 1
      DO 50 I = MP1,N,4
        DY(I) = DY(I) + DA*DX(I)
        DY(I + 1) = DY(I + 1) + DA*DX(I + 1)
        DY(I + 2) = DY(I + 2) + DA*DX(I + 2)
        DY(I + 3) = DY(I + 3) + DA*DX(I + 3)
   50 CONTINUE
      RETURN
      END

      SUBROUTINE  DCOPY(N,DX,INCX,DY,INCY)

C     COPIES A VECTOR, X, TO A VECTOR, Y.
C     USES UNROLLED LOOPS FOR INCREMENTS EQUAL TO ONE.
C     JACK DONGARRA, LINPACK, 3/11/78.

      DOUBLE PRECISION DX(*),DY(*)
      INTEGER I,INCX,INCY,IX,IY,M,MP1,N

      IF(N.LE.0)RETURN
      IF(INCX.EQ.1.AND.INCY.EQ.1)GO TO 20

C        CODE FOR UNEQUAL INCREMENTS OR EQUAL INCREMENTS
C        NOT EQUAL TO 1

      IX = 1
      IY = 1
      IF(INCX.LT.0)IX = (-N+1)*INCX + 1
      IF(INCY.LT.0)IY = (-N+1)*INCY + 1
      DO 10 I = 1,N
        DY(IY) = DX(IX)
        IX = IX + INCX
        IY = IY + INCY
   10 CONTINUE
      RETURN

C        CODE FOR BOTH INCREMENTS EQUAL TO 1

C        CLEAN-UP LOOP

   20 M = MOD(N,7)
      IF( M .EQ. 0 ) GO TO 40
      DO 30 I = 1,M
        DY(I) = DX(I)
   30 CONTINUE
      IF( N .LT. 7 ) RETURN
   40 MP1 = M + 1
      DO 50 I = MP1,N,7
        DY(I) = DX(I)
        DY(I + 1) = DX(I + 1)
        DY(I + 2) = DX(I + 2)
        DY(I + 3) = DX(I + 3)
        DY(I + 4) = DX(I + 4)
        DY(I + 5) = DX(I + 5)
        DY(I + 6) = DX(I + 6)
   50 CONTINUE
      RETURN
      END

      DOUBLE PRECISION FUNCTION DDOT(N,DX,INCX,DY,INCY)

C     FORMS THE DOT PRODUCT OF TWO VECTORS.
C     USES UNROLLED LOOPS FOR INCREMENTS EQUAL TO ONE.
C     JACK DONGARRA, LINPACK, 3/11/78.

      DOUBLE PRECISION DX(*),DY(*),DTEMP
      INTEGER I,INCX,INCY,IX,IY,M,MP1,N

      DDOT = 0.0D0
      DTEMP = 0.0D0
      IF(N.LE.0)RETURN
      IF(INCX.EQ.1.AND.INCY.EQ.1)GO TO 20

C        CODE FOR UNEQUAL INCREMENTS OR EQUAL INCREMENTS
C          NOT EQUAL TO 1

      IX = 1
      IY = 1
      IF(INCX.LT.0)IX = (-N+1)*INCX + 1
      IF(INCY.LT.0)IY = (-N+1)*INCY + 1
      DO 10 I = 1,N
        DTEMP = DTEMP + DX(IX)*DY(IY)
        IX = IX + INCX
        IY = IY + INCY
   10 CONTINUE
      DDOT = DTEMP
      RETURN

C        CODE FOR BOTH INCREMENTS EQUAL TO 1

C        CLEAN-UP LOOP

   20 M = MOD(N,5)
      IF( M .EQ. 0 ) GO TO 40
      DO 30 I = 1,M
        DTEMP = DTEMP + DX(I)*DY(I)
   30 CONTINUE
      IF( N .LT. 5 ) GO TO 60
   40 MP1 = M + 1
      DO 50 I = MP1,N,5
        DTEMP = DTEMP + DX(I)*DY(I) + DX(I + 1)*DY(I + 1) +
     *   DX(I + 2)*DY(I + 2) + DX(I + 3)*DY(I + 3) + DX(I + 4)*DY(I + 4)
   50 CONTINUE
   60 DDOT = DTEMP
      RETURN
      END

      DOUBLE PRECISION FUNCTION DNRM1(N,X,I,J)
      INTEGER N, I, J, K
      DOUBLE PRECISION SNORMX, SUM, X(N), ZERO, ONE, SCALE, TEMP
      DATA ZERO/0.0D0/, ONE/1.0D0/

C      DNRM1 - COMPUTES THE I-NORM OF A VECTOR
C              BETWEEN THE ITH AND THE JTH ELEMENTS

C      INPUT -
C      N       LENGTH OF VECTOR
C      X       VECTOR OF LENGTH N
C      I       INITIAL ELEMENT OF VECTOR TO BE USED
C      J       FINAL ELEMENT TO USE

C      OUTPUT -
C      DNRM1   NORM

      SNORMX=ZERO
      DO 10 K=I,J
 10      SNORMX=MAX(SNORMX,ABS(X(K)))
      DNRM1 = SNORMX
      IF (SNORMX.EQ.ZERO) RETURN
      SCALE = SNORMX
      IF (SNORMX.GE.ONE) SCALE=SQRT(SNORMX)
      SUM=ZERO
      DO 20 K=I,J
         TEMP=ZERO
         IF (ABS(X(K))+SCALE .NE. SCALE) TEMP = X(K)/SNORMX
         IF (ONE+TEMP.NE.ONE) SUM = SUM+TEMP*TEMP
 20      CONTINUE
      SUM=SQRT(SUM)
      DNRM1=SNORMX*SUM
      RETURN
      END

      DOUBLE PRECISION FUNCTION DNRM2 ( N, DX, INCX)
      INTEGER          N, I, J, NN, NEXT, INCX
      DOUBLE PRECISION DX(*), CUTLO, CUTHI, HITEST, SUM, XMAX, ZERO, ONE
      DATA             ZERO, ONE /0.0D0, 1.0D0/

C     EUCLIDEAN NORM OF THE N-VECTOR STORED IN DX() WITH STORAGE
C     INCREMENT INCX .
C     IF    N .LE. 0 RETURN WITH RESULT = 0.
C     IF N .GE. 1 THEN INCX MUST BE .GE. 1

C           C.L.LAWSON, 1978 JAN 08

C     FOUR PHASE METHOD     USING TWO BUILT-IN CONSTANTS THAT ARE
C     HOPEFULLY APPLICABLE TO ALL MACHINES.
C         CUTLO = MAXIMUM OF  SQRT(U/EPS)   OVER ALL KNOWN MACHINES.
C         CUTHI = MINIMUM OF  SQRT(V)       OVER ALL KNOWN MACHINES.
C     WHERE
C         EPS = SMALLEST NO. SUCH THAT EPS + 1. .GT. 1.
C         U   = SMALLEST POSITIVE NO.   (UNDERFLOW LIMIT)
C         V   = LARGEST  NO.            (OVERFLOW  LIMIT)

C     BRIEF OUTLINE OF ALGORITHM..

C     PHASE 1    SCANS ZERO COMPONENTS.
C     MOVE TO PHASE 2 WHEN A COMPONENT IS NONZERO AND .LE. CUTLO
C     MOVE TO PHASE 3 WHEN A COMPONENT IS .GT. CUTLO
C     MOVE TO PHASE 4 WHEN A COMPONENT IS .GE. CUTHI/M
C     WHERE M = N FOR X() REAL AND M = 2*N FOR COMPLEX.

C     VALUES FOR CUTLO AND CUTHI..
C     FROM THE ENVIRONMENTAL PARAMETERS LISTED IN THE IMSL CONVERTER
C     DOCUMENT THE LIMITING VALUES ARE AS FOLLOWS..
C     CUTLO, S.P.   U/EPS = 2**(-102) FOR  HONEYWELL.  CLOSE SECONDS ARE
C                   UNIVAC AND DEC AT 2**(-103)
C                   THUS CUTLO = 2**(-51) = 4.44089E-16
C     CUTHI, S.P.   V = 2**127 FOR UNIVAC, HONEYWELL, AND DEC.
C                   THUS CUTHI = 2**(63.5) = 1.30438E19
C     CUTLO, D.P.   U/EPS = 2**(-67) FOR HONEYWELL AND DEC.
C                   THUS CUTLO = 2**(-33.5) = 8.23181D-11
C     CUTHI, D.P.   SAME AS S.P.  CUTHI = 1.30438D19
C     DATA CUTLO, CUTHI / 8.232D-11,  1.304D19 /
C     DATA CUTLO, CUTHI / 4.441E-16,  1.304E19 /
      DATA CUTLO, CUTHI / 8.232D-11,  1.304D19 /

      IF(N .GT. 0) GO TO 10
         DNRM2  = ZERO
         GO TO 300

   10 ASSIGN 30 TO NEXT
      SUM = ZERO
      NN = N * INCX
C                       BEGIN MAIN LOOP
      I = 1
   20    GO TO NEXT,(30, 50, 70, 110)
   30 IF( ABS(DX(I)) .GT. CUTLO) GO TO 85
      ASSIGN 50 TO NEXT
      XMAX = ZERO

C                        PHASE 1.  SUM IS ZERO

   50 IF( DX(I) .EQ. ZERO) GO TO 200
      IF( ABS(DX(I)) .GT. CUTLO) GO TO 85

C                        PREPARE FOR PHASE 2.

      ASSIGN 70 TO NEXT
      GO TO 105

C                        PREPARE FOR PHASE 4.

  100 I = J
      ASSIGN 110 TO NEXT
      SUM = (SUM / DX(I)) / DX(I)
  105 XMAX = ABS(DX(I))
      GO TO 115

C                   PHASE 2.  SUM IS SMALL.
C                             SCALE TO AVOID DESTRUCTIVE UNDERFLOW.

   70 IF( ABS(DX(I)) .GT. CUTLO ) GO TO 75

C                   COMMON CODE FOR PHASES 2 AND 4.
C                   IN PHASE 4 SUM IS LARGE.  SCALE TO AVOID OVERFLOW.

  110 IF( ABS(DX(I)) .LE. XMAX ) GO TO 115
         SUM = ONE + SUM * (XMAX / DX(I))**2
         XMAX = ABS(DX(I))
         GO TO 200

  115 SUM = SUM + (DX(I)/XMAX)**2
      GO TO 200

C                  PREPARE FOR PHASE 3.

   75 SUM = (SUM * XMAX) * XMAX

C     FOR REAL OR D.P. SET HITEST = CUTHI/N
C     FOR COMPLEX      SET HITEST = CUTHI/(2*N)

   85 HITEST = CUTHI/FLOAT( N )

C                   PHASE 3.  SUM IS MID-RANGE.  NO SCALING.

      DO 95 J =I,NN,INCX
      IF(ABS(DX(J)) .GE. HITEST) GO TO 100
   95    SUM = SUM + DX(J)**2
      DNRM2 = SQRT( SUM )
      GO TO 300

  200 CONTINUE
      I = I + INCX
      IF ( I .LE. NN ) GO TO 20

C              END OF MAIN LOOP.

C              COMPUTE SQUARE ROOT AND ADJUST FOR SCALING.

      DNRM2 = XMAX * SQRT(SUM)
  300 CONTINUE
      RETURN
      END

      SUBROUTINE  DROT (N,DX,INCX,DY,INCY,C,S)

C     APPLIES A PLANE ROTATION.
C     JACK DONGARRA, LINPACK, 3/11/78.

      DOUBLE PRECISION DX(*),DY(*),DTEMP,C,S
      INTEGER I,INCX,INCY,IX,IY,N

      IF(N.LE.0)RETURN
      IF(INCX.EQ.1.AND.INCY.EQ.1)GO TO 20

C       CODE FOR UNEQUAL INCREMENTS OR EQUAL INCREMENTS NOT EQUAL
C         TO 1

      IX = 1
      IY = 1
      IF(INCX.LT.0)IX = (-N+1)*INCX + 1
      IF(INCY.LT.0)IY = (-N+1)*INCY + 1
      DO 10 I = 1,N
        DTEMP = C*DX(IX) + S*DY(IY)
        DY(IY) = C*DY(IY) - S*DX(IX)
        DX(IX) = DTEMP
        IX = IX + INCX
        IY = IY + INCY
   10 CONTINUE
      RETURN

C       CODE FOR BOTH INCREMENTS EQUAL TO 1

   20 DO 30 I = 1,N
        DTEMP = C*DX(I) + S*DY(I)
        DY(I) = C*DY(I) - S*DX(I)
        DX(I) = DTEMP
   30 CONTINUE
      RETURN
      END

      SUBROUTINE DROTG(DA,DB,C,S)

C     CONSTRUCT GIVENS PLANE ROTATION.
C     JACK DONGARRA, LINPACK, 3/11/78.
C                    MODIFIED 9/27/86.

      DOUBLE PRECISION DA,DB,C,S,ROE,SCALE,R,Z,ONE,ZERO
      DATA ONE, ZERO /1.0D+00, 0.0D+00/

      ROE = DB
      IF( ABS(DA) .GT. ABS(DB) ) ROE = DA
      SCALE = ABS(DA) + ABS(DB)
      IF( SCALE .NE. ZERO ) GO TO 10
         C = ONE
         S = ZERO
         R = ZERO
         GO TO 20
   10 R = SCALE*SQRT((DA/SCALE)**2 + (DB/SCALE)**2)
      R = SIGN(ONE,ROE)*R
      C = DA/R
      S = DB/R
   20 Z = S
      IF( ABS(C) .GT. ZERO .AND. ABS(C) .LE. S ) Z = ONE/C
      DA = R
      DB = Z
      RETURN
      END

      SUBROUTINE  DSCAL(N,DA,DX,INCX)

C     SCALES A VECTOR BY A CONSTANT.
C     USES UNROLLED LOOPS FOR INCREMENT EQUAL TO ONE.
C     JACK DONGARRA, LINPACK, 3/11/78.

      DOUBLE PRECISION DA,DX(*)
      INTEGER I,INCX,M,MP1,N,NINCX

      IF(N.LE.0)RETURN
      IF(INCX.EQ.1)GO TO 20


C        CODE FOR INCREMENT NOT EQUAL TO 1

      NINCX = N*INCX
      DO 10 I = 1,NINCX,INCX
        DX(I) = DA*DX(I)
   10 CONTINUE
      RETURN

C        CODE FOR INCREMENT EQUAL TO 1

C        CLEAN-UP LOOP

   20 M = MOD(N,5)
      IF( M .EQ. 0 ) GO TO 40
      DO 30 I = 1,M
        DX(I) = DA*DX(I)
   30 CONTINUE
      IF( N .LT. 5 ) RETURN
   40 MP1 = M + 1
      DO 50 I = MP1,N,5
        DX(I) = DA*DX(I)
        DX(I + 1) = DA*DX(I + 1)
        DX(I + 2) = DA*DX(I + 2)
        DX(I + 3) = DA*DX(I + 3)
        DX(I + 4) = DA*DX(I + 4)
   50 CONTINUE
      RETURN
      END



************************************************************************
*       test driver for TOMP optimal control calculations              *
*     state inequality constrained brachistochrone problem             *
************************************************************************

*     np = number of design parameters
*     nu = number of control functions
*     nm = interpolation mode (4 = spline under tension)
*     ny = number of communication points
*     (at the respective knots the state constraints are evaluated)
*     nc = number of knots of control discretization
*     nz = number of state variables (differential equations)
*     me = number of equality constraints
*     m  = total number of constraints
*     n  = total number of variables
*     nx = length of vector used for interpolation (see spline)
*     lw, ljw = length of working arrays for subroutine slsqp

      parameter        (np=1, nu=1, nm=4, ny=21, nc=21, nz=3, me=1)
      parameter        (n=np+nu*nc, nx=np+6*nu*nc, m=me+ny-2)
*     the following parameter declaration is for the
*     unconstrained problem
*     parameter        (n=np+nu*nc, nx=np+6*nu*nc, m=me     )
      parameter        (n1=n+1, meq=me, mineq=m-meq+n1+n1)
      parameter        (len_w=
     $                  (3*n1+m)*(n1+1)
     $                 +(n1-meq+1)*(mineq+2) + 2*mineq
     $                 +(n1+mineq)*(n1-meq) + 2*meq + n1
     $                 +(n+1)*n/2 + 2*m + 3*n + 3*n1 + 1,
     $                  len_jw=mineq)
      parameter        (lw=len_w, ljw=len_jw)
      integer          iv(20), jw(ljw)

      double precision x(nx), y(ny), z(nz), za(nz), zb(nz),
     1                 c(m), df(n1), dc(m,n1), w(lw),
     2                 xl(n), xu(n), dfloat, acc, ac1, f, h

      external         rk87, bra, vbra, obra

*     elements of vector iv are explained in subroutine d_tomp
      data             iv/nc,nm,0,0,0,0,0,0,0,0,0,0,
     1                    np,nu,ny,nz,m,1,0,110/


      do 1, i=1,nc
*     initial control parameters set to zero
*     and bounds
      xl(i)=0.0d0
      x (i)=0.0d0
      xu(i)=2.0d0
      j=nc+np+i
*     nc equidistant control points
*     the time interval is normalized
*     to  0 .le. t .le. 1
*     therefore dz must be multiplied by tf in subroutine bra
      x(j)=dfloat(i-1)/dfloat(nc-1)
      k=nc+nc+np+i
*     tension parameters
      x(k)=0.0d0
      if (i.gt.6 .and. i.lt.14) x(k)=1.0d3
    1 continue
*     initial design parameter (final time tf) set to two
*     and bounds
      xl(nc+np)=1.0d0
      x (nc+np)=2.0d0
      xu(nc+np)=2.0d0

*     ny equidistant communication points
      do 5, i=1,ny
    5 y(i)=dfloat(i-1)/dfloat(ny-1)
*     accuracy of optimizer
      acc = 1.0d-06
*     accuracy of simulator
      ac1 = 1.0d-08
*     itr iterations are allowed
      itr = 50
      mode = 0
      l = 19
      open (l, file = 'tomp.out')
      write(l,*) '    constrained brachistochrone problem'
      write(l,'(10h iteration, 16h  value of cost ,
     1 23h  constraint violations)')

c optimization loop (see fig.1 in accompanying VDI-report)

   10 iv(19) = mode
*     simulator
      call d_tomp (rk87,bra,vbra,obra,iv,x,y,z,za,zb,ac1,f,c,df,dc,m)
*     empty user interface
*     optimizer
      call slsqp(m,me,m,n,x,xl,xu,f,c,df,dc,acc,itr,mode,w,lw,jw,ljw)
      if (mode .eq. 0 .or. mode .eq. -1) then
          h=0.0d0
          do 15 i=1,m
          if (i.le.me) then
              h=h+c(i)**2
          else
              h=h+min(c(i),0.0d0)**2
          endif
   15     continue
*         print  iteration, cost function, norm of constraint violations
          write(l,'(3x,i3,4x,d16.8,5x,d12.4)') itr, f, sqrt(h)
      endif
      if (iabs(mode) .eq. 1) goto 10

c end of optimization loop

      write
     1    (l, '(5x,7hmode  =, i4, 8h   after , i3, 12h  iterations)')
     2    mode, itr
      close(l)

*     simulation of final solution with dense output
*     for graphical post-processing in MATLAB or RASP

      iv(19) = -2
      call d_tomp (rk87,bra,vbra,obra,iv,x,y,z,za,zb,ac1,f,c,df,dc,m)

*     results will be found in file TOMP.M
*     as appropriate MATLAB matrices for plotting
*     if MATLAB is available to you, just type
*     MATLAB
*     >tomp
*     >plot(x1,-x2), grid
*     (and you should see fig.2 of accompanying VDI-report on screen)

      end


      subroutine bra(t,z,dz,u,iu)
*     right hand sides of differential equations
*     of brachistochrone problem
      double precision t, z(*), dz(*), u(*)
      double precision g, theta(1), tf
      integer iu(20)
      data g/1.0d0/
      nc=iu(01)
      np=iu(13)
      tf=u(nc+np)
      call contrl(t,u,iu,theta)
*     the time interval is normalized
*     to  0 .le. t .le. 1
*     therefore dz must be multiplied by tf
      dz(1)=tf*z(3)*cos(theta(1))
      dz(2)=tf*z(3)*sin(theta(1))
      dz(3)=tf*g*sin(theta(1))
      end


      subroutine vbra(rhs,iu,t,u,y,z,z0,z1,w,f,c,mode)
*     boundary values, state constraints, and cost function
*     of brachistochrone problem
      double precision t,u(*),y(*),z(*),z0(*),z1(*),f,c(*),w(*)
      integer iu(20), mode
      external rhs
      save j

      nc=iu(01)
      np=iu(13)
      ny=iu(15)
      nz=iu(16)
      m =iu(17)

c boundary values
*     mode.eq.0 at start of each simulation
      if (mode.eq.0) then

         j=1

*        initial states
         z0(1)=0.0d0
         z0(2)=0.0d0
         z0(3)=0.0d0

*        final states (z1(2) & z1(3) are free)
         z1(1)=1.0d0
         z1(2)=0.0d0
         z1(3)=0.0d0

      end if

c state constraints
*     m.eq.1 means equality constrained problem only
      if (m.ne.1) then

*     mode.eq.1 and mode.eq.ny are covered by left and right boundary
         if (mode.gt.1 .and. mode.lt.ny) then
            j=j+1
            c(j)=0.2d0+0.4d0*z(1)-z(2)
         end if

      end if

c cost and final states
      if (mode.eq.ny) then

         f=u(nc+np)
*        c(j) for j=1 (equality constraints -- in our case one -- first)
         c(1)=z(1)-z1(1)

      end if
      end

      subroutine obra (t, k, g, l, n, z, u, iu)
*     trajectory data (time, states, and controls)
*     of brachistochrone problem
*     for possible output on screen or into file
      double precision  t, z(*), u(*)
      double precision  gam(1)
      real              g(l,*)
      integer           iu(*)

*     call contrl(t,u,iu,gam)
*     write(*,'(8(1pd10.2))') t, (z(i),i=1,2), gam(1)

      end

************************************************************************
*     end of test driver for TOMP optimal control calculations         *
*     state inequality constrained brachistochrone problem             *
************************************************************************
