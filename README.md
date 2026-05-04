# Bangladesh Textile Export Analytics Dashboard

## Overview
Power BI dashboard analyzing **$53.4M in Bangladesh textile export data** (2023–2024) 
across 45 global buyers, 12 fabric types, and 8 regions. Built as a portfolio project 
during my transition from 8 years in fabric marketing to data analytics.

**Key Insight:** Revenue grew 102.7% year-over-year with clear seasonal demand cycles. 
EU_Western buyers drive 35% of revenue, while Silk_Blend and Linen fabrics command 
premium pricing.

---

## Tools & Technologies
- **SQL (MySQL)** — Data extraction, window functions, CTEs, RFM segmentation
- **Power BI** — DAX measures, time intelligence, interactive dashboards
- **Python** — Synthetic dataset generation with realistic industry patterns

---

## Dashboard Pages

| Page | Purpose | Key Visuals |
|------|---------|-------------|
| **Executive Summary** | Business performance overview | Revenue trend, YoY growth, regional breakdown |
| **Product Analysis** | Fabric performance & seasonality | 60-day rolling revenue, quarterly matrix, fabric ranking |
| **Buyer Insights** | Customer segmentation & behavior | Top 10 buyers, country revenue, tier distribution |
| **Methodology** | Technical documentation | SQL queries, data model, DAX measures |

---

## SQL Highlights

Query 1: Monthly Revenue Trend
Purpose: Track revenue performance over time
Tables: orders
Author: [Jahidul-Anik]
Date: 2026-04-30

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


Query 2: Top Performers with Window Function (Rank)
Purpose: Calculate both the rank and the market share (percentage of total) for each fabric type
Tables: orders
Author: [Jahidul-Anik]
Date: 2026-04-30

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

Query 3: Buyer RFM Segmentation
Purpose: raw transactional data, transformed it into behavioral metrics, graded those metrics on a curve, and assigned plain-English marketing labels
Tables: buyers & orders
Author: [Jahidul-Anik]
Date: 2026-05-02

	With 
		Buyer_matrics as (
			select 
				b.Buyer_ID,
				b.Region,
				b.Tier,
				max(o.Order_Date) as Last_order_date,
				count(*) as Total_orders,
				sum(o.Total_Value_USD) as Total_revenue,
				avg(o.Total_Value_USD) as Avg_revenue,
				datediff('2024-12-31', max(o.Order_Date)) as Regency_day
			From buyers b
			Join orders o on b.Buyer_ID=o.Buyer_ID
			Where o.Order_Status in ('Completed' & 'Shipped')
			group by b.Buyer_ID, b.Region, b.Tier
			),
		scored as
			(select 
			*, 
			ntile(4) over (order by Regency_day desc) as R_score,
			ntile(4) over (order by Total_orders) as F_score,
			ntile(4) over (order by Total_revenue) as M_score
			from Buyer_matrics)
 
	 select
		*,
	    CASE
			When R_score >= 3 and F_score >=3 and M_score >=3 then 'Champions'
	        When R_score >= 3 and F_score >=2 and M_score >=2 then 'loayl Customer'
	        When R_score <= 2 and F_score >=3 and M_score >=3 then 'At Risk'
	        When R_score >= 3 and F_score <=2 and M_score <=2 then 'New Customer'
	        When R_score <= 2 and F_score <=2 and M_score <=2 then 'Hibernating'
	        else 'Potential Loyalists'
		end as Segment
	From scored
	order by Total_revenue desc;

Query 4: Running Total with Window Function
Purpose: A Running Total (cumulative revenue) and a Rolling Average (moving average), tracked independently for each type of fabric
Tables: orders
Author: [Jahidul-Anik]
Date: 2026-05-03

	SELECT 
	    Order_Date,
	    Fabric_Type,
	    Total_Value_USD,
	    SUM(Total_Value_USD) OVER (
	        PARTITION BY Fabric_Type 
	        ORDER BY Order_Date 
	        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
	    ) as Running_Revenue,
	    AVG(Total_Value_USD) OVER (
	        PARTITION BY Fabric_Type 
	        ORDER BY Order_Date 
	        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
	    ) as Rolling_7Order_Avg
	FROM orders
	WHERE Order_Status IN ('Completed', 'Shipped')
	ORDER BY Fabric_Type, Order_Date;

Query 5: Marketing Channel ROI
Purpose: Takes raw marketing data and calculates exactly how efficiently your money is being spent across different channels
Tables: orders
Author: [Jahidul-Anik]
Date: 2026-05-03

	SELECT 
		Channel,
		sum(Spend_USD) as total_spend,
		sum(Leads_Generated) as total_leads,
		sum(Conversions) as Total_conversion,
		round(sum(Conversions)*100/sum(leads_generated),2) as Conversation_rate,
		round(sum(spend_usd)/sum(leads_generated),2) as Cost_per_lead,
		round(sum(spend_usd)/ nullif(sum(conversions),0),2) as Cost_per_conversions
	FROM textile_analytics.campaigns
	group by channel
	order by total_conversion desc;
	
