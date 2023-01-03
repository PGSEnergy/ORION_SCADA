SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
GO

/* New columns */
ALTER TABLE [FPN].[IedMapping]
    ADD [Status] [nvarchar](50) COLLATE Latin1_General_CI_AS NOT NULL;
GO

/* Modify columns */
ALTER TABLE [FPN].[DaMapping] ALTER COLUMN PcmLnInst int NULL
GO
ALTER TABLE [FPN].[DaMapping] ALTER COLUMN FpnLnInst int NULL
GO

/* New tables */

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [FPN].[ExcludedDa](
	[ObjectID] [uniqueidentifier] NOT NULL,
	[FpnIedID] [uniqueidentifier] NULL,
	[FpnIedName] [nvarchar](255) NOT NULL,
	[FpnLdInst] [nvarchar](255) NULL,
	[FpnLnID] [uniqueidentifier] NULL,
	[FpnLnPrefix] [nvarchar](4) NULL,
	[FpnLnClass] [nvarchar](11) NULL,
	[FpnLnInst] [int] NULL,
	[FpnDoPath] [nvarchar](255) NULL,
	[FpnDaPath] [nvarchar](255) NULL,
 CONSTRAINT [PK_ExcludedDa] PRIMARY KEY CLUSTERED 
(
	[ObjectID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [FPN].[MappingStatus](
	[IedID] [uniqueidentifier] NOT NULL,
	[LnID] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_MappingStatus_1] PRIMARY KEY CLUSTERED 
(
	[IedID] ASC,
	[LnID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/* 
Create triggers to LogicalNode table, which update the mapping tables when LN is deleted or created
Changes in PCM model/database update the mapping table in FPN database
*/
DECLARE @dbName nvarchar(max)
DECLARE @LnIdColumnName nvarchar(10)
DECLARE @IedIdColumnName nvarchar(10)

IF SUBSTRING(db_name(), 1, 9) = 'SCLDS$PCM'
BEGIN
	SELECT @dbName = '[' + REPLACE(DB_NAME(), 'PCM', 'FPN') + '].'	
	SELECT @LnIdColumnName = 'PcmLnId'
	SELECT @IedIdColumnName = 'PcmIedID'
END
ELSE
BEGIN
	SELECT @dbName = ''
	SELECT @LnIdColumnName = 'FpnLnId'
	SELECT @IedIdColumnName = 'FpnIedID'
END

DECLARE @DELETE_TRIGGER VARCHAR(MAX)
DECLARE @CREATE_TRIGGER VARCHAR(MAX)

SET @DELETE_TRIGGER = 
'CREATE TRIGGER TRG_LogicalNodeDelete ON [IEC61850].[LogicalNode]
AFTER DELETE AS

BEGIN
	UPDATE {DBNAME}[FPN].[DaMapping] SET {COLUMNNAME} = NULL WHERE {COLUMNNAME} in (SELECT ObjectID FROM DELETED)
END'

SET @CREATE_TRIGGER = 
'CREATE TRIGGER TRG_LogicalNodeCreate ON [IEC61850].[LogicalNode]
AFTER INSERT AS

BEGIN
	UPDATE {DBNAME}[FPN].[IedMapping] SET Status = ''Unknown'' WHERE {COLUMNNAME} in (SELECT IedID FROM INSERTED)
END'

DECLARE @SQL_SCRIPT VARCHAR(MAX)

SET @SQL_SCRIPT = REPLACE(@DELETE_TRIGGER, '{DBNAME}', @dbname)
SET @SQL_SCRIPT = REPLACE(@SQL_SCRIPT, '{COLUMNNAME}', @LnIdColumnName)
EXECUTE (@SQL_SCRIPT) 

SET @SQL_SCRIPT = REPLACE(@CREATE_TRIGGER, '{DBNAME}', @dbname)
SET @SQL_SCRIPT = REPLACE(@SQL_SCRIPT, '{COLUMNNAME}', @IedIdColumnName)
EXECUTE (@SQL_SCRIPT)
go

CREATE TRIGGER TRG_DaMappingCreate ON [FPN].[DaMapping]
AFTER INSERT AS

BEGIN
	UPDATE [FPN].[IedMapping] SET Status = 'Unknown' WHERE ObjectID in (SELECT IedMappingId FROM INSERTED)
END
GO 

/* Update the schema version */
UPDATE [IEC61850].[SchemaInformation] SET [Value] =  N'1.3.1.1' WHERE [Key]=N'SchemaVersion'
GO