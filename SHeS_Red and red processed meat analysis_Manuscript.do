
*******************************************************************************************
*Manuscript: "Red and red processed meat (RRPM) consumption behaviours in Scottish adults"

*Data analysis do-file for the manuscript 
********************************************************************************************

****************
*Clear settings*
****************
clear all
clear matrix
macro drop _all
graph drop _all


**************************************************************
*Assign values using global macros for file location and date*
**************************************************************

global location "K:\DrJaacksGroup\FSS - Dietary Monitoring\SHeS\SHeS 2021\RRPM paper" 
global data `"$location\Data"'
global output `"$location\Output"'
global date "20231912"

set maxvar 10000

*Read in data
use "$data\SHeS 2021_participantlevel_rrpm_manuscript$date.dta", clear
*Assign survey weights
svyset [pweight=SHeS_Intake24_wt_sc], psu(psu) strata(Strata)


*Re-coding minus ethnicity values so regressions will run
replace Ethnic05=999 if Ethnic05==-9
replace Ethnic05=888 if Ethnic05==-8
replace Ethnic05=666 if Ethnic05==-6
replace Ethnic05=222 if Ethnic05==-2
replace Ethnic05=111 if Ethnic05==-1


*Create binary variables for consumer tertile subpops
	*Add non-consumers into consumer tertiles
	replace RRPM_Tertile=0 if RRPM_Tertile==. & intake24==1

	*Non consumers
	gen RRPM_Tertile_0=0
	replace RRPM_Tertile_0=1 if RRPM_Tertile==0
	*Low consumers
	gen RRPM_Tertile_1=0
	replace RRPM_Tertile_1=1 if RRPM_Tertile==1
	*Medium consumers
	gen RRPM_Tertile_2=0
	replace RRPM_Tertile_2=1 if RRPM_Tertile==2
	*High consumers
	gen RRPM_Tertile_3=0
	replace RRPM_Tertile_3=1 if RRPM_Tertile==3

	*Create non-consumer subpop
	gen RRPM_Nonconsumer=.
	replace RRPM_Nonconsumer=1 if RRPM_Tertile==0
	replace RRPM_Nonconsumer=0 if RRPM_Tertile!=0 & intake24==1

********************************
*Explore proportion of consumers
********************************
ta intake24 if age >=16
ta RRPMConsumer
svy, subpop(intake24): prop RRPMConsumer, percent
	
	*Proportion with two recalls
	ta TwoRecalls if RRPMConsumer==1
	svy, subpop(RRPMConsumer): prop TwoRecalls, percent
	*Proportion who consumed RRPM on both days
	svy, subpop(RRPMConsumer if TwoRecalls==1): prop RRPMConsumer_Days, percent
		*Across tertiles
		svy, subpop(RRPM_Tertile_1 if TwoRecalls==1): prop RRPMConsumer_Days, percent
		svy, subpop(RRPM_Tertile_2 if TwoRecalls==1): prop RRPMConsumer_Days, percent
		svy, subpop(RRPM_Tertile_3 if TwoRecalls==1): prop RRPMConsumer_Days, percent

	
/*======================================================
Explore demographic characteristics by consumer tertile
=======================================================*/

*Summarise mean intakes
	*Among consumers
	svy, subpop(RRPMConsumer): mean Avg_Day_RRPM
	*By consumer tertiles:
	svy, subpop(RRPM_Tertile_1): mean Avg_Day_RRPM
	svy, subpop(RRPM_Tertile_2): mean Avg_Day_RRPM
	svy, subpop(RRPM_Tertile_3): mean Avg_Day_RRPM

*Demographics of consumers overall	
	*Unweighted n's
	ta Sex if RRPMConsumer==1
	ta age_cat if RRPMConsumer==1
	ta Ethnic05 if RRPMConsumer==1, miss
	ta simd20_sga if RRPMConsumer==1
	
	summ age if RRPMConsumer==1

	*Weighted %
	svy, subpop(RRPMConsumer): prop Sex, percent
	svy, subpop(RRPMConsumer): prop age_cat, percent
	svy, subpop(RRPMConsumer): prop Ethnic05, percent
	svy, subpop(RRPMConsumer): prop simd20_sga, percent

