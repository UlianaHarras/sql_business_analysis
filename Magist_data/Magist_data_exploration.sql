use magist;

# 1. Number of orders 99441:
SELECT 
    COUNT(order_id) AS order_count
FROM
    orders;
SELECT DISTINCT
    order_id
FROM
    orders
ORDER BY order_id
LIMIT 100000;

# 2.Are orders actually delivered?
SELECT 
    order_status, COUNT(order_status) AS count_order_status
FROM
    orders
GROUP BY order_status;

# 3. Is Magist having user growth?
SELECT 
    COUNT(order_id),
    YEAR(order_purchase_timestamp) AS order_year,
    MONTH(order_purchase_timestamp) AS order_month
FROM
    orders
GROUP BY order_year , order_month
ORDER BY order_year , order_month;

# Is there an order growth?
SELECT 
    COUNT(order_id),
    YEAR(order_purchase_timestamp) AS order_year
FROM
    orders
GROUP BY order_year
ORDER BY order_year;

SELECT 
    COUNT(customer_id),
    YEAR(order_purchase_timestamp) AS order_year,
    MONTH(order_purchase_timestamp) AS order_month
FROM
    orders
GROUP BY order_year , order_month
ORDER BY order_year , order_month;

SELECT 
    COUNT(customer_id),
    YEAR(order_purchase_timestamp) AS order_year
FROM
    orders
GROUP BY order_year
ORDER BY order_year;

# 4. How many distinct products are there on the products table? 
SELECT 
    COUNT(product_id) AS distinct_products
FROM
    products;
SELECT DISTINCT
    product_id
FROM
    products
ORDER BY product_id
LIMIT 50000;

# 5. Which are the categories with the most products? 
SELECT 
    COUNT(DISTINCT product_id) AS amount_of_products,
    product_category_name_english
FROM
    products
        LEFT JOIN
    product_category_name_translation ON products.product_category_name = product_category_name_translation.product_category_name
GROUP BY product_category_name_english
ORDER BY amount_of_products DESC;

# 6. How many of those products were present in actual transactions?
SELECT 
    COUNT(DISTINCT product_id)
FROM
    order_items;

# 7. What’s the price for the most expensive and cheapest products?
SELECT 
    MAX(price) AS maximal_price, MIN(price) AS minimal_price
FROM
    order_items;

# 8. What are the highest and lowest payment values? 
SELECT 
    MAX(payment_value) AS max_payment_value,
    MIN(payment_value) AS min_payment_value
FROM
    order_payments;
SELECT 
    SUM(payment_value)
FROM
    order_payments
GROUP BY order_id
ORDER BY SUM(payment_value) DESC;

# 9. Selecting all technical products
SELECT 
    COUNT(product_id) AS amount_of_products,
    product_category_name_english
FROM
    products
        LEFT JOIN
    product_category_name_translation ON products.product_category_name = product_category_name_translation.product_category_name
WHERE
    product_category_name_english IN ('computers_accessories' , 'cine_photo',
        'pc_gamer',
        'electronics',
        'home_appliances',
        'consoles_games',
        'small_appliances',
        'air_conditioning',
        'signaling_and_security',
        'home_appliances_2',
        'audio',
        'small_appliances_home_oven_and_coffee',
        'computers',
        'portable_kitchen_food_processors',
        'tablets_printing_image')
GROUP BY product_category_name_english
ORDER BY amount_of_products DESC;

# 10. How many products of these tech categories have been sold (within the time window of the database snapshot)?
SELECT 
    COUNT(order_id) AS amount_of_products_sold,
    product_category_name_english
FROM
    order_items
        LEFT JOIN
    products ON order_items.product_id = products.product_id
        LEFT JOIN
    product_category_name_translation ON products.product_category_name = product_category_name_translation.product_category_name
WHERE
    product_category_name_english IN ('computers_accessories' , 'cine_photo',
        'pc_gamer',
        'electronics',
        'home_appliances',
        'consoles_games',
        'small_appliances',
        'air_conditioning',
        'signaling_and_security',
        'home_appliances_2',
        'audio',
        'small_appliances_home_oven_and_coffee',
        'computers',
        'portable_kitchen_food_processors',
        'tablets_printing_image')
GROUP BY product_category_name_english
ORDER BY amount_of_products_sold DESC;

# 11. The overall number of products sold 32951
SELECT 
    COUNT(DISTINCT (product_id)) AS products_sold
FROM
    order_items;
    
# 12. What percentage does that represent from the overall number of products sold? 3550 tech products sold
SELECT COUNT(DISTINCT(oi.product_id)) AS tech_products_sold
FROM order_items oi
LEFT JOIN products p 
	USING (product_id)
