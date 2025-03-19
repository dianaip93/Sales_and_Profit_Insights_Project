--Data Cleaning

--Date: 1 null value
  
SELECT date
FROM sales_data
ORDER BY date DESC;

-- Row with index 34866 all rows except for "revenue" are null. Deleting row as it does not provide complete information (15 null columns)

SELECT *
FROM sales_data
WHERE date IS NULL
AND year IS NULL
AND month IS NULL;

 
DELETE
FROM sales_data
WHERE date IS NULL
AND year IS NULL
AND month IS NULL;

-- Year = Clean

SELECT year, COUNT(year)
FROM sales_data
GROUP BY year;

-- Month = Clean

SELECT month, COUNT(month)
FROM sales_data
GROUP BY month
ORDER BY month;

-- Customer_age = Clean

SELECT customer_age, COUNT(customer_age)
FROM sales_data
GROUP BY customer_age
ORDER BY customer_age;	

-- Customer_gender = Clean

SELECT customer_gender, COUNT(customer_gender)
FROM sales_data
GROUP BY customer_gender;

-- Country = Clean

SELECT country, COUNT(country)
FROM sales_data
GROUP BY country;

-- State = Clean

SELECT state, COUNT(state)
FROM sales_data
GROUP BY state
ORDER BY state;

-- Product_category = Clean

SELECT product_category, COUNT(product_category)
FROM sales_data
GROUP BY product_category
ORDER BY product_category;

-- Sub_category = Clean

SELECT sub_category, COUNT(sub_category)
FROM sales_data
GROUP BY sub_category
ORDER BY sub_category;

-- Quantity = Clean

SELECT quantity, COUNT(quantity)
FROM sales_data
GROUP BY quantity
ORDER BY quantity;

-- Unit_cost = Clean

SELECT unit_cost, COUNT(unit_cost)
FROM sales_data
GROUP BY unit_cost
ORDER BY unit_cost;

-- Unit_price = Clean

SELECT unit_price, COUNT(unit_price)
FROM sales_data
GROUP BY unit_price
ORDER BY unit_price DESC;

-- Cost = Clean

SELECT cost, COUNT(cost)
FROM sales_data
GROUP BY cost
ORDER BY cost DESC;

-- Revenue = Clean

SELECT revenue, COUNT(revenue)
FROM sales_data
GROUP BY revenue
ORDER BY revenue DESC;

-- Column1: it is unclear what this column contains, most of the column contains null values, will not use this column for my analysis

-- Searching for duplicates
-- There are 11 rows that are potential duplicates, but I do not have enough information to confirm they are duplicates. Therefore I will not remove them

WITH duplicates AS
(
SELECT *, 
	ROW_NUMBER() OVER(PARTITION BY date, country, state, product_category, sub_category, quantity, customer_age, customer_gender, revenue) AS row_num
FROM sales_data
)

SELECT * 
FROM duplicates
WHERE row_num > 1;




