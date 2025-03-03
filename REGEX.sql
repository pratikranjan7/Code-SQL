-- Create a 'users' table with sample data
CREATE TABLE users
(
    id SERIAL PRIMARY KEY,
    username VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    address VARCHAR(255)
);

-- Insert sample data into the 'users' table
INSERT INTO users
    (username, email, phone, address)
VALUES
    ('john_doe', 'john.doe@example.com', '123-456-7890', '123 Elm St, Springfield, IL'),
    ('jane_smith', 'jane.smith@website.org', '987-654-3210', '456 Oak St, Springfield, IL'),
    ('alice_jones', 'alice.jones123@gmail.com', '555-666-7777', '789 Pine St, Smalltown, TX'),
    ('bob_white', 'bob_white@company.net', '321-432-5432', '101 Maple Ave, Othertown, CA'),
    ('carol_green', 'carol.green@web.org', '555-123-4567', '202 Birch Rd, Villagetown, NY');

-- Create a 'products' table with sample data
CREATE TABLE products
(
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    description TEXT,
    price DECIMAL(10, 2)
);

-- Insert sample data into the 'products' table
INSERT INTO products
    (product_name, description, price)
VALUES
    ('Laptop', 'A high-performance laptop with 16GB RAM and 512GB SSD.', 999.99),
    ('Phone', 'A sleek smartphone with a 6.5-inch display and 128GB storage.', 799.99),
    ('Smartwatch', 'A fitness-focused smartwatch with heart rate monitor and GPS.', 199.99),
    ('Headphones', 'Noise-canceling over-ear headphones with Bluetooth connectivity.', 150.00),
    ('Tablet', 'A lightweight tablet with a 10-inch screen and 64GB storage.', 499.99);

