-- =====================================
-- DATA VALIDATION
-- =====================================

-- Total number of records
SELECT COUNT(*) AS total_rows
FROM sales;

-- Date range check
SELECT 
    MIN(invoice_date) AS start_date,
    MAX(invoice_date) AS end_date
FROM sales;

-- Total orders and customers
SELECT 
    COUNT(DISTINCT invoice_no) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers
FROM sales;

-- Revenue contribution by country
SELECT 
    country,
    ROUND(SUM(quantity * unit_price), 2) AS total_revenue,
    ROUND(
        100 * SUM(quantity * unit_price) /
        (SELECT SUM(quantity * unit_price) FROM sales),
        2
    ) AS revenue_percentage
FROM sales
GROUP BY country
ORDER BY total_revenue DESC;



-- =====================================
-- REVENUE ANALYSIS
-- =====================================

-- Total revenue
SELECT 
    ROUND(SUM(quantity * unit_price), 2) AS total_revenue
FROM sales;


-- =====================================
-- TIME-BASED ANALYSIS
-- =====================================

-- Monthly revenue trend
SELECT 
    DATE_FORMAT(invoice_date, '%Y-%m') AS month,
    ROUND(SUM(quantity * unit_price), 2) AS monthly_revenue
FROM sales
GROUP BY month
ORDER BY month;


-- =====================================
-- PRODUCT PERFORMANCE
-- =====================================

-- Top products by revenue
SELECT 
    description,
    ROUND(SUM(quantity * unit_price), 2) AS revenue
FROM sales
GROUP BY description
ORDER BY revenue DESC
LIMIT 10;

-- Top products by quantity sold
SELECT 
    description,
    SUM(quantity) AS total_units_sold
FROM sales
GROUP BY description
ORDER BY total_units_sold DESC;


-- =====================================
-- CUSTOMER ANALYSIS
-- =====================================

-- Top customers by total spend
SELECT 
    customer_id,
    ROUND(SUM(quantity * unit_price), 2) AS total_spent
FROM sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10;

-- Repeat vs one-time customers
SELECT
    CASE 
        WHEN order_count = 1 THEN 'One-time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS customer_count
FROM (
    SELECT 
        customer_id,
        COUNT(DISTINCT invoice_no) AS order_count
    FROM sales
    GROUP BY customer_id
) t
GROUP BY customer_type;


-- =====================================
-- ADVANCED SQL
-- =====================================

-- Revenue ranking using window function
SELECT
    description,
    ROUND(SUM(quantity * unit_price), 2) AS revenue,
    RANK() OVER (ORDER BY SUM(quantity * unit_price) DESC) AS revenue_rank
FROM sales
GROUP BY description;
