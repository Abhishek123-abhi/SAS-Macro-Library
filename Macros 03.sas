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




