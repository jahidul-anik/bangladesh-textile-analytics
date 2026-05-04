-- ============================================
-- Query 2: Buyer RFM Segmentation
-- Purpose: raw transactional data, transformed it into behavioral metrics, graded those metrics on a curve, and assigned plain-English marketing labels
-- Tables: buyers & orders
-- Author: [Jahidul-Anik]
-- Date: 2026-05-02
-- ============================================
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