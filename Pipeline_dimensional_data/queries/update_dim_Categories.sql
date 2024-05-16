USE ORDERS_DIMENSIONAL_DB;
DROP PROCEDURE IF EXISTS [dbo].[DimCategories_SCD1_ETL]
GO



CREATE PROCEDURE [dbo].[DimCategories_SCD1_ETL]
    @SourceTable NVARCHAR(255),
    @DestinationTable NVARCHAR(255)
AS
BEGIN TRY
    DECLARE @MergeSQL NVARCHAR(MAX);

    SET @MergeSQL = '
    MERGE ' + @DestinationTable + ' AS DST 
    USING ' + @SourceTable + ' AS SRC 
    ON (SRC.CategoryID = DST.BusinessKey)
    WHEN NOT MATCHED THEN 
        INSERT (BusinessKey, CategoryName, Description)
        VALUES (SRC.CategoryID,
                SRC.CategoryName,
                SRC.Description)
    WHEN MATCHED AND (
        ISNULL(DST.CategoryName, '''') <> ISNULL(SRC.CategoryName, '''') OR
        ISNULL(DST.Description, '''') <> ISNULL(SRC.Description, ''''))
        THEN
            UPDATE SET DST.CategoryName = SRC.CategoryName,
                       DST.Description = SRC.Description
    WHEN NOT MATCHED BY SOURCE THEN
        DELETE;';

    EXEC sp_executesql @MergeSQL;
END TRY
BEGIN CATCH
    THROW;
END CATCH;

