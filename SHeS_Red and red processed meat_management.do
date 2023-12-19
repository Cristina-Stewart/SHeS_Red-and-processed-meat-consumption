

********************************************************************************
*Manuscript: "Red and red processed meat (RRPM) consumption behaviours in Scottish adults"

*Data management do-file for the manuscript 
*******************************************************************************

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
global code `"$location\Code"'
global date "20231311"

*Demographic data
global dems `"$data\shes21i_eul"'
*Intake24 diet data
global diet `"$data\shes21_intake24_food-level_dietary_data_eul"'

set maxvar 10000

******************
*Merging datasets
******************
use "$diet", clear
sort Cpseriala RecallNo

Rename missing variable names
rename variabl0 Retinol
rename variabl00 TotCarotene
rename variabl01 Alpcarotene
rename variabl02 Betacarotene
rename variabl03 BCryptoxanthin
rename variabl04 VitaminA
rename variabl05 VitaminD
rename variabl06 VitaminB12
rename variabl07 Folate
rename variabl08 Biotin
rename variabl09 Iodine
rename variabl000 Selenium

save "$diet", replace

use "$dems", clear
keep Cpseriala psu Strata InIntake24 SHeS_Intake24_wt_sc simd20_sga Ethnic05 Sex age NumberOfRecalls HBCode 
sort Cpseriala

merge 1:m Cpseriala using "$diet"
	drop _merge
	*dropping nutrients not used
	drop EnergykJ- OtherVegg WhiteFishg- OtherCheeseg


****************************************
*Create subpop variable for analysis
****************************************
*Completed at least 1 recall
gen intake24=0
replace intake24=1 if InIntake24==1

*Completed 2 recalls
gen TwoRecalls=0
replace TwoRecalls=1 if NumberOfRecalls==2
replace TwoRecalls=. if InIntake24==0

****************************************
*Create age group variable for analysis
****************************************
*Age group
gen age_cat=.
replace age_cat=1 if age>=16 & age<=34
replace age_cat=2 if age>=35 & age<=54
replace age_cat=3 if age>=55 & age<=74
replace age_cat=4 if age>=75

gen age_catdesc=""
replace age_catdesc="Aged 16-34 years" if age_cat==1
replace age_catdesc="Aged 35-54 years" if age_cat==2
replace age_catdesc="Aged 55-74 years" if age_cat==3
replace age_catdesc="Aged >=75 years" if age_cat==4


*************************************************************************
*Dropping intake from supplements as interested in intake from food only
*************************************************************************
drop if RecipeMainFoodGroupCode==54 /*n=3,589*/


**********************************************************************************
*Tag each unique recall within the food-level dataset for subsequent calculations
**********************************************************************************
bysort Cpseriala RecallNo: gen n=_n==1
replace n=. if RecallNo==.


/**************************************************************************************
Create meat animal type variables
**************************************************************************************/

/***First, re-categorising items within processed red meat, burgers, sausages and offal

Some assumptions:
1) assumed generic tongue is beef
2) assumed pate black pudding, and "meat" in tomato pasta dishes are pork (e.g. bacon)
*/

*Beef
gen Beef_Process=0
replace Beef_Process=ProcessedRedMeatg if (strpos(FoodDescription, "Pastrami") | strpos(FoodDescription, "Corned beef"))

gen Beef_Burgers=0
replace Beef_Burgers=Burgersg if (strpos(FoodDescription, "Lamb") | strpos(FoodDescription, "Hot dog"))==0

gen Beef_Sausages=0
replace Beef_Sausages=Sausagesg if strpos(FoodDescription, "Beef Sausage")

gen Beef_Offal=0
replace Beef_Offal=Offalg if (strpos(FoodDescription, "Ox") |strpos(FoodDescription, "Calf liver")) 

*Lamb
gen Lamb_Burgers=0
replace Lamb_Burgers=Burgersg if strpos(FoodDescription, "Lamb")

gen Lamb_Offal=0
replace Lamb_Offal=Offalg if (strpos(FoodDescription, "Lambs liver") | strpos(FoodDescription, "Haggis"))

*Pork
gen Pork_Process=0
replace Pork_Process=ProcessedRedMeatg if Beef_Process==0

gen Pork_Burgers=0
replace Pork_Burgers=Burgersg if Beef_Burgers==0 & Lamb_Burgers==0

gen Pork_Sausages=0
replace Pork_Sausages=Sausagesg if Beef_Sausages==0 & (strpos(FoodDescription, "Chicken/turkey sausage") | strpos(FoodDescription, "Venison sausage"))==0

gen Pork_Offal=0
replace Pork_Offal=Offalg if Beef_Offal==0 & Lamb_Offal==0 & (strpos(FoodDescription, "Chicken liver"))==0

*Game
gen Game_Sausages=0
replace Game_Sausages=Sausagesg if strpos(FoodDescription, "Venison sausage")

*Replace values of those without recalls to missing
foreach var of varlist Beef_Process Beef_Burgers Beef_Sausages Beef_Offal Lamb_Burgers Lamb_Offal Pork_Process Pork_Burgers Pork_Sausages Pork_Offal Game_Sausages {
	replace `var' =. if RecallNo==. 
}

*Totals will be calculated in next section


******************************************************
*Explore what proportion of processed meat is poultry*
******************************************************
gen ProcessedMeatCategory=0
replace ProcessedMeatCategory=1 if ProcessedRedMeatg>0 | Burgersg>0 | Sausagesg>0 | ProcessedPoultryg>0
replace ProcessedMeatCategory=. if RecallNo==. 

gen ProcessedPoultry=0
replace ProcessedPoultry=1 if ProcessedMeatCategory==1 & strpos(FoodDescription, "Chicken/turkey sausage") | ProcessedPoultryg>0
replace ProcessedPoultry=. if RecallNo==. 

