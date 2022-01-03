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



def make_Test_Scores(test_data):
    print("\tMaking 'Test scores' table")
    tests = test_data[['UNITID', 'ACTCMMID','SAT_AVG']]
    tests.to_csv('TestData.csv', index=False, na_rep=r'\N')
#------------------------ END OF FUNCTION DEFINITIONS --------------------------



# Set path to IMDb data
# ---------------------
data_path = './'

print('Looking for college data in: ',data_path,'\n')


# Unzip IMDb data files
#----------------------
#data_files = unzip_files(data_path)


# Read in and process all IMDb data files
# ---------------------------------------

# all-data-elements.csv
print('Reading Most-Recent-Cohorts-All-Data-Elements.csv')
all_data_elements = pd.read_csv(os.path.join(data_path, 'Most-Recent-Cohorts-All-Data-Elements.csv'),
                                na_values='\\N',low_memory=False)
make_Universities(all_data_elements)
make_Demographics(all_data_elements)
make_Program_Percentages(all_data_elements)
make_Test_Scores(all_data_elements)



