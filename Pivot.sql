-- SQL Consecutive Login Days Problem

create table activity(player_id int,device_id int,event_date date)

insert into activity values(1,2,'2024-12-01');
insert into activity values(1,2,'2024-12-02');
insert into activity values(2,3,'2024-12-05');
insert into activity values(3,1,'2024-12-07');
insert into activity values(3,4,'2024-12-09');




with cte as(select *,
CASE
WHEN event_date - prev_event_date = 1 THEN 'Yes'
ELSE 'No'
END AS is_consecutive
from
(
    SELECT
        player_id,
        event_date,
        LAG(event_date) OVER (PARTITION BY player_id ORDER BY event_date) AS prev_event_date
    FROM
        activity
)x)


select player_id
from cte 
where is_consecutive = 'Yes'



-------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXX-------------------------------------------------------------------

-- SQL Hard Challenge Fill Nulls
drop table if exists brands;
create table brands
(
    category varchar(50),
    brand_name varchar(50)
)

insert into brands
values
    ('chocolates', '5-star'),
    (NULL, 'dairy milk'),
    (NULL, 'perk'),
    (NULL, 'eclair'),
    ('Biscuits', 'Britania'),
    (NULL, 'good day'),
    (NULL, 'boost')

select * from brands;


with cte as(select row_number() over() as id,*,
case when category is not null then 1 else 0
end as temp
from brands),

cte2 as(select *,
sum(temp) over(order by id) as temp2
from cte)

select *
,first_value(category) over(partition by temp2 order by id)
from cte2;


--------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX------------------------------------------------------------------


--Write a query to calculate the absolute difference between the highest salaries in the Marketing and Engineering departments. 
--Output only the absolute difference in salaries.

CREATE TABLE departments ( 
department_id INT PRIMARY KEY, 
department_name VARCHAR(50) NOT NULL 
); 

-- Insert department data 
INSERT INTO departments (department_id, department_name) VALUES 
(1, 'Marketing'), 
(2, 'Engineering'), 
(3, 'Sales'); 

-- Drop table if it exists 
DROP TABLE IF EXISTS employees; 

-- Create employees table 
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    salary INT NOT NULL,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- CREATE TABLE employees ( 
-- id INT PRIMARY KEY IDENTITY(1,1), 
-- first_name VARCHAR(50) NOT NULL, 
-- last_name VARCHAR(50) NOT NULL, 
-- salary INT NOT NULL, 
-- department_id INT, 
-- FOREIGN KEY (department_id) REFERENCES departments(department_id) 
-- ); 

-- Enable manual ID insertion 
SET IDENTITY_INSERT employees ON; 

-- Insert employee data with ID 
INSERT INTO employees (id, first_name, last_name, salary, department_id) VALUES 
(1, 'John', 'Doe', 70000, 1), 
(2, 'Jane', 'Smith', 80000, 2), 
(3, 'Jim', 'Brown', 75000, 1), 
(4, 'Jack', 'Davis', 90000, 2), 
(5, 'Jill', 'Wilson', 60000, 1), 
(6, 'Joe', 'Taylor', 65000, 3); 


select * from employees
select * from departments


with cte as(select 
t1.id
,t1.first_name
,t1.last_name
,t1.salary
,t1.department_id
,t2.department_name,
dense_rank() over(partition by t2.department_name order by salary desc) rnk,
max(case when t2.department_name = 'Engineering' then salary end) as Engineering_Sal,
max(case when t2.department_name = 'Marketing' then salary end) as Marketing_Sal
-- first_value(salary) over(partition by t2.department_name) highest_sal,
-- last_value(salary) over(partition by t2.department_name) lowest_sal,
-- (first_value(salary) over(partition by t2.department_name)) - (last_value(salary) over(partition by t2.department_name)) as sal_diff
from employees t1
join departments t2
on t1.department_id = t2.department_id
group by 
t1.id
,t1.first_name
,t1.last_name
,t1.salary
,t1.department_id
,t2.department_name)

select *
from cte 
where Engineering_Sal is not null and Marketing_Sal is not null

