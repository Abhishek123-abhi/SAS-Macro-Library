data _null_;
     set sashelp.class;
     if _N_ = 1 then do;
         call symput('nvar', name);
     end;
run;
%put &nvar;

data want;
     var1=symget('nvar');
run;

proc print data=want;
run;
