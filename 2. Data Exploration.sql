-- DATA EXPLORATION

-- General Knowledge

-- Date ranges

SELECT MIN(date),
	MAX(date)
FROM sales_data
Customer age ranges
SELECT MIN (customer_age),
	MAX (customer_age)
FROM sales_data

-- Percentage of customers by age group

SELECT 
    CASE 
        WHEN customer_age BETWEEN 17 AND 25 THEN '17-25'
        WHEN customer_age BETWEEN 26 AND 35 THEN '26-35'
        WHEN customer_age BETWEEN 36 AND 50 THEN '36-50'
        WHEN customer_age BETWEEN 51 AND 65 THEN '51-65'
        ELSE '66+' 
    END AS age_group,
    COUNT(*) AS count_per_group,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM sales_data
GROUP BY age_group
ORDER BY age_group;

-- Product Categories and subcategories

SELECT product_category, sub_category, COUNT(*)
FROM sales_data
GROUP BY product_category, sub_category
ORDER BY product_category

-- Countries and States: Store Locations/Sales

SELECT country, state
FROM sales_data
GROUP BY country, state
ORDER BY country, state

-- Sales Performance & Profitability

-- What is the total revenue, total cost, and total profit over the given time period?
SELECT 
    SUM(revenue) AS total_revenue,
    SUM(cost) AS total_cost,
    SUM(revenue - cost) AS total_profit
FROM sales_data;

-- What is the overall profit margin, and how does it vary across product categories and subcategories?
-- Overall profit margin

SELECT 
    (SUM(revenue - cost) / SUM(revenue)) * 100 AS profit_margin_percentage
FROM sales_data;

-- Profit margin across categories

SELECT product_category,
    (SUM(revenue - cost) / SUM(revenue)) * 100 AS profit_margin_percentage
FROM sales_data
GROUP BY product_category
ORDER BY profit_margin_percentage DESC;

-- Profit margin across subcategories

SELECT product_category,
	sub_category,
    (SUM(revenue - cost) / SUM(revenue)) * 100 AS profit_margin_percentage
FROM sales_data
GROUP BY sub_category, product_category
ORDER BY profit_margin_percentage DESC;

-- Which product category and subcategory contribute the most to revenue and profit?

SELECT 
    product_category, 
    SUM(revenue) AS total_revenue, 
    SUM(cost) AS total_cost, 
    SUM(revenue - cost) AS total_profit,
    (SUM(revenue - cost) / SUM(revenue)) * 100 AS profit_margin_percentage
FROM sales_data
GROUP BY product_category
ORDER BY total_profit DESC;

-- Sub_cagegories that contribute the most to revenue and profit

SELECT 
    product_category, sub_category, 
    SUM(revenue) AS total_revenue, 
    SUM(cost) AS total_cost, 
    SUM(revenue - cost) AS total_profit,
    (SUM(revenue - cost) / SUM(revenue)) * 100 AS profit_margin_percentage
FROM sales_data
GROUP BY sub_category, product_category
ORDER BY total_profit DESC;

-- Are there any products being sold at a loss (where cost > revenue)?

SELECT 
    sub_category, 
    SUM(quantity) AS total_quantity_sold, 
    SUM(cost) AS total_cost, 
    SUM(revenue) AS total_revenue, 
    (SUM(revenue) - SUM(cost)) AS total_profit
FROM sales_data
GROUP BY sub_category
HAVING SUM(revenue) < SUM(cost)
ORDER BY total_profit;

-- Trends & Seasonality
-- How do sales fluctuate over time (monthly, quarterly, and yearly)? Are there noticeable trends?

SELECT 
    year, month, 
    SUM(revenue) AS total_revenue, 
    SUM(cost) AS total_cost, 
    SUM(revenue - cost) AS total_profit
FROM sales_data
GROUP BY year, month
ORDER BY year, month;

-- Are there seasonal peaks in sales for specific products or product categories?

SELECT 
    year, 
    month, 
    product_category, 
    SUM(quantity) AS total_quantity_sold, 
    SUM(revenue) AS total_revenue
FROM sales_data
GROUP BY year, month, product_category
ORDER BY product_category, year, month;

-- Peak months per category

WITH MonthlySales AS (
    SELECT 
        year, 
        month, 
        product_category, 
        SUM(quantity) AS total_quantity_sold, 
        SUM(revenue) AS total_revenue,
        RANK() OVER (PARTITION BY product_category ORDER BY SUM(revenue) DESC) AS sales_rank
    FROM sales_data
    GROUP BY year, month, product_category
)
SELECT * 
FROM MonthlySales 
WHERE sales_rank <= 3;

-- Which month and year had the highest and lowest sales, and what could be the reason?
-- Best and Worst Performing Months (By Revenue)

SELECT 
    year, month, 
    SUM(revenue) AS total_revenue
FROM sales_data
GROUP BY year, month
ORDER BY total_revenue DESC;

-- Customer Demographics & Behavior
-- What is the demographic breakdown of customers by age and gender?

-- Purchasing Behavior by Age Group

SELECT 
    CASE 
        WHEN customer_age BETWEEN 17 AND 25 THEN '17-25'
        WHEN customer_age BETWEEN 26 AND 35 THEN '26-35'
        WHEN customer_age BETWEEN 36 AND 50 THEN '36-50'
        WHEN customer_age BETWEEN 51 AND 65 THEN '51-65'
        ELSE '66+' 
    END AS age_group,
    COUNT(*) AS total_transactions,
    SUM(revenue) AS total_revenue
FROM sales_data
GROUP BY age_group
ORDER BY total_revenue DESC;

