-- 1. ___________________________________INITIAL TABLES SETUP
CREATE TABLE 
	pizza_sales_staging
LIKE
	pizza_sales;
    

INSERT
	pizza_sales_staging
SELECT
	*
FROM
	pizza_sales;


SELECT
	*
FROM
	pizza_sales_staging;

-- 2. _________________________________________REMOVE DUPLICATES

-- No duplicates found
WITH cte_sales_rows AS(
	SELECT
		*,
		ROW_NUMBER() OVER(PARTITION BY
			pizza_id, order_id, pizza_name_id, quantity, order_date, order_time,
			unit_price, total_price, pizza_size, pizza_category, pizza_ingredients, pizza_name
		) AS row_num
	FROM
		pizza_sales_staging
)
SELECT
	*
FROM
	cte_sales_rows
WHERE
	row_num > 1;


-- 3. STANDARDIZE DATA

-- Remove whitespace
-- No whitespace changes
UPDATE
	pizza_sales_staging
SET 
	pizza_id = TRIM(pizza_id),
	order_id = TRIM(order_id),
	pizza_name_id = TRIM(pizza_name_id),
    quantity = TRIM(quantity),
    order_date = TRIM(order_date),
    order_time = TRIM(order_time),
    unit_price = TRIM(unit_price),
    total_price = TRIM(total_price),
    pizza_size = TRIM(pizza_size),
    pizza_category = TRIM(pizza_category),
    pizza_ingredients = TRIM(pizza_ingredients),
    pizza_name = TRIM(pizza_name);


-- No outliers on top / bottom of pizza_id. Changed pizza_id to int datatype
SELECT
	pizza_id
FROM
	pizza_sales_staging;

SELECT
	pizza_id
FROM
	pizza_sales_staging
ORDER BY
	pizza_id DESC;

ALTER TABLE
	pizza_sales_staging
MODIFY COLUMN
	pizza_id INT;
    

-- No outliers on top / bottom of order_id. Changed order_id to int datatype
SELECT
	DISTINCT order_id
FROM
	pizza_sales_staging;

SELECT
	DISTINCT order_id
FROM
	pizza_sales_staging
ORDER BY
	order_id DESC;

ALTER TABLE
	pizza_sales_staging
MODIFY COLUMN
	order_id INT;
    

-- No typos in pizza_name_id
SELECT
	DISTINCT pizza_name_id
FROM
	pizza_sales_staging
ORDER BY
	pizza_name_id;


-- No outliers on top / bottom of quantity. Changed quantity to int datatype
SELECT
	DISTINCT quantity
FROM
	pizza_sales_staging;

ALTER TABLE
	pizza_sales_staging
MODIFY COLUMN
	quantity INT;


-- order_date normalized to YYYY-MM-DD format and column converted to date datatype
SELECT
	DISTINCT order_date
FROM
	pizza_sales_staging;

UPDATE
	pizza_sales_staging
SET
	order_date = REPLACE(order_date, "-", "/"),
    order_date = STR_TO_DATE(order_date, "%d/%m/%Y");

ALTER TABLE 
	pizza_sales_staging
MODIFY COLUMN
	order_date DATE;


-- Convert order_time to time datatype
SELECT
	DISTINCT order_time
FROM
	pizza_sales_staging
ORDER BY 1;

ALTER TABLE
	pizza_sales_staging
MODIFY COLUMN
	order_time TIME;


-- No typos in unit_price
SELECT
	DISTINCT unit_price
FROM
	pizza_sales_staging
ORDER BY 1;


-- No typos in total_price
SELECT
	DISTINCT total_price
FROM
	pizza_sales_staging
ORDER BY 1;


-- No typos in pizza_size
SELECT
	DISTINCT pizza_size
FROM
	pizza_sales_staging;


-- No typos in pizza_category
SELECT
	DISTINCT pizza_category
FROM
	pizza_sales_staging;


-- Fixed error for N'duja Salami
SELECT
	DISTINCT pizza_ingredients
FROM
	pizza_sales_staging;
    
UPDATE
	pizza_sales_staging
SET
	pizza_ingredients = REPLACE(pizza_ingredients, "?duja Salami", "N'duja Salami");


-- No typos in pizza_name
SELECT
	DISTINCT pizza_name
FROM
	pizza_sales_staging;


-- 4. ____________________________________________________CORRECT NULL / BLANK VALUES

-- No null or blank values found
SELECT
	*
FROM
	pizza_sales_staging
WHERE
	pizza_id IS NULL
    OR order_id IS NULL OR order_id = ""
    OR pizza_name_id IS NULL OR pizza_name_id = ""
    OR quantity IS NULL OR quantity = ""
    OR order_date IS NULL
    OR order_time IS NULL OR order_time = ""
    OR unit_price IS NULL OR unit_price = ""
    OR total_price IS NULL OR total_price = ""
    OR pizza_size IS NULL OR pizza_size = ""
    OR pizza_category IS NULL OR pizza_category = ""
    OR pizza_ingredients IS NULL OR pizza_ingredients = ""
    OR pizza_name IS NULL OR pizza_name = "";