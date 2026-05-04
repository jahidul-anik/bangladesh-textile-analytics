-- ============================================
-- Query 4: Running Total with Window Function
-- Purpose: A Running Total (cumulative revenue) and a Rolling Average (moving average), tracked independently for each type of fabric
-- Tables: orders
-- Author: [Jahidul-Anik]
-- Date: 2026-05-03
-- ============================================
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
