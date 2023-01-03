SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
GO

/* Update the schema version */
UPDATE [IEC61850].[SchemaInformation] SET [Value] =  N'1.3.0.0' WHERE [Key]=N'SchemaVersion'
GO

/* New columns */
ALTER TABLE [IEC61850].[GseControlBlock]
    ADD [FixedOffs] BIT NULL,
        [SecurityEnable] [nvarchar](255) COLLATE Latin1_General_CI_AS NULL,
	    [Protocol] [nvarchar](255) COLLATE Latin1_General_CI_AS NULL;
GO

ALTER TABLE [IEC61850].[SmvControlBlock]    
    ADD [SecurityEnable] [nvarchar](255) COLLATE Latin1_General_CI_AS NULL,
	    [Protocol] [nvarchar](255) COLLATE Latin1_General_CI_AS NULL;
GO

ALTER TABLE [IEC61850].[Service]
    ADD [ResvTms]        BIT            NULL,
        [Owner]          BIT            NULL,
        [SamplesPerSec]  BIT            NULL,
        [PdcTimeStamp]   BIT            NULL,
        [FixedOffs]      BIT            NULL,
        [Delivery]       NVARCHAR (255) COLLATE Latin1_General_CI_AS NULL,
        [DeliveryConf]   BIT            NULL,
        [Mms]            BIT            NULL,
        [Ftp]            BIT            NULL,
        [Ftps]           BIT            NULL,
        [SupportsLdName] BIT            NULL,
        [MaxReports]     BIGINT         NULL,
        [MaxGoose]       BIGINT         NULL,
        [MaxSmv]         BIGINT         NULL,
        [TimeSyncProt]   BIT            NULL,
        [Sntp]           BIT            NULL,
        [C37_238]        BIT            NULL,
        [Other]          BIT            NULL,
        [SetToRo]        BIT            NULL,
        [Hsr]            BIT            NULL,
        [Prp]            BIT            NULL,
        [Rstp]           BIT            NULL,
        [Ipv6]           BIT            NULL;


GO

/* New tables */
CREATE TABLE [IEC61850].[SmvSamplesPerSec] (
    [ServiceID]     UNIQUEIDENTIFIER NOT NULL,
    [OrderIndex]    INT              NOT NULL,
    [SamplesPerSec] BIGINT           NOT NULL,
    [IedID]         UNIQUEIDENTIFIER NOT NULL
);
GO

