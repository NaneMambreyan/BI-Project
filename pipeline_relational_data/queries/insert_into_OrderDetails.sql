USE ORDERS_RELATIONAL_DB;

INSERT INTO OrderDetails (OrderID, ProductID, UnitPrice, Quantity, Discount)
VALUES (?, ?, ?, ?, ?);