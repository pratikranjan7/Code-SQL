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
-- cities with min and max population

-- script:
CREATE TABLE city_population (
    state VARCHAR(50),
    city VARCHAR(50),
    population INT
);

-- Insert the data
INSERT INTO city_population (state, city, population) VALUES ('haryana', 'ambala', 100);
INSERT INTO city_population (state, city, population) VALUES ('haryana', 'panipat', 200);
INSERT INTO city_population (state, city, population) VALUES ('haryana', 'gurgaon', 300);
INSERT INTO city_population (state, city, population) VALUES ('punjab', 'amritsar', 150);
INSERT INTO city_population (state, city, population) VALUES ('punjab', 'ludhiana', 400);
INSERT INTO city_population (state, city, population) VALUES ('punjab', 'jalandhar', 250);
INSERT INTO city_population (state, city, population) VALUES ('maharashtra', 'mumbai', 1000);
INSERT INTO city_population (state, city, population) VALUES ('maharashtra', 'pune', 600);
INSERT INTO city_population (state, city, population) VALUES ('maharashtra', 'nagpur', 300);
INSERT INTO city_population (state, city, population) VALUES ('karnataka', 'bangalore', 900);
INSERT INTO city_population (state, city, population) VALUES ('karnataka', 'mysore', 400);
INSERT INTO city_population (state, city, population) VALUES ('karnataka', 'mangalore', 200);

select state,
max(case when max_population = 1 then city end) as max_poulation_city,
max(case when min_population = 1 then city end) as min_poulation_city
from
(select *,
dense_rank() over(partition by state order by population desc) max_population,
dense_rank() over(partition by state order by population) min_population
from city_population)x
group by state

------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------


-- Find number of employees inside the hospital
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



