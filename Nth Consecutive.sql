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

------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXX------------------------------------------

create table company_revenue 
(
	company varchar(100),
	year int,
	revenue int
)

insert into company_revenue values 
('ABC1',2000,100),
('ABC1',2001,110),
('ABC1',2002,120),
('ABC2',2000,100),
('ABC2',2001,90),
('ABC2',2002,120),
('ABC3',2000,500),
('ABC3',2001,400),
('ABC3',2002,600),
('ABC3',2003,800);



with cte as(select *,
lead(revenue) over(partition by company order by year) as lead
from company_revenue),

cte2 as(select *,
case 
when revenue>lead then 0
when revenue<lead then 1
else 1
end as flag
from cte)

select flag,company,year,revenue
from cte2
where company not in
(
	select company 
	from cte2
	where flag = 0
)



---------------------------------------------------------------XXXXXXXXXXXXXXX--------------------------------------------------------------


-->> Problem Statement:
--Write a query to fetch the record of brand whose amount is increasing every year.


-->> Dataset:
drop table phone_brands;
create table phone_brands
(
    Year    int,
    Brand   varchar(20),
    Amount  int
);
insert into phone_brands values (2018, 'Apple', 45000);
insert into phone_brands values (2019, 'Apple', 35000);
insert into phone_brands values (2020, 'Apple', 75000);
insert into phone_brands values (2018, 'Samsung',15000);
insert into phone_brands values (2019, 'Samsung',20000);
insert into phone_brands values (2020, 'Samsung',25000);
insert into phone_brands values (2018, 'Nokia', 21000);
insert into phone_brands values (2019, 'Nokia', 17000);
insert into phone_brands values (2020, 'Nokia', 14000);






with cte as(select *,
lead(amount) over(partition by brand order by year) as lead
from phone_brands),

cte2 as(select *,
case 
when amount > lead then 0
when amount < lead then 1
else 1
end as flag
from cte
)

select year,brand,amount
from cte2
where brand not in(
select brand
from cte2
where flag = 0)


-- with cte as(select *,
-- case
-- when amount > lead then 0
-- when amount < lead then 1
-- else 1
-- end as flag
-- from
-- (select *,
-- lead(amount) over(partition by brand order by year) as lead
-- from brands
-- )x
-- )

-- select *
-- from cte 
-- where brand not in
-- (select brand
-- from cte
-- where flag = 0
-- )




--with cte as
--    (select *
--    , (case when amount < lead(amount, 1, amount+1)  ---lead(amount, offset, default_value)
--                                over(partition by brand order by year)
--                then 1
--           else 0
--      end) as flag
--    from brands)
--select *
--from brands
--where brand not in (select brand from cte where flag = 0)




---------------------------------------------XXXXXXXXXXXXXXXXXXXXX----------------------------------------------



-- Finding n consecutive records where temperature is below zero. And table has a primary key.

--Table Structure:
drop table if exists weather cascade;
create table weather --if not exists weather
	(
		id 	int primary key,
		city varchar(50) not null,
		temperature int not null,
		day date not null
	);

delete from weather;
insert into weather values
	(1, 'London', -1, '2021-01-01'),
	(2, 'London', -2, '2021-01-02'),
	(3, 'London', 4, '2021-01-03'),
	(4, 'London', 1, '2021-01-04'),
	(5, 'London', -2, '2021-01-05'),
	(6, 'London', -5, '2021-01-06'),
	(7, 'London', -7, '2021-01-07'),
	(8, 'London', 5, '2021-01-08'),
	(9, 'London', -20, '2021-01-09'),
	(10, 'London', 20, '2021-01-10'),
	(11, 'London', 22, '2021-01-11'),
	(12, 'London', -1, '2021-01-12'),
	(13, 'London', -2, '2021-01-13'),
	(14, 'London', -2, '2021-01-14'),
	(15, 'London', -4, '2021-01-15'),
	(16, 'London', -9, '2021-01-16'),
	(17, 'London', 0, '2021-01-17'),
	(18, 'London', -10, '2021-01-18'),
	(19, 'London', -11, '2021-01-19'),
	(20, 'London', -12, '2021-01-20'),
	(21, 'London', -11, '2021-01-21');


