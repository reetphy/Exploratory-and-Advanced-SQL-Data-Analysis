/*
===============================================================================
Exploratory Data Analysis(EDA)
===============================================================================
    1. Database Exploration
    2. Dimension Exploration
    3. Date Exploration
    4. Measure Exploration
    5. Magnitude Analysis
    6. Ranking Analysis
===============================================================================
*/






/*
===============================================================================
Database Exploration
===============================================================================
*/

-- Explore all columns in the table(dim_customers)
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers'
ORDER BY ORDINAL_POSITION;

-- Number of rows in the table(dim_customers)
SELECT COUNT(*) as numofrows 
FROM dim_customers;

-- Explore all columns in the table(dim_products)
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_products'
ORDER BY ORDINAL_POSITION;

-- Number of rows in the table(dim_products)
SELECT COUNT(*) as numofrows 
FROM dim_products;

-- Explore all columns in the table(fact_sales)
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fact_sales'
ORDER BY ORDINAL_POSITION;

-- Number of rows in the table(fact_sales)
SELECT COUNT(*) as numofrows 
FROM fact_sales;


/*
===============================================================================
Dimension Exploration
===============================================================================
*/


-- Explore all Countries our customers come from
SELECT DISTINCT country FROM dim_customers;

-- Explore all Categories "The Major Divisions"
SELECT DISTINCT category, subcategory, product_name FROM dim_products
ORDER BY 1,2,3;

SELECT 
	COUNT(DISTINCT category) as category_count, 
	COUNT(DISTINCT subcategory) as subcategory_count, 
	COUNT(DISTINCT product_name) as product_count 
FROM DIM_PRODUCTS;



/*
===============================================================================
Date Exploration
===============================================================================
*/


-- Find the date of the first and last order
-- How many years of sales are available
SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    TIMESTAMPDIFF(year, MIN(order_date), MAX(order_date)) AS order_range_years,
    TIMESTAMPDIFF(month, MIN(order_date), MAX(order_date)) AS order_range_months
FROM fact_sales;

-- Find the youngest and the oldest customer
SELECT 
	MIN(birthdate) AS oldest_birthdate,
	TIMESTAMPDIFF(year, MIN(birthdate), CURDATE()) AS Oldest_age,
	MAX(birthdate) AS youngest_birthdate,
	TIMESTAMPDIFF(year, MAX(birthdate), CURDATE()) AS Youngest_age
FROM dim_customers;


/*
===============================================================================
Measure Exploration
===============================================================================
*/


-- Find the total sales
SELECT SUM(sales_amount) AS total_sales FROM fact_sales;

-- Find how many items are sold
SELECT SUM(quantity) AS total_quantity FROM fact_sales;

-- Find the average selling price
SELECT round(AVG(price)) AS avg_price FROM fact_sales;

-- Find the total number of orders
SELECT COUNT(order_number) AS total_orders FROM fact_sales;
SELECT COUNT(DISTINCT order_number) AS total_orders FROM fact_sales;

-- Find the total number of products
SELECT COUNT(product_id) AS total_products FROM dim_products;
SELECT COUNT(DISTINCT product_id) AS total_products FROM dim_products;

-- Find the total number of customers
SELECT COUNT(customer_key) AS total_customers FROM dim_customers;
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM dim_customers;

-- Find the total number of customers that have placed an order
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM fact_sales;


-- Generate a Report that shows all the key metrics of the business
SELECT 'Total Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM fact_sales
UNION ALL
SELECT 'Average Price', round(AVG(price)) FROM fact_sales
UNION ALL
SELECT 'Total Nr. Orders', COUNT(DISTINCT order_number) FROM fact_sales
UNION ALL
SELECT 'Total Nr. Products', COUNT(DISTINCT product_id) FROM dim_products
UNION ALL
SELECT 'Total Nr. of Customers', COUNT(DISTINCT customer_key) FROM dim_customers;


/*
===============================================================================
Magnitude Analysis
===============================================================================
*/

-- Find total customers by countries
SELECT 
    country, 
    COUNT(customer_key) AS total_customers 
FROM dim_customers 
GROUP BY country
ORDER BY total_customers DESC;

-- Find total customers by gender
SELECT 
    gender, 
    COUNT(customer_key) AS total_customers 
