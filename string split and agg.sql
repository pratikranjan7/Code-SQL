-- SCRIPT USED :- 

CREATE TABLE Flipkart_Data (
    User_Id  VARCHAR(512),
    Product_Name VARCHAR(512)
);

INSERT INTO Flipkart_Data (User_Id , Product_Name) VALUES ('1', 'Mobile,TV,Clothes');
INSERT INTO Flipkart_Data (User_Id , Product_Name) VALUES ('2', 'Mobile,Electronics,Home & Kitchen');
INSERT INTO Flipkart_Data (User_Id , Product_Name) VALUES ('3', 'Mobile,TV,Electronics');

select *,unnest(regexp_split_to_array(Product_Name,','))
from flipkart_data


select count(*),regexp_split_to_table(Product_Name,',')
from flipkart_data
group by regexp_split_to_table(Product_Name,',')




create table namaste_python (
file_name varchar(25),
content varchar(200)
);

delete from namaste_python;
insert into namaste_python values ('python bootcamp1.txt','python for data analytics 0 to hero bootcamp starting on Jan 6th')
,('python bootcamp2.txt','classes will be held on weekends from 11am to 1 pm for 5-6 weeks')
,('python bootcamp3.txt','use code NY2024 to get 33 percent off. You can register from namaste sql website. Link in pinned comment')


select count(*),regexp_split_to_table(content,' ') word
from namaste_python
group by regexp_split_to_table(content,' ')
having count(*) > 1
order by word desc




-- Create the table
CREATE TABLE New_Student (
    Name VARCHAR(512),
    "Joining Date" DATE -- Use DATE type for date storage
);

-- Insert data into the table
INSERT INTO New_Student (Name, "Joining Date") VALUES ('Roy', '2024-09-21');
INSERT INTO New_Student (Name, "Joining Date") VALUES ('Jordan', '2024-09-22');
INSERT INTO New_Student (Name, "Joining Date") VALUES ('Manish', '2024-09-23');
INSERT INTO New_Student (Name, "Joining Date") VALUES ('Pooja', '2024-09-22');
INSERT INTO New_Student (Name, "Joining Date") VALUES ('Shivani', '2024-09-23');
INSERT INTO New_Student (Name, "Joining Date") VALUES ('Kiran', '2024-09-23');
INSERT INTO New_Student (Name, "Joining Date") VALUES ('Harry', '2024-09-22');


select count(*),"Joining Date",string_agg(name,', ')
from new_student
group by "Joining Date"
having count(*) > 1
order by "Joining Date"



create table entries ( 
name varchar(20),
address varchar(20),
email varchar(20),
floor int,
resources varchar(10));

insert into entries 
values ('A','Bangalore','A@gmail.com',1,'CPU'),('A','Bangalore','A1@gmail.com',1,'CPU'),('A','Bangalore','A2@gmail.com',2,'DESKTOP')
,('B','Bangalore','B@gmail.com',2,'DESKTOP'),('B','Bangalore','B1@gmail.com',2,'DESKTOP'),('B','Bangalore','B2@gmail.com',1,'MONITOR')


select *
from entries

CREATE TABLE emp (
    empid INT,
    empname VARCHAR(50),
    salary INT,
    deptid INT
);

INSERT INTO emp VALUES 
(1, 'Nikitha', 45000, 206),
(2, 'Ashish', 42000, 207),
(3, 'David', 40000, 206),
(4, 'Ram', 50000, 207),
(5, 'John', 35000, 208),
(6, 'Mark', 50000, 207),
(7, 'Aravind', 39000, 208);

CREATE TABLE dept (
    deptid INT,
    deptname VARCHAR(50)
);

INSERT INTO dept VALUES 
(206, 'HR'),
(207, 'IT'),
(208, 'Finance');


select t2.deptname,string_agg(empname,', ')
from emp t1
join dept t2
on t1.deptid = t2.deptid
where salary in
(
select max(salary)
from emp
group by deptid
)
group by t2.deptname