where t2.department_name in ('Engineering','Marketing')


--------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX------------------------------------------------------------------

with cte as(select 
t1.id
,t1.first_name
,t1.last_name
,t1.salary
,t1.department_id
,t2.department_name,
dense_rank() over(partition by t2.department_name order by salary desc) rnk
-- first_value(salary) over(partition by t2.department_name) highest_sal,
-- last_value(salary) over(partition by t2.department_name) lowest_sal,
-- (first_value(salary) over(partition by t2.department_name)) - (last_value(salary) over(partition by t2.department_name)) as sal_diff
from employees t1
join departments t2
on t1.department_id = t2.department_id),


cte2 as(select *,
lead(salary,1,1) over(order by salary desc) as lead_sal
from cte 
where rnk =1 and department_name <> 'Sales')


select (salary-lead_sal) as diff 
from cte2
limit 1

--------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX------------------------------------------------------------------


--Q. Write a SQL query to find the employee names who have the same salary as another employee in the same department.
create table emp_info(id int, name varchar(10),dept varchar(10),salary int);

insert into emp_info values(1,'Akash','Sales',100);
insert into emp_info values(2,'John','Sales',110);
insert into emp_info values(3,'Rohit','Sales',100);
insert into emp_info values(4,'Tom','IT',200);
insert into emp_info values(5,'Subham','IT',205);
insert into emp_info values(6,'Vabna','IT',200);
insert into emp_info values(7,'Prativa','Marketing',150);
insert into emp_info values(8,'Rahul','Marketing',155);
insert into emp_info values(9,'yash','Marketing',160);

with cte as(select *,
dense_rank() over(partition by dept order by salary desc),
lead(salary) over(partition by dept) as lead_sal,
lag(salary) over(partition by dept) as lag_sal
from emp_info)

select id,name,dept,salary
from cte 
where salary = lead_sal or salary = lag_sal


--------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX------------------------------------------------------------------
-- Customer Ordered for consecutive days

-- CREATE TABLE Orders (  
-- customer_name VARCHAR(255), 
-- order_date DATETIME 
-- ); 

CREATE TABLE Orders (
    customer_name VARCHAR(255),
    order_date TIMESTAMP
);

 

INSERT INTO Orders (customer_name, order_date) VALUES ('Alice', '2024-04-01'); 
INSERT INTO Orders (customer_name, order_date) VALUES ('Bob', '2024-04-01'); 
INSERT INTO Orders (customer_name, order_date) VALUES ('Alice', '2024-04-02'); 
INSERT INTO Orders (customer_name, order_date) VALUES ('Bob', '2024-04-02'); 
INSERT INTO Orders (customer_name, order_date) VALUES ('Charlie', '2024-04-03'); 
INSERT INTO Orders (customer_name, order_date) VALUES ('Alice', '2024-04-03'); 
INSERT INTO Orders (customer_name, order_date) VALUES ('Alice', '2024-04-04'); 
INSERT INTO Orders (customer_name, order_date) VALUES ('Bob', '2024-04-04'); 
INSERT INTO Orders (customer_name, order_date) VALUES ('Charlie', '2024-04-05'); 
INSERT INTO Orders (customer_name, order_date) VALUES ('Alice', '2024-04-05'); 
INSERT INTO Orders (customer_name, order_date) VALUES ('Bob', '2024-04-06'); 
INSERT INTO Orders (customer_name, order_date) VALUES ('Charlie', '2024-04-06'); 

SELECT * FROM Orders order by customer_name;





--------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX------------------------------------------------------------------
-- SQL | Names of Managers who manage more than 4 employees 

-- Step 1: Create the Employee table
CREATE TABLE Employee (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    manager_id INT NULL
);