FROM dim_customers 
GROUP BY gender
ORDER BY total_customers DESC;

-- Find total products by category
SELECT
	category,
    	COUNT(product_key) AS total_product
FROM dim_products
GROUP BY category
ORDER BY total_product DESC;

-- What is the average costs in each category?
SELECT 
	category,
    	round(AVG(cost)) AS avg_cost
FROM dim_products
GROUP BY category
ORDER BY avg_cost DESC;

-- What is the total revenue generated by each category?
SELECT
	category,
    	SUM(sales_amount) AS total_revenue
FROM fact_sales f
LEFT JOIN dim_products p
ON f.product_key = p.product_key
GROUP BY category
ORDER BY total_revenue DESC;

-- Find total revenue generated by each customer
SELECT 
	c.customer_key,
    	c.first_name,
    	c.last_name,
    	SUM(sales_amount) AS total_revenue
FROM fact_sales f
LEFT JOIN dim_customers c
ON f.customer_key = c.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY total_revenue DESC;

-- What is the distribution of sold items across country?
SELECT 
	c.country,
    	SUM(quantity) AS total_sold_items
FROM fact_sales f
LEFT JOIN dim_customers c
ON f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY total_sold_items DESC;


/*
===============================================================================
Ranking Analysis
===============================================================================
*/


-- Which 5 products generate the highest revenue?
SELECT *
FROM (
	SELECT
		product_name,
		SUM(sales_amount) AS total_revenue,
		ROW_NUMBER() OVER(ORDER BY SUM(sales_amount) DESC) AS rank_products
	FROM fact_sales f
	LEFT JOIN dim_products p
	ON f.product_key = p.product_key
	GROUP BY product_name
	)t
WHERE rank_products <= 5;

-- What are the 5 worst performing products in terms of sales?
SELECT *
FROM (
	SELECT
		product_name,
		SUM(sales_amount) AS total_revenue,
		ROW_NUMBER() OVER(ORDER BY SUM(sales_amount)) AS rank_products
	FROM fact_sales f
	LEFT JOIN dim_products p
	ON f.product_key = p.product_key
	GROUP BY product_name
	)t
WHERE rank_products <= 5;

-- Which 5 subcategories generate the highest revenue?
SELECT *
FROM (
	SELECT
		subcategory,
		SUM(sales_amount) AS total_revenue,
		ROW_NUMBER() OVER(ORDER BY SUM(sales_amount) DESC) AS rank_products
	FROM fact_sales f
	LEFT JOIN dim_products p
	ON f.product_key = p.product_key
	GROUP BY subcategory
	)t
WHERE rank_products <= 5;

-- What are the 5 worst performing subcategories in terms of sales?
SELECT *
FROM (
	SELECT
		subcategory,
		SUM(sales_amount) AS total_revenue,
		ROW_NUMBER() OVER(ORDER BY SUM(sales_amount)) AS rank_products
	FROM fact_sales f
	LEFT JOIN dim_products p
	ON f.product_key = p.product_key
	GROUP BY subcategory
	)t
WHERE rank_products <= 5;

-- Find the Top-10 customers who have generated the highest revenue 
SELECT * 
FROM (
	SELECT 
		c.customer_key,
		c.first_name,
		c.last_name,
        c.country,
		SUM(sales_amount) AS total_revenue,
		ROW_NUMBER() OVER(ORDER BY SUM(sales_amount) DESC) AS rank_customers
	FROM fact_sales f
	LEFT JOIN dim_customers c
	ON f.customer_key = c.customer_key
	GROUP BY c.customer_key, c.first_name, c.last_name, c.country
    )t
WHERE rank_customers <= 10;

-- Find 3 customers with the fewest orders placed
SELECT * 
FROM (
	SELECT 
		c.customer_key,
		c.first_name,
		c.last_name,
        	c.country,
		COUNT(DISTINCT order_number) AS total_orders,
		ROW_NUMBER() OVER(ORDER BY COUNT(DISTINCT order_number)) AS rank_customers
	FROM fact_sales f
	LEFT JOIN dim_customers c
	ON f.customer_key = c.customer_key
	GROUP BY c.customer_key, c.first_name, c.last_name, c.country
    )t
WHERE rank_customers <= 3;














































