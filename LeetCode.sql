
-- A company wants to hire new employees. The budget of the company for the salaries is $70000.
-- Keep hiring the senior With the smallest salary until you cannot hire any mre seniors
-- use the remaining budget to hire the junior with the smallest salary
-- Keep hiring the junior with the smallest salary until you cannot hire any mre juniors
-- Write an SQL query to find the seniors and juniors hired under the mentioned criteria

-- script:
create table candidates (
emp_id int,
experience varchar(20),
salary int
);
delete from candidates;
insert into candidates values
(1,'Junior',10000),(2,'Junior',15000),(3,'Junior',40000),(4,'Senior',16000),(5,'Senior',20000),(6,'Senior',50000);


with cte as(select *,
sum(salary) over(partition by experience order by salary) as running_sum
from candidates),
cte2 as(
select *
from cte
where experience = 'Senior' and running_sum <= 70000)


select emp_id,experience,salary
from cte
where experience = 'Junior' and running_sum <= 70000-(select sum(salary) from cte2)
union all
select emp_id,experience,salary
from cte2

-----------------------------------------------XXXXXXXXXXXXXXXX-------------------------------------------------------------

-- Write a query to display the records which have 3 or more consecutive rows
--with the amount of people more than 100(inclusive) each day
-- script:
create table stadium (
id int,
visit_date date,
no_of_people int
);

insert into stadium
values (1,'2017-07-01',10)
,(2,'2017-07-02',109)
,(3,'2017-07-03',150)
,(4,'2017-07-04',99)
,(5,'2017-07-05',145)
,(6,'2017-07-06',1455)
,(7,'2017-07-07',199)
,(8,'2017-07-08',188);

with cte as(select *,
id-row_number() over(order by visit_date) as diff
from
(select *
from stadium
where no_of_people > 100)x)

select *,count(diff) over(partition by diff)
from cte


-------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXX-----------------------------------------------------

-- find second most recent activity and if user has only 1 activoty then return that as it is

create table UserActivity
(
username      varchar(20) ,
activity      varchar(20),
startDate     Date   ,
endDate      Date
);

insert into UserActivity values 
('Alice','Travel','2020-02-12','2020-02-20')
,('Alice','Dancing','2020-02-21','2020-02-23')
,('Alice','Travel','2020-02-24','2020-02-28')
,('Bob','Travel','2020-02-11','2020-02-18');


select username,recent_activity second_recent_activity
from(select *,
lead(activity,1,activity) over(partition by username order by enddate desc) as recent_activity
,row_number() over(partition by username) as id
from UserActivity)x
where id = 1


select username,activity second_recent_activity
from(select *,
count(activity) over(partition by username) as count
,row_number() over(partition by username) as id
from UserActivity)x
where id = 2 or count = 1

select *
from UserActivity



-------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXX---------------------------------------------------


-- Use Case 1:
drop table if exists listens;
create table listens
(
	user_id 	int,
	song_id		int,
	day			date
);
drop table if exists friendship;
create table friendship
(
	user1_id 	int,
	user2_id	int
);

insert into listens values(1,10,to_date('2021-03-15','yyyy-mm-dd'));
insert into listens values(1,11,to_date('2021-03-15','yyyy-mm-dd'));
insert into listens values(1,12,to_date('2021-03-15','yyyy-mm-dd'));
insert into listens values(2,10,to_date('2021-03-15','yyyy-mm-dd'));
insert into listens values(2,11,to_date('2021-03-15','yyyy-mm-dd'));
insert into listens values(2,12,to_date('2021-03-15','yyyy-mm-dd'));
insert into listens values(3,10,to_date('2021-03-15','yyyy-mm-dd'));
insert into listens values(3,11,to_date('2021-03-15','yyyy-mm-dd'));
insert into listens values(3,12,to_date('2021-03-15','yyyy-mm-dd'));
insert into listens values(4,10,to_date('2021-03-15','yyyy-mm-dd'));
insert into listens values(4,11,to_date('2021-03-15','yyyy-mm-dd'));
insert into listens values(4,13,to_date('2021-03-15','yyyy-mm-dd'));
insert into listens values(5,10,to_date('2021-03-16','yyyy-mm-dd'));
insert into listens values(5,11,to_date('2021-03-16','yyyy-mm-dd'));
insert into listens values(5,12,to_date('2021-03-16','yyyy-mm-dd'));

insert into friendship values(1,2);

select * from listens;
select * from friendship;



with unique_listen as(select distinct *
from listens),

valid_user as
(select count(*),user_id,day
from(select distinct *
from listens)x
group by user_id,day
having count(1) >=3),

friends as
(select l1.user_id user_id,l2.user_id recommended_id,l1.day,l2.day
,count(1)
--,l1.song_id,l2.song_id
from unique_listen l1
join unique_listen l2
on l1.user_id < l2.user_id and l1.song_id = l2.song_id and l1.day = l2.day
join valid_user vu
on vu.user_id = l1.user_id and l1.day = vu.day
where (l1.user_id,l2.user_id)  not in 
(select user1_id,user2_id from friendship)
group by l1.user_id,l2.user_id,l1.day,l2.day
having count(1) >=3 
)


select user_id ,recommended_id
--*
from friends
union
select recommended_id,user_id
from friends
order by 1,2



