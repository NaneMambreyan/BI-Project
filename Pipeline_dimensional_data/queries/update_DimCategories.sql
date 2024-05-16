MERGE {db_dim}.{schema_dim}.{table_dim} AS DST 
USING {db_rel}.{schema_rel}.{table_rel} AS SRC 
ON ( SRC.CategoryID = DST.BusinessKey )
WHEN NOT MATCHED THEN 
    INSERT (BusinessKey, CategoryName, Description)
    VALUES (SRC.CategoryID, SRC.CategoryName, SRC.Description)
WHEN MATCHED AND ( 
    Isnull(DST.CategoryName, '') <> Isnull(SRC.CategoryName, '') OR
    Isnull(DST.Description, '') <> Isnull(SRC.Description, '')) 
    THEN
        UPDATE SET DST.CategoryName = SRC.CategoryName,
                    DST.Description = SRC.Description
WHEN NOT MATCHED BY SOURCE THEN
        DELETE;

