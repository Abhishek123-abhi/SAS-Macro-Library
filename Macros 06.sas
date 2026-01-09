/* Macro Quoting */
/* Masking Special Characters and Mnemonics */
/* ~ Macro quoting functions tell the macro processor to interpret special characters and
mnemonics as text rather than as part of the macro language.*/


%let print=proc print;
run;
;

/* undesirable results */

%let print=%str(proc print; run;);

/*
The following macro quoting functions are most commonly used:
• %STR and %NRSTR
• %BQUOTE and %NRBQUOTE
• %SUPERQ
*/
/* %STR or %NRSTR macro quoting functions mask special character or mnemonics during compilation.*/
/* %BQUOTE, %NRBQUOTE, and %SUPERQ macro quoting functions mask special character or mnemonics during run time.*/
/* COMPILATION TIME */
/* ~ Compile time macro quoting functions mask the character string during the compilation of macro or macro statement.
Compilation time essentially refers to situations where we have included special characters or symbols in our code. If
the compiler sees them, it will use their conventional meaning in macro language. We don’t let this happen by using
compile time quoting functions. %STR and %NRSTR (NR stands for “No Rescan “or “Not Resolved”) are the compile
time macro quoting functions.
*/
/* %STR */

%let myvar=%str(a%');

/* a' */

%let myvar=%str(title %”first);

/* title “first */

%let myvar=%str (log%(12);          /* log(12 */

%let myvar=%str (345%));           /* 345) */

%let myvar=%str(%"Philip);
%put &myvar;                   /* "Philip */


%let printit=%str(proc print; run;);




%macro keepit1(size);
   %if &size=big %then %put %str(keep city _numeric_;);
   %else %put %str(keep city;);
%mend keepit1;

%keepit1(big)
;



/* %NRSTR */

%macro example;
   %local myvar;
   %let myvar=abc;
   %put %nrstr(The string &myvar appears in log output,);
   %put instead of the variable value.;
%mend example;

%example
;


%macro credits(d=%nrstr(Mary&Stacy&Joan Ltd.));
   %put footnote "Designed by &d";
%mend credits;

%credits()
;


%put This is the result of %nrstr(%nrstr);










/* EXECUTION TIME */

/* ~ Execution time macro quoting functions mask the character string during execution of macro or macro statement.
During macro variable resolution or macro execution, we have no way to know what they would resolve to. They
might contain characters that have meaning to macro language. To handle these situations execution time macro
quoting functions are used. */


/* 
syntax:

%BQUOTE (character string| text expression)
%NRBQUOTE (character string| text expression)
%SUPERQ (name of macro variable)
 */


/* Point to remember: “If you can see the problem, it is a compile issue; otherwise, it is execution time.” */



/* %BQUOTE and %NRBQUOTE Functions */

/* ~ The %BQUOTE and %NRBQUOTE functions mask a character string or resolved value of a text expression 
     during execution of a macro or macro language statement. */

*ex:01;    
%macro fileit(infile);
  %if %bquote(&infile) NE %then
     %do;
         %let char1 = %bquote(%substr(&infile,1,1));
         %if %bquote(&char1) = %str(%')
             or %bquote(&char1) = %str(%")
         %then %let command=FILE &infile;
         %else %let command=FILE "&infile";
     %end;
  %put &command;
%mend fileit;

%fileit(myfile)
%fileit('myfile')
;


*ex:02;
%if %bquote(&state)=%str(OR) %then %put Oregon Dept. of Revenue;


*ex:03;
data test;
      store="Susan's Office Supplies";
      call symput('s',store);
run;
%macro readit;
   %if %bquote(&s) ne %then %put *** valid ***;
   %else %put *** null value ***;
%mend readit;
%readit
;


*ex:04;
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




*ex:05;
data reason;
   text="Investigator's Decision";
   call symput('reason', text);
run;

%macro valid_reason;
    %if %bquote(&reason) ne %then %put reason is valid;
    %else %put reason is not valid;
%mend valid_reason;

%valid_reason;


*ex: 06;
data character;
     text="&";
    call symput('char', text);
run;

%macro valid_text;
    %if %nrbquote(&char) ne %then %put text is valid;
    %else %put text is not valid;
%mend valid_text;

%valid_text;











/* %SUPERQ function */

/* ~ Masks all special characters and mnemonic operators at macro execution but prevents further 
       resolution of the value. */
      
/* 
syntax:

%SUPERQ (argument)

argument is the name of a macro variable with no leading ampersand or a text expression that produces the name of 
a macro variable with no leading ampersand. */

/* 
%SUPERQ is the only quoting function that prevents the resolution of macro variables and macro references in the value of the specified macro variable.
%SUPERQ accepts only the name of a macro variable as its argument, without an ampersand, and the other quoting functions accept any text expression, including constant text, as an argument.
%SUPERQ masks the same characters as the %NRBQUOTE function. However, %SUPERQ does not attempt to resolve anything in the value of a macro variable. %NRBQUOTE attempts to resolve any macro references or macro variable values in the argument before masking the result. 
*/

*ex: 01;
data _null_;
   call symput('mv1','Smith&Jones');
   call symput('mv2','%macro abc;');
run;
%let testmv1=%superq(mv1);
%let testmv2=%superq(mv2);
%put Macro variable TESTMV1 is &testmv1;
%put Macro variable TESTMV2 is &testmv2;



*ex:02;
%let corpname= %nrstr(Smith&Jones);
%let testvar=%superq(corpname);
%put &=testvar;


*ex:03;
%let name = Doe, John; 
%let initial = %substr(%superq(name), 1, 1); 
%put &initial; 


*ex:04;
%macro check_state(state); 
      %if %superq(state) = %str(OR) %then %put State is Oregon; 
      %else %put State is &state; 
%mend; 

%check_state(OR); 



*ex:05;
data _null_;
   call symput( 'trt' , 'A&B' ) ;
run ;

%let C = %NRBQUOTE(&trt);
%put C = &C ;


data _null_;
    call symput( 'trt' , 'A&B' ) ;
run ;

%let C = %superq(trt);
%put C = &C ;


*ex:06;
data _null_;
 call symputx('Macvar','Alex&Philip');
run;
%put %nrbquote(&Macvar);
%put %superq(Macvar);















/* UNQUOTING TEXT */

/* Restoring the Significance of Symbols */

/* To unquote a value means to restore the significance of symbols in an item that was previously masked by a macro quoting function.

Usually, after an item has been masked by a macro quoting function, it retains its special status until one of the following occurs:
  - You enclose the item with the %UNQUOTE function. 
  - The item leaves the word scanner and is passed to the DATA step compiler, SAS procedures, SAS macro facility, or other parts of the SAS System.
  - The item is returned as an unquoted result by the %SCAN, %SUBSTR, or %UPCASE function. (To retain a value's masked status during one of these operations, use the %QSCAN, %QSUBSTR, or %QUPCASE function. 

As a rule, you do not need to unquote an item because it is automatically unquoted when the item is passed from the word scanner to the rest of SAS. Under two circumstances, however, you might need to use the %UNQUOTE function to restore the original significance to a masked item:
  - when you want to use a value with its restored meaning later in the same macro in which its value was previously masked by a macro quoting function
  - when masking text with a macro quoting function changes how the word scanner tokenizes it, producing SAS statements that look correct but that the SAS compiler does not recognize
*/



%macro analyze(stat);
   data _null_;
      set out1;
      call symput('v1',&stat);
   run;

   data _null_;
      set out2;
      call symput('v2',&stat);
   run;

   %put Preliminary test. Enter the operator.;
   %input;
   %let op=%bquote(&sysbuffr);
   %if &op=%str(=<) %then %let op=%str(<=);
   %else %if &op=%str(=>) %then %let op=%str(>=);
   %if &v1 %unquote(&op) &v2 %then
      %put You might proceed with the analysis.;
   %else
      %do;
         %put &stat from out1 is not &op &stat from out2.;
         %put Please check your previous models.;
      %end;
%mend analyze;


















/* Other Functions That Perform Macro Quoting */

/* Some macro functions are available in pairs, where one function starts with the letter Q:
• %SCAN and %QSCAN
• %SUBSTR and %QSUBSTR
• %UPCASE and %QUPCASE
• %SYSFUNC and %QSYSFUNC */


/* %QSCAN */

%macro a;
   aaaaaa
%mend a;
%macro b;
   bbbbbb
%mend b;
%macro c;
   cccccc
%mend c;

%let x=%nrstr(%a*%b*%c);
%put X: &x;

%put The third word in X, with SCAN: %scan(&x,3,*);
%put The third word in X, with QSCAN: %qscan(&x,3,*);





/* %QSUBSTR */

%let a=one;
%let b=two;
%let c=%nrstr(&a &b);
%put C: &c;
%put With SUBSTR: %substr(&c,1,2);
%put With QSUBSTR: %qsubstr(&c,1,2);





/* %QUPCASE */

%let a=begin;
%let b=%nrstr(&a);
%put UPCASE produces: %upcase(&b);
%put QUPCASE produces: %qupcase(&b);















