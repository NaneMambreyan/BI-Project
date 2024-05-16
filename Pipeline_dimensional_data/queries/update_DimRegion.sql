DECLARE @Yesterday VARCHAR(8) = CAST(YEAR(DATEADD(dd,-1,GETDATE())) AS CHAR(4)) + RIGHT('0' + CAST(MONTH(DATEADD(dd,-1,GETDATE())) AS VARCHAR(2)),2) + RIGHT('0' + CAST(DAY(DATEADD(dd,-1,GETDATE())) AS VARCHAR(2)),2)
	 --20210413: string/text/char


	MERGE {db_dim}.{schema_dim}.{table_dim} AS DST
	USING {db_rel}.{schema_rel}.{table_rel} AS SRC
	ON (SRC.RegionID = DST.BusinessKey)

	WHEN NOT MATCHED
	THEN
		INSERT (BusinessKey, RegionDescription)
		VALUES (SRC.RegionID, SRC.RegionDescription) 

	WHEN MATCHED  -- there can be only one matched case
		 AND (	Isnull(DST.RegionDescription, '') <> Isnull(SRC.RegionDescription, '') )  
	THEN 
		UPDATE 
		SET  
			 DST.RegionDescription_prior = (CASE WHEN DST.RegionDescription <> SRC.RegionDescription THEN DST.RegionDescription ELSE DST.RegionDescription_prior END),
			 DST.RegionDescription_prior_ValidTo = (CASE WHEN DST.RegionDescription <> SRC.RegionDescription THEN @Yesterday ELSE DST.RegionDescription_prior_ValidTo END),
			 DST.RegionDescription = SRC.RegionDescription;