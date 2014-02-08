use MultiTenentPOC
go
declare @cName varchar (20)
set @cName = 'StarBucks' 
declare @destinationDB sysname
set @destinationDB = 'StarBucks'
declare @UCopy bit
set @UCopy = 1
declare @script varchar(8000)

exec MigrateSchema @clientName = @cName, 
		@UsersCopy = @UCopy,  
		@destinationDB = @destinationDB, 
		@scriptToRun = @script output
print @script


---EXECUTE sp_MS_marksystemobject 'sp_ScriptTable' 