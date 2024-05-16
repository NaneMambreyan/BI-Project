MERGE {db_dim}.{schema_dim}.{table_dim} AS DST 
USING {db_rel}.{schema_rel}.{table_rel} AS SRC 
ON ( SRC.ShipperID = DST.BusinessKey )
WHEN NOT MATCHED THEN 
  INSERT (BusinessKey, CompanyName, Phone)
  VALUES (SRC.ShipperID,
          SRC.CompanyName,
          SRC.Phone)
WHEN MATCHED AND ( 
	Isnull(DST.CompanyName, '') <> Isnull(SRC.CompanyName, '') OR
	Isnull(DST.Phone, '') <> Isnull(SRC.Phone, '')) 
	THEN
		UPDATE SET DST.CompanyName = SRC.CompanyName,
             DST.Phone = SRC.Phone;

