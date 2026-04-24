# Olist Supply Chain & Logistics Performance Analysis

## Project Overview

This project focuese on modeling and analyzing end-toend supply chain data for a Brazilian e-commerce platform using **PostgreSQL**.  The goal is to identify logistical bottlenecks, anlyze delivery lead times, and perform Root Cause Analysis on Shipping delays.

## Data Modeling (ERD)

I designed a ""Star Schema** to ensure data integrity and enable complex cross-table queries.

<img width="1850" height="1301" alt="image" src="https://github.com/user-attachments/assets/28d613e7-fa19-4036-954e-bb29c94b4ad5" />

Key Relationship:

Orders: Certral hub connecting customers, payments, and logiestics. 

Logistics Flow: Linked 'Sellers' and 'Products' to 'Order_Items' to track supplier perfomance.

Customer Feedback: Connected 'Reviews' to 'Orders' to correlate delivery speed with satisfaction scores.

--

Supplier Lead Time (or Handling Time): order_delivered_carrier_date - order_purchase_timestamp

Carrier Transit Time: order_delivered_customer_date - order_delivered_carrier_date

Total Order Lead Time: order_delivered_customer_date - order_purchase_timestamp

-- Query 1: Top 10 States with slowest seller handling time
Objective: To see how long it takes the supplier from receiving the order to packing the goods and delivering them to the logistics company.

SELECT s.seller_state,
	   AVG(o.order_delivered_carrier_date - o.order_purchase_timestamp) AS avg_handling_time
FROM olist_sellers_dataset AS S
JOIN order_items AS oi ON s.seller_id = oi.seller_id
JOIN orders AS o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY s.seller_state
ORDER BY avg_handling_time DESC
LIMIT 10

<img width="506" height="542" alt="image" src="https://github.com/user-attachments/assets/b7e4428d-4e54-4d0b-b651-83961e65dfe4" />


-- Query 2: Identifying the pure shipping duration (Transit Time)
Objective: Regardless of how long the seller takes to pick up the goods, it purely depends on how long it takes the logistics company from taking over to delivering to the customer.

SELECT 
    order_id,
    order_purchase_timestamp,
    (order_delivered_customer_date - order_delivered_carrier_date) AS transit_time
FROM orders
WHERE order_status = 'delivered' 
AND order_delivered_carrier_date IS NOT NULL
ORDER BY transit_time DESC
LIMIT 10;

<img width="902" height="557" alt="image" src="https://github.com/user-attachments/assets/a89e0f24-727d-4c4c-831a-39c422f72850" />


Data Cleaning.

Although order_status is 'delivered', sometimes the system misses order_delivered_carrier_date (seller delivery date), or the data is misplaced. Without one of the time points, SQL cannot calculate the difference.

SELECT 
    order_id,
    order_purchase_timestamp,
    (order_delivered_customer_date - order_delivered_carrier_date) AS transit_time
FROM orders
WHERE order_status = 'delivered' 
  AND order_delivered_carrier_date IS NOT NULL  
  AND order_delivered_customer_date IS NOT NULL
ORDER BY transit_time DESC
LIMIT 10;

<img width="868" height="506" alt="image" src="https://github.com/user-attachments/assets/b54d8d3e-de62-4bc1-9525-318b523bffbb" />


-- Query 3: Comparing Estimated vs Actual Delivery

SELECT 
    order_id,
    order_estimated_delivery_date,
    order_delivered_customer_date,
    -- 計出實際遲咗幾多
    (order_delivered_customer_date - order_estimated_delivery_date) AS delay_duration,
    CASE 
        WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 'On-Time'
        ELSE 'Delayed'
    END AS delivery_status
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
ORDER BY delay_duration DESC -- 遲得最耐嘅排第一
LIMIT 10;

<img width="1360" height="519" alt="image" src="https://github.com/user-attachments/assets/b30129b8-c4f4-4e52-b6a8-e266fe1ded95" />














