-----------Q1: Data audit (order volume, date range, invalid future dates)--------------
SELECT 
  COUNT(*) as total_orders,
  MIN(order_date) as earliest,
  MAX(order_date) as latest,
  COUNT(CASE WHEN order_date > '2024-12-31' THEN 1 END) as bad_dates
FROM ecommerce_sales_analytics_5000;

---------Q2: Revenue by category----------
SELECT 
  product_category,
  COUNT(*) as total_orders,
  ROUND(SUM(revenue), 2) as total_revenue,
  ROUND(AVG(revenue), 2) as avg_order_value,
  ROUND(AVG(customer_rating), 2) as avg_rating
FROM ecommerce_sales_analytics_5000
GROUP BY product_category
ORDER BY total_revenue DESC;

------Q3: Regional delivery performance-----

SELECT 
  region,
  ROUND(AVG(delivery_days), 1) as avg_delivery_days,
  ROUND(AVG(customer_rating), 2) as avg_rating,
  ROUND(SUM(revenue), 2) as total_revenue
FROM ecommerce_sales_analytics_5000
GROUP BY region
ORDER BY avg_delivery_days ASC;

---Q4: Customer segmentation (repeat vs one-time customers)

SELECT 
  COUNT(CASE WHEN order_count > 1 THEN 1 END) as repeat_customers,
  COUNT(CASE WHEN order_count = 1 THEN 1 END) as one_time_customers,
  ROUND(AVG(CASE WHEN order_count > 1 THEN total_spent END), 2) as repeat_avg_spend,
  ROUND(AVG(CASE WHEN order_count = 1 THEN total_spent END), 2) as onetime_avg_spend
FROM (
  SELECT 
    customer_id,
    COUNT(*) as order_count,
    SUM(revenue) as total_spent
  FROM ecommerce_sales_analytics_5000
  GROUP BY customer_id
);

--------------Q5: Discount impact----------

SELECT 
  CASE 
    WHEN discount = 0 THEN 'No discount'
    WHEN discount <= 0.15 THEN 'Low (0-15%)'
    WHEN discount <= 0.30 THEN 'Medium (15-30%)'
    ELSE 'High (30%+)'
  END as discount_bucket,
  COUNT(*) as orders,
  ROUND(AVG(revenue), 2) as avg_revenue,
  ROUND(AVG(quantity), 1) as avg_quantity,
  ROUND(AVG(customer_rating), 2) as avg_rating
FROM ecommerce_sales_analytics_5000
GROUP BY discount_bucket
ORDER BY avg_revenue DESC;