-- Use Case 2:
/*
drop table if exists listens;
create table listens
(
	user_id 	int,
	song_id		int,
	day			date
);
drop table if exists friendship;
create table friendship
(
	user1_id 	int,
	user2_id	int
);

insert into listens values(1,33,to_date('2021-03-17','yyyy-mm-dd'));
insert into listens values(1,55,to_date('2021-03-17','yyyy-mm-dd'));
insert into listens values(1,44,to_date('2021-03-17','yyyy-mm-dd'));
insert into listens values(1,66,to_date('2021-03-17','yyyy-mm-dd'));
insert into listens values(1,77,to_date('2021-03-17','yyyy-mm-dd'));
insert into listens values(1,33,to_date('2021-03-17','yyyy-mm-dd'));
insert into listens values(1,55,to_date('2021-03-17','yyyy-mm-dd'));
insert into listens values(1,55,to_date('2021-03-17','yyyy-mm-dd'));
insert into listens values(2,55,to_date('2021-03-17','yyyy-mm-dd'));
insert into listens values(2,44,to_date('2021-03-17','yyyy-mm-dd'));
insert into listens values(2,66,to_date('2021-03-17','yyyy-mm-dd'));
insert into listens values(2,77,to_date('2021-03-17','yyyy-mm-dd'));
insert into listens values(2,88,to_date('2021-03-14','yyyy-mm-dd'));
insert into listens values(2,55,to_date('2021-03-17','yyyy-mm-dd'));
insert into listens values(2,55,to_date('2021-03-17','yyyy-mm-dd'));
insert into listens values(2,55,to_date('2021-03-17','yyyy-mm-dd'));
insert into listens values(2,99,to_date('2021-03-14','yyyy-mm-dd'));
insert into listens values(2,22,to_date('2021-03-14','yyyy-mm-dd'));
insert into listens values(2,88,to_date('2021-03-14','yyyy-mm-dd'));
insert into listens values(3,33,to_date('2021-03-17','yyyy-mm-dd'));
insert into listens values(3,44,to_date('2021-03-17','yyyy-mm-dd'));
insert into listens values(3,88,to_date('2021-03-14','yyyy-mm-dd'));
insert into listens values(3,44,to_date('2021-03-14','yyyy-mm-dd'));
insert into listens values(3,99,to_date('2021-03-14','yyyy-mm-dd'));
insert into listens values(3,22,to_date('2021-03-14','yyyy-mm-dd'));

insert into friendship values(2,3);

select * from listens;
select * from friendship;
*/



