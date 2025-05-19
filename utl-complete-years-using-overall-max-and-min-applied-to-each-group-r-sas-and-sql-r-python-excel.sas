%let pgm=utl-complete-years-using-overall-max-and-min-applied-to-each-group-r-sas-and-sql-r-python-excel;

%stop_submission;

Complete years using overall max and min applied to each group r sas and sql r python excel

        CONTENTS
           1 sas with sql

           2 rsql (same code in python and excel)
            Solution by Kurt Bremser (i added dosubl)
            https://communities.sas.com/t5/user/viewprofilepage/user-id/11562
            see for python excel

            https://tinyurl.com/4e6yaap8
github
https://tinyurl.com/2srftxez
https://github.com/rogerjdeangelis/utl-complete-years-using-overall-max-and-min-applied-to-each-group-r-sas-and-sql-r-python-excel

AI QUERIES
how do i complete years using overall max and min applied to each group  using sqlite with windows extensions
please provide a simple reproducible example of carrying forward the last non missing vale using sqlite

communities.sas
https://tinyurl.com/3rdsc4s7
https://communities.sas.com/t5/New-SAS-User/Fill-in-gap-years-in-my-dataset/m-p/810093#M33816

macros
https://tinyurl.com/y9nfugth
https://github.com/rogerjdeangelis/utl-macros-used-in-many-of-rogerjdeangelis-repositories


