-- find player with no of gold medals won by them only for players who won only gold medals.
-- script:


CREATE TABLE events (
ID int,
event varchar(255),
YEAR INt,
GOLD varchar(255),
SILVER varchar(255),
BRONZE varchar(255)
);

delete from events;

INSERT INTO events VALUES (1,'100m',2016, 'Amthhew Mcgarray','donald','barbara');
INSERT INTO events VALUES (2,'200m',2016, 'Nichole','Alvaro Eaton','janet Smith');
INSERT INTO events VALUES (3,'500m',2016, 'Charles','Nichole','Susana');
INSERT INTO events VALUES (4,'100m',2016, 'Ronald','maria','paula');
INSERT INTO events VALUES (5,'200m',2016, 'Alfred','carol','Steven');
INSERT INTO events VALUES (6,'500m',2016, 'Nichole','Alfred','Brandon');
INSERT INTO events VALUES (7,'100m',2016, 'Charles','Dennis','Susana');
INSERT INTO events VALUES (8,'200m',2016, 'Thomas','Dawn','catherine');
INSERT INTO events VALUES (9,'500m',2016, 'Thomas','Dennis','paula');
INSERT INTO events VALUES (10,'100m',2016, 'Charles','Dennis','Susana');
INSERT INTO events VALUES (11,'200m',2016, 'jessica','Donald','Stefeney');
INSERT INTO events VALUES (12,'500m',2016,'Thomas','Steven','Catherine');


select gold as player_name,count(1)
from events
where gold not in
(select silver
from events
union all
select bronze
from events)
group by gold
)

------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------


 -- find difference between 2 dates excluding weekends and public holidays  . Basically we need to find business days between 2 given dates using SQL. 

-- script:
create table tickets
(
ticket_id varchar(10),
create_date date,
resolved_date date
);
delete from tickets;
insert into tickets values
(1,'2022-08-01','2022-08-03')
,(2,'2022-08-01','2022-08-12')
,(3,'2022-08-01','2022-08-16');
create table holidays
(
holiday_date date
,reason varchar(100)
);
delete from holidays;
insert into holidays values
('2022-08-11','Rakhi'),('2022-08-15','Independence day');

------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------


-- Find number of employees inside the hospital. I will solve this problem with 3 methods:
-- script:

create table hospital ( emp_id int
, action varchar(10)
, time timestamp);

insert into hospital values ('1', 'in', '2019-12-22 09:00:00');
insert into hospital values ('1', 'out', '2019-12-22 09:15:00');
insert into hospital values ('2', 'in', '2019-12-22 09:00:00');
insert into hospital values ('2', 'out', '2019-12-22 09:15:00');
insert into hospital values ('2', 'in', '2019-12-22 09:30:00');
insert into hospital values ('3', 'out', '2019-12-22 09:00:00');
insert into hospital values ('3', 'in', '2019-12-22 09:15:00');
insert into hospital values ('3', 'out', '2019-12-22 09:30:00');
insert into hospital values ('3', 'in', '2019-12-22 09:45:00');
insert into hospital values ('4', 'in', '2019-12-22 09:45:00');
insert into hospital values ('5', 'out', '2019-12-22 09:40:00');

select *--count(emp_id)
from
(select *,
dense_rank() over(partition by emp_id order by time desc) rnk
from hospital)x
where rnk =1 and action = 'in'


------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------


-- The problem is called as Most Popular Room Types.  In this problem convert comma separated values into row.
-- script:
create table airbnb_searches 
(
user_id int,
date_searched date,
filter_room_types varchar(200)
);
delete from airbnb_searches;
insert into airbnb_searches values
(1,'2022-01-01','entire home,private room')
,(2,'2022-01-02','entire home,shared room')
,(3,'2022-01-02','private room,shared room')
,(4,'2022-01-03','private room')
;

select room_type,count(1)
from
(select user_id,date_searched,
 regexp_split_to_table(filter_room_types, ',') AS room_type
from airbnb_searches)x
group by room_type

------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------

--write a SQL to return all employee whose salary is same in same department
-- script:
CREATE TABLE emp_salary (
    emp_id INTEGER NOT NULL,
    name VARCHAR(20) NOT NULL,
    salary VARCHAR(30),
    dept_id INTEGER
);


INSERT INTO emp_salary
(emp_id, name, salary, dept_id)
VALUES(101, 'sohan', '3000', '11'),
(102, 'rohan', '4000', '12'),
(103, 'mohan', '5000', '13'),
(104, 'cat', '3000', '11'),
(105, 'suresh', '4000', '12'),
(109, 'mahesh', '7000', '12'),
(108, 'kamal', '8000', '11');

with cte as(select *,
count(rnk) over(partition by dept_id order by salary)
from
(select *,
dense_rank() over(partition by dept_id order by salary) as rnk
from emp_salary)x)