-- Step 2: Insert data into the Employee table
INSERT INTO Employee (id, name, department, manager_id) VALUES
(1, 'John', 'HR', NULL),
(2, 'Bob', 'HR', 1),
(3, 'Olivia', 'HR', 1),
(4, 'Emma', 'Finance', NULL),
(5, 'Sophia', 'HR', 1),
(6, 'Mason', 'Finance', 4),
(7, 'Ethan', 'HR', 1),
(8, 'Ava', 'HR', 1),
(9, 'Lucas', 'HR', 1),
(10, 'Isabela', 'Finance', 4),
(11, 'Hamper', 'Finance', 4);

-- Step 3: Query to display the Employee table


SELECT 
t1.manager_id,
t2.name as manager_name,
t1.id as emp_id,
t1.name as emp_name,
t1.department
FROM Employee t1
join Employee t2
on t1.manager_id = t2.id
order by t1.manager_id;




SELECT 
t1.manager_id,
t2.name as manager_name,
count(*) as no_of_emp
FROM Employee t1
join Employee t2
on t1.manager_id = t2.id
group by 
t1.manager_id,
t2.name 
having count(*) > 4
--------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX------------------------------------------------------------------
-- SQL | Find each flight's source and destination 

DROP TABLE flight_info;
CREATE TABLE flight_info (
    id INT,
    source VARCHAR(50),
    destination VARCHAR(50)
);

-- Step 2: Insert data into the flight_info table
INSERT INTO flight_info (id, source, destination) VALUES
(1, 'Delhi', 'Kolkata'),
(2, 'Kolkata', 'Banglore'),
(3, 'Mumbai', 'Pune'),
(4, 'Pune', 'Goa'),
(5, 'Kolkata', 'Delhi'),
(6, 'Delhi', 'Srinagar');

select t1.id,t1.source,t2.destination
from flight_info t1
join flight_info t2
on t1.destination = t2.source and t1.source <> t2.destination;




--------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX------------------------------------------------------------------
-- SQL | Find the minimum and maximum salary in each company | #sql | Interview Problem |

DROP table employee;
-- Create the employee table
CREATE TABLE employee_max_sal_min_sal (
    emp_id VARCHAR(10),
    company CHAR(1),
    salary INT,
    dept VARCHAR(50)
);

-- Insert data into the employee table
INSERT INTO employee_max_sal_min_sal (emp_id, company, salary, dept)
VALUES
('emp1', 'X', 1000, 'Sales'),
('emp2', 'X', 1020, 'IT'),
('emp3', 'X', 870, 'Sales'),
('emp4', 'Y', 1200, 'Marketing'),
('emp5', 'Y', 1500, 'IT'),
('emp6', 'Y', 1100, 'Sales'),
('emp7', 'Z', 1050, 'IT'),
('emp8', 'Z', 1350, 'Marketing'),
('emp9', 'Z', 1700, 'Sales');

select company,max(MaxSal)MaxSal,min(MinSal)MinSal
from
(select *,
case 
when salary = max(salary) over(partition by company) then salary
end as MaxSal,
case 
when salary = min(salary) over(partition by company) then salary
end as MinSal
from employee_max_sal_min_sal)x
group by company



--------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX------------------------------------------------------------------
-- SQL | find max, min population city names by state | SQL Interview Question |

-- Create the CityPopulation table
CREATE TABLE CityPopulation (
    id INT PRIMARY KEY,
    state VARCHAR(50),
    city VARCHAR(50),
    population INT
);

-- Insert sample data into the CityPopulation table
INSERT INTO CityPopulation (id, state, city, population) VALUES
(1, 'Maharashtra', 'Mumbai', 1000),
(2, 'Maharashtra', 'Pune', 500),
(3, 'Maharashtra', 'Nagpur', 400),
(4, 'Punjab', 'Amritsar', 800),
(5, 'Punjab', 'Ludhiana', 350),
(6, 'Punjab', 'Patiala', 200),
(7, 'TamilNadu', 'Chennai', 700),
(8, 'TamilNadu', 'Vellore', 400);

select state,
max(case 
when population = max_population then city end) as max_population_city,
max(case 
when population = min_population then city end) as min_population_city
from
(select *,
max(population) over(partition by state) as max_population,
min(population) over(partition by state) as min_population
from   CityPopulation)x
group by state;





