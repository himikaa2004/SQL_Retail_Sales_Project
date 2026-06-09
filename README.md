# SQL Retail Sales Analysis Project

## Project Overview

**Project Title**: SQL Retail Sales Project  
**Level**: Beginner  
**Database**: `Project_Retail_Sales_Analysis`


## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `Project_Retail_Sales_Analysis`.
- **Table Creation**: A table named `Retail_Sales` is created to store the sales data. The table structure includes columns for transactions ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE Project_Retail_Sales_Analysis;

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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT * FROM Retail_Sales;

SELECT COUNT(*) FROM Retail_Sales;

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

-- TOTAL NUMBER OF SALES? --                    
SELECT COUNT(*) as total_number_of_sales 
FROM Retail_Sales;

-- TOTAL NUMBER OF UNIQUE CUSTOMERS? --     
SELECT COUNT(DISTINCT Customer_ID) as total_number_of_unique_customers 
FROM Retail_Sales;

-- TOTAL NUMBER OF UNIQUE CATEGORY? --      
SELECT DISTINCT Category 
FROM Retail_Sales;

```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT * 
FROM Retail_Sales
WHERE Sale_Date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT * 
FROM Retail_Sales
WHERE Category = 'Clothing'
	AND Quantity >= 4
	AND TO_CHAR(Sale_Date, 'YYYY-MM') = '2022-11';           -- TO_CHAR is used to control how dates and numbers look when displayed in reports or user interfaces.

```

3. **Write a SQL query to calculate the total sales (total_sale) for each category**:
```sql
SELECT 
	Category,
	SUM(Total_Sale) as Total_Sale,
	COUNT (*) as Quantity
FROM Retail_Sales
GROUP BY 1;          -- GROUP BY 1 is used to group the query results by the first column listed in the SELECT statement, like in this case the query is grouped according to the Category Column.

```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category**:
```sql
SELECT 
	ROUND(AVG(Age), 2) as Average_Age          -- ROUND function is used to round-off the number to make it readable and user-friendly.
FROM Retail_Sales
WHERE Category = 'Beauty';
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000**:
```sql
SELECT * 
FROM Retail_Sales
WHERE Total_Sale > 1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category**:
```sql
SELECT 
	Category,
	Gender,
	COUNT(Transactions_ID) as transactions_id
FROM Retail_Sales
GROUP BY 1,2
ORDER BY 1;          -- ORDER BY 1 is used to order the query results by the first column listed in the SELECT statement.

```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
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
```

8. **Write a SQL query to find the top 10 customers based on the highest total sales**:
```sql
SELECT 
	Customer_ID,
	SUM(Total_Sale) as total_sale
FROM Retail_Sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category**:
```sql
SELECT 
	Category,
	COUNT(DISTINCT Customer_ID) as customers 
FROM Retail_Sales
GROUP BY Category;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.