*Assign survey weights
svyset [pweight=SHeS_Intake24_wt_sc], psu(psu) strata(Strata)

ta FoodDescription if  ProcessedMeatCategory==1 & ProcessedPoultry==1
svy, subpop(intake24): prop ProcessedPoultry if ProcessedMeatCategory==1, percent


/*********************************************************************************************
Create daily summary intakes (g) of RRPM - first need to calculate totals at food item level
*********************************************************************************************/

*Food level
egen totalbeef=rowtotal(Beefg Beef_Process Beef_Burgers Beef_Sausages Beef_Offal)
egen totallamb=rowtotal(Lambg Lamb_Burgers Lamb_Offal)
egen totalpork=rowtotal(Porkg Pork_Process Pork_Burgers Pork_Sausages Pork_Offal)
egen totalredgame=rowtotal(OtherRedMeatg Game_Sausages)
egen rrpmg=rowtotal(totalbeef totallamb totalpork totalredgame)

*Day level
bysort Cpseriala RecallNo: egen Day_Beef=sum(totalbeef)
bysort Cpseriala RecallNo: egen Day_Lamb=sum(totallamb)
bysort Cpseriala RecallNo: egen Day_Pork=sum(totalpork)
bysort Cpseriala RecallNo: egen Day_RedGame=sum(totalredgame)
bysort Cpseriala RecallNo: egen Day_RRPM=sum(rrpmg)

*Day level intake of kcal
bysort Cpseriala RecallNo: egen Day_Kcal=sum(Energykcal)

*Replace values of those without recalls to missing
foreach var of varlist totalbeef totallamb totalpork totalredgame rrpmg Day_Beef Day_Lamb Day_Pork Day_RedGame Day_RRPM Day_Kcal {
	replace `var' =. if RecallNo==. 
}


/************************************
 Calculate mean daily intakes of meat
************************************/

*Set local macro
ds Day_* 
local dayvalues `r(varlist)'

*Loop through each daily value
foreach var of varlist `dayvalues' {
	bysort Cpseriala RecallNo: egen DayMax_`var' =max(`var') /*daily intake*/
    bysort Cpseriala: egen Wk_`var' = total(DayMax_`var') if n==1 /*total intake across all days*/
	bysort Cpseriala: egen WkMax_`var' = max(Wk_`var') /*filling in total intake across all days across all observations*/
	bysort Cpseriala: gen Avg_`var' = (WkMax_`var'/NumberOfRecalls) /*mean daily intake*/
	drop DayMax_`var' Wk_`var' WkMax_`var'
}


/***************************************************
 Create consumer variables for RRPM. Interesed in:
 
 1) Consumer overall (yes/no)
 2) Consumer on day 1 and day 2 separately
 3) The number of days an individual was a consumer
***************************************************/

*1) Consumer overall
gen RRPMConsumer=.
replace RRPMConsumer=1 if Avg_Day_RRPM>0  & Avg_Day_RRPM!=.
replace RRPMConsumer=0 if Avg_Day_RRPM==0

*2) Consumer on day 1 and day 2 separately
gen RRPMConsumer_Day1=.
replace RRPMConsumer_Day1=1 if RecallNo==1 & Day_RRPM>0 & Avg_Day_RRPM!=.
replace RRPMConsumer_Day1=0 if RecallNo==1 & Day_RRPM==0

gen RRPMConsumer_Day2=.
replace RRPMConsumer_Day2=1 if RecallNo==2 & Day_RRPM>0 & Avg_Day_RRPM!=.
replace RRPMConsumer_Day2=0 if RecallNo==2 & Day_RRPM==0

bysort Cpseriala: egen RRPMConsumerDay1 = max(RRPMConsumer_Day1)
bysort Cpseriala: egen RRPMConsumerDay2 = max(RRPMConsumer_Day2)
drop RRPMConsumer_Day1 RRPMConsumer_Day2

*3) The number of days an individual was a consumer
gen RRPMConsumer_Days = RRPMConsumerDay1 + RRPMConsumerDay2 if NumberOfRecalls==2
replace RRPMConsumer_Days = RRPMConsumerDay1 if NumberOfRecalls==1



/***************************************************************************************************
Create high level food categories (that reflect NDNS food categories)
***************************************************************************************************/

***Create 'Food Category Code' and 'Food Category Description' variables

**Food category code
gen FoodCategoryCode=.
replace FoodCategoryCode=1 if RecipeMainFoodGroupCode>=1 & RecipeMainFoodGroupCode<=9 |RecipeMainFoodGroupCode==59 
replace FoodCategoryCode=2 if RecipeMainFoodGroupCode>=10 & RecipeMainFoodGroupCode<=15 | RecipeMainFoodGroupCode==60 | RecipeMainFoodGroupCode==53 
replace FoodCategoryCode=3 if RecipeMainFoodGroupCode==16
replace FoodCategoryCode=4 if RecipeMainFoodGroupCode>=17 & RecipeMainFoodGroupCode<=21
replace FoodCategoryCode=5 if RecipeMainFoodGroupCode>=22 & RecipeMainFoodGroupCode<=32
replace FoodCategoryCode=6 if RecipeMainFoodGroupCode>=33 & RecipeMainFoodGroupCode<=35
replace FoodCategoryCode=7 if RecipeMainFoodGroupCode==62
replace FoodCategoryCode=8 if RecipeMainFoodGroupCode>=36 & RecipeMainFoodGroupCode<=39
replace FoodCategoryCode=9 if RecipeMainFoodGroupCode==40
replace FoodCategoryCode=10 if RecipeMainFoodGroupCode==41 | RecipeMainFoodGroupCode==43 | RecipeMainFoodGroupCode==44
replace FoodCategoryCode=11 if RecipeMainFoodGroupCode==42
replace FoodCategoryCode=12 if RecipeMainFoodGroupCode==56 
replace FoodCategoryCode=13 if RecipeMainFoodGroupCode==45 | RecipeMainFoodGroupCode==61 | RecipeMainFoodGroupCode==57 | RecipeMainFoodGroupCode==58 | RecipeMainFoodGroupCode==51
replace FoodCategoryCode=14 if RecipeMainFoodGroupCode>=47 & RecipeMainFoodGroupCode<=49
replace FoodCategoryCode=15 if RecipeMainFoodGroupCode==50
replace FoodCategoryCode=16 if RecipeMainFoodGroupCode==52
replace FoodCategoryCode=17 if RecipeMainFoodGroupCode==55
replace FoodCategoryCode=. if RecipeMainFoodGroupCode==.

