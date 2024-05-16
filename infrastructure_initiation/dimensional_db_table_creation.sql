USE [ORDERS_DIMENSIONAL_DB]
GO


DROP TABLE IF EXISTS [dbo].[DimCategories];
DROP TABLE IF EXISTS [dbo].[DimShippers];
DROP TABLE IF EXISTS [dbo].[DimCustomers];
DROP TABLE IF EXISTS [dbo].[DimRegion];
DROP TABLE IF EXISTS [dbo].[DimTerritories];
DROP TABLE IF EXISTS [dbo].[DimSuppliers];
DROP TABLE IF EXISTS [dbo].[DimSuppliers_SCD4_History];
DROP TABLE IF EXISTS [dbo].[DimProducts];
DROP TABLE IF EXISTS [dbo].[DimProducts_SCD4_History];
DROP TABLE IF EXISTS [dbo].[DimEmployees];
DROP TABLE IF EXISTS [dbo].[DimEmployees_SCD4_History];
DROP TABLE IF EXISTS [dbo].[FactOrders];

--------------------------------------- DimCategories SCD1 with delete -------------------------------------
CREATE TABLE [dbo].[DimCategories] (
	CategoryID int NOT NULL IDENTITY(1,1),
	BusinessKey int NOT NULL,
	CategoryName NVARCHAR(40),
    Description NVARCHAR(100)
        )
GO



--------------------------------------- DimShippers SCD1 -------------------------------------
CREATE TABLE [dbo].[DimShippers] (
	ShipperID int NOT NULL IDENTITY(1,1),
	BusinessKey int NOT NULL,
	CompanyName NVARCHAR(50),
    Phone NVARCHAR(30)
        )
GO



--------------------------------------- DimCustomers SCD2 -------------------------------------
CREATE TABLE [dbo].[DimCustomers] (
	CustomerID int NOT NULL IDENTITY(1,1),
	BusinessKey NVARCHAR(20) NOT NULL,
    CompanyName NVARCHAR(50),
    ContactName NVARCHAR(40),
    ContactTitle NVARCHAR(40),
    Address NVARCHAR(60),
    City NVARCHAR(40),
    Region NVARCHAR(30),
    PostalCode NVARCHAR(30),
    Country NVARCHAR(30),
    Phone NVARCHAR(30),
    Fax NVARCHAR(30),
	ValidFrom INT NULL,
	ValidTo INT NULL,
	IsCurrent BIT NULL
) ON [PRIMARY]
GO




--------------------------------------- DimRegion SCD3 -------------------------------------
CREATE TABLE [dbo].[DimRegion](
	RegionID int NOT NULL IDENTITY(1,1),
	BusinessKey int NOT NULL,
	RegionDescription NVARCHAR(50),
	RegionDescription_prior NVARCHAR(50),
	RegionDescription_prior_ValidTo char(8) NULL,
        )



--------------------------------------- DimTerritories SCD3 -------------------------------------
CREATE TABLE [dbo].[DimTerritories](
    TerritoryID int NOT NULL IDENTITY(1,1),
    BusinessKey NVARCHAR(20) NOT NULL,
    TerritoryDescription NVARCHAR(50),
    TerritoryDescription_prior NVARCHAR(50),
    TerritoryDescription_prior_ValidTo char(8) NULL,
    RegionID INT
)
GO



--------------------------------------- DimSuppliers SCD4 -------------------------------------
CREATE TABLE DimSuppliers (
    SupplierID INT IDENTITY(1,1) NOT NULL,
    BusinessKey INT NOT NULL,
    CompanyName VARCHAR(255),
    ContactName VARCHAR(255),
    ContactTitle VARCHAR(255),
    Address VARCHAR(255),
    City VARCHAR(255),
    Region VARCHAR(255),
    PostalCode VARCHAR(10),
    Country VARCHAR(255),
    Phone VARCHAR(15),
    Fax VARCHAR(15),
    HomePage VARCHAR(255),
);
GO