select emp_id,name,salary,dept_id
from cte
where rnk = 1 and count >=2


------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------


CREATE TABLE movies (
    id INT PRIMARY KEY,
    genre VARCHAR(50),
    title VARCHAR(100)
);

-- Create reviews table
CREATE TABLE reviews (
    movie_id INT,
    rating DECIMAL(3,1),
    FOREIGN KEY (movie_id) REFERENCES movies(id)
);

-- Insert sample data into movies table
INSERT INTO movies (id, genre, title) VALUES
(1, 'Action', 'The Dark Knight'),
(2, 'Action', 'Avengers: Infinity War'),
(3, 'Action', 'Gladiator'),
(4, 'Action', 'Die Hard'),
(5, 'Action', 'Mad Max: Fury Road'),
(6, 'Drama', 'The Shawshank Redemption'),
(7, 'Drama', 'Forrest Gump'),
(8, 'Drama', 'The Godfather'),
(9, 'Drama', 'Schindler''s List'),
(10, 'Drama', 'Fight Club'),
(11, 'Comedy', 'The Hangover'),
(12, 'Comedy', 'Superbad'),
(13, 'Comedy', 'Dumb and Dumber'),
(14, 'Comedy', 'Bridesmaids'),
(15, 'Comedy', 'Anchorman: The Legend of Ron Burgundy');

-- Insert sample data into reviews table
INSERT INTO reviews (movie_id, rating) VALUES
(1, 4.5),
(1, 4.0),
(1, 5.0),
(2, 4.2),
(2, 4.8),
(2, 3.9),
(3, 4.6),
(3, 3.8),
(3, 4.3),
(4, 4.1),
(4, 3.7),
(4, 4.4),
(5, 3.9),
(5, 4.5),
(5, 4.2),
(6, 4.8),
(6, 4.7),
(6, 4.9),
(7, 4.6),
(7, 4.9),
(7, 4.3),
(8, 4.9),
(8, 5.0),
(8, 4.8),
(9, 4.7),
(9, 4.9),
(9, 4.5),
(10, 4.6),
(10, 4.3),
(10, 4.7),
(11, 3.9),
(11, 4.0),
(11, 3.5),
(12, 3.7),
(12, 3.8),
(12, 4.2),
(13, 3.2),
(13, 3.5),
(13, 3.8),
(14, 3.8),
(14, 4.0),
(14, 4.2),
(15, 3.9),
(15, 4.0),
(15, 4.1);


select *
from movies


select *
from reviews


------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------


-- Write a query to find busiest route along with total ticket count
-- oneway_round = "O" — > One Way Trip
-- oneway_round ="R" -> Round Trip
-- Note: DEL BOM is different route from BOM - > DEL
-- Script:
drop table tickets
CREATE TABLE tickets (
    airline_number VARCHAR(10),
    origin VARCHAR(3),
    destination VARCHAR(3),
    oneway_round CHAR(1),
    ticket_count INT
);


INSERT INTO tickets (airline_number, origin, destination, oneway_round, ticket_count)
VALUES
    ('DEF456', 'BOM', 'DEL', 'O', 150),
    ('GHI789', 'DEL', 'BOM', 'R', 50),
    ('JKL012', 'BOM', 'DEL', 'R', 75),
    ('MNO345', 'DEL', 'NYC', 'O', 200),
    ('PQR678', 'NYC', 'DEL', 'O', 180),
    ('STU901', 'NYC', 'DEL', 'R', 60),
    ('ABC123', 'DEL', 'BOM', 'O', 100),
    ('VWX234', 'DEL', 'NYC', 'R', 90);


select *
from tickets

------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------

-- Find the company only whose revenue is increasing increasing every year.
-- Note Suppose a company revenue is increasing for 3 years and a very next year revenue is dipped in that case it should not come in output

create table company_revenue 
(
company varchar(100),
year int,
revenue int
)

insert into company_revenue values 
('ABC1',2000,100),('ABC1',2001,110),('ABC1',2002,120),('ABC2',2000,100),('ABC2',2001,90),('ABC2',2002,120)
,('ABC3',2000,500),('ABC3',2001,400),('ABC3',2002,600),('ABC3',2003,800);

with cte as(select *,
case when next_year_revenue >= revenue then 1
else 0
end as flag
from
(select *,
dense_rank() over(partition by company order by year),
lead(revenue,1,revenue) over(partition by company order by null) as next_year_revenue
from company_revenue)x)

select *
from company_revenue 
where company not in
(select company 
from cte
where flag = 0)


------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------


create table source(id int, name varchar(5));

create table target(id int, name varchar(5));

insert into source values(1,'A'),(2,'B'),(3,'C'),(4,'D');

insert into target values(1,'A'),(2,'B'),(4,'X'),(5,'F');

------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------