**Food category description
gen FoodCategoryDesc=""
replace FoodCategoryDesc="Cereals and Cereal Products" if FoodCategoryCode==1
replace FoodCategoryDesc="Milk and Milk Products" if FoodCategoryCode==2
replace FoodCategoryDesc="Eggs and Egg Dishes" if FoodCategoryCode==3
replace FoodCategoryDesc="Fat Spreads" if FoodCategoryCode==4
replace FoodCategoryDesc="Meat and Meat Products" if FoodCategoryCode==5
replace FoodCategoryDesc="Fish and Fish Dishes" if FoodCategoryCode==6
replace FoodCategoryDesc="Sandwiches" if FoodCategoryCode==7
replace FoodCategoryDesc="Vegetables, potatoes" if FoodCategoryCode==8
replace FoodCategoryDesc="Fruit" if FoodCategoryCode==9
replace FoodCategoryDesc="Sugar, Preserves and Confectionery" if FoodCategoryCode==10
replace FoodCategoryDesc="Savoury Snacks" if FoodCategoryCode==11
replace FoodCategoryDesc="Nuts and Seeds" if FoodCategoryCode==12
replace FoodCategoryDesc="Non-alcoholic beverages" if FoodCategoryCode==13
replace FoodCategoryDesc="Alcoholic beverages" if FoodCategoryCode==14
replace FoodCategoryDesc="Misc" if FoodCategoryCode==15
replace FoodCategoryDesc="Toddler foods" if FoodCategoryCode==16
replace FoodCategoryDesc="Artificial sweeteners" if FoodCategoryCode==17

order FoodCategoryCode FoodCategoryDesc, before(RecipeMainFoodGroupCode)

/********************************************************
Calculate mean daily intakes of RRPM from FOOD CATEGORIES
********************************************************/
local nutrients "rrpmg" 
levelsof FoodCategoryCode, local(FoodCategoryCode) 

