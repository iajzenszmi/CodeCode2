class SqrtCountToTen {
    public static void main(String args[]) {
	    int counta;
	    double countd;
	    double sqrtcountd;
	    for(counta=1;counta < 11;counta++){
		    countd = (double)counta;
		    sqrtcountd = Math.sqrt(countd);
		    if(counta <= 9 ){
		    System.out.printf("\nCount =  %d Square Root = %f ", counta,sqrtcountd);
	    }
	            if(counta == 10)
		    {System.out.printf("\nCount = %d Square Root = %f\n",counta,sqrtcountd);                        
		    }	      
    }       
    }
}

