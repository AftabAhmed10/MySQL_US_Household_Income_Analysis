# US Household Income (Exploratory Data Analysis)

SELECT * FROM us_project.us_household_income;

SELECT * FROM us_project.us_household_income_statistics;

# Calculate total land and water area by state, ordered by land area (top 10 states)
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_household_income
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10
;

#Calculate total land and water area by state, ordered by water area (top 10 states)
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_household_income
GROUP BY State_Name
ORDER BY 3 DESC
LIMIT 10
;

# Join household income data with statistics based on ID
SELECT * 
FROM us_household_income u
JOIN us_household_income_statistics us
	ON u.id = us.id
;

# Inner join to filter out records where Mean is not zero
SELECT * 
FROM us_household_income u
INNER JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
;

# Select relevant columns while joining tables, filtering out zero Mean values
SELECT u.State_Name, County, Type, `Primary`, Mean, Median 
FROM us_household_income u
INNER JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
;

# Calculate average Mean and Median income by state, ordered by average Median (top 10 states)
SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1) 
FROM us_household_income u
INNER JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY 1
ORDER BY 3 DESC
LIMIT 10
;


#  Analyze income type distribution with averages and counts
SELECT Type, COUNT(Type), ROUND(AVG(Mean),1), ROUND(AVG(Median),1) 
FROM us_household_income u
INNER JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY Type
HAVING COUNT(Type) > 100
ORDER BY 4 DESC
LIMIT 100
;

# Calculate average Mean and Median income by city within each state, ordered by average Mean income
SELECT u.State_Name, CITY, ROUND(AVG(Mean),1), ROUND(AVG(Median),1) 
FROM us_household_income u
INNER JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name, CITY
ORDER BY 3 DESC
;
