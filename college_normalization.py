# Imports
# -------
import numpy as np
import pandas as pd
import os
import gzip
import shutil






#William's section
#===============================================================================
# create_csvs.py
# ------------------------------------------------------------------------------
#
# Author: D. L. Whittenbury
# Date created: 14/1/2020
# Date last modified: 6/2/2020
# Version: 1.0
#
#-------------------------------------------------------------------------------
# This script was written for the MySQL_IMDb_Project to preprocess the
# raw IMDb data. The output of this script will then be used as input
# into a MySQL database.
#
# This script does the following:
# - Reads in IMDb data files
# - Cleans and normalises IMDb data
# - Ouputs TSV files for the designed logical schema
#
# Run in terminal:
# $ python imdb_converter.py
#
# Run in python console:
# $ python
# >>> exec(open('imdb_converter.py').read())
#
# Run in ipython console:
# $ ipython
# run imdb_converter.py
#
#===============================================================================



# Helper functions
#------------------

def make_Universities(all_data_elements):
    print("\tMaking 'Universities' table")


    Universities = all_data_elements[['UNITID', 'INSTNM', 'CITY', 'STABBR', 'INSTURL',
                                      'NUMBRANCH', 'CONTROL', 'ADM_RATE','CURROPER']]

    Universities = Universities.rename(columns={
        'UNITID':'unit_id',
        'INSTNM':'inst_name',
        'CITY':'city',
        'STABBR':'state',
        'INSTURL':'url',
        'CONTROL':'control',
        'ADM_RATE':'adm_rate',
        'NUMBRANCH':'num_branches',
        'CURROPER':'currently_operating'
     })

    #commas in the url mess it up, so we'll use a tsv
    Universities.to_csv('Universities.tsv', index=False, sep='\t', na_rep=r'\N')

def make_Demographics(all_data_elements):
    print("\tMaking 'Demographics' table")

    Demographics = all_data_elements[['UNITID','UGDS','UG','PAR_ED_PCT_1STGEN','AGE_ENTRY',
                                      'AGEGE24','FEMALE','MD_FAMINC','MEDIAN_HH_INC']]

    Demographics = Demographics.rename(columns={
        'UNITID':'unit_id',
        'UGDS':'ug_degree_seeking_enrollment',
        'UG':'total_ug_enrollment',
        'PAR_ED_PCT_1STGEN':'percent_first_generation',
        'AGE_ENTRY':'avg_age_of_entry',
        'AGEGE24':'percent_over_23_at_entry',
        'FEMALE':'percent_female',
        'MD_FAMINC': 'median_family_income',
        'MEDIAN_HH_INC': 'median_household_income'

    })

    Demographics.to_csv('Demographics.csv', index=False, na_rep=r'\N')

def make_Program_Percentages(all_data_elements):
    print("\tMaking 'Program Percentages' table")

    #there's several CIP subjects skipped
    skipped = [2, 6, 7, 8, 17, 18, 20, 21, 28, 32, 33, 34, 35, 36, 37, 53]
    columns = ['UNITID']
    for i in range(1, 55):
        if (i not in skipped):
            columns.append('PCIP{:02d}'.format(i))

    Program_Percentages = all_data_elements[columns]

    Program_Percentages.to_csv('Program_Percentages.csv', index=False, na_rep=r'\N')


def make_Test_Scores(all_data_elements):
    print("\tMaking 'Test scores' table")
    Tests = all_data_elements[['UNITID', 'ACTCMMID','SAT_AVG']]

    Tests = Tests.rename(columns={
        'UNITID':'unit_id',
        'ACTCMMID':'act_midpoint',
        'SAT_AVG':'sat_avg'
    })
    Tests.to_csv('Test_Scores.csv', index=False, na_rep=r'\N')

def make_Costs(all_data_elements):
    print("\tMaking 'Costs' table")

    #typically if COSTT4_A is null, COSTT4_P has something
    Costs = all_data_elements[['UNITID','COSTT4_A','COSTT4_P','TUITIONFEE_IN','TUITIONFEE_OUT',
                               'TUITFTE','INEXPFTE','AVGFACSAL']]

    Costs = Costs.rename(columns={
        'UNITID':'unit_id',
        'COSTT4_A':'avg_cost_of_attendance',
        'COSTT4_P':'avg_cost_of_attendance_program_year',
        'TUITIONFEE_IN':'in_state_tuition_and_fees',
        'TUITIONFEE_OUT': 'out_of_state_tuition_and_fees',
        'TUITFTE':'tuition_revenue_per_full_time_student',
        'INEXPFTE':'expenditures_per_full_time_student',
        'AVGFACSAL':'avg_faculty_salary'

    })
    Costs.to_csv('Costs.csv', index=False, na_rep=r'\N')