/**************************************************************************************************************************/
/*      INPUT                            |       PROCESS                                 |          OUTPUT                */
/*      =====                            |       =======                                 |          ======                */
/*                                       |                                               |                                */
/* SD1.HAVE total obs=6                  | 1 SAS WITH SQL                                | COUNTRY     YEAR  DISASTE      */
/*                                       | ==============                                |                                */
/* COUNTRY     YEAR DISASTER             |                                               | Afghanistan 1990  Flood        */
/*                                       | %symdel minyer maxyer/nowarn;                 | Afghanistan 1991  None         */
/* Afghanistan 1990 Flood                | data years;                                   | Afghanistan 1992  None         */
/* Afghanistan 1993 Epidemic             |                                               | Afghanistan 1993  Epidemic     */
/* Afghanistan 2000 Storm                | * note dosubl sql is creating                 | Afghanistan 1994  None         */
/* Albania     1992 Landslide            |  min year and max year as macro vars;         | Afghanistan 1995  None         */
/* Albania     1994 Storm                |                                               | Afghanistan 1996  None         */
/* Albania     2000 Epidemic             | do year = %dosubl(%nrstr(proc sql;            | Afghanistan 1997  None         */
/*                                       |               select                          | Afghanistan 1998  None         */
/*                                       |                 min(year)                     | Afghanistan 1999  None         */
/* options validvarname=upcase;          |                ,max(year)                     | Afghanistan 2000  Storm        */
/* libname sd1 "d:/sd1";                 |               into                            | Albania     1990  None         */
/* data sd1.have;                        |                 :minyer                       | Albania     1991  None         */
/* input Country :$20.                   |                ,:maxyer                       | Albania     1992  Landslide    */
/*       Year                            |               from                            | Albania     1993  None         */
/*       Disaster :$10.;                 |                 sd1.have;quit;))              | Albania     1994  Storm        */
/* cards4;                               |           &minyer to &maxyer;                 | Albania     1995  None         */
/* Afghanistan 1990 Flood                |   output;                                     | Albania     1996  None         */
/* Afghanistan 1993 Epidemic             | end;                                          | Albania     1997  None         */
/* Afghanistan 2000 Storm                | run;                                          | Albania     1998  None         */
/* Albania 1992 Landslide                |                                               | Albania     1999  None         */
/* Albania 1994 Storm                    | proc sql;                                     | Albania     2000  Epidemic     */
/* Albania 2000 Epidemic                 | create table template as                      |                                */
/* ;;;;                                  |   select distinct                             |                                */
/* run;quit;                             |     have.country,                             |                                */
/*                                       |     years.year,                               |                                */
/* %symdel minyer maxyer/nowarn;         |     "None" as disaster length=10              |                                */
/* data years;                           |   from sd1.have, years                        |                                */
/*                                       | ;                                             |                                */
/* * note dosubl sql is creating         | quit;                                         |                                */
/*  min year and max year as macro vars; |                                               |                                */
/*                                       | data want;                                    |                                */
/* do year = %dosubl(%nrstr(proc sql;    | update template sd1.have;                     |                                */
/*               select                  | by country year;                              |                                */
/*                 min(year)             | run;                                          |                                */
/*                ,max(year)             |                                               |                                */
/*               into                    |--------------------------------------------------------------------------------*/
/*                 :minyer               | 2 RSQL (SAME CODE IN PYTHON AND EXCEL)        |  R                             */
/*                ,:maxyer               | ======================================        | allyer     unqcon  DISASTER    */
/*               from                    |                                               |  1990 Afghanistan     Flood    */
/*                 have;quit;))          |  STEPS (self expanatory>)                     |  1991 Afghanistan      <NA>    */
/*           &minyer to &maxyer;         |                                               |  1992 Afghanistan      <NA>    */
/*   output;                             |   1 Generate Years 1990-2000 using            |  1993 Afghanistan  Epidemic    */
/* end;                                  |     sql recursion                             |  1994 Afghanistan      <NA>    */
/* run;                                  |   2 Left join with distinct countries         |  1995 Afghanistan      <NA>    */
/*                                       |   3 Left join with original dataset           |  1996 Afghanistan      <NA>    */
/* proc sql;                             |     to get disaster                           |  1997 Afghanistan      <NA>    */
/* create table template as              |                                               |  1998 Afghanistan      <NA>    */
/*   select distinct                     | proc datasets lib=sd1 nolist nodetails;       |  1999 Afghanistan      <NA>    */
/*     have.country,                     |  delete want;                                 |  2000 Afghanistan     Storm    */
/*     years.year,                       | run;quit;                                     |  1990     Albania      <NA>    */
/*     "None" as disaster length=10      |                                               |  1991     Albania      <NA>    */
/*   from have, years                    | %utl_rbeginx;                                 |  1992     Albania Landslide    */
/* ;                                     | parmcards4;                                   |  1993     Albania      <NA>    */
/* quit;                                 | library(haven)                                |  1994     Albania     Storm    */
/*                                       | library(sqldf)                                |  1995     Albania      <NA>    */
/* data want;                            | source("c:/oto/fn_tosas9x.r")                 |  1996     Albania      <NA>    */
/* update template have;                 | options(sqldf.dll = "d:/dll/sqlean.dll")      |  1997     Albania      <NA>    */
/* by country year;                      | have<-read_sas("d:/sd1/have.sas7bdat")        |  1998     Albania      <NA>    */
/* run;                                  | print(have)                                   |  1999     Albania      <NA>    */
/*                                       | want<-sqldf('                                 |  2000     Albania  Epidemic    */
/*                                       |   with                                        |                                */
/*                                       |     recursive sequence(n) as (                | SAS                            */
/*                                       |   select                                      |  ALLYER UNQCON      DISASTER   */
/*                                       |     (select min(year) as minyer from have)    |                                */
/*                                       |   union                                       |  1990  Afghanistan  Flood      */
/*                                       |     all                                       |  1991  Afghanistan             */
/*                                       |   select                                      |  1992  Afghanistan             */
/*                                       |     n + 1                                     |  1993  Afghanistan  Epidemic   */
/*                                       |   from                                        |  1994  Afghanistan             */
/*                                       |     sequence                                  |  1995  Afghanistan             */
/*                                       |   where                                       |  1996  Afghanistan             */
/*                                       |     n<(select max(year) as maxyer from have)  |  1997  Afghanistan             */
/*                                       |   )                                           |  1998  Afghanistan             */
/*                                       |   select                                      |  1999  Afghanistan             */
/*                                       |     l.allyer                                  |  2000  Afghanistan  Storm      */
/*                                       |    ,r.unqcon                                  |  1990  Albania                 */
/*                                       |    ,m.disaster                                |  1991  Albania                 */
/*                                       |   from                                        |  1992  Albania      Landslid   */
/*                                       |     (select n as allyer from sequence) as l   |  1993  Albania                 */
/*                                       |   left join                                   |  1994  Albania      Storm      */
/*                                       |     (select                                   |  1995  Albania                 */
/*                                       |        distinct country as unqcon             |  1996  Albania                 */
/*                                       |      from                                     |  1997  Albania                 */
/*                                       |        have) as r                             |  1998  Albania                 */
/*                                       |   on                                          |  1999  Albania                 */
/*                                       |      1=1                                      |  2000  Albania      Epidemic   */
/*                                       |   left join                                   |                                */
/*                                       |      have as m                                |                                */
/*                                       |   on                                          |                                */
/*                                       |      l.allyer = m.year and                    |                                */
/*                                       |      m.country = r.unqcon                     |                                */
/*                                       |   order                                       |                                */
/*                                       |     by r.unqcon,l.allyer                      |                                */
/*                                       | ')                                            |                                */
/*                                       | want                                          |                                */
/*                                       | fn_tosas9x(                                   |                                */
/*                                       |       inp    = want                           |                                */
/*                                       |      ,outlib ="d:/sd1/"                       |                                */
/*                                       |      ,outdsn ="want"                          |                                */
/*                                       |      )                                        |                                */
/*                                       | ;;;;                                          |                                */
/*                                       | %utl_rendx;                                   |                                */
/*                                       |                                               |                                */
/*                                       | proc print data=sd1.want;                     |                                */
/*                                       | run;quit;                                     |                                */
/**************************************************************************************************************************/

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
input Country :$20.
      Year
      Disaster :$10.;
