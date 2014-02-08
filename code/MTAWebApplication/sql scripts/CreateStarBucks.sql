use StarBucks
exec sp_grantdbaccess @loginame = 'StarBucksUser', @name_in_db = 'StarBucks' 
go  
 CREATE TABLE StarBucks.StarBucks.Customer  (  id UNIQUEIDENTIFIER NOT NULL ,  cardTypeId INT NOT NULL ,  someMetaTag VARCHAR(100) NULL ,  currentBalance FLOAT NULL ,  createdOn DATETIME NOT NULL ,  updatedOn DATETIME NOT NULL ,  createdBy INT NOT NULL ,  updatedBy INT NOT NULL   ,CONSTRAINT PK__Customer__3213E83F1920BF5C PRIMARY KEY  CLUSTERED (id ASC)  )      -- =============================================
go
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE StarBucks.CreateCustomer (
	@CardTypeId int,
	@CurrentBalanceAmount float,
	@UserId uniqueidentifier output
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
set @UserId = NEWID()
 
insert into Customer (id, cardTypeid, currentBalance, createdon, createdBy, updatedOn, updatedBy) values 
(@UserId, @CardTypeId, @CurrentBalanceAmount, getdate(), SUSER_ID(), getdate(), SUSER_ID())
 

END

go 
  -- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE StarBucks.[UpdateCurrentBalance] (
	@UserId uniqueidentifier,
	@AddAmount float
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   update Customer set currentBalance = currentBalance + @addamount,
   updatedOn = GETDATE(),
   updatedBy =  SUSER_SID()
   where id = @UserId
END

go
  -- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE StarBucks.[GetCurrentBalance] (
	@UserId uniqueidentifier 
	)
AS
BEGIN 

   select currentBalance from Customer
   where id = @UserId
END
