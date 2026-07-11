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

proc print data=class;
run;
