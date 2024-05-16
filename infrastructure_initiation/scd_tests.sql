--------------------------------------- DimCategories SCD1 with delete -------------------------------------

--Test Scenario 1: Empty destination table
SELECT * FROM [dbo].[DimCategories];
GO
EXEC [ORDERS_DIMENSIONAL_DB].[dbo].[DimCategories_SCD1_ETL];
GO
SELECT * FROM [dbo].[DimCategories];
GO



--Test Scenario 3: New rows in the source table
INSERT INTO [ORDERS_RELATIONAL_DB].[dbo].[Categories] (CategoryID, CategoryName, Description)
VALUES (100, 'Electronics', 'Electronic devices and accessories');
GO

EXEC [ORDERS_DIMENSIONAL_DB].[dbo].[DimCategories_SCD1_ETL];
GO

SELECT * FROM [dbo].[DimCategories];
GO



--Scenario 2: Updated rows in the source table
UPDATE [ORDERS_RELATIONAL_DB].[dbo].[Categories]
	SET Description = 'STH NEW'
	WHERE CategoryName = 'Electronics';
GO

EXEC [ORDERS_DIMENSIONAL_DB].[dbo].[DimCategories_SCD1_ETL];
GO

SELECT * FROM [dbo].[DimCategories];
GO



--Scenario 4: DeLETE rows from the source table
DELETE FROM [ORDERS_RELATIONAL_DB].[dbo].[Categories] where CategoryName = 'Electronics';
GO

EXEC [ORDERS_DIMENSIONAL_DB].[dbo].[DimCategories_SCD1_ETL];
GO

SELECT * FROM [dbo].[DimCategories];
GO






--------------------------------------- DimShippers SCD1 -------------------------------------

--Test Scenario 1: Empty destination table
SELECT * FROM [dbo].[DimShippers];
GO
EXEC [ORDERS_DIMENSIONAL_DB].[dbo].[DimShippers_SCD1_ETL];
GO
SELECT * FROM [dbo].[DimShippers];
GO



--Test Scenario 3: New rows in the source table
INSERT INTO [ORDERS_RELATIONAL_DB].[dbo].[Shippers] (ShipperID, CompanyName, Phone)
VALUES (100, 'AUA', '000');
GO

EXEC [ORDERS_DIMENSIONAL_DB].[dbo].[DimShippers_SCD1_ETL];
GO

SELECT * FROM [dbo].[DimShippers];
GO



--Scenario 2: Updated rows in the source table
UPDATE [ORDERS_RELATIONAL_DB].[dbo].[Shippers]
	SET Phone = '111'
	WHERE CompanyName = 'AUA';
GO

EXEC [ORDERS_DIMENSIONAL_DB].[dbo].[DimShippers_SCD1_ETL];
GO

SELECT * FROM [dbo].[DimShippers];
GO







--------------------------------------- DimCustomers SCD2 -------------------------------------

--Test Scenario 1: Empty destination table
SELECT * FROM [dbo].[DimCustomers];
GO

EXEC [ORDERS_DIMENSIONAL_DB].[dbo].[DimCustomers_SCD2_ETL];
GO

SELECT * FROM [dbo].[DimCustomers];
GO




--Test Scenario 2: Updated rows in the source table
UPDATE [ORDERS_RELATIONAL_DB].[dbo].[Customers]
	SET Region = 'YEREVAAAAAN'
	WHERE ContactName = 'Yang Wang';
GO

EXEC [ORDERS_DIMENSIONAL_DB].[dbo].[DimCustomers_SCD2_ETL];
GO

SELECT * FROM [dbo].[DimCustomers];
GO

--Test Scenario 3: New rows in the source table
INSERT INTO [ORDERS_RELATIONAL_DB].[dbo].[Customers] (CustomerID, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax)
VALUES
('Nane Mambreyan', 'Example Company', 'Nane Mambreyan', 'CEO', '123 Example St', 'YEREVAN', NULL, '12345', 'Example Country', '555-123-4567', NULL);

GO
EXEC [ORDERS_DIMENSIONAL_DB].[dbo].[DimCustomers_SCD2_ETL];
GO

SELECT * FROM [dbo].[DimCustomers];
GO




--------------------------------------- DimRegion SCD3 -------------------------------------

-- Test Scenario 1: Empty destination table
SELECT * FROM [dbo].[DimRegion];
GO

EXEC [ORDERS_DIMENSIONAL_DB].[dbo].[DimRegion_SCD3_ETL];
GO

SELECT * FROM [dbo].[DimRegion];
GO

-- Test Scenario 2: Updated rows in the source table 
UPDATE [ORDERS_RELATIONAL_DB].[dbo].[Region]
	SET RegionDescription = 'EASTERNNN'
	WHERE RegionID = 1;
GO

EXEC [ORDERS_DIMENSIONAL_DB].[dbo].[DimRegion_SCD3_ETL];
GO