foreach var of varlist `nutrients' {
	foreach 1 of local FoodCategoryCode {
	bysort Cpseriala RecallNo: egen D_`var'_FC`1' = sum(`var') if FoodCategoryCode==`1' /*daily rrpm intake by food group*/
	bysort Cpseriala RecallNo: egen DMax_`var'_FC`1' = max(D_`var'_FC`1') /*filling in daily rrpm intake by food group across all observations*/
	bysort Cpseriala: egen Wk_`var'_FC`1' = total(DMax_`var'_FC`1') if n==1 /*total rrpm intake by food group across all days*/
	bysort Cpseriala: egen WkMax_`var'_FC`1' = max(Wk_`var'_FC`1') /*filling in total rrpm across all days across all observations*/
	bysort Cpseriala: gen Avg_`var'_FC`1'= (WkMax_`var'_FC`1'/NumberOfRecalls) /*mean daily rrpm intake by food group*/
	drop D_* DMax_* Wk_* WkMax*
	}
}	


/***********************************************************
Calculate mean daily intakes of RRPM from MAIN FOOD GROUPS
***********************************************************/
local nutrients "rrpmg"
levelsof RecipeMainFoodGroupCode, local(MainFoodGroup) 

foreach var of varlist `nutrients' {
	foreach 1 of local MainFoodGroup {
	bysort Cpseriala RecallNo: egen D_`var'_`1' = sum(`var') if RecipeMainFoodGroupCode==`1' 
	bysort Cpseriala RecallNo: egen DMax_`var'_`1' = max(D_`var'_`1')
	drop D_*
	bysort Cpseriala: egen Wk_`var'_`1' = total(DMax_`var'_`1') if n==1
	drop DMax_*
	bysort Cpseriala: egen WkMax_`var'_`1' = max(Wk_`var'_`1')
	drop Wk_*
	bysort Cpseriala: gen Avg_`var'_`1'= (WkMax_`var'_`1'/NumberOfRecalls)
	drop WkMax*
	}
}	

/********************************************************
Calculate mean daily intakes of RRPM from SUB FOOD GROUPS
*********************************************************/
local nutrients "rrpmg"
levelsof RecipeSubFoodGroupCode, local(SubFoodGroup)

foreach var of varlist `nutrients' {
	foreach 1 of local SubFoodGroup {
	bysort Cpseriala RecallNo: egen D_`var'_`1' = sum(`var') if RecipeSubFoodGroupCode=="`1'"
	bysort Cpseriala RecallNo: egen DMax_`var'_`1' = max(D_`var'_`1')
	drop D_*
	bysort Cpseriala: egen Wk_`var'_`1' = total(DMax_`var'_`1') if n==1
	drop DMax_*
	bysort Cpseriala: egen WkMax_`var'_`1' = max(Wk_`var'_`1')
	drop Wk_*
	bysort Cpseriala: gen Avg_`var'_`1'= (WkMax_`var'_`1'/NumberOfRecalls)
	drop WkMax*
	}
}


/*****************************************************************************
Create variables for proportion of RRPM coming from food categories and groups
******************************************************************************/
ds Avg_rrpmg_*
local dailyaverage `r(varlist)'
foreach var of varlist `dailyaverage' {
    bysort Cpseriala: gen Prop_`var'=(`var'/Avg_Day_RRPM)*100
}



/**********************************
Explore when RRPM is being consumed
**********************************/

*Explore times pre-set meals were consumed
ta MealTime if MealName=="Early snack or drink" /*between 2am and 10pm*/
ta MealTime if MealName=="Breakfast" /*between 1am and 10:30pm*/
ta MealTime if MealName=="Morning snack or drink" /*between 1:30am and 4:30pm*/
ta MealTime if MealName=="Lunch" /*between 2:30am and 8pm*/
ta MealTime if MealName=="Afternoon snack or drink" /*between 3:30am and 10pm*/
ta MealTime if MealName=="Dinner" /*between 4:30pm and 10:30pm*/
ta MealTime if MealName=="Evening meal" /*between 12am and 11:45pm*/
ta MealTime if MealName=="Late snack or drink" /*between 12am and 11:45pm*/
ta MealTime if MealName=="Other" /*between 12am and 11:45pm*/

*Some re-coding of meal names necessary

	*Count the number of meal names reported at the same meal time 
	bysort Cpseriala RecallNo MealTime MealName: gen mealcheck= _n==1
	bysort Cpseriala RecallNo MealTime: egen mealcheck2= total(mealcheck)
	ta MealName if mealcheck2>1

	*Some participants labelled components of main meals separately - re-code accordingly
		*Evening meal (10 changes made)
		replace MealName="Evening meal" if MealName=="Bread" & mealcheck2>1 
		replace MealName="Evening meal" if MealName=="Pasta" & mealcheck2>1 
		replace MealName="Evening meal" if MealName=="Potatoes" & mealcheck2>1 		
		replace MealName="Evening meal" if MealName=="Chicken" & mealcheck2>1 
		replace MealName="Evening meal" if MealName=="Coconut and spinach chicken curry" & mealcheck2>1 
		replace MealName="Evening meal" if MealName=="Salad" & mealcheck2>1 
		*Lunch (1 change made)
		replace MealName="Lunch" if MealName=="Toasted sandwich" & mealcheck2>1 
		*Late snack or drink (9 changes made)
		replace MealName="Late snack or drink" if MealName=="Peanut butter" & mealcheck2>1 
		replace MealName="Late snack or drink" if MealName=="Late snack" & mealcheck2>1 
		replace MealName="Late snack or drink" if MealName=="Crisps" & mealcheck2>1 
		replace MealName="Late snack or drink" if MealName=="Wine" & mealcheck2>1 
		*Afternoon snack or drink (9 changes made)
		replace MealName="Afternoon snack or drink" if MealName=="Banana" & mealcheck2>1 
		replace MealName="Afternoon snack or drink" if MealName=="cup of tea" & mealcheck2>1 
		replace MealName="Afternoon snack or drink" if MealName=="Lemon tea" & mealcheck2>1 
		replace MealName="Afternoon snack or drink" if MealName=="Tea" & mealcheck2>1 
		replace MealName="Afternoon snack or drink" if MealName=="diet pepsi" & mealcheck2>1 

		drop mealcheck mealcheck2

	*Some participans named entire meal after the items 
	replace MealName="Lunch" if MealName=="Cottage cheese and ham on ryvita" /*Assumed this was lunch*/
	replace MealName="Evening meal" if MealName=="Curry Sauce" /*Assumed this was evening meal*/

	
/*****************************************************************************
Create new meal occasion variable for analyses:

*Collapsing dinner and evening meal together
*Collapsing all "snack or drinks" together given time overlap with consumption
*****************************************************************************/
gen MealOccasion=.
replace MealOccasion=1 if MealName=="Breakfast"
replace MealOccasion=2 if MealName=="Lunch"
replace MealOccasion=3 if MealName=="Dinner" | MealName=="Evening meal" | MealName=="dinner"
replace MealOccasion=4 if MealName=="Early snack or drink" | MealName=="Morning snack or drink" | MealName=="Afternoon snack or drink" | MealName=="Late snack or drink" 

*All remaining meal names are named after snack/drink items (e.g. cake, coffee) 
*A lot of meals are named as supplements - although supplements have been removed, the water consumed when taking the supplements is still captured within the meal name
replace MealOccasion=4 if MealOccasion==. & intake24==1

label define MealOccasion 1 "Breakfast" 2 "Lunch" 3 "Dinner" 4 "Snacks and drinks"
label values MealOccasion MealOccasion


/*****************************
Explore food purchase location
*******************************/
ta FoodSource if rrpmg>0

*Re-categorise some 'other' locations
	*Restaurant or pub *12 changes
	replace FoodSource="Restaurant or pub" if rrpmg>0 & FoodSource=="Other: Hotel" | rrpmg>0 &  FoodSource=="Other: Bed & Breakfast hotel" | rrpmg>0 & FoodSource=="Other: hotel"

	*Fast food/takeaway *3 changes
	replace FoodSource="Fast food / take-away outlet" if rrpmg>0 & FoodSource=="Other: Greggs" | rrpmg>0 &  FoodSource=="Other: McDonalds" | rrpmg>0 & FoodSource=="Other: greggs bakers"

	*Food bank (existing multiple choice option) *4 changes
	replace FoodSource="Other" if rrpmg>0 & FoodSource=="Food bank (charity/community) or government food delivery scheme (food boxes/parcels)"

*Collapse all remaining 'other' locations together
replace FoodSource="Other" if strpos(FoodSource, "Other") & rrpmg>0 


/******************************
Estimating consumption location
*******************************/

*Home consmption 
gen RRPM_ConsumptionLocation=""
replace RRPM_ConsumptionLocation="Home" if FoodSource=="Supermarket / local shop / petrol station - household shopping" & rrpmg>0 & rrpmg!=.

*Out of home consumption
replace RRPM_ConsumptionLocation="OOH" if FoodSource!="Supermarket / local shop / petrol station - household shopping" & FoodSource!="Don't know" & strpos(FoodSource, "Other")==0 & rrpmg>0  & rrpmg!=.

*Unlcear
replace RRPM_ConsumptionLocation="Other" if RRPM_ConsumptionLocation!="Home" & RRPM_ConsumptionLocation!="OOH" & FoodSource!="Don't know" & rrpmg>0  & rrpmg!=.



/*************************************************************
*Calculate mean intake of RRPM within each:
1) Meal occasion
2) Day of the week
3) Purchase location (food source)
4) Estimated consumption location (home vs out of home)

*************************************************************/

*Create new variables for analysis

	*Tag each unique meal occasion, purchase location and consumption location
	bysort Cpseriala RecallNo MealOccasion: gen meal_n=_n==1 if intake24==1
	bysort Cpseriala RecallNo RRPM_ConsumptionLocation: gen location_n=_n==1 if intake24==1
	bysort Cpseriala RecallNo FoodSource: gen foodsource_n=_n==1 if intake24==1

	*Check if any respondent has two recalls on same day of the week
	bysort Cpseriala SubDay: gen day_n=_n==1  if intake24==1/*Unique days of the week*/
	bysort Cpseriala: replace day_n = sum(day_n)  if intake24==1/*Sum number of different days of the week*/
	bysort Cpseriala: replace day_n = day_n[_N]  if intake24==1 /*Filling in all rows with number of different days of the week*/

		ta day_n if NumberOfRecalls==2 /*yes, some completed recalls on same day of week */
		rename day_n NumberOfDiffDays 
		
		bysort Cpseriala RecallNo SubDay: gen wkday_n=_n==1 /*Tag unique days of the week*/

	**Calculate grams of RRPM in each:
	*Meal occasion
	bysort Cpseriala RecallNo MealOccasion: egen Meal_RRPM=sum(rrpmg) if intake24==1
	*Day of the week
	bysort Cpseriala RecallNo SubDay: egen WkDay_RRPM=sum(rrpmg) if intake24==1
	*Estimated consumption location
	bysort Cpseriala RecallNo RRPM_ConsumptionLocation: egen Location_RRPM=sum(rrpmg) if intake24==1
	*Purchase location
	bysort Cpseriala RecallNo FoodSource: egen FoodSource_RRPM=sum(rrpmg) if intake24==1

**Calculate average grams of RRPM per:

	*1) Meal occasion 
		bysort Cpseriala MealOccasion: egen Wk_Meal_RRPM = total(Meal_RRPM) if meal_n==1
		bysort Cpseriala MealOccasion: egen WkMax_Meal_RRPM = max(Wk_Meal_RRPM) 
		bysort Cpseriala MealOccasion: gen Avg_Meal_RRPM = (WkMax_Meal_RRPM/NumberOfRecalls) if intake24==1

	*2) Day of the week
		bysort Cpseriala SubDay: egen Wk_Day_RRPM = total(Day_RRPM) if wkday_n==1
		bysort Cpseriala SubDay: gen Avg_WkDay_RRPM = Wk_Day_RRPM if NumberOfRecalls==2 & NumberOfDiffDays==2 | NumberOfRecalls==1 & NumberOfDiffDays==1
		bysort Cpseriala SubDay: replace Avg_WkDay_RRPM = (Wk_Day_RRPM/NumberOfRecalls) if NumberOfRecalls==2 & NumberOfDiffDays==1
		bysort Cpseriala SubDay: egen Avg_SubDay_RRPM=max(Avg_WkDay_RRPM) if intake24==1
		
	*3) Estimated consumption location
		bysort Cpseriala RRPM_ConsumptionLocation: egen Wk_Location_RRPM = total(Location_RRPM) if location_n==1
		bysort Cpseriala RRPM_ConsumptionLocation: egen WkMax_Location_RRPM = max(Wk_Location_RRPM)
		bysort Cpseriala RRPM_ConsumptionLocation: gen Avg_Location_RRPM = (WkMax_Location_RRPM/NumberOfRecalls) if intake24==1

	*4) Purchase location 
		bysort Cpseriala FoodSource: egen Wk_FoodSource_RRPM = total(FoodSource_RRPM) if foodsource_n==1
		bysort Cpseriala FoodSource: egen WkMax_FoodSource_RRPM = max(Wk_FoodSource_RRPM)
		bysort Cpseriala FoodSource: gen Avg_FoodSource_RRPM = (WkMax_FoodSource_RRPM/NumberOfRecalls) if intake24==1

		*Drop variables no longer needed
		drop wkday_n Wk_Day_RRPM Avg_WkDay_RRPM WkDay_RRPM Wk_Meal_RRPM WkMax_Meal_RRPM Wk_Location_RRPM WkMax_Location_RRPM Wk_FoodSource_RRPM WkMax_FoodSource_RRPM
	


