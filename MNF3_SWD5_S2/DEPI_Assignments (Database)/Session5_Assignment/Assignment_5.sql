-- 1.Write a query that classifies all products into price categories:
SELECT *,
CASE
	WHEN P.list_price < 300 THEN 'Economy'
	WHEN P.list_price >= 300 AND P.list_price <= 999 THEN 'Standard'
	WHEN P.list_price >= 1000 AND P.list_price <= 2499 THEN 'Premium' 
	WHEN P.list_price >= 2500 THEN 'Luxury' 
END AS 'Product Classification'
FROM production.products P;





-- 2.Create a query that shows order processing information with user-friendly status descriptions:
SELECT *,
CASE
	WHEN O.order_status = 1 THEN 'Order Received'
	WHEN O.order_status = 2 THEN 'In Prepration'
	WHEN O.order_status = 3 THEN 'Order Cancelled'
	WHEN O.order_status = 4 THEN 'Order Delivered'
END AS 'Status Descriptions',
CASE
	WHEN DATEDIFF(DAY,O.required_date,GETDATE()) > 5 AND O.order_status = 1  THEN 'URGENT'
	WHEN DATEDIFF(DAY,O.required_date,GETDATE()) > 3 AND O.order_status = 2 THEN 'HIGH'
	ELSE 'NORMAL'
END AS 'Priorety Level'
FROM sales.orders O;





-- 3.Write a query that categorizes staff based on the number of orders they've handled:
SELECT *,
CASE
	WHEN T1.[Number of Orders] = 0 THEN 'New Staff'
	WHEN T1.[Number of Orders] BETWEEN 1 AND 10 THEN 'junior Staff'
	WHEN T1.[Number of Orders] BETWEEN 11 AND 25 THEN 'Senior Staff'
	WHEN T1.[Number of Orders] > 26 THEN 'Expert Staff'
END AS 'Staff Experience'
FROM
(SELECT S.staff_id,s.first_name + ' ' + s.last_name AS 'Full Name' , COUNT(*) AS 'Number of Orders'
FROM sales.staffs S INNER JOIN sales.orders O
ON S.staff_id = O.staff_id
GROUP BY S.staff_id,S.first_name,S.last_name) T1;





-- 4.Create a query that handles missing customer contact information:
SELECT ISNULL(C.phone,'Phone Not Avalibale') AS 'Phone', COALESCE(C.phone,C.email,'No Contact Info') AS 'Conatct Info'
FROM sales.customers C;





-- 5.Write a query that safely calculates price per unit in stock:
SELECT S.*,  P.list_price , ISNULL(S.quantity,'0') AS 'Quantity'
FROM production.stocks S INNER JOIN production.products P
ON S.product_id = P.product_id
WHERE S.store_id = 1;





-- 6.Create a query that formats complete addresses safely:
SELECT COALESCE((ISNULL(C.street,'-') + ',' +ISNULL(C.city,'-') + ',' + ISNULL(C.state,'-')),C.phone,'No Conatct Method') AS 'Address' , ISNULL (C.zip_code,'No ZIP Code') AS 'Zip Code'
FROM sales.customers C;





-- 7.Use a CTE to find customers who have spent more than $1,500 total:

WITH OrderDetails AS 
(
SELECT I.order_id , COUNT(*) AS 'Num of Items' , SUM (I.list_price) AS 'Order Total Price'
FROM sales.orders O  INNER JOIN sales.order_items I
ON O.order_id = I.order_id 
GROUP BY I.order_id 
)


SELECT O.customer_id,C.first_name + ' ' + C.last_name AS 'Full Name',C.email , SUM(OD.[Order Total Price]) AS 'Total Price'
FROM OrderDetails OD INNER JOIN sales.orders O
ON OD.order_id = O.order_id INNER JOIN sales.customers C
ON O.customer_id = C.customer_id
GROUP BY O.customer_id,C.first_name,C.last_name,C.email
HAVING SUM(OD.[Order Total Price]) > 1500;





-- 8.Create a multi-CTE query for category analysis
WITH TotalRevenuePerCategory AS
(
SELECT C.category_id,C.category_name,SUM(P.list_price) AS 'List Price'
FROM production.categories C INNER JOIN production.products P
ON C.category_id = P.category_id
GROUP BY C.category_id,C.category_name
),