CREATE TABLE DimSuppliers_SCD4_History (
    HistoryID INT IDENTITY(1,1) NOT NULL,
    BusinessKey INT NULL,
    CompanyName VARCHAR(255),
    ContactName VARCHAR(255),
    ContactTitle VARCHAR(255),
    Address VARCHAR(255),
    City VARCHAR(255),
    Region VARCHAR(255),
    PostalCode VARCHAR(10),
    Country VARCHAR(255),
    Phone VARCHAR(15),
    Fax VARCHAR(15),
    HomePage VARCHAR(255),
    ValidTo DATETIME NULL,
);



--------------------------------------- DimProducts SCD4 -------------------------------------
CREATE TABLE DimProducts (
    ProductID INT IDENTITY(1,1) NOT NULL,
    BusinessKey INT NOT NULL,
    ProductName NVARCHAR(40),
    SupplierID INT,
    CategoryID INT,
    QuantityPerUnit NVARCHAR(30),
    UnitPrice MONEY,
    UnitsInStock INT,
    UnitsOnOrder INT,
    ReorderLevel INT,
    Discontinued BIT
);
GO

CREATE TABLE DimProducts_SCD4_History (
    HistoryID INT IDENTITY(1,1) NOT NULL,
    BusinessKey INT NULL,
    ProductName NVARCHAR(40),
    SupplierID INT,
    CategoryID INT,
    QuantityPerUnit NVARCHAR(30),
    UnitPrice MONEY,
    UnitsInStock INT,
    UnitsOnOrder INT,
    ReorderLevel INT,
    Discontinued BIT,
    ValidTo DATETIME NULL,
);



--------------------------------------- DimEmployees SCD4  -------------------------------------
CREATE TABLE DimEmployees (
    EmployeeID INT IDENTITY(1,1) NOT NULL,
    BusinessKey INT NOT NULL,
    LastName NVARCHAR(50),
    FirstName NVARCHAR(50),
    Title NVARCHAR(100),
    TitleOfCourtesy NVARCHAR(10),
    BirthDate DATE,
    HireDate DATE,
    Address NVARCHAR(60),
    City NVARCHAR(40),
    Region NVARCHAR(50),
    PostalCode NVARCHAR(30),
    Country NVARCHAR(30),
    HomePhone NVARCHAR(30),
    Extension NVARCHAR(10),
    Notes NVARCHAR(MAX),
    ReportsTo INT,
    PhotoPath NVARCHAR(MAX),
);
GO

CREATE TABLE DimEmployees_SCD4_History (
    HistoryID INT IDENTITY(1,1) NOT NULL,
    BusinessKey INT NULL,
    LastName NVARCHAR(50),
    FirstName NVARCHAR(50),
    Title NVARCHAR(100),
    TitleOfCourtesy NVARCHAR(10),
    BirthDate DATE,
    HireDate DATE,
    Address NVARCHAR(60),
    City NVARCHAR(40),
    Region NVARCHAR(50),
    PostalCode NVARCHAR(30),
    Country NVARCHAR(30),
    HomePhone NVARCHAR(30),
    Extension NVARCHAR(10),
    Notes NVARCHAR(MAX),
    ReportsTo INT,
    PhotoPath NVARCHAR(MAX),
    ValidTo DATETIME NULL,
);


--------------------------- FactOrders Snapshot -------------------------
CREATE TABLE FactOrders (
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    CustomerID VARCHAR(10),
    EmployeeID INT,
    OrderDate DATETIME,
    RequiredDate DATETIME,
    ShippedDate DATETIME,
    ShipVia INT,
    Freight FLOAT,
    ShipName VARCHAR(100),
    ShipAddress VARCHAR(100),
    ShipCity VARCHAR(100),
    ShipRegion VARCHAR(100),
    ShipPostalCode VARCHAR(20),
    ShipCountry VARCHAR(100),
    TerritoryID INT,
    UnitPrice FLOAT,
    Quantity INT,
    Discount FLOAT
);

