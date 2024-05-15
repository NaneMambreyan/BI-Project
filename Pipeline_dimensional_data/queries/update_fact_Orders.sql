USE ORDERS_DIMENSIONAL_DB;

DECLARE @FactTableName NVARCHAR(255); 


DECLARE @MergeQuery NVARCHAR(MAX);

SET @MergeQuery = '
MERGE INTO [dbo].[' + @FactTableName + '] AS Target
USING (
    SELECT 
        -- Select columns from source tables
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
    FROM
        -- Source tables (replace with actual source tables)
        [ORDERS_RELATIONAL_DB].[dbo].Orders AS S1
        INNER JOIN [ORDERS_RELATIONAL_DB].[dbo].OrderDetails AS S2 ON S1.[OrderID] = S2.[OrderID]
) AS Source ON Target.[OrderID] = Source.[OrderID] AND Target.[ProductID] = Source.[ProductID]
WHEN MATCHED THEN
    -- Update existing records if necessary
    UPDATE SET
        -- Update statements here
WHEN NOT MATCHED THEN
    -- Insert new records if necessary
    INSERT (
        -- Columns list
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
        -- Values list from source
        Source.[OrderID],
        Source.[ProductID],
        Source.[CustomerID],
        Source.[EmployeeID],
        Source.[OrderDate],
        Source.[RequiredDate],
        Source.[ShippedDate],
        Source.[ShipVia],
        Source.[Freight],
        Source.[ShipName],
        Source.[ShipAddress],
        Source.[ShipCity],
        Source.[ShipRegion],
        Source.[ShipPostalCode],
        Source.[ShipCountry],
        Source.[TerritoryID],
        Source.[UnitPrice],
        Source.[Quantity],
        Source.[Discount]
    );
';

EXEC sp_executesql @MergeQuery;
