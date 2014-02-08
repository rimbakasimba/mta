USE [MultiTenentPOC]
GO

/****** Object:  StoredProcedure [dbo].[MigrateSchema]    Script Date: 01/20/2014 15:56:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- returns a script to be run for migrating all objects owned by the given schema to somewhere else
CREATE procedure [dbo].[MigrateSchema]
(  @clientName varchar(20),
	@UsersCopy bit,
	@destinationDB sysname,
   @scriptToRun varchar(8000) output   
 )
as
begin

declare @schemaToExtract varchar(20)
set @schemaToExtract = @clientName

-- 1. Check if this schema actually exists
IF EXISTS(SELECT name FROM sys.schemas WHERE name = @schemaToExtract)
  BEGIN
  
	--print 'schema exists, proceeding'
	
	declare @tableToCopy varchar (100)
	declare @currTableScript varchar (1000)
	
	set @scriptToRun = ''		-- initialize to prevent null 

--- 2. Copy tables
	declare curTableCopy cursor 
		local FAST_FORWARD read_only 
		for 
			(SELECT name
			FROM sys.tables where SCHEMA_NAME(schema_id) = @schemaToExtract )
			
	open curTableCopy

	fetch next from curTableCopy into 	@tableToCopy
	
	while @@FETCH_STATUS = 0
	begin 
		--print 'got table: ' + @tableToCopy
		
		exec sp_ScriptTable @tableName = @tableToCopy, 
							@SchemaName = @schemaToExtract, 
							@DestinationDBName = @destinationDB,
							@createStatement = @currTableScript output
		--- print @scriptToRun
		set @scriptToRun = @currTableScript + '; go; ' + @scriptToRun
		fetch next from curTableCopy into 	@tableToCopy
	end	-- end of cursor
	
	close curTableCopy
	deallocate curTableCopy
	
--- 3. Copy users	
	if (@UsersCopy = 1)
	begin
		declare @newClientLogin	varchar(25)
		--- as per defaults, the userName is 'ClientName' + User
		 set @newClientLogin = @clientName + 'User'
		 -- VALIDATE LOGIN NAME:  
		declare @isLoginValid int
		execute @isLoginValid = sys.sp_validname @newClientLogin
		if (@isLoginValid  <> 0)  return
	 
		set @scriptToRun = 'exec sp_grantdbaccess @loginame = ''' + @newClientLogin 
											+ ''', @name_in_db = ''' + @clientName
											+ '''; go; ' + @scriptToRun
  
	end
	
--- 4. Copy stored procedures
declare @spName varchar(100), @spText varchar(8000)
declare spCursor cursor 
		local FAST_FORWARD read_only
for
	(SELECT 
		pr.name , mod.definition as FinalSP
	FROM sys.procedures pr
		INNER JOIN sys.sql_modules mod ON pr.object_id = mod.object_id
	WHERE pr.Is_MS_Shipped = 0 and SCHEMA_NAME(schema_id) = @schemaToExtract)

open spCursor

	fetch next from spCursor into @spName, @spText
	WHILE @@FETCH_STATUS = 0
		begin
			--print 'Create SP ' + @spName 
			set @scriptToRun = @scriptToRun + ' go; ' + @spText
						--REPLACE(REPLACE(REPLACE(@spText, CHAR(9), '  '), CHAR(10), '  '), CHAR(13), '  ')
			fetch next from spCursor into @spName, @spText
		end
close spCursor
deallocate spCursor
	
	-- print @scriptToRun
end

else
	print 'Schema does not exists'  
	
	
 end
 


GO


