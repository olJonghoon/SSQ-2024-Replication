********************************************************************************
********************************************************************************
********************************************************************************
* Lee & Kim, SSQ 2024
* Replication Stata do-file 
* Replicate Graphs and Analyses
********************************************************************************
********************************************************************************
********************************************************************************

cd "./"
use "Master.dta", clear

********************************************************************************
* Figure 1 

tsset year

set scheme plotplain, perm

gen zero = 0
replace pre_def_visit = pre_def_visit + pre_riv_visit
replace pre_oth_visit = pre_def_visit + pre_oth_visit
twoway rarea zero pre_riv_visit year, color(gs4) /// 
    || rarea pre_riv_visit pre_def_visit year, color(gs12) /// 
    || rarea pre_def_visit pre_oth_visit year, color(gs7)  /// 
    || if year > 1950 & year <2011 ///
	, legend(off) /// 
     xla(1950(20)2010) xtitle("Year") ytitle("Travel Abroad, President") ///
	graphregion(margin(2 2 2 2)) plotregion(margin(2 2 0 0)) scheme(plotplain)
graph export "./Figures/Figure1a.pdf", replace

replace p_p1_def = p_p1_def + p_p1_riv
replace p_p1_oth = p_p1_def + p_p1_oth
twoway rarea zero p_p1_riv year, color(gs4) /// 
    || rarea p_p1_riv p_p1_def year, color(gs12) /// 
    || rarea p_p1_def p_p1_oth year, color(gs7)  /// 
    || if year > 1950 & year <2011 ///
	, legend(order(3 "Other" 2 "Ally" 1 "Adversary") rows(3) position(3)) /// 
     xla(1950(20)2010) xtitle("Year") ytitle("Travel Abroad, President") scheme(plotplain) ///
	graphregion(margin(2 2 2 2)) plotregion(margin(2 2 0 0))
graph export "./Figures/Figure1b.pdf", replace


********************************************************************************
* Table 1 

cd "./"
use "Master.dta", clear
cd "./Analysis/"

dynsimpiecoef d.unemp l.unpopularity midcount ally_midcount_high ///
	inth_d_unemp inth_l_unpopularity l.sr_rivdef l.sr_othdef ///
	d.pre_visit1 trend, dummy(post_cw inc_dem div_gov_hou) ///
	dvs(p_p1_riv p_p1_def p_p1_oth) ar(1) sigs(90 95) 
estimates store pie1

estout pie1, unstack cells(b(star fmt(3)) se(par)) stats(r2 N, fmt(%9.3f %9.0g)) legend label style(tex)

********************************************************************************
* President Visits
dynsimpiecoef d.unemp l.unpopularity midcount ally_midcount_high ///
	inth_d_unemp inth_l_unpopularity l.sr_rivdef l.sr_othdef ///
	d.pre_visit1 trend, dummy(post_cw inc_dem div_gov_hou) ///
	dvs(p_p1_riv p_p1_def p_p1_oth) ar(1) sigs(90 95) 
estimates store p1
* p1: def/ riv

dynsimpiecoef d.unemp l.unpopularity midcount ally_midcount_high ///
	inth_d_unemp inth_l_unpopularity l.sr_rivdef l.sr_othdef ///
	d.pre_visit1 trend, dummy(post_cw inc_dem div_gov_hou) ///
	dvs(p_p1_oth p_p1_def p_p1_riv) ar(1) sigs(90 95) 
estimates store p2
* p2: def/ oth

dynsimpiecoef d.unemp l.unpopularity midcount ally_midcount_high ///
	inth_d_unemp inth_l_unpopularity l.sr_rivdef l.sr_othdef ///
	d.pre_visit1 trend, dummy(post_cw inc_dem div_gov_hou) ///
	dvs(p_p1_oth p_p1_riv p_p1_def) ar(1) sigs(90 95) 
estimates store p3
* p3: riv/ oth

* Secretary Visits
dynsimpiecoef d.unemp l.unpopularity midcount ally_midcount_high ///
	inth_d_unemp inth_l_unpopularity l.pr_rivdef l.pr_othdef ///
	d.sec_visit1 trend, dummy(post_cw inc_dem div_gov_hou) ///
	dvs(p_s1_riv p_s1_def p_s1_oth) ar(1) sigs(90 95) 
estimates store s1

dynsimpiecoef d.unemp l.unpopularity midcount ally_midcount_high ///
	inth_d_unemp inth_l_unpopularity l.pr_rivdef l.pr_othdef ///
	d.sec_visit1 trend, dummy(post_cw inc_dem div_gov_hou) ///
	dvs(p_s1_oth p_s1_def p_s1_riv) ar(1) sigs(90 95) 
