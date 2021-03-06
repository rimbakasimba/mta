USE [StarBucks]
GO
BEGIN TRANSACTION
CREATE PARTITION FUNCTION [tenantBasedPartition](uniqueidentifier) AS RANGE LEFT FOR VALUES (N'4c2722a9-c524-4228-85b6-04e115ed6003', N'6e9c919a-a211-415c-9a2a-aab2294c17b2')


CREATE PARTITION SCHEME [tenantPartitionScheme] AS PARTITION [tenantBasedPartition] TO ([starBucks], [dominos], [PRIMARY])


CREATE CLUSTERED INDEX [ClusteredIndex_on_tenantPartitionScheme_635260968804188157] ON [dbo].[AllCustomers] 
(
	[tenantId]
)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [tenantPartitionScheme]([tenantId])


DROP INDEX [ClusteredIndex_on_tenantPartitionScheme_635260968804188157] ON [dbo].[AllCustomers] WITH ( ONLINE = OFF )




COMMIT TRANSACTION


