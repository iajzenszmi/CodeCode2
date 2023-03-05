      character(len=8)  clock_date, date 
      character(len=10) clock_time, time
      character(5) zone
      call date_and_time(date=clock_date, time=clock_time, zone=zone) 
      print *,clock_date
      print *,clock_time
      print *,zone
      end program
