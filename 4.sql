SELECT current_database();

-- For each driver, average monthly rides 
-- since signup; top 5 drivers by consistency (rides per active month)
WITH rides_window AS (
  SELECT * FROM rides
  WHERE pickup_time BETWEEN '2021-06-01'::timestamp AND '2024-12-31 23:59:59'::timestamp
    AND status = 'completed'
),
drivers_counts AS (
  SELECT driver_id, COUNT(*) AS total_rides
  FROM rides_window
  GROUP BY driver_id
),
driver_months AS (
  SELECT d.driver_id,
         greatest(1,
           (EXTRACT(YEAR FROM age('2024-12-31'::date, d.signup_date)) * 12
            + EXTRACT(MONTH FROM age('2024-12-31'::date, d.signup_date))
           )::INT
         ) AS months_active
  FROM drivers d
)
SELECT d.driver_id,
       d.name,
       coalesce(dc.total_rides,0) AS total_rides,
       dm.months_active,
       ROUND(coalesce(dc.total_rides) / dm.months_active, 2) AS rides_per_month
FROM drivers d
LEFT JOIN drivers_counts dc ON dc.driver_id = d.driver_id
JOIN driver_months dm ON dm.driver_id = d.driver_id
ORDER BY rides_per_month DESC
LIMIT 5;
