USE ORDERS_RELATIONAL_DB;

DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS OrderDetails;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Region;
DROP TABLE IF EXISTS Shippers;
DROP TABLE IF EXISTS Suppliers;
DROP TABLE IF EXISTS Territories;


CREATE TABLE Categories (
    CategoryID INT NOT NULL,
    CategoryName NVARCHAR(40),
    Description NVARCHAR(100)
);

CREATE TABLE Customers (
    CustomerID NVARCHAR(20) NOT NULL,
    CompanyName NVARCHAR(50),
    ContactName NVARCHAR(40),
    ContactTitle NVARCHAR(40),
    Address NVARCHAR(60),
    City NVARCHAR(40),
    Region NVARCHAR(30),
    PostalCode NVARCHAR(30),
    Country NVARCHAR(30),
    Phone NVARCHAR(30),
    Fax NVARCHAR(30)
);

CREATE TABLE Employees (
    EmployeeID INT NOT NULL,
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
    PhotoPath NVARCHAR(MAX)
);

CREATE TABLE OrderDetails (
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    UnitPrice MONEY,
    Quantity INT,
    Discount FLOAT
);

CREATE TABLE Orders (
    OrderID INT NOT NULL,
    CustomerID NVARCHAR(20),
    EmployeeID INT,
    OrderDate DATE,
    RequiredDate DATE,
    ShippedDate DATE,
    ShipVia INT,
    Freight MONEY,
    ShipName NVARCHAR(40),
    ShipAddress NVARCHAR(60),
    ShipCity NVARCHAR(40),
    ShipRegion NVARCHAR(25),
    ShipPostalCode NVARCHAR(30),
    ShipCountry NVARCHAR(30),
    TerritoryID NVARCHAR(20)
);

CREATE TABLE Products (
    ProductID INT NOT NULL,
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

CREATE TABLE Region (
    RegionID INT NOT NULL,
    RegionDescription NVARCHAR(50)
);

CREATE TABLE Shippers (
    ShipperID INT NOT NULL,
    CompanyName NVARCHAR(50),
    Phone NVARCHAR(30)
);

CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY,
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
    HomePage VARCHAR(255)
);


CREATE TABLE Territories (
    TerritoryID NVARCHAR(20) NOT NULL,
    TerritoryDescription NVARCHAR(50),
    RegionID INT
);
