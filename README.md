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

SELECT s.seller_state,
	   AVG(o.order_delivered_carrier_date - o.order_purchase_timestamp) AS avg_handling_time
FROM olist_sellers_dataset AS S
JOIN order_items AS oi ON s.seller_id = oi.seller_id
JOIN orders AS o ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY s.seller_state
ORDER BY avg_handling_time DESC
LIMIT 10





