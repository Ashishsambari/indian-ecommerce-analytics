CREATE OR REPLACE VIEW vw_monthly_sales AS
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    ROUND(SUM(o.final_amount), 2) AS gross_order_value,
    ROUND(AVG(o.final_amount), 2) AS average_order_value
FROM orders o
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m');


CREATE OR REPLACE VIEW vw_customer_performance AS
SELECT
    c.customer_id,
    c.customer_segment,
    c.state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(o.final_amount), 2) AS total_revenue,
    MAX(o.order_date) AS last_purchase_date
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_segment,
    c.state;
    
    
    
    CREATE OR REPLACE VIEW vw_product_performance AS
SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.item_revenue), 2) AS revenue,
    ROUND(SUM(oi.profit), 2) AS profit,
    ROUND(
        SUM(oi.profit) * 100.0 /
        NULLIF(SUM(oi.item_revenue), 0),
        2
    ) AS profit_margin
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category;
    
    
    
    SELECT * FROM vw_monthly_sales LIMIT 10;

SELECT * FROM vw_customer_performance LIMIT 10;

SELECT * FROM vw_product_performance
ORDER BY revenue DESC
LIMIT 10;