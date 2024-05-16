USE ORDERS_DIMENSIONAL_DB;
DROP PROCEDURE IF EXISTS [dbo].[DimProducts_SCD4_ETL];
GO

CREATE PROCEDURE [dbo].[DimProducts_SCD4_ETL]
    @SourceTable NVARCHAR(255),
    @DestinationTable NVARCHAR(255),
    @HistoryTable NVARCHAR(255)
AS
BEGIN TRY
    DECLARE @MergeSQL NVARCHAR(MAX);

    SET @MergeSQL = '
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

        MERGE ' + @DestinationTable + ' AS DST
        USING ' + @SourceTable + ' AS SRC
        ON (SRC.ProductID = DST.ProductID)

        WHEN NOT MATCHED THEN
            INSERT (BusinessKey, ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued)
            VALUES (SRC.ProductID, SRC.ProductName, SRC.SupplierID, SRC.CategoryID, SRC.QuantityPerUnit, SRC.UnitPrice, SRC.UnitsInStock, SRC.UnitsOnOrder, SRC.ReorderLevel, SRC.Discontinued)

        WHEN MATCHED AND (
            ISNULL(DST.ProductName, '''') <> ISNULL(SRC.ProductName, '''') OR
            ISNULL(DST.SupplierID, 0) <> ISNULL(SRC.SupplierID, 0) OR
            ISNULL(DST.CategoryID, 0) <> ISNULL(SRC.CategoryID, 0) OR
            ISNULL(DST.QuantityPerUnit, '''') <> ISNULL(SRC.QuantityPerUnit, '''') OR
            ISNULL(DST.UnitPrice, 0) <> ISNULL(SRC.UnitPrice, 0) OR
            ISNULL(DST.UnitsInStock, 0) <> ISNULL(SRC.UnitsInStock, 0) OR
            ISNULL(DST.UnitsOnOrder, 0) <> ISNULL(SRC.UnitsOnOrder, 0) OR
            ISNULL(DST.ReorderLevel, 0) <> ISNULL(SRC.ReorderLevel, 0) OR
            ISNULL(DST.Discontinued, 0) <> ISNULL(SRC.Discontinued, 0)
        )
        THEN 
            UPDATE
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

        UPDATE TP4
        SET TP4.ValidTo = CONVERT(DATE, GETDATE())
        FROM ' + @HistoryTable + ' TP4
        INNER JOIN @DimProducts_SCD4 TMP ON TP4.BusinessKey = TMP.BusinessKey
        WHERE TP4.ValidTo IS NULL;

        INSERT INTO ' + @HistoryTable + ' (BusinessKey, ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued,  ValidTo)
        SELECT BusinessKey, ProductName, SupplierID, CategoryID, QuantityPerUnit, UnitPrice, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued,  GETDATE()
        FROM @DimProducts_SCD4
        WHERE BusinessKey IS NOT NULL;
    ';

    EXEC sp_executesql @MergeSQL;
END TRY
BEGIN CATCH
    THROW;
END CATCH;


EXEC [dbo].[DimProducts_SCD4_ETL]
    @SourceTable = '[ORDERS_RELATIONAL_DB].[dbo].[Products]',
    @DestinationTable = 'dbo.DimProducts',
    @HistoryTable = 'DimProducts_SCD4_History';



select * from [ORDERS_RELATIONAL_DB].[dbo].Products


SELECT * FROM DimProducts;
GO

SELECT * FROM DimProducts_SCD4_History;
GO
