           character(len=80) inline
           character(len=1) icecreamselect
           character(len=80) message_A
           character(len=80) message_B
           message_A = "purchase Peters icecream online"
           message_B = "purchase Streets icecream online" 
           print *,"if you want peters ice cream type 1 and enter"
           print *,"if you want streets ice cream type 2 and enter"
           read *, icecreamselect
           if (icecreamselect .eq. "1") print *,message_A
           if (icecreamselect .eq. "2") print *,message_B
           end program
           
           