*Demographics by consumer tertiles
	*Unweighted n's
	bysort RRPM_Tertile: ta Sex if intake24==1
	bysort RRPM_Tertile: ta age_cat if intake24==1
	bysort RRPM_Tertile: ta Ethnic05 if intake24==1
	bysort RRPM_Tertile: ta simd20_sga if intake24==1

	*Weighted %
	svy, subpop(intake24): prop Sex, over(RRPM_Tertile) percent
	svy, subpop(intake24): prop age_cat, over(RRPM_Tertile) percent
	svy, subpop(intake24): prop Ethnic05, over(RRPM_Tertile) percent
	svy, subpop(intake24): prop simd20_sga, over(RRPM_Tertile) percent
		
/*=============================================
Explore mean daily intakes by consumer tertiles
===============================================*/
svy, subpop(RRPMConsumer): mean Avg_Day_RRPM
svy, subpop(RRPMConsumer): mean Avg_Day_RRPM, over(RRPM_Tertile)


/*=========================================
Explore proportion of RRPM that is processed
============================================*/

*All consumers
svy, subpop(RRPMConsumer): mean Prop_RedProcessed Prop_RedUnprocessed
svy, subpop(RRPMConsumer): mean Prop_BeefProcessed Prop_PorkProcessed Prop_LambProcessed Prop_GameProcessed
estat sd

	*Across consumer tertiles
	svy, subpop(RRPMConsumer): mean Prop_BeefProcessed Prop_PorkProcessed Prop_LambProcessed Prop_GameProcessed if RRPM_Tertile==1
	estat sd

	svy, subpop(RRPMConsumer): mean Prop_BeefProcessed Prop_PorkProcessed Prop_LambProcessed Prop_GameProcessed if RRPM_Tertile==2
	estat sd

	svy, subpop(RRPMConsumer): mean Prop_BeefProcessed Prop_PorkProcessed Prop_LambProcessed Prop_GameProcessed if RRPM_Tertile==3
	estat sd
  

/*===================================================
Test for differences in odds of being a RRPM consumer
====================================================*/

*Simple logistic regression
svy, subpop(intake24): logit RRPMConsumer ib(2).Sex i.age_cat i.simd20_sga Avg_Day_Kcal, or
svy, subpop(intake24): prop RRPMConsumer, over(Sex) percent

*Ordinal logistic regressions
svy, subpop(RRPMConsumer): ologit RRPM_Tertile ib(2).Sex i.age_cat i.simd20_sga Avg_Day_Kcal, or

svy, subpop(RRPMConsumer): prop RRPM_Tertile, over(Sex) percent
svy, subpop(RRPMConsumer): prop RRPM_Tertile, over(simd20_sga) percent


/*====================================
Explore avg intakes by meal occasion
======================================*/

*All consumers
	svy, subpop(RRPMConsumer): mean Prop_Bfast_RRPM 
	svy, subpop(RRPMConsumer): mean Prop_Lunch_RRPM 
	svy, subpop(RRPMConsumer): mean Prop_Dinner_RRPM 
	svy, subpop(RRPMConsumer): mean Prop_Snacks_RRPM

*Across consumer tertiles
	svy, subpop(RRPMConsumer): mean Prop_Bfast_RRPM, over(RRPM_Tertile) 
	svy, subpop(RRPMConsumer): mean Prop_Lunch_RRPM, over(RRPM_Tertile) 
	svy, subpop(RRPMConsumer): mean Prop_Dinner_RRPM, over(RRPM_Tertile) 
	svy, subpop(RRPMConsumer): mean Prop_Snacks_RRPM, over(RRPM_Tertile) 

	
/*====================================
Explore avg intakes by purchase location
======================================*/

*All consumers
	svy, subpop(RRPMConsumer): mean Prop_Location_Supermarket_RRPM 
	svy, subpop(RRPMConsumer): mean Prop_Location_Restaurants_RRPM 
	svy, subpop(RRPMConsumer): mean Prop_Location_Other_RRPM 
	  
*Across consumer tertiles
	svy, subpop(RRPMConsumer): mean Prop_Location_Supermarket_RRPM, over(RRPM_Tertile) 
	svy, subpop(RRPMConsumer): mean Prop_Location_Restaurants_RRPM, over(RRPM_Tertile) 
	svy, subpop(RRPMConsumer): mean Prop_Location_Other_RRPM, over(RRPM_Tertile) 


/*====================================
Explore avg intakes by day of the week
======================================*/

