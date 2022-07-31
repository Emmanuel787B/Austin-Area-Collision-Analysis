
--Creating Table--

CREATE TABLE Real_Time_Traffic_Incident_Reports_Cleaned (
	traffic_report_id text, 
	date date,
	time time, 
	issue_reported text, 
	location point, 
	latitude real,
	longitude real, 
	PRIMARY KEY (traffic_report_id)
	);

------------------	

--Inserting Data-- 
COPY Real_Time_Traffic_Incident_Reports_Cleaned
FROM 'C:\MYDIRECTORY\Real_Time_Traffic_Incident_Reports_Cleaned.csv'
WITH (FORMAT CSV, HEADER );

-----------------

--Data Check-- 

SELECT * 
FROM Real_Time_Traffic_Incident_Reports_Cleaned
ORDER BY 2 DESC; 

-----------------

--Viewing All Collisions/Fatalities With Dates--

SELECT date, issue_reported
FROM Real_Time_Traffic_Incident_Reports_Cleaned
WHERE issue_reported ILIKE ANY(ARRAY['%collision%', '%fatal%', '%crash%']);

----------------

--Creating collision_date_table-- 

CREATE TABLE collision_date_table(
	date date,
	issue_reported text
	);

INSERT INTO collision_date_table
SELECT date, issue_reported
FROM Real_Time_Traffic_Incident_Reports_Cleaned
WHERE issue_reported ILIKE ANY(ARRAY['%collision%', '%fatal%', '%urgent%']);

---------------------

--Finding Which Season Is Most Dangerous Since Last 4 Seasons-- 
--Date Range 2018-12-21 to 2022-06-16

--WINTER--
SELECT COUNT(*)
FROM(
SELECT *
FROM collision_date_table
WHERE date BETWEEN '2018/12/21' AND '2019/03/19'
OR date BETWEEN '2019/12/21' AND '2020/03/19'
OR date BETWEEN '2020/12/21' AND '2021/03/19'
OR date BETWEEN '2021/12/21' AND '2022/03/19'
) AS subquery;
--21047--

--SPRING--
SELECT COUNT(*)
FROM(
SELECT *
FROM collision_date_table
WHERE date BETWEEN '2018/03/20' AND '2018/06/20'
OR date BETWEEN '2019/03/20' AND '2019/06/20'
OR date BETWEEN '2020/03/20' AND '2020/06/20'
OR date BETWEEN '2021/03/20' AND '2021/06/20'
) AS subquery;
--21371

--Summer--
SELECT COUNT(*)
FROM(
SELECT *
FROM collision_date_table
WHERE date BETWEEN '2018/06/21' AND '2018/09/21'
OR date BETWEEN '2019/06/21' AND '2019/09/21'
OR date BETWEEN '2020/06/21' AND '2020/09/21'
OR date BETWEEN '2021/06/21' AND '2021/09/21'
) AS subquery;
--17361--

--Fall--
SELECT COUNT(*)
FROM(
SELECT *
FROM collision_date_table
WHERE date BETWEEN '2018/09/22' AND '2018/12/20'
OR date BETWEEN '2019/09/22' AND '2019/12/20'
OR date BETWEEN '2020/09/22' AND '2020/12/20'
OR date BETWEEN '2021/09/22' AND '2021/12/20'
) AS subquery;
--23092--

--Fall has the most accidents involving injury from the last 4 seasons with 23092 collisions, with spring following close behind with 21371 collisions.-- 

--------------------

--Creating collison_time_table-- 

CREATE TABLE collision_time_table(
	time time,
	issue_reported text
	);
	
INSERT INTO collision_time_table
SELECT time, issue_reported
FROM Real_Time_Traffic_Incident_Reports_Cleaned
WHERE issue_reported ILIKE ANY(ARRAY['%collision%', '%fatal%', '%urgent%']);
	
-----------------------

--Finding Most Dangerous Time To Drive--

SELECT COUNT(*)
FROM(
SELECT * 
FROM collision_time_table
WHERE time BETWEEN '08:00' AND '11:59'
ORDER BY 1 
) AS subquery;
--8049--

SELECT COUNT(*)
FROM(
SELECT * 
FROM collision_time_table
WHERE time BETWEEN '12:00' AND '15:59'
ORDER BY 1
) AS subquery;
--19595--

SELECT COUNT(*)
FROM(
SELECT * 
FROM collision_time_table
WHERE time BETWEEN '16:00' AND '19:59'
ORDER BY 1 
) AS subquery;
--23078--

SELECT COUNT(*)
FROM(
SELECT * 
FROM collision_time_table
WHERE time BETWEEN '20:00' AND '23:59'
ORDER BY 1
) AS subquery;
--26450--

SELECT COUNT(*)
FROM(
SELECT * 
FROM collision_time_table
WHERE time BETWEEN '00:00' AND '03:59'
ORDER BY 1 
) AS subquery;
--16893--

SELECT COUNT(*)
FROM(
SELECT * 
FROM collision_time_table
WHERE time BETWEEN '04:00' AND '07:59'
ORDER BY 1
) AS subquery;
--8564--

--The most collisions occur between 8 pm and 12 am with 26540 reports. Followed by 23078 reports between 4 pm and 8 pm. --