/**********************************************************************
***Pull out avg intakes across meal occasions into individual variables
**********************************************************************/

*Breakfast
bysort Cpseriala: gen Avg_Breakfast_RRPM=.
bysort Cpseriala: replace Avg_Breakfast_RRPM=Avg_Meal_RRPM if MealOccasion==1
bysort Cpseriala: egen Avg_Bfast_RRPM=max(Avg_Breakfast_RRPM)
replace Avg_Bfast_RRPM=0 if Avg_Bfast_RRPM==. & intake24==1
drop Avg_Breakfast_RRPM

*Lunch
bysort Cpseriala: gen Avg_L_RRPM=.
bysort Cpseriala: replace Avg_L_RRPM=Avg_Meal_RRPM if MealOccasion==2
bysort Cpseriala: egen Avg_Lunch_RRPM=max(Avg_L_RRPM)
replace Avg_Lunch_RRPM=0 if Avg_Lunch_RRPM==. & intake24==1
drop Avg_L_RRPM

*Dinner
bysort Cpseriala: gen Avg_D_RRPM=.
bysort Cpseriala: replace Avg_D_RRPM=Avg_Meal_RRPM if MealOccasion==3
bysort Cpseriala: egen Avg_Dinner_RRPM=max(Avg_D_RRPM)
replace Avg_Dinner_RRPM=0 if Avg_Dinner_RRPM==. & intake24==1
drop Avg_D_RRPM