-- Create a 'logs' table with sample data
CREATE TABLE logs
(
    log_id SERIAL PRIMARY KEY,
    log_level VARCHAR(10),
    message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data into the 'logs' table
INSERT INTO logs
    (log_level, message)
VALUES
    ('INFO', 'User john_doe logged in successfully.'),
    ('ERROR', 'Failed to connect to database for user alice_jones.'),
    ('WARNING', 'User jane_smith attempted to access restricted area.'),
    ('INFO', 'User bob_white updated profile settings.'),
    ('ERROR', 'Unable to send email to user carol_green.');



select *
from users
where username like '%o_'

SELECT *
FROM users
WHERE username
~ '.o.$';




select *
from users
where username
~ 'o?h'

-- Match if the email contains "example.com" (case-sensitive)
SELECT username, email
FROM users
WHERE email
~ 'EXAMPLE.COM';


-- Match if the email contains "example.com" (case-insensitive)
SELECT username, email
FROM users
WHERE email
~* 'example.com';

SELECT username, email
FROM users
WHERE email
~* 'EXAMPLE.COM';

-- Match if the email does not contain "example.com" (case-sensitive)
SELECT username, email
FROM users
WHERE email
!~ 'example.com';

-- "jane.smith@website.org"

-- Match if the email does not contain "example.com" (case-insensitive)
SELECT username, email
FROM users
WHERE email
!~* 'example.com';


-- Creating the employees table
CREATE TABLE employees_regex
(
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    job_title VARCHAR(50),
    salary NUMERIC(10, 2),
    hire_date DATE
);


-- Inserting a large set of data (100 rows) for practice
INSERT INTO employees_regex
    (first_name, last_name, email, job_title, salary, hire_date)
SELECT
    CASE WHEN random() < 0.5 THEN 'John' ELSE 'Jane' END AS first_name,
    CASE 
        WHEN random() < 0.3 THEN 'Doe'
        WHEN random() < 0.6 THEN 'Smith'
        WHEN random() < 0.8 THEN 'Johnson'
        ELSE 'Brown'
    END AS last_name,
    LOWER(CONCAT(
        CASE WHEN random() < 0.5 THEN 'john' ELSE 'jane' END,
        '.',
        CASE 
            WHEN random() < 0.3 THEN 'doe'
            WHEN random() < 0.6 THEN 'smith'
            WHEN random() < 0.8 THEN 'johnson'
            ELSE 'brown'
        END,
        '@example.com'
    )) AS email,
    CASE 
        WHEN random() < 0.2 THEN 'Software Developer'
        WHEN random() < 0.4 THEN 'Project Manager'
        WHEN random() < 0.6 THEN 'Data Scientist'
        WHEN random() < 0.8 THEN 'Data Analyst'
        ELSE 'HR Manager'
    END AS job_title,
    ROUND(30000 + (random() * 70000)
::NUMERIC, 2) AS salary,  -- Casting to NUMERIC
    NOW
() -
(random
() * 1000 * INTERVAL '1 day') AS hire_date
FROM generate_series
(1, 100);



-- This creates 100 random rows with first names like John, Jane, last names like Doe, Smith, etc.
-- It randomly assigns job titles like Software Developer, Project Manager, etc.
-- Salaries range from $30,000 to $100,000.
-- Hire dates are randomly distributed within the past 1000 days.


select *
from employees_regex

-- What are the names of employees that start with "J" and end with "n"?

select *
from employees_regex
where first_name
~* '^j.*n$'

-- Which product names have "a" as the second letter?

select *
from employees_regex
where first_name
~* '.a'

-- Which cities start with "A" and have at least three characters?

select *
from employees_regex
where last_name
~ '^S...'

-- What are the email addresses that end with "@gmail.com"?
CREATE TABLE users_regex
(
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL
);

INSERT INTO users_regex
    (email)
VALUES
    ('john.doe@gmail.com'),
    ('jane.smith@yahoo.com'),
    ('alice@example.com'),
    ('bob@gmail.com');


select *
from users_regex
where email
~ '@gmail.com$'


select *
from employees_regex

-- Which usernames consist of exactly 3 characters followed by "@gmail.com"?
select *
from users_regex
-- where email ~ '.'
where email
~ '^[a-zA-Z]{3}@gmail.com$'



CREATE TABLE media
(
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    type VARCHAR(50) NOT NULL
    -- 'movie' or 'song'
);


INSERT INTO media
    (title, type)
VALUES
    ('The Jungle Book', 'movie'),
    ('The Godfather', 'movie'),
    ('Aha', 'song'),
    ('Axe', 'song'),
    ('Brave', 'movie'),
    ('Shrek', 'movie'),
    ('Happy Feet', 'movie'),
    ('Peter Pan', 'movie'),
    ('Fantasy Island', 'movie'),
    ('Booksmart', 'movie'),
    ('Land of the Lost', 'movie'),
    ('Bark', 'movie'),
    ('Solo', 'movie'),
    ('Silo', 'movie');


-- Which movie titles starts with  the word "The"?
select *
from media
where title
~ '^The'

-- Which movie names contain the word "book"?



SELECT *
FROM media
WHERE title
~* '\\bbook\\b';


-- Which movie titles contain the word "The"?

SELECT *
FROM media
WHERE title
~* 'the';

-- Which song titles are exactly three characters long and start with "A"?
SELECT *
FROM media
where title
~* '^a..$'

-- Which movie names have "r" as the 3rd character?
SELECT *
FROM media
where title
~* '^..r'

-- Which movie names contain at least two occurrences of the letter "p"?
SELECT *
FROM media
where title
~* 'p{1,}'

SELECT *
FROM media
where title
~* 'p{2,}'

-- Which movie titles contain the word "fantasy"?

SELECT *
FROM media
where title
~* 'fantasy'


-- Which movie end with "land"?
SELECT *
FROM media
where title
~* 'land$'

-- Which movie names are exactly four characters long, start with "B", and end with "k"?
SELECT *
FROM media
where title
~* '^b[a-z]{2}k$'

-- Which movie names start with "S" and end with "o", with exactly one character in between?

SELECT *
FROM media
where title
~* '^s[a-z]{2}o$'


-- Easy Level Questions

-- Find all employees whose first name starts with the letter "J".

-- Output: A list of employees where the first_name starts with "J", such as John, Jane, etc.
-- Find all employees whose job title contains the word "Manager".

-- Output: A list of employees with "Manager" in their job_title, such as Project Manager, HR Manager, etc.
-- Find all employees whose email ends with "@example.com".

-- Output: A list of employees whose email column ends with "@example.com".





-- Medium Level Questions
-- Find all employees whose last name contains "ohn" (case-insensitive).

SELECT *
FROM employees_regex
where last_name
~* 'ohn'

-- Output: A list of employees whose last_name contains "ohn", like Johnson, Brown, etc.
-- Find all employees whose salary is between $50,000 and $80,000.
SELECT *
FROM employees_regex
where last_name
~* '[on]' and salary between 50000 and 80000

-- Output: A list of employees whose salary is between $50,000 and $80,000.
-- Find all employees whose first name starts with a vowel (A, E, I, O, U).

SELECT *
FROM employees_regex
where first_name
~* '^[aeiou]' and salary between 50000 and 80000

-- Output: A list of employees whose first_name starts with a vowel (A, E, I, O, U).







-- Hard Level Questions
-- Find employees whose job title starts with "Data" and ends with "Analyst" (using regex).
SELECT *
FROM employees_regex
where job_title
~* '^data.*analyst$'

-- Output: A list of employees with job_title starting with "Data" and ending with "Analyst", like Data Analyst, Data Scientist Analyst, etc.
-- Find all employees who were hired in the last 30 days.

-- Output: A list of employees whose hire_date is within the last 30 days.
-- Find all employees whose first name contains either "John" or "Jane" (use regex).
SELECT *
FROM employees_regex
where first_name
~* 'john' or first_name  ~* 'jane'

-- Output: A list of employees whose first_name contains either "John" or "Jane".
-- Find employees who have a first name that is exactly 4 characters long and last name that is 5 characters long.
SELECT *
FROM employees_regex
where first_name
~* '^[a-z]{4}$' and last_name  ~* '^[a-z]{5}$'



-- Output: A list of employees with a first_name of 4 characters and a last_name of 5 characters.
-- Additional Advanced Questions
-- Find employees whose email address starts with a letter from A-M and ends with ".com".

-- Output: A list of employees whose email starts with A-M and ends with ".com".
-- Find employees whose first name starts with 'J' and whose salary is greater than $60,000.

-- Output: A list of employees whose first_name starts with "J" and have a salary greater than $60,000.
-- Find employees who have been hired in the last 6 months and have "Developer" in their job title.

-- Output: A list of employees who were hired within the last 6 months and whose job_title contains "Developer".
-- Find employees whose last name contains either 'son' or 'man' (case-insensitive).

-- Output: A list of employees whose last_name contains either "son" or "man", such as Johnson, Brown, etc.
-- Find employees whose email contains a domain name that starts with "e" (case-insensitive).

-- Output: A list of employees whose email domain name starts with the letter "e", like "example.com".


/* -- Problem Statement: Find valid email id's
	A consumer electronics store in Warsaw, stores all the customer feedback in the feedback table. 
	The email id's mentioned by customers are then used by the store to contact customers to promote any upcoming sales.
	However, some of the customers while sharing feedback enter invalid email addresses.
	Write an SQL query to identify and return all the valid email address from the feedback table.

	A valid email address needs to have 3 parts:
		Part 1 is the username. A username can contain upper or lower case letters, numbers and special characters like underscore character "_", dot ".", hyphen "-". Username should always start with a letter. 
		Part 2 is the "@" symbol.
		Part 3 is the domain which needs to have 2 sub parts. First part contains upper or lower case letters followed by a dot symbol and then followed by 2 or 3 letters.
*/

drop table if exists feedback;
create table feedback
(
    feedback_id int,
    cust_name varchar(20),
    email varchar(50),
    rating float,
    remarks varchar(200)
);
insert into feedback
values(1, 'Zohan', 'zohan@2024@gmail.com', 4, 'good');
insert into feedback
values(2, 'Keyaan', 'keyaan.TR@gmail.com', 5, 'very good');
insert into feedback
values(3, 'Zayn', 'ZAYN...@gmail', 3, 'ok');
insert into feedback
values(4, 'Emir', 'emir-#1@outlook.com', 4, 'ok');
insert into feedback
values(5, 'Ashar', 'Ashar-@hotmail.DE', 4, 'nice');
insert into feedback
values(6, 'Zoya', 'zoya@techTFQ.org', 4, 'great');
insert into feedback
values(7, 'Kabir', 'kabir.com@-gmail.com', 2, 'bad');
insert into feedback
values(8, 'Ayaan', 'ayaan123@company.net', 1, 'poor');
insert into feedback
values(9, 'Meir', 'meir123@', 1.5, 'poor');
insert into feedback
values(10, 'Noah', 'noah_.com@.com', 3.5, 'bad');
insert into feedback
values(11, 'Idris', 'i@gmail.com', 5, 'excellent');
insert into feedback
values(12, 'Arhaan', 'arhaan$gmail.com', 5, 'awesome');
insert into feedback
values(13, 'Abrar', 'abrar123@gmail.comm', 5, 'awesome');


select *
from feedback


SELECT *
FROM feedback
where email
~ '^[A-Za-z]+[-_0-9a-zA-Z\.]*@{1}[a-zA-Z]+\.[a-zA-Z]{2,3}$'

SELECT *
FROM feedback
WHERE email
~* '^[a-zA-Z]+(.|_|-|[0-9]*)?[a-zA-Z]{0,}@{1}[a-zA-Z]+\.[a-z]{2,3}$'


drop table users_email

CREATE TABLE users_email
(
    user_id INT,
    name VARCHAR(255),
    mail VARCHAR(255)
);

INSERT INTO users_email
    (user_id, name, mail)
VALUES
    (1, 'Winston', 'winston@leetcode.com'),
    (2, 'Jonathan', 'jonathanisgreat'),
    (3, 'Annabelle', 'bella-@leetcode.com'),
    (4, 'Sally', 'sally.come@leetcode.com'),
    (5, 'Marwan', 'quarz#2020@leetcode.com'),
    (6, 'David', 'david69@gmail.com'),
    (7, 'Shapiro', '.shapo@leetcode.com'),
    (8, 'Benjamin', 'Benjamin._2@leetcode.com'),
    (9, 'Yaffah', 'Yaffah_-w51KKjZ@leetcode.com'),
    (10, 'Levi', 'Levi_.r@leetcode.com'),
    (11, 'Yehudah', 'Yehudah._Il@leetcode.com'),
    (12, 'Gavriel', 'Gavriel5bpr@leetcode.com')
;

-- Query to filter valid emails (as requested in the previous response)



SELECT *
FROM users_email
where mail
~ '^[a-zA-Z][-_0-9a-zA-Z\.]*@leetcode\.com$'








CREATE TABLE TEST
(
    PRICE TEXT
);

INSERT INTO TEST
    (PRICE)
VALUES
    ('INR500'),
    ('INR 600'),
    ('690IN R66'),
    ('757EURO'),
    ('  676INR'),
    ('DLR77.99');


SELECT price, regexp_replace(regexp_replace(price,'\s+','','g'),'[^\d]+','','g')
FROM TEST;








