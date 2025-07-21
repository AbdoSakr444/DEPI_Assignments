-- 1)
DECLARE @Customer_Name VARCHAR(100)
DECLARE @Total_Amount DECIMAL(10,4)

SELECT @Customer_Name = C.first_name + ' ' + C.last_name, @Total_Amount = SUM(OI.quantity*OI.list_price)
FROM sales.customers C INNER JOIN sales.orders O
ON C.customer_id = O.customer_id INNER JOIN sales.order_items OI
ON O.order_id = OI.order_id
WHERE C.customer_id = 1
GROUP BY C.customer_id,C.first_name,C.last_name

IF(@Total_Amount>5000)
BEGIN
PRINT('VIP')
END
ELSE
BEGIN
PRINT('Regular')
END





-- 2)
DECLARE @Num_Of_Producst INT
DECLARE @ThreShold INT
SET @ThreShold = 1500


SELECT @Num_Of_Producst = COUNT(P.list_price)
FROM production.products P
WHERE P.list_price > @ThreShold

PRINT 'Num Of Products = ' + CAST(@Num_Of_Producst AS VARCHAR(50)) 
PRINT 'ThreShold = $' + CAST(@ThreShold AS VARCHAR(50))





-- 3)
DECLARE @Staff_ID INT
SET @Staff_ID = 1

DECLARE @Year INT
SET @Year = 2017


DECLARE @Total_Amount DECIMAL(10,4)

SELECT @Total_Amount = SUM(OI.quantity*OI.list_price)
FROM sales.orders O INNER JOIN sales.staffs S
ON O.staff_id = S.staff_id
INNER JOIN sales.order_items OI
ON O.order_id = OI.order_id
WHERE S.staff_id = @Staff_ID AND YEAR(O.order_date) = @Year
GROUP BY S.staff_id,S.first_name,S.last_name


PRINT 'Staff ID = ' + CAST(@Staff_ID AS VARCHAR(10)) 
PRINT 'Year = ' + CAST(@Year AS VARCHAR(10))
PRINT 'Total_Amount = ' + CAST(@Total_Amount AS VARCHAR(50))





-- 4)
SELECT @@SERVERNAME AS server_name, @@VERSION AS sql_version, @@ROWCOUNT AS Row_Count





-- 5)
DECLARE @Quantity INT

SELECT @Quantity = S.quantity
FROM production.stocks S
WHERE S.store_id = 1 AND S.product_id = 1


IF @Quantity > 20
BEGIN
PRINT ('Well Stocked')
END

ELSE IF (@Quantity >= 10 and @Quantity <= 20 )
BEGIN
PRINT ('Moderate Stock')
END

ELSE IF (@Quantity < 10)
BEGIN
PRINT ('Low Stock , Render Needed')
END





-- 7)
SELECT P.product_name,P.list_price,
CASE
	WHEN P.list_price < 300 THEN 'Budget'
	WHEN P.list_price BETWEEN 300 AND 800 THEN 'Mid-Range'
	WHEN P.list_price BETWEEN 801 AND 2000 THEN 'Premium'
	WHEN P.list_price > 2000 THEN 'Luxury'
END
FROM production.products P





-- 8)
IF EXISTS (SELECT * FROM sales.customers C WHERE C.customer_id = 5)
BEGIN
	SELECT C.customer_id,COUNT(*) AS 'Num of Orders'
	FROM sales.customers C INNER JOIN sales.orders O
	ON C.customer_id = O.customer_id
	WHERE C.customer_id = 5
	GROUP BY C.customer_id
END

ELSE
BEGIN
	PRINT ('Customer Not Founded')
END





-- 9)


CREATE FUNCTION CalculateShipping (@OrderPrice AS DECIMAL(10,4))
RETURNS DECIMAL (10,4)
AS
BEGIN
	DECLARE @Shipping_Price AS DECIMAL(10,4)
	IF(@OrderPrice > 100)
		BEGIN
		SET @Shipping_Price = 0
		END

	ELSE IF(@OrderPrice >= 50 AND @OrderPrice <= 99 )
		BEGIN
		SET @Shipping_Price = 5.99
		END


	ELSE IF(@OrderPrice < 50)
		BEGIN
		SET @Shipping_Price = 12.99
		END

	RETURN @Shipping_Price
END

SELECT dbo.CalculateShipping(700) AS 'Shipping_Price'





-- 10)
CREATE FUNCTION GetProductsByPriceRange (@MinPrice AS DECIMAL(10,4), @MaxPrice AS DECIMAL(10,4))
RETURNS TABLE
AS
RETURN
(
	SELECT P.product_id,P.product_name,P.list_price,P.model_year,B.brand_name,C.category_name
	FROM production.products P INNER JOIN production.brands B
	ON P.brand_id = B.brand_id 
	INNER JOIN production.categories C
	ON p.category_id = C.category_id
	WHERE P.list_price BETWEEN @MinPrice AND @MaxPrice
)

