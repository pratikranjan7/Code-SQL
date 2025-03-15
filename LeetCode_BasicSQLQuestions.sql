-- Write an SQL query to report the first name, last name, city, and state of each person in the person table. If the address of a
-- personld is not present in the Address table, report null instead

Create table If Not Exists Person (personId int, firstName varchar(255), lastName varchar(255))
Create table If Not Exists Address (addressId int, personId int, city varchar(255), state varchar(255))
-- Truncate table Person
insert into Person (personId, lastName, firstName) values ('1', 'Wang', 'Allen');
insert into Person (personId, lastName, firstName) values ('2', 'Alice', 'Bob');
-- Truncate table Address
insert into Address (addressId, personId, city, state) values ('1', '2', 'New York City', 'New York');
insert into Address (addressId, personId, city, state) values ('2', '3', 'Leetcode', 'California');


select *
from Address

select t1.firstname,t1.lastname,t2.city,t2.state
from Person t1
left join Address t2
on t1.personid = t2.personid

----------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------

-- Employees Earning More Than Their Managers

Create table If Not Exists Employee (id int, name varchar(255), salary int, managerId int)
Truncate table Employee
insert into Employee (id, name, salary, managerId) values ('1', 'Joe', '70000', '3');
insert into Employee (id, name, salary, managerId) values ('2', 'Henry', '80000', '4');
insert into Employee (id, name, salary, managerId) values ('3', 'Sam', '60000', NULL);
insert into Employee (id, name, salary, managerId) values ('4', 'Max', '90000', NULL);

select t1.name
from employee t1
join employee t2
on t1.managerid = t2.id and t1.salary > t2.salary

----------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------

-- Duplicate Email
Create table If Not Exists Person (id int, email varchar(255))
drop table Person
insert into Person (id, email) values ('1', 'a@b.com');
insert into Person (id, email) values ('2', 'c@d.com');
insert into Person (id, email) values ('3', 'a@b.com');

select email
from person
group by email
having count(*) > 1

----------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------

--Customer who never order
Create table If Not Exists Customers (id int, name varchar(255))
Create table If Not Exists Orders (id int, customerId int)
Truncate table Customers
insert into Customers (id, name) values ('1', 'Joe');
insert into Customers (id, name) values ('2', 'Henry');
insert into Customers (id, name) values ('3', 'Sam');
insert into Customers (id, name) values ('4', 'Max');



Truncate table Orders
insert into Orders (id, customerId) values ('1', '3');
insert into Orders (id, customerId) values ('2', '1');

select c.*
from customers c
where id not in
(select c.id
from customers c
join orders o
on c.id = o.customerid)

select *
from orders

----------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------

-- Employee Bonus
-- where bonus recieved is less than 1000

drop table employee
Create table If Not Exists Employee (empId int, name varchar(255), supervisor int, salary int)
Create table If Not Exists Bonus (empId int, bonus int)
Truncate table Employee
insert into Employee (empId, name, supervisor, salary) values ('3', 'Brad', NULL, '4000');
insert into Employee (empId, name, supervisor, salary) values ('1', 'John', '3', '1000');
insert into Employee (empId, name, supervisor, salary) values ('2', 'Dan', '3', '2000');
insert into Employee (empId, name, supervisor, salary) values ('4', 'Thomas', '3', '4000');
Truncate table Bonus
insert into Bonus (empId, bonus) values ('2', '500');
insert into Bonus (empId, bonus) values ('4', '2000');

select e.name,b.bonus
from employee e
left join 
bonus b
on e.empid = b.empid --and  b.bonus < 1000 or b.bonus is null
where b.bonus < 1000 or b.bonus is null
order by b.bonus desc

----------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------

-- Find Customer Referee
-- which are not refereed by id 2


Create table If Not Exists Customer (id int, name varchar(25), referee_id int)
Truncate table Customer
insert into Customer (id, name, referee_id) values ('1', 'Will', NULL);
insert into Customer (id, name, referee_id) values ('2', 'Jane', NULL);
insert into Customer (id, name, referee_id) values ('3', 'Alex', '2');
insert into Customer (id, name, referee_id) values ('4', 'Bill', NULL);
insert into Customer (id, name, referee_id) values ('5', 'Zack', '1');
insert into Customer (id, name, referee_id) values ('6', 'Mark', '2');


select name
from customer
where referee_id is null or referee_id <> 2


----------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------