*Snacks
bysort Cpseriala: gen Avg_S_RRPM=.
bysort Cpseriala: replace Avg_S_RRPM=Avg_Meal_RRPM if MealOccasion==4
bysort Cpseriala: egen Avg_Snacks_RRPM=max(Avg_S_RRPM)
replace Avg_Snacks_RRPM=0 if Avg_Snacks_RRPM==. & intake24==1
drop Avg_S_RRPM

/********************************************
Calculate % contributions from meal occasions
*********************************************/
bysort Cpseriala: gen Prop_Bfast_RRPM = (Avg_Bfast_RRPM/Avg_Day_RRPM)*100 if intake24==1
bysort Cpseriala: gen Prop_Lunch_RRPM = (Avg_Lunch_RRPM/Avg_Day_RRPM)*100 if intake24==1
bysort Cpseriala: gen Prop_Dinner_RRPM = (Avg_Dinner_RRPM/Avg_Day_RRPM)*100 if intake24==1
bysort Cpseriala: gen Prop_Snacks_RRPM = (Avg_Snacks_RRPM/Avg_Day_RRPM)*100 if intake24==1

replace Prop_Bfast_RRPM=0 if Prop_Bfast_RRPM==. & RRPMConsumer==1 & intake24==1
replace Prop_Lunch_RRPM=0 if Prop_Lunch_RRPM==. & RRPMConsumer==1 & intake24==1
replace Prop_Dinner_RRPM=0 if Prop_Dinner_RRPM==. & RRPMConsumer==1 & intake24==1
replace Prop_Snacks_RRPM=0 if Prop_Snacks_RRPM==. & RRPMConsumer==1 & intake24==1

/*****************************************************************
***Pull out avg intakes day of the week into individual variables
******************************************************************/
bysort Cpseriala: gen Avg_Monday_RRPM=.
bysort Cpseriala: gen Avg_Tuesday_RRPM=.
bysort Cpseriala: gen Avg_Wednesday_RRPM=.
bysort Cpseriala: gen Avg_Thursday_RRPM=.
bysort Cpseriala: gen Avg_Friday_RRPM=.
bysort Cpseriala: gen Avg_Saturday_RRPM=.
bysort Cpseriala: gen Avg_Sunday_RRPM=.

bysort Cpseriala: replace Avg_Monday_RRPM=Avg_SubDay_RRPM if SubDay==2 & intake24==1
bysort Cpseriala: replace Avg_Tuesday_RRPM=Avg_SubDay_RRPM if SubDay==3 & intake24==1
bysort Cpseriala: replace Avg_Wednesday_RRPM=Avg_SubDay_RRPM if SubDay==4 & intake24==1
bysort Cpseriala: replace Avg_Thursday_RRPM=Avg_SubDay_RRPM if SubDay==5 & intake24==1
bysort Cpseriala: replace Avg_Friday_RRPM=Avg_SubDay_RRPM if SubDay==6 & intake24==1
bysort Cpseriala: replace Avg_Saturday_RRPM=Avg_SubDay_RRPM if SubDay==7 & intake24==1
bysort Cpseriala: replace Avg_Sunday_RRPM=Avg_SubDay_RRPM if SubDay==1 & intake24==1

bysort Cpseriala: egen Avg_Mon_RRPM=max(Avg_Monday_RRPM)
bysort Cpseriala: egen Avg_Tues_RRPM=max(Avg_Tuesday_RRPM)
bysort Cpseriala: egen Avg_Wed_RRPM=max(Avg_Wednesday_RRPM)
bysort Cpseriala: egen Avg_Thurs_RRPM=max(Avg_Thursday_RRPM)
bysort Cpseriala: egen Avg_Fri_RRPM=max(Avg_Friday_RRPM)
bysort Cpseriala: egen Avg_Sat_RRPM=max(Avg_Saturday_RRPM)
bysort Cpseriala: egen Avg_Sun_RRPM=max(Avg_Sunday_RRPM)

drop Avg_Monday_RRPM- Avg_Sunday_RRPM


/***************************************************************************
***Pull out avg intakes across consumption location into individual variables
****************************************************************************/

*Home
bysort Cpseriala: gen Avg_HomeConsumption_RRPM=.
bysort Cpseriala: replace Avg_HomeConsumption_RRPM=Avg_Location_RRPM if RRPM_ConsumptionLocation=="Home"
bysort Cpseriala: egen Avg_HomeConsmp_RRPM=max(Avg_HomeConsumption_RRPM)
replace Avg_HomeConsmp_RRPM=0 if Avg_HomeConsmp_RRPM==. & intake24==1
drop Avg_HomeConsumption_RRPM

*OOH
bysort Cpseriala: gen Avg_OOHConsumption_RRPM=.
bysort Cpseriala: replace Avg_OOHConsumption_RRPM=Avg_Location_RRPM if RRPM_ConsumptionLocation=="OOH"
bysort Cpseriala: egen Avg_OOHConsmp_RRPM=max(Avg_OOHConsumption_RRPM)
replace Avg_OOHConsmp_RRPM=0 if Avg_OOHConsmp_RRPM==. & intake24==1
drop Avg_OOHConsumption_RRPM

