declare @CurrentDb varchar(200); 
set @CurrentDb = (SELECT DB_NAME() AS [Current Database]); 

--work

SELECT 
		TableInfo.TABLE_CATALOG as 'DatabaseName'
		,TableInfo.TABLE_NAME as 'TableName'
		,TableInfo.TABLE_TYPE as 'TableType'
		,TableInfo.TABLE_TYPE as 'TableSchema'
		, 
		(
			SELECT 
			ColumnInfo.COLUMN_NAME as 'ColumnName'
			,ColumnInfo.ORDINAL_POSITION as 'OrdinalPosition'
			,ColumnInfo.COLUMN_DEFAULT as 'ColumnDefault'
			,ColumnInfo.IS_NULLABLE as 'IsNullable'
			,ColumnInfo.DATA_TYPE as 'DataType'
			,ColumnInfo.NUMERIC_PRECISION as 'NumericPrecision'
			,ColumnInfo.NUMERIC_PRECISION_RADIX as 'NumericPrecisionRadix'
			,ColumnInfo.NUMERIC_SCALE as 'NumericScale'
			,ColumnInfo.CHARACTER_MAXIMUM_LENGTH as 'CharacterMax'
			,ColumnInfo.CHARACTER_OCTET_LENGTH as 'CharacterOctetMax'
			,ColumnInfo.CHARACTER_SET_NAME as 'CharacterSetName'
			,ColumnInfo.COLLATION_NAME as 'CollationName'

			FROM 
				INFORMATION_SCHEMA.COLUMNS as ColumnInfo
			WHERE 
				ColumnInfo.TABLE_CATALOG = @CurrentDb
				and ColumnInfo.TABLE_NAME = TableInfo.TABLE_NAME 
				and ColumnInfo.TABLE_SCHEMA = TABLE_SCHEMA 
			for xml auto, type, ELEMENTS  
		)  as ColumnList
		,(
			SELECT 
			KeyColumnInfo.CONSTRAINT_NAME as 'ConstraintName'
			,KeyColumnInfo.CONSTRAINT_SCHEMA as 'ConstraintSchema'
			,KeyColumnInfo.TABLE_NAME as 'TableName'
			,KeyColumnInfo.COLUMN_NAME as 'ColumnName'
			,(
				SELECT 
				ReferenceInfo.CONSTRAINT_NAME as 'ConstraintName'
				,ReferenceInfo.CONSTRAINT_SCHEMA as 'ConstraintSchema'
				,ReferenceInfo.UNIQUE_CONSTRAINT_Name as 'UniqueConstraintName'
				,ReferenceInfo.UNIQUE_CONSTRAINT_SCHEMA as 'UniqueConstraintSchema'
				,(	SELECT 
						ReferanceKeyColumnInfo.CONSTRAINT_NAME as 'ConstraintName'
						,ReferanceKeyColumnInfo.CONSTRAINT_SCHEMA as 'ConstraintSchema'
						,ReferanceKeyColumnInfo.TABLE_NAME as 'TableName'
						,ReferanceKeyColumnInfo.COLUMN_NAME as 'ColumnName'
					FROM 
						INFORMATION_SCHEMA.KEY_COLUMN_USAGE as ReferanceKeyColumnInfo
					WHERE 
							ReferanceKeyColumnInfo.TABLE_CATALOG = @CurrentDb 
							and ReferanceKeyColumnInfo.CONSTRAINT_NAME = ReferenceInfo.UNIQUE_CONSTRAINT_Name 
							and ReferanceKeyColumnInfo.CONSTRAINT_SCHEMA = ReferenceInfo.CONSTRAINT_SCHEMA 
					for xml auto, type, ELEMENTS  
					) as  ReferanceKeyColumnList
				FROM 
					INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS as ReferenceInfo
				WHERE 
					ReferenceInfo.CONSTRAINT_CATALOG = @CurrentDb 
					and ReferenceInfo.CONSTRAINT_NAME = KeyColumnInfo.CONSTRAINT_NAME 
					and ReferenceInfo.CONSTRAINT_SCHEMA = KeyColumnInfo.CONSTRAINT_SCHEMA 
				for xml auto, type, ELEMENTS  
			)  as RefferanceList
			FROM 
				INFORMATION_SCHEMA.KEY_COLUMN_USAGE as KeyColumnInfo
			WHERE 
				KeyColumnInfo.TABLE_CATALOG = @CurrentDb 
				and KeyColumnInfo.TABLE_NAME = TableInfo.TABLE_NAME 
				and KeyColumnInfo.TABLE_SCHEMA = TABLE_SCHEMA 
			for xml auto, type, ELEMENTS  
		)  as KeyColumnList
		
		FROM 
			INFORMATION_SCHEMA.TABLES as TableInfo
		WHERE 
			TableInfo.TABLE_CATALOG = @CurrentDb 
			for xml auto, ELEMENTS, ROOT('TableList') 