select * from weather;



with cte as(select *,
row_number() over(order by day) as rn,
id - row_number() over(order by day) as diff
from weather 
where temperature < 0),

cte2 as(select id,city,temperature,day,
count(*) over(partition by diff) as count
from cte)

select *
from cte2 
where count=3




-- Finding n consecutive records where temperature is below zero. And table does not have primary key.

create table weather_pk 
	(
		city varchar(50) not null,
		temperature int not null,
		day date not null
	);

insert into weather_pk values
	('London', -1, '2021-01-01'),
	('London', -2, '2021-01-02'),
	('London', 4, '2021-01-03'),
	('London', 1, '2021-01-04'),
	('London', -2, '2021-01-05'),
	('London', -5, '2021-01-06'),
	('London', -7, '2021-01-07'),
	('London', 5, '2021-01-08'),
	('London', -20, '2021-01-09'),
	('London', 20, '2021-01-10'),
	('London', 22, '2021-01-11'),
	('London', -1, '2021-01-12'),
	('London', -2, '2021-01-13'),
	('London', -2, '2021-01-14'),
	('London', -4, '2021-01-15'),
	('London', -9, '2021-01-16'),
	('London', 0, '2021-01-17'),
	('London', -10, '2021-01-18'),
	('London', -11, '2021-01-19'),
	('London', -12, '2021-01-20'),
	('London', -11, '2021-01-21');


	select *
	from weather_pk

with cte as(select *,
row_number() over(order by day) as id
from weather_pk),


cte2 as(select *,
id-row_number() over(order by day) as diff
from cte
where temperature < 0
),

cte3 as(select *,count(1) over(partition by diff) as cnt
from cte2)

select *
from cte3
where cnt = 3

---------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXX----------------------------------------------------------------


-- Finding n consecutive records with consecutive date value.

--Table Structure:
drop table if exists orders cascade;
create table orders --if not exists orders
  (
    order_id    varchar(20) primary key,
    order_date  date not null
);

--delete from orders;
insert into orders values
  ('ORD1001', '2021-Jan-01'),
  ('ORD1002', '2021-Feb-01'),
  ('ORD1003', '2021-Feb-02'),
  ('ORD1004', '2021-Feb-03'),
  ('ORD1005', '2021-Mar-01'),
  ('ORD1006', '2021-Jun-01'),
  ('ORD1007', '2021-Dec-25'),
  ('ORD1008', '2021-Dec-26');

with cte as(select *,
row_number() over(order by order_id) as rn 
from orders),

cte2 as(SELECT *,DATEADD(day, - rn, CAST(order_date AS DATE)) AS NewDate
FROM cte),

cte3 as(select *,
count(*) over(partition by newdate) as count
from cte2)

select *
from cte3 
where count = 3



select * from(select *,
count(*) over(partition by month(order_date)) as rank
from orders)x
where x.rank =3



--------------------------------------------------------------------------------------------------------------------



--From the weather table, fetch all the records when London had extremely cold temperature for 3 consecutive days or more.

--Note: Weather is considered to be extremely cold then its temperature is less than zero.

--Table Structure:

drop table weather_2;
create table weather_2
(
id int,
city varchar(50),
temperature int,
day date
);
delete from weather_2;
insert into weather_2 values
(1, 'London', -1,'2021-01-01'),
(2, 'London', -2,'2021-01-02'),
(3, 'London', 4, '2021-01-03'),
(4, 'London', 1, '2021-01-04'),
(5, 'London', -2,'2021-01-05'),
(6, 'London', -5,'2021-01-06'),
(7, 'London', -7,'2021-01-07'),
(8, 'London', 5, '2021-01-08');



