! Programmer Ian Martin Ajzenszmidt Melbourne Australia March 13 2023
! Program to calculate Australian Average Rainfall for entertainment.
! 
       PROGRAM test
       IMPLICIT NONE
       CHARACTER(len=10) prodno
       character(len=7) stationno
       character(len=4) year 
       integer recnt /0/
       character(len=2) month, day
       character nodays
       character(len=3)rain
       character(len=1) qual
       character(len=40) inrec
 !      integer irain
       real rrain /0.0/
      character(len=4) oldyear /'0000'/
       character(len=2) oldmonth /'0'/
       character  oldday /'0'/    
       real yearrain /0.0/
       real monthrain /0.0/
       real yearav    /0.0/
       real monthav   /0.0/
       integer yearcount /0/
       integer monthcount /0/
       integer daycount /0/
!      character(len = 1) End /"0"/
!       REAL :: x, y, z
!  INTEGER :: m, n
! CHARACTER first*20
       OPEN(UNIT=5, FILE = "IDCJAC0009_086338_1800_Data.csv")       
       open(unit=7, file= 'outdat.txt')  
       read(5,9010,End=1) inrec
       read(5,9010,End=1) inrec
       do 
       oldyear = year
       oldmonth = month
       oldday = day
       read(5,9010,End=1) inrec
        
 9010  format(a40)    
        recnt = recnt+ 1
        daycount = daycount + 1
       READ(inrec, *,End=1) prodno,stationno,year,month,day
       if (inrec(30:30) .ne. ',' ) read(inrec(30:32), '(f3.1)') rrain
       if (year .eq. oldyear) then 
               yearrain = yearrain + monthrain
               
       else
               yearav = yearrain / monthcount
               
!               print *,"year average",yearav
 !               yearrain = 0.0
 !               yearav = 0.0
        endif
       if (month  .eq. oldmonth) then
               monthrain = monthrain + rrain
                               else
                monthav = monthrain / daycount
!               print *, "monthly average", monthav
!              monthcount = monthcount + 1
!               yearrain = yearrain + monthrain
!               print *,"daycount ", daycount

        print *, "                                           "
        print *, "station number ",stationno," year ",year
        print *," month ", oldmonth
        print *, " recnt ",recnt, " monthrain   ",monthrain 
        print *, " daycount ",daycount, " yearrain ", yearrain
        print *, "monthaverage ", monthav, "previous year average ", yearav
               monthcount = monthcount + 1
               yearrain = yearrain + monthrain
               monthrain=0.0
               IF(month .eq.'12') then
               yearav =0.0
               yearrain = 0.0
               daycount = 0
               end if
       end if        
!     read(rain,'(i3)')irain
!     read(irain,'(f3.0)') rrain 
!      irain = int(rain)
!     rrain = real(irain)
!       write(6,*) inrec
!                                                                                                          
!      PRINT *, prodno
!       PRINT *, stationno
!       PRINT *, year  
!       PRINT *, month
!!       PRINT *, day
!       PRINT *, rrain
!       print *, nodays
!       print *,qual
       end do
 1       continue
 !       print *, "                                         "
 !       print *, "station number ",stationno," year ",year
!        print *," month ", oldmonth
!        print *, " recnt ",recnt, " monthrain   ",monthrain 
!        print *, " daycount ",daycount, " yearrain ", yearrain
!        print *, "monthaverage ", monthav

        print *, "end" 
        stop 
       END PROGRAM test
