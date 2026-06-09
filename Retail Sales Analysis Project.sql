
----- SQL RETAIL SALES ANALYSIS PROJECT -----

CREATE DATABASE Project_Retail_Sales_Analysis;


----- CREATE TABLE -----

CREATE TABLE Retail_Sales(
Transactions_ID INTEGER PRIMARY KEY,
Sale_Date DATE,
Sale_Time TIME,
Customer_ID INTEGER,
Gender VARCHAR(10),
Age INTEGER,
Category VARCHAR(30),
Quantity INTEGER,
Price_Per_Unit FLOAT,
Cogs FLOAT,
TotaL_Sale FLOAT
);

SELECT * FROM Retail_Sales;

SELECT COUNT(*) FROM Retail_Sales;




----- DATA CLEANING -----

SELECT * FROM Retail_Sales
WHERE Transactions_ID IS NULL
	OR Sale_Date IS NULL
	OR Sale_Time IS NULL
	OR Customer_ID IS NULL
	OR Gender IS NULL
	OR Category IS NULL
	OR Quantity IS NULL
	OR Price_Per_Unit IS NULL
	OR Cogs IS NULL
	OR TotaL_Sale IS NULL;

DELETE FROM Retail_Sales
WHERE Transactions_ID IS NULL
	OR Sale_Date IS NULL
	OR Sale_Time IS NULL
	OR Customer_ID IS NULL
	OR Gender IS NULL
	OR Category IS NULL
	OR Quantity IS NULL
	OR Price_Per_Unit IS NULL
	OR Cogs IS NULL
	OR TotaL_Sale IS NULL;




----- DATA EXPLORATION -----

-- TOTAL NUMBER OF SALES?                    
SELECT COUNT(*) as total_number_of_sales 
FROM Retail_Sales;

-- TOTAL NUMBER OF UNIQUE CUSTOMERS?         
SELECT COUNT(DISTINCT Customer_ID) as total_number_of_unique_customers 
FROM Retail_Sales;

-- TOTAL NUMBER OF UNIQUE CATEGORY?          
SELECT DISTINCT Category 
FROM Retail_Sales;




----- DATA ANALYSIS & SOLUTIONS TO BUSINESS KEY PROBLEMS -----


-- Q1. Write a SQL Query to retrieve all the columns for sale made on 2022-11-05.

SELECT * 
FROM Retail_Sales
WHERE Sale_Date = '2022-11-05';


-- Q2. Write a SQL Query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Novemver 2022.

SELECT * 
FROM Retail_Sales
WHERE Category = 'Clothing'
	AND Quantity >= 4
	AND TO_CHAR(Sale_Date, 'YYYY-MM') = '2022-11';           -- TO_CHAR is used to control how dates and numbers look when displayed in reports or user interfaces.


-- Q3. Write a SQL Query to calculate the total sales for each category.

SELECT 
	Category,
	SUM(Total_Sale) as Total_Sale,
	COUNT (*) as Quantity
FROM Retail_Sales
GROUP BY 1;          -- GROUP BY 1 is used to group the query results by the first column listed in the SELECT statement, like in this case the query is grouped according to the Category Column.


-- Q4. Write a SQL Query to find the average age of customers who purchased items from the Beauty category.

SELECT 
	ROUND(AVG(Age), 2) as Average_Age          -- ROUND function is used to round-off the number to make it readable and user-friendly.
FROM Retail_Sales
WHERE Category = 'Beauty';


-- Q5. Write a SQL Query to find all transactions where the total sale is greater than 1000.

SELECT * 
FROM Retail_Sales
WHERE Total_Sale > 1000;


-- Q6. Write a SQL Query to find the total number of transactions (Transaction_ID) made by each gender in each category.

SELECT 
	Category,
	Gender,
	COUNT(Transactions_ID) as transactions_id
FROM Retail_Sales
GROUP BY 1,2
ORDER BY 1;          -- ORDER BY 1 is used to order the query results by the first column listed in the SELECT statement.


-- Q7. Write a SQL Query to calculate the average sale for each month. Find out the best selling month in each year.

SELECT 
	year,
	month,
	avg_sale
FROM (
	SELECT 
		EXTRACT(YEAR FROM Sale_Date) as year,          -- EXTRACT() function is used to retrieve specific component from year, month, day etc.
		EXTRACT(MONTH FROM Sale_Date) as month,
		AVG(Total_Sale) as avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM Sale_Date) ORDER BY AVG(Total_Sale) DESC) as rank          -- RANK function is used to set the data in a ranked sequence and PARTITION BY is used to divide the query's result into smaller, non-overlapping groups.
	FROM Retail_Sales
	GROUP BY 1,2
	) as new_table
WHERE RANK = 1;


-- Q8. Write a SQL Query to find the top 10 customers based on the highest total sales.

SELECT 
	Customer_ID,
	SUM(Total_Sale) as total_sale
FROM Retail_Sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;


-- Q9. Write a SQL Query to find the number of unique customers who purchased items from each category.

SELECT 
	Category,
	COUNT(DISTINCT Customer_ID) as customers 
FROM Retail_Sales
GROUP BY Category;


-- Q10. Write a SQL Query to create each shift and number of orders (Example: Morning < 12, Afternoon Between 12 & 17, Evening > 17). )

WITH hourly_shift_sale          -- WITH Clause is a CTE that defines a temporary result that exists for a particular time for a specific query.
AS (
SELECT *,
	CASE          -- CASE is an expression used for conditional logics like WHEN-THEN-ELSE.
		WHEN EXTRACT (HOUR FROM Sale_Time) < 12 THEN 'Morning'
		WHEN EXTRACT (HOUR FROM Sale_Time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as Shift          -- CASE statement terminates with END.
FROM Retail_Sales
)
SELECT 
	Shift,
	COUNT(*) as total_orders
FROM hourly_shift_sale
GROUP BY Shift;


----- END OF PROJECT -----




































