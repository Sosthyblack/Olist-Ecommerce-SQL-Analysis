SELECT COUNT(*) AS total_customers
FROM olist_ecommerce.olist_customers_dataset;

SELECT COUNT(*) AS total_orders
FROM olist_ecommerce.olist_orders_dataset;

SELECT
    c.customer_id,
    c.customer_city,
    c.customer_state,
    o.order_id,
    o.order_status
FROM olist_ecommerce.olist_customers_dataset AS c
INNER JOIN olist_ecommerce.olist_orders_dataset AS o
    ON c.customer_id = o.customer_id
LIMIT 10;

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM olist_ecommerce.olist_orders_dataset
GROUP BY order_status
ORDER BY total_orders DESC;

SELECT
    order_status,
    COUNT(*) AS total_orders,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*)
         FROM olist_ecommerce.olist_orders_dataset),
        2
    ) AS percentage
FROM olist_ecommerce.olist_orders_dataset
GROUP BY order_status
ORDER BY total_orders DESC;


SELECT COUNT(*) AS total_order_items
FROM olist_ecommerce.olist_order_items_dataset;

SELECT
    ROUND(SUM(price), 2) AS total_sales_revenue
FROM olist_ecommerce.olist_order_items_dataset;

SELECT
    ROUND(AVG(price), 2) AS average_item_price
FROM olist_ecommerce.olist_order_items_dataset;

SELECT
    MIN(price) AS lowest_price,
    MAX(price) AS highest_price
FROM olist_ecommerce.olist_order_items_dataset;

SELECT
    COUNT(*) AS total_items,
    SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END)
        AS missing_prices
FROM olist_ecommerce.olist_order_items_dataset;

SELECT
    COUNT(*) AS invalid_prices
FROM olist_ecommerce.olist_order_items_dataset
WHERE price <= 0;

SELECT
    ROUND(AVG(order_total), 2) AS average_order_value
FROM (
    SELECT
        order_id,
        SUM(price) AS order_total
    FROM olist_ecommerce.olist_order_items_dataset
    GROUP BY order_id
) AS order_summary;

SELECT
    COUNT(DISTINCT order_id) AS unique_orders
FROM olist_ecommerce.olist_order_items_dataset;

SELECT
    ROUND(
        COUNT(*) * 1.0 / COUNT(DISTINCT order_id),
        2
    ) AS average_items_per_order
FROM olist_ecommerce.olist_order_items_dataset;

SELECT
    COUNT(*) AS orders_with_multiple_items
FROM (
    SELECT
        order_id,
        COUNT(*) AS item_count
    FROM olist_ecommerce.olist_order_items_dataset
    GROUP BY order_id
    HAVING COUNT(*) > 1
) AS multiple_item_orders;

SELECT
    item_count,
    COUNT(*) AS number_of_orders
FROM (
    SELECT
        order_id,
        COUNT(*) AS item_count
    FROM olist_ecommerce.olist_order_items_dataset
    GROUP BY order_id
) AS order_items_summary
GROUP BY item_count
ORDER BY item_count;

SELECT
    item_count,
    COUNT(*) AS number_of_orders,
    ROUND(AVG(order_total), 2) AS average_order_value
FROM (
    SELECT
        order_id,
        COUNT(*) AS item_count,
        SUM(price) AS order_total
    FROM olist_ecommerce.olist_order_items_dataset
    GROUP BY order_id
) AS order_summary
GROUP BY item_count
ORDER BY item_count;
SELECT
    order_id,
    COUNT(*) AS total_items,
    ROUND(SUM(price), 2) AS order_revenue
FROM olist_ecommerce.olist_order_items_dataset
GROUP BY order_id
ORDER BY order_revenue DESC
LIMIT 10;

SELECT
    product_id,
    COUNT(*) AS units_sold,
    ROUND(SUM(price), 2) AS total_revenue
FROM olist_ecommerce.olist_order_items_dataset
GROUP BY product_id
ORDER BY total_revenue DESC
LIMIT 10;

SELECT
    product_id,
    COUNT(*) AS units_sold,
    ROUND(SUM(price), 2) AS total_revenue
FROM olist_ecommerce.olist_order_items_dataset
GROUP BY product_id
ORDER BY units_sold DESC
LIMIT 10;

