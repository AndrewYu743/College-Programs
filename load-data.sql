/*
This script loads normalised IMDb data into IMDb database tables created by
using the script imdb-create-tables.sql.

To use the IMDb scripts:

1) Open MySQL in terminal:
 $ mysql -u root -p --local-infile

2) Create IMDb data base in MySQL:
 mysql> SOURCE /Users/william/Projects/college-db/College-Programs/imdb-create-tables.sql

3) Load data using this script in MySQL:
 mysql> SOURCE /Users/william/Projects/college-db/College-Programs/imdb-load-data.sql

4) Add constraints to the IMDb database in MySQL
 mysql> SOURCE /Users/william/Projects/college-db/College-Programs/imdb-add-constraints.sql

 5) Add indexes to the IMDb database in MySQL
 mysql> SOURCE /Users/william/Projects/college-db/College-Programs/imdb-index-tables.sql
 
*/


-- SHOW VARIABLES LIKE "local_infile";
SET GLOBAL local_infile = 1;


LOAD DATA LOCAL INFILE  '/Users/william/Projects/college-db/College-Programs/Universities.tsv'
INTO TABLE Universities
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE  '/Users/william/Projects/college-db/College-Programs/Test_Scores.csv'
INTO TABLE Test_Scores
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE  '/Users/william/Projects/college-db/College-Programs/Demographics.csv'
INTO TABLE Demographics
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE  '/Users/william/Projects/college-db/College-Programs/Program_Percentages.csv'
INTO TABLE Program_Percentages
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE  '/Users/william/Projects/college-db/College-Programs/Costs.csv'
INTO TABLE Costs
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE  '/Users/william/Projects/college-db/College-Programs/Earnings.csv'
INTO TABLE Earnings
COLUMNS TERMINATED BY ','
IGNORE 1 LINES;

-- SET SQL_SAFE_UPDATES = 0;
-- delete from Degrees_Offered;
-- delete from Broad_CIP_Areas;
-- delete from Specific_CIP_Codes;
-- SET SQL_SAFE_UPDATES = 1;

LOAD DATA LOCAL INFILE  '/Users/william/Projects/college-db/College-Programs/Broad_CIP_Areas.tsv'
INTO TABLE Broad_CIP_Areas
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '"\n' 
IGNORE 1 LINES;

-- this will throw a warning for duplicate entries
LOAD DATA LOCAL INFILE  '/Users/william/Projects/college-db/College-Programs/Specific_CIP_Codes.tsv'
INTO TABLE Specific_CIP_Codes
FIELDS TERMINATED BY '\t'
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;

-- will throw warning b/c most rows have lots of nulls
LOAD DATA LOCAL INFILE  '/Users/william/Projects/college-db/College-Programs/Degrees_Offered.csv'
INTO TABLE Degrees_Offered
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n' 
IGNORE 1 LINES;

ALTER TABLE Degrees_Offered ADD degree_id int unsigned PRIMARY KEY auto_increment FIRST;
-- ALTER TABLE Degrees_Offered
-- ADD CONSTRAINT PK_Degrees_Offered PRIMARY KEY (degree_id);
