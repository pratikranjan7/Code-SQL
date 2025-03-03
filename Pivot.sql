create table emp_compensation (
emp_id int,
salary_component_type varchar(20),
val int
);


insert into emp_compensation
values (1,'salary',10000),(1,'bonus',5000),(1,'hike_percent',10)
, (2,'salary',15000),(2,'bonus',7000),(2,'hike_percent',8)
, (3,'salary',12000),(3,'bonus',6000),(3,'hike_percent',7);



select * from emp_compensation;


select emp_id,
max(case when salary_component_type = 'salary' then val end) as salary,
max(case when salary_component_type = 'bonus' then val end) as bonus,
max(case when salary_component_type = 'hike_percent' then val end) as hike_percent
-- into emp_compensation_pivot
from emp_compensation
group by emp_id
order by emp_id

select *
from emp_compensation_pivot


select emp_id,'salary' as salary_component_type,salary as val
from emp_compensation_pivot
union all
select emp_id,'bonus' as salary_component_type,bonus as val
from emp_compensation_pivot
union all
select emp_id,'hike_percent' as salary_component_type,hike_percent as val
from emp_compensation_pivot
order by emp_id









----------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX------------------------------------------------------------------
create table players_location
(
name varchar(20),
city varchar(20)
);
delete from players_location;
insert into players_location
values ('Sachin','Mumbai'),('Virat','Delhi') , ('Rahul','Bangalore'),('Rohit','Mumbai'),('Mayank','Bangalore');

select *
from players_location


select player_group,
max(case when city = 'Bangalore' then name end) as Bangalore,
max(case when city = 'Mumbai' then name end) as Mumbai,
max(case when city = 'Delhi' then name end) as Delhi
from 
(select *,
row_number() over(partition by city order by name) as player_group
from players_location)x
group by player_group
order by player_group

----------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX------------------------------------------------------------------


CREATE TABLE years_sum (
    Order_ID INT,
    Customer_Name VARCHAR(50),
    Order_Date DATE,
    Amount INT
);

INSERT INTO years_sum VALUES (1001, 'A', '2020-01-16', 200);
INSERT INTO years_sum VALUES (1002, 'B', '2020-02-12', 140);
INSERT INTO years_sum VALUES (1003, 'C', '2020-03-14', 150);
INSERT INTO years_sum VALUES (1004, 'D', '2020-05-20', 200);
INSERT INTO years_sum VALUES (1005, 'A', '2021-06-17', 180);
INSERT INTO years_sum VALUES (1006, 'B', '2021-07-23', 190);
INSERT INTO years_sum VALUES (1007, 'C', '2021-08-26', 210);
INSERT INTO years_sum VALUES (1008, 'D', '2021-09-14', 250);
INSERT INTO years_sum VALUES (1009, 'A', '2022-10-14', 220);
INSERT INTO years_sum VALUES (1010, 'B', '2022-01-15', 230);
INSERT INTO years_sum VALUES (1011, 'C', '2022-02-16', 240);
INSERT INTO years_sum VALUES (1012, 'D', '2022-03-18', 260);


select customer_name,
sum(CASE WHEN EXTRACT(YEAR FROM order_date) = 2020 THEN amount END) AS sum_2020,
sum(CASE WHEN EXTRACT(YEAR FROM order_date) = 2021 THEN amount END) AS sum_2021,
sum(CASE WHEN EXTRACT(YEAR FROM order_date) = 2022 THEN amount END) AS sum_2022
from years_sum
group by customer_name
order by customer_name


---------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------------------

CREATE TABLE ProductData (
    Product VARCHAR(255),
    Amount INT,
    Country VARCHAR(255)
);

INSERT INTO ProductData (Product, Amount, Country) VALUES
('Banana', 1000, 'USA'),
('Carrots', 1500, 'USA'),
('Beans', 1600, 'USA'),
('Orange', 2000, 'USA'),
('Banana', 400, 'China'),
('Carrots', 1200, 'China'),
('Beans', 1500, 'China'),
('Orange', 4000, 'China'),
('Banana', 2000, 'Canada'),
('Carrots', 2000, 'Canada'),
('Beans', 2000, 'Mexico');

select *
from ProductData

select country,
max(case when product = 'Banana' then amount end) as Banana,
max(case when product = 'Carrots' then amount end) as Carrots,
max(case when product = 'Beans' then amount end) as Beans,
max(case when product = 'Orange' then amount end) as Orange
from ProductData
group by country
order by country

---------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------------------

CREATE TABLE EmployeeCounts (
    DEPTNO INT,
    CNT INT
);

INSERT INTO EmployeeCounts (DEPTNO, CNT) VALUES
(10, 3),
(20, 5),
(30, 6);

select
max(case when DEPTNO = 10 then cnt end) as "DEPTNO_10",
max(case when DEPTNO = 20 then cnt end) as "DEPTNO_20",
max(case when DEPTNO = 30 then cnt end) as "DEPTNO_30"
from EmployeeCounts