-- Use Case 3:
/*
drop table if exists listens;
create table listens
(
	user_id 	int,
	song_id		int,
	day			date
);
drop table if exists friendship;
create table friendship
(
	user1_id 	int,
	user2_id	int
);

insert into listens values(20,1781,to_date('2021-07-26','yyyy-mm-dd'));
insert into listens values(20,1781,to_date('2021-07-30','yyyy-mm-dd'));
insert into listens values(20,1781,to_date('2021-07-22','yyyy-mm-dd'));
insert into listens values(20,1781,to_date('2021-07-16','yyyy-mm-dd'));
insert into listens values(20,1781,to_date('2021-07-16','yyyy-mm-dd'));
insert into listens values(20,1935,to_date('2021-07-18','yyyy-mm-dd'));
insert into listens values(20,1935,to_date('2021-07-13','yyyy-mm-dd'));
insert into listens values(20,1076,to_date('2021-07-19','yyyy-mm-dd'));
insert into listens values(20,1076,to_date('2021-07-09','yyyy-mm-dd'));
insert into listens values(20,1076,to_date('2021-07-26','yyyy-mm-dd'));
insert into listens values(20,1076,to_date('2021-07-24','yyyy-mm-dd'));
insert into listens values(20,1076,to_date('2021-07-20','yyyy-mm-dd'));
insert into listens values(20,1886,to_date('2021-07-15','yyyy-mm-dd'));
insert into listens values(20,1886,to_date('2021-07-23','yyyy-mm-dd'));
insert into listens values(20,1886,to_date('2021-07-09','yyyy-mm-dd'));
insert into listens values(20,1886,to_date('2021-07-05','yyyy-mm-dd'));
insert into listens values(20,1543,to_date('2021-07-12','yyyy-mm-dd'));
insert into listens values(20,1543,to_date('2021-07-28','yyyy-mm-dd'));
insert into listens values(20,1543,to_date('2021-07-06','yyyy-mm-dd'));
insert into listens values(20,1582,to_date('2021-07-07','yyyy-mm-dd'));
insert into listens values(20,1582,to_date('2021-07-08','yyyy-mm-dd'));
insert into listens values(20,1582,to_date('2021-07-12','yyyy-mm-dd'));
insert into listens values(20,1582,to_date('2021-07-31','yyyy-mm-dd'));
insert into listens values(20,1582,to_date('2021-07-22','yyyy-mm-dd'));
insert into listens values(21,1781,to_date('2021-07-23','yyyy-mm-dd'));
insert into listens values(21,1781,to_date('2021-07-28','yyyy-mm-dd'));
insert into listens values(21,1781,to_date('2021-07-01','yyyy-mm-dd'));
insert into listens values(21,1781,to_date('2021-07-04','yyyy-mm-dd'));
insert into listens values(21,1935,to_date('2021-07-11','yyyy-mm-dd'));
insert into listens values(21,1935,to_date('2021-07-11','yyyy-mm-dd'));
insert into listens values(21,1935,to_date('2021-07-16','yyyy-mm-dd'));
insert into listens values(21,1935,to_date('2021-07-17','yyyy-mm-dd'));
insert into listens values(21,1935,to_date('2021-07-06','yyyy-mm-dd'));
insert into listens values(21,1076,to_date('2021-07-01','yyyy-mm-dd'));
insert into listens values(21,1076,to_date('2021-07-03','yyyy-mm-dd'));
insert into listens values(21,1076,to_date('2021-07-16','yyyy-mm-dd'));
insert into listens values(21,1076,to_date('2021-07-31','yyyy-mm-dd'));
insert into listens values(21,1886,to_date('2021-07-15','yyyy-mm-dd'));
insert into listens values(21,1886,to_date('2021-07-20','yyyy-mm-dd'));
insert into listens values(21,1886,to_date('2021-07-06','yyyy-mm-dd'));
insert into listens values(21,1543,to_date('2021-07-26','yyyy-mm-dd'));
insert into listens values(21,1543,to_date('2021-07-04','yyyy-mm-dd'));
insert into listens values(21,1543,to_date('2021-07-08','yyyy-mm-dd'));
insert into listens values(21,1543,to_date('2021-07-18','yyyy-mm-dd'));
insert into listens values(21,1582,to_date('2021-07-22','yyyy-mm-dd'));
insert into listens values(21,1582,to_date('2021-07-05','yyyy-mm-dd'));
insert into listens values(21,1582,to_date('2021-07-09','yyyy-mm-dd'));
insert into listens values(21,1582,to_date('2021-07-06','yyyy-mm-dd'));
insert into listens values(17,1781,to_date('2021-07-06','yyyy-mm-dd'));
insert into listens values(17,1781,to_date('2021-07-25','yyyy-mm-dd'));
insert into listens values(17,1781,to_date('2021-07-30','yyyy-mm-dd'));
insert into listens values(17,1781,to_date('2021-07-08','yyyy-mm-dd'));
insert into listens values(17,1781,to_date('2021-07-31','yyyy-mm-dd'));
insert into listens values(17,1935,to_date('2021-07-27','yyyy-mm-dd'));
insert into listens values(17,1935,to_date('2021-07-04','yyyy-mm-dd'));
insert into listens values(17,1935,to_date('2021-07-10','yyyy-mm-dd'));
insert into listens values(17,1935,to_date('2021-07-24','yyyy-mm-dd'));
insert into listens values(17,1076,to_date('2021-07-27','yyyy-mm-dd'));
insert into listens values(17,1076,to_date('2021-07-09','yyyy-mm-dd'));
insert into listens values(17,1076,to_date('2021-07-24','yyyy-mm-dd'));
insert into listens values(17,1886,to_date('2021-07-16','yyyy-mm-dd'));
insert into listens values(17,1886,to_date('2021-07-21','yyyy-mm-dd'));
insert into listens values(17,1886,to_date('2021-07-24','yyyy-mm-dd'));
insert into listens values(17,1886,to_date('2021-07-16','yyyy-mm-dd'));
insert into listens values(17,1543,to_date('2021-07-13','yyyy-mm-dd'));
insert into listens values(17,1543,to_date('2021-07-04','yyyy-mm-dd'));
insert into listens values(17,1543,to_date('2021-07-09','yyyy-mm-dd'));
insert into listens values(17,1543,to_date('2021-07-22','yyyy-mm-dd'));
insert into listens values(17,1582,to_date('2021-07-05','yyyy-mm-dd'));
insert into listens values(17,1582,to_date('2021-07-26','yyyy-mm-dd'));
insert into listens values(13,1781,to_date('2021-07-24','yyyy-mm-dd'));
insert into listens values(13,1781,to_date('2021-07-20','yyyy-mm-dd'));
insert into listens values(13,1781,to_date('2021-07-15','yyyy-mm-dd'));
insert into listens values(13,1781,to_date('2021-07-17','yyyy-mm-dd'));
insert into listens values(13,1935,to_date('2021-07-29','yyyy-mm-dd'));
insert into listens values(13,1935,to_date('2021-07-15','yyyy-mm-dd'));
insert into listens values(13,1935,to_date('2021-07-02','yyyy-mm-dd'));
insert into listens values(13,1935,to_date('2021-07-13','yyyy-mm-dd'));
insert into listens values(13,1076,to_date('2021-07-19','yyyy-mm-dd'));
insert into listens values(13,1076,to_date('2021-07-16','yyyy-mm-dd'));
insert into listens values(13,1076,to_date('2021-07-08','yyyy-mm-dd'));
insert into listens values(13,1076,to_date('2021-07-15','yyyy-mm-dd'));
insert into listens values(13,1886,to_date('2021-07-18','yyyy-mm-dd'));
insert into listens values(13,1886,to_date('2021-07-17','yyyy-mm-dd'));
insert into listens values(13,1886,to_date('2021-07-10','yyyy-mm-dd'));
insert into listens values(13,1886,to_date('2021-07-08','yyyy-mm-dd'));
insert into listens values(13,1886,to_date('2021-07-13','yyyy-mm-dd'));
insert into listens values(13,1886,to_date('2021-07-18','yyyy-mm-dd'));
insert into listens values(13,1543,to_date('2021-07-19','yyyy-mm-dd'));
insert into listens values(13,1543,to_date('2021-07-06','yyyy-mm-dd'));
insert into listens values(13,1543,to_date('2021-07-08','yyyy-mm-dd'));
insert into listens values(13,1543,to_date('2021-07-10','yyyy-mm-dd'));
insert into listens values(13,1582,to_date('2021-07-29','yyyy-mm-dd'));
insert into listens values(13,1582,to_date('2021-07-11','yyyy-mm-dd'));
insert into listens values(10,1781,to_date('2021-07-19','yyyy-mm-dd'));
insert into listens values(10,1781,to_date('2021-07-21','yyyy-mm-dd'));
insert into listens values(10,1781,to_date('2021-07-28','yyyy-mm-dd'));
insert into listens values(10,1781,to_date('2021-07-23','yyyy-mm-dd'));
insert into listens values(10,1781,to_date('2021-07-16','yyyy-mm-dd'));
insert into listens values(10,1935,to_date('2021-07-12','yyyy-mm-dd'));
insert into listens values(10,1935,to_date('2021-07-04','yyyy-mm-dd'));
insert into listens values(10,1076,to_date('2021-07-25','yyyy-mm-dd'));
insert into listens values(10,1076,to_date('2021-07-06','yyyy-mm-dd'));
insert into listens values(10,1076,to_date('2021-07-21','yyyy-mm-dd'));
insert into listens values(10,1886,to_date('2021-07-15','yyyy-mm-dd'));
insert into listens values(10,1886,to_date('2021-07-02','yyyy-mm-dd'));
insert into listens values(10,1886,to_date('2021-07-23','yyyy-mm-dd'));
insert into listens values(10,1886,to_date('2021-07-07','yyyy-mm-dd'));
insert into listens values(10,1886,to_date('2021-07-08','yyyy-mm-dd'));
insert into listens values(10,1543,to_date('2021-07-05','yyyy-mm-dd'));
insert into listens values(10,1543,to_date('2021-07-29','yyyy-mm-dd'));
insert into listens values(10,1582,to_date('2021-07-09','yyyy-mm-dd'));
insert into listens values(10,1582,to_date('2021-07-09','yyyy-mm-dd'));
insert into listens values(10,1582,to_date('2021-07-12','yyyy-mm-dd'));
insert into listens values(6 ,1781,to_date('2021-07-25','yyyy-mm-dd'));
insert into listens values(6 ,1781,to_date('2021-07-06','yyyy-mm-dd'));
insert into listens values(6 ,1781,to_date('2021-07-09','yyyy-mm-dd'));
insert into listens values(6 ,1781,to_date('2021-07-15','yyyy-mm-dd'));
insert into listens values(6 ,1935,to_date('2021-07-17','yyyy-mm-dd'));
insert into listens values(6 ,1935,to_date('2021-07-05','yyyy-mm-dd'));
insert into listens values(6 ,1935,to_date('2021-07-16','yyyy-mm-dd'));
insert into listens values(6 ,1076,to_date('2021-07-01','yyyy-mm-dd'));
insert into listens values(6 ,1076,to_date('2021-07-07','yyyy-mm-dd'));
insert into listens values(6 ,1076,to_date('2021-07-11','yyyy-mm-dd'));
insert into listens values(6 ,1076,to_date('2021-07-12','yyyy-mm-dd'));
insert into listens values(6 ,1886,to_date('2021-07-11','yyyy-mm-dd'));
insert into listens values(6 ,1886,to_date('2021-07-07','yyyy-mm-dd'));
insert into listens values(6 ,1886,to_date('2021-07-25','yyyy-mm-dd'));
insert into listens values(6 ,1886,to_date('2021-07-19','yyyy-mm-dd'));
insert into listens values(6 ,1886,to_date('2021-07-19','yyyy-mm-dd'));
insert into listens values(6 ,1886,to_date('2021-07-17','yyyy-mm-dd'));
insert into listens values(6 ,1886,to_date('2021-07-29','yyyy-mm-dd'));
insert into listens values(6 ,1543,to_date('2021-07-07','yyyy-mm-dd'));
insert into listens values(6 ,1543,to_date('2021-07-22','yyyy-mm-dd'));
insert into listens values(6 ,1543,to_date('2021-07-13','yyyy-mm-dd'));
insert into listens values(6 ,1543,to_date('2021-07-16','yyyy-mm-dd'));
insert into listens values(6 ,1543,to_date('2021-07-03','yyyy-mm-dd'));
insert into listens values(6 ,1582,to_date('2021-07-28','yyyy-mm-dd'));
insert into listens values(6 ,1582,to_date('2021-07-07','yyyy-mm-dd'));
insert into listens values(6 ,1582,to_date('2021-07-08','yyyy-mm-dd'));
insert into listens values(6 ,1582,to_date('2021-07-12','yyyy-mm-dd'));
insert into listens values(2 ,1781,to_date('2021-07-05','yyyy-mm-dd'));
insert into listens values(2 ,1781,to_date('2021-07-04','yyyy-mm-dd'));
insert into listens values(2 ,1781,to_date('2021-07-17','yyyy-mm-dd'));
insert into listens values(2 ,1781,to_date('2021-07-23','yyyy-mm-dd'));
insert into listens values(2 ,1781,to_date('2021-07-08','yyyy-mm-dd'));
insert into listens values(2 ,1935,to_date('2021-07-11','yyyy-mm-dd'));
insert into listens values(2 ,1935,to_date('2021-07-31','yyyy-mm-dd'));
insert into listens values(2 ,1935,to_date('2021-07-25','yyyy-mm-dd'));
insert into listens values(2 ,1076,to_date('2021-07-08','yyyy-mm-dd'));
insert into listens values(2 ,1076,to_date('2021-07-15','yyyy-mm-dd'));
insert into listens values(2 ,1076,to_date('2021-07-19','yyyy-mm-dd'));
insert into listens values(2 ,1886,to_date('2021-07-27','yyyy-mm-dd'));
insert into listens values(2 ,1886,to_date('2021-07-30','yyyy-mm-dd'));
insert into listens values(2 ,1543,to_date('2021-07-08','yyyy-mm-dd'));
insert into listens values(2 ,1543,to_date('2021-07-27','yyyy-mm-dd'));
insert into listens values(2 ,1543,to_date('2021-07-18','yyyy-mm-dd'));
insert into listens values(2 ,1543,to_date('2021-07-09','yyyy-mm-dd'));
insert into listens values(2 ,1543,to_date('2021-07-20','yyyy-mm-dd'));
insert into listens values(2 ,1582,to_date('2021-07-16','yyyy-mm-dd'));
insert into listens values(2 ,1582,to_date('2021-07-14','yyyy-mm-dd'));
insert into listens values(2 ,1582,to_date('2021-07-19','yyyy-mm-dd'));
insert into listens values(5 ,1781,to_date('2021-07-06','yyyy-mm-dd'));
insert into listens values(5 ,1781,to_date('2021-07-10','yyyy-mm-dd'));
insert into listens values(5 ,1781,to_date('2021-07-19','yyyy-mm-dd'));
insert into listens values(5 ,1935,to_date('2021-07-31','yyyy-mm-dd'));
insert into listens values(5 ,1935,to_date('2021-07-27','yyyy-mm-dd'));
insert into listens values(5 ,1935,to_date('2021-07-12','yyyy-mm-dd'));
insert into listens values(5 ,1935,to_date('2021-07-21','yyyy-mm-dd'));
insert into listens values(5 ,1935,to_date('2021-07-07','yyyy-mm-dd'));
insert into listens values(5 ,1076,to_date('2021-07-13','yyyy-mm-dd'));
insert into listens values(5 ,1076,to_date('2021-07-29','yyyy-mm-dd'));
insert into listens values(5 ,1076,to_date('2021-07-24','yyyy-mm-dd'));
insert into listens values(5 ,1886,to_date('2021-07-21','yyyy-mm-dd'));
insert into listens values(5 ,1886,to_date('2021-07-27','yyyy-mm-dd'));
insert into listens values(5 ,1543,to_date('2021-07-14','yyyy-mm-dd'));
insert into listens values(5 ,1543,to_date('2021-07-06','yyyy-mm-dd'));
insert into listens values(5 ,1543,to_date('2021-07-07','yyyy-mm-dd'));
insert into listens values(5 ,1543,to_date('2021-07-30','yyyy-mm-dd'));
insert into listens values(5 ,1543,to_date('2021-07-12','yyyy-mm-dd'));
insert into listens values(5 ,1582,to_date('2021-07-27','yyyy-mm-dd'));
insert into listens values(5 ,1582,to_date('2021-07-12','yyyy-mm-dd'));
insert into listens values(5 ,1582,to_date('2021-07-25','yyyy-mm-dd'));
insert into listens values(5 ,1582,to_date('2021-07-06','yyyy-mm-dd'));
insert into listens values(11,1781,to_date('2021-07-18','yyyy-mm-dd'));
insert into listens values(11,1781,to_date('2021-07-30','yyyy-mm-dd'));
insert into listens values(11,1781,to_date('2021-07-30','yyyy-mm-dd'));
insert into listens values(11,1781,to_date('2021-07-01','yyyy-mm-dd'));
insert into listens values(11,1935,to_date('2021-07-29','yyyy-mm-dd'));
insert into listens values(11,1935,to_date('2021-07-31','yyyy-mm-dd'));
insert into listens values(11,1935,to_date('2021-07-04','yyyy-mm-dd'));
insert into listens values(11,1076,to_date('2021-07-03','yyyy-mm-dd'));
insert into listens values(11,1076,to_date('2021-07-13','yyyy-mm-dd'));
insert into listens values(11,1076,to_date('2021-07-27','yyyy-mm-dd'));
insert into listens values(11,1886,to_date('2021-07-25','yyyy-mm-dd'));
insert into listens values(11,1886,to_date('2021-07-11','yyyy-mm-dd'));
insert into listens values(11,1886,to_date('2021-07-27','yyyy-mm-dd'));
insert into listens values(11,1543,to_date('2021-07-11','yyyy-mm-dd'));
insert into listens values(11,1543,to_date('2021-07-15','yyyy-mm-dd'));
insert into listens values(11,1543,to_date('2021-07-22','yyyy-mm-dd'));
insert into listens values(11,1543,to_date('2021-07-12','yyyy-mm-dd'));
insert into listens values(11,1543,to_date('2021-07-28','yyyy-mm-dd'));
insert into listens values(11,1582,to_date('2021-07-20','yyyy-mm-dd'));
insert into listens values(11,1582,to_date('2021-07-17','yyyy-mm-dd'));
insert into listens values(11,1582,to_date('2021-07-02','yyyy-mm-dd'));
insert into listens values(11,1582,to_date('2021-07-31','yyyy-mm-dd'));
insert into listens values(11,1582,to_date('2021-07-03','yyyy-mm-dd'));
insert into listens values(4 ,1781,to_date('2021-07-18','yyyy-mm-dd'));
insert into listens values(4 ,1781,to_date('2021-07-31','yyyy-mm-dd'));
insert into listens values(4 ,1781,to_date('2021-07-04','yyyy-mm-dd'));
insert into listens values(4 ,1935,to_date('2021-07-02','yyyy-mm-dd'));
insert into listens values(4 ,1935,to_date('2021-07-17','yyyy-mm-dd'));
insert into listens values(4 ,1935,to_date('2021-07-17','yyyy-mm-dd'));
insert into listens values(4 ,1935,to_date('2021-07-23','yyyy-mm-dd'));
insert into listens values(4 ,1076,to_date('2021-07-05','yyyy-mm-dd'));
insert into listens values(4 ,1076,to_date('2021-07-19','yyyy-mm-dd'));
insert into listens values(4 ,1076,to_date('2021-07-17','yyyy-mm-dd'));
insert into listens values(4 ,1886,to_date('2021-07-20','yyyy-mm-dd'));
insert into listens values(4 ,1886,to_date('2021-07-11','yyyy-mm-dd'));
insert into listens values(4 ,1543,to_date('2021-07-07','yyyy-mm-dd'));
insert into listens values(4 ,1543,to_date('2021-07-18','yyyy-mm-dd'));
insert into listens values(4 ,1543,to_date('2021-07-04','yyyy-mm-dd'));
insert into listens values(4 ,1543,to_date('2021-07-04','yyyy-mm-dd'));
insert into listens values(4 ,1582,to_date('2021-07-08','yyyy-mm-dd'));
insert into listens values(4 ,1582,to_date('2021-07-02','yyyy-mm-dd'));
insert into listens values(4 ,1582,to_date('2021-07-06','yyyy-mm-dd'));
insert into listens values(4 ,1582,to_date('2021-07-17','yyyy-mm-dd'));
insert into listens values(4 ,1582,to_date('2021-07-31','yyyy-mm-dd'));
insert into listens values(7 ,1781,to_date('2021-07-30','yyyy-mm-dd'));
insert into listens values(7 ,1781,to_date('2021-07-22','yyyy-mm-dd'));
insert into listens values(7 ,1781,to_date('2021-07-20','yyyy-mm-dd'));
insert into listens values(7 ,1935,to_date('2021-07-24','yyyy-mm-dd'));
insert into listens values(7 ,1935,to_date('2021-07-15','yyyy-mm-dd'));
insert into listens values(7 ,1886,to_date('2021-07-09','yyyy-mm-dd'));
insert into listens values(7 ,1886,to_date('2021-07-01','yyyy-mm-dd'));
insert into listens values(7 ,1886,to_date('2021-07-08','yyyy-mm-dd'));
insert into listens values(7 ,1543,to_date('2021-07-20','yyyy-mm-dd'));
insert into listens values(7 ,1543,to_date('2021-07-18','yyyy-mm-dd'));
insert into listens values(7 ,1543,to_date('2021-07-06','yyyy-mm-dd'));
insert into listens values(7 ,1582,to_date('2021-07-09','yyyy-mm-dd'));
insert into listens values(7 ,1582,to_date('2021-07-26','yyyy-mm-dd'));
insert into listens values(7 ,1582,to_date('2021-07-21','yyyy-mm-dd'));
insert into listens values(7 ,1582,to_date('2021-07-18','yyyy-mm-dd'));
insert into listens values(7 ,1582,to_date('2021-07-24','yyyy-mm-dd'));
insert into listens values(25,1781,to_date('2021-07-04','yyyy-mm-dd'));
insert into listens values(25,1781,to_date('2021-07-11','yyyy-mm-dd'));
insert into listens values(25,1781,to_date('2021-07-15','yyyy-mm-dd'));
insert into listens values(25,1781,to_date('2021-07-07','yyyy-mm-dd'));
insert into listens values(25,1935,to_date('2021-07-31','yyyy-mm-dd'));
insert into listens values(25,1935,to_date('2021-07-19','yyyy-mm-dd'));
insert into listens values(25,1935,to_date('2021-07-02','yyyy-mm-dd'));
insert into listens values(25,1076,to_date('2021-07-11','yyyy-mm-dd'));
insert into listens values(25,1076,to_date('2021-07-25','yyyy-mm-dd'));
insert into listens values(25,1076,to_date('2021-07-09','yyyy-mm-dd'));
insert into listens values(25,1076,to_date('2021-07-25','yyyy-mm-dd'));
insert into listens values(25,1076,to_date('2021-07-17','yyyy-mm-dd'));
insert into listens values(25,1886,to_date('2021-07-21','yyyy-mm-dd'));
insert into listens values(25,1886,to_date('2021-07-01','yyyy-mm-dd'));
insert into listens values(25,1886,to_date('2021-07-08','yyyy-mm-dd'));
insert into listens values(25,1886,to_date('2021-07-09','yyyy-mm-dd'));
insert into listens values(25,1886,to_date('2021-07-22','yyyy-mm-dd'));
insert into listens values(25,1543,to_date('2021-07-06','yyyy-mm-dd'));
insert into listens values(25,1543,to_date('2021-07-21','yyyy-mm-dd'));
insert into listens values(25,1543,to_date('2021-07-03','yyyy-mm-dd'));
insert into listens values(25,1582,to_date('2021-07-12','yyyy-mm-dd'));
insert into listens values(25,1582,to_date('2021-07-01','yyyy-mm-dd'));
insert into listens values(25,1582,to_date('2021-07-07','yyyy-mm-dd'));
insert into listens values(25,1582,to_date('2021-07-06','yyyy-mm-dd'));
insert into listens values(25,1582,to_date('2021-07-08','yyyy-mm-dd'));
insert into listens values(25,1582,to_date('2021-07-22','yyyy-mm-dd'));
insert into listens values(23,1076,to_date('2021-07-01','yyyy-mm-dd'));
insert into listens values(23,1076,to_date('2021-07-04','yyyy-mm-dd'));
insert into listens values(23,1076,to_date('2021-07-26','yyyy-mm-dd'));
insert into listens values(23,1076,to_date('2021-07-11','yyyy-mm-dd'));
insert into listens values(23,1886,to_date('2021-07-04','yyyy-mm-dd'));
insert into listens values(23,1886,to_date('2021-07-07','yyyy-mm-dd'));
insert into listens values(23,1886,to_date('2021-07-17','yyyy-mm-dd'));
insert into listens values(23,1543,to_date('2021-07-04','yyyy-mm-dd'));
insert into listens values(23,1543,to_date('2021-07-19','yyyy-mm-dd'));
insert into listens values(23,1582,to_date('2021-07-06','yyyy-mm-dd'));
insert into listens values(23,1582,to_date('2021-07-17','yyyy-mm-dd'));
insert into listens values(23,1582,to_date('2021-07-16','yyyy-mm-dd'));


insert into friendship values(13,20);
insert into friendship values(10,20);
insert into friendship values(17,21);
insert into friendship values(10,21);
insert into friendship values(5 ,17);
insert into friendship values(7 ,17);
insert into friendship values(10,13);
insert into friendship values(2 ,13);
insert into friendship values(11,13);
insert into friendship values(13,25);
insert into friendship values(6 ,10);
insert into friendship values(2 ,10);
insert into friendship values(5 ,10);
insert into friendship values(6 ,11);
insert into friendship values(4 ,6 );
insert into friendship values(6 ,25);
insert into friendship values(6 ,23);
insert into friendship values(2 ,5 );
insert into friendship values(2 ,11);
insert into friendship values(2 ,23);
insert into friendship values(4 ,23);

select * from listens;
select * from friendship;
*/



