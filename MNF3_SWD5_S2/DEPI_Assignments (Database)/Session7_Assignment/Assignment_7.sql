-- 1)
CREATE NONCLUSTERED INDEX IX_Customers_CustomerEmail
ON sales.customers (email)





-- 2)
CREATE NONCLUSTERED INDEX IX_Products_Brand_Category
ON production.products (brand_id, category_id)





-- 3)
CREATE INDEX IX_Orders_OrderDate
ON sales.orders (order_date)
INCLUDE (customer_id, store_id, order_status)





-- 4)
CREATE TABLE sales.customer_log (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    customer_id INT,
    log_message NVARCHAR(255),
    log_date DATETIME DEFAULT GETDATE()
)

CREATE TRIGGER trg_AfterInsertCustomer
ON sales.customers
AFTER INSERT
AS
BEGIN
    INSERT INTO sales.customer_log (customer_id, log_message)
    SELECT 
        customer_id, 
        'Welcome! Customer account created successfully.'
    FROM inserted;
END

INSERT INTO sales.customers (first_name, last_name, email)
VALUES ('Ahmed', 'Samy', 'ahmedsamy@gmail.com')

SELECT *
FROM sales.customer_log

SELECT *
FROM sales.customers
WHERE customer_id = 8502





-- 5)
CREATE TABLE production.price_history (
    history_id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT,
    old_price DECIMAL(18, 2),
    new_price DECIMAL(18, 2),
    change_date DATETIME DEFAULT GETDATE()
)


CREATE TRIGGER trg_LogPriceChange
ON production.products
AFTER UPDATE
AS
BEGIN
   INSERT INTO production.price_history (product_id, old_price, new_price)
    SELECT 
        i.product_id,
        d.list_price AS old_price,
        i.list_price AS new_price
    FROM inserted i
    INNER JOIN deleted d ON i.product_id = d.product_id
    WHERE i.list_price <> d.list_price;
END





-- 6)
CREATE TRIGGER trg_PreventCategoryDelete
ON production.categories
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM deleted d
        JOIN production.products p ON d.category_id = p.category_id
    )
    BEGIN
        RAISERROR('Cannot delete category: associated products exist.', 16, 1);
        RETURN;
    END

    DELETE FROM production.categories
    WHERE category_id IN (SELECT category_id FROM deleted)
END





-- 7-)
CREATE TRIGGER trg_UpdateStockOnOrder
ON sales.order_items
AFTER INSERT
AS
BEGIN
    UPDATE S
    SET S.quantity = S.quantity - i.quantity
    FROM production.stocks S INNER JOIN inserted i 
	ON S.product_id = i.product_id
END






-- 8)
CREATE TABLE sales.order_audit (
    audit_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT,
    customer_id INT,
    store_id INT,
    staff_id INT,
    order_date DATE,
    audit_timestamp DATETIME DEFAULT GETDATE()
);


CREATE TRIGGER LOG_INTO_ORDER_AUDIT
ON sales.orders
AFTER INSERT
AS
BEGIN
   INSERT INTO 	sales.orders (order_id,customer_id,store_id,staff_id,order_date)
   SELECT I.order_id,I.customer_id,I.store_id,I.staff_id,I.order_date
   FROM inserted I
END