---------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------------------
-- select rn,
-- case when jobtitle = 'ANALYST' then employeename end as ANALYST,
-- case when jobtitle = 'CLERK' then employeename end as CLERK,
-- case when jobtitle = 'MANAGER' then employeename end as MANAGER,
-- case when jobtitle = 'PRESIDENT' then employeename end as PRESIDENT,
-- case when jobtitle = 'SALESMAN' then employeename end as SALESMAN
-- FROM 
-- (SELECT *,
-- row_number() over(partition by jobtitle) as rn
-- FROM JobEmployees)x
-- group by rn
-- order by rn



-- Step 1: Create the table
CREATE TABLE JobEmployees (
    JobTitle VARCHAR(50),
    EmployeeName VARCHAR(50)
);

-- Step 2: Insert the data into the table
INSERT INTO JobEmployees (JobTitle, EmployeeName) VALUES
('ANALYST', 'SCOTT'),
('ANALYST', 'FORD'),
('CLERK', 'SMITH'),
('CLERK', 'ADAMS'),
('CLERK', 'MILLER'),
('CLERK', 'JAMES'),
('MANAGER', 'JONES'),
('MANAGER', 'CLARK'),
('MANAGER', 'BLAKE'),
('PRESIDENT', 'KING'),
('SALESMAN', 'ALLEN'),
('SALESMAN', 'MARTIN'),
('SALESMAN', 'TURNER'),
('SALESMAN', 'WARD');

-- Optional: Query to view the data
SELECT * FROM JobEmployees;

select rn,
max(case when jobtitle = 'ANALYST' then employeename end) as ANALYST,
max(case when jobtitle = 'CLERK' then employeename end) as CLERK,
max(case when jobtitle = 'MANAGER' then employeename end) as MANAGER,
max(case when jobtitle = 'PRESIDENT' then employeename end) as PRESIDENT,
max(case when jobtitle = 'SALESMAN' then employeename end) as SALESMAN
FROM 
(SELECT *,
row_number() over(partition by jobtitle) as rn
FROM JobEmployees)x
group by rn
order by rn
---------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------------------


-- lowest and highest salry emp in each dept
-- Create the 'employee' table
CREATE TABLE emp_sal (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(255),
    salary INT,
    manager_id INT,
    dept VARCHAR(255)
);

-- Insert data into the 'employee' table
INSERT INTO emp_sal (emp_id, emp_name, salary, manager_id, dept) VALUES
(1, 'navin', 1300, 2, 'sales'),
(2, 'ankit', 1200, 3, 'sales'),
(3, 'kavya', 1250, 4, 'sales'),
(4, 'ranjit', 1600, 5, 'sales'),
(5, 'john', 3000, 4, 'marketing'),
(6, 'yash', 1800, 3, 'marketing'),
(7, 'tom', 1500, 2, 'marketing');

select dept,
max(case when highest_sal = 1 then emp_name end)highest_sal, 
max(case when lowest_sal = 1 then emp_name end)lowest_sal
from(select *,
dense_rank() over(partition by dept order by salary desc) as highest_sal,
dense_rank() over(partition by dept order by salary) as lowest_sal
from emp_sal)x
group by dept



-- -- Create table emp_sal with adjusted column sizes
-- CREATE TABLE emp_sal (
--     id INT,
--     emp_name VARCHAR(50),  -- Increased length to 50 to accommodate longer names
--     gender VARCHAR(30),    -- Increased length to 30 for gender identities like 'Genderqueer'
--     dept VARCHAR(50),      -- Increased length to 50 to handle longer department names
--     salary INT
-- );

-- -- Insert data into the emp_sal table
-- INSERT INTO emp_sal VALUES (1, 'Tildie', 'Female', 'Support', 1676);
-- INSERT INTO emp_sal VALUES (2, 'Averil', 'Female', 'Engineering', 1572);
-- INSERT INTO emp_sal VALUES (3, 'Matthiew', 'Male', 'Engineering', 1477);
-- INSERT INTO emp_sal VALUES (4, 'Reinald', 'Male', 'Services', 1877);
-- INSERT INTO emp_sal VALUES (5, 'Karola', 'Genderqueer', 'Marketing', 1029);
-- INSERT INTO emp_sal VALUES (6, 'Manon', 'Genderfluid', 'Research and Development', 1729);
-- INSERT INTO emp_sal VALUES (7, 'Tabbie', 'Female', 'Research and Development', 1000);
-- INSERT INTO emp_sal VALUES (8, 'Corette', 'Female', 'Marketing', 1624);
-- INSERT INTO emp_sal VALUES (9, 'Edward', 'Male', 'Accounting', 1157);
-- INSERT INTO emp_sal VALUES (10, 'Philipa', 'Female', 'Human Resources', 1992);
-- INSERT INTO emp_sal VALUES (11, 'Ingeberg', 'Female', 'Services', 1515);
-- INSERT INTO emp_sal VALUES (12, 'Kort', 'Male', 'Support', 1005);
-- INSERT INTO emp_sal VALUES (13, 'Shelby', 'Male', 'Product Management', 1020);
-- INSERT INTO emp_sal VALUES (14, 'Shelden', 'Male', 'Legal', 1354);
-- INSERT INTO emp_sal VALUES (15, 'Sonya', 'Female', 'Marketing', 1321);

-- drop table emp_sal