----------------------------------------------------------XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-----------------------------------
-- from a phone log history we need to find if the caller had done first and last call for the day to the same person.

-- script:
create table phonelog(
    Callerid int, 
    Recipientid int,
    Datecalled timestamp
);

insert into phonelog(Callerid, Recipientid, Datecalled)
values(1, 2, '2019-01-01 09:00:00.000'),
       (1, 3, '2019-01-01 17:00:00.000'),
       (1, 4, '2019-01-01 23:00:00.000'),
       (2, 5, '2019-07-05 09:00:00.000'),
       (2, 3, '2019-07-05 17:00:00.000'),
       (2, 3, '2019-07-05 17:20:00.000'),
       (2, 5, '2019-07-05 23:00:00.000'),
       (2, 3, '2019-08-01 09:00:00.000'),
       (2, 3, '2019-08-01 17:00:00.000'),
       (2, 5, '2019-08-01 19:30:00.000'),
       (2, 4, '2019-08-02 09:00:00.000'),
       (2, 5, '2019-08-02 10:00:00.000'),
       (2, 5, '2019-08-02 10:45:00.000'),
       (2, 4, '2019-08-02 11:00:00.000');

select *
from(select callerid,
case when fisrt_call_id = 1 then datecalled end as first_call,
case when last_call_id = 1 then datecalled end as last_call,
recipientid
from
(select *,
row_number() over(partition by callerid,extract(day from datecalled) order by datecalled) as fisrt_call_id ,
row_number() over(partition by callerid,extract(day from datecalled) order by datecalled) as last_call_id ,
first_value(Recipientid) over(partition by callerid,extract(day from datecalled) order by datecalled) as first_reciever,
last_value(Recipientid) over(partition by callerid,extract(day from datecalled)) as last_reciever
from phonelog)x
where first_reciever = last_reciever)z
where (first_call,last_call) is not null