-- Customer Placing the Largest Number of Orders
-- top 1 customer with Largest Number of Orders

drop table orders
Create table If Not Exists orders (order_number int, customer_number int)
Truncate table orders
insert into orders (order_number, customer_number) values ('1', '1');
insert into orders (order_number, customer_number) values ('2', '2');
insert into orders (order_number, customer_number) values ('3', '3');
insert into orders (order_number, customer_number) values ('4', '3');


select customer_number
from orders
group by customer_number
having count(*) > 1
order by count(*) desc
limit 1

----------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------

-- Big Countries

-- A country is big if:
-- • it has an area of at least three million (i.e., 3000000 km2), or
-- • it has a population of at least twenty-five million (i.e.,
-- Write a solution to find the name, population, and area of the big countries.
-- Return the result table in any order.


Create table If Not Exists World (name varchar(255), continent varchar(255), area int, population int, gdp bigint)
Truncate table World
insert into World (name, continent, area, population, gdp) values ('Afghanistan', 'Asia', '652230', '25500100', '20343000000');
insert into World (name, continent, area, population, gdp) values ('Albania', 'Europe', '28748', '2831741', '12960000000');
insert into World (name, continent, area, population, gdp) values ('Algeria', 'Africa', '2381741', '37100000', '188681000000');
insert into World (name, continent, area, population, gdp) values ('Andorra', 'Europe', '468', '78115', '3712000000');
insert into World (name, continent, area, population, gdp) values ('Angola', 'Africa', '1246700', '20609294', '100990000000');

select name,population,area
from world
where area >= 3000000 or population >= 25000000

----------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------

-- Classes More Than 5 Students
-- Write a solution to find all the classes that have at least five students.
-- Return the result table in any order.


Create table If Not Exists Courses (student varchar(255), class varchar(255))
Truncate table Courses
insert into Courses (student, class) values ('A', 'Math');
insert into Courses (student, class) values ('B', 'English');
insert into Courses (student, class) values ('C', 'Math');
insert into Courses (student, class) values ('D', 'Biology');
insert into Courses (student, class) values ('E', 'Math');
insert into Courses (student, class) values ('F', 'Computer');
insert into Courses (student, class) values ('G', 'Math');
insert into Courses (student, class) values ('H', 'Math');
insert into Courses (student, class) values ('I', 'Math');


select class
from courses
group by class
having count(*) >= 5

----------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------


-- Triangle Judgement
-- Sum of 2 sides is greater than 3rd side
Create table If Not Exists Triangle (x int, y int, z int)
Truncate table Triangle
insert into Triangle (x, y, z) values ('13', '15', '30');
insert into Triangle (x, y, z) values ('10', '20', '15');

select *,
case when (x+y)>z and (y+z)>x and (x+z)>y then 'Yes'
else 'No'
end as triangle
from triangle

----------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------


-- Biggest Single Number
-- A single number is a number that appeared only once in the MyNumbers table.
-- Find the largest single number. If there is no single number, report null
Create table If Not Exists MyNumbers (num int)
Truncate table MyNumbers
insert into MyNumbers (num) values ('8');
insert into MyNumbers (num) values ('8');
insert into MyNumbers (num) values ('3');
insert into MyNumbers (num) values ('3');
insert into MyNumbers (num) values ('1');
insert into MyNumbers (num) values ('4');
insert into MyNumbers (num) values ('5');
insert into MyNumbers (num) values ('6');

select max(num) as num
from(select num,count(*)
from mynumbers
group by num
having count(*)= 1)x

----------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------

-- Not Boring Movies
-- Write a solution to report the movies with an odd-numbered ID and a description that is not "boring" .
-- Return the result table ordered by rating
-- in descending order.

CREATE TABLE IF NOT EXISTS cinema (
    id INT,
    movie VARCHAR(255),
    description VARCHAR(255),
    rating REAL
);

-- Create table If Not Exists cinema (id int, movie varchar(255), description varchar(255), rating float(2, 1))
Truncate table cinema
insert into cinema (id, movie, description, rating) values ('1', 'War', 'great 3D', '8.9');
insert into cinema (id, movie, description, rating) values ('2', 'Science', 'fiction', '8.5');
insert into cinema (id, movie, description, rating) values ('3', 'irish', 'boring', '6.2');
insert into cinema (id, movie, description, rating) values ('4', 'Ice song', 'Fantacy', '8.6');
insert into cinema (id, movie, description, rating) values ('5', 'House card', 'Interesting', '9.1');


select *
from cinema
where description <> 'boring' and id%2<>0
order by rating desc


----------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------

--Swap Salary
-- Write a solution to swap all 'f' and 'm' values (i.e., change all 'f' values to 'm' and vice versa)


Create table If Not Exists Salary (id int, name varchar(100), sex char(1), salary int)
Truncate table Salary
insert into Salary (id, name, sex, salary) values ('1', 'A', 'm', '2500');
insert into Salary (id, name, sex, salary) values ('2', 'B', 'f', '1500');
insert into Salary (id, name, sex, salary) values ('3', 'C', 'm', '5500');
insert into Salary (id, name, sex, salary) values ('4', 'D', 'f', '500');

-- UPDATE Salary
-- SET sex = CASE WHEN sex = ' '
-- f THEN 'm'
-- WHEN Sex = THEN 'f' end



select id,name,
case when sex = 'm' then 'f'
when sex = 'f' then 'm'
end as sex,salary
from salary

----------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------

-- Write a solution to find all the pairs (actor_id, directo r_id) where the actor has cooperated with the director
-- at least three times.
-- Return the result table in any order.

Create table If Not Exists ActorDirector (actor_id int, director_id int, timestamp int)
Truncate table ActorDirector
insert into ActorDirector (actor_id, director_id, timestamp) values ('1', '1', '0');
insert into ActorDirector (actor_id, director_id, timestamp) values ('1', '1', '1');
insert into ActorDirector (actor_id, director_id, timestamp) values ('1', '1', '2');
insert into ActorDirector (actor_id, director_id, timestamp) values ('1', '2', '3');
insert into ActorDirector (actor_id, director_id, timestamp) values ('1', '2', '4');
insert into ActorDirector (actor_id, director_id, timestamp) values ('2', '1', '5');
insert into ActorDirector (actor_id, director_id, timestamp) values ('2', '1', '6');


select actor_id,director_id,count(timestamp)
from actordirector
group by actor_id,director_id
having  count(timestamp) >= 3

----------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------

-- Queries Quality and Percentage

-- We define query quality as:
-- The average of the ratio between query rating and its position.
-- We also define poor query percentage as:
-- The percentage of all queries with rating less than 3.
-- Write a solution to find each query_name, the quality and
-- Both quality and should be rounded to 2 decimal places.

Create table If Not Exists Queries (query_name varchar(30), result varchar(50), position int, rating int)
Truncate table Queries
insert into Queries (query_name, result, position, rating) values ('Dog', 'Golden Retriever', '1', '5')
insert into Queries (query_name, result, position, rating) values ('Dog', 'German Shepherd', '2', '5')
insert into Queries (query_name, result, position, rating) values ('Dog', 'Mule', '200', '1')
insert into Queries (query_name, result, position, rating) values ('Cat', 'Shirazi', '5', '2')
insert into Queries (query_name, result, position, rating) values ('Cat', 'Siamese', '3', '3')
insert into Queries (query_name, result, position, rating) values ('Cat', 'Sphynx', '7', '4')

----------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------


-- Write a solution to find the average selling price for each product. average_price should be rounded to 2
-- decimal places. If a product does not have any sold units, its average selling price is assumed to be 0.
-- Return the result table in any order.

Create table If Not Exists Prices (product_id int, start_date date, end_date date, price int)
Create table If Not Exists UnitsSold (product_id int, purchase_date date, units int)
Truncate table Prices
insert into Prices (product_id, start_date, end_date, price) values ('1', '2019-02-17', '2019-02-28', '5')
insert into Prices (product_id, start_date, end_date, price) values ('1', '2019-03-01', '2019-03-22', '20')
insert into Prices (product_id, start_date, end_date, price) values ('2', '2019-02-01', '2019-02-20', '15')
insert into Prices (product_id, start_date, end_date, price) values ('2', '2019-02-21', '2019-03-31', '30')
Truncate table UnitsSold
insert into UnitsSold (product_id, purchase_date, units) values ('1', '2019-02-25', '100')
insert into UnitsSold (product_id, purchase_date, units) values ('1', '2019-03-01', '15')
insert into UnitsSold (product_id, purchase_date, units) values ('2', '2019-02-10', '200')
insert into UnitsSold (product_id, purchase_date, units) values ('2', '2019-03-22', '30')


----------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------
-- Write a solution to report the IDs of all the employees with missing information. The information of an employee
-- is missing if:
-- The employee's name is missing, or
-- The employee's salary is missing.
-- Return the result table ordered by employee_id
-- in ascending order.
-- The result format is in the following example.


--Through union

drop table employees
drop table Salaries

Create table If Not Exists Employees (employee_id int, name varchar(30));
Create table If Not Exists Salaries (employee_id int, salary int);
Truncate table Employees
insert into Employees (employee_id, name) values ('2', 'Crew');
insert into Employees (employee_id, name) values ('4', 'Haven');
insert into Employees (employee_id, name) values ('5', 'Kristian');
Truncate table Salaries
insert into Salaries (employee_id, salary) values ('5', '76071');
insert into Salaries (employee_id, salary) values ('1', '22517');
insert into Salaries (employee_id, salary) values ('4', '63539');


select *
from employees

select *
from salaries


select employee_id
from
(select
case when e.employee_id is not null then e.employee_id
else s.employee_id
end as employee_id
,e.name,s.salary 
from employees e
full join salaries s
on e.employee_id = s.employee_id)x
where name is null or salary is null


----------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------
-- Write a solution to report the latest login for all users in the year 2020. Do not include the users who did not
-- login in 2020'
-- Return the result table in any order.

Create table If Not Exists Logins (user_id int, time_stamp timestamp)
Truncate table Logins
insert into Logins (user_id, time_stamp) values ('6', '2020-06-30 15:06:07');
insert into Logins (user_id, time_stamp) values ('6', '2021-04-21 14:06:06');
insert into Logins (user_id, time_stamp) values ('6', '2019-03-07 00:18:15');
insert into Logins (user_id, time_stamp) values ('8', '2020-02-01 05:10:53');
insert into Logins (user_id, time_stamp) values ('8', '2020-12-30 00:46:50');
insert into Logins (user_id, time_stamp) values ('2', '2020-01-16 02:49:50');
insert into Logins (user_id, time_stamp) values ('2', '2019-08-25 07:59:08');
insert into Logins (user_id, time_stamp) values ('14', '2019-07-14 09:00:00');
insert into Logins (user_id, time_stamp) values ('14', '2021-01-06 11:59:59');



select user_id,max(time_stamp) as last_stamp
-- dense_rank() over(partition by user_id order by time_stamp desc)
from logins
where  
extract (year from time_stamp) = 2020
group by user_id


----------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------
-- Write a solution to calculate the bonus of each employee. The bonus of an employee is 100% of their salary if the
-- ID of the employee is an odd number and the employee's name does not start with the character
-- 'M' . The
-- bonus of an employee is otherwise.
-- Return the result table ordered by employee_id.


drop table employees;
Create table If Not Exists Employees (employee_id int, name varchar(30), salary int)
Truncate table Employees
insert into Employees (employee_id, name, salary) values ('2', 'Meir', '3000');
insert into Employees (employee_id, name, salary) values ('3', 'Michael', '3800');
insert into Employees (employee_id, name, salary) values ('7', 'Addilyn', '7400');
insert into Employees (employee_id, name, salary) values ('8', 'Juan', '6100');
insert into Employees (employee_id, name, salary) values ('9', 'Kannon', '7700');


select employee_id,
case when employee_id % 2 = 0 or name ~ '^[Mm]' then 0 else salary
end as bonus
from employees
order by employee_id


----------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------
-- Products with low_fats and is recyclable

CREATE TABLE IF NOT EXISTS Products (
    product_id INT,
    low_fats CHAR(1) CHECK (low_fats IN ('Y', 'N')),
    recyclable CHAR(1) CHECK (recyclable IN ('Y', 'N'))
);
-- Create table If Not Exists Products (product_id int, low_fats ENUM('Y', 'N'), recyclable ENUM('Y','N'))
Truncate table Products
insert into Products (product_id, low_fats, recyclable) values ('0', 'Y', 'N');
insert into Products (product_id, low_fats, recyclable) values ('1', 'Y', 'Y');
insert into Products (product_id, low_fats, recyclable) values ('2', 'N', 'Y');
insert into Products (product_id, low_fats, recyclable) values ('3', 'Y', 'Y');
insert into Products (product_id, low_fats, recyclable) values ('4', 'N', 'N');


select product_id
from products
where low_fats = 'Y' and recyclable = 'Y'


----------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------
-- Write a solution to calculate the total time in minutes spent by each employee on each day at the office. Note
-- that within one day, an employee can enter and leave more than once. The time spent in the office for a single
-- entry is out_time — in _ time .
-- Return the result table in any order.

drop table employees

Create table If Not Exists Employees(emp_id int, event_day date, in_time int, out_time int)
Truncate table Employees
insert into Employees (emp_id, event_day, in_time, out_time) values ('1', '2020-11-28', '4', '32');
insert into Employees (emp_id, event_day, in_time, out_time) values ('1', '2020-11-28', '55', '200');
insert into Employees (emp_id, event_day, in_time, out_time) values ('1', '2020-12-3', '1', '42');
insert into Employees (emp_id, event_day, in_time, out_time) values ('2', '2020-11-28', '3', '33');
insert into Employees (emp_id, event_day, in_time, out_time) values ('2', '2020-12-9', '47', '74');

select event_day as day,emp_id,sum(sum) as total_time
from
(select *,(out_time - in_time) as sum
from employees)x
group by event_day,emp_id


----------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------
-- Write a solution to find the number of times each student attended each exam.

-- Return the result table ordered by student_id and subject_name.

drop table students
drop table Subjects
drop table Examinations


Create table If Not Exists Students (student_id int, student_name varchar(20));
Create table If Not Exists Subjects (subject_name varchar(20));
Create table If Not Exists Examinations (student_id int, subject_name varchar(20));
Truncate table Students
insert into Students (student_id, student_name) values ('1', 'Alice');
insert into Students (student_id, student_name) values ('2', 'Bob');
insert into Students (student_id, student_name) values ('13', 'John');
insert into Students (student_id, student_name) values ('6', 'Alex');
Truncate table Subjects
insert into Subjects (subject_name) values ('Math');
insert into Subjects (subject_name) values ('Physics');
insert into Subjects (subject_name) values ('Programming');
Truncate table Examinations
insert into Examinations (student_id, subject_name) values ('1', 'Math');
insert into Examinations (student_id, subject_name) values ('1', 'Physics');
insert into Examinations (student_id, subject_name) values ('1', 'Programming');
insert into Examinations (student_id, subject_name) values ('2', 'Programming');
insert into Examinations (student_id, subject_name) values ('1', 'Physics');
insert into Examinations (student_id, subject_name) values ('1', 'Math');
insert into Examinations (student_id, subject_name) values ('13', 'Math');
insert into Examinations (student_id, subject_name) values ('13', 'Programming');
insert into Examinations (student_id, subject_name) values ('13', 'Physics');
insert into Examinations (student_id, subject_name) values ('2', 'Math');
insert into Examinations (student_id, subject_name) values ('1', 'Math');



select *
from students

select *
from Subjects

select *
from Examinations e

select  s.student_id,s.student_name,sub.subject_name
,count(e.student_id)attended_exams
from students s
cross join Subjects sub
left join Examinations e
on s.student_id = e.student_id and sub.subject_name = e.subject_name
group by s.student_id,s.student_name,sub.subject_name
order by s.student_id,sub.subject_name


----------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------
-- Write a solution to show the unique ID of each user, If a user does not have a unique ID replace just show null.

-- Return the result table in any order.

drop table Employees;
drop table EmployeeUNI;

Create table If Not Exists Employees (id int, name varchar(20));
Create table If Not Exists EmployeeUNI (id int, unique_id int);
Truncate table Employees
insert into Employees (id, name) values ('1', 'Alice');
insert into Employees (id, name) values ('7', 'Bob');
insert into Employees (id, name) values ('11', 'Meir');
insert into Employees (id, name) values ('90', 'Winston');
insert into Employees (id, name) values ('3', 'Jonathan');
Truncate table EmployeeUNI
insert into EmployeeUNI (id, unique_id) values ('3', '1');
insert into EmployeeUNI (id, unique_id) values ('11', '2');
insert into EmployeeUNI (id, unique_id) values ('90', '3');

select t2.unique_id,t1.name
from Employees t1
left join 
EmployeeUNI t2
on t1.id = t2.id
order by t2.unique_id

----------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------


-- Write a solution to report the distance traveled by each user.

-- Return the result table ordered by travelled_distance in descending order, if two or more users traveled the same distance, order them by their name in ascending order.

drop table users;
drop table rides;

Create Table If Not Exists Users (id int, name varchar(30));
Create Table If Not Exists Rides (id int, user_id int, distance int);
Truncate table Users
insert into Users (id, name) values ('1', 'Alice');
insert into Users (id, name) values ('2', 'Bob');
insert into Users (id, name) values ('3', 'Alex');
insert into Users (id, name) values ('4', 'Donald');
insert into Users (id, name) values ('7', 'Lee');
insert into Users (id, name) values ('13', 'Jonathan');
insert into Users (id, name) values ('19', 'Elvis');
Truncate table Rides
insert into Rides (id, user_id, distance) values ('1', '1', '120');
insert into Rides (id, user_id, distance) values ('2', '2', '317');
insert into Rides (id, user_id, distance) values ('3', '3', '222');
insert into Rides (id, user_id, distance) values ('4', '7', '100');
insert into Rides (id, user_id, distance) values ('5', '13', '312');
insert into Rides (id, user_id, distance) values ('6', '19', '50');
insert into Rides (id, user_id, distance) values ('7', '7', '120');
insert into Rides (id, user_id, distance) values ('8', '19', '400');
insert into Rides (id, user_id, distance) values ('9', '7', '230');

select name,
case when travelled_distance is null then 0 else travelled_distance
end as travelled_distance
from(select u.name,u.id,sum(r.distance) as travelled_distance
from users u
left join rides r
on u.id = r.user_id
group by u.name,u.id)x
order by travelled_distance desc,name

----------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------
-- Write a solution to find for each date the number of different products sold and their names.

-- The sold products names for each date should be sorted lexicographically.

-- Return the result table ordered by sell_date.



Create table If Not Exists Activities (sell_date date, product varchar(20));
Truncate table Activities
insert into Activities (sell_date, product) values ('2020-05-30', 'Headphone');
insert into Activities (sell_date, product) values ('2020-06-01', 'Pencil');
insert into Activities (sell_date, product) values ('2020-06-02', 'Mask');
insert into Activities (sell_date, product) values ('2020-05-30', 'Basketball');
insert into Activities (sell_date, product) values ('2020-06-01', 'Bible');
insert into Activities (sell_date, product) values ('2020-06-02', 'Mask');
insert into Activities (sell_date, product) values ('2020-05-30', 'T-Shirt');

SELECT sell_date,COUNT(DISTINCT product) AS num_sold,STRING_AGG(DISTINCT product, ',' ORDER BY product) AS product_list
FROM activities
GROUP BY sell_date
ORDER BY sell_date;

----------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------
-- Write a solution to find the IDs of the users who visited without making any transactions and the number of times they made these types of visits.

-- Return the result table sorted in any order.


Create table If Not Exists Visits(visit_id int, customer_id int);
Create table If Not Exists Transactions(transaction_id int, visit_id int, amount int);
Truncate table Visits;
insert into Visits (visit_id, customer_id) values ('1', '23');
insert into Visits (visit_id, customer_id) values ('2', '9');
insert into Visits (visit_id, customer_id) values ('4', '30');
insert into Visits (visit_id, customer_id) values ('5', '54');
insert into Visits (visit_id, customer_id) values ('6', '96');
insert into Visits (visit_id, customer_id) values ('7', '54');
insert into Visits (visit_id, customer_id) values ('8', '54');
Truncate table Transactions
insert into Transactions (transaction_id, visit_id, amount) values ('2', '5', '310');
insert into Transactions (transaction_id, visit_id, amount) values ('3', '5', '300');
insert into Transactions (transaction_id, visit_id, amount) values ('9', '5', '200');
insert into Transactions (transaction_id, visit_id, amount) values ('12', '1', '910');
insert into Transactions (transaction_id, visit_id, amount) values ('13', '2', '970');

select *
from Visits

select *
from Transactions

select t2.customer_id,count(1)
from Transactions t1
right  join Visits t2
on t1.visit_id = t2.visit_id 
where t1.visit_id is null
group by t2.customer_id
order by t2.customer_id
----------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------
-- Write a solution to report the name and balance of users with a balance higher than 10000. The balance of an account is equal to the sum of the amounts of all transactions involving that account.


drop table users;
drop table transactions;

Create table If Not Exists Users (account int, name varchar(20));
Create table If Not Exists Transactions (trans_id int, account int, amount int, transacted_on date);
Truncate table Users
insert into Users (account, name) values ('900001', 'Alice');
insert into Users (account, name) values ('900002', 'Bob');
insert into Users (account, name) values ('900003', 'Charlie');
Truncate table Transactions
insert into Transactions (trans_id, account, amount, transacted_on) values ('1', '900001', '7000', '2020-08-01');
insert into Transactions (trans_id, account, amount, transacted_on) values ('2', '900001', '7000', '2020-09-01');
insert into Transactions (trans_id, account, amount, transacted_on) values ('3', '900001', '-3000', '2020-09-02');
insert into Transactions (trans_id, account, amount, transacted_on) values ('4', '900002', '1000', '2020-09-12');
insert into Transactions (trans_id, account, amount, transacted_on) values ('5', '900003', '6000', '2020-08-07');
insert into Transactions (trans_id, account, amount, transacted_on) values ('6', '900003', '6000', '2020-09-07');
insert into Transactions (trans_id, account, amount, transacted_on) values ('7', '900003', '-4000', '2020-09-11');


select *
from Users


select t2.name,sum(t1.amount)balance
from Transactions t1
join Users t2
on t2.account = t1.account
group by t2.name
having sum(t1.amount) > 10000

----------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------

-- Write a solution to find the IDs of the invalid tweets. The tweet is invalid if the number of characters used in the content of the tweet is strictly greater than 15.



Create table If Not Exists Tweets(tweet_id int, content varchar(50));
Truncate table Tweets
insert into Tweets (tweet_id, content) values ('1', 'Let us Code');
insert into Tweets (tweet_id, content) values ('2', 'More than fifteen chars are here!');


select tweet_id--,*,length(content) length
from tweets
where length(content) > 15



-- For each date id and make name, find the number of distinct
-- lead id 's and distinct
-- partner_id 'S.
-- Return the result table in any order.

----------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------
-- For each date_id and make_name, find the number of distinct lead_id's and distinct partner_id's.

-- Return the result table in any order.

Create table If Not Exists DailySales(date_id date, make_name varchar(20), lead_id int, partner_id int)
Truncate table DailySales
insert into DailySales (date_id, make_name, lead_id, partner_id) values ('2020-12-8', 'toyota', '0', '1');
insert into DailySales (date_id, make_name, lead_id, partner_id) values ('2020-12-8', 'toyota', '1', '0');
insert into DailySales (date_id, make_name, lead_id, partner_id) values ('2020-12-8', 'toyota', '1', '2');
insert into DailySales (date_id, make_name, lead_id, partner_id) values ('2020-12-7', 'toyota', '0', '2');
insert into DailySales (date_id, make_name, lead_id, partner_id) values ('2020-12-7', 'toyota', '0', '1');
insert into DailySales (date_id, make_name, lead_id, partner_id) values ('2020-12-8', 'honda', '1', '2');
insert into DailySales (date_id, make_name, lead_id, partner_id) values ('2020-12-8', 'honda', '2', '1');
insert into DailySales (date_id, make_name, lead_id, partner_id) values ('2020-12-7', 'honda', '0', '1');
insert into DailySales (date_id, make_name, lead_id, partner_id) values ('2020-12-7', 'honda', '1', '2');
insert into DailySales (date_id, make_name, lead_id, partner_id) values ('2020-12-7', 'honda', '2', '1');

select date_id,make_name,count(distinct lead_id)unique_leads,count(distinct partner_id)unique_partners 
from DailySales
group by date_id,make_name


----------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------
-- Write a solution to calculate the total time in minutes spent by each employee on each day at the office. Note that within one day, an employee can enter and leave more than once. The time spent in the office for a single entry is out_time - in_time.

drop table employees;

Create table If Not Exists Employees(emp_id int, event_day date, in_time int, out_time int);
Truncate table Employees
insert into Employees (emp_id, event_day, in_time, out_time) values ('1', '2020-11-28', '4', '32');
insert into Employees (emp_id, event_day, in_time, out_time) values ('1', '2020-11-28', '55', '200');
insert into Employees (emp_id, event_day, in_time, out_time) values ('1', '2020-12-3', '1', '42');
insert into Employees (emp_id, event_day, in_time, out_time) values ('2', '2020-11-28', '3', '33');
insert into Employees (emp_id, event_day, in_time, out_time) values ('2', '2020-12-9', '47', '74');


select event_day as day,emp_id,sum(out_time - in_time) as total_time 
from employees
group by emp_id,event_day;
