-- ============================================
-- Query 2: Top Performers with Window Function (Rank)
-- Purpose: Calculate both the rank and the market share (percentage of total) for each fabric type
-- Tables: orders
-- Author: [Jahidul-Anik]
-- Date: 2026-04-30
-- ============================================
select
	Fabric_Type,
    rank() over( order by sum(total_value_usd) desc) as Revenue_Rank,
    round( 
    sum(total_value_usd)*100.0/sum(sum(total_value_usd)) over(),2
    ) as Pct_of_Total
From orders
Where Order_Status IN ('completed','shipped')
group by Fabric_Type
order by revenue_rank ASC;