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


-- Write a query to display the records which have 3 or more consecutive rows
L --with the amount of people more than 100(inclusive) each day
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



