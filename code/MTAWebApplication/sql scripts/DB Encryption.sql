use starbucks 
/*
alter table [StarBucks].[Customer]
	add Name varbinary(100)	
*/	

/* 
insert into [StarBucks].[Customer] (Id, cardTypeId, createdOn, updatedOn, createdBy, updatedBy)
values (newid(), 1, GETDATE(), GETDATE(), 13434, 13434 )
*/	
	declare @passphrase varchar(100)
set @passphrase = 'StarBucksUser'		-- this will have guid of tenant
declare @Name varchar(20)
set @Name = 'John Doe'
declare @id uniqueidentifier
set @id  = 'EE7E73D2-6EFC-4B78-9106-36B70D6F22B8'
/* 
-- Step 1: Update
update [StarBucks].[Customer]
	set Name = EncryptByPassPhrase(@passphrase, @Name, 1, convert(varbinary, id)) 
where id = @id
 */		
 
 /*
 -- Step 2: Read 'Encrypted' value
select id, Name from  [StarBucks].[Customer] 
where id = @id
*/

 /*
-- Step 3: Read 'Decrypted' value
select id, convert(varchar, 
	DecryptByPassPhrase (@passphrase, Name, 1, convert(varbinary, Id)) ) as DecryptedName
from [StarBucks].[Customer] 
where id =  @id
 
*/