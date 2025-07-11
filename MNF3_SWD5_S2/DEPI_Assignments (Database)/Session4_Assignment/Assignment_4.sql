-- 1. Count the total number of products in the database.
SELECT COUNT (*) AS 'Total Num Of Products'
FROM production.products;





-- 2. Find the average, minimum, and maximum price of all products.
SELECT AVG(P.list_price) AS 'Average Price', MIN(P.list_price) AS 'MIN Price', MAX(P.list_price) AS 'MAX Price'
FROM production.products P;





-- 3. Count how many products are in each category.
SELECT C.category_name, COUNT(P.product_id) AS 'Num Of Products'
FROM production.products P INNER JOIN production.categories C
ON P.category_id = C.category_id
GROUP BY C.category_name;





-- 4. Find the total number of orders for each store.
SELECT S.store_name , COUNT (O.order_id) AS 'Num Of Orders'
FROM sales.orders O INNER JOIN sales.stores S
ON O.store_id = S.store_id
GROUP BY S.store_name;





-- 5. Show customer first names in UPPERCASE and last names in lowercase for the first 10 customers.
SELECT TOP (10) UPPER (C.first_name) , LOWER (C.last_name)
FROM sales.customers C;





-- 6. Get the length of each product name. Show product name and its length for the first 10 products.
SELECT TOP (10) P.product_name , LEN(P.product_name) AS 'Length Of Name'
FROM production.products P;





-- 7. Format customer phone numbers to show only the area code (first 3 digits) for customers 1-15.
SELECT LEFT(C.phone,3) AS 'Area Code'
FROM sales.customers C;





-- 8. Show the current date and extract the year and month from order dates for orders 1-10.
SELECT TOP (10) GETDATE() AS 'Current Date',YEAR(O.order_date) AS 'Year of Order date', MONTH(O.order_date) AS 'Month of Order date'
FROM sales.orders O;





-- 9. Join products with their categories. Show product name and category name for first 10 products.
SELECT TOP (10) P.product_name,C.category_name
FROM production.products P INNER JOIN production.categories C
ON P.category_id = C.category_id;





-- 10. Join customers with their orders. Show customer name and order date for first 10 orders.
SELECT TOP (10) C.first_name + ' ' + C.last_name  AS 'Full Name',O.order_date 
FROM sales.orders O INNER JOIN sales.customers C
ON O.customer_id = C.customer_id;





-- 11. Show all products with their brand names, even if some products don't have brands. Include product name, brand name (show 'No Brand' if null).
SELECT P.product_name , ISNULL(B.brand_name,'NO Brand') AS 'Brand Name'
FROM production.products P LEFT JOIN production.brands B
ON P.brand_id = B.brand_id;





-- 12. Find products that cost more than the average product price. Show product name and price.
SELECT *
FROM production.products P
WHERE P.list_price > (SELECT AVG(P.list_price) FROM production.products P);





-- 13. Find customers who have placed at least one order. Use a subquery with IN. Show customer_id and customer_name.
SELECT C.first_name + ' ' + C.last_name AS 'Full Name'  , O.customer_id
FROM sales.customers C INNER JOIN sales.orders O
ON C.customer_id = O.customer_id
WHERE O.customer_id IN (SELECT O.customer_id
FROM sales.customers C INNER JOIN sales.orders O
ON C.customer_id = O.customer_id
GROUP BY O.customer_id
HAVING COUNT(*) > 1);





-- 14. For each customer, show their name and total number of orders using a subquery in the SELECT clause.
SELECT C.first_name + ' ' + C.last_name AS 'Full Name', (SELECT COUNT (*) FROM sales.orders O WHERE O.customer_id = C.customer_id) AS 'Num of Orders'
FROM sales.customers C;





-- 15. Create a simple view called easy_product_list that shows product name, category name, and price. Then write a query to select all products from this view where price > 100.
CREATE VIEW easy_product_list AS 
SELECT P.product_name,C.category_name,P.list_price
FROM production.products P INNER JOIN production.categories C
ON P.category_id = C.category_id;

-- query
SELECT *
FROM easy_product_list E
WHERE E.list_price > 100;





-- 16. Create a view called customer_info that shows customer ID, full name (first + last), email, and city and state combined. Then use this view to find all customers from California (CA).
CREATE VIEW customer_info AS
SELECT C.customer_id , C.first_name + ' ' + C.last_name AS 'Full Name' , C.email , C.city + ',' + C.state AS 'Location'
FROM sales.customers C;

-- query
SELECT *
FROM customer_info C
WHERE C.Location LIKE '%CA';





-- 17. Find all products that cost between $50 and $200. Show product name and price, ordered by price from lowest to highest.
SELECT P.product_name, P.list_price
FROM production.products P
WHERE P.list_price BETWEEN 50 AND 200
ORDER BY P.list_price DESC;





-- 18. Count how many customers live in each state. Show state and customer count, ordered by count from highest to lowest.
SELECT C.state, COUNT(*) AS 'Count of Customers'
FROM sales.customers C
GROUP BY C.state
ORDER BY COUNT(*) DESC;





-- 19. Find the most expensive product in each category. Show category name, product name, and price.
SELECT T1.category_name,(SELECT TOP(1) P.product_name FROM production.products P WHERE P.list_price = T1.[Max Product Price]) AS 'Expensive Producrt Name',T1.[Max Product Price]
FROM 
(SELECT C.category_name, MAX(P.list_price) AS 'Max Product Price'
FROM production.products P INNER JOIN production.categories C
ON P.category_id = C.category_id
GROUP BY C.category_name) T1





-- 20. Show all stores and their cities, including the total number of orders from each store. Show store name, city, and order count.
SELECT S.store_name, S.city, COUNT(*) AS 'Order Count'
FROM sales.stores S INNER JOIN sales.orders O
ON S.store_id = O.store_id
GROUP BY S.store_name,S.city;