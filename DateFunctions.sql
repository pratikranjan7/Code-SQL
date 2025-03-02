SELECT EXTRACT(YEAR FROM '2025-03-02'::date);
SELECT EXTRACT(MONTH FROM '2025-03-02'::date);
SELECT EXTRACT(DAY FROM '2025-03-02'::date);


-- DateAdd
date + INTERVAL 'value unit'
-- date: The date or timestamp value you want to modify.
-- value: The amount to add (can be positive or negative).
-- unit: The unit of time to add (e.g., day, month, year, etc.).
SELECT CURRENT_DATE + INTERVAL '5 days';
SELECT '2025-03-02'::date + INTERVAL '3 months'; --SELECT CAST('2025-03-02' AS date);
SELECT '2025-03-02'::date + INTERVAL '2 years';
SELECT CURRENT_TIMESTAMP + INTERVAL '4 hours 30 minutes 10 seconds';

SELECT CURRENT_DATE + INTERVAL '2 years';
SELECT CURRENT_DATE + INTERVAL '3 months' * 2;  -- Adding 2 quarters
SELECT CURRENT_DATE + INTERVAL '6 months';
SELECT CURRENT_DATE + INTERVAL '10 days';
SELECT CURRENT_DATE + INTERVAL '3 weeks';
SELECT CURRENT_TIMESTAMP + INTERVAL '5 hours';
SELECT CURRENT_TIMESTAMP + INTERVAL '30 minutes';
SELECT CURRENT_TIMESTAMP + INTERVAL '120 seconds';
SELECT CURRENT_TIMESTAMP + INTERVAL '0.5 seconds';  -- This adds 500 milliseconds


-- Datediff
SELECT AGE('2025-03-02'::timestamp, '2025-02-25'::timestamp);
SELECT EXTRACT(YEAR FROM AGE('2025-03-02'::date, '2025-02-25'::date)) AS year_diff;
SELECT EXTRACT(MONTH FROM AGE('2025-03-02'::date, '2025-02-25'::date)) AS month_diff;

--If you want the total number of months (including partial months)
SELECT (EXTRACT(YEAR FROM AGE('2025-03-02'::date, '2025-02-25'::date)) * 12) + 
EXTRACT(MONTH FROM AGE('2025-03-02'::date, '2025-02-25'::date)) AS total_month_diff;


SELECT EXTRACT(EPOCH FROM ('2025-03-02 12:00:00'::timestamp - '2025-03-02 10:00:00'::timestamp)) / 3600 AS hour_diff;
SELECT EXTRACT(EPOCH FROM ('2025-03-02 12:30:00'::timestamp - '2025-03-02 10:00:00'::timestamp)) / 60 AS minute_diff;
SELECT EXTRACT(EPOCH FROM ('2025-03-02 12:30:00'::timestamp - '2025-03-02 10:00:00'::timestamp)) AS second_diff;
SELECT EXTRACT(EPOCH FROM ('2025-03-02 12:30:00.123'::timestamp - '2025-03-02 12:00:00.000'::timestamp)) * 1000 AS millisecond_diff;
SELECT (end_date - start_date) / 7 AS week_diff
FROM your_table;


-- SELECT EXTRACT(EPOCH FROM '2025-03-02 12:00:00'::timestamp);




-- Datename
-- Date and Time Format Patterns:
SELECT TO_CHAR('2025-03-02'::date, 'Day');
Sunday



-- General Date/Time Patterns:
-- AD / BC: Era indicator, either AD or BC.
-- AM / PM: Meridian indicator (AM or PM) for time values.
-- CC: Century indicator (e.g., 20 for the 21st century).
-- DY / DYY: Abbreviated day of the week (e.g., "Mon").

-- DAY / DY: Full day name (e.g., "Monday"). 
--Note: 'Day' gives the full day name, right-aligned by default. If you want to trim the spaces, use 'FMDay'.

-- DDD: Day of the year (1–366).
-- DD: Day of the month (1–31).
-- D: Day of the week (1–7, 1 = Sunday).
-- DY: Abbreviated day name (e.g., "Mon").
-- FM: Prefix to avoid padding the result (removes extra spaces).




-- Month Patterns:
-- MON: Abbreviated month name (e.g., "Jan").
-- MONTH: Full month name (e.g., "January").
SELECT TO_CHAR('2025-03-02'::date, 'FMMonth');

-- MM: Month as a two-digit number (01–12).
-- MMM: Abbreviated month name (e.g., "Jan").
-- M: Month as a number (1–12).





-- Year Patterns:
-- YYYY: 4-digit year (e.g., 2025).
-- YYY: Year with 3 digits (e.g., 025 for 2025).
-- YY: Last two digits of the year (e.g., 25 for 2025).
-- Y: Single-digit year (e.g., 5 for 2025).


-- Time Patterns:
-- HH: Hour in 12-hour format (01–12).
-- HH12: Hour in 12-hour format (01–12).
-- HH24: Hour in 24-hour format (00–23).
-- MI: Minute (00–59).
-- SS: Second (00–59).
-- MS: Millisecond (000–999).
-- US: Microsecond (000000–999999).
-- AM / PM: Meridian indicator for 12-hour format.
-- TZ: Timezone abbreviation.
-- Day of the Week and Time of Day:
-- DY: Abbreviated day name (e.g., "Mon").
-- D: Day of the week (1–7, where 1 = Sunday).
-- WW: Week number of the year (1–52).
-- DOW: Day of the week, number (0–6, where 0 = Sunday).
SELECT 
    ((EXTRACT(DOW FROM '2025-03-02'::date) + 6) % 7) + 1 AS monday_start_dow;

-- HH12 / HH24: Hour in 12-hour and 24-hour formats.


-- Time Zone Patterns:
-- TIMEZONE: The time zone, as an offset or name.
-- TIMEZONE_HOUR: The hour part of the time zone offset (e.g., +02).
-- TIMEZONE_MINUTE: The minute part of the time zone offset.




--GETDATE()
SELECT CURRENT_TIMESTAMP;
SELECT NOW();

-- GETUTCDATE()
SELECT CURRENT_TIMESTAMP AT TIME ZONE 'UTC';
