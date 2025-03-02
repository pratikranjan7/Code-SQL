-- charindex
SELECT POSITION('pg' IN 'pgAdmin');

SELECT CONCAT('John', ' + ', 'Doe');

SELECT CONCAT_WS(',', 'John', 'Paul', 'Doe');

SELECT LEFT('pgAdmin', 4);

SELECT RIGHT('pgAdmin', 4);

SELECT LENGTH('pgAdmin');

SELECT LOWER('PGADMIN');

SELECT UPPER('pgadmin');
SELECT LTRIM('   pgAdmin');

SELECT RTRIM('pgAdmin   ');

SELECT REPLACE('pgAdmin', 'pg', 'Postgres');

SELECT REVERSE('pgAdmin');

SELECT SUBSTRING('pgAdmin' FROM 1 FOR 4);

-- TRIM([LEADING | TRAILING | BOTH] trim_character FROM string)

SELECT TRIM('   pgAdmin   ');
SELECT TRIM(LEADING FROM '   pgAdmin');
SELECT TRIM(TRAILING FROM 'pgAdmin   ');
SELECT TRIM(BOTH '*' FROM '***pgAdmin***');





