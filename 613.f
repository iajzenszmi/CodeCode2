C     ALGORITHM 613, COLLECTED ALGORITHMS FROM ACM.
C     ALGORITHM APPEARED IN ACM-TRANS. MATH. SOFTWARE, VOL.10, NO. 1,
C     MAR., 1984, P. 108-111.
      INTEGER NV,NE,CMAX,NVP1,TCOST,I,                                  MAIN0010
     +        EPT(112),ELIST(999),ECOST(999),                           MAIN0020
     +        PRED(111),LABEL(111),                                     MAIN0030
     +        ADRS(9999),CHAIN(111)                                     MAIN0040
C                                                                       MAIN0050
C     THIS PROGRAM CALCULATES A MINIMUM SPANNING TREE (MST) FOR A       MAIN0060
C     CONNECTED UNDIRECTED GRAPH WHICH IS DESCRIBED IN A FORWARD STAR   MAIN0070
C     REPRESENTATION.  OUTPUT CONSISTS OF A PREDECESSOR ARRAY           MAIN0080
C     FOR THE MST ROOTED AT VERTEX 1 AND THE TOTAL COST OF THE MST.     MAIN0090
C     EDGE COSTS ARE POSITIVE INTEGERS IN THE RANGE 1 TO CMAX.          MAIN0100
C                                                                       MAIN0110
C                          NV  -  NUMBER OF VERTICES                    MAIN0120
C                          NE  -  NUMBER OF EDGES (EACH COUNTED TWICE)  MAIN0130
C                        CMAX  -  MAXIMUM EDGE COST                     MAIN0140
C                        NVP1  -  NUMBER OF VERTICES PLUS 1             MAIN0150
C                       TCOST  -  TOTAL COST OF MST                     MAIN0160
C EPT(NUMBER OF VERTICES + 1)  -  START OF EDGE LIST FOR EACH VERTEX    MAIN0170
C      ELIST(NUMBER OF EDGES)  -  EDGE LIST, VERTEX ADJACENCY LISTS     MAIN0180
C      ECOST(NUMBER OF EDGES)  -  EDGE COSTS                            MAIN0190
C    PRED(NUMBER OF VERTICES)  -  PREDECESSOR LIST                      MAIN0200
C   LABEL(NUMBER OF VERTICES)  -  VERTEX LABELS/ADDRESSES               MAIN0210
C     ADRS(MAXIMUM EDGE COST)  -  ADDRESS SPACE                         MAIN0220
C   CHAIN(NUMBER OF VERTICES)  -  LINKED LIST FOR ADDRESS SPACE OVERFL0WMAIN0230
C                                                                       MAIN0240
      INTEGER IUNIT,OUNIT    
!     IUNIT AND OUNIT Values changed from 1,3 to 5,6 by Ian Martin 
!      Ajzenszmidt of Melbourne Australia Tue March 2022. 
!                                                                       MAIN0250
!     DATA IUNIT,OUNIT /1,3/
      DATA IUNIT,OUNIT /5,6/                                            MAIN0260
C                                                                       MAIN0270
C                       IUNIT  -  INPUT UNIT FOR GRAPH                  MAIN0280
C                       OUNIT  -  OUTPUT UNIT FOR MST                   MAIN0290
C                                                                       MAIN0300
C     READ NUMBER OF VERTICES, NUMBER OF EDGES, MAX EDGE COST,          MAIN0310
C     FORWARD STAR DATA STRUCTURE FOR GRAPH.                            MAIN0320
C     FOR UNDIRECTED GRAPH, EACH EDGE APPEARS ONCE FOR EACH ENDPOINT.   MAIN0330
C     LAST EDGE POINTER SET TO DUMMY TO TERMINATE EDGE LIST.            MAIN0340
C                                                                       MAIN0350
      READ(IUNIT,100) NV,NE,CMAX                                        MAIN0360
      READ(IUNIT,100) (EPT(I),I=1,NV)                                   MAIN0370
      READ(IUNIT,100) (ELIST(I),I=1,NE)                                 MAIN0380
      READ(IUNIT,100) (ECOST(I),I=1,NE)                                 MAIN0390
      NVP1=NV+1                                                         MAIN0400
      EPT(NVP1)=NE+1                                                    MAIN0410
C                                                                       MAIN0420
      CALL MSTPAC(NV,NE,CMAX,NVP1,TCOST,                                MAIN0430
     +            EPT,ELIST,ECOST,PRED,LABEL,ADRS,CHAIN)                MAIN0440