--------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX------------------------------------------------------------------
-- Question: Write a query to find out the company who have atleast 2 users speaks both English and German?

CREATE TABLE Company_user (
 Company_Id VARCHAR(512),
 User_Id INT,
 Language VARCHAR(512)
);



INSERT INTO Company_user (Company_Id, User_Id, Language) VALUES ('1', '1', 'German');
INSERT INTO Company_user (Company_Id, User_Id, Language) VALUES ('1', '1', 'English');
INSERT INTO Company_user (Company_Id, User_Id, Language) VALUES ('1', '2', 'German');
INSERT INTO Company_user (Company_Id, User_Id, Language) VALUES ('1', '3', 'English');
INSERT INTO Company_user (Company_Id, User_Id, Language) VALUES ('1', '3', 'German');
INSERT INTO Company_user (Company_Id, User_Id, Language) VALUES ('1', '4', 'English');
INSERT INTO Company_user (Company_Id, User_Id, Language) VALUES ('2', '5', 'German');
INSERT INTO Company_user (Company_Id, User_Id, Language) VALUES ('2', '5', 'English');
INSERT INTO Company_user (Company_Id, User_Id, Language) VALUES ('2', '6', 'Spanish');
INSERT INTO Company_user (Company_Id, User_Id, Language) VALUES ('2', '6', 'English');
INSERT INTO Company_user (Company_Id, User_Id, Language) VALUES ('2', '7', 'English');

select *
from company_user


select count(*),company_id
from
(select user_id,company_id,count(*)
from company_user
where language in ('German','English')
group by user_id,company_id
having count(*)>1)x
group by company_id
having count(*)>1


--------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX------------------------------------------------------------------
-- Write an SQL query to report 

-- product_name in lowercase without leading or trailing white spaces. 
-- sale_date in the format ('YYYY-MM'). 
-- total the number of times the product was sold in this month.
-- Return the result table ordered by product_name in ascending order. 
-- In case of a tie, order it by sale_date in ascending order. 

CREATE TABLE Sales_ (
    sale_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    sale_date DATE
);

INSERT INTO Sales_ (sale_id, product_name, sale_date)
VALUES 
(1, '  LCPHONE', '2000-01-16'),
(2, 'LCPhone', '2000-01-17'),
(3, 'LcPhOnE', '2000-02-18'),
(4, 'LCKeyCHAiN  ', '2000-02-19'),
(5, 'LCKeyChain', '2000-02-28'),
(6, ' Matryoshka', '2000-03-31');


-- product_name in lowercase without leading or trailing white spaces. 
select *,trim(lower(product_name)) Update_product_name
from Sales_

-- sale_date in the format ('YYYY-MM'). 
SELECT *,EXTRACT(YEAR FROM sale_date) AS sale_year,
extract(month from sale_date)
FROM Sales_;

SELECT *,
       TO_CHAR(sale_date, 'YYYY-MM') AS sale_year_month
FROM Sales_;


-- total the number of times the product was sold in this month.

SELECT trim(lower(product_name))product_name,count(*)
FROM Sales_
-- where extract(month from sale_date) = 1
group by trim(lower(product_name));



-- Return the result table ordered by product_name in ascending order. 
SELECT *
FROM Sales_;

SELECT trim(lower(product_name))product_name,count(*)
FROM Sales_
-- where extract(month from sale_date) = 1
group by trim(lower(product_name))
order by product_name desc

-- In case of a tie, order it by sale_date in ascending order. 

SELECT *
FROM Sales_;



--------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX------------------------------------------------------------------
--Q. Write a SQL Query to swap the employeee department

drop table if EXISTS employee_swap;
-- create table employee_swap(id int identity,name varchar(15),department varchar(15));
CREATE TABLE employee_swap (
    id SERIAL PRIMARY KEY,
    name VARCHAR(15),
    department VARCHAR(15)
);


INSERT INTO employee_swap (name, department) VALUES
('John', 'Sales'),
('Tom', 'IT'),
('Rohit', 'IT'),
('Shubham', 'Marketing'),
('Kavya', 'Management'),
('Rohan', 'Sales'),
('Shivani', 'IT');


