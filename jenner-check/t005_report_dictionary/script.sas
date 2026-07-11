proc sql;
   create table work.Vars as
         select name,type
         from dictionary.columns
         where memname="CLASS" and libname="SASHELP";
quit;
%macro report(var= , type= );
       %if &type=char %then %do;
          proc freq data=sashelp.class;
               table &var;
          run;
       %end;
       %else %do;
       proc means data=sashelp.class;
            var &var;
       run;
       %end;
%mend report;
data _null_;
     set work.Vars;
     call execute('%report(var='||strip(name)||' , type='||strip(type)||');');
run;
