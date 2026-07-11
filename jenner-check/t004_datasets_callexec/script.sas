%macro datasets(name= );
     data work.&name;
          set sashelp.class;
          where name="&name";
     run;
%mend datasets;
data _null_;
     set sashelp.class;
     call execute('%datasets(name='||strip(name)||');');
run;

proc print data=work.Amir;
run;
