-- ** GEOGRAPHICAL AND DEMOGRAPHIC ANALYSIS **

USE US_Candy;
GO

/* I will now perform a final analysis to gain insights into regional performance 
by assessing the sales volume in different regions. */


--1. What is the distribution of sales by country and division?

SELECT	
	COALESCE(Country_Region,'All Contries') AS Country, 
	COALESCE(Division, 'All Divisions') AS Division,
	CAST(SUM(Sales) AS NUMERIC(18, 2)) AS Total_Sales
FROM	Candy_Sales
WHERE YEAR(Order_Date) = 2024
GROUP BY CUBE (Country_Region, Division);


-- 2. Which provinces in Canada and states in the USA generate the highest profitability for candy sales in 2024, 
-- and how does their profit margin percentage compare across these regions?

SELECT	
		State_Province, --Let's check the most profitable province in Canada
		CAST(SUM(Sales) AS NUMERIC(18, 2)) AS Total_Sales,
		CAST((SUM(Gross_Profit) / NULLIF(SUM(Sales), 0)) * 100 AS NUMERIC(18, 2)) AS Profit_Margin_Percentage
FROM Candy_Sales
WHERE YEAR(Order_Date) = 2024 AND Country_Region = 'Canada'
GROUP BY Country_Region, State_Province
ORDER BY Profit_Margin_Percentage DESC;


SELECT	
		State_Province, --Let's check the most profitable state in USA
		CAST(SUM(Sales) AS NUMERIC(18, 2)) AS Total_Sales,
		CAST((SUM(Gross_Profit) / NULLIF(SUM(Sales), 0)) * 100 AS NUMERIC(18, 2)) AS Profit_Margin_Percentage
FROM Candy_Sales
WHERE YEAR(Order_Date) = 2024 AND Country_Region = 'United States'
GROUP BY Country_Region, State_Province
ORDER BY Profit_Margin_Percentage DESC;


-- 3. What is the distribution of customers by state/province, and which states 
-- generate the most revenue?


SELECT	
	COALESCE(State_Province,'All States') AS State, 
	COALESCE(City, 'All Cities') AS City,
	COUNT(DISTINCT(Customer_ID)) AS Total_Customers,
	CAST(SUM(Sales) AS NUMERIC(18, 2)) AS Total_Sales
FROM	Candy_Sales
WHERE YEAR(Order_Date) = 2024 AND Country_Region LIKE 'Canada'
GROUP BY ROLLUP (State_Province, City)
ORDER BY State_Province;


SELECT	
	COALESCE(State_Province,'All States') AS State, 
	COALESCE(City, 'All Cities') AS City,
	COUNT(DISTINCT(Customer_ID)) AS Total_Customers,
	CAST(SUM(Sales) AS NUMERIC(18, 2)) AS Total_Sales
FROM	Candy_Sales
WHERE YEAR(Order_Date) = 2024 AND Country_Region LIKE 'United States'
GROUP BY ROLLUP (State_Province, City)
ORDER BY State_Province;


-- 4. How does the population density of a region (US Zips) correlate with the number of orders?

WITH City_Sales AS (
    SELECT 
        UPPER(City) AS City,
        COUNT(DISTINCT Customer_ID) AS Total_Customers,
        COUNT(DISTINCT Order_ID) AS Total_Orders,
        CAST(SUM(Sales) AS NUMERIC(18, 2)) AS Total_Sales
    FROM Candy_Sales 
    WHERE YEAR(Order_Date) = 2024 AND Country_Region = 'United States'
    GROUP BY City
),
City_Population AS (
    SELECT 
        UPPER(City) AS City,
        SUM(Population) AS Total_Population
    FROM US_Zips
    GROUP BY City
)
SELECT 
    CS.City, 
    CS.Total_Customers, 
    CS.Total_Orders, 
    CS.Total_Sales, 
    COALESCE(CP.Total_Population, 0) AS Total_Population
FROM City_Sales CS
LEFT JOIN City_Population CP 
    ON CS.City = CP.City
ORDER BY Total_Population DESC;


/* Story Insight:Larger cities with higher populations, like Los Angeles, Houston, and Chicago, 
generally show higher total sales, suggesting that more populated areas contribute to increased revenue. 
Certain cities, like San Francisco, demonstrate high sales despite fewer customers, hinting at niche markets 
or unique demand factors. For a deeper understanding, examining population density alongside sales and 
calculating a correlation coefficient would help clarify these relationships, while exploring external 
factors such as local economic conditions and consumer preferences could further explain sales 
variations across cities.
*/