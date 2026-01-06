-- Cancellation
-- rate per city and city with highest cancellation rate

--We define cancellation rate = cancelled_trips / total_trips where city is picku

WITH city_stats AS (
  SELECT
    lower(trim(coalesce(pickup_city,'unknown'))) AS city,
    COUNT(*) FILTER (WHERE status = 'cancelled')::numeric AS cancelled_count,
    COUNT(*)::numeric AS total_count
  FROM rides
  WHERE pickup_time BETWEEN '2021-06-01'::timestamp AND '2024-12-31 23:59:59'::timestamp
  GROUP BY 1
)
SELECT city,
       cancelled_count,
       total_count,
       CASE WHEN total_count = 0 THEN NULL ELSE ROUND(cancelled_count/total_count::numeric * 100, 2) END AS cancellation_rate_pct
FROM city_stats
ORDER BY cancellation_rate_pct DESC NULLS LAST;


-- Top city:


SELECT city,
       cancellation_rate_pct
FROM (
WITH city_stats AS (
  SELECT
    lower(trim(coalesce(pickup_city,'unknown'))) AS city,
    COUNT(*) FILTER (WHERE status = 'cancelled')::numeric AS cancelled_count,
    COUNT(*)::numeric AS total_count
  FROM rides
  WHERE pickup_time BETWEEN '2021-06-01'::timestamp AND '2024-12-31 23:59:59'::timestamp
  GROUP BY 1
)
SELECT city,
       cancelled_count,
       total_count,
       CASE WHEN total_count = 0 THEN NULL ELSE ROUND(cancelled_count/total_count::numeric * 100, 2) END AS cancellation_rate_pct
FROM city_stats
)
ORDER BY cancellation_rate_pct DESC NULLS LAST
LIMIT 1;

