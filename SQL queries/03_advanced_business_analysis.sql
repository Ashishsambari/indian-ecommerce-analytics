SELECT
    c.customer_segment,
    COUNT(DISTINCT c.customer_id) AS customers,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(SUM(oi.item_revenue), 2) AS revenue,
    ROUND(AVG(oi.item_revenue), 2) AS avg_item_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_segment
ORDER BY revenue DESC;


SELECT
    customer_type,
    COUNT(*) AS total_customers
FROM (
    SELECT
        customer_id,
        CASE
            WHEN COUNT(DISTINCT order_id) > 1
                THEN 'Repeat Customer'
            ELSE 'One-Time Customer'
        END AS customer_type
    FROM orders
    GROUP BY customer_id
) AS customer_groups
GROUP BY customer_type;

SELECT
    p.category,
    COUNT(DISTINCT oi.order_item_id) AS items_sold,
    COUNT(DISTINCT r.return_id) AS returned_items,
    ROUND(
        COUNT(DISTINCT r.return_id) * 100.0 /
        NULLIF(COUNT(DISTINCT oi.order_item_id), 0),
        2
    ) AS return_rate
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
LEFT JOIN `returns` r
    ON oi.order_id = r.order_id
    AND oi.product_id = r.product_id
GROUP BY p.category
ORDER BY return_rate DESC;


SELECT
    delivery_status,
    COUNT(*) AS shipments,
    ROUND(AVG(delivery_days), 2) AS avg_delivery_days,
    ROUND(AVG(delayed_flag) * 100, 2) AS delay_percentage
FROM shipments
GROUP BY delivery_status
ORDER BY shipments DESC;