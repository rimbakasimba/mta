declare @schemaToExtract varchar(100)	--- this is passed as input
set @schemaToExtract = 'StarBucks'


declare @tableToCopy varchar (100)
declare @createScript varchar (8000)

declare curTableCopy cursor for 
	(SELECT name
	FROM sys.tables where SCHEMA_NAME(schema_id) = @schemaToExtract )
open curTableCopy

fetch next from curTableCopy into 	@tableToCopy

while @@FETCH_STATUS != 0
begin 
	
	sp_ScriptTable @tableName = @tableToCopy, @SchemaName = @schemaToExtract
	select 

	SELECT NAME
	FROM sysobjects
	--WHERE id = OBJECT_ID(@SchemaName + '.' + @TableName) 
	WHERE id = OBJECT_ID('Customer')
 WHERE schema_id = SCHEMA_ID('Dominos')
 INFORMATION_SCHEMA.COLUMNS

select top 1.* from sys.foreign_keys_columns ORDER BY object_id DESC
WHERE  SCHEMA_NAME(schema_id) = 'sTARBUCKS'
sys.


---EXECUTE sp_MS_marksystemobject 'sp_ScriptTable' 

declare @createStatement as varchar(8000)
exec sp_ScriptTable @tableName = 'Customer', @SchemaName = 'Base', @createStatement = @createStatement output
print 'hello'
print @createStatement

 
