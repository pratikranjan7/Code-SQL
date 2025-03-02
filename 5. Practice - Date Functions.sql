CREATE TABLE emp_info (
empno INT,
ename VARCHAR(10),
job VARCHAR(9),
mgr INT,
hiredate DATE,
sal INT,
comm INT,
dept INT);

INSERT INTO emp_info VALUES
    (1,'JOHNSON','ADMIN',6,'1990-12-17',18000,NULL,4),
    (2,'HARDING','MANAGER',9,'1998-02-02',52000,300,3),
    (3,'TAFT','SALES I',2,'1996-01-02',25000,500,3),
    (4,'HOOVER','SALES I',2,'1990-04-02',27000,NULL,3),
    (5,'LINCOLN','TECH',6,'1994-06-23',22500,1400,4),
    (6,'GARFIELD','MANAGER',9,'1993-05-01',54000,NULL,4),
    (7,'POLK','TECH',6,'1997-09-22',25000,NULL,4),
    (8,'GRANT','ENGINEER',10,'1997-03-30',32000,NULL,2),
    (9,'JACKSON','CEO',NULL,'1990-01-01',75000,NULL,4),
    (10,'FILLMORE','MANAGER',9,'1994-08-09',56000,NULL,2),
    (11,'ADAMS','ENGINEER',10,'1996-03-15',34000,NULL,2),
    (12,'WASHINGTON','ADMIN',6,'1998-04-16',18000,NULL,4),
    (13,'MONROE','ENGINEER',10,'2000-12-03',30000,NULL,2),
    (14,'ROOSEVELT','CPA',9,'1995-10-12',35000,NULL,1);

SELECT * FROM emp_info;


-- Q1. Decrease one year from Hiredate.

SELECT * FROM emp_info;

select *,extract (year from hiredate) - 1 as decreased_year
from  emp_info


-- Q2. Calculate the tenure of the employees (in months) in the company.

SELECT * FROM emp_info;

SELECT *, 
       EXTRACT(MONTH FROM AGE(CURRENT_DATE, hiredate)) AS tenure_in_months
FROM emp_info;

	SELECT *, 
	       EXTRACT(YEAR FROM AGE(CURRENT_DATE, hiredate)) * 12 
	        + EXTRACT(MONTH FROM AGE(CURRENT_DATE, hiredate)) AS tenure_in_months
	FROM emp_info;

SELECT CURRENT_TIMESTAMP;
SELECT NOW();
SELECT CURRENT_DATE;


-- Q3. Extract Day, Month, Year, Weekday from hiredate.

select hiredate,extract(day from hiredate),extract(month from hiredate),extract(year from hiredate),extract(dow from hiredate)
from emp_info


-- EXTRACT(DOW FROM hiredate): This part of the query extracts the day of the week as a number (0 for Sunday, 1 for Monday, ..., 6 for Saturday).



-- SELECT hiredate,
--        (EXTRACT(DOW FROM hiredate) + 6) % 7 AS weekday_number
-- FROM emp_info;
-- Explanation
-- EXTRACT(DOW FROM hiredate): Extracts the day of the week where Sunday is 0 and Saturday is 6.
-- (EXTRACT(DOW FROM hiredate) + 6) % 7: Adjusts the result so that Monday becomes 0, Tuesday becomes 1, ..., and Sunday becomes 6.

-- TO_CHAR(value, format)

-- 'YYYY': Year (4 digits)
-- 'MM': Month (2 digits)
-- 'DD': Day (2 digits)
-- 'Day': Full name of the day of the week (e.g., 'Monday')
-- 'DY': Abbreviated name of the day of the week (e.g., 'Mon')
-- 'HH24': Hour (24-hour format)
-- 'MI': Minutes
-- 'SS': Seconds

-- Q4. Find employees who were hired on Monday.
The issue with your query is that the TO_CHAR function with the 'Day' format returns the 
day name with trailing spaces 

select *
from emp_info
WHERE TRIM(TO_CHAR(hiredate, 'Day')) = 'Monday'

-- Q5. Find employees who were hired after 1996.

select *
from emp_info
where extract(year from hiredate)>1996
	
-- Q6. Find employees who were hired after 1996 and before 1998.
	
select *
from emp_info
where extract(year from hiredate)>1996 and extract(year from hiredate)<1998

-- Q7. Find years where more than 2 employees were hired.

select count(distinct empno),extract(year from hiredate)
from emp_info
group by extract(year from hiredate)
having count(distinct empno) > 2