-- insert into employee_swap values('John','Sales');
-- insert into employee_swap values('Tom','IT');
-- insert into employee_swap values('Rohit','IT');
-- insert into employee_swap values('shubham','Marketing');
-- insert into employee_swap values('kavya','Management');
-- insert into employee_swap values('Rohan','Sales');
-- insert into employee_swap  values('Shivani','IT');

select *,
case when id % 2 = 0 then
lag(department,1,department) over(order by id)
else lead(department,1,department) over(order by id)
end as new_dept
from employee_swap;


--------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX------------------------------------------------------------------

CREATE TABLE EmailDomains (
    Email VARCHAR(255)
    -- ,domain VARCHAR(255)
);

INSERT INTO EmailDomains (Email) VALUES
('user1@gmail.com'),
('user2@yahoo.com'),
('user3@outlook.com'),
('user3@iul.ac.in'); 



select extracted,strpos(extracted,'.'),substring(extracted FROM 1 FOR strpos(extracted,'.')-1)
from
(SELECT substring(email FROM (strpos(email,'@')+1) FOR length(email)) as extracted  -- Returns 'gmail'
from EmailDomains)x

-- INSERT INTO EmailDomains (Email, domain) VALUES
-- ('user1@gmail.com', 'gmail'),
-- ('user2@yahoo.com', 'yahoo'),
-- ('user3@outlook.com', 'outlook'),
-- ('user3@iul.ac.in', 'iul'); 


--------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX------------------------------------------------------------------
--identify employees whose earnings surpass those of their managers.


-- Create the employees table
CREATE TABLE salary (
    employee_id INT PRIMARY KEY,
    name VARCHAR(50),
    salary DECIMAL(10, 2),
    manager_id INT
);

-- Insert values into the employees table
INSERT INTO salary (employee_id, name, salary, manager_id) VALUES
(1, 'John', 60000, 3),
(2, 'Mary', 55000, 3),
(3, 'Alice', 75000, NULL),
(4, 'Bob', 50000, 1),
(5, 'Sarah', 80000, 3),
(6, 'Mike', 58000, 1);


select t1.*,t2.name as manager_name,t2.salary
from salary t1
join salary t2
on t1.manager_id = t2.employee_id and t1.salary > t2.salary



--------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX------------------------------------------------------------------
-- Identifying Employees Currently in the Office

drop table EmployeeTimeData

CREATE TABLE EmployeeTimeData (
    emp_id INT,
    emp_status VARCHAR(3),
    time TIMESTAMP
);

INSERT INTO EmployeeTimeData (emp_id, emp_status, time) VALUES
(1, 'in', '2023-12-22 09:00:00'),
(1, 'out', '2023-12-22 09:15:00'),
(1, 'in', '2023-12-22 09:30:00'),
(1, 'out', '2023-12-22 10:00:00'),
(2, 'in', '2023-12-22 09:05:00'),
(2, 'out', '2023-12-22 09:20:00'),
(2, 'in', '2023-12-22 09:45:00'),
(3, 'in', '2023-12-22 09:00:00'),
(3, 'out', '2023-12-22 09:30:00'),
(3, 'in', '2023-12-22 09:45:00'),
(4, 'in', '2023-12-22 09:00:00'),
(4, 'out', '2023-12-22 09:15:00'),
(5, 'in', '2023-12-22 09:00:00'),
(5, 'out', '2023-12-22 09:30:00'),
(6, 'in', '2023-12-22 09:45:00'),
(7, 'in', '2023-12-22 09:45:00'),
(7, 'out', '2023-12-22 10:00:00');

--------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX------------------------------------------------------------------
--Sum of highest and Second highest marks

create table students(sname varchar(50), sid varchar(50), marks int)

insert into students values('A','X',75),('A','Y',75),('A','Z',80),('B','X',90),('B','Y',91),('B','Z',75)

