/****** Object:  Schema [PCM] */
CREATE SCHEMA [PCM] AUTHORIZATION [dbo]
GO
/****** Object:  Table [IEC61850].[PrivateElementInstanceData]    Script Date: 07/15/2011 11:08:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PCM].[PrivateElementInstanceData](
	[ObjectID] [uniqueidentifier] NOT NULL,
	[IedID] [uniqueidentifier] NOT NULL
 CONSTRAINT [PK_PrivateElementInstanceData_PCM] PRIMARY KEY CLUSTERED 
(
	[ObjectID] ASC,
	[IedID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [IEC61850].[PrivateElement]    Script Date: 07/15/2011 11:08:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PCM].[PrivateElement](
	[ObjectID] [uniqueidentifier] NOT NULL,
	[IedID] [uniqueidentifier] NOT NULL
 CONSTRAINT [PK_PrivateElement_PCM] PRIMARY KEY CLUSTERED 
(
	[ObjectID] ASC,
	[IedID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [IEC61850].[TextElementInstanceData]    Script Date: 07/15/2011 11:08:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PCM].[TextElementInstanceData](
	[ObjectID] [uniqueidentifier] NOT NULL,
	[IedID] [uniqueidentifier] NOT NULL
 CONSTRAINT [PK_TextElementInstanceData_PCM] PRIMARY KEY CLUSTERED 
(
	[ObjectID] ASC,
	[IedID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [IEC61850].[TextElement]    Script Date: 07/15/2011 11:08:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [PCM].[TextElement](
	[ObjectID] [uniqueidentifier] NOT NULL,
	[IedID] [uniqueidentifier] NOT NULL
 CONSTRAINT [PK_TextElement_PCM] PRIMARY KEY CLUSTERED 
(
	[ObjectID] ASC,
	[IedID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [PCM].[SchemaInformation]    Script Date: 03/12/2012 12:42:21 ******/
CREATE TABLE [PCM].[SchemaInformation](
	[Key] [nvarchar](255) COLLATE Latin1_General_CI_AS NOT NULL,
	[Value] [nvarchar](255) COLLATE Latin1_General_CI_AS NOT NULL,
	[Description] [nvarchar](4000) COLLATE Latin1_General_CI_AS NULL,
 CONSTRAINT [PK_SchemaInformation] PRIMARY KEY CLUSTERED 
(
	[Key] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [PCM].[SchemaInformation] ([Key], [Value], [Description]) VALUES (N'SchemaVersion', N'1.0.0.0', N'PCM Database Schema Version')
GO

