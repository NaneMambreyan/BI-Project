USE ORDERS_DIMENSIONAL_DB;

DROP PROCEDURE IF EXISTS [dbo].[DimCustomers_SCD2_ETL];
GO

CREATE PROCEDURE [dbo].[DimCustomers_SCD2_ETL]
    @SourceTable NVARCHAR(255),
    @DestinationTable NVARCHAR(255)
AS
BEGIN TRY
    DECLARE @Yesterday INT =  CONVERT(INT, CONVERT(VARCHAR(8), DATEADD(dd, - 1, GETDATE()), 112));
    DECLARE @Today INT = CONVERT(INT, CONVERT(VARCHAR(8), GETDATE(), 112));
    DECLARE @MergeSQL NVARCHAR(MAX);

    SET @MergeSQL = '
        INSERT INTO ' + @DestinationTable + ' (BusinessKey, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax, ValidFrom, IsCurrent) 
        SELECT CustomerID, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax, @Today, 1 
        FROM
        (
            MERGE INTO ' + @DestinationTable + ' AS DST 
            USING ' + @SourceTable + ' AS SRC 
            ON (SRC.CustomerID = DST.BusinessKey) 	
            
            WHEN NOT MATCHED THEN
                INSERT (BusinessKey, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax, ValidFrom, IsCurrent)  
                VALUES (SRC.CustomerID, SRC.CompanyName, SRC.ContactName, SRC.ContactTitle, SRC.Address, SRC.City, SRC.Region, SRC.PostalCode, SRC.Country, SRC.Phone, SRC.Fax, @Today, 1)
         
            WHEN MATCHED AND DST.IsCurrent = 1 
                AND (
                    ISNULL(DST.CompanyName, '''') <> ISNULL(SRC.CompanyName, '''') OR
                    ISNULL(DST.ContactName, '''') <> ISNULL(SRC.ContactName, '''') OR 
                    ISNULL(DST.ContactTitle, '''') <> ISNULL(SRC.ContactTitle, '''') OR 
                    ISNULL(DST.Address, '''') <> ISNULL(SRC.Address, '''') OR
                    ISNULL(DST.City, '''') <> ISNULL(SRC.City, '''') OR
                    ISNULL(DST.Region, '''') <> ISNULL(SRC.Region, '''') OR
                    ISNULL(DST.PostalCode, '''') <> ISNULL(SRC.PostalCode, '''') OR
                    ISNULL(DST.Country, '''') <> ISNULL(SRC.Country, '''') OR
                    ISNULL(DST.Phone, '''') <> ISNULL(SRC.Phone, '''') OR
                    ISNULL(DST.Fax, '''') <> ISNULL(SRC.Fax, '''')
                )
            THEN
                UPDATE 
                SET DST.IsCurrent = 0, 
                    DST.ValidTo = @Yesterday 
                OUTPUT SRC.CustomerID, SRC.CompanyName, SRC.ContactName, SRC.ContactTitle, SRC.Address, SRC.City, SRC.Region, SRC.PostalCode, SRC.Country, SRC.Phone, SRC.FAX, $Action AS MergeAction;
        ) AS MRG 
        WHERE MRG.MergeAction = "UPDATE";';

    EXEC sp_executesql @MergeSQL, N'@Today INT, @Yesterday INT', @Today, @Yesterday;
END TRY
BEGIN CATCH
    THROW;
END CATCH;




select * from [ORDERS_RELATIONAL_DB].[dbo].[Customers]
go
select * from dbo.DimCustomers



EXEC [dbo].[DimCustomers_SCD2_ETL]
    @SourceTable = '[ORDERS_RELATIONAL_DB].[dbo].[Customers]',
    @DestinationTable = 'dbo.DimCustomers';