def make_Earnings(all_data_elements):
    print("\tMaking 'Earnings' table")

    Earnings = all_data_elements[['UNITID','COUNT_NWNE_P6','COUNT_WNE_P6','MN_EARN_WNE_P6','MD_EARN_WNE_P6',
                                  'PCT25_EARN_WNE_P6','PCT75_EARN_WNE_P6','SD_EARN_WNE_P6',
                                  'COUNT_NWNE_P10', 'COUNT_WNE_P10', 'MN_EARN_WNE_P10', 'MD_EARN_WNE_P10',
                                  'PCT25_EARN_WNE_P10', 'PCT75_EARN_WNE_P10', 'SD_EARN_WNE_P10'
                                  ]]

    Earnings = Earnings.rename(columns={
        'UNITID':'unit_id',
        'COUNT_NWNE_P6':'number_not_working_6_years_after',
        'COUNT_WNE_P6':'number_working_6_years_after',
        'MN_EARN_WNE_P6':'mean_earnings_6_years_after',
        'MD_EARN_WNE_P6':'median_earnings_6_years_after',
        'PCT25_EARN_WNE_P6':'percentile_25_earnings_6_years_after',
        'PCT75_EARN_WNE_P6':'percentile_75_earnings_6_years_after',
        'SD_EARN_WNE_P6':'standard_deviation_earnings_6_years_after',
        'COUNT_NWNE_P10':'number_not_working_10_years_after',
        'COUNT_WNE_P10':'number_working_10_years_after',
        'MN_EARN_WNE_P10':'mean_earnings_10_years_after',
        'MD_EARN_WNE_P10':'median_earnings_10_years_after',
        'PCT25_EARN_WNE_P10':'percentile_25_earnings_10_years_after',
        'PCT75_EARN_WNE_P10':'percentile_75_earnings_10_years_after',
        'SD_EARN_WNE_P10':'standard_deviation_earnings_10_years_after'
    })
    Earnings.to_csv('Earnings.csv', index=False, na_rep=r'\N')

#copied directly from https://nces.ed.gov/ipeds/cipcode/browse.aspx?y=56
def make_Broad_CIP(txt_file):
    print("Making 'Broad CIP' table")

    cip, subject_area = [], []

    with open(txt_file) as f:
        for line in f:
            parsed = line.split(') ')
            cip.append(int(parsed[0].split('n')[1]))
            subject_area.append(parsed[1])

    Broad_CIP = pd.DataFrame({'cip_2_digit':cip, 'broad_subject_area':subject_area})

    #tsv b/c commas in subject names
    Broad_CIP.to_csv('Broad_CIP_Areas.tsv', sep='\t', index=False)

def make_Degrees_Offered(field_of_study):
    print("\tMaking 'Degrees Offered' table")
    #includes earning info

    #we'll need to add Degree ID & Broad CIP Area in SQL
    Degrees_Offered = field_of_study[['UNITID','CIPCODE','CREDLEV',
                                      'EARN_COUNT_NWNE_HI_2YR','EARN_COUNT_WNE_HI_2YR','EARN_MDN_HI_2YR']]
                            #we use info for 2 yrs after completion of highest credential b/c more long-term

    Degrees_Offered = Degrees_Offered.rename(columns={
        'UNITID':'unit_id',
        'EARN_COUNT_NWNE_HI_2YR':'number_not_working_2_years_after',
        'EARN_COUNT_WNE_HI_2YR':'number_working_2_years_after',
        'EARN_MDN_HI_2YR':'median_earnings_2_years_after'
    })

    Degrees_Offered.to_csv('Degrees_Offered.csv', index=False, na_rep=r'\N')

def make_Specific_CIP_Codes(field_of_study):
    print("\tMaking 'Specific CIP Codes' table")

    #we'll need to only have unique columns in SQL
    Specific_CIP = field_of_study[['CIPCODE', 'CIPDESC']]

    #tsv b/c commas in subject names
    Specific_CIP.to_csv('Specific_CIP_Codes.tsv', sep='\t', index=False, na_rep=r'\N')

#------------------------ END OF FUNCTION DEFINITIONS --------------------------



# Set path to downloaded csv files
# ---------------------
data_path = './'

print('Looking for college data in: ',data_path,'\n')


# Unzip IMDb data files
#----------------------
#data_files = unzip_files(data_path)


# Read in and process all college data files
# ---------------------------------------

# all-data-elements.csv
print('Reading Most-Recent-Cohorts-All-Data-Elements.csv')
all_data_elements = pd.read_csv(os.path.join(data_path, 'Most-Recent-Cohorts-All-Data-Elements.csv'),
                                na_values='\\N',low_memory=False)
make_Universities(all_data_elements)
make_Demographics(all_data_elements)
make_Program_Percentages(all_data_elements)
make_Test_Scores(all_data_elements)
make_Costs(all_data_elements)
make_Earnings(all_data_elements)



print('Reading cip.txt')
make_Broad_CIP('cip.txt')

print('Reading Most-Recent-Cohorts-Field-of-Study.csv')
field_of_study = pd.read_csv(os.path.join(data_path, 'Most-Recent-Cohorts-Field-of-Study.csv'),
                             na_values='\\N',low_memory=False)
make_Degrees_Offered(field_of_study)
make_Specific_CIP_Codes(field_of_study)