SELECT * FROM dbo.GetProductsByPriceRange(500,1000)





-- 11)
CREATE  FUNCTION GetCustomerYearlySummary (@CustomerID AS INT)
RETURNS @T TABLE 
(
 OrderYear INT,

 OrderCount INT,

 TotalAmount DECIMAL(10,2),

 AvgOrderValue DECIMAL(10,2)
)

AS

BEGIN

INSERT INTO @T
SELECT YEAR(O.order_date),COUNT(O.order_id),SUM(OI.list_price*OI.quantity),AVG(OI.list_price*OI.quantity)
FROM sales.customers C INNER JOIN sales.orders O
ON C.customer_id = O.customer_id 
INNER JOIN sales.order_items OI
ON O.order_id = OI.order_id
WHERE C.customer_id = @CustomerID
GROUP BY YEAR(O.order_date)

RETURN
END

SELECT * FROM dbo.GetCustomerYearlySummary (2)		





-- 12)
CREATE OR ALTER FUNCTION CalculateBulkDiscount (@Quantity AS INT)
RETURNS DECIMAL (10,4)
AS
BEGIN
   DECLARE @Discount AS DECIMAL (10,4)
   IF(@Quantity >= 1 AND @Quantity <= 2)
		BEGIN
		SET @Discount = 0
		END

	ELSE IF(@Quantity >= 3 AND @Quantity <= 5)
		BEGIN
		SET @Discount = 5
		END


	ELSE IF(@Quantity >= 6 AND @Quantity <= 9)
		BEGIN
		SET @Discount = 10
		END


	ELSE IF(@Quantity > 10)
		BEGIN
		SET @Discount = 15
		END

	RETURN @Discount
END


SELECT dbo.CalculateBulkDiscount(6) AS 'Discount Percentage'





-- 13)
CREATE PROCEDURE sp_GetCustomerOrderHistory 
	@customer_id INT,
    @start_date DATE = '1-1-1',
    @end_date DATE = '1-1-2050'
AS
BEGIN
	SELECT C.customer_id,COUNT(O.order_id) AS 'Total Orders'
	FROM sales.customers C INNER JOIN sales.orders O
	ON C.customer_id = O.customer_id
	WHERE (C.customer_id = @customer_id) AND (O.order_date BETWEEN @start_date AND @end_date)
	GROUP BY C.customer_id
END

EXEC sp_GetCustomerOrderHistory 1,'1-1-2022', '1-1-2023'





-- 14)
CREATE OR ALTER PROCEDURE sp_RestockProduct 
	@store_id INT,
    @product_id INT,
    @Restock_Quantity INT
AS
BEGIN

  SELECT S.quantity AS 'OLD Quantity',@Restock_Quantity+S.quantity AS 'New Quantity'
  FROM production.stocks S
  WHERE S.product_id = @product_id AND S.store_id = @store_id


  UPDATE production.stocks 
  SET quantity +=  @Restock_Quantity
  WHERE store_id = @store_id AND  product_id = @product_id
END

EXEC dbo.sp_RestockProduct 1,1,50

SELECT*
FROM production.stocks S





-- 16)
CREATE PROCEDURE sp_SearchProducts 
	@CategoryID INT,
	@MinPrice DECIMAL(10,4),
	@MaxPrice DECIMAL(10,4)

AS
BEGIN
   SELECT *
   FROM production.products P
   WHERE p.category_id = @CategoryID AND P.list_price BETWEEN @MinPrice AND @MaxPrice
END

EXEC dbo.sp_SearchProducts 1,300,2000





-- 18)
CREATE OR ALTER PROCEDURE sp_Restock 
AS
BEGIN
  UPDATE production.stocks
  SET quantity +=  5
  WHERE quantity <= 10
END





--19)
CREATE OR ALTER PROCEDURE LoyalCustomer 
@CustomerID AS INT
AS
BEGIN
   DECLARE @NumOfOrders AS INT

   SELECT @NumOfOrders = COUNT(O.order_id)
   FROM sales.customers C INNER JOIN sales.orders O
   ON C.customer_id = O.customer_id
   WHERE C.customer_id = @CustomerID
   GROUP BY C.customer_id
   

   IF (@NumOfOrders > 20)
   BEGIN
   	  PRINT ('Loyal')
   END
   ELSE
   BEGIN
		PRINT ('Not Yet')
   END
END

EXEC  dbo.LoyalCustomer 144