SELECT
    product_id,
    COUNT(*) AS units_sold,
    ROUND(AVG(price), 2) AS average_price,
    ROUND(SUM(price), 2) AS total_revenue
FROM olist_ecommerce.olist_order_items_dataset
GROUP BY product_id
ORDER BY average_price DESC
LIMIT 10;

SELECT
    product_id,
    COUNT(*) AS units_sold,
    ROUND(AVG(price), 2) AS average_price,
    ROUND(SUM(price), 2) AS total_revenue
FROM olist_ecommerce.olist_order_items_dataset
GROUP BY product_id
HAVING COUNT(*) >= 10
ORDER BY total_revenue DESC
LIMIT 10;

SELECT
    seller_id,
    COUNT(*) AS items_sold,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(price), 2) AS total_revenue
FROM olist_ecommerce.olist_order_items_dataset
GROUP BY seller_id
ORDER BY total_revenue DESC
LIMIT 10;

SELECT
    seller_id,
    COUNT(*) AS items_sold,
    ROUND(AVG(price), 2) AS average_item_price,
    ROUND(SUM(price), 2) AS total_revenue
FROM olist_ecommerce.olist_order_items_dataset
GROUP BY seller_id
ORDER BY total_revenue DESC
LIMIT 10;

SELECT
    o.order_status,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(*) AS items_sold,
    ROUND(SUM(oi.price), 2) AS total_item_value
FROM olist_ecommerce.olist_order_items_dataset AS oi
INNER JOIN olist_ecommerce.olist_orders_dataset AS o
    ON oi.order_id = o.order_id
GROUP BY o.order_status
ORDER BY total_item_value DESC;

SELECT
    COUNT(DISTINCT oi.order_id) AS delivered_orders,
    ROUND(SUM(oi.price), 2) AS delivered_item_revenue
FROM olist_ecommerce.olist_order_items_dataset AS oi
INNER JOIN olist_ecommerce.olist_orders_dataset AS o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered';

SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS sales_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_item_revenue
FROM olist_ecommerce.olist_orders_dataset AS o
INNER JOIN olist_ecommerce.olist_order_items_dataset AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY sales_month;

SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS sales_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_item_revenue
FROM olist_ecommerce.olist_orders_dataset AS o
INNER JOIN olist_ecommerce.olist_order_items_dataset AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY total_item_revenue DESC
LIMIT 5;

SELECT
    ROUND(AVG(monthly_revenue), 2) AS average_monthly_revenue
FROM (
    SELECT
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS sales_month,
        SUM(oi.price) AS monthly_revenue
    FROM olist_ecommerce.olist_orders_dataset AS o
    INNER JOIN olist_ecommerce.olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
) AS monthly_sales;

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS sales_month,
        ROUND(SUM(oi.price), 2) AS monthly_revenue
    FROM olist_ecommerce.olist_orders_dataset AS o
    INNER JOIN olist_ecommerce.olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
)
SELECT
    sales_month,
    monthly_revenue
FROM monthly_sales
WHERE monthly_revenue > (
    SELECT AVG(monthly_revenue)
    FROM monthly_sales
)
ORDER BY monthly_revenue DESC;

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS sales_month,
        ROUND(SUM(oi.price), 2) AS monthly_revenue
    FROM olist_ecommerce.olist_orders_dataset AS o
    INNER JOIN olist_ecommerce.olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
)
SELECT
    sales_month,
    monthly_revenue
FROM monthly_sales
WHERE monthly_revenue < (
    SELECT AVG(monthly_revenue)
    FROM monthly_sales
)
ORDER BY monthly_revenue ASC;

SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS sales_month,
    COUNT(*) AS total_orders
FROM olist_ecommerce.olist_orders_dataset
WHERE YEAR(order_purchase_timestamp) = 2016
GROUP BY DATE_FORMAT(order_purchase_timestamp, '%Y-%m')
ORDER BY sales_month;

SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS sales_month,
    COUNT(*) AS total_orders
FROM olist_ecommerce.olist_orders_dataset
WHERE YEAR(order_purchase_timestamp) = 2018
GROUP BY DATE_FORMAT(order_purchase_timestamp, '%Y-%m')
ORDER BY sales_month;

SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS sales_month,
    COUNT(DISTINCT o.order_id) AS delivered_orders,
    ROUND(SUM(oi.price), 2) AS item_sales_value
FROM olist_ecommerce.olist_orders_dataset AS o
INNER JOIN olist_ecommerce.olist_order_items_dataset AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
  AND o.order_purchase_timestamp >= '2017-01-01'
  AND o.order_purchase_timestamp < '2018-09-01'
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY sales_month;

SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS sales_month,
    ROUND(SUM(oi.price), 2) AS item_sales_value
FROM olist_ecommerce.olist_orders_dataset AS o
INNER JOIN olist_ecommerce.olist_order_items_dataset AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
  AND o.order_purchase_timestamp >= '2017-01-01'
  AND o.order_purchase_timestamp < '2018-09-01'
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY item_sales_value DESC
LIMIT 5;

SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS sales_month,
    ROUND(SUM(oi.price), 2) AS item_sales_value
FROM olist_ecommerce.olist_orders_dataset AS o
INNER JOIN olist_ecommerce.olist_order_items_dataset AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
  AND o.order_purchase_timestamp >= '2017-01-01'
  AND o.order_purchase_timestamp < '2018-09-01'
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY item_sales_value ASC
LIMIT 5;

SELECT
    COUNT(*) AS delivered_orders
