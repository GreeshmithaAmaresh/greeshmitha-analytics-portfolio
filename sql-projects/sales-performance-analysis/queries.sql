CREATE DATABASE sales_portfolio;
USE sales_portfolio;
drop database sales_portfolio;
CREATE TABLE sales (
    invoice_no INT,
    stock_code VARCHAR(10),
    description VARCHAR(100),
    quantity INT,
    unit_price DECIMAL(10,2),
    invoice_date DATETIME,
    customer_id INT,
    country VARCHAR(50)
);
show tables;

SELECT COUNT(*) AS total_rows FROM sales;
SELECT * FROM sales LIMIT 10;

-- >>>>>>>>>>   DATA VALIDATION <<<<<<<<<<<<<<<<<<
-- Date range check
SELECT 
    MIN(invoice_date) AS start_date,
    MAX(invoice_date) AS end_date
FROM sales;

-- Orders and customers
SELECT 
    COUNT(DISTINCT invoice_no) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers
FROM sales;

-- >>>>>>>>>>   KPI  <<<<<<<<<<<<<<<<<<
SELECT 
    ROUND(SUM(quantity * unit_price), 2) AS total_revenue
FROM sales;

-- >>>>>>>>>>   TIME BASED ANALYSIS  <<<<<<<<<<<<<<<<<<
SELECT 
    DATE_FORMAT(invoice_date, '%Y-%m') AS month,
    ROUND(SUM(quantity * unit_price), 2) AS monthly_revenue
FROM sales
GROUP BY month
ORDER BY month;

-- >>>>>>>>>>   PRODUCT ANALYSIS  <<<<<<<<<<<<<<<<<<
-- Top Products by Revenue
SELECT 
    description,
    ROUND(SUM(quantity * unit_price), 2) AS revenue
FROM sales
GROUP BY description
ORDER BY revenue DESC
LIMIT 10;

-- Top Products by Quantity
SELECT 
    description,
    SUM(quantity) AS total_units_sold
FROM sales
GROUP BY description
ORDER BY total_units_sold DESC;

 -- >>>>>>>>>>   CUSTOMER ANALYSIS  <<<<<<<<<<<<<<<<<<
-- Top Customers
SELECT 
    customer_id,
    ROUND(SUM(quantity * unit_price), 2) AS total_spent
FROM sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10;

-- Repeaters vs One-Time customer
SELECT
    CASE 
        WHEN order_count = 1 THEN 'One-time'
        ELSE 'Repeat'
    END AS customer_type,
    COUNT(*) AS customer_count
FROM (
    SELECT customer_id, COUNT(DISTINCT invoice_no) AS order_count
    FROM sales
    GROUP BY customer_id
) t
GROUP BY customer_type;

-- >>>>>>>>>>   ADVANCED EXCEL  <<<<<<<<<<<<<<<<<<
SELECT
    description,
    ROUND(SUM(quantity * unit_price), 2) AS revenue,
    RANK() OVER (ORDER BY SUM(quantity * unit_price) DESC) AS revenue_rank
FROM sales
GROUP BY description;



