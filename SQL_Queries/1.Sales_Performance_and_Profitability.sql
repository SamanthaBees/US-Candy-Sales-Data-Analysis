/*FINAL: APRIL 1 */

-- Overview of Sales Performance (2021-2024)

USE US_Candy;
GO

-- ** a. Annual Sales Performance by Division: 2021-2024**

WITH SourceTable AS (
    SELECT 
        Division,
        YEAR(Order_Date) AS Sales_Year,
        CAST(SUM(Sales) AS NUMERIC(18, 2)) AS Total_Sales
    FROM Candy_Sales
    WHERE YEAR(Order_Date) BETWEEN 2021 AND 2024
    GROUP BY Division, YEAR(Order_Date)
)
SELECT 
    Division,
    ISNULL([2021], 0) AS Sales_2021,
    ISNULL([2022], 0) AS Sales_2022,
    ISNULL([2023], 0) AS Sales_2023,
    ISNULL([2024], 0) AS Sales_2024
FROM SourceTable
PIVOT (
    SUM(Total_Sales) 
    FOR Sales_Year IN ([2021], [2022], [2023], [2024])
) AS PivotTable;

/* Story Insight: Chocolate continues to dominate across all years, with a 
strong boost in 2024, showing demand resilience.*/


-- ** b.Annual Profit Margin by Division (2021-2024) **

WITH SourceTable AS (
    SELECT 
        Division,
        YEAR(Order_Date) AS PM_Year,
		CAST((SUM(Gross_Profit) / NULLIF(SUM(Sales), 0)) * 100 AS NUMERIC(18, 2)) AS Profit_Margin_Percentage
    FROM Candy_Sales
    WHERE YEAR(Order_Date) BETWEEN 2021 AND 2024
    GROUP BY Division, YEAR(Order_Date)
)
SELECT 
    Division,
	CAST(ISNULL([2021], 0) AS NUMERIC(18, 2)) AS PM_2021,
    CAST(ISNULL([2022], 0) AS NUMERIC(18, 2)) AS PM_2022,
    CAST(ISNULL([2023], 0) AS NUMERIC(18, 2)) AS PM_2023,
    CAST(ISNULL([2024], 0) AS NUMERIC(18, 2)) AS PM_2024
FROM SourceTable
PIVOT (
    AVG(Profit_Margin_Percentage)
    FOR PM_Year IN ([2021], [2022], [2023], [2024])
) AS PivotTable;

-- ** c.Total Orders by Division from 2021-2024 **

/* This query retrieves the number of unique orders placed in each division for the 
years 2021 to 2024. The result provides an annual breakdown of order volumes by division, 
allowing for year-over-year comparisons of order activity. */

WITH SourceTable AS (
    SELECT 
        Division,
        YEAR(Order_Date) AS Sales_Year,
        COUNT(DISTINCT Order_ID) AS Order_Count
    FROM Candy_Sales
    WHERE YEAR(Order_Date) BETWEEN 2021 AND 2024
    GROUP BY  Division, YEAR(Order_Date)
)
SELECT 
    Division,
    ISNULL([2021], 0) AS Orders_2021,
    ISNULL([2022], 0) AS Orders_2022,
    ISNULL([2023], 0) AS Orders_2023,
    ISNULL([2024], 0) AS Orders_2024
FROM SourceTable
PIVOT (
    SUM(Order_Count) 
    FOR Sales_Year IN ([2021], [2022], [2023], [2024])
) AS PivotTable;



--BUSINESS QUESTIONS

/* Having reviewed the sales trends from 2021 to 2024, 
I will now focus specifically on the performance in 2024. */


--PART I: Sales Performance And Profitability 

--1. What are the total sales, orders, cost, gross profit, and profit margin by Country for 2024? 

SELECT 
    Country_Region,
    CAST(SUM(Sales) AS NUMERIC(18, 2)) AS Total_Sales,
	COUNT(DISTINCT Order_ID) AS Total_Orders,
    CAST(SUM(Cost) AS NUMERIC(18, 2)) AS Total_Costs,
    CAST(SUM(Gross_Profit) AS NUMERIC(18, 2)) AS Total_Gross_Profit,
    CAST(SUM(Gross_Profit) / NULLIF(SUM(Sales), 0) * 100 AS NUMERIC(18, 2)) AS Profit_Margin_Percentage
FROM Candy_Sales
WHERE YEAR(Order_Date) = 2024
GROUP BY  Country_Region
ORDER BY Profit_Margin_Percentage DESC;

/* Story Insight: Strong performance in USA with high-profit margins. 
Canada shows moderate sales but offers growth potential. */


--2. What are the quarterly sales trends for 2024?

SELECT 
    DATEPART(QUARTER, Order_Date) AS Quarter,
    CAST(SUM(Sales) AS NUMERIC(18, 2)) AS Total_Sales
FROM Candy_Sales
WHERE YEAR(Order_Date) = 2024
GROUP BY DATEPART(QUARTER, Order_Date)
ORDER BY Quarter;

/* Story Insight: Significant growth in Q4 suggests sales are holiday-driven, 
providing a focus area for future campaigns */

--3. What is the month-over-month sales growth for 2024? 

WITH Monthly_Sales AS (
    SELECT 
        MONTH(Order_Date) AS Month,
        CAST(SUM(Sales) AS NUMERIC(18, 2)) AS Total_Sales
    FROM  Candy_Sales
    WHERE YEAR(Order_Date) = 2024
    GROUP BY MONTH(Order_Date)
)
SELECT 
    Month,
    Total_Sales,
    LAG(Total_Sales) OVER (ORDER BY Month) AS Previous_Month_Sales,
    CAST(((Total_Sales - LAG(Total_Sales) OVER (ORDER BY Month)) 
          / NULLIF(LAG(Total_Sales) OVER (ORDER BY Month), 0)) * 100 AS NUMERIC(18, 2)) AS Growth_Percentage
