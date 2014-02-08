use StarBucks 


-- have a schema as xml (just to validate it)
-- the schema will have "null", "type", min,max etc

/*
Step 1: Create XML schema collection

declare @customXsd xml
set @customXsd = '<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema">
     <xsd:element name="Custom">
    <xsd:complexType>
      <xsd:sequence>
        <xsd:element name="Age" nillable="true" type="xsd:int" />	
        <xsd:element name="State" nillable="true" type="xsd:string" />
      </xsd:sequence>
    </xsd:complexType>
  </xsd:element>
   </xsd:schema>'
   
create xml schema collection customerSchema as  @customXsd
*/

/*
Step 2: Create customFields xml(customerSchema) in table through designer
*/

/*
-- Step 3: Create SP for updating customField
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UpdateCustomer]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[UpdateCustomer]

GO

create procedure UpdateCustomer (
	@id uniqueidentifier,
	@Name varchar(100) = null,
	@CustomFields xml = null
	)
as 
---- this will be taken from the credentials and not as any other output field
declare @passphrase varchar(100)
	set @passphrase = 'StarBucksUser'	

declare @validatedField xml (customerSchema)
select @validatedField = @CustomFields

update StarBucks.Customer
	set --Name = EncryptByPassPhrase(@passphrase, ISNULL(@name, ''), 1, convert(varbinary, Id)) ,
		CustomFields = @validatedField
where id = @id

*/


/*
-- Step 4: Update customFields

declare @custId uniqueidentifier
set @custId = 'EE7E73D2-6EFC-4B78-9106-36B70D6F22B8' 
 
 -- before update
 select [iD], [CustomFields]
 from StarBucks.Customer
 where id = @custId
 
 -- update the customFields
exec UpdateCustomer @id = @custId , 
     @CustomFields = '<Custom><Age>10</Age><State>Delhi</State></Custom>'
  
*/




	