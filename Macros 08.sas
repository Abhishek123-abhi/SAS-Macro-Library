/* MACRO facility error message and Debugging */

/* Troubleshooting Your Macros */

/* example: 01 */

%let wk=week;
title "This is data for &wk1";   /* INCORRECT */

%let wk=week;
title "This is data for &wk.1";   /* CORRECT  */



/* example: 02 - scope related issue*/
%macro totinv(var);
   data inv;
      retain total 0;
      set Houses end=final;
      total=total+&var;
      if final then call symput("macvar",put(total,dollar14.2));
   run;
   %put **** TOTAL=&macvar ****;
%mend totinv;

%totinv(price)

%put **** TOTAL=&macvar ****;   /* ERROR */


               /* the solution will be you can either use %GLOBAL statement to declare 
                    the macro variable MACVAR, or simply set the scope to GLOBAL using CALL SYMPUTX */
                   
                   
                   


/* example 03: Open Code Statement Recursion */

%let a=b   /* ERROR */
%put **** &a ****; 
                     /* soln: add semicolon at the end of %LET statement */
                    
                    


/* example 04 */

%macro test;
     %let lincoln=Four score and seven;
     %let secondwd=%subsrt(&lincoln,6,5);   /* ERROR */
     %put *** &secondwd ***;
%mend test;
%test
;
                 /* misspelled name of function */
                
                
                

/* example 05 */

/* %macro rooms; */
/*    other macro statements& */
/*    %put **** %str(John's office) ****;   /* ERROR */
/* %mend rooms; */
/* %rooms */
/* ; */


*correct code;
%macro rooms;
   /* other macro statements& */
   %put **** %str(John%'s office) ****;   /* ERROR */
%mend rooms;
%rooms
;






/* Resolving Timing Issues */

/* The key to preventing timing errors is to understand how the macro processor works. In 
simplest terms, the two major steps are compilation and execution. The compilation step 
resolves all macro code to compiled code. Then the code is executed. Most timing errors 
occur because of the following:
• the user expects something to happen during compilation that does not actually occur 
until execution 
• expects something to happen later but is actually executed right away */


/* example: 06 */

data senior;
   set census;
   if age > 65 then
   do;
      %let sr_cit = yes;  /* ERROR */
      output;
   end;
run;
                        /* The problem: The %LET statement is executed immediately and the DATA step is 
                         being compiled--before the data set is read. Therefore, the %LET statement executes 
                         regardless of the results of the IF condition. Even if the data set contains no observations 
                         where AGE is greater than 65, SR_CIT is always yes. */


*correct code;
%let sr_cit = no;
data senior;
   set census;
   if age > 65 then
   do;
      call symput ("sr_cit","yes");
    output;
   end;
run;





/* example: 07 */
%let sr_age = 0;
data senior;
   set census;
   if age > 65 then
   do;
      call symput("sr_age",age);
      put "This data set contains data about a person";
      put "who is &sr_age years old."; /* ERROR */
   end;
run;

*correct code;
%let sr_age = 0;
data senior;
   set census;
   if age > 65 then
   do;
      call symput("sr_age",age);
      stop;
   end;
run;
data _null_;
   put "This data set contains data about a person";
   put "who is &sr_age years old.";
run;









/* Resolving problems with Expression Evaluation */
%macro conjunct(word= );
   %if &word = and or &word = but or &word = or %then   /* ERROR */
      %do; %put *** &word is a conjunction. ***;
      %end;
   %else
      %do; %put *** &word is not a conjunction. ***;
      %end;
%mend conjunct;


*correct code;

%macro conjunct(word= );
   %if %bquote(&word) = %str(and) or %bquote(&word) = but or
          %bquote(&word) = %str(or) %then %do; 
              %put *** &word is a conjunction. ***;
           %end;
   %else %do;
      %put *** &word is not a conjunction. ***;
      %end;
%mend conjunct;










/* Debugging Techniques */

/* 
MCOMPILENTOE
MPRINT
MPRINTNEST
MLOGIC
MLOGICNEST
SYMBOLGEN
MFILE 
 */


*SYMBOLGEN;
options symbolgen;
%let a1=dog;
%let b2=cat;
%let b=1;
%let c=2;
%let d=a;
%let e=b;
%put **** &&&d&b ****;
%put **** &&&e&c ****;


/* options symbolgen;  */
%macro bighouse(Pet=Cat Dog, Type=Fat Fuzzy, Npets=2, Ntypes=2); 
 %do i=1 %to &npets; 
  %do j=1 %to &ntypes; 
   %let allpets=%scan(&type,&i) %scan(&pet,&j); 
   %put &allpets; 
  %end; 
 %end; 
%mend bighouse;
 
%bighouse
;



*MPRINT;
options mprint nosymbolgen nomlogic; 
%macro second(param); 
    %*Change a to &a!!!; 
    %let a = %eval(&param);&a  
%mend second; 
%macro first(exp); 
   data _null_;     
      var=%second(&exp); 
      put var=; 
   run; 
%mend first; 

%FIRST(1+2);



*MLOGIC - tracks the flow of your MACRO code;
 
options mlogic; 
%macro bighouse(Pet=Cat Dog, Type=Fat Fuzzy, Npets=2, Ntypes=2); 
      %do i=1 %to &npets; 
            %do j=1 %to &ntypes; 
                %let allpets=%scan(&type,&i) %scan(&pet,&j); 
                %if %scan(&allpets,2)=Cat %then %put &allpets;

            %end; 
      %end; 
%mend bighouse; 

%bighouse;



*MFILE ;
   /* ~ Similar to MPRINT, the MFILE option can be used to write out the resolved macro code to a file.  To take advantage 
        of this option, use a FILENAME statement with a fileref of MPRINT, and turn on both the MPRINT and MFILE options. */

FILENAME MPRINT 'C:\MYMACROS\MACCODE.SAS'; 
OPTIONS MPRINT MFILE; 













/* Use the %PUT Statement to Track Problems */
%macro totinv(var);
   %global macvar;
   data inv;
      retain total 0;
      set .Houses end=final;
      total=total+&var;
      if final then call symput("macvar",put(total,dollar14.2));
   run;
   %if &trace = ON  %then
      %do;
         %put *** Tracing macro scopes. ***;
         %put _USER_;
      %end;
%mend totinv;
%let trace=ON;
%totinv(price)
%put *** TOTAL=&macvar ***;








