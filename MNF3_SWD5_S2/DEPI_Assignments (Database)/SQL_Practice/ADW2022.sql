-- 1.1 List all employees hired after January 1, 2012, showing their ID, first name, last name, and hire date, ordered by hire date descending.
SELECT E.BusinessEntityID,P.FirstName,P.LastName,E.HireDate
FROM HumanResources.Employee E INNER JOIN Person.Person P
ON E.BusinessEntityID = P.BusinessEntityID
WHERE E.HireDate > ('2012-01-1')
ORDER BY E.HireDate DESC





-- List products with a list price between $100 and $500, showing product ID, name, list price, and product number, ordered by list price ascending.
SELECT P.ProductID,P.Name,P.ListPrice,P.ProductNumber
FROM Production.Product P
WHERE P.ListPrice BETWEEN 100 AND 500
ORDER BY P.ListPrice ASC




-- List customers from the cities 'Seattle' or 'Portland', showing customer ID, first name, last name, and city, using appropriate joins.
SELECT C.CustomerID,P.FirstName,P.LastName,A.City
FROM Sales.Customer C INNER JOIN Person.Person P
ON C.PersonID = P.BusinessEntityID
INNER JOIN Person.BusinessEntityAddress BEA
ON P.BusinessEntityID = BEA.BusinessEntityID
INNER JOIN Person.Address A
ON A.AddressID = BEA.AddressID
WHERE A.City = 'Seattle' OR A.City = 'Portland'




-- List the top 15 most expensive products currently being sold, showing name, list price, product number, and category name, excluding discontinued products.
SELECT TOP 15 p.Name AS ProductName, p.ProductNumber, p.ListPrice, pc.Name AS CategoryName
FROM Production.Product p JOIN Production.ProductSubcategory psc
ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc
ON psc.ProductCategoryID = pc.ProductCategoryID
WHERE p.DiscontinuedDate IS NULL AND p.ListPrice IS NOT NULL
ORDER BY p.ListPrice DESC





-- 2.1 List products whose name contains 'Mountain' and color is 'Black', showing product ID, name, color, and list price.
SELECT P.ProductID,P.Name,P.Color,P.ListPrice
FROM Production.Product p
WHERE P.Name LIKE '%Mountain%' AND P.Color = 'Black'


--2.2 List employees born between January 1, 1970, and December 31, 1985, showing full name, birth date, and age in years.
 SELECT CONCAT (P.FirstName , ' ' , P.LastName ) FullName,E.BirthDate,
    DATEDIFF(YEAR, e.BirthDate, GETDATE())  AgeYear
FROM HumanResources.Employee E
JOIN Person.Person P ON E.BusinessEntityID = P.BusinessEntityID
WHERE E.BirthDate BETWEEN '1970-01-01' AND '1985-12-31'

--2.3 List orders placed in the fourth quarter of 2013, showing order ID, order date, customer ID, and total due.
SELECT O.SalesOrderID,O.OrderDate,O.CustomerID,O.TotalDue
FROM Sales.SalesOrderHeader O
WHERE O.OrderDate BETWEEN '2013-10-01' AND '2013-12-31'

--2.4 List products with a null weight but a non-null size, showing product ID, name, weight, size, and product number.
SELECT P.ProductID,P.Name,P.Weight,P.Size,P.ProductNumber
FROM Production.Product P
WHERE P.Weight IS NULL AND P.Size  IS NOT NULL

--3.1 Count the number of products by category, ordered by count descending.
SELECT PC.Name ,COUNT(P.ProductID) ProductCount
FROM Production.Product P JOIN Production.ProductSubcategory C
 ON P.ProductSubcategoryID=C.ProductSubcategoryID
 JOIN Production.ProductCategory PC ON C.ProductCategoryID=PC.ProductCategoryID
 GROUP BY PC.Name
ORDER BY COUNT(P.ProductID) DESC