cards4;
Afghanistan 1990 Flood
Afghanistan 1993 Epidemic
Afghanistan 2000 Storm
Albania 1992 Landslide
Albania 1994 Storm
Albania 2000 Epidemic
;;;;
run;quit;

/**************************************************************************************************************************/
/* SD1.HAVE total obs=6                                                                                                   */
/*                                                                                                                        */
/* COUNTRY     YEAR DISASTER                                                                                              */
/* Afghanistan 1990 Flood                                                                                                 */
/* Afghanistan 1993 Epidemic                                                                                              */
/* Afghanistan 2000 Storm                                                                                                 */
/* Albania     1992 Landslide                                                                                             */
/* Albania     1994 Storm                                                                                                 */
/* Albania     2000 Epidemic                                                                                              */
/**************************************************************************************************************************/

/*                            _ _   _                 _
/ |  ___  __ _ ___  __      _(_) |_| |__    ___  __ _| |
| | / __|/ _` / __| \ \ /\ / / | __| `_ \  / __|/ _` | |
| | \__ \ (_| \__ \  \ V  V /| | |_| | | | \__ \ (_| | |
|_| |___/\__,_|___/   \_/\_/ |_|\__|_| |_| |___/\__, |_|
                                                   |_|
*/

* prety sure this is not needed but the sas doc is incomplete;

proc datasets lib=work nolist nodetails mt=cat;
 delete sasmac1 sasmac2 sasmac3;
run;quit;

%symdel minyer maxyer/nowarn;
data years;

* note dosubl sql is creating
 min year and max year as macro vars;

do year = %dosubl(%nrstr(proc sql;
              select
                min(year)
               ,max(year)
              into
                :minyer
               ,:maxyer
              from
                sd1.have;quit;))
          &minyer to &maxyer;
  output;
end;
run;

proc sql;
create table template as
  select distinct
    have.country,
    years.year,
    "None" as disaster length=10
  from sd1.have, years
;
quit;

data want;
update template sd1.have;
by country year;
run;

/**************************************************************************************************************************/
/* WORK.WANT total obs=22                                                                                                 */
/*  COUNTRY        YEAR    DISASTER                                                                                       */
/*                                                                                                                        */
/*  Afghanistan    1990    Flood                                                                                          */
/*  Afghanistan    1991    None                                                                                           */
/*  Afghanistan    1992    None                                                                                           */
/*  Afghanistan    1993    Epidemic                                                                                       */
/*  Afghanistan    1994    None                                                                                           */
/*  Afghanistan    1995    None                                                                                           */
/*  Afghanistan    1996    None                                                                                           */
/*  Afghanistan    1997    None                                                                                           */
/*  Afghanistan    1998    None                                                                                           */
/*  Afghanistan    1999    None                                                                                           */
/*  Afghanistan    2000    Storm                                                                                          */
/*  Albania        1990    None                                                                                           */
/*  Albania        1991    None                                                                                           */
/*  Albania        1992    Landslide                                                                                      */
/*  Albania        1993    None                                                                                           */
/*  Albania        1994    Storm                                                                                          */
/*  Albania        1995    None                                                                                           */
/*  Albania        1996    None                                                                                           */
/*  Albania        1997    None                                                                                           */
/*  Albania        1998    None                                                                                           */
/*  Albania        1999    None                                                                                           */
/*  Albania        2000    Epidemic                                                                                       */
/**************************************************************************************************************************/