estimates store s2

dynsimpiecoef d.unemp l.unpopularity midcount ally_midcount_high ///
	inth_d_unemp inth_l_unpopularity l.pr_rivdef l.pr_othdef ///
	d.sec_visit1 trend, dummy(post_cw inc_dem div_gov_hou) ///
	dvs(p_s1_oth p_s1_riv p_s1_def) ar(1) sigs(90 95) 
estimates store s3

********************************************************************************
* Figure 2 

coefplot p1 p2 p3, bylabel(President Visits) ///
	|| s1 s2 s3, bylabel(Secretary Visits) ///
	|| , keep(midcount ally_midcount_high) xline(0) levels(95 90) scheme(plotplain) ///
	ylabel(1 "US Disputes" 2 "Ally Disputes") legend(rows(1))
graph export "~/Figures/Figure2.pdf", replace

********************************************************************************
* Figure 3

coefplot p1 p2 p3, bylabel(President Visits) ///
	|| s1 s2 s3, bylabel(Secretary Visits) ///
	|| , keep(lag__unpopularity inth_l_unpopularity) xline(0) levels(95 90) scheme(plotplain) 	///
	ylabel(1 "Unpopularity" 2 "Divided Government * Unpopularity") legend(rows(1))
graph export "~/Figures/Figure3.pdf", replace

********************************************************************************
* Figure 4

dynsimpie d.unemp midcount ally_midcount_high l.sr_rivdef l.sr_othdef ///
	d.pre_visit1 trend, dummy(post_cw inc_dem) dummyset(1 0) ///
	dvs(p_p1_def p_p1_oth p_p1_riv) ar(1) sigs(90) ///
	shockvars(l.unpopularity) inter(div_gov_hou) intype(on) shockvals(13.8)
effectsplot
graph export "~/Figures/Figure4.pdf", replace


********************************************************************************
* Appendix
********************************************************************************
* Table 3

dynsimpiecoef d.unemp l.unpopularity midcount ally_midcount_high ///
	inth_d_unemp inth_l_unpopularity l.sr_rivdef l.sr_othdef ///
	d.pre_visit1 trend, dummy(post_cw inc_dem div_gov_hou) ///
	dvs(p_p1_riv p_p1_def p_p1_oth) ar(1) sigs(90 95) 
	
sureg 	(pre_riv_visit l.pre_riv_visit div_gov_hou##c.d.unemp div_gov_hou##c.l.unpopularity ///
			midcount ally_midcount_high d.visit trend post_cw inc_dem) ///
		(pre_def_visit l.pre_def_visit div_gov_hou##c.d.unemp div_gov_hou##c.l.unpopularity ///
			midcount ally_midcount_high d.visit trend post_cw inc_dem) ///
		(pre_oth_visit l.pre_oth_visit div_gov_hou##c.d.unemp div_gov_hou##c.l.unpopularity ///
			midcount ally_midcount_high d.visit trend post_cw inc_dem)
			
summarize  p_p1_def p_p1_riv p_p1_oth p_s1_def p_s1_riv p_s1_oth ///
	midcount ally_midcount_high unpopularity unemp post_cw inc_dem div_gov_hou ///
	year pre_visit1 sec_visit1 if e(sample)

	
********************************************************************************
* Secretary 

gen zero = 0	
replace sec_def_visit = sec_def_visit + sec_riv_visit
replace sec_oth_visit = sec_def_visit + sec_oth_visit
twoway rarea zero sec_riv_visit year, color(gs4) /// 
    || rarea sec_riv_visit sec_def_visit year, color(gs12) /// 
    || rarea sec_def_visit sec_oth_visit year, color(gs7)  /// 
    || if year > 1950 & year <2011 ///
	, legend(off) /// 
     xla(1950(20)2010) xtitle("Year") ytitle("Travel Abroad, Secretary") scheme(plotplain) ///
	graphregion(margin(2 2 2 2)) plotregion(margin(2 2 0 0))
graph export "~/Figures/Figure5a.pdf", replace
	
replace p_s1_def = p_s1_def + p_s1_riv
replace p_s1_oth = p_s1_def + p_s1_oth
twoway rarea zero p_s1_riv year, color(gs4) /// 
    || rarea p_s1_riv p_s1_def year, color(gs12) /// 
    || rarea p_s1_def p_s1_oth year, color(gs7)  /// 
    || if year > 1950 & year <2011 ///
	, legend(order(3 "Other" 2 "Ally" 1 "Adversary") rows(3) position(3)) /// 
     xla(1950(20)2010) xtitle("Year") ytitle("Travel Abroad, Secretary") scheme(plotplain) ///
	graphregion(margin(2 2 2 2)) plotregion(margin(2 2 0 0))
