USE ORDERS_DIMENSIONAL_DB;
DROP PROCEDURE IF EXISTS [dbo].[DimShippers_SCD1_ETL];
GO

CREATE PROCEDURE [dbo].[DimShippers_SCD1_ETL]
    @SourceTable NVARCHAR(255),
    @DestinationTable NVARCHAR(255)
AS
BEGIN TRY
    DECLARE @MergeSQL NVARCHAR(MAX);

    SET @MergeSQL = '
    MERGE ' + @DestinationTable + ' AS DST 
    USING ' + @SourceTable + ' AS SRC 
    ON (SRC.ShipperID = DST.BusinessKey)
    WHEN NOT MATCHED THEN 
        INSERT (BusinessKey, CompanyName, Phone)
        VALUES (SRC.ShipperID,
                SRC.CompanyName,
                SRC.Phone)
    WHEN MATCHED AND (
        ISNULL(DST.CompanyName, '''') <> ISNULL(SRC.CompanyName, '''') OR
        ISNULL(DST.Phone, '''') <> ISNULL(SRC.Phone, ''''))
        THEN
            UPDATE SET DST.CompanyName = SRC.CompanyName,
                       DST.Phone = SRC.Phone;';

    EXEC sp_executesql @MergeSQL;
END TRY
BEGIN CATCH
    THROW;
END CATCH;


select * from [ORDERS_RELATIONAL_DB].[dbo].[Shippers]
go
select * from dbo.DimShippers



EXEC [dbo].[DimShippers_SCD1_ETL]
    @SourceTable = '[ORDERS_RELATIONAL_DB].[dbo].[Shippers]',
    @DestinationTable = 'dbo.DimShippers';
