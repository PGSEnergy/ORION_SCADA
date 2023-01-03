SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
GO

/* New tables */

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [IEC61850].[SubEquipment](
	[ObjectID] [uniqueidentifier] NOT NULL,
	[ParentID] [uniqueidentifier] NOT NULL,
	[ParentType] [nvarchar](255) COLLATE Latin1_General_CI_AS NOT NULL,
	[Name] [nvarchar](255) COLLATE Latin1_General_CI_AS NOT NULL,
	[Description] [nvarchar](4000) COLLATE Latin1_General_CI_AS NULL,	
	[OrderIndex] [int] NOT NULL,	
	[IsVirtual] [bit] NOT NULL,
	[Phase] [nvarchar](10) COLLATE Latin1_General_CI_AS NOT NULL,	
 CONSTRAINT [PK_SubEquipment] PRIMARY KEY CLUSTERED 
(
	[ObjectID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


/* New columns */
ALTER TABLE [IEC61850].[ConnectedAccessPoint]
    ADD [RedProt] [nvarchar](10) COLLATE Latin1_General_CI_AS NULL;
GO

ALTER TABLE [IEC61850].[VoltageLevel]	
	ADD [NomFreq] [float] NULL,
		[NumPhases] [int] NULL;
GO

/* Disable PCM db triggers if FPN db not found */
IF (SUBSTRING(db_name(), 1, 9) = 'SCLDS$PCM' AND db_id(REPLACE(db_name(), 'PCM', 'FPN')) IS NULL)
BEGIN
	ALTER TABLE [IEC61850].[LogicalNode] DISABLE TRIGGER TRG_LogicalNodeCreate
	ALTER TABLE [IEC61850].[LogicalNode] DISABLE TRIGGER TRG_LogicalNodeDelete
END	
GO

CREATE TRIGGER [TRG_DaMappingDelete] ON [FPN].[DaMapping]
AFTER DELETE AS

BEGIN
	DELETE FROM [FPN].[MappingStatus] WHERE LnID in (SELECT FpnLnId FROM DELETED)
	UPDATE [FPN].[IedMapping] SET Status = 'Unknown' WHERE ObjectID in (SELECT IedMappingId FROM DELETED)
END
GO

/* Update the schema version */
UPDATE [IEC61850].[SchemaInformation] SET [Value] =  N'1.3.1.2' WHERE [Key]=N'SchemaVersion'
GO