select room_type,count(1)
from
(select user_id,date_searched,
 unnest(regexp_split_to_array(filter_room_types, ',')) AS room_type
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


with cte as(select genre,title,rating,
row_number() over(partition by genre order by rating desc ,id) rnk
from
(select t1.genre,t1.title, t1.id ,avg(t2.rating) as rating
from movies t1
right join reviews t2
on t1.id = t2.movie_id
group by t1.genre,t1.title,t1.id)x)

select genre,title,round(rating,0)rating,repeat('*',cast(round(rating,0)as int))
from cte
where rnk =1



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


select origin,destination,sum(ticket_count) as total_count
from(select origin,destination,ticket_count
from tickets
union all
select destination,origin,ticket_count
from tickets
where oneway_round = 'R')x
group by origin,destination
order by total_count desc

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
-- A travel and tour company has 2 tables that relate to customers: FAMILIES and COUNTRIES, Each
-- tour offers a discount if a minimum number of people book at the same time.
-- Write a query to print the maximum number of discounted tours any 1 family in the FAMILIES
-- table can choose from,
-- script:

CREATE TABLE FAMILIES (
    ID VARCHAR(50),
    NAME VARCHAR(50),
    FAMILY_SIZE INT
);

-- Insert data into FAMILIES table
INSERT INTO FAMILIES (ID, NAME, FAMILY_SIZE)
VALUES 
    ('c00dac11bde74750b4d207b9c182a85f', 'Alex Thomas', 9),
    ('eb6f2d3426694667ae3e79d6274114a4', 'Chris Gray', 2),
  ('3f7b5b8e835d4e1c8b3e12e964a741f3', 'Emily Johnson', 4),
    ('9a345b079d9f4d3cafb2d4c11d20f8ce', 'Michael Brown', 6),
    ('e0a5f57516024de2a231d09de2cbe9d1', 'Jessica Wilson', 3);

-- Create COUNTRIES table
CREATE TABLE COUNTRIES (
    ID VARCHAR(50),
    NAME VARCHAR(50),
    MIN_SIZE INT,
 MAX_SIZE INT
);

INSERT INTO COUNTRIES (ID, NAME, MIN_SIZE,MAX_SIZE)
VALUES 
    ('023fd23615bd4ff4b2ae0a13ed7efec9', 'Bolivia', 2 , 4),
    ('be247f73de0f4b2d810367cb26941fb9', 'Cook Islands', 4,8),
    ('3e85ab80a6f84ef3b9068b21dbcc54b3', 'Brazil', 4,7),
    ('e571e164152c4f7c8413e2734f67b146', 'Australia', 5,9),
    ('f35a7bb7d44342f7a8a42a53115294a8', 'Canada', 3,5),
    ('a1b5a4b5fc5f46f891d9040566a78f27', 'Japan', 10,12);
	
SELECT *
FROM FAMILIES

SELECT *
FROM COUNTRIES

SELECT *
FROM COUNTRIES
where min_size < (SELECT max(family_size)
FROM FAMILIES)

select f.name, count(1) as count--,f.family_size,c.name,c.min_size,c.max_size
from FAMILIES f
inner join COUNTRIES c
on f.family_size between c.min_size and c.max_size
group by f.name

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


-- Medium Level:
-- 1. Find out Delivery Partner wise delayed orders count(delay means - the order which took more than predicted time to deliver the order).
-- Write a SQL query to calculate thffumber of delayed orders for each delivery partner. An order is considered delayed if the actual delivery
-- time exceeds the predicted delivery time.
--Note-> if a partner has no delayed orders then display as 0


-- Advanced Level:
-- 2. On which date did the 3rd highest sale of product 4 takellace in terms of value (sale: qty sold; Value: qty sold * price of product)?

CREATE TABLE sales_data (
date DATE,
customer id INT,
store id INT,
product id INT,
sale I N T,
value INT



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




select del_partner ,sum(flag)
from
(SELECT 
    *,round(EXTRACT(EPOCH FROM (deliver_time - order_time)) / 60,0)AS delivery_duration_minutes,
	case when predicted_time <
    round(EXTRACT(EPOCH FROM (deliver_time - order_time)) / 60,0) then 1
	else 0
	end as flag
FROM 
    swiggy_orders)x
group by del_partner



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

select order_date,daily_sales
from
(select *,
dense_rank() over(order by daily_sales desc) as rnk
from
(select order_date, sum(order_value) as daily_sales
from sales_data
where product_id = 4
group by order_date)x)y
where rnk = 3

------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------
-- Exchange Seats

CREATE TABLE seats (
    id INT,
    student VARCHAR(10)
);

INSERT INTO seats VALUES 
(1, 'Amit'),
(2, 'Deepa'),
(3, 'Rohit'),
(4, 'Anjali'),
(5, 'Neha'),
(6, 'Sanjay'),
(7, 'Priya');

select *,
case 
when id%2<>0 then lead(student,1,student) over(order by null)
when id%2 = 0 then lag(student) over(order by null)
end
from seats
------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------
scripts:
create table family 
(
person varchar(5),
type varchar(10),
age int
);
delete from family ;
insert into family values ('A1','Adult',54)
,('A2','Adult',53),('A3','Adult',52),('A4','Adult',58),('A5','Adult',54),('C1','Child',20),('C2','Child',19),('C3','Child',22),('C4','Child',15);

select *
from family


------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------
-- Problem 1:

CREATE TABLE flights 
(
    cid VARCHAR(512),
    fid VARCHAR(512),
    origin VARCHAR(512),
    Destination VARCHAR(512)
);

INSERT INTO flights (cid, fid, origin, Destination) VALUES ('1', 'f1', 'Del', 'Hyd');
INSERT INTO flights (cid, fid, origin, Destination) VALUES ('1', 'f2', 'Hyd', 'Blr');
INSERT INTO flights (cid, fid, origin, Destination) VALUES ('2', 'f3', 'Mum', 'Agra');
INSERT INTO flights (cid, fid, origin, Destination) VALUES ('2', 'f4', 'Agra', 'Kol');

select t1.origin,t2.destination
from flights t1
join flights t2
on t1.destination = t2.origin

-- Ques -2 Find the count ot new customer added in each Month

CREATE TABLE sales 
(
    order_date date,
    customer VARCHAR(512),
    qty INT
);

INSERT INTO sales (order_date, customer, qty) VALUES ('2021-01-01', 'C1', '20');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-01-01', 'C2', '30');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-02-01', 'C1', '10');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-02-01', 'C3', '15');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-03-01', 'C5', '19');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-03-01', 'C4', '10');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-04-01', 'C3', '13');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-04-01', 'C5', '15');
INSERT INTO sales (order_date, customer, qty) VALUES ('2021-04-01', 'C6', '10');

select count(distinct customer),extract(month from order_date) as month,
extract(year from order_date) as year
from
(select *,
dense_rank() over(partition by customer order by order_date) as id
from sales)x
where id = 1
group by extract(month from order_date),
extract(year from order_date)


------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------

