/* chapter: 02 */

/* SAS programs and MACRO processing */

data sales (drop=lastyr);
   infile inl;
   input m1-m12 lastyr;
   total=m12+lastyr;
run;

%let list=m1 m7 m12 total;
proc print;
   var &list;
run;










/* chapter: 03 */

/* MACRO variables */

*Automatic;
%put footnote "Report for &sysday, &sysdate9";

%PUT _AUTOMATIC_;

*user-defined;
%let txt= Music heals;

%let w = hello world!;

%put _user_;


%put _all_;

%put _local_;

%put _global_;



%let name=Cary;
%let city=&name;

%put &=city;



%let street=maple;
%let street=            maple;
%let street=maple            ;    /*The leading and trailing blanks are not stored.*/


%let num=123;
%let totalstr=100+200;       /*everything is text*/


*evaluating arithmetic expressions;
%let num=%eval(100+200);

%let num1=%sysevalf(100+1.597);

%put &num, &num1;


*null value;
%let country=;

*macro variable refernce;
%let street=Maple;
%let num=123;
%let address=&num &street Avenue;

%put &=address;



*a macro invocation;
%let status=%wait;
%put &status;

%let status=%nrstr(%wait);          /*masking macro trigger*/ 
%put &status;



*value from a DATA step;
data _null_;
   set in.permdata end=final;
   if age>20 then n+1;
   if final then call symput('number',trim(left(n)));
run;
footnote "&number Observations have AGE>20";




%let dsn=Newdata;
title1 "Contents of Data Set &dsn";
title2 'Contents of Data Set &dsn';     /*doesn't resolve within single quotation*/




%let dsn=Newdata;
data temp;
   set &dsn;
   if age>=20;
run;
proc print;
 title "Subset of Data Set &dsn";
run;


%let jerry=student;
data temp;
  x="produced by &jery";
run;     /*WARNING:  Apparent symbolic reference JERY not resolved.*/



%let name=sales;
data new&name;
      set save.&name;
         more SAS statements
      if units>100;
run;



*Delimiting Macro Variable Names within Text;

data &name1 &name2;
   set in&name.temp;
run;          /*incorrect*/


/*  correct version  */
data &name.1 &name.2;     /*DATA SALES1 SALES2;*/

set in&name..temp;    /* will resolve to - SET INSALES.TEMP;*/


/*You can end any macro variable reference with a delimiter, but the delimiter is necessary 
only if the characters that follow can be part of a SAS name. For example, both of these 
TITLE statements are correct:  */
title "&name.--a report";
title "&name--a report";

/* They produce the following: */
TITLE "sales--a report";




/* Displaying macro variable values */
%let a=first;
%let b=macro variable;
%put &a ***&b***;





/* Referencing Macro Variables Indirectly */
%let n= 6;
%let city6= Los Angeles;

%put &&city&n;      /*indirect reference*/




/* Generating a Series of Macro Variable References with a Single Macro Call */

%let city1= Cary;
%let city2= New York; 
%let city3= Chicago;
%let city4= Los Angeles;
%let city5= Austin; 


%macro listthem;
   %do n=1 %to 5; 
       &&city&n
   %end;
%mend listthem;

%put %listthem;



/* Using More Than Two Ampersands */
%let var=city;
%let n=6;
%put &&&var&n;




/* Manipulating Macro Variable Values with Macro 
Functions */
%let address=123 maple avenue;
%let frstword=%scan(&address,1);

%put &=frstword;













