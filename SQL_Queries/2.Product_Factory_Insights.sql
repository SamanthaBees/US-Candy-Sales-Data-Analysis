-- **PRODUCT AND FACTORY INSIGHTS** 

USE US_Candy;
GO

-- ** Product Profitability Performance for 2024**
-- 1. What is the average profit margin for each product division and product name?.

SELECT 
	Division,
    Product_Name,
    CAST(AVG(NULLIF(Gross_Profit / NULLIF(Sales, 0), 0)) * 100 AS NUMERIC(18, 2)) AS Avg_Profit_Margin
FROM Candy_Sales
WHERE YEAR(Order_Date) = 2024
GROUP BY Division, Product_Name
ORDER BY Division, Avg_Profit_Margin DESC;


-- ** Most Profitable Product and its Factory (2024)**
-- 2. What is the most profitable product, and which factory produces it?

SELECT 
    TOP 1 WITH TIES 
    s.Product_Name,
    p.Factory,
    CAST((SUM(s.Gross_Profit) / NULLIF(SUM(s.Sales), 0)) * 100 AS NUMERIC(18, 2)) AS Profit_Margin_Percentage
FROM Candy_Sales AS s JOIN Candy_Products AS p ON s.Product_ID = p.Product_ID
WHERE YEAR(s.Order_Date) = 2024
GROUP BY s.Product_Name, p.Factory
ORDER BY Profit_Margin_Percentage DESC;


-- ** Products Contributing to 80% of Total Profit (2024)**
-- 3. Which products contribute to 80% of the total profit?

WITH Product_Profit AS (
    SELECT 
        Product_Name,
        CAST(SUM(Gross_Profit) AS NUMERIC(18, 2)) AS Total_Gross_Profit
    FROM Candy_Sales
    WHERE YEAR(Order_Date) = 2024
    GROUP BY Product_Name
),

Cumulative_Profit AS (
    SELECT 
        Product_Name,
        Total_Gross_Profit,
        SUM(Total_Gross_Profit) OVER (ORDER BY Total_Gross_Profit DESC) AS Cumulative_Profit,
        SUM(Total_Gross_Profit) OVER () AS Total_Profit
    FROM Product_Profit
)
SELECT 
    Product_Name,
    Total_Gross_Profit,
    CAST((Cumulative_Profit / Total_Profit) * 100 AS NUMERIC(18, 2)) AS Cumulative_Profit_Percentage
FROM Cumulative_Profit
WHERE CAST((Cumulative_Profit / Total_Profit) * 100 AS NUMERIC(18, 2)) <= 80
ORDER BY Cumulative_Profit_Percentage;


-- ** Factory-Level Revenue Performance (2024)**
--4. Which factories produce the highest profitable products?

SELECT 
	p.Factory,
    s.Product_Name,
    CAST((SUM(s.Gross_Profit) / NULLIF(SUM(s.Sales), 0)) * 100 AS NUMERIC(18, 2)) AS Profit_Margin_Percentage
FROM Candy_Sales AS s JOIN Candy_Products AS p ON s.Product_ID = p.Product_ID
WHERE YEAR(s.Order_Date) = 2024
GROUP BY p.Factory, s.Product_Name
ORDER BY Factory, Profit_Margin_Percentage DESC;


SELECT 
    p.Factory, -- Let's check profitability by factory
    CAST((SUM(s.Gross_Profit) / NULLIF(SUM(s.Sales), 0)) * 100 AS NUMERIC(18, 2)) AS Profit_Margin_Percentage
FROM Candy_Sales AS s JOIN Candy_Products AS p ON s.Product_ID = p.Product_ID
WHERE YEAR(s.Order_Date) = 2024
GROUP BY p.Factory
ORDER BY Profit_Margin_Percentage DESC;


-- ** Division Performance Against Targets (2024)**
-- 5. Which divisions are underperforming in terms of sales relative to their 2024 targets?

WITH Division_Sales AS (
    SELECT 
        Division,
        CAST(SUM(Sales) AS NUMERIC(18, 2)) AS Total_Sales
    FROM Candy_Sales
    WHERE YEAR(Order_Date) = 2024
    GROUP BY  Division
)
SELECT 
    ds.Division, ds.Total_Sales, ct.Target,
    (ds.Total_Sales - ct.Target) AS Difference,
    CASE 
        WHEN ds.Total_Sales >= ct.Target THEN 'Outperformed'
        ELSE 'Underperformed'
    END AS Performance
FROM Division_Sales AS ds JOIN Candy_Targets AS ct ON ds.Division = ct.Division;