create table relations
(
    c_id int,
    p_id int,
    FOREIGN KEY (c_id) REFERENCES people(id),
    foreign key (p_id) references people(id)
);

insert into people (id, name, gender)
values
    (107,'Days','F'),
    (145,'Hawbaker','M'),
    (155,'Hansel','F'),
    (202,'Blackston','M'),
    (227,'Criss','F'),
    (278,'Keffer','M'),
    (305,'Canty','M'),
    (329,'Mozingo','M'),
    (425,'Nolf','M'),
    (534,'Waugh','M'),
    (586,'Tong','M'),
    (618,'Dimartino','M'),
    (747,'Beane','M'),
    (878,'Chatmon','F'),
    (904,'Hansard','F');

insert into relations(c_id, p_id)
values
    (145, 202),
    (145, 107),
    (278,305),
    (278,155),
    (329, 425),
    (329,227),
    (534,586),
    (534,878),
    (618,747),
    (618,904);
------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------
-- Find new and repeat customers using SQL. 
-- script :

create table customer_orders (
order_id integer,
customer_id integer,
order_date date,
order_amount integer
);


insert into customer_orders values(1,100,cast('2022-01-01' as date),2000),(2,200,cast('2022-01-01' as date),2500),(3,300,cast('2022-01-01' as date),2100)
,(4,100,cast('2022-01-02' as date),2000),(5,400,cast('2022-01-02' as date),2200),(6,500,cast('2022-01-02' as date),2700)
,(7,100,cast('2022-01-03' as date),3000),(8,400,cast('2022-01-03' as date),1000),(9,600,cast('2022-01-03' as date),3000)
;

select t1.order_date,
case when t1.new_customer is null then 0 else t1.new_customer end as new_customer,
case when t2.repeat_customer is null then 0 else t2.repeat_customer end as repeat_customer
from
(select order_date,count(distinct customer_id) as new_customer
from
(select *,
dense_rank() over(partition by customer_id order by order_date) as rnk
from customer_orders)x
where rnk = 1
group by order_date)t1
full join 
(select order_date,count(distinct customer_id) as repeat_customer
from
(select *,
dense_rank() over(partition by customer_id order by order_date) as rnk
from customer_orders)x
where rnk <> 1
group by order_date)t2
on t1.order_date = t2.order_date


------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------
-- when the data is case sensitive and when it is insensitivity . 
-- script:

drop table employees;

CREATE TABLE employees  (employee_id int,employee_name varchar(15), email_id varchar(15) );

INSERT INTO employees (employee_id,employee_name, email_id) VALUES ('101','Liam Alton', 'li.al@abc.com');
INSERT INTO employees (employee_id,employee_name, email_id) VALUES ('102','Josh Day', 'jo.da@abc.com');
INSERT INTO employees (employee_id,employee_name, email_id) VALUES ('103','Sean Mann', 'se.ma@abc.com'); 
INSERT INTO employees (employee_id,employee_name, email_id) VALUES ('104','Evan Blake', 'ev.bl@abc.com');
INSERT INTO employees (employee_id,employee_name, email_id) VALUES ('105','Toby Scott', 'jo.da@abc.com');
INSERT INTO employees (employee_id,employee_name, email_id) VALUES ('106','Anjali Chouhan', 'JO.DA@ABC.COM');
INSERT INTO employees (employee_id,employee_name, email_id) VALUES ('107','Ankit Bansal', 'AN.BA@ABC.COM');

-- ALTER TABLE employees
-- ALTER COLUMN email_id VARCHAR(15) COLLATE SQL_Latin1_General_CP1_CS_AS;

ALTER TABLE employees
ALTER COLUMN email_id TYPE VARCHAR(15) COLLATE "C";

select *,ascii(email_id)
from employees


CREATE EXTENSION IF NOT EXISTS citext;


