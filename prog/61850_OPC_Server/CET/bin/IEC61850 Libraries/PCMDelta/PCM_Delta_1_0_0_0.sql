SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
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
