********************************************************************************
********************************************************************************
********************************************************************************
* Lee & Kim, SSQ 2024
* Replication Stata do-file 
* Transform a raw visit dataset to a compositional DV dataset
********************************************************************************
********************************************************************************
********************************************************************************
* DV polishing do file
********************************************************************************

cd "./"

********************************************************************************
* President visits 
import delimited "./Webscrapped/pre_data.csv", clear 
drop v1


* Cleansing based on remarks
split remarks, generate(rem) limit(1)
* Stop during tour
drop if rem1 == "Disembarked"
drop if rem1 == "Overnight"
drop if rem1 == "Stopped"
drop if rem1 == "Re-embarked"
drop if rem1 == "Rested"
drop if rem1 == "Refueling"
drop if rem1 == "Stopped"
drop if rem1 == "Stopover"
* Degree from Oxford
drop if rem1 == "Received"
* Private trip
drop if rem1 == "Fishing"
drop if rem1 == "Vacation."
drop if rem1 == "Vacationed"
drop if rem1 == "Toured"
* Pope 
drop if rem1 == "Audience"
* Regular Meeting 
*drop if rem1 == "Participated"
*drop if rem1 == "Attended"


* duplicates and remarks! 
duplicates drop country year remarks, force
duplicates r country year 

replace country = "Czechoslovakia" if country == "czechoslovakia"
replace country = "Yugoslavia" if country == "yugoslavia"
replace country = "Myanmar" if country == "Burma"
replace country = "Bosnia and Herzegovina" if country == "bosnia-herzegovina"

* Country Code and allies or adversaries
merge m:1 country using "./Merge/COW_ccodes.dta"
drop if _merge == 2
drop _merge

merge m:1 ccode year using "./Merge/rivalry.dta"
drop if _merge == 2
order country year rivalry
sort country year 
drop _merge 

merge m:1 ccode year using "./Merge/ally.dta"
drop if _merge == 2
drop _merge 

order country year rivalry defense
save "./Merge/raw_pre_visit.dta", replace

* Count outcomes 
use "./Merge/raw_pre_visit.dta", clear
bysort country year: gen pre_visit= _N
keep year rivalry defense country ccode sev_rivalry less_rivalry pre_visit
duplicates drop country year, force
replace rivalry = 0 if rivalry ==. 
replace sev_rivalry = 0 if sev_rivalry ==. 
replace less_rivalry = 0 if less_rivalry ==. 
replace defense = 0 if defense ==. 

bysort rivalry year: egen pre_riv_visit = sum(pre_visit)
replace pre_riv_visit = . if rivalry != 1

bysort defense year: egen pre_def_visit = sum(pre_visit)
replace pre_def_visit = . if defense != 1

bysort sev_rivalry year: egen pre_sriv_visit = sum(pre_visit)
replace pre_sriv_visit = . if sev_rivalry != 1

bysort less_rivalry year: egen pre_lriv_visit = sum(pre_visit)
replace pre_lriv_visit = . if less_rivalry != 1

gen others = .
replace others = 1 if rivalry == 0 & defense == 0
bysort others year: egen pre_oth_visit = sum(pre_visit)
replace pre_oth_visit = . if others != 1

drop country rivalry defense ccode sev_rivalry less_rivalry pre_visit others

duplicates drop year pre_riv_visit pre_def_visit pre_sriv_visit pre_lriv_visit pre_oth_visit, force
sort year

bysort year: replace pre_riv_visit = pre_riv_visit[_n-1] if _n > 1 & pre_riv_visit ==. 
bysort year: replace pre_def_visit = pre_def_visit[_n-1] if _n > 1 & pre_def_visit ==. 
bysort year: replace pre_sriv_visit = pre_sriv_visit[_n-1] if _n > 1 & pre_sriv_visit ==. 
bysort year: replace pre_lriv_visit = pre_lriv_visit[_n-1] if _n > 1 & pre_lriv_visit ==. 
bysort year: replace pre_oth_visit = pre_oth_visit[_n-1] if _n > 1 & pre_oth_visit ==. 
bysort year: keep if _n == _N

save "./Merge/pre_visit.dta", replace



***************************************************
* Secretary Visit Data
import delimited "./Webscrapped/sec_data.csv", clear 
drop v1