-- select callerid,Recipientid,Datecalled from(select *,
-- FIRST_VALUE(Recipientid) over(partition by cast(datecalled as date) order by cast(datecalled as date)) as FIRST_VALUE,
-- last_value(Recipientid) over(partition by cast(datecalled as date) order by datecalled rows between unbounded preceding and unbounded following) as LAST_VALUE
-- from phonelog)x
-- where Recipientid=first_value and Recipientid=LAST_VALUE


-----------------------------------------------XXXXXXXXXXXXXXXX-------------------------------------------------------------

-- Write an SQL query to report the students (student_id, student _ name) being "quiet" in ALL exams .
-- A "quite" student is the one who took at least one exam and didn't score neither the high score nor the low score in any Of the exam.
--Don't return the student who has never taken any exam. Return the result table ordered by student_id.

-- scripts:
create table students
(
student_id int,
student_name varchar(20)
);
insert into students values
(1,'Daniel'),(2,'Jade'),(3,'Stella'),(4,'Jonathan'),(5,'Will');

create table exams
(
exam_id int,
student_id int,
score int);

insert into exams values
(10,1,70),(10,2,80),(10,3,90),(20,1,80),(30,1,70),(30,3,80),(30,4,90),(40,1,60)
,(40,2,70),(40,4,80);

