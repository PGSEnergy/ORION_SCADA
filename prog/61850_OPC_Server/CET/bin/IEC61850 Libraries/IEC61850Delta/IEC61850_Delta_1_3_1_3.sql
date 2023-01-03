SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
GO

CREATE TABLE [IEC61850].[UnsupportedMustUnderstandElement](
	[ObjectID] [uniqueidentifier] NOT NULL,
	[IedID] [uniqueidentifier] NULL,
	[ParentID] [uniqueidentifier] NOT NULL,	
	[OrderIndex] [int] NOT NULL,
	[Content] [nvarchar](max) NOT NULL,
	[ElementToken] [nvarchar](max) NOT NULL,
	CONSTRAINT [PK_UnsupportedMustUnderstandElement] PRIMARY KEY CLUSTERED 
(	
	[ObjectID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE TABLE [IEC61850].[UnsupportedMustUnderstandElementForInstanceData](
	[ObjectID] [uniqueidentifier] NOT NULL,
	[IedID] [uniqueidentifier] NULL,
	[LogicalNodeID] [uniqueidentifier] NOT NULL,	
	[OrderIndex] [int] NOT NULL,
	[Content] [nvarchar](max) NOT NULL,
	[ElementToken] [nvarchar](max) NOT NULL,
	[Path] [nvarchar](255) NOT NULL,
	CONSTRAINT [PK_UnsupportedMustUnderstandElementForInstanceData] PRIMARY KEY CLUSTERED 
(	
	[ObjectID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
	
/* Modify columns */
ALTER TABLE [FPN].[DaMapping] ALTER COLUMN 	[PcmDoPath] [nvarchar](255)  COLLATE Latin1_General_CS_AS NULL
GO
ALTER TABLE [FPN].[DaMapping] ALTER COLUMN 	[PcmDaPath] [nvarchar](255)  COLLATE Latin1_General_CS_AS NULL
GO
ALTER TABLE [FPN].[DaMapping] ALTER COLUMN 	[FpnDoPath] [nvarchar](255)  COLLATE Latin1_General_CS_AS NULL
GO
ALTER TABLE [FPN].[DaMapping] ALTER COLUMN 	[FpnDaPath] [nvarchar](255)  COLLATE Latin1_General_CS_AS NULL
GO

ALTER TABLE [FPN].[ExcludedDa] ALTER COLUMN [FpnIedName] [nvarchar](255)  COLLATE Latin1_General_CI_AS NOT NULL
GO
ALTER TABLE [FPN].[ExcludedDa] ALTER COLUMN [FpnLdInst] [nvarchar](255)  COLLATE Latin1_General_CI_AS NULL
GO
ALTER TABLE [FPN].[ExcludedDa] ALTER COLUMN [FpnLnPrefix] [nvarchar](4)   COLLATE Latin1_General_CI_AS NULL
GO
ALTER TABLE [FPN].[ExcludedDa] ALTER COLUMN [FpnLnClass] [nvarchar](11)  COLLATE Latin1_General_CI_AS NULL
GO
ALTER TABLE [FPN].[ExcludedDa] ALTER COLUMN [FpnDoPath] [nvarchar](255)  COLLATE Latin1_General_CS_AS NULL
GO
ALTER TABLE [FPN].[ExcludedDa] ALTER COLUMN [FpnDaPath] [nvarchar](255)  COLLATE Latin1_General_CS_AS NULL
GO

DECLARE @CreateTrigger VARCHAR(MAX)
SET @CreateTrigger =
'CREATE TRIGGER TRG_ExcludedDa ON [FPN].[ExcludedDa]
AFTER INSERT, DELETE AS
BEGIN	
	UPDATE [FPN].[IedMapping] SET Status = ''Unknown'' WHERE FpnIedName in (SELECT FpnIedName FROM DELETED)
	UPDATE [FPN].[IedMapping] SET Status = ''Unknown'' WHERE FpnIedName in (SELECT FpnIedName FROM INSERTED)
	DELETE FROM [FPN].[MappingStatus] WHERE LnID in (SELECT FpnLnID FROM DELETED)
END'

EXECUTE (@CreateTrigger)
GO

/* Update the schema version */
UPDATE [IEC61850].[SchemaInformation] SET [Value] =  N'1.3.1.3' WHERE [Key]=N'SchemaVersion'

GO