
********************************************************************************
*Manuscript: "Red and red processed meat (RRPM) consumption behaviours in Scottish adults"

*Do file for labelling variables
*******************************************************************************

*Consumer variables
label variable RRPMConsumer "RRPM consumer (1=yes, 0=no)"
label variable RRPMConsumerDay1 "RRPM consumer on day 1 recall (1=yes, 0=no)"
label variable RRPMConsumerDay2 "RRPM consumer on day 2 recall (1=yes, 0=no)"
label variable RRPMConsumer_Days "Number of days consumed rrpm, 1 or 2"


*Variables for subpops
label variable intake24 "Has Intake24 diet data"
label variable TwoRecalls "Has two recalls"

*Categorical variables for analyses
label variable age_cat "Age category code"
label variable age_catdesc "Age category description"

**Daily average intakes (g/day)
label variable Avg_Day_RRPM "Mean daily intake (g) of total rrpm"
label variable Avg_Day_Beef "Mean daily intake (g) of beef"
label variable Avg_Day_Lamb "Mean daily intake (g) of lamb"
label variable Avg_Day_Pork "Mean daily intake (g) of pork"
label variable Avg_Day_RedGame "Mean daily intake (g) of red game"

***MEAN DAILY INTAKES - High level food category***
label variable Avg_rrpmg_FC1 "Mean daily intake (g) of rrpm from food cat 1 - cereals and cereal products"
label variable Avg_rrpmg_FC2 "Mean daily intake (g) of rrpm from food cat 2 - milk and milk products"
label variable Avg_rrpmg_FC3 "Mean daily intake (g) of rrpm from food cat 3 - eggs and egg dishes"
label variable Avg_rrpmg_FC4 "Mean daily intake (g) of rrpm from food cat 4 - fat spreads"
label variable Avg_rrpmg_FC5 "Mean daily intake (g) of rrpm from food cat 5 - meat and meat products"
label variable Avg_rrpmg_FC6 "Mean daily intake (g) of rrpm from food cat 6 - fish and fish dishes"
label variable Avg_rrpmg_FC7 "Mean daily intake (g) of rrpm from food cat 7 - sandwiches"
label variable Avg_rrpmg_FC8 "Mean daily intake (g) of rrpm from food cat 8 - vegetables, potatoes"
label variable Avg_rrpmg_FC9 "Mean daily intake (g) of rrpm from food cat 9 - fruit"
label variable Avg_rrpmg_FC10 "Mean daily intake (g) of rrpm from food cat 10 - sugars, preserves and confectionery"
label variable Avg_rrpmg_FC11 "Mean daily intake (g) of rrpm from food cat 11 - savoury snacks"
label variable Avg_rrpmg_FC12 "Mean daily intake (g) of rrpm from food cat 12 - nuts and seeds"
label variable Avg_rrpmg_FC13 "Mean daily intake (g) of rrpm from food cat 13 - non-alcoholic beverages"
label variable Avg_rrpmg_FC14 "Mean daily intake (g) of rrpm from food cat 14 - alcoholic beverages"
label variable Avg_rrpmg_FC15 "Mean daily intake (g) of rrpm from food cat 15 - misc"
label variable Avg_rrpmg_FC16 "Mean daily intake (g) of rrpm from food cat 16 - toddler foods"
label variable Avg_rrpmg_FC17 "Mean daily intake (g) of rrpm from food cat 17 - artificial sweeteners"