* Cleansing based on remarks 
split remarks, generate(rem) limit(1)
* Stop during tour
drop if rem1 == "Disembarked"
drop if rem1 == "Overnight"
drop if rem1 == "Stopped"
drop if rem1 == "Re-embarked"
drop if rem1 == "Rested"
drop if rem1 == "Refueling"
drop if rem1 == "Stopped"
drop if rem1 == "Embarked"
drop if rem1 == "Returned"
* Degree from Oxford
drop if rem1 == "Received"
* Private trip
drop if rem1 == "Fishing"
drop if rem1 == "Vacation."
drop if rem1 == "Honeymoon."
drop if rem1 == "Private"
drop if rem1 == "Vacation"
* Pope
drop if rem1 == "Audience"
* Accompanied with President
drop if rem1 == "Accompanied"
drop if rem1 == "Accoompanied"
drop if rem1 == "Joined"
* Regular meeting 
*drop if rem1 == "As"
*drop if rem1 == "Attended"
*drop if rem1 == "Chairman"
*drop if rem1 == "G-7"
*drop if rem1 == "Participated"


* Duplicate drops!
duplicates drop country year remarks, force
duplicates r country year 

replace country = "Czechoslovakia" if country == "czechoslovakia"
replace country = "Yugoslavia" if country == "yugoslavia"
replace country = "Myanmar" if country == "Burma"
replace country = "Bosnia and Herzegovina" if country == "bosnia-herzegovina"
replace country = "Democratic Republic of the Congo" if country == "Congo (Kinshasa)"
replace country = "Ivory Coast" if country == "CÃÂ´te dÃ¢ÂÂIvoire"
replace country = "St. Lucia" if country == "Saint Lucia"
replace country = "Bahamas" if country == "The Bahamas"
replace country = "East Timor" if country == "Timor-Leste"
replace country = "Democratic Republic of the Congo" if country == "congo-democratic-republic"
replace country = "German Democratic Republic" if country == "german-democratic-republic"

* Country Code
merge m:1 country using "./Merge/COW_ccodes.dta"
drop if _merge == 2
drop _merge

merge m:1 ccode year using "./Merge/rivalry.dta"
drop if _merge == 2
order country year rivalry
sort country year 
drop _merge 

merge m:1 ccode year using "./Merge/ally.dta"
drop if _merge == 2
drop _merge 

order country year rivalry defense
save "./Merge/raw_sec_visit.dta", replace

* Count Outcomes
use "./Merge/raw_sec_visit.dta", clear
bysort country year: gen sec_visit= _N
keep year rivalry defense country ccode sev_rivalry less_rivalry sec_visit
duplicates drop country year, force
replace rivalry = 0 if rivalry ==. 
replace sev_rivalry = 0 if sev_rivalry ==. 
replace less_rivalry = 0 if less_rivalry ==. 
replace defense = 0 if defense ==. 

bysort rivalry year: egen sec_riv_visit = sum(sec_visit)
replace sec_riv_visit = . if rivalry != 1

bysort defense year: egen sec_def_visit = sum(sec_visit)
replace sec_def_visit = . if defense != 1

bysort sev_rivalry year: egen sec_sriv_visit = sum(sec_visit)
replace sec_sriv_visit = . if sev_rivalry != 1

bysort less_rivalry year: egen sec_lriv_visit = sum(sec_visit)
replace sec_lriv_visit = . if less_rivalry != 1

gen others = .
replace others = 1 if rivalry == 0 & defense == 0
bysort others year: egen sec_oth_visit = sum(sec_visit)
replace sec_oth_visit = . if others != 1

drop country rivalry defense ccode sev_rivalry less_rivalry sec_visit others

duplicates drop year sec_riv_visit sec_def_visit sec_sriv_visit sec_lriv_visit sec_oth_visit, force
sort year

bysort year: replace sec_riv_visit = sec_riv_visit[_n-1] if _n > 1 & sec_riv_visit ==. 
bysort year: replace sec_def_visit = sec_def_visit[_n-1] if _n > 1 & sec_def_visit ==. 
bysort year: replace sec_sriv_visit = sec_sriv_visit[_n-1] if _n > 1 & sec_sriv_visit ==. 
bysort year: replace sec_lriv_visit = sec_lriv_visit[_n-1] if _n > 1 & sec_lriv_visit ==. 
bysort year: replace sec_oth_visit = sec_oth_visit[_n-1] if _n > 1 & sec_oth_visit ==. 
bysort year: keep if _n == _N

save "./Merge/sec_visit.dta", replace

********************************************************************************
** Compositional outcomes 
clear
set obs 123
gen year = 1899 + _n

merge 1:1 year using "./Merge/pre_visit.dta"
drop _merge
merge 1:1 year using "./Merge/sec_visit.dta"
drop if _merge ==2
drop _merge

* Deal with NAs 
replace pre_riv_visit = 0 if pre_riv_visit == .
replace pre_def_visit = 0 if pre_def_visit == .
replace pre_oth_visit = 0 if pre_oth_visit == .
replace pre_sriv_visit = 0 if pre_sriv_visit == .
replace pre_lriv_visit = 0 if pre_lriv_visit == .

