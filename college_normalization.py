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
        #'UNITID':'unit_id',
        'NUMBRANCH':'Number of Branches',
        'CURROPER':'Currently Operating'
     })

    Universities.to_csv('Universities.csv', index=False, na_rep=r'\N')

def make_Demographics(all_data_elements):
    print("\tMaking 'Demographics' table")

    Demographics = all_data_elements[['UNITID','UGDS','UG','PAR_ED_PCT_1STGEN','AGE_ENTRY',
                                      'AGEGE24','FEMALE','MD_FAMINC','MEDIAN_HH_INC']]

    Demographics = Demographics.rename(columns={
        'UGDS':'Undergraduate Degree-seeking Enrollment',
        'UG':'Total Undergraduate Enrollment',
        'PAR_ED_PCT_1STGEN':'Percentage First Generation',
        'AGE_ENTRY':'Avg Age of Entry',
        'AGEGE24':'Percent over 23 at Entry',
        'FEMALE':'Share of Female Students',
        'MD_FAMINC': 'Median Family Income',
        'MEDIAN_HH_INC': 'Median Household Income'

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
    tests = all_data_elements[['UNITID', 'ACTCMMID','SAT_AVG']]
    tests.to_csv('TestData.csv', index=False, na_rep=r'\N')

def make_Costs(all_data_elements):
    print("\tMaking 'Costs' table")

    #typically if COSTT4_A is null, COSTT4_P has something
    Costs = all_data_elements[['UNITID','COSTT4_A','COSTT4_P','TUITIONFEE_IN','TUITIONFEE_OUT',
                               'TUITFTE','INEXPFTE','AVGFACSAL']]

    Costs = Costs.rename(columns={
        'COSTT4_A':'Avg Cost of Attendance',
        'COSTT4_P':'Avg Cost of Attendance (Program-Year)',
        'TUITIONFEE_IN':'In-state Tuition & Fees',
        'TUITIONFEE_OUT': 'Out-of-state Tuition & Fees',
        'TUITFTE':'Tuition Revenue per Full-time Student',
        'INEXPFTE':'Expenditures per Full-time Student',
        'AVGFACSAL':'Avg Faculty Salary'

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
        'COUNT_NWNE_P6':'Number Not Working 6 Years After',
        'COUNT_WNE_P6':'Number Working 6 Years After',
        'MN_EARN_WNE_P6':'Mean Earnings 6 Years After',
        'MD_EARN_WNE_P6':'Median Earnings 6 Years After',
        'PCT25_EARN_WNE_P6':'25th Percentile Earnings 6 Years After',
        'PCT75_EARN_WNE_P6':'75th Percentile Earnings 6 Years After',
        'SD_EARN_WNE_P6':'Standard Deviation Earnings 6 Years After',
        'COUNT_NWNE_P10':'Number Not Working 10 Years After',
        'COUNT_WNE_P10':'Number Working 10 Years After',
        'MN_EARN_WNE_P10':'Mean Earnings 10 Years After',
        'MD_EARN_WNE_P10':'Median Earnings 10 Years After',
        'PCT25_EARN_WNE_P10':'25th Percentile Earnings 10 Years After',
        'PCT75_EARN_WNE_P10':'75th Percentile Earnings 10 Years After',
        'SD_EARN_WNE_P10':'Standard Deviation Earnings 10 Years After'
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

    Broad_CIP = pd.DataFrame({'CIP 2-Digit':cip, 'Broad Subject Area':subject_area})

    Broad_CIP.to_csv('Broad_CIP_Areas.csv', index=False)

def make_Degrees_Offered(field_of_study):
    print("\tMaking 'Degrees Offered' table")
    #includes earning info

    #we'll need to add Degree ID & Broad CIP Area in SQL
    Degrees_Offered = field_of_study[['UNITID','CIPCODE','CREDLEV',
                                      'EARN_COUNT_NWNE_HI_2YR','EARN_COUNT_WNE_HI_2YR','EARN_MDN_HI_2YR']]
                            #we use info for 2 yrs after completion of highest credential b/c more long-term

    Degrees_Offered = Degrees_Offered.rename(columns={
        'EARN_COUNT_NWNE_HI_2YR':'Number Not Working 2 Years After',
        'EARN_COUNT_WNE_HI_2YR':'Number Working 2 Years After',
        'EARN_MDN_HI_2YR':'Median Earnings 2 Years After'
    })

    Degrees_Offered.to_csv('Degrees_Offered.csv', index=False, na_rep=r'\N')

def make_Specific_CIP_Codes(field_of_study):
    print("\tMaking 'Specific CIP Codes' table")

    #we'll need to only have unique columns in SQL
    Specific_CIP = field_of_study[['CIPCODE', 'CIPDESC']]

    Specific_CIP.to_csv('Specific_CIP_Codes.csv', index=False, na_rep=r'\N')

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

# print('Reading cip.txt')
# make_Broad_CIP('cip.txt')

print('Reading Most-Recent-Cohorts-Field-of-Study.csv')
field_of_study = pd.read_csv(os.path.join(data_path, 'Most-Recent-Cohorts-Field-of-Study.csv'),
                             na_values='\\N',low_memory=False)
make_Degrees_Offered(field_of_study)
make_Specific_CIP_Codes(field_of_study)