FROM olist_ecommerce.olist_orders_dataset
WHERE order_status = 'delivered'
  AND order_purchase_timestamp >= '2017-01-01'
  AND order_purchase_timestamp < '2017-02-01';
  
  SELECT
    ROUND(
        SUM(oi.price) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM olist_ecommerce.olist_orders_dataset AS o
INNER JOIN olist_ecommerce.olist_order_items_dataset AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
  AND o.order_purchase_timestamp >= '2017-01-01'
  AND o.order_purchase_timestamp < '2017-02-01';
  
  SELECT
    COUNT(DISTINCT o.order_id) AS delivered_orders,
    ROUND(SUM(oi.price), 2) AS total_item_sales,
    ROUND(
        SUM(oi.price) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM olist_ecommerce.olist_orders_dataset AS o
INNER JOIN olist_ecommerce.olist_order_items_dataset AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
  AND o.order_purchase_timestamp >= '2017-11-01'
  AND o.order_purchase_timestamp < '2017-12-01';
  
  -- BUSINESS INSIGHT:
-- November 2017 generated much higher item sales than January 2017.
-- Delivered orders increased from 750 to 7,289.
-- Average order value decreased from 149.06 to 135.51.
-- Therefore, sales growth was driven mainly by higher order volume,
-- rather than customers spending more per order.

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM olist_ecommerce.olist_orders_dataset
WHERE order_status IN ('delivered', 'canceled')
GROUP BY order_status;

SELECT
    COUNT(*) AS total_orders,
    SUM(CASE WHEN order_status = 'canceled' THEN 1 ELSE 0 END)
        AS canceled_orders,
    ROUND(
        100.0 * SUM(CASE WHEN order_status = 'canceled' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS cancellation_rate_percent
FROM olist_ecommerce.olist_orders_dataset;

-- BUSINESS INSIGHT:
-- The dataset contains 99,441 orders.
-- Of these, 625 orders were cancelled.
-- The overall cancellation rate was 0.63%.
-- This indicates that cancellations represented a small
-- proportion of total orders.
-- Further analysis could investigate cancellation trends
-- over time and identify potential causes.

SELECT
    YEAR(order_purchase_timestamp) AS order_year,
    COUNT(*) AS canceled_orders
FROM olist_ecommerce.olist_orders_dataset
WHERE order_status = 'canceled'
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY order_year;

SELECT
    YEAR(order_purchase_timestamp) AS order_year,
    COUNT(*) AS total_orders,
    SUM(CASE
        WHEN order_status = 'canceled' THEN 1
        ELSE 0
    END) AS canceled_orders,
    ROUND(
        100.0 * SUM(CASE
            WHEN order_status = 'canceled' THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS cancellation_rate_percent
FROM olist_ecommerce.olist_orders_dataset
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY order_year;

-- BUSINESS INSIGHT:
-- The cancellation rate was 7.90% in 2016,
-- based on a relatively small number of orders (329).
-- In 2017, the cancellation rate was 0.59%.
-- In 2018, the cancellation rate was 0.62%.
-- Although cancellation counts increased between 2017
-- and 2018, the rates remained relatively stable.
-- The 2016 results should be interpreted cautiously
-- because the dataset contains limited activity that year.
-- Further monthly analysis could identify periods
-- with unusually high cancellation rates.

SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS order_month,
    COUNT(*) AS total_orders,
    SUM(CASE
        WHEN order_status = 'canceled' THEN 1
        ELSE 0
    END) AS canceled_orders,
    ROUND(
        100.0 * SUM(CASE
            WHEN order_status = 'canceled' THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS cancellation_rate_percent
FROM olist_ecommerce.olist_orders_dataset
GROUP BY DATE_FORMAT(order_purchase_timestamp, '%Y-%m')
ORDER BY order_month;

SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS order_month,
    COUNT(*) AS total_orders,
    SUM(CASE
        WHEN order_status = 'canceled' THEN 1
        ELSE 0
    END) AS canceled_orders,
    ROUND(
        100.0 * SUM(CASE
            WHEN order_status = 'canceled' THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS cancellation_rate_percent
FROM olist_ecommerce.olist_orders_dataset
GROUP BY DATE_FORMAT(order_purchase_timestamp, '%Y-%m')
HAVING COUNT(*) >= 500
ORDER BY cancellation_rate_percent DESC;

-- BUSINESS INSIGHT:
-- After excluding months with fewer than 500 orders,
-- August 2018 had the highest cancellation rate at 1.29%.
-- During this month, 84 out of 6,512 orders were canceled.
-- March 2017 followed with a cancellation rate of 1.23%.
-- February 2018 had a cancellation rate of 1.09%.
-- These findings suggest that August 2018 may warrant
-- further investigation into potential cancellation drivers.
-- The analysis does not establish the causes of cancellations.

SELECT
    c.customer_state,
    COUNT(*) AS total_orders,
    SUM(CASE
        WHEN o.order_status = 'canceled' THEN 1
        ELSE 0
    END) AS canceled_orders,
    ROUND(
        100.0 * SUM(CASE
            WHEN o.order_status = 'canceled' THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS cancellation_rate_percent
FROM olist_ecommerce.olist_orders_dataset AS o
INNER JOIN olist_ecommerce.olist_customers_dataset AS c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_state
HAVING COUNT(*) >= 100
ORDER BY cancellation_rate_percent DESC;

-- BUSINESS INSIGHT:
-- Rondônia (RO) had the highest cancellation rate at 1.19%
-- among customer states with at least 100 orders.
-- São Paulo (SP) recorded 327 canceled orders,
-- the highest cancellation count among the states shown.
-- This highlights the difference between cancellation
-- rates and the absolute number of canceled orders.
-- Further investigation could examine why cancellation
-- patterns differ between customer states.

SELECT
    c.customer_state,
    COUNT(*) AS canceled_orders
FROM olist_ecommerce.olist_orders_dataset AS o
INNER JOIN olist_ecommerce.olist_customers_dataset AS c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'canceled'
GROUP BY c.customer_state
ORDER BY canceled_orders DESC
LIMIT 10;

-- BUSINESS INSIGHT:
-- São Paulo (SP) recorded the highest number of canceled
-- orders, with 327 cancellations.
-- Rio de Janeiro (RJ) followed with 86 cancellations,
-- while Minas Gerais (MG) recorded 64.
-- These states account for a substantial share of
-- cancellations and may warrant further investigation.
-- However, cancellation counts should be considered
-- alongside total order volumes and cancellation rates.

-- BUSINESS RECOMMENDATIONS:
-- 1. Investigate cancellation reasons in São Paulo,
--    Rio de Janeiro, and Minas Gerais because these
--    states have the highest cancellation volumes.
--
-- 2. Review cancellation patterns in August 2018,
--    which had the highest monthly cancellation rate
--    among months with at least 500 orders.
--
-- 3. Monitor cancellation rates and order volumes
--    together in a monthly performance dashboard.
--    This would help identify emerging problems
--    without overreacting to small sample sizes.
--
-- These recommendations are based on observed patterns.
-- Further investigation is needed before determining
-- the causes of cancellations.