select distinct sname,
sum(marks) over(partition by sname) as total_mark
from
(select *,
row_number() over(partition by sname order by marks desc) as rnk
from students)x
where rnk <=2


select sname,
sum(marks) 
from
(select *,
row_number() over(partition by sname order by marks desc) as rnk
from students)x
where rnk <=2
group by sname



--------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX------------------------------------------------------------------
-- -- Step 1: Create the CallStartTimes table
-- CREATE TABLE CallStartTimes (
--     Contact VARCHAR(50),
--     StartTime DATETIME
-- );

-- -- Step 2: Create the CallEndTimes table
-- CREATE TABLE CallEndTimes (
--     Contact VARCHAR(50),
--     EndTime DATETIME
-- );

-- -- Step 3: Insert data into the CallStartTimes table
-- INSERT INTO CallStartTimes (Contact, StartTime) VALUES
-- ('contact 1', '2024-05-01 10:20:00'),
-- ('contact 1', '2024-05-01 16:25:00'),
-- ('contact 2', '2024-05-01 12:30:00'),
-- ('contact 3', '2024-05-02 10:00:00'),
-- ('contact 3', '2024-05-02 12:30:00'),
-- ('contact 3', '2024-05-03 09:20:00');

-- -- Step 4: Insert data into the CallEndTimes table
-- INSERT INTO CallEndTimes (Contact, EndTime) VALUES
-- ('contact 1', '2024-05-01 10:45:00'),
-- ('contact 1', '2024-05-01 17:05:00'),
-- ('contact 2', '2024-05-01 12:55:00'),
-- ('contact 3', '2024-05-02 10:20:00'),
-- ('contact 3', '2024-05-02 12:50:00'),
-- ('contact 3', '2024-05-03 09:40:00');




-- Step 1: Create the CallStartTimes table
CREATE TABLE CallStartTimes (
    Contact VARCHAR(50),
    StartTime TIMESTAMP
);

-- Step 2: Create the CallEndTimes table
CREATE TABLE CallEndTimes (
    Contact VARCHAR(50),
    EndTime TIMESTAMP
);

-- Step 3: Insert data into the CallStartTimes table
INSERT INTO CallStartTimes (Contact, StartTime) VALUES
('contact 1', '2024-05-01 10:20:00'),
('contact 1', '2024-05-01 16:25:00'),
('contact 2', '2024-05-01 12:30:00'),
('contact 3', '2024-05-02 10:00:00'),
('contact 3', '2024-05-02 12:30:00'),
('contact 3', '2024-05-03 09:20:00');

-- Step 4: Insert data into the CallEndTimes table
INSERT INTO CallEndTimes (Contact, EndTime) VALUES
('contact 1', '2024-05-01 10:45:00'),
('contact 1', '2024-05-01 17:05:00'),
('contact 2', '2024-05-01 12:55:00'),
('contact 3', '2024-05-02 10:20:00'),
('contact 3', '2024-05-02 12:50:00'),
('contact 3', '2024-05-03 09:40:00');

SELECT *
FROM CallStartTimes 


SELECT *
FROM CallEndTimes




--------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX------------------------------------------------------------------
DROP TABLE IF EXISTS years_sum;

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


SELECT *
from years_sum




--------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX------------------------------------------------------------------
DROP TABLE IF EXISTS sales_data;
CREATE TABLE sales_data (
    sales_date DATE,
    brand VARCHAR(10),
    model VARCHAR(10),
    sales INT
);

INSERT INTO sales_data VALUES ('2023-12-01', 'A', 'A1', 1000);
INSERT INTO sales_data VALUES ('2023-12-01', 'A', 'A2', 1300);
INSERT INTO sales_data VALUES ('2023-12-01', 'B', 'B1', 800);
INSERT INTO sales_data VALUES ('2023-12-02', 'A', 'A1', 1800);
INSERT INTO sales_data VALUES ('2023-12-02', 'B', 'B1', 900);
INSERT INTO sales_data VALUES ('2023-12-10', 'B', 'B1', 1400);
INSERT INTO sales_data VALUES ('2023-12-10', 'B', 'B2', 1200);


