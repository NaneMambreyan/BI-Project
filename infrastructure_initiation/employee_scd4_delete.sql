


CREATE TABLE Employees (
    EmployeeID INT NOT NULL,
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
    PhotoPath NVARCHAR(MAX)
);
--------------------------------------- DimEmployees SCD4 with delete -------------------------------------
DROP TABLE IF EXISTS DimEmployees;
GO


CREATE TABLE DimEmployees (
    EmployeeID INT IDENTITY(1,1) NOT NULL,
    BusinessKey INT NOT NULL,
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
        PRIMARY KEY(EmployeeID)
);
GO

DROP TABLE IF EXISTS DimEmployees_SCD4_History;
GO


CREATE TABLE DimEmployees_SCD4_History (
    HistoryID INT IDENTITY(1,1) NOT NULL,
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
    ValidTo DATETIME NULL,
        PRIMARY KEY (HistoryID)
);


DROP PROCEDURE IF EXISTS [dbo].[DimEmployees_SCD4_ETL];
GO


CREATE PROCEDURE [dbo].[DimEmployees_SCD4_ETL]
AS  
BEGIN
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


    -- Merge statement
    MERGE DimEmployees AS DST
    USING [ORDERS_RELATIONAL_DB].[dbo].[Employees] AS SRC
    ON (SRC.EmployeeID = DST.EmployeeID)

    WHEN NOT MATCHED THEN
    INSERT (BusinessKey, LastName, FirstName, Title, TitleOfCourtesy, BirthDate, HireDate, Address, City, Region, PostalCode, Country, HomePhone, Extension, Notes, ReportsTo, PhotoPath)
    VALUES (SRC.EmployeeID, SRC.LastName, SRC.FirstName, SRC.Title, SRC.TitleOfCourtesy, SRC.BirthDate, SRC.HireDate, SRC.Address, SRC.City, SRC.Region, SRC.PostalCode, SRC.Country, SRC.HomePhone, SRC.Extension, SRC.Notes, SRC.ReportsTo, SRC.PhotoPath
)

    WHEN MATCHED AND(
        ISNULL(DST.LastName,'') <> ISNULL(SRC.LastName,'') OR
        ISNULL(DST.FirstName,'') <> ISNULL(SRC.FirstName,'') OR
        ISNULL(DST.Title,'') <> ISNULL(SRC.Title,'') OR
        ISNULL(DST.TitleOfCourtesy,'') <> ISNULL(SRC.TitleOfCourtesy,'') OR
        ISNULL(DST.BirthDate,'') <> ISNULL(SRC.BirthDate,'') OR
        ISNULL(DST.HireDate,'') <> ISNULL(SRC.HireDate,'') OR
        ISNULL(DST.Address,'') <> ISNULL(SRC.Address,'') OR
        ISNULL(DST.City,'') <> ISNULL(SRC.City,'') OR
        ISNULL(DST.Region,'') <> ISNULL(SRC.Region,'') OR
        ISNULL(DST.PostalCode,'') <> ISNULL(SRC.PostalCode,'') OR
        ISNULL(DST.Country,'') <> ISNULL(SRC.Country,'') OR
        ISNULL(DST.HomePhone,'') <> ISNULL(SRC.HomePhone,'') OR
        ISNULL(DST.Extension,'') <> ISNULL(SRC.Extension,'') OR
        ISNULL(DST.Notes,'') <> ISNULL(SRC.Notes,'') OR
        ISNULL(DST.ReportsTo,'') <> ISNULL(SRC.ReportsTo,'') OR
        ISNULL(DST.PhotoPath,'') <> ISNULL(SRC.PhotoPath,'') )
    THEN UPDATE
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
    OUTPUT DELETED.BusinessKey,DELETED.LastName, DELETED.FirstName, DELETED.Title, DELETED.TitleOfCourtesy, DELETED.BirthDate, DELETED.HireDate, DELETED.Address, DELETED.City, DELETED.Region, DELETED.PostalCode, DELETED.Country, DELETED.HomePhone, DELETED.Extension, DELETED.Notes, DELETED.ReportsTo, DELETED.PhotoPath, $Action AS MergeAction
    INTO @DimEmployees_SCD4 (BusinessKey, LastName, FirstName, Title, TitleOfCourtesy, BirthDate, HireDate, Address, City, Region, PostalCode, Country, HomePhone, Extension, Notes, ReportsTo, PhotoPath, MergeAction);

    -- Update history table to set final date and current flag
    UPDATE TP4
    SET TP4.ValidTo = CONVERT(DATE, GETDATE())
    FROM DimEmployees_SCD4_History TP4
    INNER JOIN @DimEmployees_SCD4 TMP ON TP4.BusinessKey = TMP.BusinessKey
    WHERE TP4.ValidTo IS NULL;

    -- Add latest history records to history table
    INSERT INTO DimEmployees_SCD4_History (BusinessKey, LastName, FirstName, Title, TitleOfCourtesy, BirthDate, HireDate, Address, City, Region, PostalCode, Country, HomePhone, Extension, Notes, ReportsTo, PhotoPath,  ValidTo)
    SELECT BusinessKey, LastName, FirstName, Title, TitleOfCourtesy, BirthDate, HireDate, Address, City, Region, PostalCode, Country, HomePhone, Extension, Notes, ReportsTo, PhotoPath,  GETDATE()
    FROM @DimEmployees_SCD4
    WHERE BusinessKey IS NOT NULL;