-- Sales Breakdown by Gender

SELECT 
    customer_gender, 
    COUNT(*) AS total_transactions, 
    SUM(revenue) AS total_revenue,
    SUM(cost) AS total_cost,
    SUM(revenue - cost) AS total_profit
FROM sales_data
GROUP BY customer_gender;

--Do different age groups have different purchasing preferences? (e.g., do younger customers buy more accessories while older customers buy more bikes?)

SELECT product_category,
    CASE 
        WHEN customer_age BETWEEN 17 AND 25 THEN '17-25'
        WHEN customer_age BETWEEN 26 AND 35 THEN '26-35'
        WHEN customer_age BETWEEN 36 AND 50 THEN '36-50'
        WHEN customer_age BETWEEN 51 AND 65 THEN '51-65'
        ELSE '66+' 
    END AS age_group,
    COUNT(*) AS total_transactions,
    SUM(revenue) AS total_revenue
FROM sales_data
GROUP BY age_group, product_category
ORDER BY product_category, total_revenue DESC

-- How do male and female customers differ in their purchasing behavior (total sales, preferred product categories?

SELECT customer_gender, 
	product_category,
	SUM(revenue) AS total_revenue
FROM sales_data
GROUP BY customer_gender, product_category
ORDER BY customer_gender, total_revenue DESC

-- Geographic Insights
-- Top Countries by Revenue

SELECT 
    country, 
    SUM(revenue) AS total_revenue, 
    SUM(revenue - cost) AS total_profit
FROM sales_data
GROUP BY country
ORDER BY total_revenue DESC;

-- Best & Worst Performing States

SELECT 
    state, 
    SUM(revenue) AS total_revenue, 
    SUM(revenue - cost) AS total_profit
FROM sales_data
GROUP BY state
ORDER BY total_revenue DESC
LIMIT 5; -- Change to ASC for lowest-performing states

-- Which country and state generate the highest revenue and profit?

SELECT country,
	state,
	SUM(revenue) AS total_revenue,
	SUM(revenue - cost) AS total_profit
FROM sales_data
GROUP BY country, state
ORDER BY total_revenue DESC

-- Are there specific regions where certain product categories sell better?

SELECT product_category,
	country,
	state,
	SUM(revenue) AS total_revenue
FROM sales_data
GROUP BY product_category, country, state
ORDER BY product_category, total_revenue DESC

-- Which country has the highest profit margins?

SELECT country,
	SUM (revenue-cost) AS total_profit,
	ROUND((SUM (revenue-cost)*100)/SUM (revenue),2) AS profit_margin
FROM sales_data
GROUP BY country
ORDER BY total_profit DESC


-- Are there any underperforming regions where sales are low but could be improved with targeted marketing?

SELECT country,
	state,
	SUM(revenue) AS total_revenue,
	SUM(revenue - cost) AS total_profit
FROM sales_data
GROUP BY country, state
ORDER BY total_revenue 

-- Product Analysis & Opportunities
-- What is the best-selling product category and subcategory in terms of quantity sold?
-- Best-selling product category

SELECT 
    product_category, 
    SUM(quantity) AS total_quantity_sold, 
    SUM(revenue) AS total_revenue
FROM sales_data
GROUP BY product_category
ORDER BY total_quantity_sold DESC;

-- Best-selling sub category

SELECT 
    product_category, 
    sub_category, 
    SUM(quantity) AS total_quantity_sold, 
    SUM(revenue) AS total_revenue
FROM sales_data
GROUP BY product_category, sub_category
ORDER BY total_quantity_sold DESC
LIMIT 5;

-- Are there any products with high unit costs but low sales volume?

SELECT 
    sub_category, 
    SUM(quantity) AS total_quantity_sold, 
    SUM(cost) AS total_cost, 
    SUM(revenue) AS total_revenue,
	SUM (revenue-cost) AS total_profit
FROM sales_data
GROUP BY sub_category
ORDER BY total_profit;

-- How do unit price and unit cost compare across different products?
-- Profit margin based on subcategory and unit cost

SELECT sub_category, 
	unit_cost,
	ROUND(AVG(unit_price),2) AS avg_unit_price,
	ROUND(AVG(unit_price)-unit_cost,2) AS gross_profit,
	ROUND((AVG(unit_price)-unit_cost)*100/AVG(unit_price),2) AS gross_profit_margin
FROM sales_data
GROUP BY sub_category, unit_cost
ORDER BY gross_profit_margin DESC

-- Profit margin on subcategory using AVG cost and selling price

SELECT sub_category, 
	ROUND(AVG(unit_cost),2) AS avg_unit_cost,
	ROUND(AVG(unit_price),2) AS avg_unit_price,
	ROUND(AVG(unit_price)- AVG(unit_cost),2) AS gross_profit,
	ROUND((AVG(unit_price)- AVG(unit_cost))*100/AVG(unit_price),2) AS gross_profit_margin
FROM sales_data
GROUP BY sub_category
ORDER BY gross_profit_margin DESC

-- Operational Efficiency & Inventory Insights
-- Products with Highest Profit Margins

SELECT 
    sub_category, 
    ROUND((SUM(revenue - cost) / SUM(revenue)),2) * 100 AS profit_margin_percentage
FROM sales_data
GROUP BY sub_category
ORDER BY profit_margin_percentage DESC
LIMIT 10;

-- Products with Lowest Profit Margins

SELECT 
    sub_category, 
    ROUND((SUM(revenue - cost) / SUM(revenue)),2) * 100 AS profit_margin_percentage
FROM sales_data
GROUP BY sub_category
ORDER BY profit_margin_percentage ASC
LIMIT 10;