-- Top 10 drivers qualified for bonuses (criteria)
--Criteria:
--at least 30 rides completed (within analysis window?)
--average rating ≥ 4.5 (average of trip-level rating for completed trips)
--cancellation rate under 5% (cancelled trips / total trips < 0.05)

select *
from drivers;

WITH windowed AS (
  SELECT * FROM rides
  WHERE pickup_time BETWEEN '2021-06-01'::timestamp AND '2024-12-31 23:59:59'::timestamp
),
driver_stats AS (
  SELECT d.driver_id,
         COUNT(*) FILTER (WHERE status = 'completed') AS completed_rides,
         AVG(rating) FILTER (WHERE rating IS NOT NULL) AS avg_rating,
         COUNT(*) FILTER (WHERE status = 'cancelled') AS cancelled_rides,
         COUNT(*) AS total_rides
  FROM windowed
  JOIN drivers d ON d.driver_id = d.driver_id
  GROUP BY d.driver_id
)
SELECT ds.driver_id,
       d.name AS driver_name,
       completed_rides,
       ROUND(avg_rating::numeric,2) AS avg_rating,
       cancelled_rides,
       total_rides,
       ROUND( CASE WHEN total_rides = 0 THEN NULL ELSE cancelled_rides::numeric / total_rides END::numeric * 100, 2) AS cancellation_rate_pct
FROM driver_stats ds
JOIN drivers d ON d.driver_id = ds.driver_id
WHERE completed_rides >= 30
  AND COALESCE(avg_rating,0) >= 4.5
  AND (CASE WHEN total_rides = 0 THEN 1 ELSE cancelled_rides::numeric / total_rides END) < 0.05
ORDER BY completed_rides DESC, avg_rating DESC
LIMIT 10;
