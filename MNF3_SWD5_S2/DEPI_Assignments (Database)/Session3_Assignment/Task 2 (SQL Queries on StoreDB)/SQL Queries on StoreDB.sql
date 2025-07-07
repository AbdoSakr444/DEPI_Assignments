-- 1-) List all products with list price greater than 1000
SELECT *
FROM production.products P
WHERE P.list_price > 1000;





-- 2-) Get customers from "CA" or "NY" states
SELECT *
FROM sales.customers C
WHERE C.state in ('CA','NY');





-- 3-) Retrieve all orders placed in 2023
SELECT *
FROM sales.orders O
WHERE YEAR(O.order_date) = '2023';





-- 4-) Show customers whose emails end with @gmail.com
SELECT *
FROM sales.customers C
WHERE C.email LIKE '%@gmail.com';





-- 5-) Show all inactive staff
SELECT *
FROM sales.staffs S
WHERE S.active <> 1;





-- 6-) List top 5 most expensive products
SELECT TOP(5) *
FROM production.products P
ORDER BY P.list_price DESC;





-- 7-) Show latest 10 orders sorted by date
SELECT TOP(10) *
FROM sales.orders O
ORDER BY O.order_date DESC;





-- 8-) Retrieve the first 3 customers alphabetically by last name
SELECT TOP(3) *
FROM sales.customers C
ORDER BY C.last_name;





-- 9-) Find customers who did not provide a phone number
SELECT *
FROM sales.customers C
WHERE C.phone IS NULL;





-- 10-) Show all staff who have a manager assigned
SELECT *
FROM sales.staffs S
WHERE S.manager_id IS NOT NULL;





-- 11-) Count number of products in each category
SELECT P.category_id,COUNT(*) AS 'Num of Products'
FROM production.products P
GROUP BY P.category_id;





-- 12-) Count number of customers in each state
SELECT C.state,COUNT(*) AS 'Num of Customers'
FROM sales.customers C
GROUP BY C.state;





-- 13-) Get average list price of products per brand
SELECT P.brand_id,AVG(P.list_price) AS 'Average Price'
FROM production.products P
GROUP BY P.brand_id;





-- 14-) Show number of orders per staff
SELECT O.staff_id,COUNT(*) AS 'Num of Orders'
FROM sales.orders O
GROUP BY O.staff_id;





-- 15-) Find customers who made more than 2 orders
SELECT O.customer_id , COUNT(*) AS 'Num of Orders'
FROM sales.orders O
GROUP BY O.customer_id
HAVING COUNT(*) > 2;





-- 16-) Products priced between 500 and 1500
SELECT *
FROM production.products P
WHERE P.list_price BETWEEN 500 AND 1500;





-- 17-) Customers in cities starting with "S"
SELECT *
FROM sales.customers C
WHERE C.city LIKE 'S%';





-- 18-) Orders with order_status either 2 or 4
SELECT *
FROM sales.orders O
WHERE O.order_status IN (2,4);





-- 19-) Products from category_id IN (1, 2, 3)
SELECT *
FROM production.products P
WHERE P.category_id IN (1,2,3);





-- 20-) Staff working in store_id = 1 OR without phone number
SELECT *
FROM sales.staffs S
WHERE S.store_id = 1 OR S.phone IS NULL;