***MEAN DAILY INTAKES - main food group***
label variable Avg_rrpmg_1 "Mean daily intake (g) of rrpm from main food grp 1 - pasta, rice and other cereals"
label variable Avg_rrpmg_2 "Mean daily intake (g) of rrpm from main food grp 2 - white bread"
label variable Avg_rrpmg_3 "Mean daily intake (g) of rrpm from main food grp 3 - wholemeal bread"
label variable Avg_rrpmg_4 "Mean daily intake (g) of rrpm from main food grp 4 - other bread"
label variable Avg_rrpmg_5 "Mean daily intake (g) of rrpm from main food grp 5 - high fibre breakfast cereals"
label variable Avg_rrpmg_6 "Mean daily intake (g) of rrpm from main food grp 6 - other breakfast cereals"
label variable Avg_rrpmg_7 "Mean daily intake (g) of rrpm from main food grp 7 - biscuits"
label variable Avg_rrpmg_8 "Mean daily intake (g) of rrpm from main food grp 8 - buns cakes pastries & fruit pies"
label variable Avg_rrpmg_9 "Mean daily intake (g) of rrpm from main food grp 9 - puddings"
label variable Avg_rrpmg_10 "Mean daily intake (g) of rrpm from main food grp 10 - whole milk"
label variable Avg_rrpmg_11 "Mean daily intake (g) of rrpm from main food grp 11 - semi skimmed milk"
label variable Avg_rrpmg_12 "Mean daily intake (g) of rrpm from main food grp 12 - skimmed milk"
label variable Avg_rrpmg_13 "Mean daily intake (g) of rrpm from main food grp 13 - other milk and cream"
label variable Avg_rrpmg_14 "Mean daily intake (g) of rrpm from main food grp 14 - cheese"
label variable Avg_rrpmg_15 "Mean daily intake (g) of rrpm from main food grp 15 - yogurt fromage frais and dairy desserts"
label variable Avg_rrpmg_16 "Mean daily intake (g) of rrpm from main food grp 16 - eggs and egg dishes"
label variable Avg_rrpmg_17 "Mean daily intake (g) of rrpm from main food grp 17 - butter"
label variable Avg_rrpmg_18 "Mean daily intake (g) of rrpm from main food grp 18 - pufa margarine & oils"
label variable Avg_rrpmg_19 "Mean daily intake (g) of rrpm from main food grp 19 - low fat spread"
label variable Avg_rrpmg_20 "Mean daily intake (g) of rrpm from main food grp 20 - other margarine fats and oils"
label variable Avg_rrpmg_21 "Mean daily intake (g) of rrpm from main food grp 21 - reduced fat spread"
label variable Avg_rrpmg_22 "Mean daily intake (g) of rrpm from main food grp 22 - bacon and ham"
label variable Avg_rrpmg_23 "Mean daily intake (g) of rrpm from main food grp 23 - beef veal and dishes"
label variable Avg_rrpmg_24 "Mean daily intake (g) of rrpm from main food grp 24 - lamb and dishes"
label variable Avg_rrpmg_25 "Mean daily intake (g) of rrpm from main food grp 25 - pork and dishes"
label variable Avg_rrpmg_26 "Mean daily intake (g) of rrpm from main food grp 26 - coated chicken"
label variable Avg_rrpmg_27 "Mean daily intake (g) of rrpm from main food grp 27 - chicken and turkey dishes"
label variable Avg_rrpmg_28 "Mean daily intake (g) of rrpm from main food grp 28 - liver & dishes"
label variable Avg_rrpmg_29 "Mean daily intake (g) of rrpm from main food grp 29 - burgers and kebabs"
label variable Avg_rrpmg_30 "Mean daily intake (g) of rrpm from main food grp 30 - sausages"
label variable Avg_rrpmg_31 "Mean daily intake (g) of rrpm from main food grp 31 - meat pies and pastries"
label variable Avg_rrpmg_32 "Mean daily intake (g) of rrpm from main food grp 32 - other meat and meat products"
label variable Avg_rrpmg_33 "Mean daily intake (g) of rrpm from main food grp 33 - white fish coated or fried"
label variable Avg_rrpmg_34 "Mean daily intake (g) of rrpm from main food grp 34 - other white fish shellfish & fish dishes"
label variable Avg_rrpmg_35 "Mean daily intake (g) of rrpm from main food grp 35 - oily fish"
label variable Avg_rrpmg_36 "Mean daily intake (g) of rrpm from main food grp 36 - salad and other raw vegetables"
label variable Avg_rrpmg_37 "Mean daily intake (g) of rrpm from main food grp 37 - vegetables not raw"
label variable Avg_rrpmg_38 "Mean daily intake (g) of rrpm from main food grp 38 - chips fried & roast potatoes and potato products"
label variable Avg_rrpmg_39 "Mean daily intake (g) of rrpm from main food grp 39 - other potatoes potato salads & dishes"
label variable Avg_rrpmg_40 "Mean daily intake (g) of rrpm from main food grp 40 - fruit"
label variable Avg_rrpmg_41 "Mean daily intake (g) of rrpm from main food grp 41 - sugars preserves and sweet spreads"
label variable Avg_rrpmg_42 "Mean daily intake (g) of rrpm from main food grp 42 - crisps and savoury snacks"
label variable Avg_rrpmg_43 "Mean daily intake (g) of rrpm from main food grp 43 - sugar confectionery"
label variable Avg_rrpmg_44 "Mean daily intake (g) of rrpm from main food grp 44 - chocolate confectionery"
label variable Avg_rrpmg_45 "Mean daily intake (g) of rrpm from main food grp 45 - fruit juice"
label variable Avg_rrpmg_47 "Mean daily intake (g) of rrpm from main food grp 47 - spirits and liqueurs"
label variable Avg_rrpmg_48 "Mean daily intake (g) of rrpm from main food grp 48 - wine"
label variable Avg_rrpmg_49 "Mean daily intake (g) of rrpm from main food grp 49 - beer lager cider & perry"
label variable Avg_rrpmg_50 "Mean daily intake (g) of rrpm from main food grp 50 - miscellaneous"
label variable Avg_rrpmg_51 "Mean daily intake (g) of rrpm from main food grp 51 - tea, coffee, and water"
label variable Avg_rrpmg_52 "Mean daily intake (g) of rrpm from main food grp 52 - commercial toddlers foods and drinks"
label variable Avg_rrpmg_53 "Mean daily intake (g) of rrpm from main food grp 53 - ice cream"
label variable Avg_rrpmg_55 "Mean daily intake (g) of rrpm from main food grp 55 - artificial sweeteners"
label variable Avg_rrpmg_56 "Mean daily intake (g) of rrpm from main food grp 56 - nuts and seeds"
label variable Avg_rrpmg_57 "Mean daily intake (g) of rrpm from main food grp 57 - soft drinks not low calorie"
label variable Avg_rrpmg_58 "Mean daily intake (g) of rrpm from main food grp 58 - soft drinks low calorie"
label variable Avg_rrpmg_59 "Mean daily intake (g) of rrpm from main food grp 59 - brown granary and wheatgerm bread"
label variable Avg_rrpmg_60 "Mean daily intake (g) of rrpm from main food grp 60 - 1% fat milk"
label variable Avg_rrpmg_61 "Mean daily intake (g) of rrpm from main food grp 61 - smoothies 100% fruit and/or juice"
label variable Avg_rrpmg_62 "Mean daily intake (g) of rrpm from main food grp 62 - sandwiches"

