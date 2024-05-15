USE ORDERS_RELATIONAL_DB;

INSERT INTO Products (ProductID, ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);