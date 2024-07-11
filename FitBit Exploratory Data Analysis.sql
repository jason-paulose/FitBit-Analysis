/* Exploratory Data Analysis*/
SELECT *
FROM ActivityStaging

SELECT *
FROM SleepStaging

SELECT *
FROM HeartRateStaging

-- 1) Confirm start and end range of datasets are all consistent
SELECT MIN(CleanDate) AS StartDate, MAX(CleanDate) AS EndDate
FROM ActivityStaging

SELECT MIN(CleanDate) AS StartDate, MAX(CleanDate) AS EndDate
FROM HeartRateStaging

SELECT MIN(CleanDate) AS StartDate, MAX(CleanDate) AS EndDate
FROM SleepStaging

-- 2) What is the distinct # of individuals in each dataset?
SELECT COUNT(DISTINCT(Id)) AS DistinctIndividuals
FROM ActivityStaging

SELECT COUNT(DISTINCT(Id)) AS DistinctIndividuals
FROM HeartRateStaging

SELECT COUNT(DISTINCT(Id)) AS DistinctIndividuals
FROM SleepStaging

-- 3) How many days were data collected per person?
SELECT Id, COUNT(CleanDate) AS ActivityDaysActive
FROM ActivityStaging
GROUP BY Id
ORDER BY COUNT(CleanDate) DESC

SELECT Id, COUNT(CleanDate) AS HearRateDaysActive
FROM HeartRateStaging
GROUP BY Id
ORDER BY COUNT(CleanDate) DESC

SELECT Id, COUNT(CleanDate) AS SleepDaysActive
FROM SleepStaging
GROUP BY Id
ORDER BY COUNT(CleanDate) DESC

-- 4) What month saw the most steps?
SELECT MONTH(CleanDate) as MonthOfDate, SUM(TotalSteps) AS TotalSteps
FROM ActivityStaging
GROUP BY MONTH(CleanDate)

-- 6) What is the average # of calories burned/day?
SELECT AVG(calories) AS AverageCalories
FROM ActivityStaging

-- 7) What are the totals & rolling total of calories burned by day/person?
WITH RollingTotal AS (
SELECT DISTINCT Id, MONTH(CleanDate) AS MonthOfDate, DAY(CleanDate) AS DayofDate, SUM(Calories) AS TotalCalories
FROM ActivityStaging
GROUP BY Id, MONTH(CleanDate), DAY(CleanDate)
)
SELECT Id, MonthOfDate, DayofDate, TotalCalories, SUM(TotalCalories) OVER (ORDER By Id, MonthOfDate, DayOfDate) AS RollingTotalCalories
FROM RollingTotal
GROUP BY Id, MonthOFDate, DayofDate, TotalCalories

-- 8) What is the most steps each person covered in a day?
SELECT Id, MAX(TotalSteps) AS MaxSteps
FROM ActivityStaging
GROUP BY Id
ORDER BY MaxSteps DESC

-- 9) What is the most distance each person covered in a day?
SELECT Id, MAX(TotalDistance) AS MaxDistance
FROM ActivityStaging
GROUP BY Id
ORDER BY MaxDistance DESC

-- 10) Who was involved in Activity by not Sleep?
SELECT DISTINCT(Act.Id), Sleep.Id
FROM ActivityStaging Act LEFT JOIN SleepStaging Sleep ON Act.Id = Sleep.Id

-- 11) Who averages over 10000 steps a day?
SELECT Id, AVG(TotalSteps) AS AverageSteps, (AVG(TotalSteps) - 10000) AS StepDelta
FROM ActivityStaging
GROUP BY Id
HAVING (AVG(TotalSteps) - 10000) > 0
ORDER BY (AVG(TotalSteps) - 10000) DESC

