DECLARE @Yesterday INT =  
		(YEAR(DATEADD(dd, - 1, GETDATE())) * 100000) + 
		(MONTH(DATEADD(dd, - 1, GETDATE())) * 100) + 
		DAY(DATEADD(dd, - 1, GETDATE())) 

		DECLARE @Today INT = 
		(YEAR(GETDATE()) * 10000) + 
		(MONTH(GETDATE()) * 100) + 
		DAY(GETDATE())
		
		

		-- Outer insert - the updated records are added to the SCD2 table
		INSERT INTO {db_dim}.{schema_dim}.{table_dim} (BusinessKey, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax, ValidFrom, IsCurrent) 
		   SELECT CustomerID, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax, @Today, 1 
		   FROM
			  (  -- Merge statement
				 MERGE INTO {db_dim}.{schema_dim}.{table_dim} AS DST 
				 USING {db_rel}.{schema_rel}.{table_rel} AS SRC 
				 ON (SRC.CustomerID = DST.BusinessKey) 	
				 
				 
				 WHEN NOT MATCHED  -- New records have been inserted into src
				 THEN
					INSERT  (BusinessKey, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, Fax, ValidFrom, IsCurrent)  
					VALUES (SRC.CustomerID, SRC.CompanyName, SRC.ContactName, SRC.ContactTitle, SRC.Address, SRC.City, SRC.Region, SRC.PostalCode, SRC.Country, SRC.Phone, SRC.Fax, @Today, 1 )
         

				 WHEN MATCHED AND IsCurrent = 1  -- Existing records have been updated in src
					AND (	Isnull(DST.CompanyName, '') <> Isnull(SRC.CompanyName, '') OR
							Isnull(DST.ContactName, '') <> Isnull(SRC.ContactName, '') OR 
							Isnull(DST.ContactTitle, '') <> Isnull(SRC.ContactTitle, '') OR 
							Isnull(DST.Address, '') <> Isnull(SRC.Address, '') OR
							Isnull(DST.City, '') <> Isnull(SRC.City, '') OR
							Isnull(DST.Region, '') <> Isnull(SRC.Region, '') OR
							Isnull(DST.PostalCode, '') <> Isnull(SRC.PostalCode, '') OR
							Isnull(DST.Country, '') <> Isnull(SRC.Country, '') OR
							Isnull(DST.Phone, '') <> Isnull(SRC.Phone, '') OR
							Isnull(DST.Fax, '') <> Isnull(SRC.Fax, '')  )  
				 THEN UPDATE  -- Update statement for a changed dimension record, to flag as no longer active
				 		SET
				 		DST.IsCurrent = 0, 
				 		DST.ValidTo = @Yesterday 
						OUTPUT SRC.CustomerID, SRC.CompanyName, SRC.ContactName, SRC.ContactTitle, SRC.Address, SRC.City, SRC.Region, SRC.PostalCode, SRC.Country, SRC.Phone, SRC.FAX, $Action AS MergeAction 
						-- outpu = print
	  
	  ) AS MRG 
		WHERE MRG.MergeAction = 'UPDATE' ;