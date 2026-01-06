SELECT current_database();

--NO 1 Top 10 longest rides (by distance) with driver name,
--rider name, pickup/dropoff cities, payment method
WITH r AS (
  SELECT r.* 
  FROM rides r
  WHERE r.pickup_time >= '2021-06-01'::timestamp
    AND r.pickup_time <= '2024-12-31 23:59:59'::timestamp
    AND r.distance_km IS NOT NULL
)
SELECT r.ride_id, r.distance_km,
       d.driver_id, d.name,
       ri.rider_id, ri.name,
       r.pickup_city, r.dropoff_city,
       p.method, p.amount AS paid_amount
FROM r
LEFT JOIN drivers d ON d.driver_id = r.driver_id
LEFT JOIN riders ri ON ri.rider_id = r.rider_id
LEFT JOIN payments p ON p.ride_id = r.ride_id
ORDER BY r.distance_km DESC
LIMIT 10;