C                                                                       MAIN0450
      WRITE(OUNIT,200) NV,NE,CMAX,TCOST                                 MAIN0460
      WRITE(OUNIT,201) (I,PRED(I),I=2,NV)                               MAIN0470
C                                                                       MAIN0480
      STOP                                                              MAIN0490
C                                                                       MAIN0500
 100  FORMAT(15I4)                                                      MAIN0510
 200  FORMAT(30H1NUMBER OF VERTICES-          ,I5/                      MAIN0520
     +       30H NUMBER OF (DIRECTED) EDGES-  ,I5/                      MAIN0530
     +       30H MAX EDGE COST-               ,I5/                      MAIN0540
     +       30H TOTAL COST OF MST-           ,I5)                      MAIN0550
 201  FORMAT(32H-EDGES IN MINIMUM SPANNING TREE-/                       MAIN0560
     +       20H0VERTEX  PREDECESSOR/(I7,I10))                          MAIN0570
      END                                                               MAIN0580
      SUBROUTINE MSTPAC(NV,NE,CMAX,NVP1,TCOST,                          MSTP0010
     +                  EPT,ELIST,ECOST,PRED,LABEL,ADRS,CHAIN)
C
C     THIS SUBROUTINE CALCULATES A MINIMUM SPANNING TREE (MST) FOR A
C     CONNECTED UNDIRECTED GRAPH REPRESENTED IN A FORWARD STAR
C     DATA STRUCTURE.  THIS MST IS OUTPUT AS A TREE ROOTED AT VERTEX 1
C     VIA A PREDECESSOR ARRAY.
C
C     ASSUMPTIONS-
C       1. NUMBER OF VERTICES (NV) IS GREATER THAN OR EQUAL TO 2
C       2. GRAPH G IS CONNECTED
C       3. FORWARD STAR REPRESENTATION OF G CONSISTS OF-
C           - STARTING POINT OF ADJACENCY LIST FOR EACH VERTEX (EPT)
C           - LIST OF VERTICES ADJACENT TO EACH VERTEX (ELIST)
C           - CORRESPONDING EDGE COSTS (ECOST)
C          NOTE THAT-
C           - NUMBER OF EDGES (NE) IS TWICE NUMBER OF EDGES OF
C                  (UNDIRECTED) G SINCE EACH VERTEX OF AN EDGE APPEARS
C                  IN THE ADJACENCY LIST OF THE OTHER
C           - ADJACENCY LIST FOR VERTEX I+1 IMMEDIATELY FOLLOWS
C                  THAT OF VERTEX I
C           - STARTING POINT OF DUMMY VERTEX NV+1 MUST BE SET TO
C                  DUMMY EDGE NE+1
C
      INTEGER NV,NE,CMAX,NVP1,TCOST,I,
     +        EPT(NVP1),ELIST(NE),ECOST(NE),
     +        PRED(NV),LABEL(NV),
     +        ADRS(CMAX),CHAIN(NV)
C
C     SUBROUTINE PARAMETERS-
C
C                          NV  -  NUMBER OF VERTICES
C                          NE  -  NUMBER OF EDGES (EACH COUNTED TWICE)
C                        CMAX  -  MAXIMUM EDGE COST
C                        NVP1  -  NUMBER OF VERTICES PLUS 1
C                       TCOST  -  TOTAL COST OF MST
C EPT(NUMBER OF VERTICES + 1)  -  START OF EDGE LIST
C      ELIST(NUMBER OF EDGES)  -  EDGE LIST, VERTEX ADJACENCY LISTS
C      ECOST(NUMBER OF EDGES)  -  EDGE COSTS
C    PRED(NUMBER OF VERTICES)  -  PREDECESSOR LIST
C   LABEL(NUMBER OF VERTICES)  -  VERTEX LABELS/ADDRESSES
C     ADRS(MAXIMUM EDGE COST)  -  ADDRESS SPACE
C   CHAIN(NUMBER OF VERTICES)  -  LINKED LIST FOR ADDRESS SPACE OVERFLOW
C
      INTEGER TOP,VERT,ADJ,NEXT,LAST,NEWLAB,OLDLAB,COUNT,HOLD,LINK,NULL
      DATA NULL/0/
