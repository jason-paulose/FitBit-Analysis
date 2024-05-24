/* DATA CLEANING*/
SELECT *
FROM Activity

SELECT *
FROM Sleep

SELECT *
FROM HeartRate

-- Code to drop tables if needed

DROP TABLE ActivityStaging
DROP TABLE SleepStaging
DROP TABLE HeartRateStaging

-- check for duplicates up front
SELECT Id, Date , TotalSteps, TotalDistance, SedentaryMinutes, TotalActiveMinutes, Calories , COUNT(*) AS Counter
FROM Activity
GROUP BY Id, Date, TotalSteps, TotalDistance, SedentaryMinutes, TotalActiveMinutes, Calories
HAVING COUNT(*) > 1

SELECT Id, Date , TotalMinutesAsleep, TotalTimeInBed , COUNT(*) AS Counter
FROM Sleep
GROUP BY Id, Date , TotalMinutesAsleep, TotalTimeInBed 
HAVING COUNT(*) > 1

SELECT Id, Date , Heart_rate, COUNT(*) AS Counter
FROM HeartRate
GROUP BY Id, Date , Heart_rate
HAVING COUNT(*) > 1

-- look into duplicates found in sleep data
SELECT *
FROM Sleep
WHERE ID = 4388161847 AND Date = '2016-05-05'

SELECT *
FROM Sleep
WHERE ID = 4702921684 AND Date = '2016-05-07'

SELECT *
FROM Sleep
WHERE ID = 8378563200 AND Date = '2016-04-25'

-- Remove duplicates and create a staging table
WITH CTE AS (
SELECT *
FROM Sleep
GROUP BY Id, Date, TotalMinutesAsleep, TotalTimeInBed)
SELECT*
INTO SleepStaging
FROM CTE

-- create remaining staging tables
SELECT *
INTO ActivityStaging
FROM Activity

SELECT *
INTO HeartRateStaging
FROM HeartRate

-- check for nulls
SELECT *
FROM ActivityStaging
WHERE Id IS NULL
OR DATE IS NULL
OR TotalSteps IS NULL
OR TotalDistance IS NULL
OR SedentaryMinutes IS NULL
OR TotalActiveMinutes IS NULL
OR Calories IS NULL

SELECT *
FROM SleepStaging
WHERE Id IS NULL
OR DATE IS NULL
OR TotalMinutesAsleep IS NULL
OR TotalTimeInBed IS NULL

SELECT *
FROM HeartRateStaging
WHERE Id IS NULL
OR DATE IS NULL
OR Heart_rate IS NULL

-- Standardize data by identifying any whitespace
SELECT *
FROM SleepStaging
WHERE CONCAT(Id, Date, TotalMinutesAsleep, TotalTimeInBed) LIKE '% %'

SELECT *
FROM ActivityStaging
WHERE CONCAT(Id, Date, TotalSteps, TotalDistance, SedentaryMinutes, TotalActiveMinutes, Calories) LIKE '% %'

SELECT *
FROM HeartRateStaging
WHERE CONCAT(Id, Date, Heart_rate) LIKE '% %'

-- change date to preferred format
ALTER TABLE ActivityStaging
ADD CleanDate varchar(10)

UPDATE ActivityStaging
SET CleanDate = CONVERT(varchar(10), Date,1)

ALTER TABLE ActivityStaging
ALTER COLUMN CleanDate DATE

ALTER TABLE ActivityStaging
DROP COLUMN Date

ALTER TABLE SleepStaging
ADD CleanDate varchar(10)

UPDATE SleepStaging
SET CleanDate = CONVERT(varchar(10), Date,1)

ALTER TABLE SleepStaging
ALTER COLUMN CleanDate DATE

ALTER TABLE SleepStaging
DROP COLUMN Date

ALTER TABLE HeartRateStaging
ADD CleanDate varchar(10)

UPDATE HeartRateStaging
SET CleanDate = CONVERT(varchar(10), Date,1)

ALTER TABLE HeartRateStaging
ALTER COLUMN CleanDate DATE

ALTER TABLE HeartRateStaging
DROP COLUMN Date

-- remove unecessary columns
ALTER TABLE ActivityStaging
DROP COLUMN SedentaryMinutes

ALTER TABLE SleepStaging
DROP COLUMN TotalTimeInBed

