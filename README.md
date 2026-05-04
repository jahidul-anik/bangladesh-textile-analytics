# Bangladesh Textile Export Analytics Dashboard

![Executive Summary Dashboard](powerbi/screenshorts/01_executive_summary.png)
*(Note: Replace the link above with the actual path to your dashboard screenshot!)*

## Overview
Power BI and SQL dashboard analyzing **$53.4M in Bangladesh textile export data** (2023–2024) across 45 global buyers, 12 fabric types, and 8 regions. Built as a portfolio project during my transition from 8 years of professional experience in export-oriented fabric marketing into a dedicated data analytics role.

**Key Insights:** 
* Revenue grew **102.7% year-over-year** with clear seasonal demand cycles. 
* EU_Western buyers drive **35% of total revenue**.
* Silk_Blend and Linen fabrics command premium pricing and highest profit margins.

---

## Tools & Technologies
- **SQL (MySQL)** — Data extraction, window functions, CTEs, RFM segmentation
- **Power BI** — DAX measures, time intelligence, interactive dashboard design
- **Python** — Synthetic dataset generation modeling realistic industry patterns

---

## Dashboard Pages

| Page | Purpose | Key Visuals |
|------|---------|-------------|
| **Executive Summary** | Business performance overview | Revenue trend, YoY growth, regional breakdown |
| **Product Analysis** | Fabric performance & seasonality | 60-day rolling revenue, quarterly matrix, fabric ranking |
| **Buyer Insights** | Customer segmentation & behavior | Top 10 buyers, country revenue, tier distribution |
| **Methodology** | Technical documentation | SQL queries, data model, DAX measures |

*(Optional: Add another screenshot of your Matrix or Marketing KPI dashboard here)*

---

## SQL Highlights

### Query 1: Monthly Revenue Trend
**Purpose:** Track revenue performance and aggregate order volume over time.

```sql
SELECT
    Year,
    Month,
    COUNT(*) AS Total_Order,
    SUM(Total_value_usd) AS Revenue,
    AVG(Total_value_usd) AS Avg_Revenue,
    SUM(Quantity_kg) AS Total_Quantity_KG
FROM orders
WHERE Order_Status IN ('Completed', 'Shipped')
GROUP BY Year, Month
ORDER BY Year, Month;



