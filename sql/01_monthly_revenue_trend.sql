-- ============================================
-- Query 1: Monthly Revenue Trend
-- Purpose: Track revenue performance over time
-- Tables: orders
-- Author: [Jahidul-Anik]
-- Date: 2026-04-30
-- ============================================
SELECT
	Year,
    Month,
    count(*) as Total_Order,
    sum(Total_value_usd) as Revenue,
    avg(Total_value_usd) as Avg_Revenue,
    sum(Quantity_kg) as Total_Quantity_KG
From orders
Where Order_Status in ('Completed', 'Shipped')
Group By Year,Month
order by Year,Month;