# Imports
# -------
import numpy as np
import pandas as pd
import os
import gzip
import shutil








#Andrews section








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
                                      'NUMBRANCH', 'CONTROL', 'ADM_RATE']]

    # Universities = Universities.rename(columns={
    #    'UNITID':'unit_id'
    # })

    Universities.to_csv('Universities.csv', index=False, na_rep=r'\N')


#------------------------ END OF FUNCTION DEFINITIONS --------------------------



# Set path to IMDb data
# ---------------------
data_path = '../'
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
