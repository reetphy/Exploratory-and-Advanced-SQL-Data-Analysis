
/*
===============================================================================
Advanced Data Analysis
===============================================================================
    1. Changes Over Time
    2. Cumulative Analysis
    3. Performance Analysis
    4. Part-to-Whole Analysis
    5. Data Segmentation
===============================================================================
*/


/*
===============================================================================
Changes Over Time
===============================================================================
*/

-- Sales by Year
SELECT 
    YEAR(order_date) AS order_year,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date);

-- Sales by Month
SELECT 
    MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM fact_sales
WHERE order_date IS NOT NULL
GROUP BY MONTH(order_date)
ORDER BY MONTH(order_date);


-- Sales by Year,Month
SELECT 
    DATE_FORMAT(order_date, '%y-%m-01') as order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_FORMAT(order_date, '%y-%m-01')
ORDER BY DATE_FORMAT(order_date, '%y-%m-01');



/*
===============================================================================
Cumulative Analysis
===============================================================================
*/


-- Calculate the total sales per month
-- and the running total of sales over time
SELECT 
    order_date,
    total_sales,
    SUM(total_sales) OVER(ORDER BY order_date) AS running_total_sales,
    round(AVG(avg_price) OVER(ORDER BY order_date)) AS moving_avg_price
FROM (	
	SELECT 
		DATE_FORMAT(order_date, '%Y-%m-01') AS order_date,
		SUM(sales_amount) AS total_sales,
        round(AVG(price)) AS avg_price
	FROM fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATE_FORMAT(order_date, '%Y-%m-01')
	)t;
 
 
-- Same as the previous query, but here I want the year-wise running total.
SELECT 
    order_date,
    total_sales,
    SUM(total_sales) OVER(PARTITION BY YEAR(order_date) ORDER BY order_date) AS running_total_sales
FROM (	
	SELECT 
		DATE_FORMAT(order_date, '%Y-%m-01') AS order_date,
		SUM(sales_amount) AS total_sales
	FROM fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATE_FORMAT(order_date, '%Y-%m-01')
	)t;
    
    
/*
===============================================================================
Performance Analysis
===============================================================================
*/


/* Analyze the yearly performance of products by comparing each product's 
sales to both its average sales performance and the previous year's sales */

WITH yearly_product_sales AS 
	(
	SELECT
		YEAR(order_date) AS order_year,
		product_name,
		SUM(sales_amount) AS current_sales
	FROM fact_sales f 
	LEFT JOIN dim_products p
	ON f.product_key = p.product_key
	WHERE order_date IS NOT NULL
	GROUP BY YEAR(order_date), product_name
    )

SELECT
    order_year,
    product_name,
    current_sales,
    ROUND(AVG(current_sales) OVER(PARTITION BY product_name)) AS avg_sales,
    current_sales - ROUND(AVG(current_sales) OVER(PARTITION BY product_name))  AS diff_avg,
    CASE WHEN current_sales - ROUND(AVG(current_sales) OVER(PARTITION BY product_name)) > 0 THEN 'Above Avg'
	 WHEN current_sales - ROUND(AVG(current_sales) OVER(PARTITION BY product_name)) < 0 THEN 'Below Avg'
         ELSE 'Avg' 
    END AS avg_change,
    -- Year-over-Year Analysis
    LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) as py_sales,
    current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) as diff_py,
    CASE WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
	 WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
         ELSE 'No change' 
    END AS py_change
FROM yearly_product_sales
ORDER BY product_name, order_year;


/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
*/


-- Which category contribute the most to the overall sales?

SELECT
	category,
	SUM(sales_amount) AS total_sales,
	CONCAT(round(SUM(sales_amount)*100/(SELECT SUM(sales_amount) from fact_sales),2), '%') AS percentage_of_total
FROM fact_sales f
LEFT JOIN dim_products p
ON p.product_key = f.product_key
GROUP BY category
ORDER BY percentage_of_total DESC;
    
-- Which category contribute the most to the overall orders?
/* In a single order numbers there can be orders of multiple categories. 
Therefore we have not used distinct orders. Here the total number of orders 
isn't insightful but the percentage of orders is important*/
SELECT
	category,
	-- COUNT(order_number) AS total_orders,
	CONCAT(ROUND(COUNT(order_number)*100/(SELECT COUNT(order_number) from fact_sales),2), '%') AS percentage_of_total_orders
FROM fact_sales f
LEFT JOIN dim_products p
ON p.product_key = f.product_key
GROUP BY category
ORDER BY percentage_of_total_orders DESC;


/*
===============================================================================
Data Segmentation
===============================================================================
*/


/*Segment products into cost ranges and 
count how many products fall in each category*/
WITH product_segments AS (
	SELECT 
		product_key,
		product_name,
		cost,
		CASE WHEN cost < 100 THEN 'Below 100'
		     WHEN cost BETWEEN 100 and 500 THEN '100-500'
		     WHEN cost BETWEEN 500 and 1000 THEN '500-1000'
		     ELSE 'Above 1000'
		END AS cost_range
	FROM dim_products)

SELECT 
    cost_range,
    COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;

/*Group Customers into three segments based on their spending behaviour:
	- VIP: Customers with at least 12 months of history and spending more than 5000
    - Regular: Customers with at least 12 months of history but spending 5000 or less
    - New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/
WITH customer_spending AS(
SELECT 
    customer_key,
    MIN(order_date) AS first_order,
    MAX(order_date) AS last_order,
    PERIOD_DIFF(EXTRACT(YEAR_MONTH FROM MAX(order_date)), EXTRACT(YEAR_MONTH FROM MIN(order_date))) AS lifespan,
    sum(sales_amount) AS total_spending
FROM fact_sales
WHERE order_date IS NOT NULL
GROUP BY customer_key
ORDER BY customer_key
)
, customer_segments AS (
SELECT 
    customer_key,
    lifespan,
    total_spending,
	CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
             WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
             WHEN lifespan < 12  THEN 'New'
	END AS customer_category
FROM customer_spending)

SELECT 
    customer_category,
    COUNT(customer_key) AS total_customers
FROM customer_segments
GROUP BY customer_category
ORDER BY total_customers DESC;