--3.2 Show the average list price by product subcategory, including only subcategories with more than five products.
SELECT S.Name , AVG(p.ListPrice)  AvG_Price
FROM Production.Product P JOIN Production.ProductSubcategory S
ON P.ProductSubcategoryID = S.ProductSubcategoryID
GROUP BY S.Name
HAVING COUNT(P.ProductID) > 5

--3.3 List the top 10 customers by total order count, including customer name.
SELECT TOP 10 CONCAT (P.FirstName , ' ' , P.LastName ) FullName,COUNT(O.SalesOrderID) Totel_Order
FROM Sales.SalesOrderHeader O
JOIN Sales.Customer C ON O.CustomerID = C.CustomerID
JOIN Person.Person P ON C.PersonID = P.BusinessEntityID
GROUP BY CONCAT (P.FirstName , ' ' , P.LastName )

--3.4 Show monthly sales totals for 2013, displaying the month name and total amount.
SELECT DATENAME(MONTH, S.OrderDate)  Month_Name , SUM(S.TotalDue)  Total_Sales
FROM Sales.SalesOrderHeader S
WHERE YEAR(S.OrderDate) = 2013
GROUP BY DATENAME(MONTH, S.OrderDate)

--4.1 Find all products launched in the same year as 'Mountain-100 Black, 42'. Show product ID, name, sell start date, and year.
SELECT P.ProductID,P.Name,P.SellStartDate,YEAR(SellStartDate)
FROM Production.Product P
WHERE YEAR(SellStartDate) = (
    SELECT YEAR(P.SellStartDate)
    FROM Production.Product P
    WHERE P.Name = 'Mountain-100 Black, 42' )

--4.2 Find employees who were hired on the same date as someone else. Show employee names, shared hire date, and the count of employees hired that day.
SELECT CONCAT (P.FirstName , ' ' , P.LastName ) FullName ,E.HireDate,
  COUNT(*) OVER (PARTITION BY E.HireDate)  Hire_Count
FROM HumanResources.Employee E JOIN Person.Person P
ON E.BusinessEntityID = P.BusinessEntityID
WHERE E.HireDate IN (
    SELECT E.HireDate
    FROM HumanResources.Employee E
    GROUP BY E.HireDate
    HAVING COUNT(*) > 1 )

--5.1 Create a table named Sales.ProductReviews with columns for review ID, product ID, customer ID, rating, review date, review text, verified purchase flag, and helpful votes. Include appropriate primary key, foreign keys, check constraints, defaults, and a unique constraint on product ID and customer ID.
CREATE TABLE Sales.ProductReviews (
    reviewID INT IDENTITY(1,1) PRIMARY KEY,
    productID INT NOT NULL,
    customerID INT NOT NULL,
    rating INT  CHECK (rating BETWEEN 1 AND 10),
    reviewDate DATE DEFAULT GETDATE(),
    reviewText VARCHAR(100),
    verifiedPurchase BIT ,
    helpfulVotes INT DEFAULT 0 ,
    UNIQUE (productID, customerID),
    FOREIGN KEY (productID) REFERENCES Production.Product(ProductID),
    FOREIGN KEY (customerID) REFERENCES Sales.Customer(CustomerID)
)

--6.1 Add a column named LastModifiedDate to the Production.Product table, with a default value of the current date and time.
ALTER TABLE Production.Product
ADD LastModifiedDate DATETIME DEFAULT GETDATE()

--6.2 Create a non-clustered index on the LastName column of the Person.Person table, including FirstName and MiddleName.
CREATE NONCLUSTERED INDEX Person_LastName
ON Person.Person (LastName)
INCLUDE (FirstName, MiddleName)


--6.3 Add a check constraint to the Production.Product table to ensure that ListPrice is greater than StandardCost.
ALTER TABLE Production.Product 
ADD CONSTRAINT CHECK_COST CHECK (ListPrice > StandardCost)

