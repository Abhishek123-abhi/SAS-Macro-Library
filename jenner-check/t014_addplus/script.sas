%macro addplus(number);
       %let first = %substr(&number, 1, 1);
       %if %bquote(&first) EQ 1 %then %do;
              %let newnumber = +&number;;
       %end;
       %else %if %bquote(&first) NE %str(+) %then %do;
              %let newnumber = +1&number;;
       %end;
       %else %let newnumber = &number;
       %put &newnumber;
%mend;

%addplus((909)319-2541)
%addplus(+1(909)319-2541)
%addplus(1(909)319-2541)
;
