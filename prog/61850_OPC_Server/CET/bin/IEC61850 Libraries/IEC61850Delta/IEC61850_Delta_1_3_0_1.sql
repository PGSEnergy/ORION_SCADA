SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
GO

/* Update the schema version */
UPDATE [IEC61850].[SchemaInformation] SET [Value] =  N'1.3.0.1' WHERE [Key]=N'SchemaVersion'
GO

/* New columns */
ALTER TABLE [IEC61850].[InstanceData]
    ADD [ValImport] BIT NULL;
GO

ALTER TABLE [IEC61850].[AbstractDataAttribute]
    ADD [ValImport] BIT NULL;
GO

/* New tables */
CREATE TABLE [IEC61850].[ProtocolNamespace](
	[ObjectID] [uniqueidentifier] NOT NULL,
	[DataAttributeTypeID] [uniqueidentifier] NULL,
	[DataAttributeID] [uniqueidentifier] NULL,
	[Type] [nvarchar](255) COLLATE Finnish_Swedish_CI_AS NOT NULL,
	[Content] [nvarchar](255) COLLATE Finnish_Swedish_CI_AS NOT NULL,
	[OrderIndex] [int] NOT NULL,
CONSTRAINT [PK_ProtocolNamespace] PRIMARY KEY CLUSTERED 
(
	[ObjectID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/* New foreign keys */

/* New constraints */
ALTER TABLE [IEC61850].[ProtocolNamespace] ADD  CONSTRAINT [DF_ProtocolNamespace_DataAttributeTypeID]  DEFAULT (NULL) FOR [DataAttributeTypeID]
GO

ALTER TABLE [IEC61850].[ProtocolNamespace] ADD  CONSTRAINT [DF_ProtocolNamespace_DataAttributeID]  DEFAULT (NULL) FOR [DataAttributeID]
GO