LEFT JOIN product_category_name_translation pt
	USING (product_category_name)
WHERE product_category_name_english in ('computers_accessories','cine_photo','pc_gamer','electronics','home_appliances',
'consoles_games','small_appliances','air_conditioning','signaling_and_security',
'home_appliances_2','audio','small_appliances_home_oven_and_coffee','computers',
'portable_kitchen_food_processors','tablets_printing_image') ;

# 14. What’s the average price of the products being sold?
SELECT 
    AVG(price) AS average_price
FROM
    order_items;

# 15. Average price per tech category
SELECT 
    AVG(price) AS average_price, product_category_name_english
FROM
    order_items
        LEFT JOIN
    products ON order_items.product_id = products.product_id
        LEFT JOIN
    product_category_name_translation ON products.product_category_name = product_category_name_translation.product_category_name
WHERE
    product_category_name_english IN ('computers_accessories' , 'cine_photo',
        'pc_gamer',
        'electronics',
        'home_appliances',
        'consoles_games',
        'small_appliances',
        'air_conditioning',
        'signaling_and_security',
        'home_appliances_2',
        'audio',
        'small_appliances_home_oven_and_coffee',
        'computers',
        'portable_kitchen_food_processors',
        'tablets_printing_image')
GROUP BY product_category_name_english
ORDER BY average_price DESC;

# 16. Are expensive tech products popular? Products, which cost >1000 euro are counted as expensive
#Joining Tables
Create table Order_items_products
select * from order_items oi
LEFT JOIN products p
	using (product_id)
LEFT JOIN product_category_name_translation pt
	USING (product_category_name);
    
# Categorising products to Tech/Non_tech and  Expensive/Mid-Range/Cheap 
CREATE TABLE Popularity_1
SELECT 
    COUNT(product_id) AS amount_of_products_sold,
    CASE
        WHEN
            product_category_name_english IN ('computers_accessories' , 'cine_photo',
                'pc_gamer',
                'electronics',
                'home_appliances',
                'consoles_games',
                'small_appliances',
                'air_conditioning',
                'signaling_and_security',
                'home_appliances_2',
                'audio',
                'small_appliances_home_oven_and_coffee',
                'computers',
                'portable_kitchen_food_processors',
                'tablets_printing_image')
        THEN
            'Tech'
        ELSE 'Non-tech'
    END AS 'product_type',
    CASE
        WHEN price > 500 THEN 'Expensive'
        WHEN price > 100 THEN 'Mid-range'
        ELSE 'Cheap'
    END AS 'price_range'
FROM
    Order_items_products
        LEFT JOIN
    order_payments USING (order_id)
GROUP BY product_type , price_range
ORDER BY product_type , price_range;

# Calculating ratio of sold in specific category to all sold Tech/Non-Tech products
CREATE TABLE Total_amount SELECT SUM(amount_of_products_sold) AS total_amount, product_type FROM
    Popularity_1
GROUP BY product_type;

# Calculating popularity (%)
SELECT 
    product_type,
    price_range,
    amount_of_products_sold,
    total_amount,
    ROUND(amount_of_products_sold / total_amount * 100) AS 'popularity_%'
FROM
    Popularity_1
        LEFT JOIN
    Total_amount USING (product_type);

#####Sellers
# 17. How many months of data are included in the magist database? 25 months
SELECT 
    YEAR(order_purchase_timestamp) AS order_year,
    MONTH(order_purchase_timestamp) AS order_month
FROM
    orders
GROUP BY order_year , order_month
ORDER BY order_year , order_month;

# 18 How many sellers are there? How many Tech sellers are there? What percentage of overall sellers are Tech sellers?
SELECT 
    *
FROM
    sellers
LIMIT 100000;
# There are 936 Tech sellers, it is 3,76 percent from all sellers
SELECT 
    COUNT(seller_id)
FROM
    sellers;SELECT 
    COUNT(DISTINCT (seller_id)) AS tech_sellers,
    COUNT(DISTINCT (seller_id)) / COUNT(seller_id) * 100 AS tech_to_overall
FROM
    sellers s
        LEFT JOIN
    order_items o USING (seller_id)
        LEFT JOIN
    products p USING (product_id)
        LEFT JOIN
    product_category_name_translation pc USING (product_category_name)
WHERE
    product_category_name_english IN ('computers_accessories' , 'cine_photo',
        'pc_gamer',
        'electronics',
        'home_appliances',
        'consoles_games',
        'small_appliances',
        'air_conditioning',
        'signaling_and_security',
        'home_appliances_2',
        'audio',
        'small_appliances_home_oven_and_coffee',
        'computers',
        'portable_kitchen_food_processors',
        'tablets_printing_image');

