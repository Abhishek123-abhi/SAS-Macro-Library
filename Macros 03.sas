/* Macro Processing */

/* Defining and Calling Macros */

/*********************************************************************************************
syntax:

#compiling:
%MACRO macro_name;
<macro_text>
%MEND <macro_name>;

#calling:
%macro_name
**********************************************************************************************/


%macro ds;
   data _null_;
      put "Fred";
   run;
%mend;

%ds;



%macro app(goal);
   %if &sysday=Friday %then
   %do;
      data thisweek;
         set lastweek;
         if totsales > &goal
            then bonus = 0.03;
         else bonus = 0;
   %end;
%mend app;
%app(10000);
proc print;
run;



/*
Note: 

During macro compilation, the macro processor does the following:

# creates an entry in the session catalog
# compiles and stores all macro program statements for that macro as macro instructions
# stores all noncompiled items in the macro as text
*/












/* Chapter - 05 */

/* Scopes of Macro Variables */

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



