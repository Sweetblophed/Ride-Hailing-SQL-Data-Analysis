SELECT current_database();

-- Compare quarterly revenue between 
-- 2021, 2022, 2023, 2024. Which quarter had the biggest YoY growth?

WITH windowed_rides AS (
  SELECT r.*
  FROM rides r
  WHERE r.pickup_time BETWEEN '2021-06-01'::timestamp AND '2024-12-31 23:59:59'::timestamp
    AND r.status = 'completed'
),
rev_by_q AS (
  SELECT
    EXTRACT(YEAR FROM pickup_time)::INT AS yr,
    EXTRACT(QUARTER FROM pickup_time)::INT AS q,
    SUM(fare) AS revenue
  FROM windowed_rides
  WHERE fare IS NOT NULL
  GROUP BY 1,2
)
SELECT
  re.yr, re.q,
  re.revenue,
  LAG(re.revenue) OVER (PARTITION BY re.q ORDER BY re.yr) AS revenue_prev_year,
  CASE
    WHEN LAG(re.revenue) OVER (PARTITION BY re.q ORDER BY re.yr) IS NULL THEN NULL
    WHEN LAG(re.revenue) OVER (PARTITION BY re.q ORDER BY re.yr) = 0 THEN NULL
    ELSE (re.revenue - LAG(re.revenue) OVER (PARTITION BY re.q ORDER BY re.yr)) / LAG(re.revenue) OVER (PARTITION BY re.q ORDER BY re.yr)
  END AS yoy_growth_pct
FROM rev_by_q re
ORDER BY re.yr, re.q;

-- The single year with quarter
WITH rev_by_q AS
SELECT yr, q, revenue, yoy_growth_pct
FROM (
  SELECT re.yr, re.q, re.revenue,
         (re.revenue - LAG(re.revenue) OVER (PARTITION BY re.q ORDER BY re.yr)) / NULLIF(LAG(re.revenue) OVER (PARTITION BY re.q ORDER BY re.yr),0) AS yoy_growth_pct
  FROM rev_by_q re
) r
ORDER BY yoy_growth_pct DESC NULLS LAST
LIMIT 1;