with cte as(select *,
count(*) over(partition by diff) as count
from(select *,
row_number() over(order by day) as row_num,
id-row_number() over(order by day) as diff
from weather_2
where temperature < 0
)x)

select *
from cte
where count = 3




--Solution:

select id, city, temperature, day
from (
    select *,
        case when temperature < 0
              and lead(temperature) over(order by day) < 0
              and lead(temperature,2) over(order by day) < 0
        then 'Y'
        when temperature < 0
              and lead(temperature) over(order by day) < 0
              and lag(temperature) over(order by day) < 0
        then 'Y'
        when temperature < 0
              and lag(temperature) over(order by day) < 0
              and lag(temperature,2) over(order by day) < 0
        then 'Y'
        end as flag
    from weather_2) x
where x.flag = 'Y';



--with cte as(select *,
--row_number() over(order by day) as rn
--from weather_2
--where temperature < 0),

--cte2 as(select *,
--id - rn as diff
--from cte)

--select *,
--count (1) over(partition by diff) as count
--from cte2



----------------------------------------------XXXXXXXXXXXXX-----------------------------------------------------

-- Find the cities where covid cases are rising


CREATE TABLE covid(
city VARCHAR(50),
days DATE,
cases INT);

DELETE FROM covid;

INSERT INTO covid VALUES
('DELHI','2022-01-01',100),
('DELHI','2022-01-02',200),
('DELHI','2022-01-03',300),
('MUMBAI','2022-01-01',100),
('MUMBAI','2022-01-02',100),
('MUMBAI','2022-01-03',300),
('CHENNAI','2022-01-01',100),
('CHENNAI','2022-01-02',200),
('CHENNAI','2022-01-03',150),
('BANGALORE','2022-01-01',100),
('BANGALORE','2022-01-02',300),
('BANGALORE','2022-01-03',200),
('BANGALORE','2022-01-04',400);


with cte as(select *,
lead(cases) over(partition by city order by days) as lead
from covid),

cte2 as(select *,
case 
when lead>cases then 1
when lead<cases then 2
when lead=cases then 2
else 1
end as flag
from cte)

select city,days,cases
from cte2
where city not in(
select city 
from cte2
where flag=2
)






--with cte as(select *,
--dense_rank() over(partition by city order by days) as rnk_days,
--dense_rank() over(partition by city order by cases) as rnk_cases
--from covid),

--cte2 as(select *,rnk_days-rnk_cases as subtraction
----select *,cast(rnk_days as signed)-cast(rnk_cases as signed) as subtraction
--from cte),

--cte3 as(select city,count(distinct subtraction) as cnt
--from cte2
--group by city
--having count(distinct subtraction)=1
--)

--select c.city,cv.days,cv.cases
--from cte3 as c
--join covid as cv
--on c.city=cv.city;




---------------------------------------------XXXXXXXXXXXXXXXXXXXXX----------------------------------------------


- From the login_details table, fetch the users who logged in consecutively 3 or more times.

--Table Structure:

drop table login_details;
create table login_details(
login_id int primary key,
user_name varchar(50) not null,
login_date date);

delete from login_details;
-- insert into login_details values
-- (101, 'Michael', getutcdate()),
-- (102, 'James', getutcdate()),
-- (103, 'Stewart', getutcdate()+1),
-- (104, 'Stewart', getutcdate()+1),
-- (105, 'Stewart', getutcdate()+1),
-- (106, 'Michael', getutcdate()+2),
-- (107, 'Michael', getutcdate()+2),
-- (108, 'Stewart', getutcdate()+3),
-- (109, 'Stewart', getutcdate()+3),
-- (110, 'James', getutcdate()+4),
-- (111, 'James', getutcdate()+4),
-- (112, 'James', getutcdate()+5),
-- (113, 'James', getutcdate()+6);

