SELECT current_database();
-- 2.	How many riders who signed up in 2021 still took rides in 2024?

SELECT COUNT(DISTINCT r.rider_id) AS riders_2021_with_rides_in_2024
FROM riders ri
JOIN rides r ON r.rider_id = ri.rider_id
WHERE ri.signup_date BETWEEN '2021-01-01' AND '2021-12-31'
  AND r.pickup_time BETWEEN '2024-01-01'::timestamp AND '2024-12-31 23:59:59'::timestamp;

  