select *
from students

select *
from exams



select distinct e.student_id
from students s
join exams e
on e.student_id = s.student_id
where e.student_id not in
(select student_id
from
(select e.student_id as student_id,s.student_name as student_name,
e.exam_id,e.score,
max(score) over(partition by exam_id order by score desc) as max_mark,
min(score) over(partition by exam_id order by score) as min_mark
from exams e
join students s
on e.student_id = s.student_id)x
where score in(max_mark,min_mark))


-----------------------------------------------XXXXXXXXXXXXXXXX-------------------------------------------------------------

-- Write an SQL query to find the winner in each group.
-- The winner in each group is the player who scored the maximum total points within the group. In the case Of a tie.
-- the lowest player_id wins.

create table players
(player_id int,
group_id int)

insert into players values (15,1);
insert into players values (25,1);
insert into players values (30,1);
insert into players values (45,1);
insert into players values (10,2);
insert into players values (35,2);
insert into players values (50,2);
insert into players values (20,3);
insert into players values (40,3);

create table matches
(
match_id int,
first_player int,
second_player int,
first_score int,
second_score int)

insert into matches values (1,15,45,3,0);
insert into matches values (2,30,25,1,2);
insert into matches values (3,30,15,2,0);
insert into matches values (4,40,20,5,2);
insert into matches values (5,35,50,1,1);

