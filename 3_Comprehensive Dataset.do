********************************************************************************
********************************************************************************
********************************************************************************
* Lee & Kim, SSQ 2024
* Replication Stata do-file 
* Structure a comprehensive dataset 
********************************************************************************
********************************************************************************
********************************************************************************

cd "./"

********************************************************************************
* 
*use "DVdata.dta", clear
use "./Merge/DVdata.dta", clear
*merge 1:1 year using "USecon.dta"
merge 1:1 year using "./Merge/USecon.dta"
drop _merge

*merge 1:1 year using "disputes_all3.dta"
merge 1:1 year using "./Merge/disputes_all3.dta"
drop if _merge == 2
drop _merge 

*merge 1:1 year using "USannualapproval.dta"
merge 1:1 year using "./Merge/USannualapproval.dta"
drop if _merge == 2
drop _merge 

order ccode stateabb year, first
replace ccode = 2
replace stateabb = "USA"
sort year

gen post_cw = 0
replace post_cw = 1 if year >1991

tsset year

** Election years
gen election = 0 
replace election = 1 if year == 1900
replace election = 1 if year == 1904
replace election = 1 if year == 1908
replace election = 1 if year == 1912
replace election = 1 if year == 1916
replace election = 1 if year == 1920
replace election = 1 if year == 1924
replace election = 1 if year == 1928
replace election = 1 if year == 1932
replace election = 1 if year == 1936
replace election = 1 if year == 1940
replace election = 1 if year == 1944
replace election = 1 if year == 1948
replace election = 1 if year == 1952
replace election = 1 if year == 1956
replace election = 1 if year == 1960
replace election = 1 if year == 1964
replace election = 1 if year == 1968
replace election = 1 if year == 1972
replace election = 1 if year == 1976
replace election = 1 if year == 1980
replace election = 1 if year == 1984
replace election = 1 if year == 1988
replace election = 1 if year == 1992
replace election = 1 if year == 1996
replace election = 1 if year == 2000
replace election = 1 if year == 2004
replace election = 1 if year == 2008
replace election = 1 if year == 2012
replace election = 1 if year == 2016
replace election = 1 if year == 2020

gen felection = f.election

gen inc_dem = 0
replace inc_dem = 1 if year >= 1913 & year <= 1920
replace inc_dem = 1 if year >= 1933 & year <= 1952
replace inc_dem = 1 if year >= 1961 & year <= 1968
replace inc_dem = 1 if year >= 1977 & year <= 1980
replace inc_dem = 1 if year >= 1993 & year <= 2000
replace inc_dem = 1 if year >= 2009 & year <= 2016

gen sec_term = .
replace sec_term = 0 if year >1951
replace sec_term = 1 if year >=1949 & year <= 1952
replace sec_term = 1 if year >=1957 & year <= 1960
replace sec_term = 1 if year >=1973 & year <= 1974
replace sec_term = 1 if year >=1985 & year <= 1988
replace sec_term = 1 if year >=1997 & year <= 2000
replace sec_term = 1 if year >=2005 & year <= 2008
replace sec_term = 1 if year >=2013 & year <= 2016

gen div_gov_and = 0
replace  div_gov_and = 1 if year == 1920
replace  div_gov_and = 1 if year >= 1948 & year <= 1949
replace  div_gov_and = 1 if year >= 1956 & year <= 1960
replace  div_gov_and = 1 if year >= 1969 & year <= 1976
replace  div_gov_and = 1 if year >= 1988 & year <= 1992
replace  div_gov_and = 1 if year >= 1996 & year <= 2000
replace  div_gov_and = 1 if year == 2008 
replace  div_gov_and = 1 if year == 2016 

gen div_gov_or = 0
replace  div_gov_or = 1 if year == 1912 
replace  div_gov_or = 1 if year == 1920
replace  div_gov_or = 1 if year == 1932
replace  div_gov_or = 1 if year >= 1948 & year <= 1949
replace  div_gov_or = 1 if year >= 1956 & year <= 1960
replace  div_gov_or = 1 if year >= 1969 & year <= 1976
replace  div_gov_or = 1 if year >= 1981 & year <= 1992
replace  div_gov_or = 1 if year >= 1996 & year <= 2008 
replace  div_gov_or = 1 if year >= 2012 & year <= 2016 
replace  div_gov_or = 1 if year == 2020

gen div_gov_sen = 0
replace  div_gov_sen = 1 if year == 1920
replace  div_gov_sen = 1 if year >= 1948 & year <= 1949
replace  div_gov_sen = 1 if year >= 1956 & year <= 1960
replace  div_gov_sen = 1 if year >= 1969 & year <= 1976
replace  div_gov_sen = 1 if year >= 1988 & year <= 1992
replace  div_gov_sen = 1 if year >= 1996 & year <= 2003
replace  div_gov_sen = 1 if year == 2008 
replace  div_gov_sen = 1 if year == 2016 

gen div_gov_hou = 0
replace  div_gov_hou = 1 if year == 1912 
replace  div_gov_hou = 1 if year == 1920
replace  div_gov_hou = 1 if year == 1932
replace  div_gov_hou = 1 if year >= 1948 & year <= 1949
replace  div_gov_hou = 1 if year >= 1956 & year <= 1960
replace  div_gov_hou = 1 if year >= 1969 & year <= 1976
replace  div_gov_hou = 1 if year >= 1981 & year <= 1992
replace  div_gov_hou = 1 if year >= 1996 & year <= 2000 
replace  div_gov_hou = 1 if year == 2008
replace  div_gov_hou = 1 if year >= 2012 & year <= 2016 
replace  div_gov_hou = 1 if year == 2020

egen st_unemp = std(unemp)
egen st_unpopularity = std(unpopularity)
egen st_midcount = std(midcount)
egen st_ally_midcount_high = std(ally_midcount_high)

gen int_d_unemp = d.unemp *div_gov_and 
gen int_l_unpopularity = l.unpopularity *div_gov_and 
gen int_midcount = midcount *div_gov_and 
gen int_ally_midcount_high = ally_midcount_high *div_gov_and 


gen ints_d_unemp = d.unemp *div_gov_sen 
gen ints_l_unpopularity = l.unpopularity *div_gov_sen 
gen ints_midcount = midcount *div_gov_sen 
gen ints_ally_midcount_high = ally_midcount_high *div_gov_sen 

gen inth_d_unemp = d.unemp *div_gov_hou 
gen inth_l_unpopularity = l.unpopularity *div_gov_hou 
gen inth_midcount = midcount *div_gov_hou 
gen inth_ally_midcount_high = ally_midcount_high *div_gov_hou 


gen trend = .
replace trend = year -1960 if year > 1959

save "Master.dta", replace