graph export "~/Figures/Figure5b.pdf", replace
	
********************************************************************************
* Table 4

cd "./"
use "Master.dta", clear
cd "./Analysis/"

dynsimpiecoef d.unemp l.unpopularity midcount ally_midcount_high ///
	inth_d_unemp inth_l_unpopularity l.pr_rivdef l.pr_othdef ///
	d.sec_visit1 trend, dummy(post_cw inc_dem div_gov_hou) ///
	dvs(p_s1_riv p_s1_def p_s1_oth) ar(1) sigs(90 95) 
estimates store pie2
estout pie2, unstack cells(b(star fmt(3)) se(par)) stats(r2 N, fmt(%9.3f %9.0g)) legend label style(tex)

********************************************************************************
* Figure 6

dynsimpie d.unemp midcount ally_midcount_high l.sr_rivdef l.sr_othdef ///
	d.pre_visit1 trend, dummy(post_cw inc_dem) dummyset(1 0) ///
	dvs(p_p1_def p_p1_oth p_p1_riv) ar(1) sigs(90) ///
	shockvars(l.unpopularity) inter(div_gov_hou) intype(off) shockvals(13.8)
effectsplot
graph export "~/Figures/Figure6.pdf", replace

********************************************************************************
* Figure 7

coefplot p1 p2 p3, bylabel(President Visits) ///
	|| s1 s2 s3, bylabel(Secretary Visits) ///
	|| , keep(diff__unemp inth_d_unemp) xline(0) levels(95 90) scheme(plotplain) 	///
	ylabel(1 "{&Delta}Unemployment" 2 "Divided Government * {&Delta}Unemployment") legend(rows(1))
graph export "~/Figures/Figure7.pdf", replace

********************************************************************************
* Figure 8
coefplot p1 p2 p3, bylabel(President Visits) ///
	|| s1 s2 s3, bylabel(Secretary Visits) ///
	|| , keep(post_cw inc_dem div_gov_hou) xline(0) levels(95 90) scheme(plotplain) 	///
	ylabel(1 "Post-Cold War" 2 "Incumbent Partisanship" 3 "Divided Government") legend(rows(1))
graph export "~/Figures/Figure8.pdf", replace

********************************************************************************
* Table 5

sureg 	(pre_def_visit l.pre_def_visit midcount ally_midcount_high div_gov_hou##c.l.unpopularity ///
		div_gov_hou##c.d.unemp post_cw inc_dem ld.sec_riv_visit ld.sec_def_visit ld.sec_oth_visit trend) ///
		(pre_riv_visit l.pre_riv_visit midcount ally_midcount_high div_gov_hou##c.l.unpopularity ///
		div_gov_hou##c.d.unemp post_cw inc_dem ld.sec_riv_visit ld.sec_def_visit ld.sec_oth_visit trend) ///
		(pre_oth_visit l.pre_oth_visit midcount ally_midcount_high div_gov_hou##c.l.unpopularity ///
		div_gov_hou##c.d.unemp post_cw inc_dem ld.sec_riv_visit ld.sec_def_visit ld.sec_oth_visit trend)
estimates store count1 
estout count1, unstack cells(b(star fmt(3)) se(par)) stats(r2 N, fmt(%9.3f %9.0g)) legend label style(tex) 

********************************************************************************
* Table 6

sureg 	(sec_def_visit l.sec_def_visit midcount ally_midcount_high div_gov_hou##c.l.unpopularity ///
		div_gov_hou##c.d.unemp post_cw inc_dem ld.pre_riv_visit ld.pre_def_visit ld.pre_oth_visit trend) ///
		(sec_riv_visit l.sec_riv_visit midcount ally_midcount_high div_gov_hou##c.l.unpopularity ///
		div_gov_hou##c.d.unemp post_cw inc_dem ld.pre_riv_visit ld.pre_def_visit ld.pre_oth_visit trend) ///
		(sec_oth_visit l.sec_oth_visit midcount ally_midcount_high div_gov_hou##c.l.unpopularity ///
		div_gov_hou##c.d.unemp post_cw inc_dem ld.pre_riv_visit ld.pre_def_visit ld.pre_oth_visit trend)
estimates store count2 
estout count2, unstack cells(b(star fmt(3)) se(par)) stats(r2 N, fmt(%9.3f %9.0g)) legend label style(tex) 


