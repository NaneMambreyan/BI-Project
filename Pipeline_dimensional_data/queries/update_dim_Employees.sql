USE ORDERS_DIMENSIONAL_DB;
DROP PROCEDURE IF EXISTS [dbo].[DimEmployees_SCD4_ETL];
GO

CREATE PROCEDURE [dbo].[DimEmployees_SCD4_ETL]
    @SourceTable NVARCHAR(255),
    @DestinationTable NVARCHAR(255),
    @HistoryTable NVARCHAR(255)
AS
BEGIN TRY
    DECLARE @MergeSQL NVARCHAR(MAX);

    SET @MergeSQL = '
        DECLARE @DimEmployees_SCD4 TABLE (
            BusinessKey INT NULL,
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
            PhotoPath NVARCHAR(MAX),
            MergeAction varchar(10) NULL
        );

        MERGE ' + @DestinationTable + ' AS DST
        USING ' + @SourceTable + ' AS SRC
        ON (SRC.EmployeeID = DST.EmployeeID)

        WHEN NOT MATCHED THEN
            INSERT (BusinessKey, LastName, FirstName, Title, TitleOfCourtesy, BirthDate, HireDate, Address, City, Region, PostalCode, Country, HomePhone, Extension, Notes, ReportsTo, PhotoPath)
            VALUES (SRC.EmployeeID, SRC.LastName, SRC.FirstName, SRC.Title, SRC.TitleOfCourtesy, SRC.BirthDate, SRC.HireDate, SRC.Address, SRC.City, SRC.Region, SRC.PostalCode, SRC.Country, SRC.HomePhone, SRC.Extension, SRC.Notes, SRC.ReportsTo, SRC.PhotoPath)

        WHEN MATCHED AND (
            ISNULL(DST.LastName, '''') <> ISNULL(SRC.LastName, '''') OR
            ISNULL(DST.FirstName, '''') <> ISNULL(SRC.FirstName, '''') OR
            ISNULL(DST.Title, '''') <> ISNULL(SRC.Title, '''') OR
            ISNULL(DST.TitleOfCourtesy, '''') <> ISNULL(SRC.TitleOfCourtesy, '''') OR
            ISNULL(DST.BirthDate, '''') <> ISNULL(SRC.BirthDate, '''') OR
            ISNULL(DST.HireDate, '''')) <> ISNULL(SRC.HireDate, '''')) OR
            ISNULL(DST.Address, '''') <> ISNULL(SRC.Address, '''') OR
            ISNULL(DST.City, '''') <> ISNULL(SRC.City, '''') OR
            ISNULL(DST.Region, '''') <> ISNULL(SRC.Region, '''') OR
            ISNULL(DST.PostalCode, '''') <> ISNULL(SRC.PostalCode, '''') OR
            ISNULL(DST.Country, '''') <> ISNULL(SRC.Country, '''') OR
            ISNULL(DST.HomePhone, '''') <> ISNULL(SRC.HomePhone, '''') OR
            ISNULL(DST.Extension, '''') <> ISNULL(SRC.Extension, '''') OR
            ISNULL(DST.Notes, '''') <> ISNULL(SRC.Notes, '''') OR
            ISNULL(DST.ReportsTo, 0) <> ISNULL(SRC.ReportsTo, 0) OR
            ISNULL(DST.PhotoPath, '''') <> ISNULL(SRC.PhotoPath, '''')
        )
        THEN 
            UPDATE
            SET
                DST.LastName = SRC.LastName,
                DST.FirstName = SRC.FirstName,
                DST.Title = SRC.Title,
                DST.TitleOfCourtesy = SRC.TitleOfCourtesy,
                DST.BirthDate = SRC.BirthDate,
                DST.HireDate = SRC.HireDate,
                DST.Address = SRC.Address,
                DST.City = SRC.City,
                DST.Region = SRC.Region,
                DST.PostalCode = SRC.PostalCode,
                DST.Country = SRC.Country,
                DST.HomePhone = SRC.HomePhone,
                DST.Extension = SRC.Extension,
                DST.Notes = SRC.Notes,
                DST.ReportsTo = SRC.ReportsTo,
                DST.PhotoPath = SRC.PhotoPath
            OUTPUT DELETED.BusinessKey, DELETED.LastName, DELETED.FirstName, DELETED.Title, DELETED.TitleOfCourtesy, DELETED.BirthDate, DELETED.HireDate, DELETED.Address, DELETED.City, DELETED.Region, DELETED.PostalCode, DELETED.Country, DELETED.HomePhone, DELETED.Extension, DELETED.Notes, DELETED.ReportsTo, DELETED.PhotoPath, $Action AS MergeAction
            INTO @DimEmployees_SCD4 (BusinessKey, LastName, FirstName, Title, TitleOfCourtesy, BirthDate, HireDate, Address, City, Region, PostalCode, Country, HomePhone, Extension, Notes, ReportsTo, PhotoPath, MergeAction);

        UPDATE TP4
        SET TP4.ValidTo = CONVERT(DATE, GETDATE())
        FROM ' + @HistoryTable + ' TP4
        INNER JOIN @DimEmployees_SCD4 TMP ON TP4.BusinessKey = TMP.BusinessKey
        WHERE TP4.ValidTo IS NULL;

        INSERT INTO ' + @HistoryTable + ' (BusinessKey, LastName, FirstName, Title, TitleOfCourtesy, BirthDate, HireDate, Address, City, Region, PostalCode, Country, HomePhone, Extension, Notes, ReportsTo, PhotoPath,  ValidTo)
        SELECT BusinessKey, LastName, FirstName, Title, TitleOfCourtesy, BirthDate, HireDate, Address, City, Region, PostalCode, Country, HomePhone, Extension, Notes, ReportsTo, PhotoPath,  GETDATE()
        FROM @DimEmployees_SCD4
        WHERE BusinessKey IS NOT NULL;
    ';

    EXEC sp_executesql @MergeSQL;
END TRY
BEGIN CATCH
    THROW;
END CATCH;


EXEC [dbo].[DimEmployees_SCD4_ETL]
    @SourceTable = '[ORDERS_RELATIONAL_DB].[dbo].[Employees]',
    @DestinationTable = 'dbo.DimEmployees',
    @HistoryTable = 'DimEmployees_SCD4_History';



select * from [ORDERS_RELATIONAL_DB].[dbo].Employees


SELECT * FROM DimEmployees;
GO

SELECT * FROM DimEmployees_SCD4_History;
GO