*Sub food group
ds Avg_rrpmg_10R - Avg_rrpmg_9H
local subfoodgroup `r(varlist)'

foreach var of varlist `subfoodgroup'{
local code=substr("`var'", strpos("`var'","Avg_rrpmg_")+10,.)
	 label variable `var' "Mean daily intake (g) of rrpm from sub food grp `code'" 
}

***% CONTRIBUTIONS - high level food category***
label variable Prop_Avg_rrpmg_FC1 "% cont to rrpm from food cat 1 - cereals and cereal products"
label variable Prop_Avg_rrpmg_FC2 "% cont to rrpm from food cat 2 - milk and milk products"
label variable Prop_Avg_rrpmg_FC3 "% cont to rrpm from food cat 3 - eggs and egg dishes"
label variable Prop_Avg_rrpmg_FC4 "% cont to rrpm from food cat 4 - fat spreads"
label variable Prop_Avg_rrpmg_FC5 "% cont to rrpm from food cat 5 - meat and meat products"
label variable Prop_Avg_rrpmg_FC6 "% cont to rrpm from food cat 6 - fish and fish dishes"
label variable Prop_Avg_rrpmg_FC7 "% cont to rrpm from food cat 7 - sandwiches"
label variable Prop_Avg_rrpmg_FC8 "% cont to rrpm from food cat 8 - vegetables, potatoes"
label variable Prop_Avg_rrpmg_FC9 "% cont to rrpm from food cat 9 - fruit"
label variable Prop_Avg_rrpmg_FC10 "% cont to rrpm from food cat 10 - sugars, preserves and confectionery"
label variable Prop_Avg_rrpmg_FC11 "% cont to rrpm from food cat 11 - savoury snacks"
label variable Prop_Avg_rrpmg_FC12 "% cont to rrpm from food cat 12 - nuts and seeds"
label variable Prop_Avg_rrpmg_FC13 "% cont to rrpm from food cat 13 - non-alcoholic beverages"
label variable Prop_Avg_rrpmg_FC14 "% cont to rrpm from food cat 14 - alcoholic beverages"
label variable Prop_Avg_rrpmg_FC15 "% cont to rrpm from food cat 15 - misc"
label variable Prop_Avg_rrpmg_FC16 "% cont to rrpm from food cat 16 - toddler foods"
label variable Prop_Avg_rrpmg_FC17 "% cont to rrpm from food cat 17 - artificial sweeteners"

