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

### 1. Monthly Revenue with YoY Comparison
```sql
SELECT 
    Year, Month,
    SUM(Total_Value_USD) as Revenue,
    LAG(SUM(Total_Value_USD)) OVER (PARTITION BY Month ORDER BY Year) as Last_Year
FROM orders
WHERE Order_Status IN ('Completed', 'Shipped')
GROUP BY Year, Month;
