-- ============================================
-- Query 5: Marketing Channel ROI
-- Purpose: Takes raw marketing data and calculates exactly how efficiently your money is being spent across different channels
-- Tables: orders
-- Author: [Jahidul-Anik]
-- Date: 2026-05-03
-- ============================================
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