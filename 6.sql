-- Riders with >10 rides but never paid with cash

-- Interpretation: count trips for each rider (completed trips) > 10 and no
-- payment record on any of their trips has payment_method = 'cash'.

WITH rides_window AS (
  SELECT * FROM rides
  WHERE pickup_time BETWEEN '2021-06-01'::timestamp AND '2024-12-31 23:59:59'::timestamp
    AND status = 'completed'
),
rider_counts AS (
  SELECT r.rider_id, COUNT(*) AS rides_count
  FROM rides_window r
  GROUP BY r.rider_id
),
rider_cash_flag AS (
  SELECT r.rider_id,
         MAX(CASE WHEN p.method = 'cash' THEN 1 ELSE 0 END) AS ever_paid_cash
  FROM rides_window r
  LEFT JOIN payments p ON p.ride_id = r.ride_id
  GROUP BY r.rider_id
)
SELECT ri.rider_id, name, rc.rides_count
FROM rider_counts rc
JOIN rider_cash_flag cf ON cf.rider_id = rc.rider_id
LEFT JOIN riders ri ON ri.rider_id = rc.rider_id
WHERE rc.rides_count > 10 AND COALESCE(cf.ever_paid_cash,0) = 0
ORDER BY rc.rides_count DESC;
