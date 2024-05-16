 DECLARE @DimSuppliers_SCD4 TABLE (
    BusinessKey INT NULL,
    CompanyName VARCHAR(255),
    ContactName VARCHAR(255),
    ContactTitle VARCHAR(255),
    Address VARCHAR(255),
    City VARCHAR(255),
    Region VARCHAR(255),
    PostalCode VARCHAR(10),
    Country VARCHAR(255),
    Phone VARCHAR(15),
    Fax VARCHAR(15),
    HomePage VARCHAR(255),
    MergeAction varchar(10) NULL
);


    -- Merge statement
    MERGE {db_dim}.{schema_dim}.{table_dim} AS DST
    USING {db_rel}.{schema_rel}.{table_rel} AS SRC
    ON (SRC.SupplierID = DST.SupplierID)

    WHEN NOT MATCHED THEN
    INSERT (BusinessKey, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax, HomePage)
    VALUES (SRC.SupplierID, SRC.CompanyName, SRC.ContactName, SRC.ContactTitle, SRC.Address, SRC.City, SRC.Region, SRC.PostalCode, SRC.Country, SRC.Phone, SRC.Fax, SRC.HomePage)

    WHEN MATCHED AND(
        ISNULL(DST.CompanyName,'') <> ISNULL(SRC.CompanyName,'') OR
        ISNULL(DST.ContactName,'') <> ISNULL(SRC.ContactName,'') OR
        ISNULL(DST.ContactTitle,'') <> ISNULL(SRC.ContactTitle,'') OR
        ISNULL(DST.Address,'') <> ISNULL(SRC.Address,'') OR
        ISNULL(DST.City,'') <> ISNULL(SRC.City,'') OR
        ISNULL(DST.Region,'') <> ISNULL(SRC.Region,'') OR
        ISNULL(DST.PostalCode,'') <> ISNULL(SRC.PostalCode,'') OR
        ISNULL(DST.Country,'') <> ISNULL(SRC.Country,'') OR
        ISNULL(DST.Phone,'') <> ISNULL(SRC.Phone,'') OR
        ISNULL(DST.Fax,'') <> ISNULL(SRC.Fax,'') OR
        ISNULL(DST.HomePage,'') <> ISNULL(SRC.HomePage,''))
    THEN UPDATE
    SET
        DST.CompanyName = SRC.CompanyName,
        DST.ContactName = SRC.ContactName,
        DST.ContactTitle = SRC.ContactTitle,
        DST.Address = SRC.Address,
        DST.City = SRC.City,
        DST.Region = SRC.Region,
        DST.PostalCode = SRC.PostalCode,
        DST.Country = SRC.Country,
        DST.Phone = SRC.Phone,
        DST.Fax = SRC.Fax,
        DST.HomePage = SRC.HomePage
    OUTPUT DELETED.BusinessKey, DELETED.CompanyName, DELETED.ContactName, DELETED.ContactTitle, DELETED.Address, DELETED.City, DELETED.Region, DELETED.PostalCode, DELETED.Country, DELETED.Phone, DELETED.Fax, DELETED.HomePage, $Action AS MergeAction
    INTO @DimSuppliers_SCD4 (BusinessKey, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax, HomePage, MergeAction);

    -- Update history table to set final date and current flag
    UPDATE TP4
    SET TP4.ValidTo = CONVERT(DATE, GETDATE())
    FROM DimSuppliers_SCD4_History TP4
    INNER JOIN @DimSuppliers_SCD4 TMP ON TP4.BusinessKey = TMP.BusinessKey
    WHERE TP4.ValidTo IS NULL;

    -- Add latest history records to history table
    INSERT INTO DimSuppliers_SCD4_History (BusinessKey, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax, HomePage,  ValidTo)
    SELECT BusinessKey, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax, HomePage,  GETDATE()
    FROM @DimSuppliers_SCD4
    WHERE BusinessKey IS NOT NULL;