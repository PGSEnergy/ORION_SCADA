SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
GO

/* Update the schema version */
UPDATE [IEC61850].[SchemaInformation] SET [Value] =  N'1.3.1.0' WHERE [Key]=N'SchemaVersion'
GO

/* New tables */

CREATE SCHEMA [FPN] AUTHORIZATION [dbo]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [FPN].[IedMapping](
	[ObjectID] [uniqueidentifier] NOT NULL,
	[PcmIedName] [nvarchar](255)  COLLATE Latin1_General_CI_AS NULL,
	[PcmIedID] [uniqueidentifier] NULL,
	[FpnIedName] [nvarchar](255)  COLLATE Latin1_General_CI_AS NULL,
	[FpnIedID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_IedMapping] PRIMARY KEY CLUSTERED 
(
	[ObjectID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [FPN].[IedMapping]  WITH CHECK ADD  CONSTRAINT [FK_IedMapping_Ied] FOREIGN KEY([FpnIedID])
REFERENCES [IEC61850].[Ied] ([ObjectID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [FPN].[IedMapping] CHECK CONSTRAINT [FK_IedMapping_Ied]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [FPN].[DaMapping](
	[ObjectID] [uniqueidentifier] NOT NULL,
	[IedMappingId] [uniqueidentifier] NOT NULL,
	[PcmIedName] [nvarchar](255)  COLLATE Latin1_General_CI_AS NULL,	
	[PcmLdInst] [nvarchar](255)  COLLATE Latin1_General_CI_AS NULL,
	[PcmLnId] [uniqueidentifier] NULL,
	[PcmLnClass] [nvarchar](4)  COLLATE Latin1_General_CI_AS NULL,
	[PcmLnPrefix] [nvarchar](11)  COLLATE Latin1_General_CI_AS NULL,
	[PcmLnInst] [int] NOT NULL,
	[PcmDoPath] [nvarchar](255)  COLLATE Latin1_General_CI_AS NULL,
	[PcmDaPath] [nvarchar](255)  COLLATE Latin1_General_CI_AS NULL,
	[FpnIedName] [nvarchar](255)  COLLATE Latin1_General_CI_AS NULL,	
	[FpnLdInst] [nvarchar](255)  COLLATE Latin1_General_CI_AS NULL,
	[FpnLnId] [uniqueidentifier] NULL,
	[FpnLnClass] [nvarchar](4)  COLLATE Latin1_General_CI_AS NULL,
	[FpnLnPrefix] [nvarchar](11)  COLLATE Latin1_General_CI_AS NULL,
	[FpnLnInst] [int] NOT NULL,
	[FpnDoPath] [nvarchar](255)  COLLATE Latin1_General_CI_AS NULL,
	[FpnDaPath] [nvarchar](255)  COLLATE Latin1_General_CI_AS NULL,
	[Excluded] [bit] NOT NULL,
 CONSTRAINT [PK_DaMapping] PRIMARY KEY CLUSTERED 
(
	[ObjectID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [FPN].[DaMapping]  WITH CHECK ADD  CONSTRAINT [FK_DaMapping_IedMapping] FOREIGN KEY([IedMappingId])
REFERENCES [FPN].[IedMapping] ([ObjectID])
GO

ALTER TABLE [FPN].[DaMapping] CHECK CONSTRAINT [FK_DaMapping_IedMapping]
GO

ALTER TABLE [FPN].[DaMapping] ADD  CONSTRAINT [DF_DaMapping_Excluded]  DEFAULT ((0)) FOR [Excluded]
GO