*Other
bysort Cpseriala: gen Avg_OtherConsumption_RRPM=.
bysort Cpseriala: replace Avg_OtherConsumption_RRPM=Avg_Location_RRPM if RRPM_ConsumptionLocation=="Other"
bysort Cpseriala: egen Avg_OtherConsmp_RRPM=max(Avg_OtherConsumption_RRPM)
replace Avg_OtherConsmp_RRPM=0 if Avg_OtherConsmp_RRPM==. & intake24==1
drop Avg_OtherConsumption_RRPM

*Missing
bysort Cpseriala: gen Avg_MissingConsumption_RRPM=.
bysort Cpseriala: replace Avg_MissingConsumption_RRPM=Avg_Location_RRPM if RRPM_ConsumptionLocation=="" & rrpmg>0
bysort Cpseriala: egen Avg_MissingConsmp_RRPM=max(Avg_MissingConsumption_RRPM)
replace Avg_MissingConsmp_RRPM=0 if Avg_MissingConsmp_RRPM==. & intake24==1
drop Avg_MissingConsumption_RRPM

*Check total intake from home, OOH and other equals total consumed
gen PurchaseTotal=Avg_HomeConsmp_RRPM + Avg_OOHConsmp_RRPM + Avg_OtherConsmp_RRPM + Avg_MissingConsmp_RRPM 
gen PurchaseCheck=PurchaseTotal-Avg_Day_RRPM
ta PurchaseCheck

drop PurchaseCheck PurchaseTotal

/************************************************
*Calculate % contributions from consumption location
************************************************/ 
bysort Cpseriala: gen Prop_HomeConsumption_RRPM = (Avg_HomeConsmp_RRPM/Avg_Day_RRPM)*100 if intake24==1
bysort Cpseriala: gen Prop_OOHConsumption_RRPM = (Avg_OOHConsmp_RRPM/Avg_Day_RRPM)*100 if intake24==1
bysort Cpseriala: gen Prop_OtherConsumption_RRPM = (Avg_OtherConsmp_RRPM/Avg_Day_RRPM)*100 if intake24==1
bysort Cpseriala: gen Prop_MissingConsumption_RRPM = (Avg_MissingConsmp_RRPM/Avg_Day_RRPM)*100 if intake24==1

replace Prop_HomeConsumption_RRPM=0 if Prop_HomeConsumption_RRPM==. & RRPMConsumer==1
replace Prop_OOHConsumption_RRPM=0 if Prop_OOHConsumption_RRPM==. & RRPMConsumer==1
replace Prop_OtherConsumption_RRPM=0 if Prop_OtherConsumption_RRPM==. & RRPMConsumer==1
replace Prop_MissingConsumption_RRPM=0 if Prop_MissingConsumption_RRPM==. & RRPMConsumer==1


/*********************************************************************
Pull out avg intakes across each food source into individual variables
**********************************************************************/
ta FoodSource if rrpmg>0

bysort Cpseriala: gen Avg_Src_FoodVan_RRPM=.
bysort Cpseriala: gen Avg_Src_Deli_RRPM=.
bysort Cpseriala: gen Avg_Src_Canteen_RRPM=.
bysort Cpseriala: gen Avg_Src_DK_RRPM=.
bysort Cpseriala: gen Avg_Src_FastFood_RRPM=.
bysort Cpseriala: gen Avg_Src_LeisureCentre__RRPM=.
bysort Cpseriala: gen Avg_Src_Other_RRPM=.
bysort Cpseriala: gen Avg_Src_Pub_RRPM=.
bysort Cpseriala: gen Avg_Src_Supermarket_OTG_RRPM=.
bysort Cpseriala: gen Avg_Src_Supermarket_Shop_RRPM=.

bysort Cpseriala: replace Avg_Src_FoodVan_RRPM=Avg_FoodSource_RRPM if FoodSource=="Burger, chip or kebab van / 'street food'"
bysort Cpseriala: replace Avg_Src_Deli_RRPM=Avg_FoodSource_RRPM if strpos(FoodSource, "coffee shop / sandwich bar / deli")
bysort Cpseriala: replace Avg_Src_Canteen_RRPM=Avg_FoodSource_RRPM if FoodSource=="Canteen at work or school / university / college"
bysort Cpseriala: replace Avg_Src_DK_RRPM=Avg_FoodSource_RRPM if FoodSource=="Don't know"
bysort Cpseriala: replace Avg_Src_FastFood_RRPM=Avg_FoodSource_RRPM if FoodSource=="Fast food / take-away outlet"
bysort Cpseriala: replace Avg_Src_LeisureCentre__RRPM=Avg_FoodSource_RRPM if FoodSource=="Leisure centre / recreation or entertainment venue"
bysort Cpseriala: replace Avg_Src_Other_RRPM=Avg_FoodSource_RRPM if FoodSource=="Other"
bysort Cpseriala: replace Avg_Src_Pub_RRPM=Avg_FoodSource_RRPM if FoodSource=="Restaurant or pub"
bysort Cpseriala: replace Avg_Src_Supermarket_OTG_RRPM=Avg_FoodSource_RRPM if FoodSource=="Supermarket / local shop / petrol station - food on the go"
bysort Cpseriala: replace Avg_Src_Supermarket_Shop_RRPM=Avg_FoodSource_RRPM if FoodSource=="Supermarket / local shop / petrol station - household shopping"

