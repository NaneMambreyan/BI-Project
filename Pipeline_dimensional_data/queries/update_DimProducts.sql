     DECLARE @DimProducts_SCD4 TABLE (
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
    MergeAction varchar(10) NULL
);


   MERGE {db_dim}.{schema_dim}.{table_dim} AS DST
    USING {db_rel}.{schema_rel}.{table_rel} AS SRC
    ON (SRC.ProductID = DST.ProductID)

    WHEN NOT MATCHED THEN
    INSERT (BusinessKey, ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued)
    VALUES (SRC.ProductID, SRC.ProductName, SRC.SupplierID, SRC.CategoryID, SRC.QuantityPerUnit, SRC.UnitPrice, SRC.UnitsInStock, SRC.UnitsOnOrder, SRC.ReorderLevel, SRC.Discontinued)

    WHEN MATCHED AND(
        ISNULL(DST.ProductName,'') <> ISNULL(SRC.ProductName,'') OR
        ISNULL(DST.SupplierID,'') <> ISNULL(SRC.SupplierID,'') OR
        ISNULL(DST.CategoryID,'') <> ISNULL(SRC.CategoryID,'') OR
        ISNULL(DST.QuantityPerUnit,'') <> ISNULL(SRC.QuantityPerUnit,'') OR
        ISNULL(DST.UnitPrice,'') <> ISNULL(SRC.UnitPrice,'') OR
        ISNULL(DST.UnitsInStock,'') <> ISNULL(SRC.UnitsInStock,'') OR
        ISNULL(DST.UnitsOnOrder,'') <> ISNULL(SRC.UnitsOnOrder,'') OR
        ISNULL(DST.ReorderLevel,'') <> ISNULL(SRC.ReorderLevel,'') OR
        ISNULL(DST.Discontinued,'') <> ISNULL(SRC.Discontinued,'') )
    THEN UPDATE
    SET
        DST.ProductName = SRC.ProductName,
        DST.SupplierID = SRC.SupplierID,
        DST.CategoryID = SRC.CategoryID,
        DST.QuantityPerUnit = SRC.QuantityPerUnit,
        DST.UnitPrice = SRC.UnitPrice,
        DST.UnitsInStock = SRC.UnitsInStock,
        DST.UnitsOnOrder = SRC.UnitsOnOrder,
        DST.ReorderLevel = SRC.ReorderLevel,
        DST.Discontinued = SRC.Discontinued
    OUTPUT DELETED.BusinessKey, DELETED.ProductName, DELETED.SupplierID, DELETED.CategoryID, DELETED.QuantityPerUnit, DELETED.UnitPrice, DELETED.UnitsInStock, DELETED.UnitsOnOrder, DELETED.ReorderLevel, DELETED.Discontinued, $Action AS MergeAction
    INTO @DimProducts_SCD4 (BusinessKey, ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued, MergeAction);

    -- Update history table to set final date and current flag
    UPDATE TP4
    SET TP4.ValidTo = CONVERT(DATE, GETDATE())
    FROM DimProducts_SCD4_History TP4
    INNER JOIN @DimProducts_SCD4 TMP ON TP4.BusinessKey = TMP.BusinessKey
    WHERE TP4.ValidTo IS NULL;

    -- Add latest history records to history table
    INSERT INTO DimProducts_SCD4_History (BusinessKey, ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued,  ValidTo)
    SELECT BusinessKey, ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued,  GETDATE()
    FROM @DimProducts_SCD4
    WHERE BusinessKey IS NOT NULL;