C
C     LOCAL VARIABLES-
C
C            TOP  -  POSITION OF MIN LABEL VERTEX IN ADDRESS SPACE
C           VERT  -  VERTEX LAST ADDED TO MST
C            ADJ  -  VERTEX ADJACENT TO VERT
C           NEXT  -  POSITION OF ADJ IN ELIST
C           LAST  -  POSITION OF LAST VERTEX ADJACENT TO VERT IN ELIST
C         NEWLAB  -  POTENTIAL NEW LABEL FOR ADJ, CURRENT EDGE COST
C         OLDLAB  -  LAST LABEL RECORDED FOR ADJ
C          COUNT  -  NUMBER OF VERTICES IN CURRENT SUBTREE
C      HOLD,LINK  -  VARIABLES TO WALK OVERFLOW LINKED LIST
C           NULL  -  0, EMPTY/END MARK
C
C
C
C      INITIALIZATION-
C      - GRAPH DESCRIPTION (EPT,ELIST,ECOST) FROM MAIN
C      - PREDECESSOR NULL IF VERTEX NOT YET LABELED
C      - LABEL CALCULATED IN PROCESS, NULL AS VERTEX ADDED TO SUBTREE
C      - ADDRESS SPACE EMPTY/NULL
C      - OVERFLOW CHAIN CALCULATED IN PROCESS
C
      DO 1 I=1,NV
 1      PRED(I)=NULL
      DO 2 I=1,CMAX
 2      ADRS(I)=NULL
C
C     START ALGORITHM AT VERTEX 1
C
      PRED(1)=1
      LABEL(1)=NULL
      TCOST=0
      VERT=1
      COUNT=1
      TOP=CMAX+1
C
C     UPDATE LABELS OF VERTICES ADJACENT TO VERT
C
 10   NEXT=EPT(VERT)-1
      LAST=EPT(VERT+1)-1
 20   NEXT=NEXT+1
      IF( NEXT.GT.LAST ) GOTO 50
      ADJ=ELIST(NEXT)
      NEWLAB=ECOST(NEXT)
C
C     NULL PREDECESSOR  <==>  ADJ UNLABELED, ADD TO ADDRESS SPACE
      IF( PRED(ADJ).EQ.NULL ) GOTO 40
C
C     CHECK FOR UPDATE OF A CURRENT LABEL
      OLDLAB=LABEL(ADJ)
C
C     NULL LABEL  <==>  ALREADY IN MST SO CHECK NEXT VERTEX
      IF( OLDLAB.EQ.NULL ) GOTO 20
C
C     NO UPDATE IF OLDLAB LESS THAN OR EQUAL TO NEWLAB
      IF( OLDLAB.LE.NEWLAB ) GOTO 20
C
C     REMOVE OLD LABEL FROM ADDRESS SPACE
      LINK=ADRS(OLDLAB)
      IF( LINK.NE.ADJ ) GOTO 30
C
C     NOT IN OVERFLOW LIST, PULL UP NEXT FROM OVERFLOW
      ADRS(OLDLAB)=CHAIN(ADJ)
      GOTO 40
C
C     FOLLOW OVERFLOW CHAIN UNTIL FIND ADJ
 30   HOLD=LINK
      LINK=CHAIN(HOLD)
      IF( LINK.NE.ADJ ) GOTO 30
      CHAIN(HOLD)=CHAIN(ADJ)
C
C     PLACE ADJ AT NEWLAB POSITION OF ADDRESS SPACE,
C     CURRENT OCCUPANT (POSSIBLY NULL) TO OVERFLOW LIST
 40   CHAIN(ADJ)=ADRS(NEWLAB)
      ADRS(NEWLAB)=ADJ
      LABEL(ADJ)=NEWLAB
      PRED(ADJ)=VERT
      IF( NEWLAB.LT.TOP ) TOP=NEWLAB
      GOTO 20
C
C     FIND MINIMUM LABEL IN ADDRESS SPACE, POSITION AT OR BELOW TOP
C     RETURN WHEN HAVE FOUND NV VERTICES
C
 50   VERT=ADRS(TOP)
      IF( VERT.NE.NULL ) GOTO 60
      TOP=TOP+1
      GOTO 50
 60   TCOST=TCOST+TOP
      COUNT=COUNT+1
      IF( COUNT.EQ.NV ) RETURN
      ADRS(TOP)=CHAIN(VERT)
      LABEL(VERT)=NULL
      GOTO 10
      END 
