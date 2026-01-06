-- Top 3 drivers in each city by total revenue
--between June 2021 and Dec 2024

--If a driver picks up in multiple cities, revenue counted for pickup
--city of that trip.

WITH windowed AS (
  SELECT r.*, p.method, p.amount
  FROM rides r
  LEFT JOIN payments p ON p.ride_id = r.ride_id
  WHERE r.pickup_time BETWEEN '2021-06-01'::timestamp AND '2024-12-31 23:59:59'::timestamp
    AND r.status = 'completed'
),
revenue_by_driver_city AS (
  SELECT lower(trim(pickup_city)) AS city,
         driver_id,
         SUM(COALESCE(fare, amount, 0)) AS total_revenue
  FROM windowed
  GROUP BY 1,2
)
SELECT d.city, d.driver_id, d.name AS driver_name, total_revenue
FROM (
  SELECT *,
    row_number() OVER (PARTITION BY city ORDER BY total_revenue DESC) AS rn
  FROM revenue_by_driver_city
) r
JOIN drivers d ON d.driver_id = r.driver_id
WHERE rn <= 3
ORDER BY city, rn;