INSERT INTO login_details (login_id, user_name, login_date) VALUES
(101, 'Michael', CURRENT_TIMESTAMP),
(102, 'James', CURRENT_TIMESTAMP),
(103, 'Stewart', CURRENT_TIMESTAMP + INTERVAL '1 day'),
(104, 'Stewart', CURRENT_TIMESTAMP + INTERVAL '1 day'),
(105, 'Stewart', CURRENT_TIMESTAMP + INTERVAL '1 day'),
(106, 'Michael', CURRENT_TIMESTAMP + INTERVAL '2 days'),
(107, 'Michael', CURRENT_TIMESTAMP + INTERVAL '2 days'),
(108, 'Stewart', CURRENT_TIMESTAMP + INTERVAL '3 days'),
(109, 'Stewart', CURRENT_TIMESTAMP + INTERVAL '3 days'),
(110, 'James', CURRENT_TIMESTAMP + INTERVAL '4 days'),
(111, 'James', CURRENT_TIMESTAMP + INTERVAL '4 days'),
(112, 'James', CURRENT_TIMESTAMP + INTERVAL '5 days'),
(113, 'James', CURRENT_TIMESTAMP + INTERVAL '6 days');



select * from login_details;

--Solution:

select distinct user_name from(select *,
lead(user_name) over(order by login_id) as lead,
lag(user_name) over(order by login_id) as lag
from login_details)x
where x.lead=user_name and x.lag=user_name



select distinct repeated_names
from (
select *,
case when user_name = lead(user_name) over(order by login_id)
and  user_name = lead(user_name,2) over(order by login_id)
then user_name else null end as repeated_names
from login_details) x
where x.repeated_names is not null;


-----------------------------------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------

--Consecutive Empty Seats 

create table bms (seat_no int ,is_empty varchar(10));
insert into bms values
(1,'N')
,(2,'Y')
,(3,'N')
,(4,'Y')
,(5,'Y')
,(6,'Y')
,(7,'N')
,(8,'Y')
,(9,'Y')
,(10,'Y')
,(11,'Y')
,(12,'N')
,(13,'Y')
,(14,'Y');

select *
from bms



with cte as(
select *,
seat_no - row_number() over(order by seat_no) as diff
from(select *,
-- lead(is_empty) over(order by seat_no),
-- lag(is_empty) over(order by seat_no),
case 
when is_empty =  lead(is_empty) over(order by seat_no) then 1 
when is_empty =  lag(is_empty) over(order by seat_no) then 1
else 0
end as flag
from bms)x
where is_empty = 'Y')

select *,
count(*) over(partition by diff) as count
from cte






create table movie(
seat varchar(50),occupancy int
);
insert into movie 
values('a1',1),('a2',1),('a3',0),('a4',0),('a5',0),('a6',0),('a7',1),('a8',1),('a9',0),('a10',0),
('b1',0),('b2',0),('b3',0),('b4',1),('b5',1),('b6',1),('b7',1),('b8',0),('b9',0),('b10',0),
('c1',0),('c2',1),('c3',0),('c4',1),('c5',1),('c6',0),('c7',1),('c8',0),('c9',0),('c10',1);



select *,left(seat,1),
row_number() over(partition by left(seat,1)),
lead(occupancy) over(partition by left(seat,1)),
lag(occupancy) over(partition by left(seat,1)),
case 
when occupancy =  lead(occupancy) over(partition by left(seat,1)) then 1
when occupancy = lag(occupancy) over(partition by left(seat,1)) then 1
else 0
end as flag
from movie
where occupancy  = 0








-----------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------------------


script:
create table event_status
(
event_time varchar(10),
status varchar(10)
);
insert into event_status 
values
('10:01','on'),('10:02','on'),('10:03','on'),('10:04','off'),('10:07','on'),('10:08','on'),('10:09','off')
,('10:11','on'),('10:12','off');

select *
from event_status
-----------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------------------

Find out the time employee spent in office on a particular day (office hour = last logout time - first login time)
Find out how productive he was on that day 


CREATE TABLE swipe (
    employee_id INT,
    activity_type VARCHAR(10),
    activity_time timestamp
);