INSERT INTO FactOrders (
    OrderID,
    ProductID,
    CustomerID,
    EmployeeID,
    OrderDate,
    RequiredDate,
    ShippedDate,
    ShipVia,
    Freight,
    ShipName,
    ShipAddress,
    ShipCity,
    ShipRegion,
    ShipPostalCode,
    ShipCountry,
    TerritoryID,
    UnitPrice,
    Quantity,
    Discount
)
SELECT 
    o.OrderID,
    od.ProductID,
    o.CustomerID,
    o.EmployeeID,
    o.OrderDate,
    o.RequiredDate,
    o.ShippedDate,
    o.ShipVia,
    o.Freight,
    o.ShipName,
    o.ShipAddress,
    o.ShipCity,
    o.ShipRegion,
    o.ShipPostalCode,
    o.ShipCountry,
    o.TerritoryID,
    od.UnitPrice,
    od.Quantity,
    od.Discount
FROM [ORDERS_RELATIONAL_DB].[dbo].Orders o
JOIN [ORDERS_RELATIONAL_DB].[dbo].OrderDetails od ON o.OrderID = od.OrderID;




-- Primary Key (PK) Constraints

ALTER TABLE DimCategories ADD CONSTRAINT PK_DimCategories PRIMARY KEY (CategoryID);
ALTER TABLE DimCustomers ADD CONSTRAINT PK_DimCustomers PRIMARY KEY (CustomerID);
ALTER TABLE DimEmployees ADD CONSTRAINT PK_DimEmployees PRIMARY KEY (EmployeeID);
ALTER TABLE DimProducts ADD CONSTRAINT PK_DimProducts PRIMARY KEY (ProductID);
ALTER TABLE DimRegion ADD CONSTRAINT PK_DimRegion PRIMARY KEY (RegionID);
ALTER TABLE DimShippers ADD CONSTRAINT PK_DimShippers PRIMARY KEY (ShipperID);
ALTER TABLE DimSuppliers ADD CONSTRAINT PK_DimSuppliers PRIMARY KEY (SupplierID);
ALTER TABLE DimTerritories ADD CONSTRAINT PK_DimTerritories PRIMARY KEY (TerritoryID);
ALTER TABLE FactOrders ADD CONSTRAINT PK_FactOrders PRIMARY KEY (OrderID, ProductID); 




-- Foreign Key (FK) Constraints
ALTER TABLE DimEmployees ADD CONSTRAINT FK_DimEmployees_ReportsTo FOREIGN KEY (ReportsTo) REFERENCES DimEmployees(EmployeeID);
ALTER TABLE DimProducts ADD CONSTRAINT FK_DimProducts_SupplierID FOREIGN KEY (SupplierID) REFERENCES DimSuppliers(SupplierID);
ALTER TABLE DimProducts ADD CONSTRAINT FK_DimProducts_CategoryID FOREIGN KEY (CategoryID) REFERENCES DimCategories(CategoryID);
ALTER TABLE DimTerritories ADD CONSTRAINT FK_DimTerritories_RegionID FOREIGN KEY (RegionID) REFERENCES DimRegion(RegionID);
ALTER TABLE FactOrders ADD CONSTRAINT FK_FactOrders_DimProducts FOREIGN KEY (ProductID) REFERENCES DimProducts(ProductID);
--ALTER TABLE FactOrders ADD CONSTRAINT FK_FactOrders_DimCustomers FOREIGN KEY (CustomerID) REFERENCES DimCustomers(CustomerID);
ALTER TABLE FactOrders ADD CONSTRAINT FK_FactOrders_DimEmployees FOREIGN KEY (EmployeeID) REFERENCES DimEmployees(EmployeeID);
ALTER TABLE FactOrders ADD CONSTRAINT FK_FactOrders_DimShippers FOREIGN KEY (ShipVia) REFERENCES DimShippers(ShipperID);
--ALTER TABLE FactOrders ADD CONSTRAINT FK_FactOrders_DimTerritories FOREIGN KEY (TerritoryID) REFERENCES DimTerritories(TerritoryID);
GO




