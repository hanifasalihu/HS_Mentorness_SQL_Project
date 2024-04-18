---CREATE 5 TABLES---

CREATE TABLE customers (
    cust_id INT PRIMARY KEY,
    first_name VARCHAR,
    last_name VARCHAR,
    email VARCHAR,
    phone BIGINT,
    primary_pincode INT,
    gender VARCHAR,
    dob DATE,
    joining_date DATE)

SELECT * FROM customers


CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR,
	brand VARCHAR,
    category VARCHAR,
    procurement_cost_per_unit INT,
	mrp INT)

SELECT * FROM products


CREATE TABLE pincode (
    pincode INT PRIMARY KEY,
    city VARCHAR,
    state VARCHAR)

SELECT * FROM pincode


CREATE TABLE delivery_person (
    delivery_person_id INT PRIMARY KEY,
    name VARCHAR,
    joining_date DATE,
    pincode INT,
	FOREIGN KEY (pincode) REFERENCES pincode(pincode))

SELECT * FROM delivery_person


CREATE TABLE orders (
    order_id BIGINT,
    order_type VARCHAR,
    cust_id INT,
    order_date DATE,
    delivery_date DATE,
    tot_units INT,
    displayed_selling_price_per_unit INT,
    total_amount_paid INT,
    product_id INT,
    delivery_person_id INT,
    payment_type VARCHAR,
    delivery_pincode INT,
    FOREIGN KEY (cust_id) REFERENCES customers(cust_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (delivery_person_id) REFERENCES delivery_person(delivery_person_id),
	FOREIGN KEY (delivery_pincode) REFERENCES pincode(pincode))

SELECT * FROM orders


------------------------------EXPLORATORY DATA ANALYSIS-------------------------------

----- 1. How many customers do not have DOB information available?

SELECT COUNT(*) 
FROM customers
WHERE dob IS NULL


----- 2. How many customers are there in each pincode and gender combination?

SELECT primary_pincode, gender, 
COUNT(*) AS customer_count
FROM customers
GROUP BY primary_pincode, gender


----- 3. Print product name and mrp for products which have more than 50000 MRP?

SELECT product_name, mrp
FROM products
WHERE mrp > 50000


----- 4. How many delivery personal are there in each pincode?

SELECT pincode, 
COUNT(*) AS total_delivery_personnels
FROM delivery_person
GROUP BY pincode


----- 5. For each Pin code, print the count of orders, sum of total amount paid, average amount paid,
-- maximum amount paid, minimum amount paid for the transactions which were paid by 'cash'. Take only 'buy' order types

SELECT delivery_pincode,
    COUNT(*) AS order_count,
    SUM(total_amount_paid) AS total_amount_paid,
    AVG(total_amount_paid) AS avg_amount_paid,
    MAX(total_amount_paid) AS max_amount_paid,
    MIN(total_amount_paid) AS min_amount_paid
FROM orders
WHERE order_type = 'buy'
    AND payment_type = 'cash'
GROUP BY delivery_pincode


----- 6. For each delivery_person_id, print the count of orders and total amount paid for product_id = 12350 or 12348 and total units > 8. 
-- Sort the output by total amount paid in descending order. Take only 'buy' order types

SELECT delivery_person_id,
    COUNT(*) AS order_count,
    SUM(total_amount_paid) AS total_amount_paid
FROM orders
WHERE order_type = 'buy'
    AND (product_id = 12350 OR product_id = 12348)
    AND tot_units > 8
GROUP BY delivery_person_id
ORDER BY total_amount_paid DESC


----- 7. Print the Full names (first name plus last name) for customers that have email on "gmail.com"?

SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM customers
WHERE email LIKE '%@gmail.com'


----- 8. Which pincode has average amount paid more than 150,000? Take only 'buy' order types

SELECT delivery_pincode, 
AVG(total_amount_paid) AS average_amount_paid
FROM orders
WHERE order_type = 'buy'
GROUP BY delivery_pincode
HAVING AVG(total_amount_paid) > 150000


----- 9. Create following columns from order_date data - Order_date, - Order day, - Order month, - Order year

SELECT order_date,
    TO_CHAR(order_date, 'Day') AS order_day,
    TO_CHAR(order_date, 'Month') AS order_month,
    TO_CHAR(order_date, 'YYYY') AS order_year
FROM orders


----- 10. How many total orders were there in each month and how many of them were returned? Add a column for return rate too.
return rate = (100.0 * total return orders) / total buy orders.Hint: You will need to combine SUM() with CASE WHEN

SELECT
  EXTRACT(MONTH FROM order_date) AS month,
  COUNT(*) AS total_orders,
  SUM(CASE WHEN order_type = 'buy' THEN 1 ELSE 0 END) AS total_buy_orders,
  SUM(CASE WHEN order_type = 'buy' AND payment_type = 'cash' THEN 1 ELSE 0 END) AS total_return_orders,
  (100.0 * SUM(CASE WHEN order_type = 'buy' AND payment_type = 'cash' THEN 1 ELSE 0 END)) / SUM(CASE WHEN order_type = 'buy' THEN 1 ELSE 0 END) AS return_rate
FROM orders
GROUP BY month
ORDER BY month


----- 11. How many units have been sold by each brand? Also get total returned units for each brand.

SELECT
    p.brand,
    SUM(CASE WHEN o.order_type = 'buy' THEN o.tot_units ELSE 0 END) AS total_units_sold,
    SUM(CASE WHEN o.order_type = 'return' THEN o.tot_units ELSE 0 END) AS total_units_returned
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.brand


----- 12. How many distinct customers and delivery boys are there in each state?

SELECT p.state,
       COUNT(DISTINCT c.cust_id) AS num_customers,
       COUNT(DISTINCT d.delivery_person_id) AS num_delivery_persons
FROM pincode p
LEFT JOIN customers c ON p.pincode = c.primary_pincode
LEFT JOIN delivery_person d ON p.pincode = d.pincode
GROUP BY p.state
 
----- 13. For every customer, print how many total units were ordered, 
how many units were ordered from their primary_pincode and how many were ordered not from the
primary_pincode. Also calulate the percentage of total units which were ordered from
primary_pincode(remember to multiply the numerator by 100.0). Sort by the percentage column in descending order.

SELECT
    c.cust_id,
    SUM(o.tot_units) AS total_units_ordered,
    SUM(CASE WHEN o.delivery_pincode = c.primary_pincode THEN o.tot_units ELSE 0 END) AS units_ordered_primary_pincode,
    SUM(CASE WHEN o.delivery_pincode <> c.primary_pincode THEN o.tot_units ELSE 0 END) AS units_ordered_not_primary_pincode,
    (100.0 * SUM(CASE WHEN o.delivery_pincode = c.primary_pincode THEN o.tot_units ELSE 0 END)) / 
	SUM(o.tot_units) AS percentage_ordered_primary_pincode
FROM customers c
JOIN  orders o ON c.cust_id = o.cust_id
GROUP BY c.cust_id
ORDER BY percentage_ordered_primary_pincode DESC


----- 14. For each product name, print the sum of number of units, total amount paid, total displayed selling price, total mrp of these units, 
and finally the net discount from selling price.(i.e. 100.0 - 100.0 * total amount paid / total displayed selling price) &
the net discount from mrp (i.e. 100.0 - 100.0 * total amount paid / total mrp)

SELECT p.product_name,
    SUM(o.tot_units) AS total_units,
    SUM(o.total_amount_paid) AS total_amount_paid,
    SUM(o.displayed_selling_price_per_unit * o.tot_units) AS total_displayed_selling_price,
    SUM(p.mrp * o.tot_units) AS total_mrp,
    (100.0 - 100.0 * SUM(o.total_amount_paid) / SUM(o.displayed_selling_price_per_unit * o.tot_units)) AS net_discount_selling_price,
    (100.0 - 100.0 * SUM(o.total_amount_paid) / SUM(p.mrp * o.tot_units)) AS net_discount_mrp
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name


----- 15. For every order_id (exclude returns), get the product name and calculate the discount percentage from selling price. 
Sort by highest discount and print only those rows where discount percentage was above 10.10%.

WITH order_details AS (
  SELECT
    o.order_id,
    p.product_name,
    o.total_amount_paid,
    o.displayed_selling_price_per_unit * o.tot_units AS total_selling_price,
    ROUND(100.0 - (100.0 * o.total_amount_paid / (o.displayed_selling_price_per_unit * o.tot_units)), 2) AS discount_percentage
  FROM orders o
  JOIN products p ON o.product_id = p.product_id
  WHERE o.order_type <> 'return')
SELECT order_id, product_name, discount_percentage
FROM order_details
WHERE discount_percentage > 10.10
ORDER BY discount_percentage DESC


----- 16. Using the per unit procurement cost in product_dim, find which product category has made the most profit in both absolute amount and percentage. 
-- Absolute Profit = Total Amt Sold - Total Procurement 
-- Cost Percentage Profit = 100.0 * Total Amt Sold / Total Procurement Cost - 100.0

SELECT
    pd.category,
    SUM((o.displayed_selling_price_per_unit - pd.procurement_cost_per_unit) * o.tot_units) AS absolute_profit,
    (100.0 * SUM(o.displayed_selling_price_per_unit * o.tot_units)) / SUM(pd.procurement_cost_per_unit * o.tot_units) - 100.0 AS percentage_profit
FROM orders o
JOIN products pd ON o.product_id = pd.product_id
GROUP BY pd.category
ORDER BY absolute_profit DESC


----- 17. For every delivery person(use their name), print the total number of order ids (exclude returns) by month in separate columns 
-- i.e. there should be one row for each delivery_person_id and 12 columns for every month in the year

SELECT dp.name AS delivery_person_name,
  SUM(CASE WHEN EXTRACT(MONTH FROM o.order_date) = 1 THEN 1 ELSE 0 END) AS jan,
  SUM(CASE WHEN EXTRACT(MONTH FROM o.order_date) = 2 THEN 1 ELSE 0 END) AS feb,
  SUM(CASE WHEN EXTRACT(MONTH FROM o.order_date) = 3 THEN 1 ELSE 0 END) AS mar,
  SUM(CASE WHEN EXTRACT(MONTH FROM o.order_date) = 4 THEN 1 ELSE 0 END) AS apr,
  SUM(CASE WHEN EXTRACT(MONTH FROM o.order_date) = 5 THEN 1 ELSE 0 END) AS may,
  SUM(CASE WHEN EXTRACT(MONTH FROM o.order_date) = 6 THEN 1 ELSE 0 END) AS jun,
  SUM(CASE WHEN EXTRACT(MONTH FROM o.order_date) = 7 THEN 1 ELSE 0 END) AS jul,
  SUM(CASE WHEN EXTRACT(MONTH FROM o.order_date) = 8 THEN 1 ELSE 0 END) AS aug,
  SUM(CASE WHEN EXTRACT(MONTH FROM o.order_date) = 9 THEN 1 ELSE 0 END) AS sep,
  SUM(CASE WHEN EXTRACT(MONTH FROM o.order_date) = 10 THEN 1 ELSE 0 END) AS oct,
  SUM(CASE WHEN EXTRACT(MONTH FROM o.order_date) = 11 THEN 1 ELSE 0 END) AS nov,
  SUM(CASE WHEN EXTRACT(MONTH FROM o.order_date) = 12 THEN 1 ELSE 0 END) AS dec
FROM orders o
JOIN delivery_person dp ON o.delivery_person_id = dp.delivery_person_id
WHERE o.order_type <> 'return'
GROUP BY dp.name


----- 18. For each gender - male and female - find the absolute and percentage profit (like in Q15) by product name

WITH gender_profit AS (
	  SELECT
		c.gender,
		p.product_name,
		SUM(o.total_amount_paid) AS total_amt_sold,
		SUM(p.procurement_cost_per_unit * o.tot_units) AS total_procurement_cost,
		SUM(o.total_amount_paid) - SUM(p.procurement_cost_per_unit * o.tot_units) AS absolute_profit,
		ROUND(100.0 * SUM(o.total_amount_paid) / SUM(p.procurement_cost_per_unit * o.tot_units) - 100.0, 2) AS percentage_profit
FROM orders o
JOIN customers c ON o.cust_id = c.cust_id
JOIN products p ON o.product_id = p.product_id
WHERE o.order_type <> 'return'
GROUP BY c.gender, p.product_name)
SELECT gender, product_name,
  MAX(absolute_profit) AS max_absolute_profit,
  MAX(percentage_profit) AS max_percentage_profit
FROM gender_profit
GROUP BY gender, product_name


----- 19. Generally the more numbers of units you buy, the more discount seller will give you.
-- For 'Dell AX420' is there a relationship between number of units ordered and average discount from selling price?
-- Take only 'buy' order types


SELECT o.tot_units AS number_of_units_ordered,
   AVG(o.displayed_selling_price_per_unit - pd.procurement_cost_per_unit) AS average_discount
FROM orders o
JOIN products pd ON o.product_id = pd.product_id
WHERE pd.product_name = 'Dell AX420'
AND o.order_type = 'buy'
GROUP BY o.tot_units
ORDER BY o.tot_units
	
SELECT * FROM customers
SELECT * FROM products
SELECT * FROM pincode
SELECT * FROM delivery_person
SELECT * FROM orders













