-- Insert sample data
INSERT INTO swipe (employee_id, activity_type, activity_time) VALUES
(1, 'login', '2024-07-23 08:00:00'),
(1, 'logout', '2024-07-23 12:00:00'),
(1, 'login', '2024-07-23 13:00:00'),
(1, 'logout', '2024-07-23 17:00:00'),
(2, 'login', '2024-07-23 09:00:00'),
(2, 'logout', '2024-07-23 11:00:00'),
(2, 'login', '2024-07-23 12:00:00'),
(2, 'logout', '2024-07-23 15:00:00'),
(1, 'login', '2024-07-24 08:30:00'),
(1, 'logout', '2024-07-24 12:30:00'),
(2, 'login', '2024-07-24 09:30:00'),
(2, 'logout', '2024-07-24 10:30:00');


select *,
dense_rank() over(partition by employee_id,extract (day from activity_time) order by activity_time desc),
-- first_value(activity_time) over(partition by employee_id,extract (day from activity_time)),
-- last_value(activity_time) over(partition by employee_id,extract (day from activity_time)),
first_value(activity_time) over(partition by employee_id,extract (day from activity_time)) - 
last_value(activity_time) over(partition by employee_id,extract (day from activity_time)) time_employee_spent_in_office
from swipe


select *,
dense_rank() over(partition by employee_id,extract (day from activity_time) order by activity_time desc)
-- first_value(activity_time) over(partition by employee_id,extract (day from activity_time)),
-- last_value(activity_time) over(partition by employee_id,extract (day from activity_time)),
-- first_value(activity_time) over(partition by employee_id,extract (day from activity_time)) - 
-- last_value(activity_time) over(partition by employee_id,extract (day from activity_time)) time_employee_spent_in_office
from swipe
where activity_type = 'login'



-----------------------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXX-------------------------------------------------------------


-- Write a SQL query to find consecutive 3 rows with the visited people more than 500

-- create table tourist(id int identity,date_id date,visited_people int;
CREATE TABLE tourist (
    id SERIAL PRIMARY KEY,
    date_id DATE,
    visited_people INT
);

-- insert into tourist values('2024-01-01',700);
-- insert into tourist values('2024-02-01',460);
-- insert into tourist values('2024-03-01',550);
-- insert into tourist values('2024-04-01',510);
-- insert into tourist values('2024-05-01',550);
-- insert into tourist values('2024-06-01',540);
-- insert into tourist values('2024-07-01',90);
-- insert into tourist values('2024-08-01',650);
-- insert into tourist values('2024-09-01',580);
-- insert into tourist values('2024-10-01',590);



INSERT INTO tourist (date_id, visited_people) VALUES ('2024-01-01', 700);
INSERT INTO tourist (date_id, visited_people) VALUES ('2024-02-01', 460);
INSERT INTO tourist (date_id, visited_people) VALUES ('2024-03-01', 550);
INSERT INTO tourist (date_id, visited_people) VALUES ('2024-04-01', 510);
INSERT INTO tourist (date_id, visited_people) VALUES ('2024-05-01', 550);
INSERT INTO tourist (date_id, visited_people) VALUES ('2024-06-01', 540);
INSERT INTO tourist (date_id, visited_people) VALUES ('2024-07-01', 90);
INSERT INTO tourist (date_id, visited_people) VALUES ('2024-08-01', 650);
INSERT INTO tourist (date_id, visited_people) VALUES ('2024-09-01', 580);
INSERT INTO tourist (date_id, visited_people) VALUES ('2024-10-01', 590);


with cte as(select *,
row_number() over(order by date_id) as rnk,
id - row_number() over(order by date_id) diff
from
(SELECT *
from tourist
where visited_people > 500)x),

cte2 as(select id,date_id,visited_people
,count(diff) over(partition by diff) as cnt
from cte)

select id,date_id,visited_people,cnt
from cte2
where cnt >= 3 