*All consumers
	svy, subpop(RRPMConsumer): mean Avg_Mon_RRPM
	svy, subpop(RRPMConsumer): mean Avg_Tues_RRPM
	svy, subpop(RRPMConsumer): mean Avg_Wed_RRPM
	svy, subpop(RRPMConsumer): mean Avg_Thurs_RRPM
	svy, subpop(RRPMConsumer): mean Avg_Fri_RRPM
	svy, subpop(RRPMConsumer): mean Avg_Sat_RRPM
	svy, subpop(RRPMConsumer): mean Avg_Sun_RRPM

*Across consumer tertiles
	svy, subpop(RRPMConsumer): mean Avg_Mon_RRPM, over(RRPM_Tertile) 
	svy, subpop(RRPMConsumer): mean Avg_Tues_RRPM, over(RRPM_Tertile) 
	svy, subpop(RRPMConsumer): mean Avg_Wed_RRPM, over(RRPM_Tertile) 
	svy, subpop(RRPMConsumer): mean Avg_Thurs_RRPM, over(RRPM_Tertile) 
	svy, subpop(RRPMConsumer): mean Avg_Fri_RRPM, over(RRPM_Tertile) 
	svy, subpop(RRPMConsumer): mean Avg_Sat_RRPM, over(RRPM_Tertile) 
	svy, subpop(RRPMConsumer): mean Avg_Sun_RRPM, over(RRPM_Tertile) 


/*=========================================================================
Export avg intakes of RPM over all consumers and consumer tertiles to Excel
==========================================================================*/

matrix avgmeat = J(34, 6, .) 	
local r=2