replace sec_riv_visit = 0 if sec_riv_visit == .
replace sec_def_visit = 0 if sec_def_visit == .
replace sec_oth_visit = 0 if sec_oth_visit == .
replace sec_sriv_visit = 0 if sec_sriv_visit == .
replace sec_lriv_visit = 0 if sec_lriv_visit == .

* Deal with 0s
replace pre_riv_visit = pre_riv_visit + 0.01
replace pre_def_visit = pre_def_visit + 0.01
replace pre_oth_visit = pre_oth_visit + 0.01
replace pre_sriv_visit = pre_sriv_visit + 0.01
replace pre_lriv_visit = pre_lriv_visit + 0.01

replace sec_riv_visit = sec_riv_visit + 0.01
replace sec_def_visit = sec_def_visit + 0.01
replace sec_oth_visit = sec_oth_visit + 0.01
replace sec_sriv_visit = sec_sriv_visit + 0.01
replace sec_lriv_visit = sec_lriv_visit + 0.01

* Baseline
gen riv_visit = pre_riv_visit + sec_riv_visit
gen def_visit = pre_def_visit + sec_def_visit
gen oth_visit = pre_oth_visit + sec_oth_visit

* Total Pies
gen visit = riv_visit + def_visit + oth_visit

gen tot_visit1 = pre_riv_visit + pre_def_visit + pre_oth_visit + ///
	sec_riv_visit + sec_def_visit + sec_oth_visit
gen tot_visit2 = pre_sriv_visit + pre_lriv_visit + pre_def_visit + pre_oth_visit + ///
	sec_sriv_visit + sec_lriv_visit + sec_def_visit + sec_oth_visit

gen pre_visit1 = pre_riv_visit + pre_def_visit + pre_oth_visit 
gen pre_visit2 = pre_sriv_visit + pre_lriv_visit + pre_def_visit + pre_oth_visit 
gen sec_visit1 = sec_riv_visit + sec_def_visit + sec_oth_visit 
gen sec_visit2 = sec_sriv_visit + sec_lriv_visit + sec_def_visit + sec_oth_visit 
	
* Total Proportions 
gen p_riv = riv_visit /visit
gen p_def = def_visit /visit
gen p_oth = oth_visit /visit

gen p_tp1_riv = pre_riv_visit /tot_visit1
gen p_tp1_def = pre_def_visit /tot_visit1
gen p_tp1_oth = pre_oth_visit /tot_visit1
gen p_ts1_riv = sec_riv_visit /tot_visit1
gen p_ts1_def = sec_def_visit /tot_visit1
gen p_ts1_oth = sec_oth_visit /tot_visit1

gen p_tp2_sriv = pre_sriv_visit /tot_visit2
gen p_tp2_lriv = pre_lriv_visit /tot_visit2
gen p_tp2_def = pre_def_visit /tot_visit2
gen p_tp2_oth = pre_oth_visit /tot_visit2
gen p_ts2_sriv = sec_sriv_visit /tot_visit2
gen p_ts2_lriv = sec_lriv_visit /tot_visit2
gen p_ts2_def = sec_def_visit /tot_visit2
gen p_ts2_oth = sec_oth_visit /tot_visit2

* President Proportions
gen p_p1_riv = pre_riv_visit /pre_visit1
gen p_p1_def = pre_def_visit /pre_visit1
gen p_p1_oth = pre_oth_visit /pre_visit1

gen p_p2_sriv = pre_sriv_visit /pre_visit2
gen p_p2_lriv = pre_lriv_visit /pre_visit2
gen p_p2_def = pre_def_visit /pre_visit2
gen p_p2_oth = pre_oth_visit /pre_visit2

* Secretary Proportions 
gen p_s1_riv = sec_riv_visit /sec_visit1
gen p_s1_def = sec_def_visit /sec_visit1
gen p_s1_oth = sec_oth_visit /sec_visit1

gen p_s2_sriv = sec_sriv_visit /sec_visit2
gen p_s2_lriv = sec_lriv_visit /sec_visit2
gen p_s2_def = sec_def_visit /sec_visit2
gen p_s2_oth = sec_oth_visit /sec_visit2

* Log ratios
gen r_rivdef = log(p_riv/p_def)
gen r_othdef = log(p_oth/p_def)
gen r_rivoth = log(p_riv/p_oth)

gen pr_rivdef = log(p_p1_riv/p_p1_def)
gen pr_othdef = log(p_p1_oth/p_p1_def)
gen pr_rivoth = log(p_p1_riv/p_p1_oth)

gen sr_rivdef = log(p_s1_riv/p_s1_def)
gen sr_othdef = log(p_s1_oth/p_s1_def)
gen sr_rivoth = log(p_s1_riv/p_s1_oth)

	
save "./Merge/DVdata.dta", replace

