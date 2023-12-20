# SHeS_Red-and-red-processed-meat-consumption
Analysis of red and red processed meat (RRPM) consumption behaviours among adults 16+ years in the 2021 Scottish Health Survey.

## Data Management Files

### SHeS_Red and red processed meat_management.do
This Stata do-file creates a food-level and participant-level dataset. It combines demographic survey data with dietary data collected through Intake24. At the participant level, mean daily intakes (g) of red and red processed meat (RRPM), both total, each animal type, and processed vs unprocessed, are calculated, as well as average RRPM intakes from the following situational contexts:

1) Meal occasion (breakfast, lunch, dinner, and snacks)
2) Day of the week
3) Purchase location (supermarkets vs cafes, restaurants & takeaways, vs other)

Mean daily intakes of RRPM (g) from, and per cent contributions of, all food categories and food groups to total RRPM intake are provided. Further, mean daily per cent contributions from meal occasion, day of the week and purchase location to total RRPM intake are provided.

Files needed to run this do-file:
#### Data files
Two data files are needed to run this do-file, and can be downloaded from the UK Data Archive.
- shes21_intake24_food-level_dietary_data_eul - Intake 24 diet data. There are multiple observations per participant, each observation corresponds to a food item reported.
- shes21i_eul - participant demographic survey data. There is only one observation per participant.

#### Do files
SHeS 2021_Red and red processed meat_labels - labels all the variables in the data management do-file.

### Output
- SHeS 2021_foodlevel_rrpm_manuscript_20231912.dta - this dataset has multiple observations for each participant, corresponding to each food item reported
- SHeS 2021_participantlevel_rrpm_manuscript20231912.dta - this dataset has one observation for each participant

## Data Analysis Files
### SHeS_Red and red processed meat analysis_Manuscript.do
This do-file contains all analyses of RRPM dietary data used in the manuscript "Red and red processed meat consumption behaviours in Scottish adults". This do-file also contains code which exports the following data into Excel tables, overall and among RRPM consumers tertiles (low, medium, and high consumers): 

1) Mean daily intake of RRPM (total, processed and unprocessed) (g)
2) Mean daily intake of RRPM from meal occasions (g)
3) Mean per cent contribution of meal occasions to RRPM intake
4) Mean daily intake of RRPM by day of the week (g)
5) Mean daily intake of RRPM by purchase locations (g)
6) Mean per cent contribution of purchase locations to RRPM intake
7) Mean daily intake of RRPM from food food groups (g)
8) Mean per cent contributions of RRPM from food groups