SELECT *,
sum(sales) over(partition by brand,sales_date order by sales_date)
FROM sales_data

--------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX------------------------------------------------------------------
-- Find states where the average sales exceed the overall country average

DROP TABLE IF EXISTS city_data;

CREATE TABLE city_data (
    State VARCHAR(50),
    City VARCHAR(50),
    Address VARCHAR(50),
    Sales INT
);

INSERT INTO city_data VALUES ('Delhi', 'Delhi', 'Ashok Nagar', 18800);
INSERT INTO city_data VALUES ('Delhi', 'Delhi', 'Inner circle CP', 25000);
INSERT INTO city_data VALUES ('Delhi', 'Delhi', 'Sarojni Nagar', 15800);
INSERT INTO city_data VALUES ('Maharastra', 'Pune', 'Hanjiwada', 12000);
INSERT INTO city_data VALUES ('Maharastra', 'Pune', 'Shivaji Nagar', 15000);
INSERT INTO city_data VALUES ('Maharastra', 'Mumbai', 'Bandra', 40000);
INSERT INTO city_data VALUES ('Maharastra', 'Mumbai', 'GT Road', 28000);
INSERT INTO city_data VALUES ('Maharastra', 'Mumbai', '58 Gates Street', 45000);
INSERT INTO city_data VALUES ('Maharastra', 'Mumbai', 'Norcross', 55000);
INSERT INTO city_data VALUES ('Maharastra', 'Mumbai', '337 Shore Ave', 35000);
INSERT INTO city_data VALUES ('Haryana', 'Gurgaon', '84 Central Street', 39000);
INSERT INTO city_data VALUES ('Haryana', 'Gurgaon', 'Passaic', 28000);
INSERT INTO city_data VALUES ('Uttar Pradesh', 'Lucknow', '952 Fulton Road', 14000);
INSERT INTO city_data VALUES ('Punjab', 'Chandigarh', 'Lewis', 11000);
INSERT INTO city_data VALUES ('Rajasthan', 'Jaipur', 'Atwater', 9000);


SELECT state,round(avg(sales),2) as avg_sales,(SELECT round(avg(sales),2) FROM city_data) as country_avg_sale
FROM city_data
group by state 
having round(avg(sales),2) >
(SELECT round(avg(sales),2) as avg_sales
FROM city_data)

------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX------------------------------------------------------------------
-- Find Max Unique id

drop table if exists employees;

create table employees (id int)

insert into employees values (2),(5),(6),(6),(7),(8),(8);

select * from employees;


Select max(id)id
from
(select id, count(*) 
from employees
group by id
having count(*) = 1)x


--------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX--------------------------------------------------------------------------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX--------------------------------------------------------------------------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX--------------------------------------------------------------------------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX--------------------------------------------------------------------------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX--------------------------------------------------------------------------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX--------------------------------------------------------------------------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX--------------------------------------------------------------------------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX--------------------------------------------------------------------------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX--------------------------------------------------------------------------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX--------------------------------------------------------------------------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX--------------------------------------------------------------------------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX--------------------------------------------------------------------------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX--------------------------------------------------------------------------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX--------------------------------------------------------------------------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX--------------------------------------------------------------------------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX--------------------------------------------------------------------------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX--------------------------------------------------------------------------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX--------------------------------------------------------------------------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXX------------------------------------------------------------------
DROP TABLE IF EXISTS Products;

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    Product VARCHAR(255),
    Category VARCHAR(100)
);

INSERT INTO Products (ProductID, Product, Category)
VALUES
    (1, 'Laptop', 'Electronics'),
    (2, 'Smartphone', 'Electronics'),
    (3, 'Tablet', 'Electronics'),
    (4, 'Headphones', 'Accessories'),
    (5, 'Smartwatch', 'Accessories'),
    (6, 'Keyboard', 'Accessories'),
    (7, 'Mouse', 'Accessories'),
    (8, 'Monitor', 'Accessories'),
    (9, 'Printer', 'Electronics');



