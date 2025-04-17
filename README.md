Replication Materials for:

“Travel to allies or adversaries? A compositional analysis of U.S. diplomatic visits”
Social Science Quarterly, 2024
Author: Jonghoon Lee  and James D. Kim
Email: jolee@astate.edu
Date: April 2025  

---

OVERVIEW  
This replication package includes all data, R & Stata code, and figures necessary to reproduce the results reported in the manuscript “Travel to allies or adversaries? A compositional analysis of U.S. diplomatic visits.” 

---

FOLDER STRUCTURE  
.
├── Analysis/             		 	<- Output folder for Stata gph files 
├── Figures/          			<- Output folder for figures  
├── Merge/         	  			<- Folder for raw and merging datasets
├── Webscrapped/        			<- Output folder for web-scrapped raw visit datasets
├── 1_Web Scrapping Visit Data.R	<- R script for web-scrapping U.S. diplomatic visit data
├── 2_DV Dataset.do			<- Stata do-file for constructing the DV dataset
├── 3_Comprehensive Dataset.do	<- Stata do-file for constructing the Master dataset
├── 4_Replications.do			<- Stata do-file for replication
├── Master.dta				<- Master data file 
└── README.txt         			<- This file

---

REQUIREMENTS  
- Stata 16 or higher  
- The following user-written Stata packages (install via `ssc install`):  
	- `coefplot’  
	- `estout’  
	- `dynsimpie’
	- `clarify’
	- `estsimp’
	- `sets’
---

DATA  
- Master.dta: Main dataset with year level information
- Merge/ folder includes: 
	- ally.dta				<- Yearly-level US ally data coded by ATOP data
	- COW_codes.dta			<- Country cow code data
	- disputes_all3.dta			<- Yearly-level US and allies’ MID count data
	- rivalry.dta				<- Yearly-level US adversaries data coded based on Diehl, Goertz, and Gallegos (2021)
	- USannualapproval.dta		<- Yearly-level US presidential approval ratings data from Gallup 
	- USecon.dta 			<- Yearly-level US economic variables (unemployment and inflation) data


---

INSTRUCTIONS  

1. Web Scrapping of Visit Data 
To collect and process the raw visit data from government websites, run the R script: 
	- 1_Web Scrapping Visit Data.R 
	- This script extracts presidential and secretary visit records from the website of the Office of the Historian and saves them in a structured format for merging.

2. Constructing a Compositional DV Dataset
To construct the time-series compositional dataset, run the Stata-do files: 
	- 2_DV Dataset.do 
	- This file processes the raw visit data by categorizing it according to visit purpose and destination country, 
	- generates a yearly dataset that counts how many US leaders visit in each composition (ally, adversary, and other), and
	- transforms the count outcomes into a compositional format.

3. Running Main Analyses and Replication
To replicate all analyses and generate figures and tables used in the manuscript, run: 
	- 4_Replications.do 
