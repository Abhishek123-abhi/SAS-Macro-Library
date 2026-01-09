OPTIONS SYMBOLGEN MPRINT MLOGIC MCOMPILENOTE= ALL;

%macro myMac1; 
    data class;
       set sashelp.class;
       x=1;
       put " **** ";
       put "This macro is running in the SAS-client session 
            and creating a SAS data set in the Work library";
       put " **** ";
       put _hostname_ 'thread #' _threadid_;
    run;
%mend myMac1;
 
%myMac1;

quit;




%let city=New Orleans;

%put title "Data for &city";





%macro dsn;
    Newdata;
%mend dsn;

%put title "Display of Data Set %dsn";





/* Inserting comments in MACROS */

%macro comment;
/* Here is the type of comment used in other SAS code. */
   %let myvar=abc;
%* Here is a macro-type comment.;
   %let myvar2=xyz;
%mend comment;






/* More advanced macro techniques  */

*Generating Repetitive Pieces of Text Using %DO Loops;
%macro names(name= ,number= );
   %do n=1 %to &number;
      &name&n
   %end;
%mend names;

%put data %names(name=dsn,number=5);


/* Generating a Suffix for a Macro Variable Reference */
%macro namesx(name=,number=);
   %do n=1 %to &number;
      &name.x&n
   %end;
%mend namesx;

%put data %namesx(name=dsn,number=3);



