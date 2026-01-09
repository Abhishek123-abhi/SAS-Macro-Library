/* Chapter - 05 */

/* Scopes of Macro Variables */

/************************************************************************************************************/
/* ~ Every macro variable has a scope. A macro variable's scope determines how it is 
assigned values and how the macro processor resolves references to it. */

/* ~ Two types of scopes exist for macro variables: global and local. Global macro variables 
exist for the duration of the SAS session and can be referenced anywhere (except 
CARDS and DATALINES) in the program—either inside or outside a macro. Local 
macro variables exist only during the execution of the macro in which the variables are 
created and have no meaning outside the defining macro. */

/* ~ Scopes can be nested, like boxes within boxes. For example, suppose you have a macro A 
that creates the macro variable LOC1 and a macro B that creates the macro variable 
LOC2. If the macro B is nested (executed) within the macro A, LOC1 is local to both A 
and B. However, LOC2 is local only to B.
*/

/* ~ Macro variables are stored in symbol tables, which list the macro variable name and its 
value. There is a global symbol table, which stores all global macro variables. Local 
macro variables are stored in a local symbol table that is created at the beginning of the 
execution of a macro. */

/* ~ You can use the %SYMEXIST function to indicate whether a macro variable exists. */

/************************************************************************************************************/

OPTIONS MPRINT MLOGIC SYMBOLGEN MCOMPILENOTE= ALL;

/* GLOBAL MACRO VARIABLES */

%let county=Clark;
%macro concat;
   data _null_;
      length longname $20;
      longname="&county"||" County";
      put longname;
   run;
%mend concat;

%concat;


/* Global macro variables include the following:
 - all automatic macro variables except SYSPBUFF.
 - macro variables created outside of any macro.
 - macro variables created in %GLOBAL statements.
 - most macro variables created by the CALL SYMPUT routine.
*/





/* LOCAL MACRO VARIABLES */

%macro holinfo(day,date);
   %let holiday=Christmas;
   %put *** Inside macro: ***;
   %put *** &holiday occurs on &day, &date, 2012. ***;
%mend holinfo;

%holinfo(Tuesday,12/25)

%put *** Outside macro: ***;
%put *** &holiday occurs on &day, &date, 2012. ***;


/*
A macro's local symbol table is empty until the macro creates at least one macro 
variable. A local symbol table can be created by any of the following:
• the presence of one or more macro parameters
• a %LOCAL statement
• macro statements that define macro variables, such as %LET and the iterative %DO 
statement (if the variable does not already exist globally or a %GLOBAL statement 
is not used)

Note: Macro parameters are always local to the macro that defines them. You cannot 
make macro parameters global. (Although, you can assign the value of the parameter 
to a global variable.
*/


/*
When you invoke one macro inside another, you create nested scopes. Because you can 
have any number of levels of nested macros, your programs can contain any number of 
levels of nested scopes.

You can create a read-only local macro variable and assign a specified value to it using 
the READONLY option in a %LOCAL statement. Existing macro variables cannot be 
made read-only. The value of the variable cannot be changed, and the variable cannot be 
deleted. All read-only macro variables persist until the scope in which they exist is 
deleted. 

You can use the %SYMLOCAL function to indicate whether an existing macro variable 
resides in an enclosing local symbol table.
*/




/* Writing the Contents of Symbol Tables to the Log */
%put _ALL_;

%put _AUTOMATIC_;

%put _GLOBAL_;

%put _LOCAL_;

%put _READONLY_;        /* describes all user-defined read-only macro variables, regardless of scope. The scope 
is either GLOBAL, for global macro variables, or the name of the macro in which 
the macro variable is defined.*/

%put _USER_;

%put _WRITABLE_;     /* describes all user-defined read and write macro variables, regardless of scope. The 
scope is either GLOBAL, for global macro variables, or the name of the macro in 
which the macro variable is defined.*/





/* Examples */

/* 01 */
%let origin=North America;
%macro dogs(type=);
   data _null_;
      set all_dogs;
      where dogtype="&type" and dogorig="&origin";
      put breed " is for &type.";
   run;
   %put _user_;
%mend dogs;

%dogs(type=work);


/* 02 */

%let new=inventry;
%macro name1;
   %let new=report;
%mend name1;

%name1;     
          /* Because NEW exists as a global variable, the macro processor changes the value of the 
               variable rather than creating a new one.  The macro NAME1's local symbol table remains 
                                         empty.*/
                                        


/* 03 */
%let new=inventry;
%macro name2;
   %let new=report;
   %let old=warehse;
%mend name2;
%name2;
data &new;
   set &old;
run;       /* The macro processor encounters the reference &OLD after macro NAME2 has finished 
               executing. Thus, the macro variable OLD no longer exists. The macro processor is not 
                 able to resolve the reference and issues a warning message. */
                



/* 04  */
%let new=inventry;

%macro name2;
   %let new=report;
   %let old=warehse;
   data &new;
      set &old;
   run;
%mend name2;
%name2;