ALTER TABLE employees
ALTER COLUMN email_id TYPE CITEXT;
------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------
create table icc_world_cup
(
match_no int,
team_1 Varchar(20),
team_2 Varchar(20),
winner Varchar(20)
);
INSERT INTO icc_world_cup values(1,'ENG','NZ','NZ');
INSERT INTO icc_world_cup values(2,'PAK','NED','PAK');
INSERT INTO icc_world_cup values(3,'AFG','BAN','BAN');
INSERT INTO icc_world_cup values(4,'SA','SL','SA');
INSERT INTO icc_world_cup values(5,'AUS','IND','IND');
INSERT INTO icc_world_cup values(6,'NZ','NED','NZ');
INSERT INTO icc_world_cup values(7,'ENG','BAN','ENG');
INSERT INTO icc_world_cup values(8,'SL','PAK','PAK');
INSERT INTO icc_world_cup values(9,'AFG','IND','IND');
INSERT INTO icc_world_cup values(10,'SA','AUS','SA');
INSERT INTO icc_world_cup values(11,'BAN','NZ','NZ');
INSERT INTO icc_world_cup values(12,'PAK','IND','IND');
INSERT INTO icc_world_cup values(12,'SA','IND','DRAW');

select *
from icc_world_cup

with cte as(select team_1 team,sum(no_of_matches_played) no_of_matches_played,
sum(point)point
from
(select team_1,count(*) as no_of_matches_played,
sum(case when team_1 = winner then 1 else 0 end) as point
from icc_world_cup
group by team_1
union all
select team_2,count(*) as no_of_matches_played,
sum(case when team_2 = winner then 1 else 0 end) as point
from icc_world_cup
group by team_2)x
group by team_1)

select team,no_of_matches_played,no_of_matches_played-point as no_of_loss,point*2 point
from cte
------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------
-- solve a SQL puzzle kind of problem. This was asked in a Data Analyst Interview.
-- script:

create table input (
id int,
formula varchar(10),
value int
)
insert into input values (1,'1+4',10),(2,'2+1',5),(3,'3-2',40),(4,'4-1',20);

select *
from input
------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------

------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------

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
create table Ameriprise_LLC
(
teamID varchar(2),
memberID varchar(10),
Criteria1 varchar(1),
Criteria2 varchar(1)
);
insert into Ameriprise_LLC values 
('T1','T1_mbr1','Y','Y'),
('T1','T1_mbr2','Y','Y'),
('T1','T1_mbr3','Y','Y'),
('T1','T1_mbr4','Y','Y'),
('T1','T1_mbr5','Y','N'),
('T2','T2_mbr1','Y','Y'),
('T2','T2_mbr2','Y','N'),
('T2','T2_mbr3','N','Y'),
('T2','T2_mbr4','N','N'),
('T2','T2_mbr5','N','N'),
('T3','T3_mbr1','Y','Y'),
('T3','T3_mbr2','Y','Y'),
('T3','T3_mbr3','N','Y'),
('T3','T3_mbr4','N','Y'),
('T3','T3_mbr5','Y','N');
------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------
create table source(id int, name varchar(5));

create table target(id int, name varchar(5));

insert into source values(1,'A'),(2,'B'),(3,'C'),(4,'D');

insert into target values(1,'A'),(2,'B'),(4,'X'),(5,'F');
------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------
-- write a query to get start time and end time of each call from below 2 tables. Also create a column of call
-- duration in minutes. Please do take into account that there will be multiple calls from one phone number
-- and each entry in start table has a corresponding entry in end table.



create table call_start_logs
(
phone_number varchar(10),
start_time timestamp
);

insert into call_start_logs values
('PN1','2022-01-01 10:20:00'),
('PN1','2022-01-01 16:25:00'),
('PN2','2022-01-01 12:30:00'),
('PN3','2022-01-02 10:00:00'),
('PN3','2022-01-02 12:30:00'),
('PN3','2022-01-03 09:20:00');

create table call_end_logs
(
phone_number varchar(10),
end_time timestamp
);

insert into call_end_logs values
('PN1','2022-01-01 10:45:00'),
('PN1','2022-01-01 17:05:00'),
('PN2','2022-01-01 12:55:00'),
('PN3','2022-01-02 10:20:00'),
('PN3','2022-01-02 12:50:00'),
('PN3','2022-01-03 09:40:00');

with cte as(select * 
from
(SELECT *
FROM call_start_logs
UNION ALL
SELECT *
FROM call_end_logs)x
order by phone_number ,EXTRACT(hour FROM start_time), EXTRACT(MINUTE FROM start_time)),

cte2 as(select *,
ntile(6) over(order by null)
from cte),

cte3 as(select phone_number ,max(start_time)start_time, min(start_time)end_time,ntile
from cte2
group by phone_number,ntile
order by phone_number,ntile)

select phone_number,start_time,end_time,
round(EXTRACT(EPOCH FROM start_time::timestamp - end_time::timestamp) / 60,0) AS minutes_difference
from cte3

------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------