/*___                   _
|___ \   _ __ ___  __ _| |
  __) | | `__/ __|/ _` | |
 / __/  | |  \__ \ (_| | |
|_____| |_|  |___/\__, |_|
                     |_|
*/

proc datasets lib=sd1 nolist nodetails;
 delete want;
run;quit;

%utl_rbeginx;
parmcards4;
library(haven)
library(sqldf)
source("c:/oto/fn_tosas9x.r")
options(sqldf.dll = "d:/dll/sqlean.dll")
have<-read_sas("d:/sd1/have.sas7bdat")
print(have)
want<-sqldf('
  with
    recursive sequence(n) as (
  select
    (select min(year) as minyer from have)
  union
    all
  select
    n + 1
  from
    sequence
  where
    n<(select max(year) as maxyer from have)
  )
  select
    l.allyer
   ,r.unqcon
   ,m.disaster
  from
    (select n as allyer from sequence) as l
  left join
    (select
       distinct country as unqcon
     from
       have) as r
  on
     1=1
  left join
     have as m
  on
     l.allyer = m.year and
     m.country = r.unqcon
  order
    by r.unqcon,l.allyer
')
want
fn_tosas9x(
      inp    = want
     ,outlib ="d:/sd1/"
     ,outdsn ="want"
     )
;;;;
%utl_rendx;

proc print data=sd1.want;
run;quit;

/**************************************************************************************************************************/
/*  > want                            |                                                                                   */
/*     allyer      unqcon  DISASTER   | ROWNAMES    ALLYER    UNQCON         DISASTER                                     */
/*                                    |                                                                                   */
/*  1    1990 Afghanistan     Flood   |     1        1990     Afghanistan    Flood                                        */
/*  2    1991 Afghanistan      <NA>   |     2        1991     Afghanistan                                                 */
/*  3    1992 Afghanistan      <NA>   |     3        1992     Afghanistan                                                 */
/*  4    1993 Afghanistan  Epidemic   |     4        1993     Afghanistan    Epidemic                                     */
/*  5    1994 Afghanistan      <NA>   |     5        1994     Afghanistan                                                 */
/*  6    1995 Afghanistan      <NA>   |     6        1995     Afghanistan                                                 */
/*  7    1996 Afghanistan      <NA>   |     7        1996     Afghanistan                                                 */
/*  8    1997 Afghanistan      <NA>   |     8        1997     Afghanistan                                                 */
/*  9    1998 Afghanistan      <NA>   |     9        1998     Afghanistan                                                 */
/*  10   1999 Afghanistan      <NA>   |    10        1999     Afghanistan                                                 */
/*  11   2000 Afghanistan     Storm   |    11        2000     Afghanistan    Storm                                        */
/*  12   1990     Albania      <NA>   |    12        1990     Albania                                                     */
/*  13   1991     Albania      <NA>   |    13        1991     Albania                                                     */
/*  14   1992     Albania Landslide   |    14        1992     Albania        Landslide                                    */
/*  15   1993     Albania      <NA>   |    15        1993     Albania                                                     */
/*  16   1994     Albania     Storm   |    16        1994     Albania        Storm                                        */
/*  17   1995     Albania      <NA>   |    17        1995     Albania                                                     */
/*  18   1996     Albania      <NA>   |    18        1996     Albania                                                     */
/*  19   1997     Albania      <NA>   |    19        1997     Albania                                                     */
/*  20   1998     Albania      <NA>   |    20        1998     Albania                                                     */
/*  21   1999     Albania      <NA>   |    21        1999     Albania                                                     */
/*  22   2000     Albania  Epidemic   |    22        2000     Albania        Epidemic                                     */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
