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

with cte as(SELECT 
employee_id,
activity_type,
activity_time,
DENSE_RANK() OVER (PARTITION BY employee_id, extract( DAY from activity_time) ORDER BY activity_time) AS session_id,
LEAD(activity_time) OVER (PARTITION BY employee_id, extract (DAY from activity_time ) ORDER BY activity_time) AS next_activity_time
from swipe
-- WHERE activity_type = 'login'
)


select
employee_id,
CAST(activity_time as date) as activity_date,
extract (hour from max(next_activity_time) - min(activity_time))total_hours,
sum (extract (hour from (next_activity_time - activity_time)))as hours_worked
FROM cte
WHERE activity_type = 'login'
GROUP BY employee_id,CAST(activity_time as date);