bysort Cpseriala: egen Avg_Srce_FoodVan_RRPM=max(Avg_Src_FoodVan_RRPM)
bysort Cpseriala: egen Avg_Srce_Deli_RRPM=max(Avg_Src_Deli_RRPM)
bysort Cpseriala: egen Avg_Srce_Canteen_RRPM=max(Avg_Src_Canteen_RRPM)
bysort Cpseriala: egen Avg_Srce_DK_RRPM=max(Avg_Src_DK_RRPM)
bysort Cpseriala: egen Avg_Srce_FastFood_RRPM=max(Avg_Src_FastFood_RRPM)
bysort Cpseriala: egen Avg_Srce_LeisureCentre__RRPM=max(Avg_Src_LeisureCentre__RRPM)
bysort Cpseriala: egen Avg_Srce_Other_RRPM=max(Avg_Src_Other_RRPM)
bysort Cpseriala: egen Avg_Srce_Pub_RRPM=max(Avg_Src_Pub_RRPM)
bysort Cpseriala: egen Avg_Srce_Supermarket_OTG_RRPM=max(Avg_Src_Supermarket_OTG_RRPM)
bysort Cpseriala: egen Avg_Srce_Supermarket_Shop_RRPM=max(Avg_Src_Supermarket_Shop_RRPM)

drop Avg_Src_FoodVan_RRPM- Avg_Src_Supermarket_Shop_RRPM

replace Avg_Srce_FoodVan_RRPM=0 if Avg_Srce_FoodVan_RRPM==. & RRPMConsumer==1
replace Avg_Srce_Deli_RRPM=0 if Avg_Srce_Deli_RRPM==. & RRPMConsumer==1
replace Avg_Srce_Canteen_RRPM=0 if Avg_Srce_Canteen_RRPM==. & RRPMConsumer==1
replace Avg_Srce_DK_RRPM=0 if Avg_Srce_DK_RRPM==. & RRPMConsumer==1
replace Avg_Srce_FastFood_RRPM=0 if Avg_Srce_FastFood_RRPM==. & RRPMConsumer==1
replace Avg_Srce_LeisureCentre__RRPM=0 if Avg_Srce_LeisureCentre__RRPM==. & RRPMConsumer==1
replace Avg_Srce_Other_RRPM=0 if Avg_Srce_Other_RRPM==. & RRPMConsumer==1
replace Avg_Srce_Pub_RRPM=0 if Avg_Srce_Pub_RRPM==. & RRPMConsumer==1
replace Avg_Srce_Supermarket_OTG_RRPM=0 if Avg_Srce_Supermarket_OTG_RRPM==. & RRPMConsumer==1
replace Avg_Srce_Supermarket_Shop_RRPM=0 if Avg_Srce_Supermarket_Shop_RRPM==. & RRPMConsumer==1


/*****************************************
Calculate % contributions from food source
******************************************/
bysort Cpseriala: gen Prop_Srce_FoodVan_RRPM = (Avg_Srce_FoodVan_RRPM/Avg_Day_RRPM)*100 if intake24==1
bysort Cpseriala: gen Prop_Srce_Deli_RRPM = (Avg_Srce_Deli_RRPM/Avg_Day_RRPM)*100 if intake24==1
bysort Cpseriala: gen Prop_Srce_Canteen_RRPM = (Avg_Srce_Canteen_RRPM/Avg_Day_RRPM)*100 if intake24==1
bysort Cpseriala: gen Prop_Srce_DK_RRPM = (Avg_Srce_DK_RRPM/Avg_Day_RRPM)*100 if intake24==1
bysort Cpseriala: gen Prop_Srce_FastFood_RRPM = (Avg_Srce_FastFood_RRPM/Avg_Day_RRPM)*100 if intake24==1
bysort Cpseriala: gen Prop_Srce_LeisureCentre_RRPM = (Avg_Srce_LeisureCentre__RRPM/Avg_Day_RRPM)*100 if intake24==1
bysort Cpseriala: gen Prop_Srce_Other_RRPM = (Avg_Srce_Other_RRPM/Avg_Day_RRPM)*100 if intake24==1
bysort Cpseriala: gen Prop_Srce_Pub_RRPM = (Avg_Srce_Pub_RRPM/Avg_Day_RRPM)*100 if intake24==1
bysort Cpseriala: gen Prop_Srce_Supermarket_OTG_RRPM = (Avg_Srce_Supermarket_OTG_RRPM/Avg_Day_RRPM)*100 if intake24==1
bysort Cpseriala: gen Prop_Srce_Supermarket_Shop_RRPM = (Avg_Srce_Supermarket_Shop_RRPM/Avg_Day_RRPM)*100 if intake24==1


/********************************************************************
 Create categorical variables to distinguish between consumer levels
********************************************************************/
	gen Cpseriala_formatted = string(Cpseriala, "%12.0f")

	*Split consumers into quintiles
	xtile RRPM_Tertile = Avg_Day_RRPM if RRPMConsumer==1 & intake24==1, nq(3)

	*Manually tweak upper cut of from 72g to 70g for high consumers
	replace RRPM_Tertile=3 if Avg_Day_RRPM>70 & intake24==1
	
/*****************************************************************
 Create binary variable for whether a meal occasion contains RRPM
****************************************************************/
bysort Cpseriala RecallNo MealOccasion: gen RRPM_Meal=.
replace RRPM_Meal=0 if Meal_RRPM==0 & intake24==1
replace RRPM_Meal=1 if Meal_RRPM>0 & intake24==1


****Drop variables no longer needed
drop Day_* n Beef_Process-totalredgame meal_n location_n foodsource_n Meal_RRPM Location_RRPM FoodSource_RRPM Avg_Meal_RRPM Avg_SubDay_RRPM Avg_Location_RRPM Avg_FoodSource_RRPM NumberOfDiffDays



*****************
*Label variables
*****************
do "$code\SHeS 2021_Red and red processed meat_labels.do"


*Save food level dataset
save "$data\SHeS 2021_foodlevel_rrpm_manuscript_$date.dta", replace

*Participant level dataset
	*Drop duplicate respondents so each respondent has one line
	duplicates drop Cpseriala, force
	*Drop food level variables not needed
	drop SubDay-TotalGrams

save "$data\SHeS 2021_participantlevel_rrpm_manuscript$date.dta", replace