***% CONTRIBUTIONS - main food group
label variable Prop_Avg_rrpmg_1 "% cont to rrpm from main food grp 1 - pasta, rice and other cereals"
label variable Prop_Avg_rrpmg_2 "% cont to rrpm from main food grp 2 - white bread"
label variable Prop_Avg_rrpmg_3 "% cont to rrpm from main food grp 3 - wholemeal bread"
label variable Prop_Avg_rrpmg_4 "% cont to rrpm from main food grp 4 - other bread"
label variable Prop_Avg_rrpmg_5 "% cont to rrpm from main food grp 5 - high fibre breakfast cereals"
label variable Prop_Avg_rrpmg_6 "% cont to rrpm from main food grp 6 - other breakfast cereals"
label variable Prop_Avg_rrpmg_7 "% cont to rrpm from main food grp 7 - biscuits"
label variable Prop_Avg_rrpmg_8 "% cont to rrpm from main food grp 8 - buns cakes pastries & fruit pies"
label variable Prop_Avg_rrpmg_9 "% cont to rrpm from main food grp 9 - puddings"
label variable Prop_Avg_rrpmg_10 "% cont to rrpm from main food grp 10 - whole milk"
label variable Prop_Avg_rrpmg_11 "% cont to rrpm from main food grp 11 - semi skimmed milk"
label variable Prop_Avg_rrpmg_12 "% cont to rrpm from main food grp 12 - skimmed milk"
label variable Prop_Avg_rrpmg_13 "% cont to rrpm from main food grp 13 - other milk and cream"
label variable Prop_Avg_rrpmg_14 "% cont to rrpm from main food grp 14 - cheese"
label variable Prop_Avg_rrpmg_15 "% cont to rrpm from main food grp 15 - yogurt fromage frais and dairy desserts"
label variable Prop_Avg_rrpmg_16 "% cont to rrpm from main food grp 16 - eggs and egg dishes"
label variable Prop_Avg_rrpmg_17 "% cont to rrpm from main food grp 17 - butter"
label variable Prop_Avg_rrpmg_18 "% cont to rrpm from main food grp 18 - pufa margarine & oils"
label variable Prop_Avg_rrpmg_19 "% cont to rrpm from main food grp 19 - low fat spread"
label variable Prop_Avg_rrpmg_20 "% cont to rrpm from main food grp 20 - other margarine fats and oils"
label variable Prop_Avg_rrpmg_21 "% cont to rrpm from main food grp 21 - reduced fat spread"
label variable Prop_Avg_rrpmg_22 "% cont to rrpm from main food grp 22 - bacon and ham"
label variable Prop_Avg_rrpmg_23 "% cont to rrpm from main food grp 23 - beef veal and dishes"
label variable Prop_Avg_rrpmg_24 "% cont to rrpm from main food grp 24 - lamb and dishes"
label variable Prop_Avg_rrpmg_25 "% cont to rrpm from main food grp 25 - pork and dishes"
label variable Prop_Avg_rrpmg_26 "% cont to rrpm from main food grp 26 - coated chicken"
label variable Prop_Avg_rrpmg_27 "% cont to rrpm from main food grp 27 - chicken and turkey dishes"
label variable Prop_Avg_rrpmg_28 "% cont to rrpm from main food grp 28 - liver & dishes"
label variable Prop_Avg_rrpmg_29 "% cont to rrpm from main food grp 29 - burgers and kebabs"
label variable Prop_Avg_rrpmg_30 "% cont to rrpm from main food grp 30 - sausages"
label variable Prop_Avg_rrpmg_31 "% cont to rrpm from main food grp 31 - meat pies and pastries"
label variable Prop_Avg_rrpmg_32 "% cont to rrpm from main food grp 32 - other meat and meat products"
label variable Prop_Avg_rrpmg_33 "% cont to rrpm from main food grp 33 - white fish coated or fried"
label variable Prop_Avg_rrpmg_34 "% cont to rrpm from main food grp 34 - other white fish shellfish & fish dishes"
label variable Prop_Avg_rrpmg_35 "% cont to rrpm from main food grp 35 - oily fish"
label variable Prop_Avg_rrpmg_36 "% cont to rrpm from main food grp 36 - salad and other raw vegetables"
label variable Prop_Avg_rrpmg_37 "% cont to rrpm from main food grp 37 - vegetables not raw"
label variable Prop_Avg_rrpmg_38 "% cont to rrpm from main food grp 38 - chips fried & roast potatoes and potato products"
label variable Prop_Avg_rrpmg_39 "% cont to rrpm from main food grp 39 - other potatoes potato salads & dishes"
label variable Prop_Avg_rrpmg_40 "% cont to rrpm from main food grp 40 - fruit"
label variable Prop_Avg_rrpmg_41 "% cont to rrpm from main food grp 41 - sugars preserves and sweet spreads"
label variable Prop_Avg_rrpmg_42 "% cont to rrpm from main food grp 42 - crisps and savoury snacks"
label variable Prop_Avg_rrpmg_43 "% cont to rrpm from main food grp 43 - sugar confectionery"
label variable Prop_Avg_rrpmg_44 "% cont to rrpm from main food grp 44 - chocolate confectionery"
label variable Prop_Avg_rrpmg_45 "% cont to rrpm from main food grp 45 - fruit juice"
label variable Prop_Avg_rrpmg_47 "% cont to rrpm from main food grp 47 - spirits and liqueurs"
label variable Prop_Avg_rrpmg_48 "% cont to rrpm from main food grp 48 - wine"
label variable Prop_Avg_rrpmg_49 "% cont to rrpm from main food grp 49 - beer lager cider & perry"
label variable Prop_Avg_rrpmg_50 "% cont to rrpm from main food grp 50 - miscellaneous"
label variable Prop_Avg_rrpmg_51 "% cont to rrpm from main food grp 51 - tea, coffee, and water"
label variable Prop_Avg_rrpmg_52 "% cont to rrpm from main food grp 52 - commercial toddlers foods and drinks"
label variable Prop_Avg_rrpmg_53 "% cont to rrpm from main food grp 53 - ice cream"
label variable Prop_Avg_rrpmg_55 "% cont to rrpm from main food grp 55 - artificial sweeteners"
label variable Prop_Avg_rrpmg_56 "% cont to rrpm from main food grp 56 - nuts and seeds"
label variable Prop_Avg_rrpmg_57 "% cont to rrpm from main food grp 57 - soft drinks not low calorie"
label variable Prop_Avg_rrpmg_58 "% cont to rrpm from main food grp 58 - soft drinks low calorie"
label variable Prop_Avg_rrpmg_59 "% cont to rrpm from main food grp 59 - brown granary and wheatgerm bread"
label variable Prop_Avg_rrpmg_60 "% cont to rrpm from main food grp 60 - 1% fat milk"
label variable Prop_Avg_rrpmg_61 "% cont to rrpm from main food grp 61 - smoothies 100% fruit and/or juice"
label variable Prop_Avg_rrpmg_62 "% cont to rrpm from main food grp 62 - sandwiches"


