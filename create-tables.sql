DROP DATABASE IF EXISTS College;

CREATE DATABASE College;

USE COLLEGE;

CREATE TABLE Universities (
  unit_id 			  INTEGER NOT NULL, -- not null bc PK
  INSTNM 	TEXT, 
  CITY 	VARCHAR(200), 
  STABBR VARCHAR(50),
  INSTURL 			  VARCHAR(200),
  Number_of_Branches			TINYINT, -- add better domain here (>1800)
  CONTROL 			  TINYINT, -- add better domain here (>0)
  ADM_RATE	FLOAT, -- add better domain here (>0)
  currently_operating  TINYINT

);
CREATE TABLE Test_Scores (
UNITID				Integer NOT NULL,
ACTCMMID			float,
SAT_AVG				float


);
CREATE TABLE Demographics(
unit_id 				Integer NOT NULL,
ug_degree_seeking_enrollment Integer,
total_undergraduate_enrollment Integer,
percentage_first_generation	 	float,
avg_age_of_entry				Integer,
percent_over_23_at_entry		float,
share_of_female_students 		float,
median_family_income			integer,
median_household_income			integer
);
CREATE TABLE Program_Percentages(
	unit_id 				Integer NOT NULL,
	pcip_1						float,
    pcip_3						float,
    pcip_4						float,
    pcip_5						float,
    pcip_9						float,
    pcip_10						float, 
	pcip_11						float,
	pcip_12						float,
    pcip_13						float,
    pcip_14						float,
	pcip_15						float,
	pcip_16						float,
    pcip_19						float,
	pcip_22						float,
    pcip_23						float,
    pcip_24						float,
	pcip_25						float,
	pcip_26						float,
	pcip_27						float,
    pcip_29						float,
	pcip_30						float,
	pcip_31						float,
	pcip_38						float,
	pcip_39						float,
	pcip_40						float,
	pcip_41						float,
	pcip_42						float,
	pcip_43						float,
	pcip_44						float,
	pcip_45						float,
	pcip_46						float,
	pcip_47						float,
	pcip_48						float,
	pcip_49						float,
	pcip_50						float,
	pcip_51						float,
    pcip_52						float,
	pcip_54						float
);
CREATE TABLE Costs(
		unit_id 									Integer NOT NULL,
		avg_cost_of_attendance						integer,
        avg_cost_of_attendance_Program_Year			integer,
        in_state_tuition_and_fees					integer,
        out_of_state_tuition_and_Fees				integer,
        tuition_revenue_per_full_time_student		integer	,
		expenditures_per_full_time_student			integer,
        avg_faculty_salary							integer


);
CREATE TABLE Earnings(
		unit_id 				Integer NOT NULL,
        number_not_working_6_years_after integer,
        number_working_6_years_after 		integer,
        mean_earnings_6_years_after 		integer,	
		median_earnings_6_years_after		integer,
        25th_percentile_earnings_6_years_after  integer,
        75th_percentile_earnings_6_years_after	integer,
        standard_deviation_earnings_6_years_after	integer,
        number_not_working_10_years_after			integer,
        number_working_10_years_after			integer,	
		mean_earnings_10_years_after			integer,
        median_earnings_10_years_after			integer,
       25th_percentile_earnings_10_years_after	integer,
      75th_percentile_earnings_10_years_after	integer,
	   standard_deviation_earnings_10_years_after	integer


);
CREATE TABLE Degrees_Earned(
			unit_id 				Integer NOT NULL,
			cipcode								Integer,
            credlev								TINYINT,
            number_not_working_2_years_after 	Integer,
			number_working_2_years_after		Integer,	
			median_earnings_2_years_after 		Integer

);
CREATE TABLE Make_Specific_CIP_Code(
	cipcode								Integer,
	cipdesc								VARCHAR(200)
)
