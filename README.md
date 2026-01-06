# Ride-Hailing-SQL-Data-Analysis

This project analyzes cleaned ride-hailing data using SQL to answer key business questions related to
driver performance, rider retention, revenue growth, and operational efficiency between June 2021 and December 2024.

The goal is to demonstrate strong SQL querying skills, analytical thinking, and business insight generation.
## Project Overview
This project analyzes cleaned ride-hailing data using SQL to answer key business questions related to
driver performance, rider retention, revenue growth, and operational efficiency between June 2021 and December 2024.

The goal is to demonstrate strong SQL querying skills, analytical thinking, and business insight generation.

---

## Business Questions Answered
1. Top 10 longest rides by distance
2. Rider retention from 2021 to 2024
3. Quarterly revenue comparison and YoY growth
4. Driver ride consistency over time
5. City-level cancellation rates
6. Cashless rider behavior analysis
7. Top drivers by city revenue
8. Bonus eligibility evaluation for drivers

---

## Dataset Description
The analysis uses cleaned relational tables:

### Tables Used
- `rides`
- `drivers`
- `riders`

### Key Columns
- ride_date
- distance_km
- fare_amount
- payment_method
- ride_status
- rating
- signup_date

Missing values were handled during preprocessing, and only completed rides were used for revenue-based analysis.

---

## Tools & Technologies
- SQL (MySQL / PostgreSQL compatible)
- Git & GitHub
- PDF reporting
- Screenshot documentation

---

## Analysis Approach
- Used JOINs to connect ride, rider, and driver data
- Applied CTEs and window functions for advanced analysis
- Filtered date ranges for accurate period comparison
- Aggregated metrics to generate business KPIs

---

## Key Insights
- Rider retention from 2021 to 2024 shows strong platform loyalty
- Revenue growth peaked during specific quarters across years
- Drivers with high monthly consistency also generated higher revenue
- Certain cities experienced disproportionately high cancellation rates
- Cashless riders demonstrated higher ride frequency

---

## Repository Structure
data/ → Schema and data documentation
sql/ → SQL queries used for analysis
screenshots/ → Query results evidence
report/ → Final business report (PDF)


---

## How to Reproduce
1. Load cleaned data into a SQL database
2. Execute queries in `sql/ride_analysis_queries.sql`
3. Compare outputs with screenshots provided

---

## Author
**Adewuyi Blophed**  
Data Analyst