average_order_value_per_category AS
(
SELECT C.category_id,C.category_name,AVG(I.list_price) AS 'Avg Price'
FROM production.products P INNER JOIN  production.categories C
ON P.category_id = C.category_id INNER JOIN sales.order_items I 
ON P.product_id = I.product_id
GROUP BY C.category_id,C.category_name
)

SELECT T.category_id,T.category_name,T.[List Price],A.[Avg Price],
CASE
	WHEN T.[List Price] > 50000 THEN 'Excellent'
	WHEN T.[List Price] > 20000 THEN 'Good'
	ELSE 'Needs Improvements'
END AS 'Performance Rate'
FROM TotalRevenuePerCategory T INNER JOIN average_order_value_per_category A
ON T.category_id = A.category_id





-- 9.Use CTEs to analyze monthly sales trends:
WITH OrderDetails AS 
(
SELECT I.order_id , COUNT(*) AS 'Num of Items' , SUM (I.list_price) AS 'Order Total Price'
FROM sales.orders O  INNER JOIN sales.order_items I
ON O.order_id = I.order_id 
GROUP BY I.order_id 
)

SELECT MONTH(O.order_date) AS 'Order Month',SUM(OD.[Order Total Price]) AS 'Total Price'
FROM sales.orders O INNER JOIN OrderDetails OD
ON O.order_id = OD.order_id
GROUP  BY MONTH(O.order_date)





-- 10.Create a query that ranks products within each category:'

SELECT C.category_id,C.category_name,P.product_id,P.product_name,
RANK() OVER (
	PARTITION BY c.category_id
	ORDER BY p.list_price DESC
 ) AS price_rank
FROM 
production.categories C INNER JOIN production.products P 
ON C.category_id = P.category_id;


SELECT C.category_id,C.category_name,P.product_id,P.product_name,
DENSE_RANK() OVER (
	PARTITION BY c.category_id
	ORDER BY p.list_price DESC
 ) AS price_rank
FROM 
production.categories C INNER JOIN production.products P 
ON C.category_id = P.category_id;


WITH Ranking AS
(
SELECT c.category_id,p.product_id,p.product_name,p.list_price,
    ROW_NUMBER() OVER (
        PARTITION BY c.category_id 
        ORDER BY p.list_price DESC
    ) AS price_rank
FROM 
production.categories c INNER JOIN production.products p 
ON c.category_id = p.category_id
)


SELECT *
FROM Ranking R
WHERE R.price_rank <= 3





-- 11.Rank customers by their total spending:
WITH OrderDetails AS 
(
SELECT I.order_id , SUM (I.list_price) AS 'Order Total Price'
FROM sales.orders O  INNER JOIN sales.order_items I
ON O.order_id = I.order_id 
GROUP BY I.order_id 
),

Orders_Cust AS
(
SELECT O.customer_id,OD.*
FROM sales.orders O INNER JOIN OrderDetails OD
ON O.order_id = OD.order_id
)

SELECT *,RANK() OVER (ORDER BY OC.[Order Total Price] DESC) AS 'Rank'
FROM Orders_Cust OC  INNER JOIN sales.customers C
ON OC.customer_id = C.customer_id





-- 12.Create a comprehensive store performance ranking:
WITH StoreRevenue AS (
    SELECT 
        s.store_id,
        s.store_name,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM sales.stores s
    JOIN sales.orders o ON s.store_id = o.store_id
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    GROUP BY s.store_id, s.store_name
),
RankedStores AS (
    SELECT *,
        RANK() OVER (ORDER BY total_revenue DESC) AS revenue_rank,
        RANK() OVER (ORDER BY total_orders DESC) AS order_rank,
        PERCENT_RANK() OVER (ORDER BY total_revenue) AS revenue_percentile
    FROM StoreRevenue
)
SELECT * FROM RankedStores;





-- 13.Create a PIVOT table showing product counts by category and brand:
SELECT 
    category_name,
    ISNULL([Nike], 0) AS Nike,
    ISNULL([Adiddas], 0) AS Adiddas,
    ISNULL([Puma], 0) AS Puma,
    ISNULL([Zara], 0) AS Zara
FROM (
    SELECT 
        c.category_name,
        b.brand_name
    FROM production.products p
    JOIN production.categories c ON p.category_id = c.category_id
    JOIN production.brands b ON p.brand_id = b.brand_id
) AS SourceTable
PIVOT (
    COUNT(brand_name)
    FOR brand_name IN ([Nike], [Adiddas], [Puma], [Zara])
) AS PivotTable;
SELECT*
FROM production.brands






