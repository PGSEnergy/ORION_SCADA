SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
GO

ALTER TABLE [FPN].[ExcludedDa]
	ALTER COLUMN [FpnLnClass] [nvarchar](4) COLLATE Latin1_General_CI_AS NULL;	
GO

ALTER TABLE [FPN].[ExcludedDa]
	ALTER COLUMN [FpnLnPrefix] [nvarchar](11) COLLATE Latin1_General_CI_AS NULL;	
GO

/****** Object:  Table [IEC61850].[PhysicalConnection]    Script Date: 08/07/2015 11:06:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [IEC61850].[PhysicalConnection](
	[ObjectID] [uniqueidentifier] NOT NULL,
	[ConnectedAccessPointID] [uniqueidentifier] NOT NULL,
	[ConnectionBusID] [uniqueidentifier] NOT NULL,
	[IedID] [uniqueidentifier] NOT NULL,
	[OrderIndex] [int] NOT NULL,
	[ConnectionType] [nvarchar](255) COLLATE Latin1_General_CI_AS NOT NULL,	
 CONSTRAINT [PK_PhysicalConnection] PRIMARY KEY CLUSTERED 
(
	[ObjectID] ASC,
	[IedID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [IEC61850].[PhysicalConnectionParameter]    Script Date: 08/07/2015 11:06:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [IEC61850].[PhysicalConnectionParameter](
	[ObjectID] [uniqueidentifier] NOT NULL,
	[PhysicalConnectionID] [uniqueidentifier] NOT NULL,
	[IedID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](255) COLLATE Latin1_General_CI_AS NOT NULL,
	[Value] [nvarchar](255) COLLATE Latin1_General_CI_AS NULL,	
	[OrderIndex] [int] NOT NULL,
 CONSTRAINT [PK_PhysicalConnectionParameter] PRIMARY KEY CLUSTERED 
(
	[ObjectID] ASC,
	[IedID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [IEC61850].[ConnectionBus]    Script Date: 08/07/2015 11:06:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [IEC61850].[ConnectionBus](
	[ObjectID] [uniqueidentifier] NOT NULL,	
	[Type] [nvarchar](255) COLLATE Latin1_General_CI_AS NOT NULL,	
 CONSTRAINT [PK_ConnectionBus] PRIMARY KEY CLUSTERED 
(
	[ObjectID] ASC	
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [IEC61850].[ConnectedAccessPoint]	
	ADD [ConnectionBusID] [uniqueidentifier] NULL;
GO

ALTER TABLE [IEC61850].[PhysicalConnection]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalConnection.ConnectedAccessPointID_ConnectedAccessPoint.ObjectID] FOREIGN KEY([ConnectedAccessPointID], [IedID])
REFERENCES [IEC61850].[ConnectedAccessPoint] ([ObjectID], [IedID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [IEC61850].[PhysicalConnection] CHECK CONSTRAINT [FK_PhysicalConnection.ConnectedAccessPointID_ConnectedAccessPoint.ObjectID]
GO

ALTER TABLE [IEC61850].[PhysicalConnection]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalConnection.ConnectionBusID_ConnectionBus.ObjectID] FOREIGN KEY([ConnectionBusID])
REFERENCES [IEC61850].[ConnectionBus] ([ObjectID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [IEC61850].[PhysicalConnection] CHECK CONSTRAINT [FK_PhysicalConnection.ConnectionBusID_ConnectionBus.ObjectID]
GO

ALTER TABLE [IEC61850].[PhysicalConnectionParameter]  WITH CHECK ADD  CONSTRAINT [FK_PhysicalConnectionParameter.PhysicalConnectionID_PhysicalConnection.ObjectID] FOREIGN KEY([PhysicalConnectionID], [IedID])
REFERENCES [IEC61850].[PhysicalConnection] ([ObjectID], [IedID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [IEC61850].[PhysicalConnectionParameter] CHECK CONSTRAINT [FK_PhysicalConnectionParameter.PhysicalConnectionID_PhysicalConnection.ObjectID]
GO

/* Update the schema version */
UPDATE [IEC61850].[SchemaInformation] SET [Value] =  N'1.3.1.5' WHERE [Key]=N'SchemaVersion'
GO