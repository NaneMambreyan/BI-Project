USE ORDERS_DIMENSIONAL_DB;

DROP PROCEDURE IF EXISTS [dbo].[DimTerritories_SCD3_ETL];
GO

CREATE PROCEDURE [dbo].[DimTerritories_SCD3_ETL]
    @SourceTable NVARCHAR(255),
    @DestinationTable NVARCHAR(255)
AS
BEGIN TRY
    DECLARE @Yesterday VARCHAR(8) = CONVERT(VARCHAR(8), DATEADD(dd, -1, GETDATE()), 112);
    DECLARE @MergeSQL NVARCHAR(MAX);

    SET @MergeSQL = '
        MERGE ' + @DestinationTable + ' AS DST
        USING ' + @SourceTable + ' AS SRC
        ON (SRC.TerritoryID = DST.BusinessKey)
        
        WHEN NOT MATCHED THEN
            INSERT (BusinessKey, TerritoryDescription, RegionID)
            VALUES (SRC.TerritoryID, SRC.TerritoryDescription, SRC.RegionID) 
            
        WHEN MATCHED AND (ISNULL(DST.TerritoryDescription, '''') <> ISNULL(SRC.TerritoryDescription, ''''))
        THEN 
            UPDATE 
            SET 
                DST.TerritoryDescription_prior = CASE WHEN DST.TerritoryDescription <> SRC.TerritoryDescription THEN DST.TerritoryDescription ELSE DST.TerritoryDescription_prior END,
                DST.TerritoryDescription_prior_ValidTo = CASE WHEN DST.TerritoryDescription <> SRC.TerritoryDescription THEN @Yesterday ELSE DST.TerritoryDescription_prior_ValidTo END,
                DST.TerritoryDescription = SRC.TerritoryDescription,
                DST.RegionID = SRC.RegionID;
    ';

    EXEC sp_executesql @MergeSQL, N'@Yesterday VARCHAR(8)', @Yesterday;
END TRY
BEGIN CATCH
    THROW;
END CATCH;




select * from [ORDERS_RELATIONAL_DB].[dbo].[Territories]
go
select * from dbo.DimTerritories



EXEC [dbo].[DimTerritories_SCD3_ETL]
    @SourceTable = '[ORDERS_RELATIONAL_DB].[dbo].[Territories]',
    @DestinationTable = 'dbo.DimTerritories';