-- 15.PIVOT order statuses across stores:
SELECT 
    store_name,
    ISNULL([1], 0) AS Pending,
    ISNULL([2], 0) AS Processing,
    ISNULL([3], 0) AS Rejected,
    ISNULL([4], 0) AS Completed
FROM (
    SELECT 
        s.store_name,
        o.order_status
    FROM sales.orders o
    JOIN sales.stores s ON o.store_id = s.store_id
) AS SourceTable
PIVOT (
    COUNT(order_status)
    FOR order_status IN ([1], [2], [3], [4])
) AS PivotTable;





-- 16.Create a PIVOT comparing sales across years:
WITH YearlySales AS (
    SELECT 
        b.brand_name,
        YEAR(o.order_date) AS sales_year,
        SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS revenue
    FROM sales.orders o
    JOIN sales.order_items oi ON o.order_id = oi.order_id
    JOIN production.products p ON oi.product_id = p.product_id
    JOIN production.brands b ON p.brand_id = b.brand_id
    GROUP BY b.brand_name, YEAR(o.order_date)
),
PivotedSales AS (
    SELECT *
    FROM YearlySales
    PIVOT (
        SUM(revenue)
        FOR sales_year IN ([2016], [2017], [2018])
    ) AS PivotTable
)
SELECT *,
    ROUND(([2017] - [2016]) * 100.0 / NULLIF([2016], 0), 2) AS Growth_2016_2017_Percent,
    ROUND(([2018] - [2017]) * 100.0 / NULLIF([2017], 0), 2) AS Growth_2017_2018_Percent
FROM PivotedSales;







-- 17.Use UNION to combine different product availability statuses:
SELECT P.product_id,P.product_name,S.store_id,S.quantity
FROM production.products P INNER JOIN production.stocks S
ON P.product_id = S.product_id
WHERE S.quantity > 0

UNION

SELECT P.product_id,P.product_name,S.store_id,S.quantity
FROM production.products P INNER JOIN production.stocks S
ON P.product_id = S.product_id
WHERE S.quantity = 0 OR S.quantity IS NULL

UNION

SELECT P.product_id,P.product_name,S.store_id,S.quantity
FROM production.products P FULL JOIN production.stocks S
ON P.product_id = S.product_id
WHERE S.product_id IS NULL





-- 18.Use INTERSECT to find loyal customers:
SELECT C.customer_id,C.first_name,O.order_id,YEAR(O.order_date) AS 'Order Year'
FROM sales.customers C INNER JOIN sales.orders O
ON C.customer_id = O.order_id
WHERE YEAR(O.order_date) = 2017

INTERSECT

SELECT C.customer_id,C.first_name,O.order_id,YEAR(O.order_date) AS 'Order Year'
FROM sales.customers C INNER JOIN sales.orders O
ON C.customer_id = O.order_id
WHERE YEAR(O.order_date) = 2018





-- 19.Use multiple set operators to analyze product distribution:
SELECT P.*,S.store_id
FROM production.products P INNER JOIN production.stocks S
ON P.product_id = S.product_id
WHERE S.store_id = 1

INTERSECT

SELECT P.*,S.store_id
FROM production.products P INNER JOIN production.stocks S
ON P.product_id = S.product_id
WHERE S.store_id = 2

INTERSECT

SELECT P.*,S.store_id
FROM production.products P INNER JOIN production.stocks S
ON P.product_id = S.product_id
WHERE S.store_id = 3






-- 20.Complex set operations for customer retention:
SELECT C.*,O.order_id,O.order_date
FROM sales.customers C INNER JOIN sales.orders O
ON C.customer_id = O.order_id
WHERE YEAR(O.order_date) = 2016

UNION ALL

SELECT C.*,O.order_id,O.order_date
FROM sales.customers C INNER JOIN sales.orders O
ON C.customer_id = O.order_id
WHERE YEAR(O.order_date) = 2017

UNION ALL

SELECT C.*,O.order_id,O.order_date
FROM sales.customers C INNER JOIN sales.orders O
ON C.customer_id = O.order_id
WHERE YEAR(O.order_date) IN (2016,2017)