/*  Macro Expressions: text, logical, and arithmetic */


/* Evaluating arithmetic expressions */
%let A=2;
%let B=5;
%let operator=+;

%put The result of &A &operator &B is %eval(&A &operator &B).;


%let a=%eval(1+2);
%let b=%eval(10*3);
%let c=%eval(4/2);
%let i=%eval(5/3);
%put The value of a is &a;
%put The value of b is &b;
%put The value of c is &c;
%put The value of I is &i;


*Evaluating Floating-Point Operands;
%let a=%sysevalf(10.0*3.0);
%let b=%sysevalf(10.5+20.8);
%let c=%sysevalf(5/3);
%put 10.0*3.0 = &a;
%put 10.5+20.8 = &b;
%put 5/3 = &c;



%let a=2.5;
%put %sysevalf(&a,boolean);
%put %sysevalf(&a,integer);
%put %sysevalf(&a,ceil);
%put %sysevalf(&a,floor);



/* How the Macro Processor Evaluates Logical Expressions */
%macro compnum(first,second);
   %if &first>&second %then %put &first is greater than &second;
   %else %if &first=&second %then %put &first equals &second;
   %else %put &first is less than &second;
%mend compnum;

%compnum(1,2)
%compnum(-1,0)
;


%macro compflt(first,second);
   %if %sysevalf(&first>&second) %then %put &first is greater than &second;
   %else %if  %sysevalf(&first=&second) %then %put &first equals &second;
   %else %put &first is less than &second;
%mend compflt;

%compflt (1.2,.9)
%compflt (-.1,.)
%compflt (0,.)
;


*Comparing Character Operands in Logical Expressions;
%macro compchar(first,second);
   %if &first>&second %then %put &first comes after &second;
   %else %put &first comes before &second;
%mend compchar;

%compchar(a,b)
%compchar(.,1)
%compchar(Z,E)
;





