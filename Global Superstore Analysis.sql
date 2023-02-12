show databases;

Use Global_superstore_data;

-- Data exploration 

SELECT *
FROM Global_superstore_data.Global_Superstore;

-- Checking table dimention 

SELECT COUNT(*) AS Total_rows, ( 
SELECT COUNT(*)
FROM Global_Superstore gs ) AS Total_column
FROM Global_Superstore ;

-- Cheking the data type

SELECT COLUMN_NAME,
       DATA_TYPE,
       IS_NULLABLE,
       CHARACTER_MAXIMUM_LENGTH,
       NUMERIC_PRECISION,
       NUMERIC_SCALE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='Global_superstore_data.Global_Superstore';

-- Checking the all missing values in Global_superstore_data.Global_Superstore data

SELECT
  COUNT(*) AS Total_Rows,
  COUNT(RowID) - COUNT(*) AS Missing_RowID,
  COUNT(OrderId) - COUNT(*) AS Missing_OrderId,
  COUNT(OrderDate) - COUNT(*) AS Missing_OrderDate,
  COUNT(ShipDate) - COUNT(*) AS Missing_ShipDate,
  COUNT(ShipMode) - COUNT(*) AS Missing_ShipMode,
  COUNT(CustomerID) - COUNT(*) AS Missing_CustomerID,
  COUNT(CustomerName) - COUNT(*) AS Missing_CustomerName,
  COUNT(Segment) - COUNT(*) AS Missing_Segment,
  COUNT(City) - COUNT(*) AS Missing_city,
  COUNT(PostalCode) - COUNT(*) AS Missing_PostalCode,
  COUNT(Sales) - COUNT(*) AS Missing_sales,
  COUNT(Profit) - COUNT(*) AS Missing_profit,
  COUNT(ShippingCost) - COUNT(*) AS Missing_ShippingCost,
  COUNT(OrderPriority) - COUNT(*) AS Missing_OrderPriority,
  COUNT(Country) - COUNT(*) AS Missing_country
FROM Global_Superstore;

-- Remove duplicates

WITH cte AS (
  SELECT RowID, OrderId, ROW_NUMBER() OVER (PARTITION BY OrderId ORDER BY RowID) AS rn
  FROM Global_Superstore
)
DELETE FROM cte
WHERE rn > 1;

-- checking the categorical column 

SELECT OrderID , COUNT(*) AS Frequency
FROM Global_Superstore
GROUP BY OrderID ;

-- Checking the unique values column

SELECT 
	COLUMN_NAME AS Unique_Values_Columns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Global_Superstore' AND DATA_TYPE = 'float';

-- Try to find out the primary key

SELECT orderId,COUNT(*) 
FROM Global_Superstore gs
GROUP BY OrderID 
HAVING COUNT(*)>1; 

SELECT *
FROM Global_Superstore gs 
WHERE OrderID = 'IN-2013-71249'

-- Looking combination between orderId and rowId whether we have doublicate

SELECT RowID,orderId,COUNT(*) 
FROM Global_Superstore gs
GROUP BY RowID,OrderID 
HAVING COUNT(*)>1;

-- Checking the condition whether ship date less then order date

SELECT *
FROM Global_Superstore gs 
WHERE ShipDate < OrderDate;

-- Looking delivery status (Number of days) of the product 

SELECT MIN(a.NumofDays) AS MinDays,
       MAX(a.NumofDays) AS MaxDays
FROM (
  SELECT ABS(DATEDIFF(DAY, OrderDate, ShipDate)) AS NumofDays
  FROM Global_Superstore 
  WHERE ShipMode = 'First Class'
) a;


-- Checking the multiple order items

SELECT customerId, orderId, COUNT(*)
FROM Global_Superstore
GROUP BY customerId, orderId
ORDER BY customerId;

-- Aggreate a Revenue column

ALTER TABLE Global_Superstore
ADD Revenue float;

UPDATE Global_Superstore
SET Revenue = Sales * Quantity;

-- Delete Unused Columns

SELECT *
FROM Global_Superstore;

ALTER TABLE Global_Superstore
DROP COLUMN	PostalCode;

-- trying to find out the total sales and their categories

SELECT 
  DISTINCT Category,
  SUM(Sales) AS Total_Sales
FROM Global_Superstore
GROUP BY Category
ORDER BY Total_Sales DESC;

-- shows the frequency of purchase for each customer

SELECT 
  CustomerID,
  COUNT(OrderID) AS Purchase_Frequency
FROM Global_Superstore
GROUP BY CustomerID;

-- Which customer segment is most profitable in each year?

SELECT 
  YEAR(OrderDate) AS OrderYear,
  Segment,
  SUM(Profit) AS Total_Profit
FROM Global_Superstore
GROUP BY YEAR(OrderDate), Segment
ORDER BY OrderYear, Total_Profit DESC;

-- How the customers are distributed across the countries?

SELECT
Country,
COUNT(DISTINCT CustomerID) AS Number_of_Customers
FROM Global_Superstore
GROUP BY Country;

 -- Which Country has top sales?

SELECT
Country,
SUM(Sales) AS Total_Sales
FROM Global_Superstore
GROUP BY Country
ORDER BY Total_Sales DESC
LIMIT 5;

-- How the customers are distributed across the countries?

SELECT
Country,
COUNT(DISTINCT CustomerID) AS Total_Customers
FROM Global_Superstore
GROUP BY Country
ORDER BY Total_Customers DESC;

-- Profile the customers based on their frequency of purchase – calculate frequency of purchase for each customer.

SELECT
CustomerID,
COUNT(*) AS Total_Purchases
FROM Global_Superstore
GROUP BY CustomerID
ORDER BY Total_Purchases DESC;






















       