SELECT * FROM [dbo].[DimRegion];
GO


-- Test Scenario 3: Updated rows in the source table 
UPDATE [ORDERS_RELATIONAL_DB].[dbo].[Region]
	SET RegionDescription = 'UPDATED'
	WHERE RegionID = 1;
GO

EXEC [ORDERS_DIMENSIONAL_DB].[dbo].[DimRegion_SCD3_ETL];
GO

SELECT * FROM [dbo].[DimRegion];
GO






--------------------------------------- DimTerritories SCD3 -------------------------------------

-- Test Scenario 1: Empty destination table
SELECT * FROM [dbo].[DimTerritories];
GO

EXEC [dbo].[DimTerritories_SCD3_ETL];
GO

SELECT * FROM [dbo].[DimTerritories];
GO

-- Test Scenario 2: Updated rows in the source table 
UPDATE [ORDERS_RELATIONAL_DB].[dbo].[Territories]
    SET TerritoryDescription = 'Updated Territory Description'
    WHERE TerritoryDescription = 'Westboro';
GO

EXEC [dbo].[DimTerritories_SCD3_ETL];
GO

SELECT * FROM [dbo].[DimTerritories];
GO






--------------------------------------- DimSuppliers SCD4 -------------------------------------

select * from [ORDERS_RELATIONAL_DB].[dbo].Suppliers


-- Test Scenario 1: Empty Destination
SELECT * FROM DimSuppliers;
GO

SELECT * FROM DimSuppliers_SCD4_History;
GO

EXEC [dbo].[DimSuppliers_SCD4_ETL];
GO

SELECT * FROM DimSuppliers;
GO

SELECT * FROM DimSuppliers_SCD4_History;
GO




-- Test scenario 2: New rows in the source table
select * from [ORDERS_RELATIONAL_DB].[dbo].Suppliers

INSERT INTO [ORDERS_RELATIONAL_DB].[dbo].[Suppliers] (SupplierID, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax, HomePage)
VALUES (30, 'Supplier One', 'John Doe', 'Manager', '123 Main St', 'Anytown', 'Anyregion', '12345', 'USA', '555-1234', '555-5678', 'www.supplierone.com');


EXEC DimSuppliers_SCD4_ETL;
GO

SELECT * FROM DimSuppliers;
GO

SELECT * FROM DimSuppliers_SCD4_History;
GO





-- Test Scenario3: After first Update 
UPDATE [ORDERS_RELATIONAL_DB].[dbo].[Suppliers]
SET CompanyName = 'UPDATE1'
WHERE SupplierID = 1;
GO

EXEC DimSuppliers_SCD4_ETL;
GO

SELECT * FROM DimSuppliers;
GO

SELECT * FROM DimSuppliers_SCD4_History;
GO


-- Test Scenario 4: After second Update 
UPDATE [ORDERS_RELATIONAL_DB].[dbo].[Suppliers]
SET CompanyName = 'UPDATE2'
WHERE SupplierID = 1;
GO

EXEC DimSuppliers_SCD4_ETL;
GO

SELECT * FROM DimSuppliers;
GO

SELECT * FROM DimSuppliers_SCD4_History;
GO





--------------------------------------- DimProducts SCD4 -------------------------------------

select * from [ORDERS_RELATIONAL_DB].[dbo].Products


-- Test Scenario 1: Empty Destination
SELECT * FROM DimProducts;
GO

SELECT * FROM DimProducts_SCD4_History;
GO

EXEC [dbo].[DimProducts_SCD4_ETL];
GO

SELECT * FROM DimProducts;
GO

SELECT * FROM DimProducts_SCD4_History;
GO




-- Test scenario 2: New rows in the source table
select * from [ORDERS_RELATIONAL_DB].[dbo].Products

INSERT INTO [ORDERS_RELATIONAL_DB].[dbo].[Products] (ProductID, ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued)
VALUES (78, 'Product Name', 1, 1, '30 units per case', 10.99, 100, 20, 10, 0);


EXEC DimProducts_SCD4_ETL;
GO

SELECT * FROM DimProducts;
GO

SELECT * FROM DimProducts_SCD4_History;
GO





-- Test Scenario3: After first Update 
UPDATE [ORDERS_RELATIONAL_DB].[dbo].[Products]
SET ProductName = 'UPDATE1'
WHERE ProductID = 78;
GO

EXEC DimProducts_SCD4_ETL;
GO

SELECT * FROM DimProducts;
GO

SELECT * FROM DimProducts_SCD4_History;
GO


-- Test Scenario 4: After second Update 
UPDATE [ORDERS_RELATIONAL_DB].[dbo].[Products]
SET ProductName = 'UPDATE2'
WHERE ProductID = 78;
GO


EXEC DimProducts_SCD4_ETL;
GO

SELECT * FROM DimProducts;
GO

SELECT * FROM DimProducts_SCD4_History;
GO

