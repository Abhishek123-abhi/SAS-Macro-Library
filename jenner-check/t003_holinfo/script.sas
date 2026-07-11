%macro holinfo(day,date);
   %let holiday=Christmas;
   %put *** Inside macro: ***;
   %put *** &holiday occurs on &day, &date, 2012. ***;
%mend holinfo;

%holinfo(Tuesday,12/25)