END;








select * from [ORDERS_RELATIONAL_DB].[dbo].Employees


-- Test Scenario 1: Empty Destination
SELECT * FROM DimEmployees;
GO

SELECT * FROM DimEmployees_SCD4_History;
GO

EXEC [dbo].[DimEmployees_SCD4_ETL];
GO

SELECT * FROM DimEmployees;
GO

SELECT * FROM DimEmployees_SCD4_History;
GO




-- Test scenario 2: New rows in the source table
select * from [ORDERS_RELATIONAL_DB].[dbo].Employees

INSERT INTO [ORDERS_RELATIONAL_DB].[dbo].[Employees] (EmployeeID, LastName, FirstName, Title, TitleOfCourtesy, BirthDate, HireDate, Address, City, Region, PostalCode, Country, HomePhone, Extension, Notes, ReportsTo, PhotoPath)
VALUES (10, 'Nane', 'Mambreyan', 'Manager', 'Mr.', '1990-01-01', '2020-01-01', '123 Main St', 'Anytown', 'Anyregion', '12345', 'USA', '555-1234', '123', 'Some notes', NULL, NULL);

EXEC DimEmployees_SCD4_ETL;
GO

SELECT * FROM DimEmployees;
GO

SELECT * FROM DimEmployees_SCD4_History;
GO





-- Test Scenario3: After first Update 
UPDATE [ORDERS_RELATIONAL_DB].[dbo].[Employees]
SET ProductName = 'UPDATE1'
WHERE EmployeeID = 78;
GO

EXEC DimEmployees_SCD4_ETL;
GO

SELECT * FROM DimEmployees;
GO

SELECT * FROM DimEmployees_SCD4_History;
GO


-- Test Scenario 4: After second Update 
UPDATE [ORDERS_RELATIONAL_DB].[dbo].[Employees]
SET ProductName = 'UPDATE2'
WHERE EmployeeID = 78;
GO


EXEC DimEmployees_SCD4_ETL;
GO

SELECT * FROM DimEmployees;
GO

SELECT * FROM DimEmployees_SCD4_History;
GO















-- Test Scenario 5: After second Update 
DELETE FROM [ORDERS_RELATIONAL_DB].[dbo].[Suppliers]
WHERE SupplierID = 1;


EXEC DimEmployees_SCD4_ETL;
GO

SELECT * FROM DimEmployees;
GO

SELECT * FROM DimEmployees_SCD4_History;
GO