*% contributions to sub food group
ds Prop_Avg_rrpmg_10R - Prop_Avg_rrpmg_9H
local subfoodgroup `r(varlist)'

foreach var of varlist `subfoodgroup'{
local code=substr("`var'", strpos("`var'","Prop_Avg_rrpmg_")+15,.)
	 label variable `var' "% cont to rrpm from sub food grp `code'" 
}
	 
***AVERAGE INTAKE AND % CONTRIBUTIONS - meal occasion***
label variable Avg_Bfast_RRPM "Average daily intake (g) of RRPM at breakfast"
label variable Avg_Lunch_RRPM "Average daily intake (g) of RRPM at lunch"
label variable Avg_Dinner_RRPM "Average daily intake (g) of RRPM at dinner"
label variable Avg_Snacks_RRPM "Average daily intake (g) of RRPM from snacks"

label variable Prop_Bfast_RRPM "% contribution of RRPM at breakfast to total daily intake"
label variable Prop_Lunch_RRPM "% contribution of RRPM at lunch to total daily intake"
label variable Prop_Dinner_RRPM "% contribution of RRPM at dinner to total daily intake"
label variable Prop_Snacks_RRPM "% contribution of RRPM at snacks to total daily intake"

***AVERAGE INTAKE - day of the week***
label variable Avg_Mon_RRPM "Avg intake (g) of RRPM on Mondays"
label variable Avg_Tues_RRPM "Avg intake (g) of RRPM on Tuesdays"
label variable Avg_Wed_RRPM "Avg intake (g) of RRPM on Wednesdays"
label variable Avg_Thurs_RRPM "Avg intake (g) of RRPM on Thursdays"
label variable Avg_Fri_RRPM "Avg intake (g) of RRPM on Fridays"
label variable Avg_Sat_RRPM "Avg intake (g) of RRPM on Saturdays"
label variable Avg_Sun_RRPM "Avg intake (g) of RRPM on Sundays"

