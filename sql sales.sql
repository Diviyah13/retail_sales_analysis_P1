-- SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p2;


-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

SELECT * FROM retail_sales
limit 10

SELECT COUNT (*) FROM retail_sales
-- Data Cleaning to identify null values from columns
SELECT * FROM retail_sales 
WHERE 
    TRANSACTION_ID IS NULL
    OR
	sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

-- delete null values from any column
DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL

	-- Data Exploration and Analysing Key Problems

-- Q1 How many sales do we have?
SELECT COUNT(*) AS total_sale from retail_sales
	
-- Q2 How many  unique "current_schema"()customers do we have?
SELECT COUNT (DISTINCT customer_id) from retail_sales
	
-- Q3 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q4 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4

-- Q5 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders 
FROM retail_sales
GROUP BY 1

-- Q6 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT
    ROUND(AVG(age), 0) as avg_age
FROM retail_sales
WHERE category = 'Beauty'

-- Q7 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales
WHERE total_sale > 1000

-- Q8 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
    category,
    gender,
    COUNT(*) as total_transaction
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1

-- Q9 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT -- to save the below subquery/ CTE
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year, -- use extraction function since year column is not given
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1,2 --all the columns that are not included in aggregation
--ORDER BY 1,2,3 DESC 
) as t1 -- labelled as table1
WHERE rank = 1
     
-- Q10 Write a SQL query to find the top 5 customers based on the highest total sales.
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- Q11 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as unique_cs-- to calculate the total unique customers in each cat 
FROM retail_sales
GROUP BY category

-- Q12 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale -- to save the case query as a CTE
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

--END OF PROJECT


	