ALTER TABLE [IEC61850].[SmvSamplesPerSec]
    ADD CONSTRAINT [PK_SmvSamplesPerSec] PRIMARY KEY CLUSTERED ([ServiceID] ASC, 
    [OrderIndex] ASC, [IedID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, 
    ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);
GO

CREATE TABLE [IEC61850].[SmvSecPerSamples] (
    [ServiceID]     UNIQUEIDENTIFIER NOT NULL,
    [OrderIndex]    INT              NOT NULL,
    [SecPerSamples] BIGINT           NOT NULL,
    [IedID]         UNIQUEIDENTIFIER NOT NULL
);
GO

ALTER TABLE [IEC61850].[SmvSecPerSamples]
    ADD CONSTRAINT [PK_SmvSecPerSamples] PRIMARY KEY CLUSTERED ([ServiceID] ASC, [OrderIndex] ASC, 
    [IedID] ASC) WITH (ALLOW_PAGE_LOCKS = ON, ALLOW_ROW_LOCKS = ON, PAD_INDEX = OFF, 
    IGNORE_DUP_KEY = OFF, STATISTICS_NORECOMPUTE = OFF);
GO

/* New foreign keys */
ALTER TABLE [IEC61850].[SmvSamplesPerSec]  WITH CHECK ADD  CONSTRAINT [FK_SmvSamplesPerSec.ServiceID_Service.ObjectID] FOREIGN KEY([ServiceID], [IedID])
REFERENCES [IEC61850].[Service] ([ObjectID], [IedID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [IEC61850].[SmvSamplesPerSec] CHECK CONSTRAINT [FK_SmvSamplesPerSec.ServiceID_Service.ObjectID]
GO

ALTER TABLE [IEC61850].[SmvSecPerSamples]  WITH CHECK ADD  CONSTRAINT [FK_SmvSecPerSamples.ServiceID_Service.ObjectID] FOREIGN KEY([ServiceID], [IedID])
REFERENCES [IEC61850].[Service] ([ObjectID], [IedID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [IEC61850].[SmvSecPerSamples] CHECK CONSTRAINT [FK_SmvSecPerSamples.ServiceID_Service.ObjectID]
GO

/* New constraints */
ALTER TABLE [IEC61850].[GseControlBlock] ADD  CONSTRAINT [DF_GseControlBlock_FixedOffs]  DEFAULT (NULL) FOR [FixedOffs]
GO
ALTER TABLE [IEC61850].[GseControlBlock] ADD  CONSTRAINT [DF_GseControlBlock_SecurityEnable]  DEFAULT (NULL) FOR [SecurityEnable]
GO
ALTER TABLE [IEC61850].[GseControlBlock] ADD  CONSTRAINT [DF_GseControlBlock_Protocol]  DEFAULT (NULL) FOR [Protocol]
GO
ALTER TABLE [IEC61850].[SmvControlBlock] ADD  CONSTRAINT [DF_SmvControlBlock_SecurityEnable]  DEFAULT (NULL) FOR [SecurityEnable]
GO
ALTER TABLE [IEC61850].[SmvControlBlock] ADD  CONSTRAINT [DF_SmvControlBlock_Protocol]  DEFAULT (NULL) FOR [Protocol]
GO
ALTER TABLE [IEC61850].[Service] ADD  CONSTRAINT [DF_Service_ResvTms]  DEFAULT (NULL) FOR [ResvTms]
GO
ALTER TABLE [IEC61850].[Service] ADD  CONSTRAINT [DF_Service_Owner]  DEFAULT (NULL) FOR [Owner]
GO
ALTER TABLE [IEC61850].[Service] ADD  CONSTRAINT [DF_Service_SamplesPerSec]  DEFAULT (NULL) FOR [SamplesPerSec]
GO
ALTER TABLE [IEC61850].[Service] ADD  CONSTRAINT [DF_Service_PdcTimeStamp]  DEFAULT (NULL) FOR [PdcTimeStamp]
GO
ALTER TABLE [IEC61850].[Service] ADD  CONSTRAINT [DF_Service_FixedOffs]  DEFAULT (NULL) FOR [FixedOffs]
GO
ALTER TABLE [IEC61850].[Service] ADD  CONSTRAINT [DF_Service_Delivery]  DEFAULT (NULL) FOR [Delivery]
GO
ALTER TABLE [IEC61850].[Service] ADD  CONSTRAINT [DF_Service_DeliveryConf]  DEFAULT (NULL) FOR [DeliveryConf]
GO
ALTER TABLE [IEC61850].[Service] ADD  CONSTRAINT [DF_Service_Mms]  DEFAULT (NULL) FOR [Mms]
GO
ALTER TABLE [IEC61850].[Service] ADD  CONSTRAINT [DF_Service_Ftp]  DEFAULT (NULL) FOR [Ftp]
GO
ALTER TABLE [IEC61850].[Service] ADD  CONSTRAINT [DF_Service_Ftps]  DEFAULT (NULL) FOR [Ftps]
GO
ALTER TABLE [IEC61850].[Service] ADD  CONSTRAINT [DF_Service_SupportsLdName]  DEFAULT (NULL) FOR [SupportsLdName]
GO
ALTER TABLE [IEC61850].[Service] ADD  CONSTRAINT [DF_Service_MaxReports]  DEFAULT (NULL) FOR [MaxReports]
GO
ALTER TABLE [IEC61850].[Service] ADD  CONSTRAINT [DF_Service_MaxGoose]  DEFAULT (NULL) FOR [MaxGoose]
GO
ALTER TABLE [IEC61850].[Service] ADD  CONSTRAINT [DF_Service_MaxSmv]  DEFAULT (NULL) FOR [MaxSmv]
GO
ALTER TABLE [IEC61850].[Service] ADD  CONSTRAINT [DF_Service_TimeSyncProt]  DEFAULT (NULL) FOR [TimeSyncProt]
GO
ALTER TABLE [IEC61850].[Service] ADD  CONSTRAINT [DF_Service_Sntp]  DEFAULT (NULL) FOR [Sntp]
GO
ALTER TABLE [IEC61850].[Service] ADD  CONSTRAINT [DF_Service_C37_238]  DEFAULT (NULL) FOR [C37_238]
GO
ALTER TABLE [IEC61850].[Service] ADD  CONSTRAINT [DF_Service_Other]  DEFAULT (NULL) FOR [Other]
GO
ALTER TABLE [IEC61850].[Service] ADD  CONSTRAINT [DF_Service_SetToRo]  DEFAULT (NULL) FOR [SetToRo]
GO
ALTER TABLE [IEC61850].[Service] ADD  CONSTRAINT [DF_Service_Hsr]  DEFAULT (NULL) FOR [Hsr]
GO
ALTER TABLE [IEC61850].[Service] ADD  CONSTRAINT [DF_Service_Prp]  DEFAULT (NULL) FOR [Prp]
GO
ALTER TABLE [IEC61850].[Service] ADD  CONSTRAINT [DF_Service_Rstp]  DEFAULT (NULL) FOR [Rstp]
GO
ALTER TABLE [IEC61850].[Service] ADD  CONSTRAINT [DF_Service_Ipv6]  DEFAULT (NULL) FOR [Ipv6]
GO