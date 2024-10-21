# US Household Income (Data Cleaning)

USE us_project;

SELECT * FROM us_project.us_household_income;

SELECT * FROM us_project.us_household_income_statistics;

# Rename the column to remove unwanted characters
ALTER TABLE us_household_income_statistics RENAME COLUMN `ï»¿id` TO id;

# Count total records in the household income table
SELECT COUNT(id)
FROM us_household_income
;

# Count total records in the household income statistics table
SELECT COUNT(id)
FROM us_household_income_statistics
;

# Identify duplicate IDs in the household income table
SELECT id, COUNT(id)
FROM us_household_income
GROUP BY id
HAVING COUNT(id) > 1
;

# Select rows with duplicate IDs for review
SELECT *
	FROM (
	SELECT row_id,
	id,
	ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
	FROM us_household_income
	) AS Row_Table
WHERE row_num > 1
;

# Delete duplicate records from the household income table
DELETE FROM us_household_income
WHERE row_id IN (
	SELECT row_id
		FROM (
		SELECT row_id,
		id,
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
		FROM us_household_income
		) AS Row_Table
WHERE row_num > 1
);


# Count occurrences of each state in the household income table
SELECT State_Name, COUNT(State_Name)
FROM us_household_income
GROUP BY State_Name
;

# Correct misspelled state names in the dataset (Georgia)
UPDATE us_household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

# Correct misspelled state names in the dataset (Alabama)
UPDATE us_household_income
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama';

# Retrieve state abbreviations from the household income table
SELECT State_ab
FROM us_household_income
;

# Count occurrences of each type in the household income table
SELECT Type, COUNT(Type)
FROM us_household_income
GROUP BY Type
;

# Standardize type names in the dataset (Borough)
UPDATE us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs';

# Retrieve records for a specific county (Autauga County)
SELECT * 
FROM us_household_income
WHERE County = 'Autauga County'
;
# Update place name for a specific county and city combination (Vinemont)
UPDATE us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont'
;

# Identify records with missing or zero land area values
SELECT ALand, AWater 
FROM us_household_income
WHERE (ALand = 0 OR ALand = '' OR ALand IS NULL)
;