FROM Monthly_Sales;

/* Story Insight: The business experiences two peak periods, one in spring (March) and the other in 
fall (September-November), likely driven by seasonality*/

--4. Which product divisions are generating the highest and lowest profits?

SELECT 
    Division,
    CAST(SUM(Sales) AS NUMERIC(18, 2)) AS Total_Sales,
    SUM(Units) AS Total_Units_Sold,
    CAST(SUM(Gross_Profit) AS NUMERIC(18, 2)) AS Total_Gross_Profit,
    CAST(SUM(Gross_Profit) / NULLIF(SUM(Sales), 0) * 100 AS NUMERIC(18, 2)) AS Profit_Margin_Percentage
FROM Candy_Sales
WHERE YEAR(Order_Date) = 2024
GROUP BY  Division
ORDER BY Profit_Margin_Percentage DESC;

/* Story Insight:Chocolate outperforms with the highest margin, while 'other' divisions lag, 
signaling a need for product repositioning. */

--5. What are the monthly sales trends per product division? (E.g. Chocolate)

WITH Monthly_Sales AS (
    SELECT
		Division,
        MONTH(Order_Date) AS Month,
        CAST(SUM(Sales) AS NUMERIC(18, 2)) AS Total_Sales
    FROM Candy_Sales
    WHERE YEAR(Order_Date) = 2024
    GROUP BY Division, MONTH(Order_Date)
)
SELECT
	Division,
    Month,
    Total_Sales,
    LAG(Total_Sales) OVER (ORDER BY Month) AS Previous_Month_Sales,
    CAST(((Total_Sales - LAG(Total_Sales) OVER (ORDER BY Month)) 
          / NULLIF(LAG(Total_Sales) OVER (ORDER BY Month), 0)) * 100 AS NUMERIC(18, 2)) AS Growth_Percentage
FROM Monthly_Sales
WHERE Division LIKE 'Chocolate' --Change it as needed 
ORDER BY Month;

-- 6. Which products generate the highest profit margin?

SELECT 
    Product_Name, -- Let's check the profit margin of all products
    CAST((SUM(Gross_Profit) / NULLIF(SUM(Sales), 0)) * 100 AS NUMERIC(18, 2)) AS Profit_Margin_Percentage
FROM Candy_Sales
WHERE YEAR(Order_Date) = 2024
GROUP BY Product_Name
ORDER BY Profit_Margin_Percentage DESC;

SELECT 
    TOP 1 WITH TIES 
    s.Product_Name, -- Let's check the most profitable product and its factory.
    p.Factory,
    CAST((SUM(s.Gross_Profit) / NULLIF(SUM(s.Sales), 0)) * 100 AS NUMERIC(18, 2)) AS Profit_Margin_Percentage
FROM Candy_Sales AS s 
JOIN Candy_Products AS p ON s.Product_ID = p.Product_ID
WHERE  YEAR(s.Order_Date) = 2024
GROUP BY 
    s.Product_Name, 
    p.Factory
ORDER BY Profit_Margin_Percentage DESC;


/*Pareto analysis, I want to identify the products that 
contributed to 80% of the total profit. */

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
WHERE 
    CAST((Cumulative_Profit / Total_Profit) * 100 AS NUMERIC(18, 2)) <= 80
ORDER BY Cumulative_Profit_Percentage;


--cross-check the cost-to-revenue ratio by product

SELECT 
    Product_Name, -- Let's check cost-to-price ratio
    CAST(Unit_Price AS NUMERIC(18, 2)) AS Unit_Price,
    CAST(Unit_Cost AS NUMERIC(18, 2)) AS Unit_Cost, 
    CAST((Unit_Cost * 100.0) / NULLIF(Unit_Price, 0) AS NUMERIC(18, 2)) AS Cost_To_Price_Ratio
FROM Candy_Products
ORDER BY Cost_To_Price_Ratio ASC;

--7. What is the most popular shipping method? 

WITH Order_Counts AS (
    SELECT 
        Ship_Mode,
        COUNT(DISTINCT Order_ID) AS Total_Orders,
		CAST(SUM(Gross_Profit) AS NUMERIC(18, 2)) AS Total_Gross_Profit
    FROM Candy_Sales
    WHERE YEAR(Order_Date) = 2024
    GROUP BY Ship_Mode
)
SELECT 
    Ship_Mode,
	CAST((Total_Orders * 100.0) / SUM(Total_Orders) OVER () AS NUMERIC(5, 2)) AS Order_Percentage,
	Total_Gross_Profit
FROM Order_Counts
ORDER BY Total_Orders DESC;

--8. Which customers have placed the most orders and contributed the highest revenue?

WITH Orders_by_Customer AS (
    SELECT	
        Customer_ID,
        COUNT(DISTINCT Order_ID) AS Total_Orders,
        CAST(SUM(Sales) AS NUMERIC(18, 2)) AS Total_Sales
    FROM Candy_Sales
    WHERE YEAR(Order_Date) = 2024
    GROUP BY Customer_ID
)
SELECT 
    Customer_ID,
    Total_Orders,
    Total_Sales,
    DENSE_RANK() OVER (ORDER BY Total_Orders DESC) AS Order_Rank
FROM Orders_by_Customer
ORDER BY Order_Rank;

/*Story Insight: Identifying key customers can inform loyalty programs 
and retention strategies.*/