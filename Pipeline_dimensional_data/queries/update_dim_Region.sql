USE ORDERS_DIMENSIONAL_DB;
DROP PROCEDURE IF EXISTS [dbo].[DimRegion_SCD3_ETL];
GO

CREATE PROCEDURE [dbo].[DimRegion_SCD3_ETL]
    @SourceTable NVARCHAR(255),
    @DestinationTable NVARCHAR(255)
AS
BEGIN TRY
    DECLARE @Yesterday VARCHAR(8) = CONVERT(VARCHAR(8), DATEADD(dd, -1, GETDATE()), 112);
    DECLARE @MergeSQL NVARCHAR(MAX);

    SET @MergeSQL = '
        MERGE ' + @DestinationTable + ' AS DST
        USING ' + @SourceTable + ' AS SRC
        ON (SRC.RegionID = DST.BusinessKey)
        
        WHEN NOT MATCHED THEN
            INSERT (BusinessKey, RegionDescription)
            VALUES (SRC.RegionID, SRC.RegionDescription) 
            
        WHEN MATCHED AND (ISNULL(DST.RegionDescription, '''') <> ISNULL(SRC.RegionDescription, ''''))
        THEN 
            UPDATE 
            SET 
                DST.RegionDescription_prior = CASE WHEN DST.RegionDescription <> SRC.RegionDescription THEN DST.RegionDescription ELSE DST.RegionDescription_prior END,
                DST.RegionDescription_prior_ValidTo = CASE WHEN DST.RegionDescription <> SRC.RegionDescription THEN @Yesterday ELSE DST.RegionDescription_prior_ValidTo END,
                DST.RegionDescription = SRC.RegionDescription;
    ';

    EXEC sp_executesql @MergeSQL, N'@Yesterday VARCHAR(8)', @Yesterday;
END TRY
BEGIN CATCH
    THROW;
END CATCH;





select * from [ORDERS_RELATIONAL_DB].[dbo].[Region]
go
select * from dbo.DimRegion



EXEC [dbo].[DimRegion_SCD3_ETL]
    @SourceTable = '[ORDERS_RELATIONAL_DB].[dbo].[Region]',
    @DestinationTable = 'dbo.DimRegion';
