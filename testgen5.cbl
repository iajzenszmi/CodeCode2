           identification division.
           program-id. testgen4x.
           data division.
           working-storage section.
           77 count7 pic 99999999.
           77 count6 pic 99999999.
           77 count5 pic 99999999.
           77 count4 pic 99999999.
           77 count3 pic 99999999.
           77 count2 pic 99999999.
           77 count1 pic 99999999.
           procedure division.
           perform 105.
                           
           stop run.
           
           105.
           perform varying count7 from 1 by 1 until count7  = 8
           display count7 count6 count5 count4 count3 count2 count1
           perform  varying count6 from 1 by 1 until count6 = 8
           display count7 count6 count5 count4 count3 count2 count1
           perform  varying count5 from 1 by 1 until count5 = 8
           display count7 count6 count5 count4 count3 count2 count1
           perform  varying count4 from 1 by 1 until count4 = 8
           display count7 count6 count5 count4 count3 count2 count1
           perform  varying count3 from 1 by 1 until count3 = 8
           display count7 count6 count5 count4 count3 count2 count1
           perform varying count2 from 1 by 1 until count2 = 8
           display count7 count6 count5 count4 count3 count2 count1
           perform varying count1 from 1 by 1 until count1 = 8
           display count7 count6 count5 count4 count3 count2 count1
           end-perform
           end-perform
           end-perform
           end-perform
           end-perform
           end-perform
           end-perform.
           display count7.
           display count6.
           display count5.
           display count4.
           display count3.
           display count2.
           display count1.
           stop run.
           
