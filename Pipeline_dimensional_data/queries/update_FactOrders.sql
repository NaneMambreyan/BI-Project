
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
MERGE INTO {db_dim}.{schema_dim}.{table_dim} AS Target
USING (
    SELECT 
        S1.[OrderID] AS SrcOrderID,
        S1.[ProductID] AS SrcProductID,
        S1.[CustomerID] AS SrcCustomerID,
        S1.[EmployeeID] AS SrcEmployeeID,
        S1.[OrderDate] AS SrcOrderDate,
        S1.[RequiredDate] AS SrcRequiredDate,
        S1.[ShippedDate] AS SrcShippedDate,
        S1.[ShipVia] AS SrcShipVia,
        S1.[Freight] AS SrcFreight,
        S1.[ShipName] AS SrcShipName,
        S1.[ShipAddress] AS SrcShipAddress,
        S1.[ShipCity] AS SrcShipCity,
        S1.[ShipRegion] AS SrcShipRegion,
        S1.[ShipPostalCode] AS SrcShipPostalCode,
        S1.[ShipCountry] AS SrcShipCountry,
        S1.[TerritoryID] AS SrcTerritoryID,
        S2.[UnitPrice] AS SrcUnitPrice,
        S2.[Quantity] AS SrcQuantity,
        S2.[Discount] AS SrcDiscount
    FROM {db_rel}.{schema_rel}.Orders AS S1
    INNER JOIN 
    {db_rel}.{schema_rel}.OrderDetails AS S2 
    ON S1.[OrderID] = S2.[OrderID]
) AS Source 
ON Target.[OrderID] = Source.SrcOrderID AND Target.[ProductID] = Source.SrcProductID
WHEN MATCHED THEN
    UPDATE SET
        Target.[OrderDate] = Source.SrcOrderDate,
        Target.[RequiredDate] = Source.SrcRequiredDate,
        Target.[ShippedDate] = Source.SrcShippedDate,
        Target.[ShipVia] = Source.SrcShipVia,
        Target.[Freight] = Source.SrcFreight,
        Target.[ShipName] = Source.SrcShipName,
        Target.[ShipAddress] = Source.SrcShipAddress,
        Target.[ShipCity] = Source.SrcShipCity,
        Target.[ShipRegion] = Source.SrcShipRegion,
        Target.[ShipPostalCode] = Source.SrcShipPostalCode,
        Target.[ShipCountry] = Source.SrcShipCountry,
        Target.[TerritoryID] = Source.SrcTerritoryID,
        Target.[UnitPrice] = Source.SrcUnitPrice,
        Target.[Quantity] = Source.SrcQuantity,
        Target.[Discount] = Source.SrcDiscount
WHEN NOT MATCHED THEN
    INSERT (
        [OrderID],
        [ProductID],
        [CustomerID],
        [EmployeeID],
        [OrderDate],
        [RequiredDate],
        [ShippedDate],
        [ShipVia],
        [Freight],
        [ShipName],
        [ShipAddress],
        [ShipCity],
        [ShipRegion],
        [ShipPostalCode],
        [ShipCountry],
        [TerritoryID],
        [UnitPrice],
        [Quantity],
        [Discount]
    ) VALUES (
        Source.SrcOrderID,
        Source.SrcProductID,
        Source.SrcCustomerID,
        Source.SrcEmployeeID,
        Source.SrcOrderDate,
        Source.SrcRequiredDate,
        Source.SrcShippedDate,
        Source.SrcShipVia,
        Source.SrcFreight,
        Source.SrcShipName,
        Source.SrcShipAddress,
        Source.SrcShipCity,
        Source.SrcShipRegion,
        Source.SrcShipPostalCode,
        Source.SrcShipCountry,
        Source.SrcTerritoryID,
        Source.SrcUnitPrice,
        Source.SrcQuantity,
        Source.SrcDiscount
    );