select *
from players


select *
from matches


-----------------------------------------------XXXXXXXXXXXXXXXX-------------------------------------------------------------













Create table  Trips (id int, client_id int, driver_id int, city_id int, status varchar(50), request_at varchar(50));
Create table Users (users_id int, banned varchar(50), role varchar(50));
Truncate table Trips;
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('1', '1', '10', '1', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('2', '2', '11', '1', 'cancelled_by_driver', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('3', '3', '12', '6', 'completed', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('4', '4', '13', '6', 'cancelled_by_client', '2013-10-01');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('5', '1', '10', '1', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('6', '2', '11', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('7', '3', '12', '6', 'completed', '2013-10-02');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('8', '2', '12', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('9', '3', '10', '12', 'completed', '2013-10-03');
insert into Trips (id, client_id, driver_id, city_id, status, request_at) values ('10', '4', '13', '12', 'cancelled_by_driver', '2013-10-03');
Truncate table Users;
insert into Users (users_id, banned, role) values ('1', 'No', 'client');
insert into Users (users_id, banned, role) values ('2', 'Yes', 'client');
insert into Users (users_id, banned, role) values ('3', 'No', 'client');
insert into Users (users_id, banned, role) values ('4', 'No', 'client');
insert into Users (users_id, banned, role) values ('10', 'No', 'driver');
insert into Users (users_id, banned, role) values ('11', 'No', 'driver');
insert into Users (users_id, banned, role) values ('12', 'No', 'driver');
insert into Users (users_id, banned, role) values ('13', 'No', 'driver');

-----------------------------------------------XXXXXXXXXXXXXXXX-------------------------------------------------------------
/* User purchase platform.
-- The table logs the spendings history of users that make purchases from an online shopping website which has a desktop 
and a mobile application.
-- Write an SQL query to find the total number of users and the total amount spent using mobile only, desktop only 
and both mobile and desktop together for each date.
*/

create table spending 
(
user_id int,
spend_date date,
platform varchar(10),
amount int
);

insert into spending values(1,'2019-07-01','mobile',100),(1,'2019-07-01','desktop',100),(2,'2019-07-01','mobile',100)
,(2,'2019-07-02','mobile',100),(3,'2019-07-01','desktop',100),(3,'2019-07-02','desktop',100);



select *
from spending

select spend_date,platform,count(distinct user_id) as total_users,sum(amount) as total_amount
from spending
where platform = 'mobile'
group by spend_date,platform
union all
select spend_date,platform,count(distinct user_id) as total_users,sum(amount) as total_amount
from spending
where platform = 'desktop'
group by spend_date,platform
union all
select spend_date,platform,count(distinct user_id) as total_users,sum(amount) as total_amount
from spending
where platform in ('desktop','mobile')
group by spend_date,platform
-----------------------------------------------XXXXXXXXXXXXXXXX-------------------------------------------------------------
-- Write an SQL query to find for each user, whether the brand of the second item (by date) they sold is their favorite brand. If a user sold less than two items, report the answer for that user as no.

-- It is guaranteed that no seller sold more than one item on a day.




drop table users

create table users (
user_id         int     ,
 join_date       date    ,
 favorite_brand  varchar(50));



drop table orders

 create table orders (
 order_id       int     ,
 order_date     date    ,
 item_id        int     ,
 buyer_id       int     ,
 seller_id      int 
 );


drop table items

 create table items
 (
 item_id        int     ,
 item_brand     varchar(50)
 );


 insert into users values (1,'2019-01-01','Lenovo'),(2,'2019-02-09','Samsung'),(3,'2019-01-19','LG'),(4,'2019-05-21','HP');

 insert into items values (1,'Samsung'),(2,'Lenovo'),(3,'LG'),(4,'HP');

 insert into orders values (1,'2019-08-01',4,1,2),(2,'2019-08-02',2,1,3),(3,'2019-08-03',3,2,3),(4,'2019-08-04',1,4,2)
 ,(5,'2019-08-04',1,3,4),(6,'2019-08-05',2,2,4);


select *
from users



select *
from items


select *
from orders

select seller_id,
case 
when rnk = 2 and item_brand = favorite_brand then 'Yes'
else 'No'
end as "2nd_item_fav_brand"
from
(select o.order_id,o.order_date,o.item_id,o.buyer_id,
u.user_id as seller_id,i.item_brand item_brand,u.favorite_brand favorite_brand,
dense_rank() over(partition by seller_id order by order_date) as rnk,
count(i.item_id)  over(partition by seller_id) as cnt
from orders o
right join items i
on o.item_id = i.item_id
right join users u
on o.seller_id = u.user_id)x
where rnk=2 or cnt < 2
order by seller_id