/* 05 */

/* The same rule applies regardless of how many levels of nesting exist. Consider the 
following example: */

%let new=inventry;
%macro conditn;
   %let old=sales;
   %let cond=cases>0;
%mend conditn;
%macro name3;
   %let new=report;
   %let old=warehse;
   %conditn
      data &new;
         set &old;
         if &cond;
      run;
%mend name3;
%name3;
                 /* CONDITN finishes executing before the macro processor reaches the reference 
                   &COND, so no variable named COND exists when the macro processor attempts to 
                   resolve the reference. Thus, the macro processor issues a warning message and generates 
                  the unresolved reference as part of the constant text and issues a warning message.*/
                 
                 


/* 06 */
%macro namelst(name,number);
   %do n=1 %to &number;
      &name&n
   %end;
%mend namelst;

%let n=North State Industries;
proc print;
   var %namelst(dept,5);
   title "Quarterly Report for &n";             /* here the value for 'n' will get updated in global symbol table */
run;  

                       

/* 07 */
%macro namels2(name,number);
   %local n;                      /*forcing local scope*/
   %do n=1 %to &number;
      &name&n
   %end;
%mend namels2;

%let n=North State Industries;
proc print;
   var %namels2(dept,5);
   title "Quarterly Report for &n";
run;



/* 08 */
%macro conditn;
   %global cond;
   %let old=sales;
   %let cond=cases>0;
%mend conditn;

%let new=inventry;
%macro name4; 
   %let new=report;
   %let old=warehse;
   %conditn
   data &new;
      set &old;
      if &cond;
   run;
%mend name4;
%name4;




/* 09 */
%let new=inventry;
%macro conditn;
   %global cond;
   %let old=sales;
   %let cond=cases>0;
%mend conditn;
%macro name5;
      %global old;
      %let new=report;
      %let old=warehse;
      %conditn
%mend name5;
%name5;

data &new;
   set &old;
   if &cond;
run;



/* Creating Global Variables Based on the Value of Local Variables */

%macro namels3(name,number);
   %local n;
   %global g_number;
   %let g_number=&number;
   %do n=1 %to &number;
      &name&n
   %end;
%mend namels3;

%let n=North State Industries;
proc print;
   var %namels3(dept,5);
   title "Quarterly Report for &n";
   footnote "Survey of &g_number Departments";
run;




/* Special Cases of Scope with the CALL SYMPUT Routine */

/* 1. Example Using CALL SYMPUT with Complete DATA Step and a 
Nonempty Local Symbol Table */

%macro env1(param1);      
   data _null_;
      x = 'a token';
      call symput('myvar1',x);
   run;
%mend env1;
%env1(10);
data temp;
   y = "&myvar1";
run;                  /* to explain in simple words, when used inside a Macro HAVING PARAMETERS, CALL SYMPUT 
                          will create macro variable in local table */





%macro env1(param1);
   data _null_;
      x = 'a token';
      call symput('myvar1',x);
   run;
   %put ** Inside the macro: **;
   %put _user_;
%mend env1;
%env1(10)
%put ** In open code: **;
%put _user_;
data temp;
   y = "&myvar1";  /* ERROR - MYVAR1 is not available in open code. */
run;





/* 2. Example Using CALL SYMPUT with an Incomplete DATA Step */
%macro env2(param2);
   data _null_;
      x = 'a token';
      call symput('myvar2',x);
%mend env2;
%env2(20)
run;
data temp;
   y="&myvar2";
run;       
              /* These statements execute without errors. The DATA step is complete only when SAS 
               encounters the RUN statement (in this case, in open code). Thus, the current scope of the 
                DATA step is the global scope. CALL SYMPUT creates MYVAR2 as a global macro 
                  variable, and the value is available to the subsequent DATA step.  */



%macro env2(param2);
   data _null_;
      x = 'a token';
      call symput('myvar2',x);
      %put ** Inside the macro: **;
      %put _user_;
%mend env2;
%env2(20)
run;
%put ** In open code: **;
%put _user_;
data temp;
   y="&myvar2";
run;




/* 3. Example Using CALL SYMPUT with a Complete DATA Step and an Empty Local Symbol Table */
%macro env3;
   data _null_;
      x = 'a token';
      call symput('myvar3',x);              /*will create in global table*/
   run;
   %put ** Inside the macro: **;
   %put _user_;
%mend env3;

%env3
%put ** In open code: **;
%put _user_;
data temp;
   y="&myvar3";
run;     




/* 4. Example Using CALL SYMPUT with SYSPBUFF and an Empty Local Symbol Table  */
%macro env4 /parmbuff;
 data _null_;
      x = 'a token';
      call symput('myvar4',x);
   run;
   %put ** Inside the macro: **;
   %put _user_;
   %put &syspbuff;
%mend env4;
%env4
%put ** In open code: **;
%put _user_;
%put &syspbuff;
data temp;
   y="&myvar4";  /* ERROR - MYVAR4 is not available in open code */
run;

     









              

          











