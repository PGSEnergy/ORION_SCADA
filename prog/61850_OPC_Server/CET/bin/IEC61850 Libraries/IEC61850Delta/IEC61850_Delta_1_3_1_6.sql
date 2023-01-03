SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
GO

ALTER TABLE [FPN].[IedMapping]	
	ADD [TemplateID] [nvarchar](255)  COLLATE Latin1_General_CI_AS NULL;
GO

ALTER TABLE [FPN].[ExcludedDa]
	ADD [Value] [nvarchar](255)  COLLATE Latin1_General_CI_AS NULL;	
GO

/* Update the schema version */
UPDATE [IEC61850].[SchemaInformation] SET [Value] =  N'1.3.1.6' WHERE [Key]=N'SchemaVersion'
GO