-- -find the words which are repeating more than once considering all the rows of content column

drop table python
create table python (
file_name varchar(25),
content varchar(200)
);

delete from python;
insert into python values ('python bootcamp1.txt','python for data analytics 0 to hero bootcamp starting on Jan 6th')
,('python bootcamp2.txt','classes will be held on weekends from 11am to 1 pm for 5-6 weeks')
,('python bootcamp3.txt','use code NY2024 to get 33 percent off. You can register from namaste sql website. Link in pinned comment')

select regexp_split_to_table(content,' ') as words, count(1) as count
from python
group by regexp_split_to_table(content,' ')
having count(1) > 1

------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------
-- Highest and Lowest Salary Employees in Each Department

drop table employee;
create table employee 
(
emp_name varchar(10),
dep_id int,
salary int
);

delete from employee;
insert into employee values 
('Siva',1,30000),('Ravi',2,40000),('Prasad',1,50000),('Sai',2,20000)


select dep_id,
max(case 
when highest_salary = 1 then emp_name end) as max_sal_emp,
max(case
when lowest_salary = 1 then emp_name end) as min_sal_emp
from(select *,
dense_rank() over(partition by dep_id order by salary desc) highest_salary,
dense_rank() over(partition by dep_id order by salary) lowest_salary
from employee)x
group by dep_id

------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------
Here are the scripts:
--Question 1
CREATE TABLE swiggy_orders (
    orderid INT PRIMARY KEY,
    custid INT,
    city VARCHAR(50),
    del_partner VARCHAR(50),
    order_time TIMESTAMP,
    deliver_time TIMESTAMP,
    predicted_time INT -- Predicted delivery time in minutes
);
INSERT INTO swiggy_orders (orderid, custid, city, del_partner, order_time, deliver_time, predicted_time)
VALUES
-- Delivery Partner A
(1, 101, 'Mumbai', 'Partner A', '2024-12-18 10:00:00', '2024-12-18 11:30:00', 60),
(2, 102, 'Delhi', 'Partner A', '2024-12-18 09:00:00', '2024-12-18 10:00:00', 45),
(3, 103, 'Pune', 'Partner A', '2024-12-18 15:00:00', '2024-12-18 15:30:00', 30),
(4, 104, 'Mumbai', 'Partner A', '2024-12-18 14:00:00', '2024-12-18 14:50:00', 45),

-- Delivery Partner B
(5, 105, 'Bangalore', 'Partner B', '2024-12-18 08:00:00', '2024-12-18 08:29:00', 30),
(6, 106, 'Hyderabad', 'Partner B', '2024-12-18 13:00:00', '2024-12-18 14:00:00', 70),
(7, 107, 'Kolkata', 'Partner B', '2024-12-18 10:00:00', '2024-12-18 10:40:00', 45),
(8, 108, 'Delhi', 'Partner B', '2024-12-18 18:00:00', '2024-12-18 18:30:00', 40),

-- Delivery Partner C
(9, 109, 'Chennai', 'Partner C', '2024-12-18 07:00:00', '2024-12-18 07:40:00', 30),
(10, 110, 'Mumbai', 'Partner C', '2024-12-18 12:00:00', '2024-12-18 13:00:00', 50),
(11, 111, 'Delhi', 'Partner C', '2024-12-18 09:00:00', '2024-12-18 09:35:00', 30),
(12, 112, 'Hyderabad', 'Partner C', '2024-12-18 16:00:00', '2024-12-18 16:45:00', 30);

--question 2
CREATE TABLE sales_data (
    order_date DATE,
    customer_id INT,
    store_id INT,
    product_id INT,
    sale INT,
    order_value INT
);


INSERT INTO sales_data (order_date, customer_id, store_id, product_id, sale, order_value)
VALUES
('2024-12-01', 109, 1, 3, 2, 700),
('2024-12-02', 110, 2, 2, 1, 300),
('2024-12-03', 111, 1, 5, 3, 900),
('2024-12-04', 112, 3, 1, 2, 500),
('2024-12-05', 113, 3, 4, 4, 1200), 
('2024-12-05', 114, 3, 4, 2, 400),
('2024-12-05', 115, 3, 4, 1, 300),
('2024-12-01', 101, 1, 4, 2, 500),
('2024-12-01', 102, 1, 4, 1, 300),
('2024-12-02', 103, 2, 4, 3, 900),
('2024-12-02', 104, 2, 4, 1, 400),
('2024-12-03', 105, 1, 4, 2, 600),
('2024-12-03', 106, 1, 4, 3, 800),
('2024-12-04', 107, 3, 4, 1, 200),
('2024-12-04', 108, 3, 4, 2, 500);

------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------

------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------

------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------

------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------

------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------

------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------

------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------

------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------

------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------

------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------

------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------


------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------

------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------

------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------


