SELECT
	*
FROM
	pizza_sales_staging;

-- 1. Create pizza_order_totals

CREATE TABLE pizza_order_totals AS
SELECT
	order_id,
    MIN(order_date) AS order_date,
    HOUR(MIN(order_time)) as order_hour,
	SUM(total_price) AS order_total,
    SUM(quantity) as num_of_pizzas
FROM
	pizza_sales_staging
GROUP BY 
	order_id;


SELECT
	*
FROM
	pizza_order_totals;


-- 2. Create pizza_most_sold

CREATE TABLE pizza_most_sold AS
SELECT
	pizza_name,
    SUM(quantity) AS total_sold
FROM
	pizza_sales_staging
GROUP BY
	pizza_name
ORDER BY
	2 DESC;


SELECT
	*
FROM
	pizza_most_sold;


-- 3. Create pizza_daily_sales

CREATE TABLE pizza_daily_sales AS
SELECT
	order_date,
    COUNT(DISTINCT pizza_id) AS daily_pizza_sold,
    SUM(IF(pizza_size = "S", 1, 0)) AS num_of_small,
    SUM(IF(pizza_size = "M", 1, 0)) AS num_of_medium,
    SUM(IF(pizza_size = "L", 1, 0)) AS num_of_large,
    SUM(IF(pizza_size = "XL", 1, 0)) AS num_of_x_large,
    SUM(IF(pizza_size = "XXL", 1, 0)) AS num_of_xx_large,
    ROUND(SUM(total_price), 2) AS daily_sales
FROM
	pizza_sales_staging
GROUP BY
	order_date
ORDER BY
	order_date;
    
SELECT
	*
FROM
	pizza_daily_sales;
    

-- 4. Create pizza_monthly_sales

CREATE TABLE pizza_monthly_sales AS
SELECT
	MONTH(order_date) AS order_month,
    SUM(daily_pizza_sold) AS monthly_pizza_sold,
    SUM(num_of_small) AS num_of_small,
    SUM(num_of_medium) AS num_of_medium,
    SUM(num_of_large) AS num_of_large,
    SUM(num_of_x_large) AS num_of_x_large,
    SUM(num_of_xx_large) AS num_of_xx_large,
    ROUND(SUM(daily_sales), 2) AS monthly_sales
FROM
	pizza_daily_sales
GROUP BY
	order_month;

SELECT
	*
FROM
	pizza_monthly_sales;