--7.1 Insert three sample records into Sales.ProductReviews using existing product and customer IDs, with varied ratings and meaningful review text.
INSERT INTO Sales.ProductReviews (ProductID, CustomerID, Rating, ReviewDate, ReviewText, VerifiedPurchase, HelpfulVotes)
VALUES
(1, 11000, 8, GETDATE(), 'Excellent quality and performance', 1, 8),
(879, 11001, 4, GETDATE(), 'Average product', 1, 4),
(712, 11002, 1, GETDATE(), 'Not worth the price.', 0, 1)

--7.2 Insert a new product category named 'Electronics' and a corresponding product subcategory named 'Smartphones' under Electronics.
INSERT INTO Production.ProductCategory (Name)
VALUES ('Electronics')
  --a corresponding product subcategory named 'Smartphones' under Electronics.
INSERT INTO Production.ProductSubcategory (ProductCategoryID, Name)
VALUES (5, 'Smartphones')

--7.3 Copy all discontinued products (where SellEndDate is not null) into a new table named Sales.DiscontinuedProducts.
SELECT * INTO Sales.DiscontinuedProducts
FROM Production.Product P
WHERE P.SellEndDate IS NOT NULL

--8.1 Update the ModifiedDate to the current date for all products where ListPrice is greater than $1000 and SellEndDate is null.
UPDATE Production.Product 
SET ModifiedDate = GETDATE()
WHERE ListPrice > 1000 AND SellEndDate IS NULL


--8.2 Increase the ListPrice by 15% for all products in the 'Bikes' category and update the ModifiedDate.
UPDATE Production.Product
SET ListPrice = ListPrice * 1.15,ModifiedDate = GETDATE()
FROM Production.Product P JOIN Production.ProductSubcategory PS ON P.ProductSubcategoryID = PS.ProductSubcategoryID
JOIN Production.ProductCategory PC ON PS.ProductCategoryID = PC.ProductCategoryID
WHERE PC.Name = 'Bikes'

--8.3 Update the JobTitle to 'Senior' plus the existing job title for employees hired before January 1, 2010.
UPDATE HumanResources.Employee
SET JobTitle = 'Senior ' + JobTitle
WHERE HireDate < ('2010-01-01')

--9.1 Delete all product reviews with a rating of 1 and helpful votes equal to 0.
DELETE FROM Sales.ProductReviews
WHERE rating = 1 AND helpfulVotes = 0

--9.2 Delete products that have never been ordered, using a NOT EXISTS condition with Sales.SalesOrderDetail
DELETE FROM Production.Product
WHERE ProductID NOT IN (
    SELECT S.ProductID FROM Sales.SalesOrderDetail S )

--9.3 Delete all purchase orders from vendors that are no longer active.
DELETE FROM Purchasing.PurchaseOrderHeader
WHERE VendorID IN (
    SELECT V.BusinessEntityID
    FROM Purchasing.Vendor V
    WHERE V.ActiveFlag = 0
)

--10.1 Calculate the total sales amount by year from 2011 to 2014, showing year, total sales, average order value, and order count.
SELECT YEAR(S.OrderDate) Year,SUM(S.TotalDue) TotalSales,AVG(S.TotalDue) AverageOrderValue,COUNT(*) OrderCount
FROM Sales.SalesOrderHeader S
WHERE YEAR(S.OrderDate) BETWEEN 2011 AND 2014
GROUP BY YEAR(S.OrderDate)

--10.2 For each customer, show customer ID, total orders, total amount, average order value, first order date, and last order date.
SELECT S.CustomerID,COUNT(*) TotalOrders,SUM(S.TotalDue) TotalAmount, AVG(S.TotalDue) AverageOrder,
    MIN(S.OrderDate) FirstOrder,MAX(S.OrderDate) LastOrder
FROM Sales.SalesOrderHeader S
GROUP BY S.CustomerID

