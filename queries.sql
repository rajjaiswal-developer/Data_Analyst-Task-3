-- 1. USE SELECT, WHERE, ORDER BY List all products with price 6000, ordered by price 
SELECT 
    product_name, 
    price 
FROM 
    products 
WHERE 
    price > 6000 
ORDER BY 
    price DESC;


-- 2. GROUP BY with Aggregate Functions  - Total sales by category
SELECT 
    c.category_name, 
    SUM(p.price * oi.quantity) AS total_sales
FROM 
    order_items oi
JOIN 
    products p ON oi.product_id = p.product_id
JOIN 
    categories c ON p.category_id = c.category_id
GROUP BY 
    c.category_name
ORDER BY 
    total_sales DESC;


/*-------- Use JOINS (INNER, LEFT, RIGHT) --------*/

-- 3.1 INNER JOIN: Orders with customer info
SELECT o.order_id, o.order_date, c.customer_name
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

-- 3.2 LEFT JOIN: All products and their order quantities
SELECT p.product_name, c.category_name, oi.quantity
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN categories c ON p.category_id = c.category_id;

-- 3.3 RIGHT JOIN using LEFT JOIN (by swapping tables): All order items and include product info
SELECT oi.order_id, oi.product_id, p.product_name, p.price
FROM products p
RIGHT JOIN order_items oi ON p.product_id = oi.product_id;


-- 4. SUBQUERY: Customers who placed 2 or more orders
SELECT 
    c.customer_id,
    c.customer_name,
    ( SELECT COUNT(*) FROM orders o WHERE o.customer_id = c.customer_id ) AS order_count
FROM 
    customers c
WHERE 
    ( SELECT COUNT(*) FROM orders o WHERE o.customer_id = c.customer_id ) >= 2;



-- 5. Aggregate functions (SUM, AVG): Total and Average Order Value per Customer
SELECT 
    cu.customer_name,
    SUM(p.amount) AS total_amount_paid,
    AVG(p.amount) AS average_payment
FROM 
    customers cu
JOIN 
    orders o ON cu.customer_id = o.customer_id
JOIN 
    payments p ON o.order_id = p.order_id
GROUP BY 
    cu.customer_name
ORDER BY 
    total_amount_paid DESC;


-- 6. Create an enhanced view for monthly sales analysis
CREATE OR REPLACE VIEW monthly_sales AS
SELECT 
    TO_CHAR(o.order_date, 'YYYY-MM') AS month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    SUM(oi.quantity) AS total_quantity_sold
FROM 
    orders o
JOIN 
    order_items oi ON o.order_id = oi.order_id
GROUP BY 
    TO_CHAR(o.order_date, 'YYYY-MM');

-- Use the view
SELECT * FROM monthly_sales;


-- 7. Optimize queries with indexes: Create index on frequently searched columns
CREATE INDEX idx_products_price ON products(price);
CREATE INDEX idx_orders_customer ON orders(customer_id);

SELECT 
    index_name, 
    table_name, 
    column_name
FROM 
    user_ind_columns
WHERE 
    table_name IN ('PRODUCTS', 'ORDERS');
