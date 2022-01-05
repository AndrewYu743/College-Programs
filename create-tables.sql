DROP DATABASE IF EXISTS College;

CREATE DATABASE College;

USE College;

CREATE TABLE Universities (
  unit_id 			  INTEGER NOT NULL, 
  inst_name 	TEXT, 
  city 	VARCHAR(200), 
  state VARCHAR(50),
  url 			  VARCHAR(200),
  num_branches			TINYINT, 
  control 			  TINYINT, 
  adm_rate	FLOAT, 
  currently_operating  TINYINT,
  PRIMARY KEY (unit_id)

);

CREATE TABLE Test_Scores (
	unit_id				Integer NOT NULL,
	act_midpoint			float,
	sat_avg				float,
    PRIMARY KEY (unit_id)

);

CREATE TABLE Demographics(
	unit_id 				Integer NOT NULL,
	ug_degree_seeking_enrollment Integer,
	total_ug_enrollment Integer,
	percent_first_generation	 	float,
	avg_age_of_entry				Integer,
	percent_over_23_at_entry		float,
	percent_female 		float,
	median_family_income			integer,
	median_household_income			integer,
    PRIMARY KEY (unit_id)
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
	pcip_54						float,
    PRIMARY KEY (unit_id)
);

CREATE TABLE Costs(
		unit_id 									Integer NOT NULL,
		avg_cost_of_attendance						integer,
        avg_cost_of_attendance_program_year			integer,
        in_state_tuition_and_fees					integer,
        out_of_state_tuition_and_fees				integer,
        tuition_revenue_per_full_time_student		integer	,
		expenditures_per_full_time_student			integer,
        avg_faculty_salary							integer,
        PRIMARY KEY (unit_id)

);

CREATE TABLE Earnings(
		unit_id 				Integer NOT NULL,
        number_not_working_6_years_after integer,
        number_working_6_years_after 		integer,
        mean_earnings_6_years_after 		integer,	
		median_earnings_6_years_after		integer,
        percentile_25_earnings_6_years_after  integer,
        percentile_75_earnings_6_years_after	integer,
        standard_deviation_earnings_6_years_after	integer,
        number_not_working_10_years_after			integer,
        number_working_10_years_after			integer,	
		mean_earnings_10_years_after			integer,
        median_earnings_10_years_after			integer,
        percentile_25_earnings_10_years_after	integer,
       percentile_75_earnings_10_years_after	integer,
	   standard_deviation_earnings_10_years_after	integer,
		PRIMARY KEY (unit_id)

);

CREATE TABLE Specific_CIP_Codes(
	cipcode								Integer,
	cipdesc								VARCHAR(200),
	PRIMARY KEY (cipcode)
);

CREATE TABLE Broad_CIP_Areas(
	cip_2_digit	TINYINT,
	broad_subject_area VARCHAR(200),
	PRIMARY KEY (cip_2_digit)
);

CREATE TABLE Degrees_Offered(
			degree_id int unsigned not null auto_increment,
            unit_id								Integer,
			cipcode								Integer,
            credlev								TINYINT,
            number_not_working_2_years_after 	Integer,
			number_working_2_years_after		Integer,	
			median_earnings_2_years_after 		Integer,
            PRIMARY KEY (degree_id),
            FOREIGN KEY (unit_id) REFERENCES Universities(unit_id),
            FOREIGN KEY (cipcode) REFERENCES Specific_CIP_Codes(cipcode)

);