--10.3 List the top 20 products by total sales amount, including product name, category, total quantity sold, and total revenue.
SELECT TOP 20 P.Name Product, PC.Name category , SUM(SD.OrderQty) TotalQuantity,SUM(SD.LineTotal) TotalRevenue
FROM Sales.SalesOrderDetail SD JOIN Production.Product P ON SD.ProductID = P.ProductID
JOIN Production.ProductSubcategory PS ON P.ProductSubcategoryID = PS.ProductSubcategoryID
JOIN Production.ProductCategory PC ON PS.ProductCategoryID = PC.ProductCategoryID
GROUP BY P.Name, PC.Name

--10.4 Show sales amount by month for 2013, displaying the month name, sales amount, and percentage of the yearly total.
SELECT DATENAME(MONTH, SH.OrderDate) MonthName,SUM(SH.TotalDue)SalesAmount
FROM Sales.SalesOrderHeader SH
WHERE YEAR(SH.OrderDate) = 2013
GROUP BY DATENAME(MONTH, SH.OrderDate)

--11.1 Show employees with their full name, age in years, years of service, hire date formatted as 'Mon DD, YYYY', and birth month name.
SELECT CONCAT (P.FirstName , ' ' , P.LastName ) FullName,
    DATEDIFF(YEAR, E.BirthDate, GETDATE()) Age,
    DATEDIFF(YEAR, E.HireDate, GETDATE())  Years_Service,
    FORMAT(E.HireDate, 'MMM dd, yyyy') HireDate,
    DATENAME(MONTH, E.BirthDate) BirthMonth
FROM HumanResources.Employee E JOIN Person.Person P 
ON E.BusinessEntityID = P.BusinessEntityID

--11.2 Format customer names as 'LAST, First M.' (with middle initial), extract the email domain, and apply proper case formatting.
SELECT UPPER(P.LastName) + ', ' + P.FirstName + ' ' + LEFT(P.MiddleName, 1) + '.' Name,
   RIGHT(e.EmailAddress, LEN(e.EmailAddress) - CHARINDEX('@', e.EmailAddress))  Email
FROM Person.Person P JOIN Person.EmailAddress E
ON P.BusinessEntityID = E.BusinessEntityID
WHERE P.MiddleName IS NOT NULL

--11.3 For each product, show name, weight rounded to one decimal, weight in pounds (converted from grams), and price per pound.
SELECT P.Name,ROUND(P.Weight, 1)  Weight
FROM Production.Product P 
WHERE P.Weight IS NOT NULL

--12.1 List product name, category, subcategory, and vendor name for products that have been purchased from vendors.
SELECT P.Name  ProductName,PC.Name  Category,PS.Name  SubCategory,V.Name  Vendor
FROM Production.Product P JOIN Production.ProductSubcategory PS ON P.ProductSubcategoryID = PS.ProductSubcategoryID
JOIN Production.ProductCategory PC ON PS.ProductCategoryID = PC.ProductCategoryID
JOIN Purchasing.ProductVendor PV ON P.ProductID = PV.ProductID
JOIN Purchasing.Vendor V ON PV.BusinessEntityID = V.BusinessEntityID

--12.2 Show order details including order ID, customer name, salesperson name, territory name, product name, quantity, and line total.
SELECT SO.SalesOrderID, CONCAT (PP.FirstName , ' ' , PP.LastName ) FullName,
    ST.Name  TerritoryName, P.Name  ProductName,
    SOD.OrderQty,SOD.LineTotal
FROM Sales.SalesOrderHeader SO JOIN Sales.Customer C ON SO.CustomerID = C.CustomerID 
JOIN Person.Person PP ON c.PersonID = PP.BusinessEntityID
JOIN Sales.SalesPerson S ON SO.SalesPersonID = S.BusinessEntityID
JOIN Sales.SalesTerritory ST ON SO.TerritoryID = ST.TerritoryID
JOIN Sales.SalesOrderDetail SOD ON SO.SalesOrderID = SOD.SalesOrderID
JOIN Production.Product P ON SOD.ProductID = P.ProductID
