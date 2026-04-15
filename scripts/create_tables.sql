--Create customer table
--T1
CREATE TABLE customers(
			 customer_id VARCHAR PRIMARY KEY,
			 customer_unique_id VARCHAR,
			 customer_zip_code_prefix INT,
			 customer_city VARCHAR,
			 customer_state VARCHAR
);

SELECT *
FROM CUSTOMERS
LIMIT 100;

--T2
CREATE TABLE products(
			 product_id VARCHAR PRIMARY KEY,
			 product_category_name VARCHAR,
			 product_name_length INT,
			 product_description_length INT,
			 product_photos_qty INT,
			 product_weight_g INT,
			 product_length_cm INT,
			 product_height_cm INT,
			 product_width_cm INT
);

SELECT *
FROM PRODUCTS
LIMIT 100;

--T3
CREATE TABLE orders(
			 order_id VARCHAR PRIMARY KEY,
			 customer_id VARCHAR,
			 order_status VARCHAR,
			 order_purchase_timestamp TIMESTAMP,
			 order_approved_at TIMESTAMP,
			 order_delivered_carrier_date TIMESTAMP,
			 order_delivered_customer_date TIMESTAMP,
			 order_estimated_delivery_date TIMESTAMP
);

SELECT *
FROM ORDERS
LIMIT 5;

--T4
CREATE TABLE order_payments(
			 order_id VARCHAR,
			 payment_sequential INT,
			 payment_type VARCHAR,
			 payment_installments INT,
			 payment_value DECIMAL
);

SELECT *
FROM ORDER_payments
LIMIT 5;

DROP TABLE IF EXISTS order_items;

CREATE TABLE order_items (
			 order_id VARCHAR,
			 order_item_id INT,
			 product_id VARCHAR,
			 seller_id VARCHAR,
			 shipping_limit_date VARCHAR,
			 price DECIMAL,
			 freight_value DECIMAL
);

--Timestamp Format: DD/MM/YYYY HH24:MI:SS 
--BUT DATABASE 19/9/2017 9:45 so I use VARCHAR first.

SELECT *
FROM order_items
LIMIT 5;

--T5

CREATE TABLE order_reviews(
			 review_id VARCHAR,
			 order_id VARCHAR,
			 review_score INT,
			 review_comment_title VARCHAR,
			 review_comment_message VARCHAR,
			 review_creation_date TIMESTAMP,
			 review_answer_timestamp VARCHAR
);

DROP TABLE IF EXISTS order_reviews;

CREATE TABLE reviews_raw (
    raw_data TEXT
);

COPY reviews_raw FROM '"C:\Users\nikin\OneDrive\桌面\Dataset\Brazilian E-Commerce Public Dataset by Olist\olist_order_reviews_dataset.csv"'
WITH (FORMAT csv, QUOTE '"', DELIMITER '|');

DROP TABLE IF EXISTS order_reviews;

CREATE TABLE order_reviews_v2 (
    review_id TEXT,
    order_id TEXT,
    review_score TEXT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TEXT,
    review_answer_timestamp TEXT
);

SELECT *
FROM order_reviews_v2
LIMIT 5;

CREATE TABLE olist_reviews_final AS
SELECT 
    review_id,
    order_id,
    CAST(review_score AS INTEGER) AS review_score,
    review_comment_title,
    review_comment_message,
    TO_TIMESTAMP(review_creation_date, 'DD/MM/YYYY HH24:MI') AS review_creation_date,
    TO_TIMESTAMP(review_answer_timestamp, 'DD/MM/YYYY HH24:MI') AS review_answer_timestamp
FROM order_reviews_v2;

SELECT *
FROM olist_reviews_final
LIMIT 5;

--
My ETL Workflow:

Extract: Imported raw CSV rows into reviews_raw to bypass delimiter errors.

Transform: Parsed strings in reviews_raw into columns within order_reviews_v2.

Load: Cast data types (Score to INT, Date to TIMESTAMP) to create the final analytics-ready table olist_reviews_final.

--T6

CREATE TABLE olist_sellers_dataset (
			 seller_id VARCHAR,
			 seller_zip_code_prefix INT,
			 seller_city VARCHAR,
			 seller_state VARCHAR
);

SELECT *
FROM olist_sellers_dataset
LIMIT 5;

--T7

CREATE TABLE product_category_name_translation (
	         product_category_name VARCHAR,
			 product_category_name_english VARCHAR
);

SELECT *
FROM product_category_name_translation
LIMIT 5;

GROUP BY order_status;
