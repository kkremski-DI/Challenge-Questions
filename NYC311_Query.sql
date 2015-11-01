


SELECT * FROM (
SELECT 'AgencyName', 'Frequency'
UNION ALL
(
SELECT REPLACE(AgencyName, ',', '') AS AgencyName, Count(AgencyName) AS Frequency
FROM NYC311 
WHERE AgencyName IS NOT NULL AND TRIM(AgencyName) <> ''
GROUP BY AgencyName
ORDER BY COUNT(AgencyName) DESC 
)
)
resulting_set
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/DeptFreq.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

SELECT * FROM (
SELECT 'Borough', 'ComplaintType', 'Frequency'
UNION ALL
(
SELECT REPLACE(Borough, ',', '') AS Borough, REPLACE(ComplaintType, ',', '') AS ComplaintType, COUNT(ComplaintType) AS Frequency
FROM NYC311
WHERE Borough IS NOT NULL AND TRIM(Borough) <> '' AND ComplaintType IS NOT NULL AND TRIM(ComplaintType) <> ''
GROUP BY Borough, ComplaintType
ORDER BY COUNT(ComplaintType) DESC
)
)
resulting_set
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/ComplType.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';


SELECT * FROM (
SELECT 'Latitude', 'Longitude'
UNION ALL
(
SELECT Latitude, Longitude
FROM NYC311
WHERE concat('',Latitude * 1) = Latitude AND concat('',Longitude * 1) = Longitude
ORDER BY Latitude DESC
)
)
resulting_set
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/Coords.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';

SELECT * FROM (
SELECT 'CreatedDate', 'ClosedDate'
UNION ALL
(
SELECT REPLACE(CreatedDate, ',', '') AS CreatedDate, REPLACE(ClosedDate, ',', '') AS ClosedDate
FROM NYC311
WHERE CreatedDate IS NOT NULL AND TRIM(CreatedDate) <> '' AND ClosedDate IS NOT NULL AND TRIM(ClosedDate) <> ''
ORDER BY CreatedDate DESC
)
)
resulting_set
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 5.7/Uploads/Times.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';