# 19.What is the total amount earned by all sellers  ? 13591643.701720357 euro
SELECT 
    SUM(price)
FROM
    sellers
        LEFT JOIN
    order_items USING (seller_id);

# 20.What is the total amount earned by all Tech sellers? 3820658.3850183487 euro
SELECT 
    SUM(price) AS total_amount_earned
FROM
    sellers
        LEFT JOIN
    order_items USING (seller_id)
        LEFT JOIN
    products p USING (product_id)
        LEFT JOIN
    product_category_name_translation pc USING (product_category_name)
WHERE
    product_category_name_english IN ('computers_accessories' , 'cine_photo',
        'pc_gamer',
        'electronics',
        'home_appliances',
        'consoles_games',
        'small_appliances',
        'air_conditioning',
        'signaling_and_security',
        'home_appliances_2',
        'audio',
        'small_appliances_home_oven_and_coffee',
        'computers',
        'portable_kitchen_food_processors',
        'tablets_printing_image');

# 21. What is the average monthly income of all sellers? 
SELECT 
    AVG(price) AS aver_month_income,
    YEAR(order_purchase_timestamp) AS year_p,
    MONTH(order_purchase_timestamp) AS month_p
FROM
    sellers
        LEFT JOIN
    order_items USING (seller_id)
        LEFT JOIN
    orders USING (order_id)
GROUP BY year_p , month_p
ORDER BY year_p , month_p;

# 22. What is the average monthly income of Tech sellers?
SELECT 
    AVG(price) AS aver_month_income,
    YEAR(order_purchase_timestamp) AS year_p,
    MONTH(order_purchase_timestamp) AS month_p
FROM
    sellers
        LEFT JOIN
    order_items USING (seller_id)
        LEFT JOIN
    orders USING (order_id)
        LEFT JOIN
    products p USING (product_id)
        LEFT JOIN
    product_category_name_translation pc USING (product_category_name)
WHERE
    product_category_name_english IN ('computers_accessories' , 'cine_photo',
        'pc_gamer',
        'electronics',
        'home_appliances',
        'consoles_games',
        'small_appliances',
        'air_conditioning',
        'signaling_and_security',
        'home_appliances_2',
        'audio',
        'small_appliances_home_oven_and_coffee',
        'computers',
        'portable_kitchen_food_processors',
        'tablets_printing_image')
GROUP BY year_p , month_p
ORDER BY year_p , month_p;

####Delivery
# 23. What’s the average time between the order being placed and the product being delivered? 
SELECT 
    TIMESTAMPDIFF(HOUR,
        order_purchase_timestamp,
        order_delivered_customer_date) AS a,
    order_purchase_timestamp,
    order_delivered_customer_date
FROM
    orders;
SELECT 
    AVG(TIMESTAMPDIFF(HOUR,
        order_purchase_timestamp,
        order_delivered_customer_date)) AS avg_delivery_time_hours_customer300,
    AVG(TIMESTAMPDIFF(HOUR,
        order_purchase_timestamp,
        order_delivered_carrier_date)) AS avg_delivery_time_hours_carrier
FROM
    orders
WHERE
    order_delivered_customer_date IS NOT NULL;

# 24. How many orders are delivered on time vs orders delivered with a delay?
SELECT 
    COUNT(order_id)
FROM
    orders
WHERE
    TIMESTAMP(order_estimated_delivery_date) < TIMESTAMP(order_delivered_customer_date)
        AND (order_estimated_delivery_date IS NOT NULL)
        AND (order_delivered_customer_date IS NOT NULL);

SELECT 
    COUNT(DISTINCT order_id)
FROM
    orders
WHERE
    TIMESTAMP(order_estimated_delivery_date) >= TIMESTAMP(order_delivered_customer_date)
        AND (order_estimated_delivery_date IS NOT NULL)
        AND (order_delivered_customer_date IS NOT NULL);

# 25.Is there any pattern for delayed orders, e.g. big products being delayed more often?
SELECT 
    *
FROM
    orders
        LEFT JOIN
    order_items USING (order_id)
        LEFT JOIN
    products USING (product_id)
        LEFT JOIN
    product_category_name_translation USING (product_category_name)
WHERE
    TIMESTAMP(order_estimated_delivery_date) < TIMESTAMP(order_delivered_customer_date)
        AND (order_estimated_delivery_date IS NOT NULL)
        AND (order_delivered_customer_date IS NOT NULL);