quietly foreach var of varlist Avg_Day_RRPM Avg_Day_RedUnprocessed Avg_Day_RedProcessed {

		*Among consumers
		sum `var' if RRPMConsumer==1
		matrix avgmeat[`r',1]=r(N)
		
		svy, subpop(RRPMConsumer): mean `var'
		estat sd
		matrix avgmeat[`r',2]=r(mean) 
		matrix avgmeat[`r',4]=r(sd) 
		
		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if RRPMConsumer==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r',3]=r(r2)
		matrix avgmeat[`r',5]=r(r1)
		matrix avgmeat[`r',6]=r(r3)

		*Low consumers
		sum `var' if RRPM_Tertile==1
		matrix avgmeat[`r'+4,1]=r(N) 

		svy, subpop(RRPM_Tertile_1): mean `var'
		estat sd
		matrix avgmeat[`r'+4,2]=r(mean) 
		matrix avgmeat[`r'+4,4]=r(sd) 

		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if RRPM_Tertile==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+4,3]=r(r2) 
		matrix avgmeat[`r'+4,5]=r(r1) 
		matrix avgmeat[`r'+4,6]=r(r3) 

		*Medium consumers
		sum `var' if RRPM_Tertile==2
		matrix avgmeat[`r'+8,1]=r(N) 

		svy, subpop(RRPM_Tertile_2): mean `var'
		estat sd
		matrix avgmeat[`r'+8,2]=r(mean) 
		matrix avgmeat[`r'+8,4]=r(sd) 

		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if RRPM_Tertile==1, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+8,3]=r(r2) 
		matrix avgmeat[`r'+8,5]=r(r1) 
		matrix avgmeat[`r'+8,6]=r(r3) 

		*High consumers
		sum `var' if RRPM_Tertile==3
		matrix avgmeat[`r'+12,1]=r(N) 

		svy, subpop(RRPM_Tertile_3): mean `var'
		estat sd
		matrix avgmeat[`r'+12,2]=r(mean) 
		matrix avgmeat[`r'+12,4]=r(sd) 

		_pctile `var' [pweight=SHeS_Intake24_wt_sc] if RRPM_Tertile==3, p(2.5, 50, 97.5)
		matrix avgmeat[`r'+12,3]=r(r2) 
		matrix avgmeat[`r'+12,5]=r(r1) 
		matrix avgmeat[`r'+12,6]=r(r3) 
		
		local r=`r'+1
}	


*Export to Excel 
	putexcel set "$output\SHeS Red and red processed meat.xlsx", sheet("Avg intakes") modify
	putexcel B2=matrix(avgmeat)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="Median" 
	putexcel E1="SD" 
	putexcel F1="2.5th percentile" 
	putexcel G1="97.5th percentile"
		

/*======================================================
Export meal occasion grams by consumer tertile to excel
========================================================*/

matrix avgmeat = J(21, 3, .) 	
local r=2

quietly foreach var of varlist Avg_Bfast_RRPM Avg_Lunch_RRPM Avg_Dinner_RRPM Avg_Snacks_RRPM {

		*Overall
		sum `var' if RRPMConsumer==1
		matrix avgmeat[`r',1]=r(N)
		
		svy, subpop(RRPMConsumer): mean `var'
		estat sd
		matrix avgmeat[`r',2]=r(mean) 
		matrix avgmeat[`r',3]=r(sd) 
				
		*Low consumers
		sum `var' if RRPM_Tertile==1
		matrix avgmeat[`r'+5,1]=r(N) 

		svy, subpop(RRPM_Tertile_1): mean `var'
		estat sd
		matrix avgmeat[`r'+5,2]=r(mean) 
		matrix avgmeat[`r'+5,3]=r(sd) 

		*Medium consumers
		sum `var' if RRPM_Tertile==2
		matrix avgmeat[`r'+10,1]=r(N) 

		svy, subpop(RRPM_Tertile_2): mean `var'
		estat sd
		matrix avgmeat[`r'+10,2]=r(mean) 
		matrix avgmeat[`r'+10,3]=r(sd) 

		*High consumers
		sum `var' if RRPM_Tertile==3
		matrix avgmeat[`r'+15,1]=r(N) 

		svy, subpop(RRPM_Tertile_3): mean `var'
		estat sd
		matrix avgmeat[`r'+15,2]=r(mean) 
		matrix avgmeat[`r'+15,3]=r(sd) 
	
		local r=`r'+1
}	

*Export to Excel 
	putexcel set "$output\SHeS Red and red processed meat.xlsx", sheet("Meal occasions g") modify
	putexcel B2=matrix(avgmeat)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD" 

/*============================================================
Export meal occasion contribution by consumer tertile to excel
=============================================================*/

matrix avgmeat = J(21, 3, .) 	
local r=2

quietly foreach var of varlist Prop_Bfast_RRPM Prop_Lunch_RRPM Prop_Dinner_RRPM Prop_Snacks_RRPM {

		*Overall
		sum `var'
		matrix avgmeat[`r',1]=r(N)
		
		svy, subpop(RRPMConsumer): mean `var'
		estat sd
		matrix avgmeat[`r',2]=r(mean) 
		matrix avgmeat[`r',3]=r(sd) 
				
		*Low consumers
		sum `var' if RRPM_Tertile==1
		matrix avgmeat[`r'+5,1]=r(N) 

		svy, subpop(RRPM_Tertile_1): mean `var'
		estat sd
		matrix avgmeat[`r'+5,2]=r(mean) 
		matrix avgmeat[`r'+5,3]=r(sd) 

		*Medium consumers
		sum `var' if RRPM_Tertile==2
		matrix avgmeat[`r'+10,1]=r(N) 

		svy, subpop(RRPM_Tertile_2): mean `var'
		estat sd
		matrix avgmeat[`r'+10,2]=r(mean) 
		matrix avgmeat[`r'+10,3]=r(sd) 

		*High consumers
		sum `var' if RRPM_Tertile==3
		matrix avgmeat[`r'+15,1]=r(N) 

		svy, subpop(RRPM_Tertile_3): mean `var'
		estat sd
		matrix avgmeat[`r'+15,2]=r(mean) 
		matrix avgmeat[`r'+15,3]=r(sd) 
	
		local r=`r'+1
}	

*Export to Excel 
	putexcel set "$output\SHeS Red and red processed meat.xlsx", sheet("Meal occasions %") modify
	putexcel B2=matrix(avgmeat)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD" 


/*======================================================
Export grams by day of week by consumer tertile to excel
========================================================*/

matrix avgmeat = J(35, 3, .) 	
local r=2

quietly foreach var of varlist Avg_Mon_RRPM Avg_Tues_RRPM Avg_Wed_RRPM Avg_Thurs_RRPM Avg_Fri_RRPM Avg_Sat_RRPM Avg_Sun_RRPM {

		*Overall
		sum `var' if RRPMConsumer==1
		matrix avgmeat[`r',1]=r(N)
		
		svy, subpop(RRPMConsumer): mean `var'
		estat sd
		matrix avgmeat[`r',2]=r(mean) 
		matrix avgmeat[`r',3]=r(sd) 
				
		*Low consumers
		sum `var' if RRPM_Tertile==1
		matrix avgmeat[`r'+8,1]=r(N) 

		svy, subpop(RRPM_Tertile_1): mean `var'
		estat sd
		matrix avgmeat[`r'+8,2]=r(mean) 
		matrix avgmeat[`r'+8,3]=r(sd) 

		*Medium consumers
		sum `var' if RRPM_Tertile==2
		matrix avgmeat[`r'+16,1]=r(N) 

		svy, subpop(RRPM_Tertile_2): mean `var'
		estat sd
		matrix avgmeat[`r'+16,2]=r(mean) 
		matrix avgmeat[`r'+16,3]=r(sd) 

		*High consumers
		sum `var' if RRPM_Tertile==3
		matrix avgmeat[`r'+24,1]=r(N) 

		svy, subpop(RRPM_Tertile_3): mean `var'
		estat sd
		matrix avgmeat[`r'+24,2]=r(mean) 
		matrix avgmeat[`r'+24,3]=r(sd) 
	
		local r=`r'+1
}	

*Export to Excel 
	putexcel set "$output\SHeS Red and red processed meat.xlsx", sheet("Day of the week") modify
	putexcel B2=matrix(avgmeat)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD" 

	
/*=================================================================
Export intake (g) by purchase location by consumer tertile to excel
=================================================================*/

matrix avgmeat = J(20, 3, .) 	
local r=2

quietly foreach var of varlist Avg_Location_Supermarket_RRPM Avg_Location_Restaurants_RRPM Avg_Location_Other_RRPM {

		*Overall
		sum `var' if RRPMConsumer==1
		matrix avgmeat[`r',1]=r(N)
		
		svy, subpop(RRPMConsumer): mean `var'
		estat sd
		matrix avgmeat[`r',2]=r(mean) 
		matrix avgmeat[`r',3]=r(sd) 
				
		*Low consumers
		sum `var' if RRPM_Tertile==1
		matrix avgmeat[`r'+4,1]=r(N) 

		svy, subpop(RRPM_Tertile_1): mean `var'
		estat sd
		matrix avgmeat[`r'+4,2]=r(mean) 
		matrix avgmeat[`r'+4,3]=r(sd) 

		*Medium consumers
		sum `var' if RRPM_Tertile==2
		matrix avgmeat[`r'+8,1]=r(N) 

		svy, subpop(RRPM_Tertile_2): mean `var'
		estat sd
		matrix avgmeat[`r'+8,2]=r(mean) 
		matrix avgmeat[`r'+8,3]=r(sd) 

		*High consumers
		sum `var' if RRPM_Tertile==3
		matrix avgmeat[`r'+12,1]=r(N) 

		svy, subpop(RRPM_Tertile_3): mean `var'
		estat sd
		matrix avgmeat[`r'+12,2]=r(mean) 
		matrix avgmeat[`r'+12,3]=r(sd) 
	
		local r=`r'+1
}	

*Export to Excel 
	putexcel set "$output\SHeS Red and red processed meat.xlsx", sheet("Purchase location g") modify
	putexcel B2=matrix(avgmeat)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD" 

	
/*=====================================================================
Export % contribution by purchase location by consumer tertile to excel
======================================================================*/

matrix avgmeat = J(20, 3, .) 	
local r=2

quietly foreach var of varlist Prop_Location_Supermarket_RRPM Prop_Location_Restaurants_RRPM Prop_Location_Other_RRPM {

		*Overall
		sum `var' if RRPMConsumer==1
		matrix avgmeat[`r',1]=r(N)
		
		svy, subpop(RRPMConsumer): mean `var'
		estat sd
		matrix avgmeat[`r',2]=r(mean) 
		matrix avgmeat[`r',3]=r(sd) 
				
		*Low consumers
		sum `var' if RRPM_Tertile==1
		matrix avgmeat[`r'+4,1]=r(N) 

		svy, subpop(RRPM_Tertile_1): mean `var'
		estat sd
		matrix avgmeat[`r'+4,2]=r(mean) 
		matrix avgmeat[`r'+4,3]=r(sd) 

		*Medium consumers
		sum `var' if RRPM_Tertile==2
		matrix avgmeat[`r'+8,1]=r(N) 

		svy, subpop(RRPM_Tertile_2): mean `var'
		estat sd
		matrix avgmeat[`r'+8,2]=r(mean) 
		matrix avgmeat[`r'+8,3]=r(sd) 

		*High consumers
		sum `var' if RRPM_Tertile==3
		matrix avgmeat[`r'+12,1]=r(N) 

		svy, subpop(RRPM_Tertile_3): mean `var'
		estat sd
		matrix avgmeat[`r'+12,2]=r(mean) 
		matrix avgmeat[`r'+12,3]=r(sd) 
	
		local r=`r'+1
}	

*Export to Excel 
	putexcel set "$output\SHeS Red and red processed meat.xlsx", sheet("Purchase location %") modify
	putexcel B2=matrix(avgmeat)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD" 

	
/*======================================================================
Export food category contributions (grams) by consumer quintile to excel
========================================================================*/
	
	matrix foodcat = J(73, 3, .)
	local r=2

quietly foreach var of varlist Avg_rrpmg_FC1- Avg_rrpmg_FC17 {
			
		*overall		
		sum `var' if RRPMConsumer==1
		matrix foodcat[`r',1]=r(N)
		
		svy, subpop(RRPMConsumer): mean `var'
		estat sd
		matrix foodcat[`r',2]=r(mean)
		matrix foodcat[`r',3]=r(sd)

		*Low consumers
		sum `var' if RRPM_Tertile==1
		matrix foodcat[`r'+18,1]=r(N) 

		svy, subpop(RRPM_Tertile_1): mean `var'
		estat sd
		matrix foodcat[`r'+18,2]=r(mean) 
		matrix foodcat[`r'+18,3]=r(sd) 

		*Medium consumers
		sum `var' if RRPM_Tertile==2
		matrix foodcat[`r'+36,1]=r(N) 

		svy, subpop(RRPM_Tertile_2): mean `var'
		estat sd
		matrix foodcat[`r'+36,2]=r(mean) 
		matrix foodcat[`r'+36,3]=r(sd) 

		*High consumers
		sum `var' if RRPM_Tertile==3
		matrix foodcat[`r'+54,1]=r(N) 

		svy, subpop(RRPM_Tertile_3): mean `var'
		estat sd
		matrix foodcat[`r'+54,2]=r(mean) 
		matrix foodcat[`r'+54,3]=r(sd) 

		
		local r=`r'+1
}	
	
*Export to Excel 
	putexcel set "$output\SHeS Red and red processed meat.xlsx", sheet("Food category g") modify
	putexcel B2=matrix(foodcat)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel E1="SD" 


/*================================================================
Export food category % contributions by consumer quintile to excel
==================================================================*/
	
	matrix foodcat = J(73, 3, .)
	local r=2

quietly foreach var of varlist Prop_Avg_rrpmg_FC1- Prop_Avg_rrpmg_FC17 {
			
		*overall		
		sum `var' if RRPMConsumer==1
		matrix foodcat[`r',1]=r(N)
		
		svy, subpop(RRPMConsumer): mean `var'
		estat sd
		matrix foodcat[`r',2]=r(mean)
		matrix foodcat[`r',3]=r(sd)

		*Low consumers
		sum `var' if RRPM_Tertile==1
		matrix foodcat[`r'+18,1]=r(N) 

		svy, subpop(RRPM_Tertile_1): mean `var'
		estat sd
		matrix foodcat[`r'+18,2]=r(mean) 
		matrix foodcat[`r'+18,3]=r(sd) 

		*Medium consumers
		sum `var' if RRPM_Tertile==2
		matrix foodcat[`r'+36,1]=r(N) 

		svy, subpop(RRPM_Tertile_2): mean `var'
		estat sd
		matrix foodcat[`r'+36,2]=r(mean) 
		matrix foodcat[`r'+36,3]=r(sd) 

		*High consumers
		sum `var' if RRPM_Tertile==3
		matrix foodcat[`r'+54,1]=r(N) 

		svy, subpop(RRPM_Tertile_3): mean `var'
		estat sd
		matrix foodcat[`r'+54,2]=r(mean) 
		matrix foodcat[`r'+54,3]=r(sd) 

		
		local r=`r'+1
}	
	
*Export to Excel 
	putexcel set "$output\SHeS Red and red processed meat.xlsx", sheet("Food category % contributions") modify
	putexcel B2=matrix(foodcat)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel E1="SD" 


/*========================================================================
Export main food group contributions (grams) by consumer quintile to excel
=========================================================================*/
	
	matrix maingroup = J(245, 4, .)
	local r=2

quietly foreach var of varlist Avg_rrpmg_1- Avg_rrpmg_62 {
			
		*overall		
		sum `var' if RRPMConsumer==1
		matrix maingroup[`r',1]=r(N)
		
		svy, subpop(RRPMConsumer): mean `var'
		estat sd
		matrix maingroup[`r',2]=r(mean)
		matrix maingroup[`r',3]=r(sd)

		*Low consumers
		sum `var' if RRPM_Tertile==1
		matrix maingroup[`r'+61,1]=r(N) 

		svy, subpop(RRPM_Tertile_1): mean `var'
		estat sd
		matrix maingroup[`r'+61,2]=r(mean) 
		matrix maingroup[`r'+61,3]=r(sd) 

		*Medium consumers
		sum `var' if RRPM_Tertile==2
		matrix maingroup[`r'+122,1]=r(N) 

		svy, subpop(RRPM_Tertile_2): mean `var'
		estat sd
		matrix maingroup[`r'+122,2]=r(mean) 
		matrix maingroup[`r'+122,3]=r(sd) 
		
		*High consumers
		sum `var' if RRPM_Tertile==3
		matrix maingroup[`r'+183,1]=r(N) 

		svy, subpop(RRPM_Tertile_3): mean `var'
		estat sd
		matrix maingroup[`r'+183,2]=r(mean) 
		matrix maingroup[`r'+183,3]=r(sd) 
	
		local r=`r'+1
}	
	

*Export to Excel 
	putexcel set "$output\SHeS Red and red processed meat.xlsx", sheet("Main food group g") modify
	putexcel B2=matrix(maingroup)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel E1="SD" 


/*===================================================================
Export main food group % contributions by consumer quintile to excel
====================================================================*/
	
	matrix maingroup = J(245, 4, .)
	local r=2

quietly foreach var of varlist Prop_Avg_rrpmg_1- Prop_Avg_rrpmg_62 {
			
		*overall		
		sum `var' if RRPMConsumer==1
		matrix maingroup[`r',1]=r(N)
		
		svy, subpop(RRPMConsumer): mean `var'
		estat sd
		matrix maingroup[`r',2]=r(mean)
		matrix maingroup[`r',3]=r(sd)

		*Low consumers
		sum `var' if RRPM_Tertile==1
		matrix maingroup[`r'+61,1]=r(N) 

		svy, subpop(RRPM_Tertile_1): mean `var'
		estat sd
		matrix maingroup[`r'+61,2]=r(mean) 
		matrix maingroup[`r'+61,3]=r(sd) 

		*Medium consumers
		sum `var' if RRPM_Tertile==2
		matrix maingroup[`r'+122,1]=r(N) 

		svy, subpop(RRPM_Tertile_2): mean `var'
		estat sd
		matrix maingroup[`r'+122,2]=r(mean) 
		matrix maingroup[`r'+122,3]=r(sd) 
		
		*High consumers
		sum `var' if RRPM_Tertile==3
		matrix maingroup[`r'+183,1]=r(N) 

		svy, subpop(RRPM_Tertile_3): mean `var'
		estat sd
		matrix maingroup[`r'+183,2]=r(mean) 
		matrix maingroup[`r'+183,3]=r(sd) 
	
		local r=`r'+1
}	
	

*Export to Excel 
	putexcel set "$output\SHeS Red and red processed meat.xlsx", sheet("Main food group % contributions") modify
	putexcel B2=matrix(maingroup)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel E1="SD" 

/*=======================================================================
Export sub food group contributions (grams) by consumer quintile to excel
========================================================================*/
	
	matrix subgroup = J(560, 4, .)
	local r=2

quietly foreach var of varlist Avg_rrpmg_10R- Avg_rrpmg_9H {
			
		*overall		
		sum `var' if RRPMConsumer==1
		matrix subgroup[`r',1]=r(N)
		
		svy, subpop(RRPMConsumer): mean `var'
		estat sd
		matrix subgroup[`r',2]=r(mean)
		matrix subgroup[`r',3]=r(sd)

		*Low consumers
		sum `var' if RRPM_Tertile==1
		matrix subgroup[`r'+139,1]=r(N) 

		svy, subpop(RRPM_Tertile_1): mean `var'
		estat sd
		matrix subgroup[`r'+139,2]=r(mean) 
		matrix subgroup[`r'+139,3]=r(sd) 

		*Medium consumers
		sum `var' if RRPM_Tertile==2
		matrix subgroup[`r'+278,1]=r(N) 

		svy, subpop(RRPM_Tertile_2): mean `var'
		estat sd
		matrix subgroup[`r'+278,2]=r(mean) 
		matrix subgroup[`r'+278,3]=r(sd) 
		
		*High consumers
		sum `var' if RRPM_Tertile==3
		matrix subgroup[`r'+417,1]=r(N) 

		svy, subpop(RRPM_Tertile_3): mean `var'
		estat sd
		matrix subgroup[`r'+417,2]=r(mean) 
		matrix subgroup[`r'+417,3]=r(sd) 
	
		local r=`r'+1
}	
	

*Export to Excel 
	putexcel set "$output\SHeS Red and red processed meat.xlsx", sheet("Sub food group g") modify
	putexcel B2=matrix(subgroup)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD" 

	
/*================================================================
Export sub food group % contributions by consumer quintile to excel
=================================================================*/
	
	matrix subgroup = J(560, 4, .)
	local r=2

quietly foreach var of varlist Prop_Avg_rrpmg_10R- Prop_Avg_rrpmg_9H {
			
		*overall		
		sum `var' if RRPMConsumer==1
		matrix subgroup[`r',1]=r(N)
		
		svy, subpop(RRPMConsumer): mean `var'
		estat sd
		matrix subgroup[`r',2]=r(mean)
		matrix subgroup[`r',3]=r(sd)

		*Low consumers
		sum `var' if RRPM_Tertile==1
		matrix subgroup[`r'+139,1]=r(N) 

		svy, subpop(RRPM_Tertile_1): mean `var'
		estat sd
		matrix subgroup[`r'+139,2]=r(mean) 
		matrix subgroup[`r'+139,3]=r(sd) 

		*Medium consumers
		sum `var' if RRPM_Tertile==2
		matrix subgroup[`r'+278,1]=r(N) 

		svy, subpop(RRPM_Tertile_2): mean `var'
		estat sd
		matrix subgroup[`r'+278,2]=r(mean) 
		matrix subgroup[`r'+278,3]=r(sd) 
		
		*High consumers
		sum `var' if RRPM_Tertile==3
		matrix subgroup[`r'+417,1]=r(N) 

		svy, subpop(RRPM_Tertile_3): mean `var'
		estat sd
		matrix subgroup[`r'+417,2]=r(mean) 
		matrix subgroup[`r'+417,3]=r(sd) 
	
		local r=`r'+1
}	
	

*Export to Excel 
	putexcel set "$output\SHeS Red and red processed meat.xlsx", sheet("Sub food group % contributions") modify
	putexcel B2=matrix(subgroup)
	putexcel B1="N" 
	putexcel C1="Mean"
	putexcel D1="SD" 


********************************************************************************************
*Explore most frequently consumed red and processed meat food items across consumer tertiles*
*********************************************************************************************

*Read in food level data
use "$data\SHeS 2021_foodlevel_rrpm_manuscript_$date.dta", clear
*Assign survey weights
svyset [pweight=SHeS_Intake24_wt_sc], psu(psu) strata(Strata)

*Create new binary variable for rrpm product
	gen rrpm_item=0
	replace rrpm_item=1 if rrpmg>0 & rrpmg!=.

*Create binary variables for consumer tertile subpops
	*Add non-consumers into consumer tertiles
	replace RRPM_Tertile=0 if RRPM_Tertile==. & intake24==1
	
	*Low consumers
	gen rrpm_lowconsumer=.
	replace rrpm_lowconsumer=1 if RRPM_Tertile==1 & rrpm_item==1
	replace rrpm_lowconsumer=0 if (RRPM_Tertile==0 | RRPM_Tertile==2 | RRPM_Tertile==3) & rrpm_item==1
	
	*Medium consumers
	gen rrpm_mediumconsumer=.
	replace rrpm_mediumconsumer=1 if RRPM_Tertile==2 & rrpm_item==1
	replace rrpm_mediumconsumer=0 if (RRPM_Tertile==0 | RRPM_Tertile==1 | RRPM_Tertile==3) & rrpm_item==1
	
	*High consumers
	gen rrpm_highconsumer=.
	replace rrpm_highconsumer=1 if RRPM_Tertile==3 & rrpm_item==1
	replace rrpm_highconsumer=0 if (RRPM_Tertile==0 | RRPM_Tertile==1 | RRPM_Tertile==2) & rrpm_item==1


*Unweighted n
ta FoodDescription if rrpm_item==1 & RRPM_Tertile==1
ta FoodDescription if rrpm_item==1 & RRPM_Tertile==2
ta FoodDescription if rrpm_item==1 & RRPM_Tertile==3

*Weighted % 
svy, subpop(rrpm_lowconsumer): ta FoodDescription 
svy, subpop(rrpm_mediumconsumer): ta FoodDescription
svy, subpop(rrpm_highconsumer): ta FoodDescription	