***AVERAGE INTAKE AND % CONTRIBUTIONS - (estimated) consumption location***
label variable Avg_HomeConsmp_RRPM "Avg daily intake (g) of RRPM purchased from home"
label variable Avg_OOHConsmp_RRPM "Avg daily intake (g) of RRPM purchased from out of home"
label variable Avg_OtherConsmp_RRPM "Avg daily intake (g) of RRPM purchased from other"
label variable Avg_MissingConsmp_RRPM "Avg daily intake (g) of RRPM purchased from missing"

label variable Prop_HomeConsumption_RRPM "% contribution of RRPM consumed from home"
label variable Prop_OOHConsumption_RRPM "% contribution of RRPM consumed out of home"
label variable Prop_OtherConsumption_RRPM "% contribution of RRPM consumed from other"
label variable Prop_MissingConsumption_RRPM "% contribution of RRPM consumed from missing"

***AVERAGE INTAKE AND % CONTRIBUTIONS - purchase location***
label variable Avg_Srce_FoodVan_RRPM "Avg daily intake (g) of RRPM purchased from burger/chip/kebab vans"
label variable Avg_Srce_Deli_RRPM "Avg daily intake (g) of RRPM purchased from cafe/coffee shop/deli"
label variable Avg_Srce_Canteen_RRPM "Avg daily intake (g) of RRPM purchased from canteen at work/school/univ"
label variable Avg_Srce_DK_RRPM "Avg daily intake (g) of RRPM purchased from 'I don't know'"
label variable Avg_Srce_FastFood_RRPM "Avg daily intake (g) of RRPM purchased from fast food/takeaway outlet"
label variable Avg_Srce_LeisureCentre__RRPM "Avg daily intake (g) of RRPM purchased from leisure centre/entertainment venue"
label variable Avg_Srce_Other_RRPM "Avg daily intake (g) of RRPM purchased from other locations"
label variable Avg_Srce_Pub_RRPM "Avg daily intake (g) of RRPM purchased from restaurants or pubs"
label variable Avg_Srce_Supermarket_OTG_RRPM "Avg daily intake (g) of RRPM purchased from supermarkets food on the go"
label variable Avg_Srce_Supermarket_Shop_RRPM "Avg daily intake (g) of RRPM purchased from supermarkets household shopping"

label variable Prop_Srce_FoodVan_RRPM "% contribution of RRPM purchased from burger/chip/kebab vans"
label variable Prop_Srce_Deli_RRPM "% contribution of RRPM purchased from cafe/coffee shop/deli"
label variable Prop_Srce_Canteen_RRPM "% contribution of RRPM purchased from canteen at work/school/univ"
label variable Prop_Srce_DK_RRPM "% contribution of RRPM purchased from 'I don't know'"
label variable Prop_Srce_FastFood_RRPM "% contribution of RRPM purchased from fast food/takeaway outlet"
label variable Prop_Srce_LeisureCentre_RRPM "% contribution of RRPM purchased from leisure centre/entertainment venue"
label variable Prop_Srce_Other_RRPM "% contribution of RRPM purchased from other locations"
label variable Prop_Srce_Pub_RRPM "% contribution of RRPM purchased from restaurants or pubs"
label variable Prop_Srce_Supermarket_OTG_RRPM "% contribution of RRPM purchased from supermarkets food on the go"
label variable Prop_Srce_Supermarket_Shop_RRPM "% contribution of RRPM purchased from supermarkets household shopping"



*Additional variables
label variable FoodCategoryCode "Food Category Code (NDNS definitions)"
label variable FoodCategoryDesc "Food Category Description (NDNS definitions)"

label variable MealOccasion "Meal occasion based on self-report"
label variable RRPM_ConsumptionLocation "Purchase location collapsed into home, OOH and other"

label variable RRPM_Tertile "Tertiles of red and red processed meat consumers"
label variable RRPM_Meal "RRPM meal (1) or not (0)"
