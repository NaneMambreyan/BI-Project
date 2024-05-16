  DECLARE @Yesterday VARCHAR(8) = CAST(YEAR(DATEADD(dd,-1,GETDATE())) AS CHAR(4)) + RIGHT('0' + CAST(MONTH(DATEADD(dd,-1,GETDATE())) AS VARCHAR(2)),2) + RIGHT('0' + CAST(DAY(DATEADD(dd,-1,GETDATE())) AS VARCHAR(2)),2);

    MERGE {db_dim}.{schema_dim}.{table_dim} AS DST
    USING {db_rel}.{schema_rel}.{table_rel} AS SRC
    ON (SRC.TerritoryID = DST.BusinessKey)

    WHEN NOT MATCHED
    THEN
        INSERT (BusinessKey, TerritoryDescription, RegionID)
        VALUES (SRC.TerritoryID, SRC.TerritoryDescription, SRC.RegionID) 

    WHEN MATCHED  
         AND (    ISNULL(DST.TerritoryDescription, '') <> ISNULL(SRC.TerritoryDescription, '') )  
    THEN 
        UPDATE 
        SET  
             DST.TerritoryDescription_prior = (CASE WHEN DST.TerritoryDescription <> SRC.TerritoryDescription THEN DST.TerritoryDescription ELSE DST.TerritoryDescription_prior END),
             DST.TerritoryDescription_prior_ValidTo = (CASE WHEN DST.TerritoryDescription <> SRC.TerritoryDescription THEN @Yesterday ELSE DST.TerritoryDescription_prior_ValidTo END),
             DST.TerritoryDescription = SRC.TerritoryDescription,
             DST.RegionID = SRC.RegionID;