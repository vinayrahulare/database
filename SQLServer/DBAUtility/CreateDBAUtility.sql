USE [DBAUtility]
GO
/****** Object:  Schema [metrics]    Script Date: 11/16/2020 10:42:37 AM ******/
CREATE SCHEMA [metrics]
GO
/****** Object:  Schema [perms]    Script Date: 11/16/2020 10:42:37 AM ******/
CREATE SCHEMA [perms]
GO
/****** Object:  Table [perms].[Snapshots]    Script Date: 11/16/2020 10:42:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [perms].[Snapshots](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[DatabaseName] [nvarchar](128) NOT NULL,
	[CaptureDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Perms_Snapshots] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [perms].[vwPerms_listCurrentSnapshots]    Script Date: 11/16/2020 10:42:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [perms].[vwPerms_listCurrentSnapshots] 

AS
	/**************************************************************************
		Author: Eric Cobb - http://www.sqlnuggets.com/
		License:
				MIT License
				Copyright (c) 2017 Eric Cobb
				View full license disclosure: https://github.com/ericcobb/SQL-Server-Permissions-Manager/blob/master/LICENSE
		Purpose: 
				This view returns a list of the most recent Permissions Snapshots for each database
					
	***************************************************************************/

SELECT ID, [DatabaseName], [CaptureDate]
FROM(SELECT ID, [DatabaseName], [CaptureDate] 
		,ROW_NUMBER() OVER (PARTITION BY [DatabaseName] ORDER BY [CaptureDate] DESC) AS rn
	FROM perms.snapshots
) s
WHERE s.rn = 1

GO
/****** Object:  Table [perms].[DatabasePermissions]    Script Date: 11/16/2020 10:42:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [perms].[DatabasePermissions](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[SnapshotID] [bigint] NOT NULL,
	[State] [char](1) NOT NULL,
	[StateDesc] [nvarchar](60) NOT NULL,
	[PermissionName] [nvarchar](128) NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_Perms_DatabasePermissions] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [perms].[ObjectPermissions]    Script Date: 11/16/2020 10:42:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [perms].[ObjectPermissions](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[SnapshotID] [bigint] NOT NULL,
	[State] [char](1) NOT NULL,
	[StateDesc] [nvarchar](60) NOT NULL,
	[PermissionName] [nvarchar](128) NOT NULL,
	[SchemaName] [nvarchar](128) NOT NULL,
	[ObjectName] [nvarchar](128) NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
	[ClassDesc] [nvarchar](60) NOT NULL,
	[ColumnName] [nvarchar](128) NULL,
 CONSTRAINT [PK_Perms_Object_Permissions] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [perms].[RoleMemberships]    Script Date: 11/16/2020 10:42:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [perms].[RoleMemberships](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[SnapshotID] [bigint] NOT NULL,
	[RoleName] [nvarchar](256) NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_Perms_Role_Memberships] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [perms].[Roles]    Script Date: 11/16/2020 10:42:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [perms].[Roles](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[SnapshotID] [bigint] NOT NULL,
	[RoleName] [nvarchar](128) NOT NULL,
	[RoleType] [char](1) NOT NULL,
	[RoleTypeDesc] [nvarchar](60) NOT NULL,
	[DefaultSchema] [nvarchar](128) NULL,
 CONSTRAINT [PK_Perms_Roles] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [perms].[SchemaPermissions]    Script Date: 11/16/2020 10:42:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [perms].[SchemaPermissions](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[SnapshotID] [bigint] NOT NULL,
	[State] [char](1) NOT NULL,
	[StateDesc] [nvarchar](60) NOT NULL,
	[PermissionName] [nvarchar](128) NOT NULL,
	[SchemaName] [nvarchar](128) NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_Perms_Schema_Permissions] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [perms].[Users]    Script Date: 11/16/2020 10:42:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [perms].[Users](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[SnapshotID] [bigint] NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
	[UserType] [char](1) NOT NULL,
	[UserTypeDesc] [nvarchar](60) NOT NULL,
	[DefaultSchema] [nvarchar](128) NULL,
	[LoginName] [nvarchar](128) NOT NULL,
	[LoginType] [char](1) NOT NULL,
	[isDisabled] [bit] NOT NULL,
	[SID] [varbinary](85) NULL,
	[PasswordHash] [varbinary](256) NULL,
 CONSTRAINT [PK_Perms_Users] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [perms].[vwPerms_listCurrentDBPermissions]    Script Date: 11/16/2020 10:42:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [perms].[vwPerms_listCurrentDBPermissions]
AS
	/**************************************************************************
		Author: Eric Cobb - http://www.sqlnuggets.com/
		License:
				MIT License
				Copyright (c) 2017 Eric Cobb
				View full license disclosure: https://github.com/ericcobb/SQL-Server-Permissions-Manager/blob/master/LICENSE
		Purpose: 
				This view returns a list of the most recent Permissions Snapshots for each database, displaying users and their assigned permissions.					
	***************************************************************************/

	SELECT TOP 100 PERCENT [SnapshotID] = ID, [CaptureDate], [DatabaseName]
			,rm.[username]
			,rm.[PermType]
			,rm.[Perm]
	FROM(SELECT ID, [DatabaseName], [CaptureDate] 
			,ROW_NUMBER() OVER (PARTITION BY [DatabaseName] ORDER BY [CaptureDate] DESC) AS rn
		FROM perms.snapshots
		) s
		INNER JOIN (SELECT [PermType] = 'User-Login Mapping'
							,[UserName] 
							,[Perm] = ' FROM LOGIN ' + [loginname]
							,[SnapshotID]
					 FROM [perms].[Users] u
					UNION
					SELECT [PermType] = CASE WHEN r.[roletype] = 'R' THEN 'Database Role' ELSE ' Application Role' END
							,[UserName] = [rolename]
							,[Perm] = NULL
							,[SnapshotID]
					FROM [perms].[Roles] r
					UNION 
					SELECT [PermType] = 'Role Memberships'
							,[UserName]
							,[Perm] = [rolename]
							,[SnapshotID]
					FROM [perms].[RoleMemberships] rm
					UNION
					SELECT [PermType] = 'Object Permission'
							,[UserName]
							,[Perm] = CASE WHEN state <> 'W' THEN [StateDesc] + SPACE(1) ELSE 'GRANT ' END
										+ [PermissionName] 
										+ ' ON [' +  [schemaname] + '].[' + [objectname] + '] TO [' + [username] + ']'
										+ CASE WHEN [state] <> 'W' THEN SPACE(0) ELSE ' (WITH GRANT OPTION)' END
							,[SnapshotID]
					FROM [perms].[ObjectPermissions] op
					UNION 
					SELECT [PermType] = 'Schema Permission'
							,[UserName]
							,[Perm] = CASE WHEN [state] <> 'W' THEN [StateDesc] + SPACE(1) ELSE 'GRANT ' END
										+ [PermissionName] 
										+ ' ON [' + [schemaname] + '] TO [' + [username] + ']'
										+ CASE WHEN [state] <> 'W' THEN SPACE(0) ELSE ' (WITH GRANT OPTION)' END
							,[SnapshotID]
					FROM [perms].[SchemaPermissions] 
					UNION
					SELECT [PermType] = 'Database Permission'
							,[UserName]
							,[Perm] = StateDesc + ' ' + PermissionName
							,[SnapshotID]
					FROM perms.DatabasePermissions
					) rm ON rm.[SnapshotID] = s.ID
	WHERE s.rn = 1
	ORDER BY [DatabaseName],[username],[PermType],[Perm];


GO
/****** Object:  Table [metrics].[IndexMetrics]    Script Date: 11/16/2020 10:42:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [metrics].[IndexMetrics](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[DatabaseID] [smallint] NOT NULL,
	[DatabaseName] [nvarchar](128) NOT NULL,
	[SchemaName] [nvarchar](128) NOT NULL,
	[TableName] [nvarchar](128) NULL,
	[IndexName] [nvarchar](128) NULL,
	[IndexID] [int] NOT NULL,
	[IndexType] [nvarchar](60) NULL,
	[PartitionNumber] [int] NULL,
	[Rows] [bigint] NULL,
	[UserSeeks] [bigint] NULL,
	[UserScans] [bigint] NULL,
	[UserLookups] [bigint] NULL,
	[UserUpdates] [bigint] NULL,
	[IndexSizeMB] [decimal](18, 2) NULL,
	[IndexMetricsChecks] [int] NOT NULL,
	[LastUserSeek] [datetime] NULL,
	[LastUserScan] [datetime] NULL,
	[LastUserLookup] [datetime] NULL,
	[LastUserUpdate] [datetime] NULL,
	[SystemSeeks] [bigint] NULL,
	[SystemScans] [bigint] NULL,
	[SystemLookups] [bigint] NULL,
	[SystemUpdates] [bigint] NULL,
	[LastSystemSeek] [datetime] NULL,
	[LastSystemScan] [datetime] NULL,
	[LastSystemLookup] [datetime] NULL,
	[LastSystemUpdate] [datetime] NULL,
	[isUnique] [bit] NULL,
	[isUniqueConstraint] [bit] NULL,
	[isPrimaryKey] [bit] NULL,
	[isDisabled] [bit] NULL,
	[isHypothetical] [bit] NULL,
	[allowRowLocks] [bit] NULL,
	[allowPageLocks] [bit] NULL,
	[FillFactor] [tinyint] NOT NULL,
	[hasFilter] [bit] NULL,
	[Filter] [nvarchar](max) NULL,
	[DateInitiallyChecked] [datetime] NOT NULL,
	[DateLastChecked] [datetime] NOT NULL,
	[SQLServerStartTime] [datetime] NOT NULL,
	[DropStatement] [nvarchar](1000) NULL,
	[Hash] [varbinary](256) NULL,
 CONSTRAINT [PK_IndexMetrics] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [metrics].[vwIndexMetrics_CurrentMetricsWithTotals]    Script Date: 11/16/2020 10:42:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [metrics].[vwIndexMetrics_CurrentMetricsWithTotals]
AS
	/**************************************************************************
		Author: Eric Cobb - http://www.sqlnuggets.com/
		License:
				MIT License
				Copyright (c) 2017 Eric Cobb
				View full license disclosure: https://github.com/ericcobb/SQL-Server-Metrics-Pack/blob/master/LICENSE
		Purpose: 
				This view queries the IndexMetrics table to return both the current (since last SQL Server restart) and 
				total (historical aggregations across all available index data) Index metrics.		
	***************************************************************************/

	SELECT [DatabaseName]
			,[SchemaName]
			,[TableName]
			,[IndexName]
			,[IndexType]
			,[Rows]
			,[IndexSizeMB]
			,[UserSeeks]
			,[UserScans]
			,[UserLookups]
			,[UserUpdates]
			,[IndexMetricsChecks]
			,[SQLServerStartTime]
			,[totalUserSeek]
			,[totalUserScans]
			,[totalUserLookups]
			,[totalUserUpdates]
			,[TotalIndexMetricsChecks]
			,[DateInitiallyChecked]
			,[DateLastChecked]
			,[isDisabled]
			,[isHypothetical]
	FROM (SELECT ixm.[DatabaseName],ixm.[SchemaName],ixm.[TableName],ixm.[IndexName],[IndexType],[Rows],ixm.[IndexSizeMB],ixm.[UserSeeks],ixm.[UserScans],
				ixm.[UserLookups],ixm.[UserUpdates],ixm.[IndexMetricsChecks],ixm.[SQLServerStartTime],t.[totalUserSeek],t.[totalUserScans],t.[totalUserLookups],t.[totalUserUpdates],
				[TotalIndexMetricsChecks] = t.[totalCount],	t.[DateInitiallyChecked], t.[DateLastChecked], ixm.[isDisabled], ixm.[isHypothetical],
				ROW_NUMBER() OVER (PARTITION BY ixm.[Hash] ORDER BY ixm.SQLServerStartTime DESC) AS rn
			FROM [metrics].[IndexMetrics] ixm
			INNER JOIN (SELECT [Hash], [totaluserseek] = SUM(UserSeeks), [totalUserScans] = SUM(UserScans), [totalUserLookups] = SUM(UserLookups), 
							[totalUserUpdates] = SUM(UserUpdates), [totalcount] = SUM([IndexMetricsChecks]),[DateInitiallyChecked] = MIN([DateInitiallyChecked]),
							[DateLastChecked] = MAX([DateLastChecked])
						FROM [metrics].[IndexMetrics]
						GROUP BY [Hash]
						) t ON t.[Hash] = ixm.[Hash]
		) ix
	WHERE ix.rn = 1

GO
/****** Object:  View [metrics].[vwIndexMetrics_CurrentActiveIndexMetrics]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [metrics].[vwIndexMetrics_CurrentActiveIndexMetrics]
AS
	/**************************************************************************
		Author: Eric Cobb - http://www.sqlnuggets.com/
		License:
				MIT License
				Copyright (c) 2017 Eric Cobb
				View full license disclosure: https://github.com/ericcobb/SQL-Server-Metrics-Pack/blob/master/LICENSE
		Purpose: 
				This view queries the IndexMetrics table to return the metrics gathered since the last SQL Server restart,
				as determined by the sys.dm_os_sys_info DMV. Excludes Disabled and Hypothetical indexes.		
	***************************************************************************/

	SELECT [DatabaseID]
		  ,[DatabaseName]
		  ,[SchemaName]
		  ,[TableName]
		  ,[IndexName]
		  ,[IndexType]
		  ,[UserSeeks]
		  ,[UserScans]
		  ,[UserLookups]
		  ,[UserUpdates]
		  ,[LastUserSeek]
		  ,[LastUserScan]
		  ,[LastUserLookup]
		  ,[LastUserUpdate]
		  ,[SystemSeeks]
		  ,[SystemScans]
		  ,[SystemLookups]
		  ,[SystemUpdates]
		  ,[LastSystemSeek]
		  ,[LastSystemScan]
		  ,[LastSystemLookup]
		  ,[LastSystemUpdate]
		  ,[IndexMetricsChecks]
		  ,[DateInitiallyChecked]
		  ,[DateLastChecked]
		  ,[SQLServerStartTime]
  FROM [metrics].[IndexMetrics] ixm
  INNER JOIN sys.dm_os_sys_info info ON ixm.SQLServerStartTime = info.sqlserver_start_time
  WHERE ixm.isDisabled = 0
  AND	ixm.isHypothetical = 0

GO
/****** Object:  View [metrics].[vwIndexMetrics_CurrentActiveIndexDetails]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [metrics].[vwIndexMetrics_CurrentActiveIndexDetails]
AS
	/**************************************************************************
		Author: Eric Cobb - http://www.sqlnuggets.com/
		License:
				MIT License
				Copyright (c) 2017 Eric Cobb
				View full license disclosure: https://github.com/ericcobb/SQL-Server-Metrics-Pack/blob/master/LICENSE
		Purpose: 
				This view queries the IndexMetrics table to return the index details gathered since the last SQL Server restart,
				as determined by the sys.dm_os_sys_info DMV. Excludes Disabled and Hypothetical indexes.		
	***************************************************************************/

	SELECT [DatabaseID]
		  ,[DatabaseName]
		  ,[SchemaName]
		  ,[TableName]
		  ,[IndexName]
		  ,[IndexID]
		  ,[IndexType]
		  ,[PartitionNumber]
		  ,[Rows]
		  ,[IndexSizeMB]
		  ,[isUnique]
		  ,[isUniqueConstraint]
		  ,[isPrimaryKey]
		  ,[isDisabled]
		  ,[isHypothetical]
		  ,[allowRowLocks]
		  ,[allowPageLocks]
		  ,[FillFactor]
		  ,[hasFilter]
		  ,[Filter]
		  ,[IndexMetricsChecks]
		  ,[DateInitiallyChecked]
		  ,[DateLastChecked]
		  ,[SQLServerStartTime]
		  ,[DropStatement]
  FROM [metrics].[IndexMetrics] ixm
  INNER JOIN sys.dm_os_sys_info info ON ixm.SQLServerStartTime = info.sqlserver_start_time
  WHERE ixm.isDisabled = 0
  AND	ixm.isHypothetical = 0

GO
/****** Object:  View [metrics].[vwIndexMetrics_RarelyUsedIndexes]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [metrics].[vwIndexMetrics_RarelyUsedIndexes]
AS
	/**************************************************************************
		Author: Eric Cobb - http://www.sqlnuggets.com/
		License:
				MIT License
				Copyright (c) 2017 Eric Cobb
				View full license disclosure: https://github.com/ericcobb/SQL-Server-Metrics-Pack/blob/master/LICENSE
		Purpose: 
				This view queries the IndexMetrics table to return rarely used since the last SQL Server restart, as determined by the sys.dm_os_sys_info DMV. 	
				This view considers an index "rarely" used when the summed total of UserSeeks, UserScans, and UserLookups is less than 25% of number of upates to the index.
				Excludes Heaps, Clustered Indexes, Primary Keys, Disabled and Hypothetical indexes.
	***************************************************************************/

	SELECT [DatabaseID]
		  ,[DatabaseName]
		  ,[SchemaName]
		  ,[TableName]
		  ,[IndexName]
		  ,[IndexType]
		  ,[UserSeeks]
		  ,[UserScans]
		  ,[UserLookups]
		  ,[UserUpdates]
		  ,[LastUserSeek]
		  ,[LastUserScan]
		  ,[LastUserLookup]
		  ,[LastUserUpdate]
		  ,[Rows]
		  ,[IndexSizeMB]
		  ,[IndexMetricsChecks]
		  ,[DateInitiallyChecked]
		  ,[DateLastChecked]
		  ,[SQLServerStartTime]
		  ,[DropStatement]
  FROM [metrics].[IndexMetrics] ixm
  INNER JOIN sys.dm_os_sys_info info ON ixm.[SQLServerStartTime] = info.[sqlserver_start_time]
  WHERE ixm.[IndexID] > 1
  AND	(ixm.[isDisabled] = 0 AND ixm.[isHypothetical] = 0 AND ixm.[isPrimaryKey] = 0)
  AND   ((ixm.[UserSeeks] + ixm.[UserScans] + ixm.[UserLookups]) < (ixm.[UserUpdates] * 0.25)
		OR (ixm.[UserSeeks] + ixm.[UserScans] + ixm.[UserLookups]) = 0)

GO
/****** Object:  Table [metrics].[DatabaseFileMetrics]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [metrics].[DatabaseFileMetrics](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[DatabaseID] [smallint] NULL,
	[DatabaseName] [nvarchar](128) NULL,
	[FileID] [int] NOT NULL,
	[FileName] [nvarchar](128) NOT NULL,
	[FileType] [nvarchar](60) NULL,
	[FileLocation] [nvarchar](260) NOT NULL,
	[CurrentState] [nvarchar](60) NULL,
	[isReadOnly] [bit] NOT NULL,
	[CurrentSizeMB] [decimal](10, 2) NULL,
	[SpaceUsedMB] [decimal](10, 2) NULL,
	[PercentUsed] [decimal](10, 2) NULL,
	[FreeSpaceMB] [decimal](10, 2) NULL,
	[PercentFree] [decimal](10, 2) NULL,
	[AutoGrowth] [nvarchar](128) NULL,
	[CaptureDate] [datetime] NOT NULL,
 CONSTRAINT [PK_DatabaseFileMetrics] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [metrics].[vwDBFileMetrics_CurrentFileSizes]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [metrics].[vwDBFileMetrics_CurrentFileSizes]
AS

	/**************************************************************************
		Author: Eric Cobb - http://www.sqlnuggets.com/
		License:
				MIT License
				Copyright (c) 2017 Eric Cobb
				View full license disclosure: https://github.com/ericcobb/SQL-Server-Metrics-Pack/blob/master/LICENSE
		Purpose: 
				This view queries the DatabaseFileMetrics table to return the most recently recorded
				data and log file metrics.
	***************************************************************************/

	SELECT [DatabaseName]
		  ,[FileName]
		  ,[FileType]
		  ,[CurrentSize]
		  ,[SpaceUsed]
		  ,[PercentUsed]
		  ,[FreeSpace]
		  ,[PercentFree]
		  ,[AutoGrowth]
		  ,[CaptureDate]
	FROM (SELECT [DatabaseName]
			  ,[FileName]
			  ,[FileType]
			  ,[CurrentSize] = Cast([CurrentSizeMB] AS varchar(25))+' MB'
			  ,[SpaceUsed] = Cast([SpaceUsedMB] AS varchar(25))+' MB'
			  ,[PercentUsed] = Cast([PercentUsed] AS varchar(25))+'%'
			  ,[FreeSpace] = Cast([FreeSpaceMB] AS varchar(25))+' MB'
			  ,[PercentFree] = Cast([PercentFree] AS varchar(25))+'%'
			  ,[AutoGrowth]
			  ,[CaptureDate]
			  ,ROW_NUMBER() OVER (PARTITION BY [DatabaseID],[FileID] ORDER BY [CaptureDate] DESC) AS rn
		  FROM [metrics].[DatabaseFileMetrics]
		) fm
	WHERE fm.rn = 1;

GO
/****** Object:  Table [dbo].[TableActivity]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TableActivity](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DatabaseName] [sysname] NOT NULL,
	[SchemaName] [nvarchar](128) NULL,
	[ObjectName] [sysname] NOT NULL,
	[IndexName] [sysname] NULL,
	[IndexID] [int] NOT NULL,
	[UserSeek] [bigint] NOT NULL,
	[UserScans] [bigint] NOT NULL,
	[UserLookups] [bigint] NOT NULL,
	[UserUpdates] [bigint] NOT NULL,
	[TableRows] [bigint] NULL,
	[IndexSizeMB] [bigint] NULL,
	[DropStatement] [nvarchar](2000) NULL,
	[Count] [int] NULL,
	[SQLServerStartTime] [datetime] NULL,
	[HoursOnline] [int] NULL,
	[DateInitiallyChecked] [datetime] NOT NULL,
	[DateLastChecked] [datetime] NOT NULL,
	[LastUserSeek] [datetime] NULL,
	[LastUserScan] [datetime] NULL,
	[LastUserLookup] [datetime] NULL,
	[LastUserUpdate] [datetime] NULL,
	[isUnique] [bit] NOT NULL,
	[FillFactor] [tinyint] NOT NULL,
	[isDisabled] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[TablesWithNoReads]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [dbo].[TablesWithNoReads]
AS
SELECT        DatabaseName, SchemaName, ObjectName, UserSeek, UserScans, TableRows, UserUpdates, UserLookups, LastUserSeek, LastUserScan, LastUserLookup, LastUserUpdate
FROM            dbo.TableActivity
where LastUserSeek IS NULL
  and LastUserScan IS NULL
  and LastUserLookup IS NULL
GO
/****** Object:  View [dbo].[TablesWithNoWrites]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create view [dbo].[TablesWithNoWrites]
AS
SELECT        DatabaseName, SchemaName, ObjectName, UserSeek, UserScans, TableRows, UserUpdates, UserLookups, LastUserSeek, LastUserScan, LastUserLookup, LastUserUpdate
FROM            dbo.TableActivity
where LastUserUpdate IS NULL
GO
/****** Object:  Table [dbo].[Names]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Names](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Value] [nvarchar](260) NOT NULL,
 CONSTRAINT [PK_Names] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IndexUsageStats]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IndexUsageStats](
	[StatsDate] [datetime2](0) NOT NULL,
	[ServerNameID] [int] NOT NULL,
	[DatabaseID] [smallint] NOT NULL,
	[ObjectID] [int] NOT NULL,
	[IndexID] [int] NOT NULL,
	[DatabaseNameID] [int] NOT NULL,
	[SchemaNameID] [int] NOT NULL,
	[TableNameID] [int] NOT NULL,
	[IndexNameID] [int] NULL,
	[User_Seeks] [bigint] NOT NULL,
	[User_Scans] [bigint] NOT NULL,
	[User_Lookups] [bigint] NOT NULL,
	[User_Updates] [bigint] NOT NULL,
	[System_Seeks] [bigint] NOT NULL,
	[System_Scans] [bigint] NOT NULL,
	[System_Lookups] [bigint] NOT NULL,
	[System_Updates] [bigint] NOT NULL,
 CONSTRAINT [PK_IUS] PRIMARY KEY CLUSTERED 
(
	[StatsDate] ASC,
	[ServerNameID] ASC,
	[DatabaseID] ASC,
	[ObjectID] ASC,
	[IndexID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_IndexUsageStats]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- displays usage statistics
CREATE VIEW [dbo].[vw_IndexUsageStats]
AS
SELECT
	s.StatsDate,
	vn.Value AS ServerName,
	dbn.Value AS DatabaseName,
	sn.Value AS SchemaName,
	tn.Value AS TableName,
	dn.Value AS IndexName,
	s.IndexID,
	s.User_Seeks,
	s.User_Scans,
	s.User_Lookups,
	s.User_Updates,
	s.System_Seeks,
	s.System_Scans,
	s.System_Lookups,
	s.System_Updates
FROM dbo.IndexUsageStats s
INNER JOIN dbo.Names vn ON s.ServerNameID = vn.ID
INNER JOIN dbo.Names dbn ON s.DatabaseNameID = dbn.ID
INNER JOIN dbo.Names sn ON s.SchemaNameID = sn.ID
INNER JOIN dbo.Names tn ON s.TableNameID = tn.ID
LEFT JOIN dbo.Names dn ON s.IndexNameID = dn.ID;
GO
/****** Object:  Table [metrics].[BlitzFirst_FileStats]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [metrics].[BlitzFirst_FileStats](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ServerName] [nvarchar](128) NULL,
	[CheckDate] [datetimeoffset](7) NULL,
	[DatabaseID] [int] NOT NULL,
	[FileID] [int] NOT NULL,
	[DatabaseName] [nvarchar](256) NULL,
	[FileLogicalName] [nvarchar](256) NULL,
	[TypeDesc] [nvarchar](60) NULL,
	[SizeOnDiskMB] [bigint] NULL,
	[io_stall_read_ms] [bigint] NULL,
	[num_of_reads] [bigint] NULL,
	[bytes_read] [bigint] NULL,
	[io_stall_write_ms] [bigint] NULL,
	[num_of_writes] [bigint] NULL,
	[bytes_written] [bigint] NULL,
	[PhysicalName] [nvarchar](520) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [metrics].[BlitzFirst_FileStats_Deltas]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [metrics].[BlitzFirst_FileStats_Deltas] AS 
WITH RowDates as
(
        SELECT 
                ROW_NUMBER() OVER (ORDER BY [ServerName], [CheckDate]) ID,
                [CheckDate]
        FROM [metrics].[BlitzFirst_FileStats]
        GROUP BY [ServerName], [CheckDate]
),
CheckDates as
(
        SELECT ThisDate.CheckDate,
               LastDate.CheckDate as PreviousCheckDate
        FROM RowDates ThisDate
        JOIN RowDates LastDate
        ON ThisDate.ID = LastDate.ID + 1
)
     SELECT f.ServerName,
            f.CheckDate,
            f.DatabaseID,
            f.DatabaseName,
            f.FileID,
            f.FileLogicalName,
            f.TypeDesc,
            f.PhysicalName,
            f.SizeOnDiskMB,
            DATEDIFF(ss, fPrior.CheckDate, f.CheckDate) AS ElapsedSeconds,
            (f.SizeOnDiskMB - fPrior.SizeOnDiskMB) AS SizeOnDiskMBgrowth,
            (f.io_stall_read_ms - fPrior.io_stall_read_ms) AS io_stall_read_ms,
            io_stall_read_ms_average = CASE
                                           WHEN(f.num_of_reads - fPrior.num_of_reads) = 0
                                           THEN 0
                                           ELSE(f.io_stall_read_ms - fPrior.io_stall_read_ms) /     (f.num_of_reads   -           fPrior.num_of_reads)
                                       END,
            (f.num_of_reads - fPrior.num_of_reads) AS num_of_reads,
            (f.bytes_read - fPrior.bytes_read) / 1024.0 / 1024.0 AS megabytes_read,
            (f.io_stall_write_ms - fPrior.io_stall_write_ms) AS io_stall_write_ms,
            io_stall_write_ms_average = CASE
                                            WHEN(f.num_of_writes - fPrior.num_of_writes) = 0
                                            THEN 0
                                            ELSE(f.io_stall_write_ms - fPrior.io_stall_write_ms) /         (f.num_of_writes   -       fPrior.num_of_writes)
                                        END,
            (f.num_of_writes - fPrior.num_of_writes) AS num_of_writes,
            (f.bytes_written - fPrior.bytes_written) / 1024.0 / 1024.0 AS megabytes_written, 
            f.ServerName + CAST(f.CheckDate AS NVARCHAR(50)) AS JoinKey
     FROM   [metrics].[BlitzFirst_FileStats] f
            INNER HASH JOIN CheckDates DATES ON f.CheckDate = DATES.CheckDate
            INNER JOIN [metrics].[BlitzFirst_FileStats] fPrior ON f.ServerName =                 fPrior.ServerName
                                                              AND f.DatabaseID = fPrior.DatabaseID
                                                              AND f.FileID = fPrior.FileID
                                                              AND fPrior.CheckDate =   DATES.PreviousCheckDate

     WHERE  f.num_of_reads >= fPrior.num_of_reads
            AND f.num_of_writes >= fPrior.num_of_writes
            AND DATEDIFF(MI, fPrior.CheckDate, f.CheckDate) BETWEEN 1 AND 60;
GO
/****** Object:  Table [metrics].[BlitzFirst_PerfmonStats]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [metrics].[BlitzFirst_PerfmonStats](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ServerName] [nvarchar](128) NULL,
	[CheckDate] [datetimeoffset](7) NULL,
	[object_name] [nvarchar](128) NOT NULL,
	[counter_name] [nvarchar](128) NOT NULL,
	[instance_name] [nvarchar](128) NULL,
	[cntr_value] [bigint] NULL,
	[cntr_type] [int] NOT NULL,
	[value_delta] [bigint] NULL,
	[value_per_second] [decimal](18, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [metrics].[BlitzFirst_PerfmonStats_Deltas]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [metrics].[BlitzFirst_PerfmonStats_Deltas] AS 
WITH RowDates as
(
        SELECT 
                ROW_NUMBER() OVER (ORDER BY [ServerName], [CheckDate]) ID,
                [CheckDate]
        FROM [metrics].[BlitzFirst_PerfmonStats]
        GROUP BY [ServerName], [CheckDate]
),
CheckDates as
(
        SELECT ThisDate.CheckDate,
               LastDate.CheckDate as PreviousCheckDate
        FROM RowDates ThisDate
        JOIN RowDates LastDate
        ON ThisDate.ID = LastDate.ID + 1
)
SELECT
       pMon.[ServerName]
      ,pMon.[CheckDate]
      ,pMon.[object_name]
      ,pMon.[counter_name]
      ,pMon.[instance_name]
      ,DATEDIFF(SECOND,pMonPrior.[CheckDate],pMon.[CheckDate]) AS ElapsedSeconds
      ,pMon.[cntr_value]
      ,pMon.[cntr_type]
      ,(pMon.[cntr_value] - pMonPrior.[cntr_value]) AS cntr_delta
      ,(pMon.cntr_value - pMonPrior.cntr_value) * 1.0 / DATEDIFF(ss, pMonPrior.CheckDate, pMon.CheckDate) AS cntr_delta_per_second
      ,pMon.ServerName + CAST(pMon.CheckDate AS NVARCHAR(50)) AS JoinKey
  FROM [metrics].[BlitzFirst_PerfmonStats] pMon
  INNER HASH JOIN CheckDates Dates
  ON Dates.CheckDate = pMon.CheckDate
  JOIN [metrics].[BlitzFirst_PerfmonStats] pMonPrior
  ON  Dates.PreviousCheckDate = pMonPrior.CheckDate
      AND pMon.[ServerName]    = pMonPrior.[ServerName]   
      AND pMon.[object_name]   = pMonPrior.[object_name]  
      AND pMon.[counter_name]  = pMonPrior.[counter_name] 
      AND pMon.[instance_name] = pMonPrior.[instance_name]
    WHERE DATEDIFF(MI, pMonPrior.CheckDate, pMon.CheckDate) BETWEEN 1 AND 60;
GO
/****** Object:  View [metrics].[BlitzFirst_PerfmonStats_Actuals]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [metrics].[BlitzFirst_PerfmonStats_Actuals] AS 
WITH PERF_AVERAGE_BULK AS
(
    SELECT ServerName,
           object_name,
           instance_name,
           counter_name,
           CASE WHEN CHARINDEX('(', counter_name) = 0 THEN counter_name ELSE LEFT (counter_name, CHARINDEX('(',counter_name)-1) END    AS   counter_join,
           CheckDate,
           cntr_delta
    FROM   [metrics].[BlitzFirst_PerfmonStats_Deltas]
    WHERE  cntr_type IN(1073874176)
    AND cntr_delta <> 0
),
PERF_LARGE_RAW_BASE AS
(
    SELECT ServerName,
           object_name,
           instance_name,
           LEFT(counter_name, CHARINDEX('BASE', UPPER(counter_name))-1) AS counter_join,
           CheckDate,
           cntr_delta
    FROM   [metrics].[BlitzFirst_PerfmonStats_Deltas]
    WHERE  cntr_type IN(1073939712)
    AND cntr_delta <> 0
),
PERF_AVERAGE_FRACTION AS
(
    SELECT ServerName,
           object_name,
           instance_name,
           counter_name,
           counter_name AS counter_join,
           CheckDate,
           cntr_delta
    FROM   [metrics].[BlitzFirst_PerfmonStats_Deltas]
    WHERE  cntr_type IN(537003264)
    AND cntr_delta <> 0
),
PERF_COUNTER_BULK_COUNT AS
(
    SELECT ServerName,
           object_name,
           instance_name,
           counter_name,
           CheckDate,
           cntr_delta / ElapsedSeconds AS cntr_value
    FROM   [metrics].[BlitzFirst_PerfmonStats_Deltas]
    WHERE  cntr_type IN(272696576, 272696320)
    AND cntr_delta <> 0
),
PERF_COUNTER_RAWCOUNT AS
(
    SELECT ServerName,
           object_name,
           instance_name,
           counter_name,
           CheckDate,
           cntr_value
    FROM   [metrics].[BlitzFirst_PerfmonStats_Deltas]
    WHERE  cntr_type IN(65792, 65536)
)

SELECT NUM.ServerName,
       NUM.object_name,
       NUM.counter_name,
       NUM.instance_name,
       NUM.CheckDate,
       NUM.cntr_delta / DEN.cntr_delta AS cntr_value,
       NUM.ServerName + CAST(NUM.CheckDate AS NVARCHAR(50)) AS JoinKey
       
FROM   PERF_AVERAGE_BULK AS NUM
       JOIN PERF_LARGE_RAW_BASE AS DEN ON NUM.counter_join = DEN.counter_join
                                          AND NUM.CheckDate = DEN.CheckDate
                                          AND NUM.ServerName = DEN.ServerName
                                          AND NUM.object_name = DEN.object_name
                                          AND NUM.instance_name = DEN.instance_name
                                          AND DEN.cntr_delta <> 0

UNION ALL

SELECT NUM.ServerName,
       NUM.object_name,
       NUM.counter_name,
       NUM.instance_name,
       NUM.CheckDate,
       CAST((CAST(NUM.cntr_delta as DECIMAL(19)) / DEN.cntr_delta) as decimal(23,3))  AS cntr_value,
       NUM.ServerName + CAST(NUM.CheckDate AS NVARCHAR(50)) AS JoinKey
FROM   PERF_AVERAGE_FRACTION AS NUM
       JOIN PERF_LARGE_RAW_BASE AS DEN ON NUM.counter_join = DEN.counter_join
                                          AND NUM.CheckDate = DEN.CheckDate
                                          AND NUM.ServerName = DEN.ServerName
                                          AND NUM.object_name = DEN.object_name
                                          AND NUM.instance_name = DEN.instance_name
                                          AND DEN.cntr_delta <> 0
UNION ALL

SELECT ServerName,
       object_name,
       counter_name,
       instance_name,
       CheckDate,
       cntr_value,
       ServerName + CAST(CheckDate AS NVARCHAR(50)) AS JoinKey
FROM   PERF_COUNTER_BULK_COUNT

UNION ALL

SELECT ServerName,
       object_name,
       counter_name,
       instance_name,
       CheckDate,
       cntr_value,
       ServerName + CAST(CheckDate AS NVARCHAR(50)) AS JoinKey
FROM   PERF_COUNTER_RAWCOUNT;
GO
/****** Object:  Table [metrics].[BlitzFirst_WaitStats]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [metrics].[BlitzFirst_WaitStats](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ServerName] [nvarchar](128) NULL,
	[CheckDate] [datetimeoffset](7) NULL,
	[wait_type] [nvarchar](60) NULL,
	[wait_time_ms] [bigint] NULL,
	[signal_wait_time_ms] [bigint] NULL,
	[waiting_tasks_count] [bigint] NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [metrics].[BlitzFirst_WaitStats_Categories]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [metrics].[BlitzFirst_WaitStats_Categories](
	[WaitType] [nvarchar](60) NOT NULL,
	[WaitCategory] [nvarchar](128) NOT NULL,
	[Ignorable] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[WaitType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [metrics].[BlitzFirst_WaitStats_Deltas]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [metrics].[BlitzFirst_WaitStats_Deltas] AS 
WITH RowDates as
(
        SELECT 
                ROW_NUMBER() OVER (ORDER BY [ServerName], [CheckDate]) ID,
                [CheckDate]
        FROM [metrics].[BlitzFirst_WaitStats]
        GROUP BY [ServerName], [CheckDate]
),
CheckDates as
(
        SELECT ThisDate.CheckDate,
               LastDate.CheckDate as PreviousCheckDate
        FROM RowDates ThisDate
        JOIN RowDates LastDate
        ON ThisDate.ID = LastDate.ID + 1
)
SELECT w.ServerName, w.CheckDate, w.wait_type, COALESCE(wc.WaitCategory, 'Other') AS WaitCategory, COALESCE(wc.Ignorable,0) AS Ignorable
, DATEDIFF(ss, wPrior.CheckDate, w.CheckDate) AS ElapsedSeconds
, (w.wait_time_ms - wPrior.wait_time_ms) AS wait_time_ms_delta
, (w.wait_time_ms - wPrior.wait_time_ms) / 60000.0 AS wait_time_minutes_delta
, (w.wait_time_ms - wPrior.wait_time_ms) / 1000.0 / DATEDIFF(ss, wPrior.CheckDate, w.CheckDate) AS wait_time_minutes_per_minute
, (w.signal_wait_time_ms - wPrior.signal_wait_time_ms) AS signal_wait_time_ms_delta
, (w.waiting_tasks_count - wPrior.waiting_tasks_count) AS waiting_tasks_count_delta
, w.ServerName + CAST(w.CheckDate AS NVARCHAR(50)) AS JoinKey
FROM [metrics].[BlitzFirst_WaitStats] w
INNER HASH JOIN CheckDates Dates
ON Dates.CheckDate = w.CheckDate
INNER JOIN [metrics].[BlitzFirst_WaitStats] wPrior ON w.ServerName = wPrior.ServerName AND w.wait_type = wPrior.wait_type AND Dates.PreviousCheckDate = wPrior.CheckDate
LEFT OUTER JOIN [metrics].[BlitzFirst_WaitStats_Categories] wc ON w.wait_type = wc.WaitType
WHERE DATEDIFF(MI, wPrior.CheckDate, w.CheckDate) BETWEEN 1 AND 60
AND [w].[wait_time_ms] >= [wPrior].[wait_time_ms];
GO
/****** Object:  Table [dbo].[ddl_log]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ddl_log](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Database_Name] [nvarchar](50) NOT NULL,
	[Event] [nvarchar](100) NOT NULL,
	[PostTime] [datetime] NOT NULL,
	[TSQL] [nvarchar](2000) NOT NULL,
	[Login_Name] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[IndexUsageStats_LastCumulative]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IndexUsageStats_LastCumulative](
	[ServerNameID] [int] NOT NULL,
	[DatabaseID] [smallint] NOT NULL,
	[ObjectID] [int] NOT NULL,
	[IndexID] [int] NOT NULL,
	[LoadTime] [datetime2](0) NOT NULL,
	[User_Seeks] [bigint] NOT NULL,
	[User_Scans] [bigint] NOT NULL,
	[User_Lookups] [bigint] NOT NULL,
	[User_Updates] [bigint] NOT NULL,
	[System_Seeks] [bigint] NOT NULL,
	[System_Scans] [bigint] NOT NULL,
	[System_Lookups] [bigint] NOT NULL,
	[System_Updates] [bigint] NOT NULL,
 CONSTRAINT [PK_IUS_C] PRIMARY KEY CLUSTERED 
(
	[ServerNameID] ASC,
	[DatabaseID] ASC,
	[ObjectID] ASC,
	[IndexID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Query_Cache]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Query_Cache](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Collection Date] [datetime] NOT NULL,
	[Avg CPU Time (ms)] [bigint] NULL,
	[Last_execution_time] [datetime] NOT NULL,
	[Duration(ms)] [bigint] NULL,
	[Execution Count] [bigint] NULL,
	[Physical Reads] [bigint] NULL,
	[Logical Reads] [bigint] NULL,
	[Logical Writes] [bigint] NULL,
	[Statement Text] [nvarchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Wave_log]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Wave_log](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Database_Name] [nvarchar](260) NOT NULL,
	[Wave_Number] [int] NULL,
	[Src_SchemaName] [nvarchar](260) NOT NULL,
	[Table_Name] [nvarchar](260) NOT NULL,
	[Dst_SchemaName] [nvarchar](260) NOT NULL,
	[Archival_Date] [datetime] NOT NULL,
	[Comment] [varchar](20) NULL,
 CONSTRAINT [PK_WaveLog] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [metrics].[BlitzCache]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [metrics].[BlitzCache](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[ServerName] [nvarchar](258) NULL,
	[CheckDate] [datetimeoffset](7) NULL,
	[Version] [nvarchar](258) NULL,
	[QueryType] [nvarchar](258) NULL,
	[Warnings] [varchar](max) NULL,
	[DatabaseName] [sysname] NOT NULL,
	[SerialDesiredMemory] [float] NULL,
	[SerialRequiredMemory] [float] NULL,
	[AverageCPU] [bigint] NULL,
	[TotalCPU] [bigint] NULL,
	[PercentCPUByType] [money] NULL,
	[CPUWeight] [money] NULL,
	[AverageDuration] [bigint] NULL,
	[TotalDuration] [bigint] NULL,
	[DurationWeight] [money] NULL,
	[PercentDurationByType] [money] NULL,
	[AverageReads] [bigint] NULL,
	[TotalReads] [bigint] NULL,
	[ReadWeight] [money] NULL,
	[PercentReadsByType] [money] NULL,
	[AverageWrites] [bigint] NULL,
	[TotalWrites] [bigint] NULL,
	[WriteWeight] [money] NULL,
	[PercentWritesByType] [money] NULL,
	[ExecutionCount] [bigint] NULL,
	[ExecutionWeight] [money] NULL,
	[PercentExecutionsByType] [money] NULL,
	[ExecutionsPerMinute] [money] NULL,
	[PlanCreationTime] [datetime] NULL,
	[PlanCreationTimeHours]  AS (datediff(hour,[PlanCreationTime],sysdatetime())),
	[LastExecutionTime] [datetime] NULL,
	[PlanHandle] [varbinary](64) NULL,
	[Remove Plan Handle From Cache]  AS (case when [PlanHandle] IS NOT NULL then ('DBCC FREEPROCCACHE ('+CONVERT([varchar](128),[PlanHandle],(1)))+');' else 'N/A' end),
	[SqlHandle] [varbinary](64) NULL,
	[Remove SQL Handle From Cache]  AS (case when [SqlHandle] IS NOT NULL then ('DBCC FREEPROCCACHE ('+CONVERT([varchar](128),[SqlHandle],(1)))+');' else 'N/A' end),
	[SQL Handle More Info]  AS (case when [SqlHandle] IS NOT NULL then ('EXEC sp_BlitzCache @OnlySqlHandles = '''+CONVERT([varchar](128),[SqlHandle],(1)))+'''; ' else 'N/A' end),
	[QueryHash] [binary](8) NULL,
	[Query Hash More Info]  AS (case when [QueryHash] IS NOT NULL then ('EXEC sp_BlitzCache @OnlyQueryHashes = '''+CONVERT([varchar](32),[QueryHash],(1)))+'''; ' else 'N/A' end),
	[QueryPlanHash] [binary](8) NULL,
	[StatementStartOffset] [int] NULL,
	[StatementEndOffset] [int] NULL,
	[MinReturnedRows] [bigint] NULL,
	[MaxReturnedRows] [bigint] NULL,
	[AverageReturnedRows] [money] NULL,
	[TotalReturnedRows] [bigint] NULL,
	[QueryText] [nvarchar](max) NULL,
	[QueryPlan] [xml] NULL,
	[NumberOfPlans] [int] NULL,
	[NumberOfDistinctPlans] [int] NULL,
	[MinGrantKB] [bigint] NULL,
	[MaxGrantKB] [bigint] NULL,
	[MinUsedGrantKB] [bigint] NULL,
	[MaxUsedGrantKB] [bigint] NULL,
	[PercentMemoryGrantUsed] [money] NULL,
	[AvgMaxMemoryGrant] [money] NULL,
	[MinSpills] [bigint] NULL,
	[MaxSpills] [bigint] NULL,
	[TotalSpills] [bigint] NULL,
	[AvgSpills] [money] NULL,
	[QueryPlanCost] [float] NULL,
	[JoinKey]  AS ([ServerName]+CONVERT([nvarchar](50),[CheckDate])),
	[LastCompletionTime] [datetime] NULL,
	[PlanGenerationNum] [bigint] NULL,
 CONSTRAINT [PK_E29C00F4-4581-444D-946B-8F6325E45F78] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [metrics].[BlitzFirst]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [metrics].[BlitzFirst](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ServerName] [nvarchar](128) NULL,
	[CheckDate] [datetimeoffset](7) NULL,
	[CheckID] [int] NOT NULL,
	[Priority] [tinyint] NOT NULL,
	[FindingsGroup] [varchar](50) NOT NULL,
	[Finding] [varchar](200) NOT NULL,
	[URL] [varchar](200) NOT NULL,
	[Details] [nvarchar](4000) NULL,
	[HowToStopIt] [xml] NULL,
	[QueryPlan] [xml] NULL,
	[QueryText] [nvarchar](max) NULL,
	[StartTime] [datetimeoffset](7) NULL,
	[LoginName] [nvarchar](128) NULL,
	[NTUserName] [nvarchar](128) NULL,
	[OriginalLoginName] [nvarchar](128) NULL,
	[ProgramName] [nvarchar](128) NULL,
	[HostName] [nvarchar](128) NULL,
	[DatabaseID] [int] NULL,
	[DatabaseName] [nvarchar](128) NULL,
	[OpenTransactionCount] [int] NULL,
	[DetailsInt] [int] NULL,
	[QueryHash] [binary](8) NULL,
	[JoinKey]  AS ([ServerName]+CONVERT([nvarchar](50),[CheckDate])),
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [perms].[ServerPermissions]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [perms].[ServerPermissions](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[SnapshotID] [bigint] NOT NULL,
	[PermissionName] [nvarchar](128) NOT NULL,
	[PermissionTypeDesc] [nvarchar](60) NOT NULL,
	[LoginName] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_Perms_ServerPermissions] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Wave_log] ADD  DEFAULT ('Archive') FOR [Dst_SchemaName]
GO
ALTER TABLE [dbo].[Wave_log] ADD  DEFAULT (getdate()) FOR [Archival_Date]
GO
ALTER TABLE [metrics].[BlitzFirst_WaitStats_Categories] ADD  DEFAULT ((0)) FOR [Ignorable]
GO
ALTER TABLE [metrics].[DatabaseFileMetrics] ADD  CONSTRAINT [DF_DatabaseFileMetrics_CaptureDate]  DEFAULT (getdate()) FOR [CaptureDate]
GO
ALTER TABLE [metrics].[IndexMetrics] ADD  CONSTRAINT [DF_IndexMetrics_IndexMetricsCheck]  DEFAULT ((0)) FOR [IndexMetricsChecks]
GO
ALTER TABLE [metrics].[IndexMetrics] ADD  CONSTRAINT [DF_IndexMetrics_DateInitiallyChecked]  DEFAULT (getdate()) FOR [DateInitiallyChecked]
GO
ALTER TABLE [metrics].[IndexMetrics] ADD  CONSTRAINT [DF_IndexMetrics_DateLastChecked]  DEFAULT (getdate()) FOR [DateLastChecked]
GO
ALTER TABLE [perms].[Snapshots] ADD  CONSTRAINT [DF_Perms_Snapshots_CaptureDate]  DEFAULT (getdate()) FOR [CaptureDate]
GO
ALTER TABLE [dbo].[IndexUsageStats]  WITH CHECK ADD  CONSTRAINT [FK_IUS_Names_DB] FOREIGN KEY([DatabaseNameID])
REFERENCES [dbo].[Names] ([ID])
GO
ALTER TABLE [dbo].[IndexUsageStats] CHECK CONSTRAINT [FK_IUS_Names_DB]
GO
ALTER TABLE [dbo].[IndexUsageStats]  WITH CHECK ADD  CONSTRAINT [FK_IUS_Names_Index] FOREIGN KEY([IndexNameID])
REFERENCES [dbo].[Names] ([ID])
GO
ALTER TABLE [dbo].[IndexUsageStats] CHECK CONSTRAINT [FK_IUS_Names_Index]
GO
ALTER TABLE [dbo].[IndexUsageStats]  WITH CHECK ADD  CONSTRAINT [FK_IUS_Names_Schema] FOREIGN KEY([SchemaNameID])
REFERENCES [dbo].[Names] ([ID])
GO
ALTER TABLE [dbo].[IndexUsageStats] CHECK CONSTRAINT [FK_IUS_Names_Schema]
GO
ALTER TABLE [dbo].[IndexUsageStats]  WITH CHECK ADD  CONSTRAINT [FK_IUS_Names_Table] FOREIGN KEY([TableNameID])
REFERENCES [dbo].[Names] ([ID])
GO
ALTER TABLE [dbo].[IndexUsageStats] CHECK CONSTRAINT [FK_IUS_Names_Table]
GO
ALTER TABLE [perms].[DatabasePermissions]  WITH CHECK ADD  CONSTRAINT [FK_Perms_DatabasePermissions_Snapshot] FOREIGN KEY([SnapshotID])
REFERENCES [perms].[Snapshots] ([ID])
GO
ALTER TABLE [perms].[DatabasePermissions] CHECK CONSTRAINT [FK_Perms_DatabasePermissions_Snapshot]
GO
ALTER TABLE [perms].[ObjectPermissions]  WITH CHECK ADD  CONSTRAINT [FK_Perms_ObjectPermissions_Snapshot] FOREIGN KEY([SnapshotID])
REFERENCES [perms].[Snapshots] ([ID])
GO
ALTER TABLE [perms].[ObjectPermissions] CHECK CONSTRAINT [FK_Perms_ObjectPermissions_Snapshot]
GO
ALTER TABLE [perms].[RoleMemberships]  WITH CHECK ADD  CONSTRAINT [FK_Perms_RoleMemberships_Snapshot] FOREIGN KEY([SnapshotID])
REFERENCES [perms].[Snapshots] ([ID])
GO
ALTER TABLE [perms].[RoleMemberships] CHECK CONSTRAINT [FK_Perms_RoleMemberships_Snapshot]
GO
ALTER TABLE [perms].[Roles]  WITH CHECK ADD  CONSTRAINT [FK_Perms_Roles_Snapshot] FOREIGN KEY([SnapshotID])
REFERENCES [perms].[Snapshots] ([ID])
GO
ALTER TABLE [perms].[Roles] CHECK CONSTRAINT [FK_Perms_Roles_Snapshot]
GO
ALTER TABLE [perms].[SchemaPermissions]  WITH CHECK ADD  CONSTRAINT [FK_Perms_SchemaPermissions_Snapshot] FOREIGN KEY([SnapshotID])
REFERENCES [perms].[Snapshots] ([ID])
GO
ALTER TABLE [perms].[SchemaPermissions] CHECK CONSTRAINT [FK_Perms_SchemaPermissions_Snapshot]
GO
ALTER TABLE [perms].[ServerPermissions]  WITH CHECK ADD  CONSTRAINT [FK_Perms_ServerPermissions_Snapshot] FOREIGN KEY([SnapshotID])
REFERENCES [perms].[Snapshots] ([ID])
GO
ALTER TABLE [perms].[ServerPermissions] CHECK CONSTRAINT [FK_Perms_ServerPermissions_Snapshot]
GO
ALTER TABLE [perms].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Perms_Users_Snapshot] FOREIGN KEY([SnapshotID])
REFERENCES [perms].[Snapshots] ([ID])
GO
ALTER TABLE [perms].[Users] CHECK CONSTRAINT [FK_Perms_Users_Snapshot]
GO
ALTER TABLE [dbo].[IndexUsageStats]  WITH CHECK ADD  CONSTRAINT [CK_IUS_PositiveValues] CHECK  (([User_Seeks]>=(0) AND [User_Scans]>=(0) AND [user_Lookups]>=(0) AND [user_updates]>=(0) AND [system_seeks]>=(0) AND [system_scans]>=(0) AND [system_lookups]>=(0) AND [system_updates]>=(0)))
GO
ALTER TABLE [dbo].[IndexUsageStats] CHECK CONSTRAINT [CK_IUS_PositiveValues]
GO
/****** Object:  StoredProcedure [dbo].[CollectIndexUsageStats]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- collects usage statistics
-- I run this once daily (can be run more often if you like)
CREATE PROCEDURE [dbo].[CollectIndexUsageStats]
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;
		
		-- get current stats for all online databases
		
		SELECT database_id, name
		INTO #dblist
		FROM sys.databases
		WHERE [state] = 0
			AND database_id != 2; -- skip TempDB
		
		CREATE TABLE #t (
			StatsDate DATETIME2(0),
			ServerName SYSNAME,
			DatabaseID SMALLINT,
			ObjectID INT,
			IndexID INT,
			DatabaseName SYSNAME,
			SchemaName SYSNAME,
			TableName SYSNAME,
			IndexName SYSNAME NULL,
			User_Seeks BIGINT,
			User_Scans BIGINT,
			User_Lookups BIGINT,
			User_Updates BIGINT,
			System_Seeks BIGINT,
			System_Scans BIGINT,
			System_Lookups BIGINT,
			System_Updates BIGINT
		);
		
		DECLARE @DBID INT;
		DECLARE @DBNAME SYSNAME;
		DECLARE @Qry NVARCHAR(2000);

		-- iterate through each DB, generate & run query
		WHILE (SELECT COUNT(*) FROM #dblist) > 0
		BEGIN
			SELECT TOP (1) @DBID=database_id, @DBNAME=[name]
			FROM #dblist ORDER BY database_id;
			
			SET @Qry = '
				INSERT INTO #t
				SELECT
					SYSDATETIME() AS StatsDate,
					@@SERVERNAME AS ServerName,
					s.database_id AS DatabaseID,
					s.object_id AS ObjectID,
					s.index_id AS IndexID,
					''' + @DBNAME + ''' AS DatabaseName,
					c.name AS SchemaName,
					o.name AS TableName,
					i.name AS IndexName,
					s.user_seeks,
					s.user_scans,
					s.user_lookups,
					s.user_updates,
					s.system_seeks,
					s.system_scans,
					s.system_lookups,
					s.system_updates
				FROM sys.dm_db_index_usage_stats s
				INNER JOIN ' + @DBNAME + '.sys.objects o ON s.object_id = o.object_id
				INNER JOIN ' + @DBNAME + '.sys.schemas c ON o.schema_id = c.schema_id
				INNER JOIN ' + @DBNAME + '.sys.indexes i ON s.object_id = i.object_id and s.index_id = i.index_id
				WHERE s.database_id = ' + CONVERT(NVARCHAR,@DBID) + ';
				';
			
			EXEC sp_executesql @Qry;
			
			DELETE FROM #dblist WHERE database_id = @DBID;
		END -- db while loop
		
		DROP TABLE #DBList;
		
		BEGIN TRAN;
		
		-- create ids for Server Name by inserting new ones into dbo.Names
		INSERT INTO DBAUtility.dbo.Names (Value)
		SELECT DISTINCT RTRIM(LTRIM(t.ServerName)) AS ServerName
		FROM #t t
		LEFT JOIN DBAUtility.dbo.Names n ON t.ServerName = n.Value
		WHERE n.ID IS NULL AND t.ServerName IS NOT NULL
		ORDER BY RTRIM(LTRIM(t.ServerName));
		
		-- same as above for DatabaseName
		INSERT INTO DBAUtility.dbo.Names (Value)
		SELECT DISTINCT RTRIM(LTRIM(t.DatabaseName)) AS DatabaseName
		FROM #t t
		LEFT JOIN DBAUtility.dbo.Names n ON t.DatabaseName = n.Value
		WHERE n.ID IS NULL AND t.DatabaseName IS NOT NULL
		ORDER BY RTRIM(LTRIM(t.DatabaseName));
		
		-- SchemaName
		INSERT INTO DBAUtility.dbo.Names (Value)
		SELECT DISTINCT RTRIM(LTRIM(t.SchemaName)) AS SchemaName
		FROM #t t
		LEFT JOIN DBAUtility.dbo.Names n ON t.SchemaName = n.Value
		WHERE n.ID IS NULL AND t.SchemaName IS NOT NULL
		ORDER BY RTRIM(LTRIM(t.SchemaName));
		
		-- TableName
		INSERT INTO DBAUtility.dbo.Names (Value)
		SELECT DISTINCT RTRIM(LTRIM(t.TableName)) AS TableName
		FROM #t t
		LEFT JOIN DBAUtility.dbo.Names n ON t.TableName = n.Value
		WHERE n.ID IS NULL AND t.TableName IS NOT NULL
		ORDER BY RTRIM(LTRIM(t.TableName));
		
		-- IndexName
		INSERT INTO DBAUtility.dbo.Names (Value)
		SELECT DISTINCT RTRIM(LTRIM(t.IndexName)) AS IndexName
		FROM #t t
		LEFT JOIN DBAUtility.dbo.Names n ON t.IndexName = n.Value
		WHERE n.ID IS NULL AND t.IndexName IS NOT NULL
		ORDER BY RTRIM(LTRIM(t.IndexName));
		
		-- Calculate Deltas
		INSERT INTO DBAUtility.dbo.IndexUsageStats (StatsDate, ServerNameID, DatabaseID, ObjectID,
			IndexID, DatabaseNameID, SchemaNameID, TableNameID, IndexNameID, User_Seeks, User_Scans,
			User_Lookups, User_Updates, System_Seeks, System_Scans, System_Lookups, System_Updates)
		SELECT
			t.StatsDate,
			s.ID AS ServerNameID,
			t.DatabaseID,
			t.ObjectID,
			t.IndexID,
			d.ID AS DatabaseNameID,
			c.ID AS SchemaNameID,
			b.ID AS TableNameID,
			i.ID AS IndexNameID,
			CASE
				-- if the previous cumulative value is greater than the current one, the server has been reset
				-- just use the current value
				WHEN t.User_Seeks - ISNULL(lc.User_Seeks,0) < 0 THEN t.User_Seeks
				-- if the prev value is less than the current one, then subtract to get the delta
				ELSE t.User_Seeks - ISNULL(lc.User_Seeks,0)
			END AS User_Seeks,
			CASE
				WHEN t.User_Scans - ISNULL(lc.User_Scans,0) < 0 THEN t.User_Scans
				ELSE t.User_Scans - ISNULL(lc.User_Scans,0)
			END AS User_Scans,
			CASE
				WHEN t.User_Lookups - ISNULL(lc.User_Lookups,0) < 0 THEN t.User_Lookups
				ELSE t.User_Lookups - ISNULL(lc.User_Lookups,0)
			END AS User_Lookups,
			CASE
				WHEN t.User_Updates - ISNULL(lc.User_Updates,0) < 0 THEN t.User_Updates
				ELSE t.User_Updates - ISNULL(lc.User_Updates,0)
			END AS User_Updates,
			CASE
				WHEN t.System_Seeks - ISNULL(lc.System_Seeks,0) < 0 THEN t.System_Seeks
				ELSE t.System_Seeks - ISNULL(lc.System_Seeks,0)
			END AS System_Seeks,
			CASE
				WHEN t.System_Scans - ISNULL(lc.System_Scans,0) < 0 THEN t.System_Scans
				ELSE t.System_Scans - ISNULL(lc.System_Scans,0)
			END AS System_Scans,
			CASE
				WHEN t.System_Lookups - ISNULL(lc.System_Lookups,0) < 0 THEN t.System_Lookups
				ELSE t.System_Lookups - ISNULL(lc.System_Lookups,0)
			END AS System_Lookups,
			CASE
				WHEN t.System_Updates - ISNULL(lc.System_Updates,0) < 0 THEN t.System_Updates
				ELSE t.System_Updates - ISNULL(lc.System_Updates,0)
			END AS System_Updates
		FROM #t t
		INNER JOIN DBAUtility.dbo.Names s ON t.ServerName = s.Value
		INNER JOIN DBAUtility.dbo.Names d ON t.DatabaseName = d.Value
		INNER JOIN DBAUtility.dbo.Names c ON t.SchemaName = c.Value
		INNER JOIN DBAUtility.dbo.Names b ON t.TableName = b.Value
		LEFT JOIN DBAUtility.dbo.Names i ON t.IndexName = i.Value
		LEFT JOIN DBAUtility.dbo.IndexUsageStats_LastCumulative lc
			ON s.ID = lc.ServerNameID
			AND t.DatabaseID = lc.DatabaseID
			AND t.ObjectID = lc.ObjectID
			AND t.IndexID = lc.IndexID
		ORDER BY StatsDate, ServerName, DatabaseID, ObjectID, IndexID;
		
		-- Update last cumulative values with the current ones
		MERGE INTO DBAUtility.dbo.IndexUsageStats_LastCumulative lc
		USING #t t
		INNER JOIN DBAUtility.dbo.Names s ON t.ServerName = s.Value
		ON s.ID = lc.ServerNameID
			AND t.DatabaseID = lc.DatabaseID
			AND t.ObjectID = lc.ObjectID
			AND t.IndexID = lc.IndexID
		WHEN MATCHED THEN
			UPDATE SET 
				lc.LoadTime = t.StatsDate,
				lc.User_Seeks = t.User_Seeks,
				lc.User_Scans = t.User_Scans,
				lc.User_Lookups = t.User_Lookups,
				lc.User_Updates = t.User_Updates,
				lc.System_Seeks = t.System_Seeks,
				lc.System_Scans = t.System_Scans,
				lc.System_Lookups = t.System_Lookups,
				lc.System_Updates = t.System_Updates
		WHEN NOT MATCHED BY TARGET THEN
			INSERT (ServerNameID, DatabaseID, ObjectID, IndexID, LoadTime, User_Seeks, User_Scans, 
				User_Lookups, User_Updates, System_Seeks, System_Scans, 
				System_Lookups, System_Updates)
			VALUES (s.ID, t.DatabaseID, t.ObjectID, t.IndexID, t.StatsDate, t.User_Seeks, t.User_Scans, 
				t.User_Lookups, t.User_Updates, t.System_Seeks, t.System_Scans, 
				t.System_Lookups, t.System_Updates)
		WHEN NOT MATCHED BY SOURCE
			THEN DELETE;
	
		COMMIT TRAN;
	
	END TRY
	BEGIN CATCH
		
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN;
		
		DECLARE @ErrorNumber INT;
		DECLARE @ErrorSeverity INT;
		DECLARE @ErrorState INT;
		DECLARE @ErrorProcedure NVARCHAR(126);
		DECLARE @ErrorLine INT;
		DECLARE @ErrorMessage NVARCHAR(2048);

		SELECT @ErrorNumber = ERROR_NUMBER(),
			   @ErrorSeverity = ERROR_SEVERITY(),
			   @ErrorState = ERROR_STATE(),
			   @ErrorProcedure = ERROR_PROCEDURE(),
			   @ErrorLine = ERROR_LINE(),
			   @ErrorMessage = ERROR_MESSAGE();

		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);

	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[loadIndexStats]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[loadIndexStats]
	@DBName sysname
AS 
/**************************************************************************
	Author: Eric Cobb - http://www.sqlnuggets.com/blog/persist-and-aggregate-index-stats-across-server-restarts
	Purpose: This stored procedure will be used to collect metrics from multiple DMVs over time
		      to determine which indexes in the specified database are useful.  Due to the DMVs being 
			  refreshed with each restart of SQL Server, data is persisted in a database.  
			  This procedure excludes clustered indexes, primary keys and unique indexes.
***************************************************************************/

	SET NOCOUNT ON

	--The following is dynamic so that this stored procedure can reside in any database.

	--Capture server uptime
	DECLARE @sql varchar(max)
	DECLARE @crlf NCHAR(2)

	SET @crlf  = NCHAR(13)+NCHAR(10) 
	SET @sql = '
	USE '+ @DBName +' 
	
	DECLARE @sqlserver_start_time datetime,
			@HoursOnline int

	SELECT @sqlserver_start_time = sqlserver_start_time, @HoursOnline = datediff(hh,sqlserver_start_time, getdate()) from sys.dm_os_sys_info' + @crlf

	--create the MERGE statement
	SET @sql = @sql +  '

		MERGE INTO DBAUtility.dbo.TableActivity AS Target
			USING (
					SELECT  DB_NAME() AS DatabaseName
						  ,SCHEMA_NAME(s.schema_id) AS SchemaName
						  ,OBJECT_NAME(i.OBJECT_ID) AS ObjectName
						  ,i.name AS IndexName
						  ,i.index_id AS IndexID
						  ,COALESCE(ius.user_seeks,-1) AS UserSeek
						  ,COALESCE(ius.user_scans,-1) AS UserScans
						  ,COALESCE(ius.user_lookups,-1) AS UserLookups
						  ,COALESCE(ius.user_updates,-1) AS UserUpdates
						  ,p.TableRows
						  ,CASE 
							 WHEN ps.usedpages > ps.pages THEN (ps.usedpages - ps.pages) ELSE 0 
							 END * 8 / 1024 AS indexsizeMB
						  , ''DROP INDEX '' + QUOTENAME(i.name)
						  + '' ON '' + QUOTENAME(s.name) + ''.'' + QUOTENAME(OBJECT_NAME(i.OBJECT_ID)) AS DropStatement
						  ,1 AS [Count]
						  ,@sqlserver_start_time AS SQLServerStartTime
						  ,@HoursOnline AS hoursOnline 
						  ,GetDate() AS DateChecked
						  ,ius.last_user_seek AS LastUserSeek
						  ,ius.last_user_scan AS LastUserScan
						  ,ius.last_user_lookup AS LastUserLookup
						  ,ius.last_user_update AS LastUserUpdate
						  ,i.is_unique AS isUnique
						  ,i.fill_factor AS [FillFactor]
						  ,i.is_disabled AS isDisabled
				    FROM sys.indexes i
				    LEFT JOIN sys.dm_db_index_usage_stats ius ON ius.index_id = i.index_id AND ius.OBJECT_ID = i.OBJECT_ID
				    INNER JOIN (SELECT sch.name, sch.schema_id, o.OBJECT_ID, o.create_date FROM sys.schemas sch 
								INNER JOIN sys.objects o ON o.schema_id = sch.schema_id) s ON s.OBJECT_ID = i.OBJECT_ID
				    LEFT JOIN (SELECT SUM(p.rows) TableRows, p.index_id, p.OBJECT_ID
								    FROM sys.partitions p GROUP BY p.index_id, p.OBJECT_ID) p ON p.index_id = i.index_id AND i.OBJECT_ID = p.OBJECT_ID
				    LEFT JOIN (SELECT OBJECT_ID, index_id, SUM(used_page_count) AS usedpages,
									   SUM(CASE WHEN (index_id < 2) 
											 THEN (in_row_data_page_count + lob_used_page_count + row_overflow_used_page_count) 
											 ELSE lob_used_page_count + row_overflow_used_page_count 
										  END) AS pages
								    FROM sys.dm_db_partition_stats
								    GROUP BY object_id, index_id) AS ps ON i.object_id = ps.object_id AND i.index_id = ps.index_id
				    WHERE OBJECTPROPERTY(i.OBJECT_ID,''IsUserTable'') = 1
				    AND (ius.database_id = DB_ID() OR ius.database_id IS NULL)
				    --AND i.type_desc = ''nonclustered''
				    --AND i.is_primary_key = 0
				    --AND i.is_unique_constraint = 0
			) AS Source ([DatabaseName],[SchemaName], [ObjectName], [IndexName], [IndexId], [UserSeek], [UserScans], [UserLookups], [UserUpdates], [TableRows], [IndexSizeMB], [DropStatement], [Count], [SQLServerStartTime], [hoursOnline], [DateChecked], [LastUserSeek], [LastUserScan], [LastUserLookup], [LastUserUpdate], [isUnique], [FillFactor], [isDisabled])
			ON ( Target.DropStatement = Source.DropStatement AND Target.SQLServerStartTime = Source.SQLServerStartTime)
			WHEN NOT MATCHED THEN 
				INSERT (
							[DatabaseName],
							[SchemaName] , 
							[ObjectName] ,
							[IndexName] ,
							[IndexID] ,
							[UserSeek] ,
							[UserScans] ,
							[UserLookups] ,
							[UserUpdates] ,
							[TableRows] ,
							[indexsizeMB] ,
							[DropStatement] ,
							[Count],
							[SQLServerStartTime] ,
							[HoursOnline] ,
							[DateInitiallyChecked],
							[DateLastChecked],
							[LastUserSeek],
							[LastUserScan],
							[LastUserLookup],
							[LastUserUpdate],
							[isUnique],
							[FillFactor],
							[isDisabled]
					)
				VALUES
					([DatabaseName], [SchemaName], [ObjectName], [IndexName], [IndexId], [UserSeek], [UserScans], [UserLookups], [UserUpdates], [TableRows], [IndexSizeMB], [DropStatement], [Count], [SQLServerStartTime], [hoursOnline], [DateChecked], [DateChecked],[LastUserSeek],[LastUserScan],[LastUserLookup],[LastUserUpdate],[isUnique],[FillFactor],[isDisabled])
			WHEN MATCHED THEN 
				UPDATE SET
				    target.[UserSeek]  = source.UserSeek,
				    target.[UserScans] = source.UserScans,
				    target.[UserLookups] = source.UserLookups,
				    target.[UserUpdates] = source.UserUpdates,
				    target.[TableRows] = source.TableRows,
				    target.[IndexSizeMB] = source.IndexSizeMB, 
				    target.[Count] = target.[Count] + 1, 
				    target.[DateLastChecked] = GetDate(),  
				    target.HoursOnline = @HoursOnline,
					target.[LastUserSeek] = source.[LastUserSeek],
					target.[LastUserScan] = source.[LastUserScan],
					target.[LastUserLookup] = source.[LastUserLookup],
					target.[LastUserUpdate] = source.[LastUserUpdate],
					target.[isUnique] = source.[isUnique],
					target.[FillFactor] = source.[FillFactor],
					target.[isDisabled] = source.[isDisabled]

		;
'
--run the generated T-SQL
EXEC(@sql)

GO
/****** Object:  StoredProcedure [dbo].[sp_GenerateTransferSchemaStatements]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_GenerateTransferSchemaStatements] 
 @dbname varchar(50),
 @wave_number int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

select 'ALTER SCHEMA' + ' ' + Dst_SchemaName + ' ' + 'TRANSFER' + ' [' + Src_SchemaName +'].['+Table_Name +']'
from dbo.wave_log
where Database_Name = @dbname
and Wave_Number = @wave_number

END
GO
/****** Object:  StoredProcedure [dbo].[sp_HumanEvents]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_HumanEvents]( @event_type sysname = N'query',
                                    @query_duration_ms INTEGER = 500,
                                    @query_sort_order NVARCHAR(10) = N'cpu',
                                    @blocking_duration_ms INTEGER = 500,
                                    @wait_type NVARCHAR(4000) = N'ALL',
                                    @wait_duration_ms INTEGER = 10,
                                    @client_app_name sysname = N'',
                                    @client_hostname sysname = N'',
                                    @database_name sysname = N'',
                                    @session_id NVARCHAR(7) = N'',
                                    @sample_divisor INT = 5,
                                    @username sysname = N'',
                                    @object_name sysname = N'',
                                    @object_schema sysname = N'dbo', 
                                    @requested_memory_mb INTEGER = 0,
                                    @seconds_sample INTEGER = 10,
                                    @gimme_danger BIT = 0,
                                    @keep_alive BIT = 0,
                                    @custom_name NVARCHAR(256) = N'',
                                    @output_database_name sysname = N'',
                                    @output_schema_name sysname = N'dbo',
                                    @delete_retention_days INT = 3,
                                    @cleanup BIT = 0,
                                    @version VARCHAR(30) = NULL OUTPUT,
                                    @version_date DATETIME = NULL OUTPUT,
                                    @debug BIT = 0,
                                    @help BIT = 0 )
WITH RECOMPILE
AS

/*Example:  EXEC dbo.sp_HumanEvents @event_type = 'compilations', @seconds_sample = 60; */

/* If you are looking at high CPU situation, run the below to find recompilation
EXEC dbo.sp_HumanEvents @event_type = 'recompilations', @seconds_sample = 60;*/
BEGIN

SET NOCOUNT, XACT_ABORT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT @version = '1.5', @version_date = '20200501';

IF @help = 1
BEGIN
    /*Warnings, I guess*/
    SELECT N'warning! achtung! peligro! chardonnay!' AS [WARNING WARNING WARNING] UNION ALL 
    SELECT N'misuse of this procedure can harm performance' UNION ALL
    SELECT N'be very careful about introducing observer overhead, especially when gathering query plans' UNION ALL
    SELECT N'be even more careful when setting up permanent sessions!' UNION ALL
    SELECT N'for additional support: http://bit.ly/sp_HumanEvents';
 
 
    /*Introduction*/
    SELECT N'allow me to reintroduce myself' AS introduction UNION ALL
    SELECT N'this can be used to start a time-limited extended event session to capture various things:' UNION ALL
    SELECT N'  * blocking' UNION ALL 
    SELECT N'  * query performance and plans' UNION ALL 
    SELECT N'  * compilations' UNION ALL 
    SELECT N'  * recompilations' UNION ALL 
    SELECT N'  * wait stats'; 


    /*Limitations*/
    SELECT N'frigid shortcomings' AS limitations UNION ALL
    SELECT N'you need to be on at least SQL Server 2012 or higher to run this' UNION ALL
    SELECT REPLICATE(N'-', 100) UNION ALL
    SELECT N'sp_HumanEvents is designed to make getting information from common extended events easier. with that in mind,' UNION ALL
    SELECT N'some of the customization is limited, and right now you can''t just choose your own adventure.' UNION ALL    
    SELECT REPLICATE(N'-', 100) UNION ALL
    SELECT N'because i don''t want to create files, i''m using the ring buffer, which also has some pesky limitations.' UNION ALL
    SELECT N'https://techcommunity.microsoft.com/t5/sql-server-support/you-may-not-see-the-data-you-expect-in-extended-event-ring/ba-p/315838' UNION ALL
    SELECT REPLICATE(N'-', 100) UNION ALL
    SELECT N'in order to use the "blocking" session, you must enable the blocked process report' UNION ALL
    SELECT N'https://docs.microsoft.com/en-us/sql/database-engine/configure-windows/blocked-process-threshold-server-configuration-option';   
 
 
    /*Usage*/
    SELECT ap.name AS parameter,
           t.name,
           CASE ap.name WHEN N'@event_type' THEN N'used to pick which session you want to run'
                        WHEN N'@query_duration_ms' THEN N'(>=) used to set a minimum query duration to collect data for'
                        WHEN N'@query_sort_order' THEN 'when you use the "query" event, lets you choose which metrics to sort results by'
                        WHEN N'@blocking_duration_ms' THEN N'(>=) used to set a minimum blocking duration to collect data for'
                        WHEN N'@wait_type' THEN N'(inclusive) filter to only specific wait types'
                        WHEN N'@wait_duration_ms' THEN N'(>=) used to set a minimum time per wait to collect data for'
                        WHEN N'@client_app_name' THEN N'(inclusive) filter to only specific app names'
                        WHEN N'@client_hostname' THEN N'(inclusive) filter to only specific host names'
                        WHEN N'@database_name' THEN N'(inclusive) filter to only specific databases'
                        WHEN N'@session_id' THEN N'(inclusive) filter to only a specific session id, or a sample of session ids'
                        WHEN N'@sample_divisor' THEN N'the divisor for session ids when sampling a workload, e.g. SPID % 5'
                        WHEN N'@username' THEN N'(inclusive) filter to only a specific user'
                        WHEN N'@object_name' THEN N'(inclusive) to only filter to a specific object name'
                        WHEN N'@object_schema' THEN N'(inclusive) the schema of the object you want to filter to; only needed with blocking events'
                        WHEN N'@requested_memory_mb' THEN N'(>=) the memory grant a query must ask for to have data collected'
                        WHEN N'@seconds_sample' THEN N'the duration in seconds to run the event session for'
                        WHEN N'@gimme_danger' THEN N'used to override default minimums for query, wait, and blocking durations. only use if you''re okay with potentially adding a lot of observer overhead on your system, or for testing purposes.'
                        WHEN N'@debug' THEN N'use to print out dynamic SQL'
                        WHEN N'@keep_alive' THEN N'creates a permanent session, either to watch live or log to a table from'
                        WHEN N'@custom_name' THEN N'if you want to custom name a permanent session'
                        WHEN N'@output_database_name' THEN N'the database you want to log data to'
                        WHEN N'@output_schema_name' THEN N'the schema you want to log data to'
                        WHEN N'@delete_retention_days' THEN N'how many days of logged data you want to keep'
                        WHEN N'@cleanup' THEN N'deletes all sessions, tables, and views. requires output database and schema.'
                        WHEN N'@help' THEN N'well you''re here so you figured this one out'
                        WHEN N'@version' THEN N'to make sure you have the most recent bits'
                        WHEN N'@version_date' THEN N'to make sure you have the most recent bits'
                        ELSE N'????' 
           END AS description,
           CASE ap.name WHEN N'@event_type' THEN N'"blocking", "query", "waits", "recompiles", "compiles" and certain variations on those words'
                        WHEN N'@query_duration_ms' THEN N'an integer'
                        WHEN N'@query_sort_order' THEN '"cpu", "reads", "writes", "duration", "memory", "spills", and you can add "avg" to sort by averages, e.g. "avg cpu"'
                        WHEN N'@blocking_duration_ms' THEN N'an integer'
                        WHEN N'@wait_type' THEN N'a single wait type, or a CSV list of wait types'
                        WHEN N'@wait_duration_ms' THEN N'an integer'
                        WHEN N'@client_app_name' THEN N'a stringy thing'
                        WHEN N'@client_hostname' THEN N'a stringy thing'
                        WHEN N'@database_name' THEN N'a stringy thing'
                        WHEN N'@session_id' THEN N'an integer, or "sample" to sample a workload'
                        WHEN N'@sample_divisor' THEN N'an integer'
                        WHEN N'@username' THEN N'a stringy thing'
                        WHEN N'@object_name' THEN N'a stringy thing'
                        WHEN N'@object_schema' THEN N'a stringy thing'
                        WHEN N'@requested_memory_mb' THEN N'an integer'
                        WHEN N'@seconds_sample' THEN N'an integer'
                        WHEN N'@gimme_danger' THEN N'1 or 0'
                        WHEN N'@debug' THEN N'1 or 0'
                        WHEN N'@keep_alive' THEN N'1 or 0'
                        WHEN N'@custom_name' THEN N'a stringy thing'
                        WHEN N'@output_database_name' THEN N'a valid database name'
                        WHEN N'@output_schema_name' THEN N'a valid schema'
                        WHEN N'@delete_retention_days' THEN N'a POSITIVE integer'
                        WHEN N'@cleanup' THEN N'1 or 0'
                        WHEN N'@help' THEN N'1 or 0'
                        WHEN N'@version' THEN N'none, output'
                        WHEN N'@version_date' THEN N'none, output'
                        ELSE N'????' 
           END AS valid_inputs,
           CASE ap.name WHEN N'@event_type' THEN N'"query"'
                        WHEN N'@query_duration_ms' THEN N'500 (ms)'
                        WHEN N'@query_sort_order' THEN N'"cpu"'
                        WHEN N'@blocking_duration_ms' THEN N'500 (ms)'
                        WHEN N'@wait_type' THEN N'"all", which uses a list of "interesting" waits'
                        WHEN N'@wait_duration_ms' THEN N'10 (ms)'
                        WHEN N'@client_app_name' THEN N'intentionally left blank'
                        WHEN N'@client_hostname' THEN N'intentionally left blank'
                        WHEN N'@database_name' THEN N'intentionally left blank'
                        WHEN N'@session_id' THEN N'intentionally left blank'
                        WHEN N'@sample_divisor' THEN N'5'
                        WHEN N'@username' THEN N'intentionally left blank'
                        WHEN N'@object_name' THEN N'intentionally left blank'
                        WHEN N'@object_schema' THEN N'dbo'
                        WHEN N'@requested_memory_mb' THEN N'0'
                        WHEN N'@seconds_sample' THEN N'10'
                        WHEN N'@gimme_danger' THEN N'0'
                        WHEN N'@keep_alive' THEN N'0'
                        WHEN N'@custom_name' THEN N'intentionally left blank'
                        WHEN N'@output_database_name' THEN N'intentionally left blank'
                        WHEN N'@output_schema_name' THEN N'dbo'
                        WHEN N'@delete_retention_days' THEN N'3 (days)'
                        WHEN N'@debug' THEN N'0'
                        WHEN N'@cleanup' THEN N'0'
                        WHEN N'@help' THEN N'0'
                        WHEN N'@version' THEN N'none, output'
                        WHEN N'@version_date' THEN N'none, output'
                        ELSE N'????' 
           END AS defaults
    FROM sys.all_parameters AS ap
    INNER JOIN sys.all_objects AS o
        ON ap.object_id = o.object_id
    INNER JOIN sys.types AS t
        ON  ap.system_type_id = t.system_type_id
        AND ap.user_type_id = t.user_type_id
    WHERE o.name = N'sp_HumanEvents'
    OPTION(RECOMPILE);


    /*Example calls*/
    SELECT N'EXAMPLE CALLS' AS example_calls UNION ALL    
    SELECT N'note that not all filters are compatible with all sessions' UNION ALL
    SELECT N'this is handled dynamically, but please don''t think you''re crazy if one "doesn''t work"' UNION ALL
    SELECT N'to capture all types of "completed" queries that have run for at least one second for 20 seconds from a specific database' UNION ALL
    SELECT REPLICATE(N'-', 100) UNION ALL
    SELECT N'EXEC dbo.sp_HumanEvents @event_type = ''query'', @query_duration_ms = 1000, @seconds_sample = 20, @database_name = ''YourMom'';' UNION ALL
    SELECT REPLICATE(N'-', 100) UNION ALL
    SELECT N'or that have asked for 1gb of memory' UNION ALL
    SELECT REPLICATE(N'-', 100) UNION ALL
    SELECT N'EXEC dbo.sp_HumanEvents @event_type = ''query'', @query_duration_ms = 1000, @seconds_sample = 20, @requested_memory_mb = 1024;' UNION ALL
    SELECT REPLICATE(N'-', 100) UNION ALL
    SELECT N'maybe you want to find unparameterized queries from a poorly written app' UNION ALL
    SELECT N'newer versions will use sql_statement_post_compile, older versions will use uncached_sql_batch_statistics and sql_statement_recompile' UNION ALL
    SELECT REPLICATE(N'-', 100) UNION ALL
    SELECT N'EXEC dbo.sp_HumanEvents @event_type = ''compilations'', @client_app_name = N''GL00SNIFЯ'', @session_id = ''sample'', @sample_divisor = 3;' UNION ALL
    SELECT REPLICATE(N'-', 100) UNION ALL
    SELECT N'perhaps you think queries recompiling are the cause of your problems!' UNION ALL
    SELECT REPLICATE(N'-', 100) UNION ALL
    SELECT N'EXEC dbo.sp_HumanEvents @event_type = ''recompilations'', @seconds_sample = 30;' UNION ALL
    SELECT REPLICATE(N'-', 100) UNION ALL
    SELECT N'look, blocking is annoying. just turn on RCSI, you goblin.' UNION ALL
    SELECT REPLICATE(N'-', 100) UNION ALL
    SELECT N'EXEC dbo.sp_HumanEvents @event_type = ''blocking'', @seconds_sample = 60, @blocking_duration_ms = 5000;' UNION ALL
    SELECT REPLICATE(N'-', 100) UNION ALL
    SELECT N'i mean wait stats are probably a meme but whatever' UNION ALL
    SELECT REPLICATE(N'-', 100) UNION ALL
    SELECT N'EXEC dbo.sp_HumanEvents @event_type = ''waits'', @wait_duration_ms = 10, @seconds_sample = 100, @wait_type = N''all'';' UNION ALL
    SELECT REPLICATE(N'-', 100) UNION ALL
    SELECT N'note that THREADPOOL is SOS_WORKER in xe-land. why? i dunno.' UNION ALL
    SELECT REPLICATE(N'-', 100) UNION ALL
    SELECT N'EXEC dbo.sp_HumanEvents @event_type = ''waits'', @wait_duration_ms = 10, @seconds_sample = 100, @wait_type = N''SOS_WORKER,RESOURCE_SEMAPHORE,YOUR_MOM'';' UNION ALL
    SELECT REPLICATE(N'-', 100) UNION ALL
    SELECT N'to set up a permanent session for compiles, but you can specify any of the session types here' UNION ALL
    SELECT REPLICATE(N'-', 100) UNION ALL    
    SELECT N'EXEC sp_HumanEvents @event_type = N''compiles'', @debug = 1, @keep_alive = 1;' UNION ALL
    SELECT REPLICATE(N'-', 100) UNION ALL
    SELECT N'to log to a database named whatever, and a schema called dbo' UNION ALL
    SELECT REPLICATE(N'-', 100) UNION ALL    
    SELECT N'EXEC sp_HumanEvents @debug = 1, @output_database_name = N''whatever'', @output_schema_name = N''dbo'';' UNION ALL
    SELECT REPLICATE(N'-', 100);


    /*Views*/
    SELECT N'views that get created when you log to tables' AS views_and_stuff UNION ALL
    SELECT N'these will get created in the same database that your output tables get created in for simplicity' UNION ALL
    SELECT REPLICATE(N'-', 100) UNION ALL
    SELECT N'HumanEvents_Queries: View to look at data pulled from logged queries' UNION ALL
    SELECT REPLICATE(N'-', 100) UNION ALL
    SELECT N'HumanEvents_WaitsByQueryAndDatabase: waits generated grouped by query and database. this is best effort, as the query grouping relies on them being present in the plan cache' UNION ALL
    SELECT N'HumanEvents_WaitsByDatabase: waits generated grouped by database' UNION ALL
    SELECT N'HumanEvents_WaitsTotal: total waits' UNION ALL
    SELECT REPLICATE(N'-', 100) UNION ALL
    SELECT N'HumanEvents_Blocking: view to assemble blocking chains' UNION ALL
    SELECT REPLICATE(N'-', 100) UNION ALL
    SELECT N'HumanEvents_CompilesByDatabaseAndObject: compiles by database and object' UNION ALL
    SELECT N'HumanEvents_CompilesByQuery: compiles by query' UNION ALL
    SELECT N'HumanEvents_CompilesByDuration: compiles by duration length' UNION ALL
    SELECT N'HumanEvents_Compiles_Legacy: compiles on older versions that don''t support new events' UNION ALL
    SELECT REPLICATE(N'-', 100) UNION ALL
    SELECT N'HumanEvents_Parameterization: data collected from the parameterization event' UNION ALL
    SELECT REPLICATE(N'-', 100) UNION ALL
    SELECT N'HumanEvents_RecompilesByDatabaseAndObject: recompiles by database and object' UNION ALL
    SELECT N'HumanEvents_RecompilesByQuery: recompiles by query' UNION ALL
    SELECT N'HumanEvents_RecompilesByDuration: recompiles by long duration' UNION ALL
    SELECT N'HumanEvents_Recompiles_Legacy: recompiles on older versions that don''t support new events' UNION ALL
    SELECT REPLICATE(N'-', 100);


    /*License to F5*/
    SELECT N'i am MIT licensed, so like, do whatever' AS mit_license_yo UNION ALL
    SELECT N'see printed messages for full license';
    RAISERROR(N'
MIT License

Copyright 2020 Darling Data, LLC 

https://www.erikdarlingdata.com/

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 
to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the 
following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION 
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
', 0, 1) WITH NOWAIT; 

RETURN;
END;

BEGIN TRY

/*
I mean really stop it with the unsupported versions
*/
DECLARE @v DECIMAL(5,0);
SELECT  @v = SUBSTRING( CONVERT(NVARCHAR(128), SERVERPROPERTY('ProductVersion')), 
                        1,
                        CHARINDEX('.', CONVERT(NVARCHAR(128), 
                            SERVERPROPERTY('ProductVersion'))) + 1 );
IF @v < 11
    BEGIN
        RAISERROR(N'This darn thing doesn''t seem to work on versions older than 2012.', 16, 1) WITH NOWAIT;
        RETURN;
    END;

/*Checking to see where we're running this thing*/
RAISERROR('Checking for Azure Cloud Nonsense™', 0, 1) WITH NOWAIT;
DECLARE @Azure BIT;
SELECT  @Azure = CASE WHEN CONVERT(NVARCHAR(128), SERVERPROPERTY('Edition')) = N'SQL Azure'
                      THEN 1
                      ELSE 0
                 END;

/*clean up any old/dormant sessions*/
IF EXISTS
(    
    SELECT 1/0
    FROM sys.server_event_sessions AS ses
    LEFT JOIN sys.dm_xe_sessions AS dxe
        ON dxe.name = ses.name
    WHERE ses.name LIKE N'HumanEvents%'
    AND   ( dxe.create_time < DATEADD(MINUTE, -1, SYSDATETIME())
    OR      dxe.create_time IS NULL ) 
)
BEGIN 
    RAISERROR(N'Found old sessions, dropping those.', 0, 1) WITH NOWAIT;
    
    DECLARE @drop_old_sql  NVARCHAR(1000) = N'';
    
    CREATE TABLE #drop_commands ( id INT IDENTITY PRIMARY KEY, 
                                  drop_command NVARCHAR(1000) );
    
    INSERT #drop_commands WITH (TABLOCK) (drop_command)
    SELECT N'DROP EVENT SESSION '  + ses.name + N' ON SERVER;'
    FROM sys.server_event_sessions AS ses
    LEFT JOIN sys.dm_xe_sessions AS dxe
        ON dxe.name = ses.name
    WHERE ses.name LIKE N'HumanEvents%'
    AND   ( dxe.create_time < DATEADD(MINUTE, -1, SYSDATETIME())
    OR      dxe.create_time IS NULL ) 
    OPTION(RECOMPILE);

    DECLARE drop_cursor CURSOR LOCAL STATIC FOR
    SELECT  drop_command FROM #drop_commands;
    
    OPEN drop_cursor;
    FETCH NEXT FROM drop_cursor 
        INTO @drop_old_sql;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN             
        PRINT @drop_old_sql;
        EXEC(@drop_old_sql);    
        FETCH NEXT FROM drop_cursor 
            INTO @drop_old_sql;
    END;
    
    CLOSE drop_cursor;
    DEALLOCATE drop_cursor;
END;

RAISERROR(N'Setting up some variables', 0, 1) WITH NOWAIT;
--How long we let the session run
DECLARE @waitfor NVARCHAR(20) = N'';

--Give sessions super unique names in case more than one person uses it at a time
DECLARE @session_name NVARCHAR(512) = N'';
IF @keep_alive = 0
BEGIN
    SET @session_name += REPLACE(N'HumanEvents_' + @event_type + N'_' + CONVERT(NVARCHAR(36), NEWID()), N'-', N''); 
END;
IF @keep_alive = 1
BEGIN
    SET @session_name += N'keeper_HumanEvents_'  + @event_type + CASE WHEN @custom_name <> N'' THEN N'_' + @custom_name ELSE N'' END;
END;

--Universal, yo
DECLARE @session_with NVARCHAR(MAX) = N'    
ADD TARGET package0.ring_buffer
        ( SET max_memory = 102400 )
WITH
        (
            MAX_MEMORY = 102400KB,
            EVENT_RETENTION_MODE = ALLOW_SINGLE_EVENT_LOSS,
            MAX_DISPATCH_LATENCY = 5 SECONDS,
            MAX_EVENT_SIZE = 0KB,
            MEMORY_PARTITION_MODE = PER_CPU,
            TRACK_CAUSALITY = OFF,
            STARTUP_STATE = OFF
        );' + NCHAR(10);

--I guess we need to do this, too
DECLARE @session_sql NVARCHAR(MAX) = N'';
SELECT  @session_sql = CASE WHEN @Azure = 0
                            THEN N'
CREATE EVENT SESSION ' + @session_name + N'
    ON SERVER '
                            ELSE N'
CREATE EVENT SESSION ' + @session_name + N'
    ON DATABASE '
                       END;

-- STOP. DROP. SHUT'EM DOWN OPEN UP SHOP.
DECLARE @start_sql NVARCHAR(MAX) = N'ALTER EVENT SESSION ' + @session_name + N' ON SERVER STATE = START;' + NCHAR(10);
DECLARE @stop_sql  NVARCHAR(MAX) = N'ALTER EVENT SESSION ' + @session_name + N' ON SERVER STATE = STOP;' + NCHAR(10);
DECLARE @drop_sql  NVARCHAR(MAX) = N'DROP EVENT SESSION '  + @session_name + N' ON SERVER;' + NCHAR(10);


/*Some sessions can use all general filters*/
DECLARE @session_filter NVARCHAR(MAX) = NCHAR(10) + N'            sqlserver.is_system = 0 ' + NCHAR(10);
/*Others can't use all of them, like app and host name*/
DECLARE @session_filter_limited NVARCHAR(MAX) = NCHAR(10) + N'            sqlserver.is_system = 0 ' + NCHAR(10);
/*query plans can filter on requested memory, too, along with the limited filters*/
DECLARE @session_filter_query_plans NVARCHAR(MAX) = NCHAR(10) + N'            sqlserver.is_system = 0 ' + NCHAR(10);
/*only wait stats can filter on wait types, but can filter on everything else*/
DECLARE @session_filter_waits NVARCHAR(MAX) = NCHAR(10) + N'            sqlserver.is_system = 0 ' + NCHAR(10);
/*only wait stats can filter on wait types, but can filter on everything else*/
DECLARE @session_filter_recompile NVARCHAR(MAX) = NCHAR(10) + N'            sqlserver.is_system = 0 ' + NCHAR(10);
/*sql_statement_completed can do everything except object name*/
DECLARE @session_filter_statement_completed NVARCHAR(MAX) = NCHAR(10) + N'            sqlserver.is_system = 0 ' + NCHAR(10);
/*for blocking because blah blah*/
DECLARE @session_filter_blocking NVARCHAR(MAX) = NCHAR(10) + N'         sqlserver.is_system = 1 ' + NCHAR(10);
/*for parameterization because blah blah*/
DECLARE @session_filter_parameterization NVARCHAR(MAX) = NCHAR(10) + N'            sqlserver.is_system = 0 ' + NCHAR(10);


/*
Create one filter per possible input.
This allows us to construct specific filters later.
*/
DECLARE @query_duration_filter NVARCHAR(MAX) = N'';
DECLARE @blocking_duration_ms_filter NVARCHAR(MAX) = N'';
DECLARE @wait_type_filter NVARCHAR(MAX) = N'';
DECLARE @wait_duration_filter NVARCHAR(MAX) = N'';
DECLARE @client_app_name_filter NVARCHAR(MAX) = N'';
DECLARE @client_hostname_filter NVARCHAR(MAX) = N'';
DECLARE @database_name_filter NVARCHAR(MAX) = N'';
DECLARE @session_id_filter NVARCHAR(MAX) = N'';
DECLARE @username_filter NVARCHAR(MAX) = N'';
DECLARE @object_name_filter NVARCHAR(MAX) = N'';
DECLARE @requested_memory_mb_filter NVARCHAR(MAX) = N'';

RAISERROR(N'Checking for some event existence', 0, 1) WITH NOWAIT;
--Determines if we use the new event or the old event(s) to track compiles
DECLARE @compile_events BIT = 0;
IF EXISTS
(
    SELECT 1/0 
    FROM sys.dm_xe_objects AS dxo 
    WHERE dxo.name = N'sql_statement_post_compile'
)
BEGIN 
    SET @compile_events = 1; 
END;


--Or if we use this event at all!
DECLARE @parameterization_events BIT = 0;
IF EXISTS
(
    SELECT 1/0 
    FROM sys.dm_xe_objects AS dxo 
    WHERE dxo.name = N'query_parameterization_data'
)
BEGIN 
    SET @parameterization_events = 1; 
END;


--A new thing suggested by Mikael Eriksson
DECLARE @x XML;


/*
You know what I don't wanna deal with? NULLs.
*/
RAISERROR(N'Nixing NULLs', 0, 1) WITH NOWAIT;
SET @event_type            = ISNULL(@event_type, N'');
SET @client_app_name       = ISNULL(@client_app_name, N'');
SET @client_hostname       = ISNULL(@client_hostname, N'');
SET @database_name         = ISNULL(@database_name, N'');
SET @session_id            = ISNULL(@session_id, N'');
SET @username              = ISNULL(@username, N'');
SET @object_name           = ISNULL(@object_name, N'');
SET @object_schema         = ISNULL(@object_schema, N'');
SET @custom_name           = ISNULL(@custom_name, N'');
SET @output_database_name  = ISNULL(@output_database_name, N'');
SET @output_schema_name    = ISNULL(@output_schema_name, N'');

/*I'm also very forgiving of some white space*/
SET @database_name = RTRIM(LTRIM(@database_name));

/*Assemble the full object name for easier wrangling*/
DECLARE @fully_formed_babby NVARCHAR(1000) = QUOTENAME(@database_name) + N'.' + 
                                             QUOTENAME(@object_schema) + N'.' + 
                                             QUOTENAME(@object_name);

/*
Some sanity checking
*/
RAISERROR(N'Sanity checking event types', 0, 1) WITH NOWAIT;
--You can only do this right now.
IF LOWER(@event_type) NOT IN 
        ( N'waits',
          N'blocking',
          N'locking',
          N'queries',
          N'compiles',
          N'recompiles',
          N'wait',
          N'block',
          N'blocks',
          N'lock',
          N'locks',
          N'query',
          N'compile',
          N'recompile',
          N'compilation',
          N'recompilation',
          N'compilations',
          N'recompilations' )
BEGIN
    RAISERROR(N'You have chosen a value for @event_type... poorly. use @help = 1 to see valid arguments.', 16, 1) WITH NOWAIT;
    RAISERROR(N'What on earth is %s?', 16, 1, @event_type) WITH NOWAIT;
    RETURN;
END;


RAISERROR(N'Checking query duration filter', 0, 1) WITH NOWAIT;
--Set these durations to non-crazy numbers unless someone asks for @gimme_danger = 1
--ignore compile and recompile because this is a filter on query compilation time 🙄
IF ( LOWER(@event_type) LIKE N'%quer%' AND @event_type NOT LIKE N'%comp%'
     AND @gimme_danger = 0 )
     AND (@query_duration_ms < 500 OR @query_duration_ms IS NULL )
BEGIN
    RAISERROR(N'You chose a really dangerous value for @query_duration', 0, 1) WITH NOWAIT;
    RAISERROR(N'If you really want that, please set @gimme_danger = 1, and re-run', 0, 1) WITH NOWAIT;
    RAISERROR(N'Setting @query_duration to 500', 0, 1) WITH NOWAIT;
    SET @query_duration_ms = 500;
END;


RAISERROR(N'Checking wait duration filter', 0, 1) WITH NOWAIT;
IF ( LOWER(@event_type) LIKE N'%wait%' 
     AND @gimme_danger = 0 )
     AND (@wait_duration_ms < 10 OR @wait_duration_ms IS NULL ) 
BEGIN
    RAISERROR(N'You chose a really dangerous value for @wait_duration_ms', 0, 1) WITH NOWAIT;
    RAISERROR(N'If you really want that, please set @gimme_danger = 1, and re-run', 0, 1) WITH NOWAIT;
    RAISERROR(N'Setting @wait_duration_ms to 10', 0, 1) WITH NOWAIT;
    SET @wait_duration_ms = 10;
END;


RAISERROR(N'Checking block duration filter', 0, 1) WITH NOWAIT;
IF ( LOWER(@event_type) LIKE N'%lock%' 
     AND @gimme_danger = 0 )
     AND (@blocking_duration_ms < 500 OR @blocking_duration_ms IS NULL ) 
BEGIN
    RAISERROR(N'You chose a really dangerous value for @blocking_duration_ms', 0, 1) WITH NOWAIT;
    RAISERROR(N'If you really want that, please set @gimme_danger = 1, and re-run', 0, 1) WITH NOWAIT;
    RAISERROR(N'Setting @blocking_duration_ms to 500', 0, 1) WITH NOWAIT;
    SET @blocking_duration_ms = 500;
END;


RAISERROR(N'Checking query sort order', 0, 1) WITH NOWAIT;
IF @query_sort_order NOT IN ( N'cpu', N'reads', N'writes', N'duration', N'memory', N'spills',
                              N'avg cpu', N'avg reads', N'avg writes', N'avg duration', N'avg memory', N'avg spills' )
BEGIN
   RAISERROR(N'That sort order (%s) you chose is so out of this world that i''m ignoring it', 0, 1, @query_sort_order) WITH NOWAIT;
   SET @query_sort_order = N'cpu';
END;


RAISERROR(N'Parsing any supplied waits', 0, 1) WITH NOWAIT;
SET @wait_type = UPPER(@wait_type);
--This will hold the CSV list of wait types someone passes in
CREATE TABLE #user_waits(wait_type NVARCHAR(60));
INSERT #user_waits
SELECT LTRIM(RTRIM(waits.wait_type)) AS wait_type
FROM
(
    SELECT wait_type = x.x.value('(./text())[1]', 'NVARCHAR(60)')
    FROM 
    ( 
      SELECT wait_type =  CONVERT(XML, N'<x>' 
                        + REPLACE(REPLACE(@wait_type, N',', N'</x><x>'), N' ', N'') 
                        + N'</x>').query('.')
    ) AS w 
        CROSS APPLY wait_type.nodes('x') AS x(x)
) AS waits
WHERE @wait_type <> N'ALL'
OPTION(RECOMPILE);


/*
If someone is passing in specific waits, let's make sure that
they're valid waits by checking them against what's available.
*/
IF @wait_type <> N'ALL'
BEGIN
RAISERROR(N'Checking wait validity', 0, 1) WITH NOWAIT;

    --There's no THREADPOOL in XE map values, it gets registered as SOS_WORKER
    SET @wait_type = REPLACE(@wait_type, N'THREADPOOL', N'SOS_WORKER');

    SELECT DISTINCT uw.wait_type AS invalid_waits
    INTO #invalid_waits
    FROM #user_waits AS uw
    WHERE NOT EXISTS
    (
        SELECT 1/0
        FROM sys.dm_xe_map_values AS dxmv
        WHERE  dxmv.map_value COLLATE Latin1_General_BIN = uw.wait_type COLLATE Latin1_General_BIN
        AND    dxmv.name = N'wait_types'
    )
    OPTION(RECOMPILE);
    
    /*If we find any invalid waits, let people know*/
    IF @@ROWCOUNT > 0    
    BEGIN
        SELECT N'You have chosen some invalid wait types' AS invalid_waits
        UNION ALL
        SELECT iw.invalid_waits
        FROM #invalid_waits AS iw
        OPTION(RECOMPILE);
        
        RAISERROR(N'Waidaminnithataintawait', 16, 1) WITH NOWAIT;
        RETURN;
    END;

END;


/*
If someone is passing in non-blank values, let's try to limit our SQL injection exposure a little bit
*/
IF 
    ( @client_app_name <> N''
      OR @client_hostname <> N''
      OR @database_name <> N''
      OR @session_id <> N''
      OR @username <> N''
      OR @object_name <> N''
      OR @object_schema NOT IN (N'dbo', N'') 
      OR @custom_name <> N''       
      OR @output_database_name <> N''
      OR @output_schema_name NOT IN (N'dbo', N'') )
BEGIN
RAISERROR(N'Checking for unsanitary inputs', 0, 1) WITH NOWAIT;

    CREATE TABLE #papers_please(ahem sysname);
    INSERT #papers_please
    SELECT UPPER(pp.ahem)
    FROM (
    VALUES
        (@client_app_name),
        (@client_hostname),
        (@database_name),
        (@session_id),
        (@username),
        (@object_name),
        (@object_schema),
        (@custom_name),
        (@output_database_name),
        (@output_schema_name)
    ) AS pp (ahem)
    WHERE pp.ahem NOT IN (N'', N'dbo')
    OPTION(RECOMPILE);

    IF EXISTS
    (
        SELECT 1/0
        FROM #papers_please AS pp
        WHERE pp.ahem LIKE N'%SELECT%'
        OR    pp.ahem LIKE N'%INSERT%'
        OR    pp.ahem LIKE N'%UPDATE%'
        OR    pp.ahem LIKE N'%DELETE%'
        OR    pp.ahem LIKE N'%DROP%'
        OR    pp.ahem LIKE N'%EXEC%'
        OR    pp.ahem LIKE N'%BACKUP%'
        OR    pp.ahem LIKE N'%RESTORE%'
        OR    pp.ahem LIKE N'%ALTER%'
        OR    pp.ahem LIKE N'%CREATE%'
        OR    pp.ahem LIKE N'%SHUTDOWN%'
        OR    pp.ahem LIKE N'%DBCC%'
        OR    pp.ahem LIKE N'%CONFIGURE%'
        OR    pp.ahem LIKE N'%XP[_]CMDSHELL%'
    )
    BEGIN
        RAISERROR(N'Say... you wouldn''t happen to be trying some funny business, would you?', 16, 1) WITH NOWAIT;
        RETURN;
    END;

END;


/*
I just don't want anyone to be disappointed
*/
RAISERROR(N'Avoiding disappointment', 0, 1) WITH NOWAIT;
IF ( @wait_type <> N'' AND @wait_type <> N'ALL' AND LOWER(@event_type) NOT LIKE N'%wait%' )
BEGIN
    RAISERROR(N'You can''t filter on wait stats unless you use the wait stats event.', 16, 1) WITH NOWAIT;
    RETURN;
END;


/*
This is probably important, huh?
*/
RAISERROR(N'Are we trying to filter for a blocking session?', 0, 1) WITH NOWAIT;
--blocking events need a database name to resolve objects
IF ( LOWER(@event_type) LIKE N'%lock%' AND DB_ID(@database_name) IS NULL AND @object_name <> N'' )
BEGIN
    RAISERROR(N'The blocking event can only filter on an object_id, and we need a valid @database_name to resolve it correctly.', 16, 1) WITH NOWAIT;
    RETURN;
END;

--but could we resolve the object name?
IF ( LOWER(@event_type) LIKE N'%lock%' AND @object_name <> N'' AND OBJECT_ID(@fully_formed_babby) IS NULL )
BEGIN
    RAISERROR(N'We couldn''t find the object you''re trying to find: %s', 16, 1, @fully_formed_babby) WITH NOWAIT;
    RETURN;
END;

--no blocked process report, no love
RAISERROR(N'Validating if the Blocked Process Report is on, if the session is for blocking', 0, 1) WITH NOWAIT;
IF @event_type LIKE N'%lock%'
AND  EXISTS
(
    SELECT 1/0
    FROM sys.configurations AS c
    WHERE c.name = N'blocked process threshold (s)'
    AND CONVERT(INT, c.value_in_use) = 0
)
BEGIN
        RAISERROR(N'You need to set up the blocked process report in order to use this:
    EXEC sys.sp_configure ''show advanced options'', 1;
    GO
    RECONFIGURE
    GO
    EXEC sys.sp_configure ''blocked process threshold'', 5; --Seconds of blocking before a report is generated
    GO
    RECONFIGURE
    GO', 1, 0) WITH NOWAIT;
    RETURN;
END;

--validatabase name
RAISERROR(N'If there''s a database filter, is the name valid?', 0, 1) WITH NOWAIT;
IF @database_name <> N''
BEGIN
    IF DB_ID(@database_name) IS NULL
    BEGIN
        RAISERROR(N'It looks like you''re looking for a database that doesn''t wanna be looked for (%s) -- check that spelling!', 16, 1, @database_name) WITH NOWAIT;
        RETURN;
    END;
END;


--session id has be be "sampled" or a number.
RAISERROR(N'If there''s a session id filter, is it valid?', 0, 1) WITH NOWAIT;
IF LOWER(@session_id) NOT LIKE N'%sample%' AND @session_id LIKE '%[^0-9]%' AND LOWER(@session_id) <> N''
BEGIN
   RAISERROR(N'That @session_id doesn''t look proper (%s). double check it for me.', 16, 1, @session_id) WITH NOWAIT;
   RETURN;
END;


--some numbers won't be effective as sample divisors
RAISERROR(N'No dividing by zero', 0, 1) WITH NOWAIT;
IF @sample_divisor < 2 AND LOWER(@session_id) LIKE N'%sample%'
BEGIN
    RAISERROR(N'@sample_divisor is used to divide @session_id when taking a sample of a workload.', 16, 1) WITH NOWAIT;
    RAISERROR(N'we can''t really divide by zero, and dividing by 1 would be useless.', 16, 1) WITH NOWAIT;
    RETURN;
END;


/*
We need to do some seconds math here, because WAITFOR is very stupid
*/
RAISERROR(N'Wait For It! Wait For it!', 0, 1) WITH NOWAIT;
IF @seconds_sample > 1
BEGIN
DECLARE @math INT = 0;
SET @math = @seconds_sample / 60;
    
    --I really don't want this running for more than 10 minutes right now.
    IF ( @math > 9 AND @gimme_danger = 0 )
    BEGIN
        RAISERROR(N'Yeah nah not more than 10 minutes', 16, 1) WITH NOWAIT;
        RAISERROR(N'(unless you set @gimme_danger = 1)', 16, 1) WITH NOWAIT;
        RETURN;
    END;
    
    -- Fun fact: running WAITFOR DELAY '00:00:60.000' throws an error
    -- If we have over 60 seconds, we need to populate the minutes section
    IF ( @math < 10 AND @math >= 1 )
    BEGIN
        DECLARE @minutes INT;
        DECLARE @seconds INT;
        
        SET @minutes = @seconds_sample / 60;
        SET @seconds = @seconds_sample % 60;
        SET @waitfor = N'00:' 
                     + CONVERT(NVARCHAR(11), RIGHT(N'00' + RTRIM(@minutes), 2))
                     + N':'
                     + CONVERT(NVARCHAR(11), RIGHT(N'00' + RTRIM(@seconds), 2))
                     + N'.000';
    END;
    
    --Only if we have 59 seconds or less can we use seconds only
    IF ( @math = 0 )
    BEGIN
        DECLARE @seconds_ INT;        
        SET @seconds_ = @seconds_sample % 60;        
        SET @waitfor  = N'00:' 
                      + N'00'
                      + N':'
                      + CONVERT(NVARCHAR(11), RIGHT(N'00' + RTRIM(@seconds_), 2))
                      + N'.000';        
    END;
END;


/*
CH-CH-CH-CHECK-IT-OUT
*/
--check for existing session with the same name
RAISERROR(N'Make sure the session doesn''t exist already', 0, 1) WITH NOWAIT;
IF EXISTS
(
    SELECT 1/0
    FROM sys.server_event_sessions AS ses
    LEFT JOIN sys.dm_xe_sessions AS dxs 
        ON dxs.name = ses.name
    WHERE ses.name = @session_name
)
BEGIN
    RAISERROR('A session with the name %s already exists. dropping.', 0, 1, @session_name) WITH NOWAIT;
    EXEC sys.sp_executesql @drop_sql;
END;


--check that the output database exists
RAISERROR(N'Does the output database exist?', 0, 1) WITH NOWAIT;
IF @output_database_name <> N''
BEGIN
    IF DB_ID(@output_database_name) IS NULL
    BEGIN
        RAISERROR(N'It looks like you''re looking for a database (%s) that doesn''t wanna be looked for -- check that spelling!', 16, 1, @output_database_name) WITH NOWAIT;
        RETURN;
    END;
END;


--check that the output schema exists
RAISERROR(N'Does the output schema exist?', 0, 1) WITH NOWAIT;
IF @output_schema_name NOT IN (N'dbo', N'')
BEGIN
    DECLARE @s_out INT,
            @schema_check BIT,
            @s_sql NVARCHAR(MAX) = N'
    SELECT @is_out = COUNT(*) 
    FROM ' + QUOTENAME(@output_database_name) + N'.sys.schemas
    WHERE name = ' + QUOTENAME(@output_schema_name, '''') + N' 
    OPTION (RECOMPILE);',
            @s_params NVARCHAR(MAX) = N'@is_out INT OUTPUT';
    
    EXEC sys.sp_executesql @s_sql, @s_params, @is_out = @s_out OUTPUT;
    
    IF @s_out = 0
    BEGIN
        RAISERROR(N'It looks like the schema %s doesn''t exist in the database %s', 16, 1, @output_schema_name, @output_database_name);
        RETURN;
    END;
END;
 

--we need an output schema and database
RAISERROR(N'Is output database OR schema filled in?', 0, 1) WITH NOWAIT;
IF LEN(@output_database_name + @output_schema_name) > 0
 AND @output_schema_name <> N'dbo'
 AND ( @output_database_name  = N'' 
       OR @output_schema_name = N'' )
BEGIN
    IF @output_database_name = N''
        BEGIN
            RAISERROR(N'@output_database_name can''t blank when outputting to tables or cleaning up', 16, 1) WITH NOWAIT;
            RETURN;
        END;
    
    IF @output_schema_name = N''
        BEGIN
            RAISERROR(N'@output_schema_name can''t blank when outputting to tables or cleaning up', 16, 1) WITH NOWAIT;
            RETURN;
        END;
END;


--no goofballing in custom names
RAISERROR(N'Is custom name something stupid?', 0, 1) WITH NOWAIT;
IF ( PATINDEX(N'%[^a-zA-Z0-9]%', @custom_name) > 0 
     OR @custom_name LIKE N'[0-9]%' )
BEGIN
    RAISERROR(N'Dunno if I like the looks of @custom_name: %s', 16, 1, @custom_name) WITH NOWAIT;
    RAISERROR(N'You can''t use special characters, or leading numbers.', 16, 1, @custom_name) WITH NOWAIT;
    RETURN;
END;


--I'M LOOKING AT YOU
RAISERROR(N'Someone is going to try it.', 0, 1) WITH NOWAIT;
IF @delete_retention_days < 0
BEGIN
    SET @delete_retention_days *= -1;
    RAISERROR(N'Stay positive', 0, 1) WITH NOWAIT;
END;


/*
If we're writing to a table, we don't want to do anything else
Or anything else after this, really
We want the session to get set up
*/
RAISERROR(N'Do we skip to the GOTO and log tables?', 0, 1) WITH NOWAIT;
IF ( @output_database_name <> N''
     AND @output_schema_name <> N''
     AND @cleanup = 0 )
BEGIN
    RAISERROR(N'Skipping all the other stuff and going to data logging', 0, 1) WITH NOWAIT;    
    
    CREATE TABLE #human_events_xml_internal (human_events_xml XML);        
    
    GOTO output_results;
    RETURN;
END;


--just finishing up the second coat now
RAISERROR(N'Do we skip to the GOTO and cleanup?', 0, 1) WITH NOWAIT;
IF ( @output_database_name <> N''
     AND @output_schema_name <> N''
     AND @cleanup = 1 )
BEGIN
    RAISERROR(N'Skipping all the other stuff and going to cleanup', 0, 1) WITH NOWAIT;       
    
    GOTO cleanup;
    RETURN;
END;


/*
Start setting up individual filters
*/
RAISERROR(N'Setting up individual filters', 0, 1) WITH NOWAIT;
IF @query_duration_ms > 0
BEGIN
    IF LOWER(@event_type) NOT LIKE N'%comp%' --compile and recompile durations are tiny
    BEGIN
        SET @query_duration_filter += N'     AND duration >= ' + CONVERT(NVARCHAR(20), (@query_duration_ms * 1000)) + NCHAR(10);
    END;
END;

IF @blocking_duration_ms > 0
BEGIN
    SET @blocking_duration_ms_filter += N'     AND duration >= ' + CONVERT(NVARCHAR(20), (@blocking_duration_ms * 1000)) + NCHAR(10);
END;

IF @wait_duration_ms > 0
BEGIN
    SET @wait_duration_filter += N'     AND duration >= ' + CONVERT(NVARCHAR(20), (@wait_duration_ms)) + NCHAR(10);
END;

IF @client_app_name <> N''
BEGIN
    SET @client_app_name_filter += N'     AND sqlserver.client_app_name = N' + QUOTENAME(@client_app_name, '''') + NCHAR(10);
END;

IF @client_hostname <> N''
BEGIN
    SET @client_hostname_filter += N'     AND sqlserver.client_hostname = N' + QUOTENAME(@client_hostname, '''') + NCHAR(10);
END;

IF @database_name <> N''
BEGIN
    IF LOWER(@event_type) NOT LIKE N'%lock%'
    BEGIN
        SET @database_name_filter += N'     AND sqlserver.database_name = N' + QUOTENAME(@database_name, '''') + NCHAR(10);
    END;
    IF LOWER(@event_type) LIKE N'%lock%'
    BEGIN
        SET @database_name_filter += N'     AND database_name = N' + QUOTENAME(@database_name, '''') + NCHAR(10);
    END;
END;

IF @session_id <> N''
BEGIN
    IF LOWER(@session_id) NOT LIKE N'%sample%'
        BEGIN
            SET @session_id_filter += N'     AND sqlserver.session_id = ' + CONVERT(NVARCHAR(11), @session_id) + NCHAR(10);
        END;
    IF LOWER(@session_id) LIKE N'%sample%'
        BEGIN
            SET @session_id_filter += N'     AND package0.divides_by_uint64(sqlserver.session_id, ' + CONVERT(NVARCHAR(11), @sample_divisor) + N') ' + NCHAR(10);
        END;
END;

IF @username <> N''
BEGIN
    SET @username_filter += N'     AND sqlserver.username = N' + QUOTENAME(@username, '''') + NCHAR(10);
END;

IF @object_name <> N''
BEGIN
    IF @event_type LIKE N'%lock%'
    BEGIN
        DECLARE @object_id sysname;
        SET @object_id = OBJECT_ID(@fully_formed_babby);
        SET @object_name_filter += N'     AND object_id = ' + @object_id + NCHAR(10);
    END;
    IF @event_type NOT LIKE N'%lock%'
    BEGIN
        SET @object_name_filter += N'     AND object_name = N' + QUOTENAME(@object_name, '''') + NCHAR(10);
    END;
END;

IF @requested_memory_mb > 0
BEGIN
    DECLARE @requested_memory_kb NVARCHAR(11) = @requested_memory_mb / 1024.;
    SET @requested_memory_mb_filter += N'     AND requested_memory_kb >= ' + @requested_memory_kb + NCHAR(10);
END;


--At this point we'll either put my list of interesting waits in a temp table, 
--or a list of user defined waits
IF LOWER(@event_type) LIKE N'%wait%'
BEGIN
    CREATE TABLE #wait(wait_type sysname);
    
    INSERT #wait( wait_type )
    SELECT x.wait_type
    FROM (
    VALUES 
        (N'LCK_M_SCH_S'), 
        (N'LCK_M_SCH_M'), 
        (N'LCK_M_S'),
        (N'LCK_M_U'), 
        (N'LCK_M_X'), 
        (N'LCK_M_IS'),
        (N'LCK_M_IU'), 
        (N'LCK_M_IX'), 
        (N'LCK_M_SIU'),
        (N'LCK_M_SIX'), 
        (N'LCK_M_UIX'), 
        (N'LCK_M_BU'),
        (N'LCK_M_RS_S'), 
        (N'LCK_M_RS_U'), 
        (N'LCK_M_RIn_NL'),
        (N'LCK_M_RIn_S'), 
        (N'LCK_M_RIn_U'),
        (N'LCK_M_RIn_X'), 
        (N'LCK_M_RX_S'), 
        (N'LCK_M_RX_U'),
        (N'LCK_M_RX_X'), 
        (N'LATCH_NL'), 
        (N'LATCH_KP'),
        (N'LATCH_SH'), 
        (N'LATCH_UP'), 
        (N'LATCH_EX'),
        (N'LATCH_DT'), 
        (N'PAGELATCH_NL'), 
        (N'PAGELATCH_KP'),
        (N'PAGELATCH_SH'), 
        (N'PAGELATCH_UP'),
        (N'PAGELATCH_EX'), 
        (N'PAGELATCH_DT'),
        (N'PAGEIOLATCH_NL'), 
        (N'PAGEIOLATCH_KP'),
        (N'PAGEIOLATCH_SH'), 
        (N'PAGEIOLATCH_UP'),
        (N'PAGEIOLATCH_EX'), 
        (N'PAGEIOLATCH_DT'),
        (N'IO_COMPLETION'), 
        (N'ASYNC_IO_COMPLETION'),
        (N'NETWORK_IO'),
        (N'WRITE_COMPLETION'), 
        (N'RESOURCE_SEMAPHORE'),
        (N'RESOURCE_SEMAPHORE_QUERY_COMPILE'),
        (N'RESOURCE_SEMAPHORE_MUTEX'),
        (N'CMEMTHREAD'), 
        (N'CXCONSUMER'),
        (N'CXPACKET'),
        (N'EXECSYNC'),
        (N'SOS_WORKER'),
        (N'SOS_SCHEDULER_YIELD'), 
        (N'LOGBUFFER'),
        (N'WRITELOG') 
    ) AS x (wait_type)
    WHERE @wait_type = N'all'
        
    UNION ALL
    
    SELECT uw.wait_type
    FROM #user_waits AS uw
    WHERE @wait_type <> N'all'
    OPTION(RECOMPILE);
    
    --This section creates a dynamic WHERE clause based on wait types
    --The problem is that wait type IDs change frequently, which sucks.
    WITH maps
          AS ( SELECT   dxmv.map_key,
                        dxmv.map_value,
                        dxmv.map_key
                        - ROW_NUMBER() OVER ( ORDER BY dxmv.map_key ) AS rn
               FROM     sys.dm_xe_map_values AS dxmv
               WHERE    dxmv.name = N'wait_types'
                        AND dxmv.map_value IN ( SELECT w.wait_type FROM #wait AS w )
                ),
         grps
           AS ( SELECT   MIN(maps.map_key) AS minkey,
                         MAX(maps.map_key) AS maxkey
                FROM     maps
                GROUP BY maps.rn )
         SELECT @wait_type_filter += SUBSTRING(( SELECT N'      AND  (('
                                                 + STUFF(( SELECT N'         OR '
                                                                  + CASE WHEN grps.minkey < grps.maxkey
                                                                         THEN + N'(wait_type >= '
                                                                              + CONVERT(NVARCHAR(11), grps.minkey)
                                                                              + N' AND wait_type <= '
                                                                              + CONVERT(NVARCHAR(11), grps.maxkey)
                                                                              + N')' + CHAR(10)
                                                                         ELSE N'(wait_type = '
                                                                              + CONVERT(NVARCHAR(11), grps.minkey)
                                                                              + N')'  + NCHAR(10)
                                                                    END
                                                 FROM grps FOR XML PATH(''), TYPE).value('.[1]', 'NVARCHAR(MAX)')
                                     , 1, 13, N'') ), 0, 8000) + N')';
END; 

/*
End individual filters
*/

--This section sets event-dependent filters
RAISERROR(N'Combining session filters', 0, 1) WITH NOWAIT;
/*For full filter-able sessions*/
SET @session_filter += ( ISNULL(@query_duration_filter, N'') +
                         ISNULL(@client_app_name_filter, N'') +
                         ISNULL(@client_hostname_filter, N'') +
                         ISNULL(@database_name_filter, N'') +
                         ISNULL(@session_id_filter, N'') +
                         ISNULL(@username_filter, N'') +
                         ISNULL(@object_name_filter, N'') );

/*For waits specifically, because they also need to filter on wait type and wait duration*/
SET @session_filter_waits += ( ISNULL(@wait_duration_filter, N'') +
                               ISNULL(@wait_type_filter, N'') +
                               ISNULL(@client_app_name_filter, N'') +
                               ISNULL(@client_hostname_filter, N'') +
                               ISNULL(@database_name_filter, N'') +
                               ISNULL(@session_id_filter, N'') +
                               ISNULL(@username_filter, N'') +
                               ISNULL(@object_name_filter, N'') );

/*For sessions that can't filter on client app or host name*/
SET @session_filter_limited += ( ISNULL(@query_duration_filter, N'') +
                                 ISNULL(@database_name_filter, N'') +
                                 ISNULL(@session_id_filter, N'') +
                                 ISNULL(@username_filter, N'') +
                                 ISNULL(@object_name_filter, N'') );

/*For query plans, which can also filter on memory required*/
SET @session_filter_query_plans += ( ISNULL(@query_duration_filter, N'') +
                                     ISNULL(@database_name_filter, N'') +
                                     ISNULL(@session_id_filter, N'') +
                                     ISNULL(@username_filter, N'') +
                                     ISNULL(@object_name_filter, N'') +
                                     ISNULL(@requested_memory_mb_filter, N'') );

/*Recompile can have almost everything except... duration.*/
SET @session_filter_recompile += ( ISNULL(@client_app_name_filter, N'') +
                                   ISNULL(@client_hostname_filter, N'') +
                                   ISNULL(@database_name_filter, N'') +
                                   ISNULL(@session_id_filter, N'') +
                                   ISNULL(@object_name_filter, N'') +
                                   ISNULL(@username_filter, N'')  );

/*Apparently statement completed can't filter on an object name so that's fun*/
SET @session_filter_statement_completed += ( ISNULL(@query_duration_filter, N'') +
                                             ISNULL(@client_app_name_filter, N'') +
                                             ISNULL(@client_hostname_filter, N'') +
                                             ISNULL(@database_name_filter, N'') +
                                             ISNULL(@session_id_filter, N'') +
                                             ISNULL(@username_filter, N'') );

/*Blocking woighoiughuohaeripugbapiouergb*/
SET @session_filter_blocking += ( ISNULL(@blocking_duration_ms_filter, N'') +
                                  ISNULL(@database_name_filter, N'') +
                                  ISNULL(@session_id_filter, N'') +
                                  ISNULL(@username_filter, N'') +
                                  ISNULL(@object_name_filter, N'') +
                                  ISNULL(@requested_memory_mb_filter, N'') );

/*The parameterization event is pretty limited in weird ways*/
SET @session_filter_parameterization += ( ISNULL(@client_app_name_filter, N'') +
                                          ISNULL(@client_hostname_filter, N'') +
                                          ISNULL(@database_name_filter, N'') +
                                          ISNULL(@session_id_filter, N'') +
                                          ISNULL(@username_filter, N'') );


--This section sets up the event session definition
RAISERROR(N'Setting up the event session', 0, 1) WITH NOWAIT;
SET @session_sql += 
    CASE WHEN LOWER(@event_type) LIKE N'%lock%'
         THEN N' 
  ADD EVENT sqlserver.blocked_process_report 
    (WHERE ( ' + @session_filter_blocking + N' ))'
         WHEN LOWER(@event_type) LIKE N'%quer%'
         THEN N' 
  ADD EVENT sqlserver.module_end 
    (SET collect_statement = 1
     ACTION (sqlserver.database_name, sqlserver.sql_text, sqlserver.plan_handle, sqlserver.query_hash_signed, sqlserver.query_plan_hash_signed)
     WHERE ( ' + @session_filter + N' )),
  ADD EVENT sqlserver.rpc_completed 
    (SET collect_statement = 1
     ACTION(sqlserver.database_name, sqlserver.sql_text, sqlserver.plan_handle, sqlserver.query_hash_signed, sqlserver.query_plan_hash_signed)
     WHERE ( ' + @session_filter + N' )),
  ADD EVENT sqlserver.sp_statement_completed 
    (SET collect_object_name = 1, collect_statement = 1
     ACTION(sqlserver.database_name, sqlserver.sql_text, sqlserver.plan_handle, sqlserver.query_hash_signed, sqlserver.query_plan_hash_signed) 
     WHERE ( ' + @session_filter + N' )),
  ADD EVENT sqlserver.sql_statement_completed 
    (SET collect_statement = 1
     ACTION(sqlserver.database_name, sqlserver.sql_text, sqlserver.plan_handle, sqlserver.query_hash_signed, sqlserver.query_plan_hash_signed)
     WHERE ( ' + @session_filter_statement_completed + N' )),
  ADD EVENT sqlserver.query_post_execution_showplan
    (
     ACTION(sqlserver.database_name, sqlserver.sql_text, sqlserver.plan_handle, sqlserver.query_hash_signed, sqlserver.query_plan_hash_signed)
     WHERE ( ' + @session_filter_query_plans + N' ))'
         WHEN LOWER(@event_type) LIKE N'%wait%' AND @v > 11
         THEN N' 
  ADD EVENT sqlos.wait_completed
    (SET collect_wait_resource = 1
     ACTION (sqlserver.database_name, sqlserver.plan_handle, sqlserver.query_hash_signed, sqlserver.query_plan_hash_signed)
     WHERE ( ' + @session_filter_waits + N' ))'
         WHEN LOWER(@event_type) LIKE N'%wait%' AND @v = 11
         THEN N' 
  ADD EVENT sqlos.wait_info
    (
     ACTION (sqlserver.database_name, sqlserver.plan_handle, sqlserver.query_hash_signed, sqlserver.query_plan_hash_signed)
     WHERE ( ' + @session_filter_waits + N' ))'
         WHEN LOWER(@event_type) LIKE N'%recomp%'
         THEN CASE WHEN @compile_events = 1
                   THEN N' 
  ADD EVENT sqlserver.sql_statement_post_compile 
    (SET collect_object_name = 1, collect_statement = 1
     ACTION(sqlserver.database_name)
     WHERE ( ' + @session_filter + N' ))'
                   ELSE N' 
  ADD EVENT sqlserver.sql_statement_recompile 
    (SET collect_object_name = 1, collect_statement = 1
     ACTION(sqlserver.database_name)
     WHERE ( ' + @session_filter_recompile + N' ))'
             END
         WHEN (LOWER(@event_type) LIKE N'%comp%' AND LOWER(@event_type) NOT LIKE N'%re%')
         THEN CASE WHEN @compile_events = 1
                   THEN N' 
  ADD EVENT sqlserver.sql_statement_post_compile 
    (SET collect_object_name = 1, collect_statement = 1
     ACTION(sqlserver.database_name)
     WHERE ( ' + @session_filter + N' ))'
                   ELSE N'
  ADD EVENT sqlserver.uncached_sql_batch_statistics
    (
     ACTION(sqlserver.database_name)
     WHERE ( ' + @session_filter_recompile + N' )),             
  ADD EVENT sqlserver.sql_statement_recompile 
    (SET collect_object_name = 1, collect_statement = 1
     ACTION(sqlserver.database_name)
     WHERE ( ' + @session_filter_recompile + N' ))'
              END
            + CASE WHEN @parameterization_events = 1
                   THEN N',
  ADD EVENT sqlserver.query_parameterization_data
    (
     ACTION (sqlserver.database_name, sqlserver.plan_handle, sqlserver.sql_text)
     WHERE ( ' + @session_filter_parameterization + N' ))'
                   ELSE N''
              END 
        ELSE N'i have no idea what i''m doing.'
    END;
--End event session definition  
  

--This creates the event session
SET @session_sql += @session_with;
    IF @debug = 1 BEGIN RAISERROR(@session_sql, 0, 1) WITH NOWAIT; END;
EXEC (@session_sql);

--This starts the event session
IF @debug = 1 BEGIN RAISERROR(@start_sql, 0, 1) WITH NOWAIT; END;
EXEC (@start_sql);

--bail out here if we want to keep the session
IF @keep_alive = 1
BEGIN
    RAISERROR(N'Session %s created, exiting.', 0, 1, @session_name) WITH NOWAIT;
    RAISERROR(N'To collect data from it, run this proc from an agent job with an output database and schema name', 0, 1) WITH NOWAIT;
    RAISERROR(N'Alternately, you can watch live data stream in by accessing the GUI', 0, 1) WITH NOWAIT;
    RAISERROR(N'Just don''t forget to stop it when you''re done with it!', 0, 1) WITH NOWAIT;
    RETURN;
END;


--NOW WE WAIT, MR. BOND
WAITFOR DELAY @waitfor;


--Dump whatever we got into a temp table
SELECT @x = CONVERT(XML, t.target_data)
FROM   sys.dm_xe_session_targets AS t
JOIN   sys.dm_xe_sessions AS s
    ON s.address = t.event_session_address
WHERE  s.name = @session_name
AND    t.target_name = N'ring_buffer'
OPTION (RECOMPILE);


SELECT e.x.query('.') AS human_events_xml
INTO   #human_events_xml
FROM   @x.nodes('/RingBufferTarget/event') AS e(x)
OPTION (RECOMPILE);


IF @debug = 1
BEGIN
    SELECT N'#human_events_xml' AS table_name, * FROM #human_events_xml AS hex;
END;


/*
This is where magic will happen
*/
IF LOWER(@event_type) LIKE N'%quer%'
BEGIN;
         WITH queries AS 
         (
            SELECT DATEADD(MINUTE, DATEDIFF(MINUTE, GETUTCDATE(), SYSDATETIME()), c.value('@timestamp', 'DATETIME2')) AS event_time,
                   c.value('@name', 'NVARCHAR(256)') AS event_type,
                   c.value('(action[@name="database_name"]/value)[1]', 'NVARCHAR(256)') AS database_name,                
                   c.value('(data[@name="object_name"]/value)[1]', 'NVARCHAR(256)') AS [object_name],
                   c.value('(action[@name="sql_text"]/value)[1]', 'NVARCHAR(MAX)') AS sql_text,
                   c.value('(data[@name="statement"]/value)[1]', 'NVARCHAR(MAX)') AS statement,
                   c.query('(data[@name="showplan_xml"]/value/*)[1]') AS [showplan_xml],
                   c.value('(data[@name="cpu_time"]/value)[1]', 'BIGINT') / 1000. AS cpu_ms,
                  (c.value('(data[@name="logical_reads"]/value)[1]', 'BIGINT') * 8) / 1024. AS logical_reads,
                  (c.value('(data[@name="physical_reads"]/value)[1]', 'BIGINT') * 8) / 1024. AS physical_reads,
                   c.value('(data[@name="duration"]/value)[1]', 'BIGINT') / 1000. AS duration_ms,
                  (c.value('(data[@name="writes"]/value)[1]', 'BIGINT') * 8) / 1024. AS writes,
                  (c.value('(data[@name="spills"]/value)[1]', 'BIGINT') * 8) / 1024. AS spills_mb,
                   c.value('(data[@name="row_count"]/value)[1]', 'BIGINT') AS row_count,
                   c.value('(data[@name="estimated_rows"]/value)[1]', 'BIGINT') AS estimated_rows,
                   c.value('(data[@name="dop"]/value)[1]', 'INT') AS dop,
                   c.value('(data[@name="serial_ideal_memory_kb"]/value)[1]', 'BIGINT') / 1024. AS serial_ideal_memory_mb,
                   c.value('(data[@name="requested_memory_kb"]/value)[1]', 'BIGINT') / 1024. AS requested_memory_mb,
                   c.value('(data[@name="used_memory_kb"]/value)[1]', 'BIGINT') / 1024. AS used_memory_mb,
                   c.value('(data[@name="ideal_memory_kb"]/value)[1]', 'BIGINT') / 1024. AS ideal_memory_mb,
                   c.value('(data[@name="granted_memory_kb"]/value)[1]', 'BIGINT') / 1024. AS granted_memory_mb,
                   CONVERT(BINARY(8), c.value('(action[@name="query_plan_hash_signed"]/value)[1]', 'BIGINT')) AS query_plan_hash_signed,
                   CONVERT(BINARY(8), c.value('(action[@name="query_hash_signed"]/value)[1]', 'BIGINT')) AS query_hash_signed,
                   c.value('xs:hexBinary((action[@name="plan_handle"]/value/text())[1])', 'VARBINARY(64)') AS plan_handle
            FROM #human_events_xml AS xet
            OUTER APPLY xet.human_events_xml.nodes('//event') AS oa(c)
            WHERE c.exist('(action[@name="query_hash_signed"]/value[. != 0])') = 1
         )
         SELECT *
         INTO #queries
         FROM queries AS q
         OPTION (RECOMPILE);
         
         IF @debug = 1 BEGIN SELECT N'#queries' AS table_name, * FROM #queries AS q OPTION (RECOMPILE); END;

         WITH query_agg AS 
             (
                SELECT q.query_plan_hash_signed,
                       q.query_hash_signed,
                       CONVERT(VARBINARY(64), NULL) AS plan_handle,
                       /*totals*/
                       ISNULL(q.cpu_ms, 0.) AS total_cpu_ms,
                       ISNULL(q.logical_reads, 0.) AS total_logical_reads,
                       ISNULL(q.physical_reads, 0.) AS total_physical_reads,
                       ISNULL(q.duration_ms, 0.) AS total_duration_ms,
                       ISNULL(q.writes, 0.) AS total_writes,
                       ISNULL(q.spills_mb, 0.) AS total_spills_mb,
                       NULL AS total_used_memory_mb,
                       NULL AS total_granted_memory_mb,
                       ISNULL(q.row_count, 0.) AS total_rows,
                       /*averages*/
                       ISNULL(q.cpu_ms, 0.) AS avg_cpu_ms,
                       ISNULL(q.logical_reads, 0.) AS avg_logical_reads,
                       ISNULL(q.physical_reads, 0.) AS avg_physical_reads,
                       ISNULL(q.duration_ms, 0.) AS avg_duration_ms,
                       ISNULL(q.writes, 0.) AS avg_writes,
                       ISNULL(q.spills_mb, 0.) AS avg_spills_mb,
                       NULL AS avg_used_memory_mb,
                       NULL AS avg_granted_memory_mb,
                       ISNULL(q.row_count, 0) AS avg_rows                    
                FROM #queries AS q
                WHERE q.event_type <> N'query_post_execution_showplan'
                
                UNION ALL 
                
                SELECT q.query_plan_hash_signed,
                       q.query_hash_signed,
                       q.plan_handle,
                       /*totals*/
                       NULL AS total_cpu_ms,
                       NULL AS total_logical_reads,
                       NULL AS total_physical_reads,
                       NULL AS total_duration_ms,
                       NULL AS total_writes,
                       NULL AS total_spills_mb,                        
                       ISNULL(used_memory_mb, 0.) AS total_used_memory_mb,
                       ISNULL(granted_memory_mb, 0.) AS total_granted_memory_mb,
                       NULL AS total_rows,
                       /*averages*/
                       NULL AS avg_cpu_ms,
                       NULL AS avg_logical_reads,
                       NULL AS avg_physical_reads,
                       NULL AS avg_duration_ms,
                       NULL AS avg_writes,
                       NULL AS avg_spills_mb,
                       ISNULL(q.used_memory_mb, 0.) AS avg_used_memory_mb,
                       ISNULL(q.granted_memory_mb, 0.) AS avg_granted_memory_mb,
                       NULL AS avg_rows                    
                FROM #queries AS q
                WHERE q.event_type = N'query_post_execution_showplan'        
             )
             SELECT qa.query_plan_hash_signed,
                    qa.query_hash_signed,
                    MAX(qa.plan_handle) AS plan_handle,
                    SUM(qa.total_cpu_ms) AS total_cpu_ms,
                    SUM(qa.total_logical_reads) AS total_logical_reads_mb,
                    SUM(qa.total_physical_reads) AS total_physical_reads_mb,
                    SUM(qa.total_duration_ms) AS total_duration_ms,
                    SUM(qa.total_writes) AS total_writes_mb,
                    SUM(qa.total_spills_mb) AS total_spills_mb,
                    SUM(qa.total_used_memory_mb) AS total_used_memory_mb,
                    SUM(qa.total_granted_memory_mb) AS total_granted_memory_mb,
                    SUM(qa.total_rows) AS total_rows,
                    AVG(qa.avg_cpu_ms) AS avg_cpu_ms,
                    AVG(qa.avg_logical_reads) AS avg_logical_reads_mb,
                    AVG(qa.avg_physical_reads) AS avg_physical_reads_mb,
                    AVG(qa.avg_duration_ms) AS avg_duration_ms,
                    AVG(qa.avg_writes) AS avg_writes_mb,
                    AVG(qa.avg_spills_mb) AS avg_spills_mb,
                    AVG(qa.avg_used_memory_mb) AS avg_used_memory_mb,
                    AVG(qa.avg_granted_memory_mb) AS avg_granted_memory_mb,
                    AVG(qa.avg_rows) AS avg_rows,
                    COUNT(qa.plan_handle) AS executions
             INTO #totals
             FROM query_agg AS qa
             GROUP BY qa.query_plan_hash_signed,
                      qa.query_hash_signed;
         
         IF @debug = 1 BEGIN SELECT N'#totals' AS table_name, * FROM #totals AS t OPTION (RECOMPILE); END;

         WITH query_results AS
             (
                 SELECT q.event_time,
                        q.database_name,
                        q.object_name,
                        q2.statement_text,
                        q.sql_text,
                        q.showplan_xml,
                        t.executions,
                        t.total_cpu_ms,
                        t.avg_cpu_ms,
                        t.total_logical_reads_mb,
                        t.avg_logical_reads_mb,
                        t.total_physical_reads_mb,
                        t.avg_physical_reads_mb,
                        t.total_duration_ms,
                        t.avg_duration_ms,
                        t.total_writes_mb,
                        t.avg_writes_mb,
                        t.total_spills_mb,
                        t.avg_spills_mb,
                        t.total_used_memory_mb,
                        t.avg_used_memory_mb,
                        t.total_granted_memory_mb,
                        t.avg_granted_memory_mb,
                        t.total_rows,
                        t.avg_rows,
                        q.serial_ideal_memory_mb,
                        q.requested_memory_mb,
                        q.ideal_memory_mb,
                        q.estimated_rows,
                        q.dop,
                        q.query_plan_hash_signed,
                        q.query_hash_signed,
                        q.plan_handle,
                        ROW_NUMBER() OVER( PARTITION BY q.query_plan_hash_signed, q.query_hash_signed, q.plan_handle
                                               ORDER BY q.query_plan_hash_signed, q.query_hash_signed, q.plan_handle ) AS n
                 FROM #queries AS q
                 JOIN #totals AS t
                     ON  q.query_hash_signed = t.query_hash_signed
                     AND q.query_plan_hash_signed = t.query_plan_hash_signed
                     AND q.plan_handle = t.plan_handle
                 CROSS APPLY
                 (
                     SELECT TOP (1) q2.statement AS statement_text
                     FROM #queries AS q2
                     WHERE q.query_hash_signed = q2.query_hash_signed
                     AND   q.query_plan_hash_signed = q2.query_plan_hash_signed
                     AND   q2.statement IS NOT NULL
                     ORDER BY q2.event_time DESC
                 ) AS q2
                 WHERE q.showplan_xml.exist('*') = 1
             )
                 SELECT q.event_time,
                        q.database_name,
                        q.object_name,
                        q.statement_text,
                        q.sql_text,
                        q.showplan_xml,
                        q.executions,
                        q.total_cpu_ms,
                        q.avg_cpu_ms,
                        q.total_logical_reads_mb,
                        q.avg_logical_reads_mb,
                        q.total_physical_reads_mb,
                        q.avg_physical_reads_mb,
                        q.total_duration_ms,
                        q.avg_duration_ms,
                        q.total_writes_mb,
                        q.avg_writes_mb,
                        q.total_spills_mb,
                        q.avg_spills_mb,
                        q.total_used_memory_mb,
                        q.avg_used_memory_mb,
                        q.total_granted_memory_mb,
                        q.avg_granted_memory_mb,
                        q.total_rows,
                        q.avg_rows,
                        q.serial_ideal_memory_mb,
                        q.requested_memory_mb,
                        q.ideal_memory_mb,
                        q.estimated_rows,
                        q.dop,
                        q.query_plan_hash_signed,
                        q.query_hash_signed,
                        q.plan_handle
                 FROM query_results AS q
                 WHERE q.n = 1
                 ORDER BY CASE @query_sort_order
                               WHEN N'cpu' THEN q.total_cpu_ms
                               WHEN N'reads' THEN q.total_logical_reads_mb + q.total_physical_reads_mb
                               WHEN N'writes' THEN q.total_writes_mb
                               WHEN N'duration' THEN q.total_duration_ms
                               WHEN N'spills' THEN q.total_spills_mb
                               WHEN N'memory' THEN q.total_granted_memory_mb
                               WHEN N'avg cpu' THEN q.avg_cpu_ms
                               WHEN N'avg reads' THEN q.avg_logical_reads_mb + q.avg_physical_reads_mb
                               WHEN N'avg writes' THEN q.avg_writes_mb
                               WHEN N'avg duration' THEN q.avg_duration_ms
                               WHEN N'avg spills' THEN q.avg_spills_mb
                               WHEN N'avg memory' THEN q.avg_granted_memory_mb
                               ELSE N'cpu'
                          END DESC
                 OPTION (RECOMPILE);
END
;


IF LOWER(@event_type) LIKE N'%comp%' AND LOWER(@event_type) NOT LIKE N'%re%'
BEGIN

IF @compile_events = 1
    BEGIN
            SELECT DATEADD(MINUTE, DATEDIFF(MINUTE, GETUTCDATE(), SYSDATETIME()), c.value('@timestamp', 'DATETIME2')) AS event_time,
                   c.value('@name', 'NVARCHAR(256)') AS event_type,
                   c.value('(action[@name="database_name"]/value)[1]', 'NVARCHAR(256)') AS database_name,                
                   c.value('(data[@name="object_name"]/value)[1]', 'NVARCHAR(256)') AS [object_name],
                   c.value('(data[@name="statement"]/value)[1]', 'NVARCHAR(MAX)') AS statement_text,
                   c.value('(data[@name="cpu_time"]/value)[1]', 'BIGINT') compile_cpu_ms,
                   c.value('(data[@name="duration"]/value)[1]', 'BIGINT') compile_duration_ms
            INTO #compiles_1
            FROM #human_events_xml AS xet
            OUTER APPLY xet.human_events_xml.nodes('//event') AS oa(c)
            WHERE c.exist('(data[@name="is_recompile"]/value[. = "false"])') = 1
            AND   c.exist('@name[.= "sql_statement_post_compile"]') = 1
            ORDER BY event_time
            OPTION (RECOMPILE);

            ALTER TABLE #compiles_1 ADD statement_text_checksum AS CHECKSUM(database_name + statement_text) PERSISTED;

            IF @debug = 1 BEGIN SELECT N'#compiles_1' AS table_name, * FROM #compiles_1 AS c OPTION(RECOMPILE); END;

            WITH cbq
              AS (
                 SELECT statement_text_checksum,
                        COUNT_BIG(*) AS total_compiles,
                        SUM(compile_cpu_ms) AS total_compile_cpu,
                        AVG(compile_cpu_ms) AS avg_compile_cpu,
                        MAX(compile_cpu_ms) AS max_compile_cpu,
                        SUM(compile_duration_ms) AS total_compile_duration,
                        AVG(compile_duration_ms) AS avg_compile_duration,
                        MAX(compile_duration_ms) AS max_compile_duration
                 FROM #compiles_1
                 GROUP BY statement_text_checksum )
            SELECT N'total compiles' AS pattern,
                   k.object_name,
                   k.statement_text,
                   c.total_compiles,
                   c.total_compile_cpu,
                   c.avg_compile_cpu,
                   c.max_compile_cpu,
                   c.total_compile_duration,
                   c.avg_compile_duration,
                   c.max_compile_duration
            FROM cbq AS c
            CROSS APPLY
                (
                    SELECT TOP(1) *
                    FROM #compiles_1 AS k
                    WHERE c.statement_text_checksum = k.statement_text_checksum
                    ORDER BY k.event_time DESC
                ) AS k
            ORDER BY c.total_compiles DESC
            OPTION(RECOMPILE);

    END;

IF @compile_events = 0
    BEGIN
            SELECT DATEADD(MINUTE, DATEDIFF(MINUTE, GETUTCDATE(), SYSDATETIME()), c.value('@timestamp', 'DATETIME2')) AS event_time,
                   c.value('@name', 'NVARCHAR(256)') AS event_type,
                   c.value('(action[@name="database_name"]/value)[1]', 'NVARCHAR(256)') AS database_name,                
                   c.value('(data[@name="object_name"]/value)[1]', 'NVARCHAR(256)') AS [object_name],
                   c.value('(data[@name="statement"]/value)[1]', 'NVARCHAR(MAX)') AS statement_text
            INTO #compiles_0
            FROM #human_events_xml AS xet
            OUTER APPLY xet.human_events_xml.nodes('//event') AS oa(c)
            ORDER BY event_time
            OPTION (RECOMPILE);

            IF @debug = 1 BEGIN SELECT N'#compiles_0' AS table_name, * FROM #compiles_0 AS c OPTION(RECOMPILE); END;

            SELECT c.event_time,
                   c.event_type,
                   c.database_name,
                   c.object_name,
                   c.statement_text
            FROM #compiles_0 AS c
            ORDER BY c.event_time
            OPTION(RECOMPILE);

    END;

IF @parameterization_events  = 1
    BEGIN
            SELECT DATEADD(MINUTE, DATEDIFF(MINUTE, GETUTCDATE(), SYSDATETIME()), c.value('@timestamp', 'DATETIME2')) AS event_time,
                   c.value('@name', 'NVARCHAR(256)') AS event_type,
                   c.value('(action[@name="database_name"]/value)[1]', 'NVARCHAR(256)') AS database_name,                
                   c.value('(action[@name="sql_text"]/value)[1]', 'NVARCHAR(MAX)') AS sql_text,
                   c.value('(data[@name="compile_cpu_time"]/value)[1]', 'BIGINT') / 1000. AS compile_cpu_time_ms,
                   c.value('(data[@name="compile_duration"]/value)[1]', 'BIGINT') / 1000. AS compile_duration_ms,
                   c.value('(data[@name="query_param_type"]/value)[1]', 'INT') AS query_param_type,
                   c.value('(data[@name="is_cached"]/value)[1]', 'BIT') AS is_cached,
                   c.value('(data[@name="is_recompiled"]/value)[1]', 'BIT') AS is_recompiled,
                   c.value('(data[@name="compile_code"]/text)[1]', 'NVARCHAR(256)') AS compile_code,                  
                   c.value('(data[@name="has_literals"]/value)[1]', 'BIT') AS has_literals,
                   c.value('(data[@name="is_parameterizable"]/value)[1]', 'BIT') AS is_parameterizable,
                   c.value('(data[@name="parameterized_values_count"]/value)[1]', 'BIGINT') AS parameterized_values_count,
                   c.value('xs:hexBinary((data[@name="query_plan_hash"]/value/text())[1])', 'BINARY(8)') AS query_plan_hash,
                   c.value('xs:hexBinary((data[@name="query_hash"]/value/text())[1])', 'BINARY(8)') AS query_hash,
                   c.value('xs:hexBinary((action[@name="plan_handle"]/value/text())[1])', 'VARBINARY(64)') AS plan_handle, 
                   c.value('xs:hexBinary((data[@name="statement_sql_hash"]/value/text())[1])', 'VARBINARY(64)') AS statement_sql_hash
            INTO #parameterization
            FROM #human_events_xml AS xet
            OUTER APPLY xet.human_events_xml.nodes('//event') AS oa(c)
            WHERE c.exist('@name[. = "query_parameterization_data"]') = 1
            AND   c.exist('(data[@name="is_recompiled"]/value[. = "false"])') = 1
            ORDER BY event_time
            OPTION (RECOMPILE);

            IF @debug = 1 BEGIN SELECT N'#parameterization' AS table_name, * FROM #parameterization AS p OPTION(RECOMPILE); END;

            WITH cpq AS 
               (
                SELECT database_name,
                       query_hash,
                       COUNT_BIG(*) AS total_compiles,
                       COUNT(DISTINCT query_plan_hash) AS plan_count,
                       SUM(compile_cpu_time_ms) AS total_compile_cpu,
                       AVG(compile_cpu_time_ms) AS avg_compile_cpu,
                       MAX(compile_cpu_time_ms) AS max_compile_cpu,
                       SUM(compile_duration_ms) AS total_compile_duration,
                       AVG(compile_duration_ms) AS avg_compile_duration,
                       MAX(compile_duration_ms) AS max_compile_duration
                FROM #parameterization
                GROUP BY database_name, 
                         query_hash
               )
               SELECT N'parameterization opportunities' AS pattern,
                      c.database_name,
                      k.sql_text,
                      k.is_parameterizable,
                      c.total_compiles,
                      c.plan_count,
                      c.total_compile_cpu,
                      c.avg_compile_cpu,
                      c.max_compile_cpu,
                      c.total_compile_duration,
                      c.avg_compile_duration,
                      c.max_compile_duration,
                      k.query_param_type,
                      k.is_cached,
                      k.is_recompiled,
                      k.compile_code,
                      k.has_literals,
                      k.parameterized_values_count
               FROM cpq AS c
               CROSS APPLY
               (
                   SELECT TOP (1) *
                   FROM #parameterization AS k
                   WHERE k.query_hash = c.query_hash
                   ORDER BY k.event_time DESC
               ) AS k
            ORDER BY c.total_compiles DESC
            OPTION(RECOMPILE);
    END;

END;


IF LOWER(@event_type) LIKE N'%recomp%'
BEGIN

IF @compile_events = 1
    BEGIN
            SELECT DATEADD(MINUTE, DATEDIFF(MINUTE, GETUTCDATE(), SYSDATETIME()), c.value('@timestamp', 'DATETIME2')) AS event_time,
                   c.value('@name', 'NVARCHAR(256)') AS event_type,
                   c.value('(action[@name="database_name"]/value)[1]', 'NVARCHAR(256)') AS database_name,                
                   c.value('(data[@name="object_name"]/value)[1]', 'NVARCHAR(256)') AS [object_name],
                   c.value('(data[@name="recompile_cause"]/text)[1]', 'NVARCHAR(256)') AS recompile_cause,
                   c.value('(data[@name="statement"]/value)[1]', 'NVARCHAR(MAX)') AS statement_text,
                   c.value('(data[@name="cpu_time"]/value)[1]', 'BIGINT') AS recompile_cpu_ms,
                   c.value('(data[@name="duration"]/value)[1]', 'BIGINT') AS recompile_duration_ms
            INTO #recompiles_1
            FROM #human_events_xml AS xet
            OUTER APPLY xet.human_events_xml.nodes('//event') AS oa(c)
            WHERE c.exist('(data[@name="is_recompile"]/value[. = "false"])') = 0
            ORDER BY event_time
            OPTION (RECOMPILE);

            ALTER TABLE #recompiles_1 ADD statement_text_checksum AS CHECKSUM(database_name + statement_text) PERSISTED;

            IF @debug = 1 BEGIN SELECT N'#recompiles_1' AS table_name, * FROM #recompiles_1 AS r OPTION(RECOMPILE); END;

            WITH cbq
              AS (
                 SELECT statement_text_checksum,
                        COUNT_BIG(*) AS total_recompiles,
                        SUM(recompile_cpu_ms) AS total_recompile_cpu,
                        AVG(recompile_cpu_ms) AS avg_recompile_cpu,
                        MAX(recompile_cpu_ms) AS max_recompile_cpu,
                        SUM(recompile_duration_ms) AS total_recompile_duration,
                        AVG(recompile_duration_ms) AS avg_recompile_duration,
                        MAX(recompile_duration_ms) AS max_recompile_duration
                 FROM #recompiles_1
                 GROUP BY statement_text_checksum )
            SELECT N'total recompiles' AS pattern,
                   k.recompile_cause,
                   k.object_name,
                   k.statement_text,
                   c.total_recompiles,
                   c.total_recompile_cpu,
                   c.avg_recompile_cpu,
                   c.max_recompile_cpu,
                   c.total_recompile_duration,
                   c.avg_recompile_duration,
                   c.max_recompile_duration
            FROM cbq AS c
            CROSS APPLY
                (
                    SELECT TOP(1) *
                    FROM #recompiles_1 AS k
                    WHERE c.statement_text_checksum = k.statement_text_checksum
                    ORDER BY k.event_time DESC
                ) AS k
            ORDER BY c.total_recompiles DESC
            OPTION(RECOMPILE);

    END;

IF @compile_events = 0
    BEGIN
            SELECT DATEADD(MINUTE, DATEDIFF(MINUTE, GETUTCDATE(), SYSDATETIME()), c.value('@timestamp', 'DATETIME2')) AS event_time,
                   c.value('@name', 'NVARCHAR(256)') AS event_type,
                   c.value('(action[@name="database_name"]/value)[1]', 'NVARCHAR(256)') AS database_name,                
                   c.value('(data[@name="object_name"]/value)[1]', 'NVARCHAR(256)') AS [object_name],
                   c.value('(data[@name="recompile_cause"]/text)[1]', 'NVARCHAR(256)') AS recompile_cause,
                   c.value('(data[@name="statement"]/value)[1]', 'NVARCHAR(MAX)') AS statement_text
            INTO #recompiles_0
            FROM #human_events_xml AS xet
            OUTER APPLY xet.human_events_xml.nodes('//event') AS oa(c)
            ORDER BY event_time
            OPTION (RECOMPILE);

            IF @debug = 1 BEGIN SELECT N'#recompiles_0' AS table_name, * FROM #recompiles_0 AS r OPTION(RECOMPILE); END;

            SELECT r.event_time,
                   r.event_type,
                   r.database_name,
                   r.object_name,
                   r.statement_text
            FROM #recompiles_0 AS r
            ORDER BY r.event_time
            OPTION(RECOMPILE);

    END;
END;


IF LOWER(@event_type) LIKE N'%wait%'
BEGIN;
         WITH waits AS 
             (
                 SELECT DATEADD(MINUTE, DATEDIFF(MINUTE, GETUTCDATE(), SYSDATETIME()), c.value('@timestamp', 'DATETIME2')) AS event_time,
                        c.value('@name', 'NVARCHAR(256)') AS event_type,
                        c.value('(action[@name="database_name"]/value)[1]', 'NVARCHAR(256)') AS database_name,                
                        c.value('(data[@name="wait_type"]/text)[1]', 'NVARCHAR(256)') AS wait_type,
                        c.value('(data[@name="duration"]/value)[1]', 'BIGINT')  AS duration_ms,
                        c.value('(data[@name="signal_duration"]/value)[1]', 'BIGINT') AS signal_duration_ms,
                        CASE WHEN @v = 11 THEN N'Not Available < 2014' ELSE c.value('(data[@name="wait_resource"]/value)[1]', 'NVARCHAR(256)') END AS wait_resource,
                        CONVERT(BINARY(8), c.value('(action[@name="query_plan_hash_signed"]/value)[1]', 'BIGINT')) AS query_plan_hash_signed,
                        CONVERT(BINARY(8), c.value('(action[@name="query_hash_signed"]/value)[1]', 'BIGINT')) AS query_hash_signed,
                        c.value('xs:hexBinary((action[@name="plan_handle"]/value/text())[1])', 'VARBINARY(64)') AS plan_handle
                 FROM (
                           SELECT TOP (2147483647) xet.human_events_xml
                           FROM #human_events_xml AS xet
                           WHERE ( xet.human_events_xml.exist('(//event/data[@name="duration"]/value[. > 0])') = 1 
                                       OR @gimme_danger = 1 )
                      )AS c
                 OUTER APPLY c.human_events_xml.nodes('//event') AS oa(c)
             )
                 SELECT *
                 INTO #waits_agg
                 FROM waits
                 OPTION(RECOMPILE);
            
            IF @debug = 1 BEGIN SELECT N'#waits_agg' AS table_name, * FROM #waits_agg AS wa OPTION (RECOMPILE); END;

            SELECT N'total waits' AS wait_pattern,
                   MIN(wa.event_time) AS min_event_time,
                   MAX(wa.event_time) AS max_event_time,
                   wa.wait_type,
                   COUNT_BIG(*) AS total_waits,
                   SUM(wa.duration_ms) AS sum_duration_ms,
                   SUM(wa.signal_duration_ms) AS sum_signal_duration_ms,
                   SUM(wa.duration_ms) / COUNT_BIG(*) AS avg_ms_per_wait
            FROM #waits_agg AS wa
            GROUP BY wa.wait_type
            ORDER BY sum_duration_ms DESC
            OPTION (RECOMPILE);            

            SELECT N'total waits by database' AS wait_pattern,
                   MIN(wa.event_time) AS min_event_time,
                   MAX(wa.event_time) AS max_event_time,
                   wa.database_name,
                   wa.wait_type,
                   COUNT_BIG(*) AS total_waits,
                   SUM(wa.duration_ms) AS sum_duration_ms,
                   SUM(wa.signal_duration_ms) AS sum_signal_duration_ms,
                   SUM(wa.duration_ms) / COUNT_BIG(*) AS avg_ms_per_wait
            FROM #waits_agg AS wa
            GROUP BY wa.database_name, 
                     wa.wait_type
            ORDER BY sum_duration_ms DESC
            OPTION (RECOMPILE); 

            WITH plan_waits AS 
                (
                     SELECT N'total waits by query and database' AS wait_pattern,
                            MIN(wa.event_time) AS min_event_time,
                            MAX(wa.event_time) AS max_event_time,
                            wa.database_name,
                            wa.wait_type,
                            COUNT_BIG(*) AS total_waits,
                            wa.plan_handle,
                            SUM(wa.duration_ms) AS sum_duration_ms,
                            SUM(wa.signal_duration_ms) AS sum_signal_duration_ms,
                            SUM(wa.duration_ms) / COUNT_BIG(*) AS avg_ms_per_wait
                     FROM #waits_agg AS wa
                     GROUP BY wa.database_name,
                              wa.wait_type, 
                              wa.plan_handle
                     
                )
                     SELECT pw.wait_pattern,
                            pw.min_event_time,
                            pw.max_event_time,
                            pw.database_name,
                            pw.wait_type,
                            pw.total_waits,
                            pw.sum_duration_ms,
                            pw.sum_signal_duration_ms,
                            pw.avg_ms_per_wait,
                            st.text,
                            qp.query_plan
                     FROM plan_waits AS pw
                     OUTER APPLY sys.dm_exec_query_plan(pw.plan_handle) AS qp
                     OUTER APPLY sys.dm_exec_sql_text(pw.plan_handle) AS st
                     ORDER BY pw.sum_duration_ms DESC
                     OPTION (RECOMPILE);
END;


IF LOWER(@event_type) LIKE N'%lock%'
BEGIN

            SELECT DATEADD(MINUTE, DATEDIFF(MINUTE, GETUTCDATE(), SYSDATETIME()), c.value('@timestamp', 'DATETIME2')) AS event_time,        
                   DB_NAME(c.value('(data[@name="database_id"]/value)[1]', 'INT')) AS database_name,
                   c.value('(data[@name="database_id"]/value)[1]', 'INT') AS database_id,
                   c.value('(data[@name="object_id"]/value)[1]', 'INT') AS object_id,
                   c.value('(data[@name="transaction_id"]/value)[1]', 'BIGINT') AS transaction_id,
                   c.value('(data[@name="resource_owner_type"]/text)[1]', 'NVARCHAR(256)') AS resource_owner_type,
                   c.value('(//@monitorLoop)[1]', 'INT') AS monitor_loop,
                   bd.value('(process/@spid)[1]', 'INT') AS spid,
                   bd.value('(process/@ecid)[1]', 'INT') AS ecid,
                   bd.value('(process/inputbuf/text())[1]', 'NVARCHAR(MAX)') AS query_text,
                   bd.value('(process/@waittime)[1]', 'BIGINT') AS wait_time,
                   bd.value('(process/@transactionname)[1]', 'NVARCHAR(256)') AS transaction_name,
                   bd.value('(process/@lasttranstarted)[1]', 'DATETIME2') AS last_transaction_started,
                   bd.value('(process/@lockMode)[1]', 'NVARCHAR(10)') AS lock_mode,
                   bd.value('(process/@status)[1]', 'NVARCHAR(10)') AS status,
                   bd.value('(process/@priority)[1]', 'INT') AS priority,
                   bd.value('(process/@trancount)[1]', 'INT') AS transaction_count,
                   bd.value('(process/@clientapp)[1]', 'NVARCHAR(256)') AS client_app,
                   bd.value('(process/@hostname)[1]', 'NVARCHAR(256)') AS host_name,
                   bd.value('(process/@loginname)[1]', 'NVARCHAR(256)') AS login_name,
                   bd.value('(process/@isolationlevel)[1]', 'NVARCHAR(50)') AS isolation_level,
                   bd.value('(process/executionStack/frame/@sqlhandle)[1]', 'NVARCHAR(100)') AS sqlhandle,
                   'blocked' AS activity,
                   c.query('.') AS blocked_process_report
            INTO #blocked
            FROM #human_events_xml AS xet
            OUTER APPLY xet.human_events_xml.nodes('//event') AS oa(c)
            OUTER APPLY oa.c.nodes('//blocked-process-report/blocked-process') AS bd(bd)
            OPTION (RECOMPILE);

            IF @debug = 1 BEGIN SELECT N'#blocked' AS table_name, * FROM #blocked AS wa OPTION (RECOMPILE); END;

            SELECT DATEADD(MINUTE, DATEDIFF(MINUTE, GETUTCDATE(), SYSDATETIME()), c.value('@timestamp', 'DATETIME2')) AS event_time,        
                   DB_NAME(c.value('(data[@name="database_id"]/value)[1]', 'INT')) AS database_name,
                   c.value('(data[@name="database_id"]/value)[1]', 'INT') AS database_id,
                   c.value('(data[@name="object_id"]/value)[1]', 'INT') AS object_id,
                   c.value('(data[@name="transaction_id"]/value)[1]', 'BIGINT') AS transaction_id,
                   c.value('(data[@name="resource_owner_type"]/text)[1]', 'NVARCHAR(256)') AS resource_owner_type,
                   c.value('(//@monitorLoop)[1]', 'INT') AS monitor_loop,
                   bg.value('(process/@spid)[1]', 'INT') AS spid,
                   bg.value('(process/@ecid)[1]', 'INT') AS ecid,
                   bg.value('(process/inputbuf/text())[1]', 'NVARCHAR(MAX)') AS query_text,
                   CONVERT(INT, NULL) AS wait_time,
                   CONVERT(NVARCHAR(256), NULL) AS transaction_name,
                   CONVERT(DATETIME2, NULL) AS last_transaction_started,
                   CONVERT(NVARCHAR(10), NULL) AS lock_mode,
                   bg.value('(process/@status)[1]', 'NVARCHAR(10)') AS status,
                   bg.value('(process/@priority)[1]', 'INT') AS priority,
                   bg.value('(process/@trancount)[1]', 'INT') AS transaction_count,
                   bg.value('(process/@clientapp)[1]', 'NVARCHAR(256)') AS client_app,
                   bg.value('(process/@hostname)[1]', 'NVARCHAR(256)') AS host_name,
                   bg.value('(process/@loginname)[1]', 'NVARCHAR(256)') AS login_name,
                   bg.value('(process/@isolationlevel)[1]', 'NVARCHAR(50)') AS isolation_level,
                   CONVERT(NVARCHAR(100), NULL) AS sqlhandle,
                   'blocking' AS activity,
                   c.query('.') AS blocked_process_report
            INTO #blocking
            FROM #human_events_xml AS xet
            OUTER APPLY xet.human_events_xml.nodes('//event') AS oa(c)
            OUTER APPLY oa.c.nodes('//blocked-process-report/blocking-process') AS bg(bg)
            OPTION (RECOMPILE);

            IF @debug = 1 BEGIN SELECT N'#blocking' AS table_name, * FROM #blocking AS wa OPTION (RECOMPILE); END;


            SELECT TOP (2147483647)
                kheb.event_time,
                kheb.database_name,
                kheb.contentious_object,
                kheb.activity,
                kheb.spid,
                kheb.query_text,
                kheb.wait_time,
                kheb.status,
                kheb.isolation_level,
                kheb.last_transaction_started,
                kheb.transaction_name,
                kheb.lock_mode,
                kheb.priority,
                kheb.transaction_count,
                kheb.client_app,
                kheb.host_name,
                kheb.login_name,
                kheb.blocked_process_report
            FROM 
            (
                SELECT *, OBJECT_NAME(object_id, database_id) AS contentious_object FROM #blocking
                UNION ALL 
                SELECT *, OBJECT_NAME(object_id, database_id) AS contentious_object FROM #blocked
            ) AS kheb
            ORDER BY kheb.event_time,
                     CASE WHEN kheb.activity = 'blocking' 
                          THEN 1
                          ELSE 999 
                     END
            OPTION(RECOMPILE);

END;

/*
End magic happening
*/

IF @keep_alive = 0
BEGIN
    IF @debug = 1 BEGIN RAISERROR(@stop_sql, 0, 1) WITH NOWAIT; END;
    RAISERROR(N'all done, stopping session', 0, 1) WITH NOWAIT;
    EXEC (@stop_sql);
    
    IF @debug = 1 BEGIN RAISERROR(@drop_sql, 0, 1) WITH NOWAIT; END;
   RAISERROR(N'and dropping session', 0, 1) WITH NOWAIT;
   EXEC (@drop_sql);
END;
RETURN;


/*This section handles outputting data to tables*/
output_results:
RAISERROR(N'Starting data collection.', 0, 1) WITH NOWAIT;
WHILE 1 = 1
    BEGIN
    
    /*If we don't find any sessions to poll from, wait 5 seconds and restart loop*/
    IF NOT EXISTS
    (
        SELECT 1/0
        FROM sys.server_event_sessions AS ses
        LEFT JOIN sys.dm_xe_sessions AS dxs
            ON dxs.name = ses.name
        WHERE ses.name LIKE N'keeper_HumanEvents_%'
        AND   dxs.create_time IS NOT NULL
    )
    BEGIN
        RAISERROR(N'No matching active session names found starting with keeper_HumanEvents ', 0, 1) WITH NOWAIT;
    END;

    /*If we find any stopped sessions, turn them back on*/
    IF EXISTS
    (
        SELECT 1/0
        FROM sys.server_event_sessions AS ses
        LEFT JOIN sys.dm_xe_sessions AS dxs
            ON dxs.name = ses.name
        WHERE ses.name LIKE N'keeper_HumanEvents_%'
        AND   dxs.create_time IS NULL
    )
    BEGIN
        
     DECLARE @the_sleeper_must_awaken NVARCHAR(MAX) = N'';    
     
     SELECT @the_sleeper_must_awaken += 
     N'ALTER EVENT SESSION ' + ses.name + N' ON SERVER STATE = START;' + NCHAR(10)
     FROM sys.server_event_sessions AS ses
     LEFT JOIN sys.dm_xe_sessions AS dxs
         ON dxs.name = ses.name
     WHERE ses.name LIKE N'keeper_HumanEvents_%'
     AND   dxs.create_time IS NULL
     OPTION (RECOMPILE);
     
     IF @debug = 1 BEGIN RAISERROR(@the_sleeper_must_awaken, 0, 1) WITH NOWAIT; END;
     
     EXEC sys.sp_executesql @the_sleeper_must_awaken;

    END;


    /*Create a table to hold loop info*/
    IF OBJECT_ID(N'tempdb..#human_events_worker') IS NULL
    BEGIN
        CREATE TABLE #human_events_worker
        (
            id INT NOT NULL PRIMARY KEY IDENTITY,
            event_type sysname NOT NULL,
            event_type_short sysname NOT NULL,
            is_table_created BIT NOT NULL DEFAULT 0,
            is_view_created BIT NOT NULL DEFAULT 0,
            last_checked DATETIME NOT NULL DEFAULT '19000101',
            last_updated DATETIME NOT NULL DEFAULT '19000101',
            output_database sysname NOT NULL,
            output_schema sysname NOT NULL,
            output_table NVARCHAR(400) NOT NULL
        );

        --don't want to fail on, or process duplicates
        CREATE UNIQUE NONCLUSTERED INDEX no_dupes 
            ON #human_events_worker (output_table) 
                WITH (IGNORE_DUP_KEY = ON);

        
        /*Insert any sessions we find*/
        INSERT #human_events_worker
            ( event_type, event_type_short, is_table_created, is_view_created, last_checked, 
              last_updated, output_database, output_schema, output_table )        
        SELECT s.name, N'', 0, 0, '19000101', '19000101', 
               @output_database_name, @output_schema_name, s.name
        FROM sys.server_event_sessions AS s
        LEFT JOIN sys.dm_xe_sessions AS r 
            ON r.name = s.name
        WHERE s.name LIKE N'keeper_HumanEvents_%'
        AND   r.create_time IS NOT NULL
        OPTION (RECOMPILE);

        /*If we're getting compiles, and the parameterization event is available*/
        /*Add a row to the table so we account for it*/
        IF @parameterization_events = 1
           AND EXISTS ( SELECT 1/0 
                        FROM #human_events_worker 
                        WHERE event_type LIKE N'keeper_HumanEvents_compiles%' )
        BEGIN
            INSERT #human_events_worker 
                ( event_type, event_type_short, is_table_created, is_view_created, last_checked, last_updated, 
                  output_database, output_schema, output_table )
            SELECT event_type + N'_parameterization', N'', 1, 0, last_checked, last_updated, 
                   output_database, output_schema, output_table + N'_parameterization'
            FROM #human_events_worker 
            WHERE event_type LIKE N'keeper_HumanEvents_compiles%'
            OPTION (RECOMPILE);
        END;

        /*Update this column for when we see if we need to create views.*/
        UPDATE hew
            SET hew.event_type_short = CASE WHEN hew.event_type LIKE N'%block%' 
                                        THEN N'[_]Blocking'
                                        WHEN ( hew.event_type LIKE N'%comp%' 
                                                 AND hew.event_type NOT LIKE N'%re%' )
                                        THEN N'[_]Compiles'
                                        WHEN hew.event_type LIKE N'%quer%'
                                        THEN N'[_]Queries'
                                        WHEN hew.event_type LIKE N'%recomp%'
                                        THEN N'[_]Recompiles'
                                        WHEN hew.event_type LIKE N'%wait%'
                                        THEN N'[_]Waits'
                                        ELSE N'?'
                                   END    
        FROM #human_events_worker AS hew
        WHERE hew.event_type_short = N''
        OPTION(RECOMPILE);

        IF @debug = 1 BEGIN SELECT N'#human_events_worker' AS table_name, * FROM #human_events_worker OPTION (RECOMPILE); END;

    END;

    /*This section is where tables that need tables get created*/
    IF EXISTS
    (
        SELECT 1/0
        FROM #human_events_worker AS hew
        WHERE hew.is_table_created = 0   
    )
    BEGIN
        RAISERROR(N'Sessions without tables found, starting loop.', 0, 1) WITH NOWAIT;
        DECLARE @min_id INT,
                @max_id INT,
                @event_type_check sysname,
                @object_name_check NVARCHAR(1000) = N'',
                @table_sql NVARCHAR(MAX) = N'';
        
        SELECT @min_id = MIN(hew.id), 
               @max_id = MAX(hew.id)
        FROM #human_events_worker AS hew
        WHERE hew.is_table_created = 0
        OPTION (RECOMPILE);
        
        RAISERROR(N'While, while, while...', 0, 1) WITH NOWAIT;
        WHILE @min_id <= @max_id
        BEGIN
            SELECT @event_type_check  = hew.event_type,
                   @object_name_check = QUOTENAME(hew.output_database)
                                      + N'.'
                                      + QUOTENAME(hew.output_schema)
                                      + N'.'
                                      + hew.output_table
            FROM #human_events_worker AS hew
            WHERE hew.id = @min_id
            AND   hew.is_table_created = 0
            OPTION (RECOMPILE);
        
            IF OBJECT_ID(@object_name_check) IS NULL
            BEGIN
            RAISERROR(N'Generating create table statement for %s', 0, 1, @event_type_check) WITH NOWAIT;
                SELECT @table_sql =  
                  CASE WHEN @event_type_check LIKE N'%wait%'
                       THEN N'CREATE TABLE ' + @object_name_check + NCHAR(10) +
                            N'( id BIGINT PRIMARY KEY IDENTITY, server_name sysname NULL, event_time DATETIME2 NULL, event_type sysname NULL,  ' + NCHAR(10) +
                            N'  database_name sysname NULL, wait_type NVARCHAR(60) NULL, duration_ms BIGINT NULL, signal_duration_ms BIGINT NULL, ' + NCHAR(10) +
                            N'  wait_resource NVARCHAR(256) NULL,  query_plan_hash_signed BINARY(8) NULL, query_hash_signed BINARY(8) NULL, plan_handle VARBINARY(64) NULL );'
                       WHEN @event_type_check LIKE N'%lock%'
                       THEN N'CREATE TABLE ' + @object_name_check + NCHAR(10) +
                            N'( id BIGINT PRIMARY KEY IDENTITY, server_name sysname NULL, event_time DATETIME2 NULL, ' + NCHAR(10) +
                            N'  activity NVARCHAR(20) NULL, database_name sysname NULL, database_id INT NULL, object_id BIGINT NULL, contentious_object AS OBJECT_NAME(object_id, database_id), ' + NCHAR(10) +
                            N'  transaction_id INT NULL, resource_owner_type NVARCHAR(256) NULL, monitor_loop INT NULL, spid INT NULL, ecid INT NULL, query_text NVARCHAR(MAX) NULL, ' + 
                            N'  wait_time BIGINT NULL, transaction_name NVARCHAR(256) NULL,  last_transaction_started NVARCHAR(30) NULL, ' + NCHAR(10) +
                            N'  lock_mode NVARCHAR(10) NULL, status NVARCHAR(10) NULL, priority INT NULL, transaction_count INT NULL, ' + NCHAR(10) +
                            N'  client_app sysname NULL, host_name sysname NULL, login_name sysname NULL, isolation_level NVARCHAR(30) NULL, sql_handle VARBINARY(64) NULL, blocked_process_report XML NULL );'
                       WHEN @event_type_check LIKE N'%quer%'
                       THEN N'CREATE TABLE ' + @object_name_check + NCHAR(10) +
                            N'( id BIGINT PRIMARY KEY IDENTITY, server_name sysname NULL, event_time DATETIME2 NULL, event_type sysname NULL, ' + NCHAR(10) +
                            N'  database_name sysname NULL, object_name NVARCHAR(512) NULL, sql_text NVARCHAR(MAX) NULL, statement NVARCHAR(MAX) NULL, ' + NCHAR(10) +
                            N'  showplan_xml XML NULL, cpu_ms DECIMAL(18,2) NULL, logical_reads DECIMAL(18,2) NULL, ' + NCHAR(10) +
                            N'  physical_reads DECIMAL(18,2) NULL,  duration_ms DECIMAL(18,2) NULL, writes_mb DECIMAL(18,2) NULL,' + NCHAR(10) +
                            N'  spills_mb DECIMAL(18,2) NULL, row_count DECIMAL(18,2) NULL, estimated_rows DECIMAL(18,2) NULL, dop INT NULL,  ' + NCHAR(10) +
                            N'  serial_ideal_memory_mb DECIMAL(18,2) NULL, requested_memory_mb DECIMAL(18,2) NULL, used_memory_mb DECIMAL(18,2) NULL, ideal_memory_mb DECIMAL(18,2) NULL, ' + NCHAR(10) +
                            N'  granted_memory_mb DECIMAL(18,2) NULL, query_plan_hash_signed BINARY(8) NULL, query_hash_signed BINARY(8) NULL, plan_handle VARBINARY(64) NULL );'
                       WHEN @event_type_check LIKE N'%recomp%'
                       THEN N'CREATE TABLE ' + @object_name_check + NCHAR(10) +
                            N'( id BIGINT PRIMARY KEY IDENTITY, server_name sysname NULL, event_time DATETIME2 NULL,  event_type sysname NULL,  ' + NCHAR(10) +
                            N'  database_name sysname NULL, object_name NVARCHAR(512) NULL, recompile_cause NVARCHAR(256) NULL, statement_text NVARCHAR(MAX) NULL, statement_text_checksum AS CHECKSUM(database_name + statement_text) PERSISTED '
                            + CASE WHEN @compile_events = 1 THEN N', compile_cpu_ms BIGINT NULL, compile_duration_ms BIGINT NULL );' ELSE N' );' END
                       WHEN @event_type_check LIKE N'%comp%' AND @event_type_check NOT LIKE N'%re%'
                       THEN N'CREATE TABLE ' + @object_name_check + NCHAR(10) +
                            N'( id BIGINT PRIMARY KEY IDENTITY, server_name sysname NULL, event_time DATETIME2 NULL,  event_type sysname NULL,  ' + NCHAR(10) +
                            N'  database_name sysname NULL, object_name NVARCHAR(512) NULL, statement_text NVARCHAR(MAX) NULL, statement_text_checksum AS CHECKSUM(database_name + statement_text) PERSISTED '
                            + CASE WHEN @compile_events = 1 THEN N', compile_cpu_ms BIGINT NULL, compile_duration_ms BIGINT NULL );' ELSE N' );' END
                            + CASE WHEN @parameterization_events = 1 
                                   THEN 
                            NCHAR(10) + 
                            N'CREATE TABLE ' + @object_name_check + N'_parameterization' + NCHAR(10) +
                            N'( id BIGINT PRIMARY KEY IDENTITY, server_name sysname NULL, event_time DATETIME2 NULL,  event_type sysname NULL,  ' + NCHAR(10) +
                            N'  database_name sysname NULL, sql_text NVARCHAR(MAX) NULL, compile_cpu_time_ms BIGINT NULL, compile_duration_ms BIGINT NULL, query_param_type INT NULL,  ' + NCHAR(10) +
                            N'  is_cached BIT NULL, is_recompiled BIT NULL, compile_code NVARCHAR(256) NULL, has_literals BIT NULL, is_parameterizable BIT NULL, parameterized_values_count BIGINT NULL, ' + NCHAR(10) +
                            N'  query_plan_hash BINARY(8) NULL, query_hash BINARY(8) NULL, plan_handle VARBINARY(64) NULL, statement_sql_hash VARBINARY(64) NULL );'
                                   ELSE N'' 
                              END  
                       ELSE N''
                  END;          
            END;        
            
            IF @debug = 1 BEGIN RAISERROR(@table_sql, 0, 1) WITH NOWAIT; END;
            EXEC sys.sp_executesql @table_sql;
            
            RAISERROR(N'Updating #human_events_worker to set is_table_created for %s', 0, 1, @event_type_check) WITH NOWAIT;
            UPDATE #human_events_worker SET is_table_created = 1 WHERE id = @min_id AND is_table_created = 0 OPTION (RECOMPILE);

            IF @debug = 1 BEGIN RAISERROR(N'@min_id: %i', 0, 1, @min_id) WITH NOWAIT; END;

            RAISERROR(N'Setting next id after %i out of %i total', 0, 1, @min_id, @max_id) WITH NOWAIT;
            
            SET @min_id = 
            (
                SELECT TOP (1) hew.id
                FROM #human_events_worker AS hew
                WHERE hew.id > @min_id
                AND   hew.is_table_created = 0
                ORDER BY hew.id
            );

            IF @debug = 1 BEGIN RAISERROR(N'new @min_id: %i', 0, 1, @min_id) WITH NOWAIT; END;

            IF @min_id IS NULL BREAK;

        END;
    END;

    /*This section handles creating or altering views*/
    IF EXISTS
    (   --Any views not created
        SELECT 1/0
        FROM #human_events_worker AS hew
        WHERE hew.is_table_created = 1
        AND   hew.is_view_created = 0
    ) 
    OR 
    (   --If the proc has been modified, maybe views have been added or changed?
        SELECT modify_date 
        FROM sys.all_objects
        WHERE type = N'P'
        AND name = N'sp_HumanEvents' 
    ) < DATEADD(HOUR, -1, SYSDATETIME())
    BEGIN

    RAISERROR(N'Found views to create, beginning!', 0, 1) WITH NOWAIT;

        IF OBJECT_ID(N'tempdb..#view_check') IS NULL
        BEGIN
            
            RAISERROR(N'#view_check doesn''t exist, creating and populating', 0, 1) WITH NOWAIT;
            
            CREATE TABLE #view_check 
            (
                id INT PRIMARY KEY IDENTITY, 
                view_name sysname NOT NULL, 
                view_definition VARBINARY(MAX) NOT NULL,
                output_database sysname NOT NULL DEFAULT N'',
                output_schema sysname NOT NULL DEFAULT N'',
                output_table sysname NOT NULL DEFAULT N'',
                view_converted AS CONVERT(NVARCHAR(MAX), view_definition), 
                view_converted_length AS DATALENGTH(CONVERT(NVARCHAR(MAX), view_definition))
            );
            --These binary values are the view definitions. If I didn't do this, I would have been adding >50k lines of code in here.
            INSERT #view_check (view_name, view_definition)
            SELECT N'HumanEvents_Blocking', 0x4300520045004100540045002000560049004500570020005B00640062006F005D002E005B00480075006D0061006E004500760065006E00740073005F0042006C006F0063006B0069006E0067005D000D000A00410053000D000A00530045004C00450043005400200054004F00500020002800320031003400370034003800330036003400370029000D000A00200020002000200020002000200020002000200020006B006800650062002E006500760065006E0074005F00740069006D0065002C000D000A00200020002000200020002000200020002000200020006B006800650062002E00640061007400610062006100730065005F006E0061006D0065002C000D000A00200020002000200020002000200020002000200020006B006800650062002E0063006F006E00740065006E00740069006F00750073005F006F0062006A006500630074002C000D000A00200020002000200020002000200020002000200020006B006800650062002E00610063007400690076006900740079002C000D000A00200020002000200020002000200020002000200020006B006800650062002E0073007000690064002C000D000A00200020002000200020002000200020002000200020006B006800650062002E00710075006500720079005F0074006500780074002C000D000A00200020002000200020002000200020002000200020006B006800650062002E0077006100690074005F00740069006D0065002C000D000A00200020002000200020002000200020002000200020006B006800650062002E007300740061007400750073002C000D000A00200020002000200020002000200020002000200020006B006800650062002E00690073006F006C006100740069006F006E005F006C006500760065006C002C000D000A00200020002000200020002000200020002000200020006B006800650062002E006C006100730074005F007400720061006E00730061006300740069006F006E005F0073007400610072007400650064002C000D000A00200020002000200020002000200020002000200020006B006800650062002E007400720061006E00730061006300740069006F006E005F006E0061006D0065002C000D000A00200020002000200020002000200020002000200020006B006800650062002E006C006F0063006B005F006D006F00640065002C000D000A00200020002000200020002000200020002000200020006B006800650062002E007000720069006F0072006900740079002C000D000A00200020002000200020002000200020002000200020006B006800650062002E007400720061006E00730061006300740069006F006E005F0063006F0075006E0074002C000D000A00200020002000200020002000200020002000200020006B006800650062002E0063006C00690065006E0074005F006100700070002C000D000A00200020002000200020002000200020002000200020006B006800650062002E0068006F00730074005F006E0061006D0065002C000D000A00200020002000200020002000200020002000200020006B006800650062002E006C006F00670069006E005F006E0061006D0065002C000D000A00200020002000200020002000200020002000200020006B006800650062002E0062006C006F0063006B00650064005F00700072006F0063006500730073005F007200650070006F00720074000D000A00460052004F004D002000640062006F002E006B00650065007000650072005F00480075006D0061006E004500760065006E00740073005F0062006C006F0063006B0069006E00670020004100530020006B006800650062000D000A004F00520044004500520020004200590020006B006800650062002E006500760065006E0074005F00740069006D0065002C000D000A00200020002000200020002000200020002000430041005300450020005700480045004E0020006B006800650062002E006100630074006900760069007400790020003D002000270062006C006F0063006B0069006E006700270020005400480045004E00200031000D000A002000200020002000200020002000200020002000200020002000200045004C0053004500200039003900390020000D000A0020002000200020002000200020002000200045004E0044000D000A00200020002000200020002000200020002000;
            INSERT #view_check (view_name, view_definition)
            SELECT N'HumanEvents_CompilesByDatabaseAndObject', 0x0D000A000D000A00430052004500410054004500200056004900450057002000640062006F002E00480075006D0061006E004500760065006E00740073005F0043006F006D00700069006C0065007300420079004400610074006100620061007300650041006E0064004F0062006A006500630074000D000A00410053000D000A002000200020002000530045004C00450043005400200054004F005000280020003200310034003700340038003300360034003800200029000D000A00200020002000200020002000200020002000200020004D0049004E0028006500760065006E0074005F00740069006D006500290020004100530020006D0069006E005F006500760065006E0074005F00740069006D0065002C000D000A00200020002000200020002000200020002000200020004D004100580028006500760065006E0074005F00740069006D006500290020004100530020006D00610078005F006500760065006E0074005F00740069006D0065002C000D000A0020002000200020002000200020002000200020002000640061007400610062006100730065005F006E0061006D0065002C000D000A0020002000200020002000200020002000200020002000430041005300450020005700480045004E0020006F0062006A006500630074005F006E0061006D00650020003D0020004E00270027000D000A0020002000200020002000200020002000200020002000200020002000200020005400480045004E0020004E0027004E002F00410027000D000A0020002000200020002000200020002000200020002000200020002000200045004C005300450020006F0062006A006500630074005F006E0061006D0065000D000A002000200020002000200020002000200020002000200045004E00440020004100530020006F0062006A006500630074005F006E0061006D0065002C000D000A002000200020002000200020002000200020002000200043004F0055004E0054005F0042004900470028002A002900200041005300200074006F00740061006C005F0063006F006D00700069006C00650073002C000D000A0020002000200020002000200020002000200020002000530055004D00280063006F006D00700069006C0065005F006300700075005F006D0073002900200041005300200074006F00740061006C005F0063006F006D00700069006C0065005F006300700075002C000D000A0020002000200020002000200020002000200020002000410056004700280063006F006D00700069006C0065005F006300700075005F006D007300290020004100530020006100760067005F0063006F006D00700069006C0065005F006300700075002C000D000A00200020002000200020002000200020002000200020004D0041005800280063006F006D00700069006C0065005F006300700075005F006D007300290020004100530020006D00610078005F0063006F006D00700069006C0065005F006300700075002C000D000A0020002000200020002000200020002000200020002000530055004D00280063006F006D00700069006C0065005F006400750072006100740069006F006E005F006D0073002900200041005300200074006F00740061006C005F0063006F006D00700069006C0065005F006400750072006100740069006F006E002C000D000A0020002000200020002000200020002000200020002000410056004700280063006F006D00700069006C0065005F006400750072006100740069006F006E005F006D007300290020004100530020006100760067005F0063006F006D00700069006C0065005F006400750072006100740069006F006E002C000D000A00200020002000200020002000200020002000200020004D0041005800280063006F006D00700069006C0065005F006400750072006100740069006F006E005F006D007300290020004100530020006D00610078005F0063006F006D00700069006C0065005F006400750072006100740069006F006E000D000A002000200020002000460052004F004D0020005B007200650070006C006100630065005F006D0065005D000D000A002000200020002000470052004F00550050002000420059002000640061007400610062006100730065005F006E0061006D0065002C0020006F0062006A006500630074005F006E0061006D0065000D000A0020002000200020004F005200440045005200200042005900200074006F00740061006C005F0063006F006D00700069006C0065007300200044004500530043003B000D000A00
            WHERE @compile_events = 1;
            INSERT #view_check (view_name, view_definition)
            SELECT N'HumanEvents_CompilesByDuration', 0x0D000A000D000A00430052004500410054004500200056004900450057002000640062006F002E00480075006D0061006E004500760065006E00740073005F0043006F006D00700069006C0065007300420079004400750072006100740069006F006E000D000A00410053000D000A002000200020002000570049005400480020006300620071000D000A0020002000200020002000200041005300200028000D000A00200020002000200020002000200020002000530045004C004500430054002000730074006100740065006D0065006E0074005F0074006500780074005F0063006800650063006B00730075006D002C000D000A00200020002000200020002000200020002000200020002000200020002000200043004F0055004E0054005F0042004900470028002A002900200041005300200074006F00740061006C005F0063006F006D00700069006C00650073002C000D000A002000200020002000200020002000200020002000200020002000200020002000530055004D00280063006F006D00700069006C0065005F006300700075005F006D0073002900200041005300200074006F00740061006C005F0063006F006D00700069006C0065005F006300700075002C000D000A002000200020002000200020002000200020002000200020002000200020002000410056004700280063006F006D00700069006C0065005F006300700075005F006D007300290020004100530020006100760067005F0063006F006D00700069006C0065005F006300700075002C000D000A0020002000200020002000200020002000200020002000200020002000200020004D0041005800280063006F006D00700069006C0065005F006300700075005F006D007300290020004100530020006D00610078005F0063006F006D00700069006C0065005F006300700075002C000D000A002000200020002000200020002000200020002000200020002000200020002000530055004D00280063006F006D00700069006C0065005F006400750072006100740069006F006E005F006D0073002900200041005300200074006F00740061006C005F0063006F006D00700069006C0065005F006400750072006100740069006F006E002C000D000A002000200020002000200020002000200020002000200020002000200020002000410056004700280063006F006D00700069006C0065005F006400750072006100740069006F006E005F006D007300290020004100530020006100760067005F0063006F006D00700069006C0065005F006400750072006100740069006F006E002C000D000A0020002000200020002000200020002000200020002000200020002000200020004D0041005800280063006F006D00700069006C0065005F006400750072006100740069006F006E005F006D007300290020004100530020006D00610078005F0063006F006D00700069006C0065005F006400750072006100740069006F006E000D000A00200020002000200020002000200020002000460052004F004D0020005B007200650070006C006100630065005F006D0065005D000D000A00200020002000200020002000200020002000470052004F00550050002000420059002000730074006100740065006D0065006E0074005F0074006500780074005F0063006800650063006B00730075006D000D000A0020002000200020002000200020002000200048004100560049004E0047002000410056004700280063006F006D00700069006C0065005F006400750072006100740069006F006E005F006D007300290020003E0020003100300030003000200029000D000A002000200020002000530045004C00450043005400200054004F005000280020003200310034003700340038003300360034003800200029000D000A00200020002000200020002000200020002000200020006B002E006F0062006A006500630074005F006E0061006D0065002C000D000A00200020002000200020002000200020002000200020006B002E00730074006100740065006D0065006E0074005F0074006500780074002C000D000A002000200020002000200020002000200020002000200063002E0074006F00740061006C005F0063006F006D00700069006C00650073002C000D000A002000200020002000200020002000200020002000200063002E0074006F00740061006C005F0063006F006D00700069006C0065005F006300700075002C000D000A002000200020002000200020002000200020002000200063002E006100760067005F0063006F006D00700069006C0065005F006300700075002C000D000A002000200020002000200020002000200020002000200063002E006D00610078005F0063006F006D00700069006C0065005F006300700075002C000D000A002000200020002000200020002000200020002000200063002E0074006F00740061006C005F0063006F006D00700069006C0065005F006400750072006100740069006F006E002C000D000A002000200020002000200020002000200020002000200063002E006100760067005F0063006F006D00700069006C0065005F006400750072006100740069006F006E002C000D000A002000200020002000200020002000200020002000200063002E006D00610078005F0063006F006D00700069006C0065005F006400750072006100740069006F006E000D000A002000200020002000460052004F004D002000630062007100200041005300200063000D000A002000200020002000430052004F005300530020004100500050004C0059000D000A002000200020002000200020002000200028000D000A00200020002000200020002000200020002000200020002000530045004C00450043005400200054004F005000280020003100200029000D000A0020002000200020002000200020002000200020002000200020002000200020002000200020002A000D000A00200020002000200020002000200020002000200020002000460052004F004D0020005B007200650070006C006100630065005F006D0065005D0020004100530020006B000D000A0020002000200020002000200020002000200020002000200057004800450052004500200063002E00730074006100740065006D0065006E0074005F0074006500780074005F0063006800650063006B00730075006D0020003D0020006B002E00730074006100740065006D0065006E0074005F0074006500780074005F0063006800650063006B00730075006D000D000A002000200020002000200020002000200020002000200020004F00520044004500520020004200590020006B002E0069006400200044004500530043000D000A0020002000200020002000200020002000290020004100530020006B000D000A0020002000200020004F005200440045005200200042005900200063002E006100760067005F0063006F006D00700069006C0065005F006400750072006100740069006F006E00200044004500530043003B000D000A00
            WHERE @compile_events = 1;
            INSERT #view_check (view_name, view_definition)
            SELECT N'HumanEvents_CompilesByQuery', 0x0D000A000D000A00430052004500410054004500200056004900450057002000640062006F002E00480075006D0061006E004500760065006E00740073005F0043006F006D00700069006C006500730042007900510075006500720079000D000A00410053000D000A002000200020002000570049005400480020006300620071000D000A0020002000200020002000200041005300200028000D000A00200020002000200020002000200020002000530045004C004500430054002000730074006100740065006D0065006E0074005F0074006500780074005F0063006800650063006B00730075006D002C000D000A00200020002000200020002000200020002000200020002000200020002000200043004F0055004E0054005F0042004900470028002A002900200041005300200074006F00740061006C005F0063006F006D00700069006C00650073002C000D000A002000200020002000200020002000200020002000200020002000200020002000530055004D00280063006F006D00700069006C0065005F006300700075005F006D0073002900200041005300200074006F00740061006C005F0063006F006D00700069006C0065005F006300700075002C000D000A002000200020002000200020002000200020002000200020002000200020002000410056004700280063006F006D00700069006C0065005F006300700075005F006D007300290020004100530020006100760067005F0063006F006D00700069006C0065005F006300700075002C000D000A0020002000200020002000200020002000200020002000200020002000200020004D0041005800280063006F006D00700069006C0065005F006300700075005F006D007300290020004100530020006D00610078005F0063006F006D00700069006C0065005F006300700075002C000D000A002000200020002000200020002000200020002000200020002000200020002000530055004D00280063006F006D00700069006C0065005F006400750072006100740069006F006E005F006D0073002900200041005300200074006F00740061006C005F0063006F006D00700069006C0065005F006400750072006100740069006F006E002C000D000A002000200020002000200020002000200020002000200020002000200020002000410056004700280063006F006D00700069006C0065005F006400750072006100740069006F006E005F006D007300290020004100530020006100760067005F0063006F006D00700069006C0065005F006400750072006100740069006F006E002C000D000A0020002000200020002000200020002000200020002000200020002000200020004D0041005800280063006F006D00700069006C0065005F006400750072006100740069006F006E005F006D007300290020004100530020006D00610078005F0063006F006D00700069006C0065005F006400750072006100740069006F006E000D000A00200020002000200020002000200020002000460052004F004D0020005B007200650070006C006100630065005F006D0065005D000D000A00200020002000200020002000200020002000470052004F00550050002000420059002000730074006100740065006D0065006E0074005F0074006500780074005F0063006800650063006B00730075006D000D000A0020002000200020002000200020002000200048004100560049004E004700200043004F0055004E0054005F0042004900470028002A00290020003E003D00200031003000200029000D000A002000200020002000530045004C00450043005400200054004F005000280020003200310034003700340038003300360034003800200029000D000A00200020002000200020002000200020002000200020006B002E006F0062006A006500630074005F006E0061006D0065002C000D000A00200020002000200020002000200020002000200020006B002E00730074006100740065006D0065006E0074005F0074006500780074002C000D000A002000200020002000200020002000200020002000200063002E0074006F00740061006C005F0063006F006D00700069006C00650073002C000D000A002000200020002000200020002000200020002000200063002E0074006F00740061006C005F0063006F006D00700069006C0065005F006300700075002C000D000A002000200020002000200020002000200020002000200063002E006100760067005F0063006F006D00700069006C0065005F006300700075002C000D000A002000200020002000200020002000200020002000200063002E006D00610078005F0063006F006D00700069006C0065005F006300700075002C000D000A002000200020002000200020002000200020002000200063002E0074006F00740061006C005F0063006F006D00700069006C0065005F006400750072006100740069006F006E002C000D000A002000200020002000200020002000200020002000200063002E006100760067005F0063006F006D00700069006C0065005F006400750072006100740069006F006E002C000D000A002000200020002000200020002000200020002000200063002E006D00610078005F0063006F006D00700069006C0065005F006400750072006100740069006F006E000D000A002000200020002000460052004F004D002000630062007100200041005300200063000D000A002000200020002000430052004F005300530020004100500050004C0059000D000A002000200020002000200020002000200028000D000A00200020002000200020002000200020002000200020002000530045004C00450043005400200054004F005000280020003100200029000D000A0020002000200020002000200020002000200020002000200020002000200020002000200020002A000D000A00200020002000200020002000200020002000200020002000460052004F004D0020005B007200650070006C006100630065005F006D0065005D0020004100530020006B000D000A0020002000200020002000200020002000200020002000200057004800450052004500200063002E00730074006100740065006D0065006E0074005F0074006500780074005F0063006800650063006B00730075006D0020003D0020006B002E00730074006100740065006D0065006E0074005F0074006500780074005F0063006800650063006B00730075006D000D000A002000200020002000200020002000200020002000200020004F00520044004500520020004200590020006B002E0069006400200044004500530043000D000A0020002000200020002000200020002000290020004100530020006B000D000A0020002000200020004F005200440045005200200042005900200063002E0074006F00740061006C005F0063006F006D00700069006C0065007300200044004500530043003B000D000A00
            WHERE @compile_events = 1;
            INSERT #view_check (view_name, view_definition)
            SELECT N'HumanEvents_Parameterization', 0x0D000A000D000A00430052004500410054004500200056004900450057002000640062006F002E00480075006D0061006E004500760065006E00740073005F0050006100720061006D00650074006500720069007A006100740069006F006E000D000A00410053000D000A002000200020002000570049005400480020006300700071000D000A0020002000200020002000200041005300200028000D000A00200020002000200020002000200020002000530045004C004500430054002000640061007400610062006100730065005F006E0061006D0065002C000D000A002000200020002000200020002000200020002000200020002000200020002000710075006500720079005F0068006100730068002C000D000A00200020002000200020002000200020002000200020002000200020002000200043004F0055004E0054005F0042004900470028002A002900200041005300200074006F00740061006C005F0063006F006D00700069006C00650073002C000D000A00200020002000200020002000200020002000200020002000200020002000200043004F0055004E0054002800440049005300540049004E00430054002000710075006500720079005F0070006C0061006E005F0068006100730068002900200041005300200070006C0061006E005F0063006F0075006E0074002C000D000A002000200020002000200020002000200020002000200020002000200020002000530055004D00280063006F006D00700069006C0065005F006300700075005F00740069006D0065005F006D0073002900200041005300200074006F00740061006C005F0063006F006D00700069006C0065005F006300700075002C000D000A002000200020002000200020002000200020002000200020002000200020002000410056004700280063006F006D00700069006C0065005F006300700075005F00740069006D0065005F006D007300290020004100530020006100760067005F0063006F006D00700069006C0065005F006300700075002C000D000A0020002000200020002000200020002000200020002000200020002000200020004D0041005800280063006F006D00700069006C0065005F006300700075005F00740069006D0065005F006D007300290020004100530020006D00610078005F0063006F006D00700069006C0065005F006300700075002C000D000A002000200020002000200020002000200020002000200020002000200020002000530055004D00280063006F006D00700069006C0065005F006400750072006100740069006F006E005F006D0073002900200041005300200074006F00740061006C005F0063006F006D00700069006C0065005F006400750072006100740069006F006E002C000D000A002000200020002000200020002000200020002000200020002000200020002000410056004700280063006F006D00700069006C0065005F006400750072006100740069006F006E005F006D007300290020004100530020006100760067005F0063006F006D00700069006C0065005F006400750072006100740069006F006E002C000D000A0020002000200020002000200020002000200020002000200020002000200020004D0041005800280063006F006D00700069006C0065005F006400750072006100740069006F006E005F006D007300290020004100530020006D00610078005F0063006F006D00700069006C0065005F006400750072006100740069006F006E000D000A00200020002000200020002000200020002000460052004F004D0020005B007200650070006C006100630065005F006D0065005D000D000A00200020002000200020002000200020002000470052004F00550050002000420059002000640061007400610062006100730065005F006E0061006D0065002C002000710075006500720079005F006800610073006800200029000D000A002000200020002000530045004C00450043005400200054004F005000280020003200310034003700340038003300360034003800200029000D000A002000200020002000200020002000200020002000200063002E00640061007400610062006100730065005F006E0061006D0065002C000D000A00200020002000200020002000200020002000200020006B002E00730071006C005F0074006500780074002C000D000A00200020002000200020002000200020002000200020006B002E00690073005F0070006100720061006D00650074006500720069007A00610062006C0065002C000D000A002000200020002000200020002000200020002000200063002E0074006F00740061006C005F0063006F006D00700069006C00650073002C000D000A002000200020002000200020002000200020002000200063002E0070006C0061006E005F0063006F0075006E0074002C000D000A002000200020002000200020002000200020002000200063002E0074006F00740061006C005F0063006F006D00700069006C0065005F006300700075002C000D000A002000200020002000200020002000200020002000200063002E006100760067005F0063006F006D00700069006C0065005F006300700075002C000D000A002000200020002000200020002000200020002000200063002E006D00610078005F0063006F006D00700069006C0065005F006300700075002C000D000A002000200020002000200020002000200020002000200063002E0074006F00740061006C005F0063006F006D00700069006C0065005F006400750072006100740069006F006E002C000D000A002000200020002000200020002000200020002000200063002E006100760067005F0063006F006D00700069006C0065005F006400750072006100740069006F006E002C000D000A002000200020002000200020002000200020002000200063002E006D00610078005F0063006F006D00700069006C0065005F006400750072006100740069006F006E002C000D000A00200020002000200020002000200020002000200020006B002E00710075006500720079005F0070006100720061006D005F0074007900700065002C000D000A00200020002000200020002000200020002000200020006B002E00690073005F006300610063006800650064002C000D000A00200020002000200020002000200020002000200020006B002E00690073005F007200650063006F006D00700069006C00650064002C000D000A00200020002000200020002000200020002000200020006B002E0063006F006D00700069006C0065005F0063006F00640065002C000D000A00200020002000200020002000200020002000200020006B002E006800610073005F006C00690074006500720061006C0073002C000D000A00200020002000200020002000200020002000200020006B002E0070006100720061006D00650074006500720069007A00650064005F00760061006C007500650073005F0063006F0075006E0074000D000A002000200020002000460052004F004D002000630070007100200041005300200063000D000A002000200020002000430052004F005300530020004100500050004C0059000D000A002000200020002000200020002000200028000D000A00200020002000200020002000200020002000200020002000530045004C00450043005400200054004F005000280020003100200029000D000A0020002000200020002000200020002000200020002000200020002000200020002000200020002A000D000A00200020002000200020002000200020002000200020002000460052004F004D0020005B007200650070006C006100630065005F006D0065005D0020004100530020006B000D000A002000200020002000200020002000200020002000200020005700480045005200450020006B002E00710075006500720079005F00680061007300680020003D00200063002E00710075006500720079005F0068006100730068000D000A002000200020002000200020002000200020002000200020004F00520044004500520020004200590020006B002E0069006400200044004500530043000D000A0020002000200020002000200020002000290020004100530020006B000D000A0020002000200020004F005200440045005200200042005900200063002E0074006F00740061006C005F0063006F006D00700069006C0065007300200044004500530043003B000D000A00
            WHERE @parameterization_events = 1;
            INSERT #view_check (view_name, view_definition)
            SELECT N'HumanEvents_Queries', 0x4300520045004100540045002000560049004500570020005B00640062006F005D002E005B00480075006D0061006E004500760065006E00740073005F0051007500650072006900650073005D000D000A00410053000D000A00200020002000200057004900540048002000710075006500720079005F0061006700670020004100530020000D000A00200020002000200020002000200020002000200020002000200028000D000A002000200020002000200020002000200020002000200020002000200020002000530045004C00450043005400200071002E00710075006500720079005F0070006C0061006E005F0068006100730068005F007300690067006E00650064002C000D000A002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200071002E00710075006500720079005F0068006100730068005F007300690067006E00650064002C000D000A002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200071002E0070006C0061006E005F00680061006E0064006C0065002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000490053004E0055004C004C00280071002E006300700075005F006D0073002C00200030002E002900200041005300200074006F00740061006C005F006300700075005F006D0073002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000490053004E0055004C004C00280071002E006C006F0067006900630061006C005F00720065006100640073002C00200030002E002900200041005300200074006F00740061006C005F006C006F0067006900630061006C005F00720065006100640073002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000490053004E0055004C004C00280071002E0070006800790073006900630061006C005F00720065006100640073002C00200030002E002900200041005300200074006F00740061006C005F0070006800790073006900630061006C005F00720065006100640073002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000490053004E0055004C004C00280071002E006400750072006100740069006F006E005F006D0073002C00200030002E002900200041005300200074006F00740061006C005F006400750072006100740069006F006E005F006D0073002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000490053004E0055004C004C00280071002E007700720069007400650073005F006D0062002C00200030002E002900200041005300200074006F00740061006C005F007700720069007400650073005F006D0062002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000490053004E0055004C004C00280071002E007300700069006C006C0073005F006D0062002C00200030002E002900200041005300200074006F00740061006C005F007300700069006C006C0073005F006D0062002C000D000A00200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020004E0055004C004C00200041005300200074006F00740061006C005F0075007300650064005F006D0065006D006F00720079005F006D0062002C000D000A00200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020004E0055004C004C00200041005300200074006F00740061006C005F006700720061006E007400650064005F006D0065006D006F00720079005F006D0062002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000490053004E0055004C004C00280071002E0072006F0077005F0063006F0075006E0074002C00200030002E002900200041005300200074006F00740061006C005F0072006F00770073002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000490053004E0055004C004C00280071002E006300700075005F006D0073002C00200030002E00290020004100530020006100760067005F006300700075005F006D0073002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000490053004E0055004C004C00280071002E006C006F0067006900630061006C005F00720065006100640073002C00200030002E00290020004100530020006100760067005F006C006F0067006900630061006C005F00720065006100640073002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000490053004E0055004C004C00280071002E0070006800790073006900630061006C005F00720065006100640073002C00200030002E00290020004100530020006100760067005F0070006800790073006900630061006C005F00720065006100640073002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000490053004E0055004C004C00280071002E006400750072006100740069006F006E005F006D0073002C00200030002E00290020004100530020006100760067005F006400750072006100740069006F006E005F006D0073002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000490053004E0055004C004C00280071002E007700720069007400650073005F006D0062002C00200030002E00290020004100530020006100760067005F007700720069007400650073005F006D0062002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000490053004E0055004C004C00280071002E007300700069006C006C0073005F006D0062002C00200030002E00290020004100530020006100760067005F007300700069006C006C0073005F006D0062002C000D000A00200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020004E0055004C004C0020004100530020006100760067005F0075007300650064005F006D0065006D006F00720079005F006D0062002C000D000A00200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020004E0055004C004C0020004100530020006100760067005F006700720061006E007400650064005F006D0065006D006F00720079005F006D0062002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000490053004E0055004C004C00280071002E0072006F0077005F0063006F0075006E0074002C0020003000290020004100530020006100760067005F0072006F0077007300200020002000200020002000200020002000200020002000200020002000200020002000200020000D000A002000200020002000200020002000200020002000200020002000200020002000460052004F004D0020005B007200650070006C006100630065005F006D0065005D00200041005300200071000D000A00200020002000200020002000200020002000200020002000200020002000200057004800450052004500200071002E006500760065006E0074005F00740079007000650020003C003E0020004E002700710075006500720079005F0070006F00730074005F0065007800650063007500740069006F006E005F00730068006F00770070006C0061006E0027000D000A0020002000200020002000200020002000200020002000200020002000200020000D000A00200020002000200020002000200020002000200020002000200020002000200055004E0049004F004E00200041004C004C0020000D000A0020002000200020002000200020002000200020002000200020002000200020000D000A002000200020002000200020002000200020002000200020002000200020002000530045004C00450043005400200071002E00710075006500720079005F0070006C0061006E005F0068006100730068005F007300690067006E00650064002C000D000A002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200071002E00710075006500720079005F0068006100730068005F007300690067006E00650064002C000D000A002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200071002E0070006C0061006E005F00680061006E0064006C0065002C000D000A00200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002F002A0074006F00740061006C0073002A002F000D000A00200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020004E0055004C004C00200041005300200074006F00740061006C005F006300700075005F006D0073002C000D000A00200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020004E0055004C004C00200041005300200074006F00740061006C005F006C006F0067006900630061006C005F00720065006100640073002C000D000A00200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020004E0055004C004C00200041005300200074006F00740061006C005F0070006800790073006900630061006C005F00720065006100640073002C000D000A00200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020004E0055004C004C00200041005300200074006F00740061006C005F006400750072006100740069006F006E005F006D0073002C000D000A00200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020004E0055004C004C00200041005300200074006F00740061006C005F007700720069007400650073002C000D000A00200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020004E0055004C004C00200041005300200074006F00740061006C005F007300700069006C006C0073005F006D0062002C002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020000D000A0020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000490053004E0055004C004C00280075007300650064005F006D0065006D006F00720079005F006D0062002C00200030002E002900200041005300200074006F00740061006C005F0075007300650064005F006D0065006D006F00720079005F006D0062002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000490053004E0055004C004C0028006700720061006E007400650064005F006D0065006D006F00720079005F006D0062002C00200030002E002900200041005300200074006F00740061006C005F006700720061006E007400650064005F006D0065006D006F00720079005F006D0062002C000D000A00200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020004E0055004C004C00200041005300200074006F00740061006C005F0072006F00770073002C000D000A00200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002F002A00610076006500720061006700650073002A002F000D000A00200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020004E0055004C004C0020004100530020006100760067005F006300700075005F006D0073002C000D000A00200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020004E0055004C004C0020004100530020006100760067005F006C006F0067006900630061006C005F00720065006100640073002C000D000A00200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020004E0055004C004C0020004100530020006100760067005F0070006800790073006900630061006C005F00720065006100640073002C000D000A00200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020004E0055004C004C0020004100530020006100760067005F006400750072006100740069006F006E005F006D0073002C000D000A00200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020004E0055004C004C0020004100530020006100760067005F007700720069007400650073005F006D0062002C000D000A00200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020004E0055004C004C0020004100530020006100760067005F007300700069006C006C0073005F006D0062002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000490053004E0055004C004C00280071002E0075007300650064005F006D0065006D006F00720079005F006D0062002C00200030002E00290020004100530020006100760067005F0075007300650064005F006D0065006D006F00720079005F006D0062002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000490053004E0055004C004C00280071002E006700720061006E007400650064005F006D0065006D006F00720079005F006D0062002C00200030002E00290020004100530020006100760067005F006700720061006E007400650064005F006D0065006D006F00720079005F006D0062002C000D000A00200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020004E0055004C004C0020004100530020006100760067005F0072006F0077007300200020002000200020002000200020002000200020002000200020002000200020002000200020000D000A002000200020002000200020002000200020002000200020002000200020002000460052004F004D0020005B007200650070006C006100630065005F006D0065005D00200041005300200071000D000A00200020002000200020002000200020002000200020002000200020002000200057004800450052004500200071002E006500760065006E0074005F00740079007000650020003D0020004E002700710075006500720079005F0070006F00730074005F0065007800650063007500740069006F006E005F00730068006F00770070006C0061006E002700200020002000200020002000200020000D000A00200020002000200020002000200020002000200020002000200029002C002000200020002000200020002000200020002000200020002000200020002000200020000D000A0020002000200020002000200020002000200074006F00740061006C0073000D000A0020002000200020002000200041005300200028002000530045004C00450043005400200054004F005000280020003200310034003700340038003300360034003800200029000D000A0020002000200020002000200020002000200020002000200020002000200020002000200071002E00710075006500720079005F0070006C0061006E005F0068006100730068005F007300690067006E00650064002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200071002E00710075006500720079005F0068006100730068005F007300690067006E00650064002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200071002E0070006C0061006E005F00680061006E0064006C0065002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200043004F0055004E0054005F0042004900470028002A00290020004F0056004500520020002800200050004100520054004900540049004F004E00200042005900200071002E00710075006500720079005F0070006C0061006E005F0068006100730068005F007300690067006E00650064002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200071002E00710075006500720079005F0068006100730068005F007300690067006E00650064002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200071002E0070006C0061006E005F00680061006E0064006C0065000D000A002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002900200041005300200065007800650063007500740069006F006E0073002C000D000A002000200020002000200020002000200020002000200020002000200020002000200020002F002A0074006F00740061006C0073002A002F000D000A00200020002000200020002000200020002000200020002000200020002000200020002000530055004D002800490053004E0055004C004C00280071002E0074006F00740061006C005F006300700075005F006D0073002C00200030002E0029002900200041005300200074006F00740061006C005F006300700075005F006D0073002C000D000A00200020002000200020002000200020002000200020002000200020002000200020002000530055004D002800490053004E0055004C004C00280071002E0074006F00740061006C005F006C006F0067006900630061006C005F00720065006100640073002C00200030002E0029002900200041005300200074006F00740061006C005F006C006F0067006900630061006C005F00720065006100640073002C000D000A00200020002000200020002000200020002000200020002000200020002000200020002000530055004D002800490053004E0055004C004C00280071002E0074006F00740061006C005F0070006800790073006900630061006C005F00720065006100640073002C00200030002E0029002900200041005300200074006F00740061006C005F0070006800790073006900630061006C005F00720065006100640073002C000D000A00200020002000200020002000200020002000200020002000200020002000200020002000530055004D002800490053004E0055004C004C00280071002E0074006F00740061006C005F006400750072006100740069006F006E005F006D0073002C00200030002E0029002900200041005300200074006F00740061006C005F006400750072006100740069006F006E005F006D0073002C000D000A00200020002000200020002000200020002000200020002000200020002000200020002000530055004D002800490053004E0055004C004C00280071002E0074006F00740061006C005F007700720069007400650073005F006D0062002C00200030002E0029002900200041005300200074006F00740061006C005F007700720069007400650073002C000D000A00200020002000200020002000200020002000200020002000200020002000200020002000530055004D002800490053004E0055004C004C00280071002E0074006F00740061006C005F007300700069006C006C0073005F006D0062002C00200030002E0029002900200041005300200074006F00740061006C005F007300700069006C006C0073005F006D0062002C000D000A00200020002000200020002000200020002000200020002000200020002000200020002000530055004D002800490053004E0055004C004C00280071002E0074006F00740061006C005F0075007300650064005F006D0065006D006F00720079005F006D0062002C00200030002E0029002900200041005300200074006F00740061006C005F0075007300650064005F006D0065006D006F00720079005F006D0062002C000D000A00200020002000200020002000200020002000200020002000200020002000200020002000530055004D002800490053004E0055004C004C00280071002E0074006F00740061006C005F006700720061006E007400650064005F006D0065006D006F00720079005F006D0062002C00200030002E0029002900200041005300200074006F00740061006C005F006700720061006E007400650064005F006D0065006D006F00720079005F006D0062002C000D000A00200020002000200020002000200020002000200020002000200020002000200020002000530055004D002800490053004E0055004C004C00280071002E0074006F00740061006C005F0072006F00770073002C00200030002E0029002900200041005300200074006F00740061006C005F0072006F00770073002C000D000A002000200020002000200020002000200020002000200020002000200020002000200020002F002A00610076006500720061006700650073002A002F000D000A002000200020002000200020002000200020002000200020002000200020002000200020004100560047002800490053004E0055004C004C00280071002E006100760067005F006300700075005F006D0073002C00200030002E002900290020004100530020006100760067005F006300700075005F006D0073002C000D000A002000200020002000200020002000200020002000200020002000200020002000200020004100560047002800490053004E0055004C004C00280071002E006100760067005F006C006F0067006900630061006C005F00720065006100640073002C00200030002E002900290020004100530020006100760067005F006C006F0067006900630061006C005F00720065006100640073002C000D000A002000200020002000200020002000200020002000200020002000200020002000200020004100560047002800490053004E0055004C004C00280071002E006100760067005F0070006800790073006900630061006C005F00720065006100640073002C00200030002E002900290020004100530020006100760067005F0070006800790073006900630061006C005F00720065006100640073002C000D000A002000200020002000200020002000200020002000200020002000200020002000200020004100560047002800490053004E0055004C004C00280071002E006100760067005F006400750072006100740069006F006E005F006D0073002C00200030002E002900290020004100530020006100760067005F006400750072006100740069006F006E005F006D0073002C000D000A002000200020002000200020002000200020002000200020002000200020002000200020004100560047002800490053004E0055004C004C00280071002E006100760067005F007700720069007400650073005F006D0062002C00200030002E002900290020004100530020006100760067005F007700720069007400650073002C000D000A002000200020002000200020002000200020002000200020002000200020002000200020004100560047002800490053004E0055004C004C00280071002E006100760067005F007300700069006C006C0073005F006D0062002C00200030002E002900290020004100530020006100760067005F007300700069006C006C0073005F006D0062002C000D000A002000200020002000200020002000200020002000200020002000200020002000200020004100560047002800490053004E0055004C004C00280071002E006100760067005F0075007300650064005F006D0065006D006F00720079005F006D0062002C00200030002E002900290020004100530020006100760067005F0075007300650064005F006D0065006D006F00720079005F006D0062002C000D000A002000200020002000200020002000200020002000200020002000200020002000200020004100560047002800490053004E0055004C004C00280071002E006100760067005F006700720061006E007400650064005F006D0065006D006F00720079005F006D0062002C00200030002E002900290020004100530020006100760067005F006700720061006E007400650064005F006D0065006D006F00720079005F006D0062002C000D000A002000200020002000200020002000200020002000200020002000200020002000200020004100560047002800490053004E0055004C004C00280071002E006100760067005F0072006F00770073002C00200030002900290020004100530020006100760067005F0072006F00770073000D000A0020002000200020002000200020002000200020002000460052004F004D002000710075006500720079005F00610067006700200041005300200071000D000A0020002000200020002000200020002000200020002000470052004F0055005000200042005900200071002E00710075006500720079005F0070006C0061006E005F0068006100730068005F007300690067006E00650064002C000D000A002000200020002000200020002000200020002000200020002000200020002000200020002000200071002E00710075006500720079005F0068006100730068005F007300690067006E00650064002C000D000A002000200020002000200020002000200020002000200020002000200020002000200020002000200071002E0070006C0061006E005F00680061006E0064006C006500200029002C000D000A00200020002000200020002000200020002000710075006500720079005F0072006500730075006C00740073000D000A0020002000200020002000200041005300200028002000530045004C00450043005400200054004F005000280020003200310034003700340038003300360034003800200029000D000A0020002000200020002000200020002000200020002000200020002000200020002000200071002E006500760065006E0074005F00740069006D0065002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200071002E00640061007400610062006100730065005F006E0061006D0065002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200071002E006F0062006A006500630074005F006E0061006D0065002C000D000A00200020002000200020002000200020002000200020002000200020002000200020002000710032002E00730074006100740065006D0065006E0074005F0074006500780074002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200071002E00730071006C005F0074006500780074002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200071002E00730068006F00770070006C0061006E005F0078006D006C002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200074002E0065007800650063007500740069006F006E0073002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200074002E0074006F00740061006C005F006300700075005F006D0073002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200074002E006100760067005F006300700075005F006D0073002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200074002E0074006F00740061006C005F006C006F0067006900630061006C005F00720065006100640073002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200074002E006100760067005F006C006F0067006900630061006C005F00720065006100640073002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200074002E0074006F00740061006C005F0070006800790073006900630061006C005F00720065006100640073002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200074002E006100760067005F0070006800790073006900630061006C005F00720065006100640073002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200074002E0074006F00740061006C005F006400750072006100740069006F006E005F006D0073002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200074002E006100760067005F006400750072006100740069006F006E005F006D0073002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200074002E0074006F00740061006C005F007700720069007400650073002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200074002E006100760067005F007700720069007400650073002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200074002E0074006F00740061006C005F007300700069006C006C0073005F006D0062002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200074002E006100760067005F007300700069006C006C0073005F006D0062002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200074002E0074006F00740061006C005F0075007300650064005F006D0065006D006F00720079005F006D0062002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200074002E006100760067005F0075007300650064005F006D0065006D006F00720079005F006D0062002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200074002E0074006F00740061006C005F006700720061006E007400650064005F006D0065006D006F00720079005F006D0062002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200074002E006100760067005F006700720061006E007400650064005F006D0065006D006F00720079005F006D0062002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200074002E0074006F00740061006C005F0072006F00770073002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200074002E006100760067005F0072006F00770073002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200071002E00730065007200690061006C005F0069006400650061006C005F006D0065006D006F00720079005F006D0062002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200071002E007200650071007500650073007400650064005F006D0065006D006F00720079005F006D0062002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200071002E0069006400650061006C005F006D0065006D006F00720079005F006D0062002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200071002E0065007300740069006D0061007400650064005F0072006F00770073002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200071002E0064006F0070002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200071002E00710075006500720079005F0070006C0061006E005F0068006100730068005F007300690067006E00650064002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200071002E00710075006500720079005F0068006100730068005F007300690067006E00650064002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200071002E0070006C0061006E005F00680061006E0064006C0065002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200052004F0057005F004E0055004D004200450052002800290020004F0056004500520020002800200050004100520054004900540049004F004E00200042005900200071002E00710075006500720079005F0070006C0061006E005F0068006100730068005F007300690067006E00650064002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200071002E00710075006500720079005F0068006100730068005F007300690067006E00650064002C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200071002E0070006C0061006E005F00680061006E0064006C0065000D000A00200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020004F005200440045005200200042005900200071002E00710075006500720079005F0070006C0061006E005F0068006100730068005F007300690067006E00650064002C000D000A002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200071002E00710075006500720079005F0068006100730068005F007300690067006E00650064002C000D000A002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200071002E0070006C0061006E005F00680061006E0064006C0065000D000A00200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000290020004100530020006E000D000A0020002000200020002000200020002000200020002000460052004F004D0020005B007200650070006C006100630065005F006D0065005D00200041005300200071000D000A00200020002000200020002000200020002000200020004A004F0049004E00200074006F00740061006C007300200041005300200074000D000A002000200020002000200020002000200020002000200020002000200020004F004E002000200071002E00710075006500720079005F0068006100730068005F007300690067006E006500640020003D00200074002E00710075006500720079005F0068006100730068005F007300690067006E00650064000D000A0020002000200020002000200020002000200020002000200020002000200041004E004400200071002E00710075006500720079005F0070006C0061006E005F0068006100730068005F007300690067006E006500640020003D00200074002E00710075006500720079005F0070006C0061006E005F0068006100730068005F007300690067006E00650064000D000A0020002000200020002000200020002000200020002000200020002000200041004E004400200071002E0070006C0061006E005F00680061006E0064006C00650020003D00200074002E0070006C0061006E005F00680061006E0064006C0065000D000A0020002000200020002000200020002000200020002000430052004F005300530020004100500050004C0059000D000A0020002000200020002000200020002000200020002000200020002000200028000D000A002000200020002000200020002000200020002000200020002000200020002000200020002000530045004C00450043005400200054004F005000280020003100200029002000710032002E00730074006100740065006D0065006E0074002000410053002000730074006100740065006D0065006E0074005F0074006500780074000D000A002000200020002000200020002000200020002000200020002000200020002000200020002000460052004F004D0020005B007200650070006C006100630065005F006D0065005D002000410053002000710032000D000A00200020002000200020002000200020002000200020002000200020002000200020002000200057004800450052004500200071002E00710075006500720079005F0068006100730068005F007300690067006E006500640020003D002000710032002E00710075006500720079005F0068006100730068005F007300690067006E00650064000D000A00200020002000200020002000200020002000200020002000200020002000200020002000200041004E00440020002000200071002E00710075006500720079005F0070006C0061006E005F0068006100730068005F007300690067006E006500640020003D002000710032002E00710075006500720079005F0070006C0061006E005F0068006100730068005F007300690067006E00650064000D000A00200020002000200020002000200020002000200020002000200020002000200020002000200041004E00440020002000200071002E0070006C0061006E005F00680061006E0064006C00650020003D002000710032002E0070006C0061006E005F00680061006E0064006C0065000D000A00200020002000200020002000200020002000200020002000200020002000200020002000200041004E004400200020002000710032002E00730074006100740065006D0065006E00740020004900530020004E004F00540020004E0055004C004C000D000A0020002000200020002000200020002000200020002000200020002000200020002000200020004F0052004400450052002000420059002000710032002E006500760065006E0074005F00740069006D006500200044004500530043000D000A0020002000200020002000200020002000200020002000200020002000200029002000410053002000710032000D000A002000200020002000200020002000200020002000200057004800450052004500200071002E00730068006F00770070006C0061006E005F0078006D006C002E0065007800690073007400280027002A002700290020003D0020003100200029000D000A002000200020002000530045004C00450043005400200054004F005000280020003200310034003700340038003300360034003800200029000D000A002000200020002000200020002000200020002000200071002E006500760065006E0074005F00740069006D0065002C000D000A002000200020002000200020002000200020002000200071002E00640061007400610062006100730065005F006E0061006D0065002C000D000A002000200020002000200020002000200020002000200071002E006F0062006A006500630074005F006E0061006D0065002C000D000A002000200020002000200020002000200020002000200071002E00730074006100740065006D0065006E0074005F0074006500780074002C000D000A002000200020002000200020002000200020002000200071002E00730071006C005F0074006500780074002C000D000A002000200020002000200020002000200020002000200071002E00730068006F00770070006C0061006E005F0078006D006C002C000D000A002000200020002000200020002000200020002000200071002E0065007800650063007500740069006F006E0073002C000D000A002000200020002000200020002000200020002000200071002E0074006F00740061006C005F006300700075005F006D0073002C000D000A002000200020002000200020002000200020002000200071002E006100760067005F006300700075005F006D0073002C000D000A002000200020002000200020002000200020002000200071002E0074006F00740061006C005F006C006F0067006900630061006C005F00720065006100640073002C000D000A002000200020002000200020002000200020002000200071002E006100760067005F006C006F0067006900630061006C005F00720065006100640073002C000D000A002000200020002000200020002000200020002000200071002E0074006F00740061006C005F0070006800790073006900630061006C005F00720065006100640073002C000D000A002000200020002000200020002000200020002000200071002E006100760067005F0070006800790073006900630061006C005F00720065006100640073002C000D000A002000200020002000200020002000200020002000200071002E0074006F00740061006C005F006400750072006100740069006F006E005F006D0073002C000D000A002000200020002000200020002000200020002000200071002E006100760067005F006400750072006100740069006F006E005F006D0073002C000D000A002000200020002000200020002000200020002000200071002E0074006F00740061006C005F007700720069007400650073002C000D000A002000200020002000200020002000200020002000200071002E006100760067005F007700720069007400650073002C000D000A002000200020002000200020002000200020002000200071002E0074006F00740061006C005F007300700069006C006C0073005F006D0062002C000D000A002000200020002000200020002000200020002000200071002E006100760067005F007300700069006C006C0073005F006D0062002C000D000A002000200020002000200020002000200020002000200071002E0074006F00740061006C005F0075007300650064005F006D0065006D006F00720079005F006D0062002C000D000A002000200020002000200020002000200020002000200071002E006100760067005F0075007300650064005F006D0065006D006F00720079005F006D0062002C000D000A002000200020002000200020002000200020002000200071002E0074006F00740061006C005F006700720061006E007400650064005F006D0065006D006F00720079005F006D0062002C000D000A002000200020002000200020002000200020002000200071002E006100760067005F006700720061006E007400650064005F006D0065006D006F00720079005F006D0062002C000D000A002000200020002000200020002000200020002000200071002E0074006F00740061006C005F0072006F00770073002C000D000A002000200020002000200020002000200020002000200071002E006100760067005F0072006F00770073002C000D000A002000200020002000200020002000200020002000200071002E00730065007200690061006C005F0069006400650061006C005F006D0065006D006F00720079005F006D0062002C000D000A002000200020002000200020002000200020002000200071002E007200650071007500650073007400650064005F006D0065006D006F00720079005F006D0062002C000D000A002000200020002000200020002000200020002000200071002E0069006400650061006C005F006D0065006D006F00720079005F006D0062002C000D000A002000200020002000200020002000200020002000200071002E0065007300740069006D0061007400650064005F0072006F00770073002C000D000A002000200020002000200020002000200020002000200071002E0064006F0070002C000D000A002000200020002000200020002000200020002000200071002E00710075006500720079005F0070006C0061006E005F0068006100730068005F007300690067006E00650064002C000D000A002000200020002000200020002000200020002000200071002E00710075006500720079005F0068006100730068005F007300690067006E00650064002C000D000A002000200020002000200020002000200020002000200071002E0070006C0061006E005F00680061006E0064006C0065000D000A002000200020002000460052004F004D002000710075006500720079005F0072006500730075006C0074007300200041005300200071000D000A00200020002000200057004800450052004500200071002E006E0020003D00200031003B00;
            INSERT #view_check (view_name, view_definition)
            SELECT N'HumanEvents_RecompilesByDatabaseAndObject', 0x0D000A000D000A00430052004500410054004500200056004900450057002000640062006F002E00480075006D0061006E004500760065006E00740073005F005200650063006F006D00700069006C0065007300420079004400610074006100620061007300650041006E0064004F0062006A006500630074000D000A00410053000D000A002000200020002000530045004C00450043005400200054004F005000280020003200310034003700340038003300360034003800200029000D000A00200020002000200020002000200020002000200020004D0049004E0028006500760065006E0074005F00740069006D006500290020004100530020006D0069006E005F006500760065006E0074005F00740069006D0065002C000D000A00200020002000200020002000200020002000200020004D004100580028006500760065006E0074005F00740069006D006500290020004100530020006D00610078005F006500760065006E0074005F00740069006D0065002C000D000A0020002000200020002000200020002000200020002000640061007400610062006100730065005F006E0061006D0065002C000D000A0020002000200020002000200020002000200020002000430041005300450020005700480045004E0020006F0062006A006500630074005F006E0061006D00650020003D0020004E00270027000D000A0020002000200020002000200020002000200020002000200020002000200020005400480045004E0020004E0027004E002F00410027000D000A0020002000200020002000200020002000200020002000200020002000200045004C005300450020006F0062006A006500630074005F006E0061006D0065000D000A002000200020002000200020002000200020002000200045004E00440020004100530020006F0062006A006500630074005F006E0061006D0065002C000D000A002000200020002000200020002000200020002000200043004F0055004E0054005F0042004900470028002A002900200041005300200074006F00740061006C005F0063006F006D00700069006C00650073002C000D000A0020002000200020002000200020002000200020002000530055004D00280063006F006D00700069006C0065005F006300700075005F006D0073002900200041005300200074006F00740061006C005F0063006F006D00700069006C0065005F006300700075002C000D000A0020002000200020002000200020002000200020002000410056004700280063006F006D00700069006C0065005F006300700075005F006D007300290020004100530020006100760067005F0063006F006D00700069006C0065005F006300700075002C000D000A00200020002000200020002000200020002000200020004D0041005800280063006F006D00700069006C0065005F006300700075005F006D007300290020004100530020006D00610078005F0063006F006D00700069006C0065005F006300700075002C000D000A0020002000200020002000200020002000200020002000530055004D00280063006F006D00700069006C0065005F006400750072006100740069006F006E005F006D0073002900200041005300200074006F00740061006C005F0063006F006D00700069006C0065005F006400750072006100740069006F006E002C000D000A0020002000200020002000200020002000200020002000410056004700280063006F006D00700069006C0065005F006400750072006100740069006F006E005F006D007300290020004100530020006100760067005F0063006F006D00700069006C0065005F006400750072006100740069006F006E002C000D000A00200020002000200020002000200020002000200020004D0041005800280063006F006D00700069006C0065005F006400750072006100740069006F006E005F006D007300290020004100530020006D00610078005F0063006F006D00700069006C0065005F006400750072006100740069006F006E000D000A002000200020002000460052004F004D0020005B007200650070006C006100630065005F006D0065005D000D000A002000200020002000470052004F00550050002000420059002000640061007400610062006100730065005F006E0061006D0065002C0020006F0062006A006500630074005F006E0061006D0065000D000A0020002000200020004F005200440045005200200042005900200074006F00740061006C005F0063006F006D00700069006C0065007300200044004500530043003B000D000A00
            WHERE @compile_events = 1;
            INSERT #view_check (view_name, view_definition)
            SELECT N'HumanEvents_RecompilesByDuration', 0x0D000A000D000A00430052004500410054004500200056004900450057002000640062006F002E00480075006D0061006E004500760065006E00740073005F005200650063006F006D00700069006C0065007300420079004400750072006100740069006F006E000D000A00410053000D000A002000200020002000570049005400480020006300620071000D000A0020002000200020002000200041005300200028000D000A00200020002000200020002000200020002000530045004C004500430054002000730074006100740065006D0065006E0074005F0074006500780074005F0063006800650063006B00730075006D002C000D000A00200020002000200020002000200020002000200020002000200020002000200043004F0055004E0054005F0042004900470028002A002900200041005300200074006F00740061006C005F0063006F006D00700069006C00650073002C000D000A002000200020002000200020002000200020002000200020002000200020002000530055004D00280063006F006D00700069006C0065005F006300700075005F006D0073002900200041005300200074006F00740061006C005F0063006F006D00700069006C0065005F006300700075002C000D000A002000200020002000200020002000200020002000200020002000200020002000410056004700280063006F006D00700069006C0065005F006300700075005F006D007300290020004100530020006100760067005F0063006F006D00700069006C0065005F006300700075002C000D000A0020002000200020002000200020002000200020002000200020002000200020004D0041005800280063006F006D00700069006C0065005F006300700075005F006D007300290020004100530020006D00610078005F0063006F006D00700069006C0065005F006300700075002C000D000A002000200020002000200020002000200020002000200020002000200020002000530055004D00280063006F006D00700069006C0065005F006400750072006100740069006F006E005F006D0073002900200041005300200074006F00740061006C005F0063006F006D00700069006C0065005F006400750072006100740069006F006E002C000D000A002000200020002000200020002000200020002000200020002000200020002000410056004700280063006F006D00700069006C0065005F006400750072006100740069006F006E005F006D007300290020004100530020006100760067005F0063006F006D00700069006C0065005F006400750072006100740069006F006E002C000D000A0020002000200020002000200020002000200020002000200020002000200020004D0041005800280063006F006D00700069006C0065005F006400750072006100740069006F006E005F006D007300290020004100530020006D00610078005F0063006F006D00700069006C0065005F006400750072006100740069006F006E000D000A00200020002000200020002000200020002000460052004F004D0020005B007200650070006C006100630065005F006D0065005D000D000A00200020002000200020002000200020002000470052004F00550050002000420059002000730074006100740065006D0065006E0074005F0074006500780074005F0063006800650063006B00730075006D000D000A0020002000200020002000200020002000200048004100560049004E0047002000410056004700280063006F006D00700069006C0065005F006400750072006100740069006F006E005F006D007300290020003E0020003100300030003000200029000D000A002000200020002000530045004C00450043005400200054004F005000280020003200310034003700340038003300360034003800200029000D000A00200020002000200020002000200020002000200020006B002E006F0062006A006500630074005F006E0061006D0065002C000D000A00200020002000200020002000200020002000200020006B002E00730074006100740065006D0065006E0074005F0074006500780074002C000D000A002000200020002000200020002000200020002000200063002E0074006F00740061006C005F0063006F006D00700069006C00650073002C000D000A002000200020002000200020002000200020002000200063002E0074006F00740061006C005F0063006F006D00700069006C0065005F006300700075002C000D000A002000200020002000200020002000200020002000200063002E006100760067005F0063006F006D00700069006C0065005F006300700075002C000D000A002000200020002000200020002000200020002000200063002E006D00610078005F0063006F006D00700069006C0065005F006300700075002C000D000A002000200020002000200020002000200020002000200063002E0074006F00740061006C005F0063006F006D00700069006C0065005F006400750072006100740069006F006E002C000D000A002000200020002000200020002000200020002000200063002E006100760067005F0063006F006D00700069006C0065005F006400750072006100740069006F006E002C000D000A002000200020002000200020002000200020002000200063002E006D00610078005F0063006F006D00700069006C0065005F006400750072006100740069006F006E000D000A002000200020002000460052004F004D002000630062007100200041005300200063000D000A002000200020002000430052004F005300530020004100500050004C0059000D000A002000200020002000200020002000200028000D000A00200020002000200020002000200020002000200020002000530045004C00450043005400200054004F005000280020003100200029000D000A0020002000200020002000200020002000200020002000200020002000200020002000200020002A000D000A00200020002000200020002000200020002000200020002000460052004F004D0020005B007200650070006C006100630065005F006D0065005D0020004100530020006B000D000A0020002000200020002000200020002000200020002000200057004800450052004500200063002E00730074006100740065006D0065006E0074005F0074006500780074005F0063006800650063006B00730075006D0020003D0020006B002E00730074006100740065006D0065006E0074005F0074006500780074005F0063006800650063006B00730075006D000D000A002000200020002000200020002000200020002000200020004F00520044004500520020004200590020006B002E0069006400200044004500530043000D000A0020002000200020002000200020002000290020004100530020006B000D000A0020002000200020004F005200440045005200200042005900200063002E006100760067005F0063006F006D00700069006C0065005F006400750072006100740069006F006E00200044004500530043003B000D000A00
            WHERE @compile_events = 1;
            INSERT #view_check (view_name, view_definition)
            SELECT N'HumanEvents_RecompilesByQuery', 0x0D000A000D000A00430052004500410054004500200056004900450057002000640062006F002E00480075006D0061006E004500760065006E00740073005F005200650063006F006D00700069006C006500730042007900510075006500720079000D000A00410053000D000A002000200020002000570049005400480020006300620071000D000A0020002000200020002000200041005300200028000D000A00200020002000200020002000200020002000530045004C004500430054002000730074006100740065006D0065006E0074005F0074006500780074005F0063006800650063006B00730075006D002C000D000A00200020002000200020002000200020002000200020002000200020002000200043004F0055004E0054005F0042004900470028002A002900200041005300200074006F00740061006C005F007200650063006F006D00700069006C00650073002C000D000A002000200020002000200020002000200020002000200020002000200020002000530055004D00280063006F006D00700069006C0065005F006300700075005F006D0073002900200041005300200074006F00740061006C005F0063006F006D00700069006C0065005F006300700075002C000D000A002000200020002000200020002000200020002000200020002000200020002000410056004700280063006F006D00700069006C0065005F006300700075005F006D007300290020004100530020006100760067005F0063006F006D00700069006C0065005F006300700075002C000D000A0020002000200020002000200020002000200020002000200020002000200020004D0041005800280063006F006D00700069006C0065005F006300700075005F006D007300290020004100530020006D00610078005F0063006F006D00700069006C0065005F006300700075002C000D000A002000200020002000200020002000200020002000200020002000200020002000530055004D00280063006F006D00700069006C0065005F006400750072006100740069006F006E005F006D0073002900200041005300200074006F00740061006C005F0063006F006D00700069006C0065005F006400750072006100740069006F006E002C000D000A002000200020002000200020002000200020002000200020002000200020002000410056004700280063006F006D00700069006C0065005F006400750072006100740069006F006E005F006D007300290020004100530020006100760067005F0063006F006D00700069006C0065005F006400750072006100740069006F006E002C000D000A0020002000200020002000200020002000200020002000200020002000200020004D0041005800280063006F006D00700069006C0065005F006400750072006100740069006F006E005F006D007300290020004100530020006D00610078005F0063006F006D00700069006C0065005F006400750072006100740069006F006E000D000A00200020002000200020002000200020002000460052004F004D0020005B007200650070006C006100630065005F006D0065005D000D000A00200020002000200020002000200020002000470052004F00550050002000420059002000730074006100740065006D0065006E0074005F0074006500780074005F0063006800650063006B00730075006D000D000A0020002000200020002000200020002000200048004100560049004E004700200043004F0055004E0054005F0042004900470028002A00290020003E003D00200031003000200029000D000A002000200020002000530045004C00450043005400200054004F005000280020003200310034003700340038003300360034003800200029000D000A00200020002000200020002000200020002000200020006B002E006F0062006A006500630074005F006E0061006D0065002C000D000A00200020002000200020002000200020002000200020006B002E00730074006100740065006D0065006E0074005F0074006500780074002C000D000A002000200020002000200020002000200020002000200063002E0074006F00740061006C005F007200650063006F006D00700069006C00650073002C000D000A002000200020002000200020002000200020002000200063002E0074006F00740061006C005F0063006F006D00700069006C0065005F006300700075002C000D000A002000200020002000200020002000200020002000200063002E006100760067005F0063006F006D00700069006C0065005F006300700075002C000D000A002000200020002000200020002000200020002000200063002E006D00610078005F0063006F006D00700069006C0065005F006300700075002C000D000A002000200020002000200020002000200020002000200063002E0074006F00740061006C005F0063006F006D00700069006C0065005F006400750072006100740069006F006E002C000D000A002000200020002000200020002000200020002000200063002E006100760067005F0063006F006D00700069006C0065005F006400750072006100740069006F006E002C000D000A002000200020002000200020002000200020002000200063002E006D00610078005F0063006F006D00700069006C0065005F006400750072006100740069006F006E000D000A002000200020002000460052004F004D002000630062007100200041005300200063000D000A002000200020002000430052004F005300530020004100500050004C0059000D000A002000200020002000200020002000200028000D000A00200020002000200020002000200020002000200020002000530045004C00450043005400200054004F005000280020003100200029000D000A0020002000200020002000200020002000200020002000200020002000200020002000200020002A000D000A00200020002000200020002000200020002000200020002000460052004F004D0020005B007200650070006C006100630065005F006D0065005D0020004100530020006B000D000A0020002000200020002000200020002000200020002000200057004800450052004500200063002E00730074006100740065006D0065006E0074005F0074006500780074005F0063006800650063006B00730075006D0020003D0020006B002E00730074006100740065006D0065006E0074005F0074006500780074005F0063006800650063006B00730075006D000D000A002000200020002000200020002000200020002000200020004F00520044004500520020004200590020006B002E0069006400200044004500530043000D000A0020002000200020002000200020002000290020004100530020006B000D000A0020002000200020004F005200440045005200200042005900200063002E0074006F00740061006C005F007200650063006F006D00700069006C0065007300200044004500530043003B000D000A00
            WHERE @compile_events = 1;
            INSERT #view_check (view_name, view_definition)
            SELECT N'HumanEvents_WaitsByDatabase', 0x0D000A000D000A00430052004500410054004500200056004900450057002000640062006F002E00480075006D0061006E004500760065006E00740073005F005700610069007400730042007900440061007400610062006100730065000D000A00410053000D000A00200020002000200057004900540048002000770061006900740073000D000A0020002000200020002000200041005300200028000D000A00200020002000200020002000200020002000530045004C0045004300540020004E00270074006F00740061006C002000770061006900740073002000620079002000640061007400610062006100730065002700200041005300200077006100690074005F007000610074007400650072006E002C000D000A0020002000200020002000200020002000200020002000200020002000200020004D0049004E002800770061002E006500760065006E0074005F00740069006D006500290020004100530020006D0069006E005F006500760065006E0074005F00740069006D0065002C000D000A0020002000200020002000200020002000200020002000200020002000200020004D00410058002800770061002E006500760065006E0074005F00740069006D006500290020004100530020006D00610078005F006500760065006E0074005F00740069006D0065002C000D000A002000200020002000200020002000200020002000200020002000200020002000770061002E00640061007400610062006100730065005F006E0061006D0065002C000D000A002000200020002000200020002000200020002000200020002000200020002000770061002E0077006100690074005F0074007900700065002C000D000A00200020002000200020002000200020002000200020002000200020002000200043004F0055004E0054005F0042004900470028002A002900200041005300200074006F00740061006C005F00770061006900740073002C000D000A002000200020002000200020002000200020002000200020002000200020002000530055004D002800770061002E006400750072006100740069006F006E005F006D00730029002000410053002000730075006D005F006400750072006100740069006F006E005F006D0073002C000D000A002000200020002000200020002000200020002000200020002000200020002000530055004D002800770061002E007300690067006E0061006C005F006400750072006100740069006F006E005F006D00730029002000410053002000730075006D005F007300690067006E0061006C005F006400750072006100740069006F006E005F006D0073002C000D000A002000200020002000200020002000200020002000200020002000200020002000530055004D002800770061002E006400750072006100740069006F006E005F006D007300290020002F00200043004F0055004E0054005F0042004900470028002A00290020004100530020006100760067005F006D0073005F007000650072005F0077006100690074000D000A00200020002000200020002000200020002000460052004F004D0020005B007200650070006C006100630065005F006D0065005D002000410053002000770061000D000A00200020002000200020002000200020002000470052004F00550050002000420059002000770061002E00640061007400610062006100730065005F006E0061006D0065002C002000770061002E0077006100690074005F007400790070006500200029000D000A002000200020002000530045004C00450043005400200054004F005000280020003200310034003700340038003300360034003800200029000D000A0020002000200020002000200020002000200020002000770061006900740073002E0077006100690074005F007000610074007400650072006E002C000D000A0020002000200020002000200020002000200020002000770061006900740073002E006D0069006E005F006500760065006E0074005F00740069006D0065002C000D000A0020002000200020002000200020002000200020002000770061006900740073002E006D00610078005F006500760065006E0074005F00740069006D0065002C000D000A0020002000200020002000200020002000200020002000770061006900740073002E00640061007400610062006100730065005F006E0061006D0065002C000D000A0020002000200020002000200020002000200020002000770061006900740073002E0077006100690074005F0074007900700065002C000D000A0020002000200020002000200020002000200020002000770061006900740073002E0074006F00740061006C005F00770061006900740073002C000D000A0020002000200020002000200020002000200020002000770061006900740073002E00730075006D005F006400750072006100740069006F006E005F006D0073002C000D000A0020002000200020002000200020002000200020002000770061006900740073002E00730075006D005F007300690067006E0061006C005F006400750072006100740069006F006E005F006D0073002C000D000A0020002000200020002000200020002000200020002000770061006900740073002E006100760067005F006D0073005F007000650072005F0077006100690074002C000D000A0020002000200020002000200020002000200020002000490053004E0055004C004C0028000D000A0020002000200020002000200020002000200020002000200020002000200020002000200020002000200043004F0055004E0054005F0042004900470028002A0029000D000A002000200020002000200020002000200020002000200020002000200020002000200020002000200020002F0020004E0055004C004C004900460028004400410054004500440049004600460028000D000A002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020005300450043004F004E0044002C002000770061006900740073002E006D0069006E005F006500760065006E0074005F00740069006D0065002C000D000A00200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000770061006900740073002E006D00610078005F006500760065006E0074005F00740069006D0065000D000A002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200029002C002000300029002C00200030000D000A002000200020002000200020002000200020002000200020002000200020002000200029002000410053002000770061006900740073005F007000650072005F007300650063006F006E0064002C000D000A0020002000200020002000200020002000200020002000490053004E0055004C004C0028000D000A0020002000200020002000200020002000200020002000200020002000200020002000200020002000200043004F0055004E0054005F0042004900470028002A0029000D000A002000200020002000200020002000200020002000200020002000200020002000200020002000200020002F0020004E0055004C004C004900460028004400410054004500440049004600460028000D000A0020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200048004F00550052002C002000770061006900740073002E006D0069006E005F006500760065006E0074005F00740069006D0065002C000D000A00200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000770061006900740073002E006D00610078005F006500760065006E0074005F00740069006D0065000D000A002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200029002C002000300029002C00200030000D000A002000200020002000200020002000200020002000200020002000200020002000200029002000410053002000770061006900740073005F007000650072005F0068006F00750072002C000D000A0020002000200020002000200020002000200020002000490053004E0055004C004C0028000D000A0020002000200020002000200020002000200020002000200020002000200020002000200020002000200043004F0055004E0054005F0042004900470028002A0029000D000A002000200020002000200020002000200020002000200020002000200020002000200020002000200020002F0020004E0055004C004C004900460028004400410054004500440049004600460028000D000A002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020004400410059002C002000770061006900740073002E006D0069006E005F006500760065006E0074005F00740069006D0065002C000D000A00200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000770061006900740073002E006D00610078005F006500760065006E0074005F00740069006D0065000D000A002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200020002000200029002C002000300029002C00200030000D000A002000200020002000200020002000200020002000200020002000200020002000200029002000410053002000770061006900740073005F007000650072005F006400610079000D000A002000200020002000460052004F004D002000770061006900740073000D000A002000200020002000470052004F00550050002000420059002000770061006900740073002E0077006100690074005F007000610074007400650072006E002C000D000A002000200020002000200020002000200020002000200020002000770061006900740073002E006D0069006E005F006500760065006E0074005F00740069006D0065002C000D000A002000200020002000200020002000200020002000200020002000770061006900740073002E006D00610078005F006500760065006E0074005F00740069006D0065002C000D000A002000200020002000200020002000200020002000200020002000770061006900740073002E00640061007400610062006100730065005F006E0061006D0065002C000D000A002000200020002000200020002000200020002000200020002000770061006900740073002E0077006100690074005F0074007900700065002C000D000A002000200020002000200020002000200020002000200020002000770061006900740073002E0074006F00740061006C005F00770061006900740073002C000D000A002000200020002000200020002000200020002000200020002000770061006900740073002E00730075006D005F006400750072006100740069006F006E005F006D0073002C000D000A002000200020002000200020002000200020002000200020002000770061006900740073002E00730075006D005F007300690067006E0061006C005F006400750072006100740069006F006E005F006D0073002C000D000A002000200020002000200020002000200020002000200020002000770061006900740073002E006100760067005F006D0073005F007000650072005F0077006100690074000D000A0020002000200020004F0052004400450052002000420059002000770061006900740073002E00730075006D005F006400750072006100740069006F006E005F006D007300200044004500530043003B000D000A00;
            INSERT #view_check (view_name, view_definition)
            SELECT N'HumanEvents_WaitsByQueryAndDatabase', 0x0D000A000D000A00430052004500410054004500200056004900450057002000640062006F002E00480075006D0061006E004500760065006E00740073005F0057006100690074007300420079005100750065007200790041006E006400440061007400610062006100730065000D000A00410053000D000A0020002000200020005700490054004800200070006C0061006E005F00770061006900740073000D000A0020002000200020002000200041005300200028000D000A00200020002000200020002000200020002000530045004C0045004300540020004E00270077006100690074007300200062007900200071007500650072007900200061006E0064002000640061007400610062006100730065002700200041005300200077006100690074005F007000610074007400650072006E002C000D000A0020002000200020002000200020002000200020002000200020002000200020004D0049004E002800770061002E006500760065006E0074005F00740069006D006500290020004100530020006D0069006E005F006500760065006E0074005F00740069006D0065002C000D000A0020002000200020002000200020002000200020002000200020002000200020004D00410058002800770061002E006500760065006E0074005F00740069006D006500290020004100530020006D00610078005F006500760065006E0074005F00740069006D0065002C000D000A002000200020002000200020002000200020002000200020002000200020002000770061002E00640061007400610062006100730065005F006E0061006D0065002C000D000A002000200020002000200020002000200020002000200020002000200020002000770061002E0077006100690074005F0074007900700065002C000D000A00200020002000200020002000200020002000200020002000200020002000200043004F0055004E0054005F0042004900470028002A002900200041005300200074006F00740061006C005F00770061006900740073002C000D000A002000200020002000200020002000200020002000200020002000200020002000770061002E0070006C0061006E005F00680061006E0064006C0065002C000D000A002000200020002000200020002000200020002000200020002000200020002000770061002E00710075006500720079005F0070006C0061006E005F0068006100730068005F007300690067006E00650064002C000D000A002000200020002000200020002000200020002000200020002000200020002000770061002E00710075006500720079005F0068006100730068005F007300690067006E00650064002C000D000A002000200020002000200020002000200020002000200020002000200020002000530055004D002800770061002E006400750072006100740069006F006E005F006D00730029002000410053002000730075006D005F006400750072006100740069006F006E005F006D0073002C000D000A002000200020002000200020002000200020002000200020002000200020002000530055004D002800770061002E007300690067006E0061006C005F006400750072006100740069006F006E005F006D00730029002000410053002000730075006D005F007300690067006E0061006C005F006400750072006100740069006F006E005F006D0073002C000D000A002000200020002000200020002000200020002000200020002000200020002000530055004D002800770061002E006400750072006100740069006F006E005F006D007300290020002F00200043004F0055004E0054005F0042004900470028002A00290020004100530020006100760067005F006D0073005F007000650072005F0077006100690074000D000A00200020002000200020002000200020002000460052004F004D0020005B007200650070006C006100630065005F006D0065005D002000410053002000770061000D000A00200020002000200020002000200020002000470052004F00550050002000420059002000770061002E00640061007400610062006100730065005F006E0061006D0065002C000D000A00200020002000200020002000200020002000200020002000200020002000200020002000770061002E0077006100690074005F0074007900700065002C000D000A00200020002000200020002000200020002000200020002000200020002000200020002000770061002E00710075006500720079005F0068006100730068005F007300690067006E00650064002C000D000A00200020002000200020002000200020002000200020002000200020002000200020002000770061002E00710075006500720079005F0070006C0061006E005F0068006100730068005F007300690067006E00650064002C000D000A00200020002000200020002000200020002000200020002000200020002000200020002000770061002E0070006C0061006E005F00680061006E0064006C006500200029000D000A002000200020002000530045004C00450043005400200054004F005000280020003200310034003700340038003300360034003800200029000D000A0020002000200020002000200020002000200020002000700077002E0077006100690074005F007000610074007400650072006E002C000D000A0020002000200020002000200020002000200020002000700077002E006D0069006E005F006500760065006E0074005F00740069006D0065002C000D000A0020002000200020002000200020002000200020002000700077002E006D00610078005F006500760065006E0074005F00740069006D0065002C000D000A0020002000200020002000200020002000200020002000700077002E00640061007400610062006100730065005F006E0061006D0065002C000D000A0020002000200020002000200020002000200020002000700077002E0077006100690074005F0074007900700065002C000D000A0020002000200020002000200020002000200020002000700077002E0074006F00740061006C005F00770061006900740073002C000D000A0020002000200020002000200020002000200020002000700077002E00730075006D005F006400750072006100740069006F006E005F006D0073002C000D000A0020002000200020002000200020002000200020002000700077002E00730075006D005F007300690067006E0061006C005F006400750072006100740069006F006E005F006D0073002C000D000A0020002000200020002000200020002000200020002000700077002E006100760067005F006D0073005F007000650072005F0077006100690074002C000D000A0020002000200020002000200020002000200020002000730074002E0074006500780074002C000D000A0020002000200020002000200020002000200020002000710070002E00710075006500720079005F0070006C0061006E000D000A002000200020002000460052004F004D00200070006C0061006E005F00770061006900740073002000410053002000700077000D000A0020002000200020004F00550054004500520020004100500050004C00590020007300790073002E0064006D005F0065007800650063005F00710075006500720079005F0070006C0061006E002800700077002E0070006C0061006E005F00680061006E0064006C00650029002000410053002000710070000D000A0020002000200020004F00550054004500520020004100500050004C00590020007300790073002E0064006D005F0065007800650063005F00730071006C005F0074006500780074002800700077002E0070006C0061006E005F00680061006E0064006C00650029002000410053002000730074000D000A0020002000200020004F0052004400450052002000420059002000700077002E00730075006D005F006400750072006100740069006F006E005F006D007300200044004500530043003B000D000A00;
            INSERT #view_check (view_name, view_definition)
            SELECT N'HumanEvents_WaitsTotal', 0x0D000A000D000A00430052004500410054004500200056004900450057002000640062006F002E00480075006D0061006E004500760065006E00740073005F005700610069007400730054006F00740061006C000D000A00410053000D000A002000200020002000530045004C00450043005400200054004F005000280020003200310034003700340038003300360034003800200029000D000A00200020002000200020002000200020002000200020004E00270074006F00740061006C002000770061006900740073002700200041005300200077006100690074005F007000610074007400650072006E002C000D000A00200020002000200020002000200020002000200020004D0049004E002800770061002E006500760065006E0074005F00740069006D006500290020004100530020006D0069006E005F006500760065006E0074005F00740069006D0065002C000D000A00200020002000200020002000200020002000200020004D00410058002800770061002E006500760065006E0074005F00740069006D006500290020004100530020006D00610078005F006500760065006E0074005F00740069006D0065002C000D000A0020002000200020002000200020002000200020002000770061002E0077006100690074005F0074007900700065002C000D000A002000200020002000200020002000200020002000200043004F0055004E0054005F0042004900470028002A002900200041005300200074006F00740061006C005F00770061006900740073002C000D000A0020002000200020002000200020002000200020002000530055004D002800770061002E006400750072006100740069006F006E005F006D00730029002000410053002000730075006D005F006400750072006100740069006F006E005F006D0073002C000D000A0020002000200020002000200020002000200020002000530055004D002800770061002E007300690067006E0061006C005F006400750072006100740069006F006E005F006D00730029002000410053002000730075006D005F007300690067006E0061006C005F006400750072006100740069006F006E005F006D0073002C000D000A0020002000200020002000200020002000200020002000530055004D002800770061002E006400750072006100740069006F006E005F006D007300290020002F00200043004F0055004E0054005F0042004900470028002A00290020004100530020006100760067005F006D0073005F007000650072005F0077006100690074000D000A002000200020002000460052004F004D0020005B007200650070006C006100630065005F006D0065005D002000410053002000770061000D000A002000200020002000470052004F00550050002000420059002000770061002E0077006100690074005F0074007900700065000D000A0020002000200020004F0052004400450052002000420059002000730075006D005F006400750072006100740069006F006E005F006D007300200044004500530043003B000D000A00;    
            INSERT #view_check (view_name, view_definition)
            SELECT N'HumanEvents_Compiles_Legacy', 0x430052004500410054004500200056004900450057002000640062006F002E00480075006D0061006E004500760065006E00740073005F0043006F006D00700069006C00650073005F004C00650067006100630079000D000A00410053000D000A00530045004C00450043005400200054004F00500020002800320031003400370034003800330036003400380029000D000A0020002000200020002000200020006500760065006E0074005F00740069006D0065002C000D000A0020002000200020002000200020006500760065006E0074005F0074007900700065002C000D000A002000200020002000200020002000640061007400610062006100730065005F006E0061006D0065002C000D000A0020002000200020002000200020006F0062006A006500630074005F006E0061006D0065002C000D000A002000200020002000200020002000730074006100740065006D0065006E0074005F0074006500780074000D000A00460052004F004D0020005B007200650070006C006100630065005F006D0065005D000D000A004F00520044004500520020004200590020006500760065006E0074005F00740069006D0065003B00
            WHERE @compile_events = 0;
            INSERT #view_check (view_name, view_definition)
            SELECT N'HumanEvents_Recompiles_Legacy', 0x430052004500410054004500200056004900450057002000640062006F002E00480075006D0061006E004500760065006E00740073005F005200650063006F006D00700069006C00650073005F004C00650067006100630079000D000A00410053000D000A00530045004C00450043005400200054004F00500020002800320031003400370034003800330036003400380029000D000A0020002000200020002000200020006500760065006E0074005F00740069006D0065002C000D000A0020002000200020002000200020006500760065006E0074005F0074007900700065002C000D000A002000200020002000200020002000640061007400610062006100730065005F006E0061006D0065002C000D000A0020002000200020002000200020006F0062006A006500630074005F006E0061006D0065002C000D000A0020002000200020002000200020007200650063006F006D00700069006C0065005F00630061007500730065002C000D000A002000200020002000200020002000730074006100740065006D0065006E0074005F0074006500780074000D000A00460052004F004D0020005B007200650070006C006100630065005F006D0065005D000D000A004F00520044004500520020004200590020006500760065006E0074005F00740069006D0065003B00
            WHERE @compile_events = 0;

            RAISERROR(N'Updating #view_check with output database (%s) and schema (%s)', 0, 1, @output_database_name, @output_schema_name) WITH NOWAIT;
            UPDATE #view_check SET output_database = @output_database_name, output_schema = @output_schema_name OPTION(RECOMPILE);
            
            RAISERROR(N'Updating #view_check with table names', 0, 1) WITH NOWAIT;
            UPDATE vc SET vc.output_table = hew.output_table
            FROM #view_check AS vc
            JOIN #human_events_worker AS hew
                ON  vc.view_name LIKE N'%' + hew.event_type_short + N'%'
                AND hew.is_table_created = 1
                AND hew.is_view_created = 0
            OPTION(RECOMPILE);
        
            UPDATE vc SET vc.output_table = hew.output_table + N'_parameterization'
            FROM #view_check AS vc
            JOIN #human_events_worker AS hew
                ON  vc.view_name = N'HumanEvents_Parameterization'
                AND hew.output_table LIKE N'keeper_HumanEvents_compiles%'
                AND hew.is_table_created = 1
                AND hew.is_view_created = 0
            OPTION(RECOMPILE);
        
            IF @debug = 1 BEGIN SELECT N'#view_check' AS table_name, * FROM #view_check AS vc OPTION(RECOMPILE); END;
        
        END;
        
        DECLARE @view_tracker BIT;
        
        IF (@view_tracker IS NULL
                OR @view_tracker = 0 )
        BEGIN 
            RAISERROR(N'Starting view creation loop', 0, 1) WITH NOWAIT;

            DECLARE @spe NVARCHAR(MAX) = N'.sys.sp_executesql ';
            DECLARE @view_sql NVARCHAR(MAX) = N'';
            DECLARE @view_database sysname = N'';
            
            SELECT @min_id = MIN(vc.id), 
                   @max_id = MAX(vc.id)
            FROM #view_check AS vc
            WHERE EXISTS
            (
                SELECT 1/0
                FROM #human_events_worker AS hew
                WHERE vc.view_name LIKE N'%' + hew.event_type_short + N'%'
                AND hew.is_table_created = 1
                AND hew.is_view_created = 0
            )
            OPTION(RECOMPILE);
            
                WHILE @min_id <= @max_id
                BEGIN
                                
                    SELECT @event_type_check  = LOWER(vc.view_name),
                           @object_name_check = QUOTENAME(vc.output_database)
                                              + N'.'
                                              + QUOTENAME(vc.output_schema)
                                              + N'.'
                                              + vc.view_name,
                           @view_database     = QUOTENAME(vc.output_database),
                           @view_sql          = REPLACE(
                                                    REPLACE( vc.view_converted, 
                                                             N'[replace_me]', 
                                                             QUOTENAME(vc.output_schema) 
                                                             + N'.' 
                                                             + vc.output_table ), 
                                                N'', 
                                                N'''' )
                    FROM #view_check AS vc
                    WHERE vc.id = @min_id
                    OPTION (RECOMPILE);
                
                    IF OBJECT_ID(@object_name_check) IS NOT NULL
                    BEGIN
                      RAISERROR(N'Uh oh, found a view', 0, 1) WITH NOWAIT;
                      SET @view_sql = REPLACE(@view_sql, N'CREATE VIEW', N'ALTER VIEW');
                    END;
                    
                    SELECT @spe = @view_database + @spe;
                    
                    IF @debug = 1 BEGIN RAISERROR(@spe, 0, 1) WITH NOWAIT; END;
            
                    IF @debug = 1
                    BEGIN 
                        PRINT SUBSTRING(@view_sql, 0, 4000);
                        PRINT SUBSTRING(@view_sql, 4000, 8000);
                        PRINT SUBSTRING(@view_sql, 8000, 12000);
                        PRINT SUBSTRING(@view_sql, 12000, 16000);
                        PRINT SUBSTRING(@view_sql, 16000, 20000);
                        PRINT SUBSTRING(@view_sql, 20000, 24000);
                        PRINT SUBSTRING(@view_sql, 24000, 28000);
                        PRINT SUBSTRING(@view_sql, 28000, 32000);
                        PRINT SUBSTRING(@view_sql, 32000, 36000);
                        PRINT SUBSTRING(@view_sql, 36000, 40000);           
                    END;
                    
                    RAISERROR(N'creating view %s', 0, 1, @event_type_check) WITH NOWAIT;
                    EXEC @spe @view_sql;
            
                    IF @debug = 1 BEGIN RAISERROR(N'@min_id: %i', 0, 1, @min_id) WITH NOWAIT; END;
            
                    RAISERROR(N'Setting next id after %i out of %i total', 0, 1, @min_id, @max_id) WITH NOWAIT;
                    
                    SET @min_id = 
                    (
                        SELECT TOP (1) vc.id
                        FROM #view_check AS vc
                        WHERE vc.id > @min_id
                        ORDER BY vc.id
                    );
            
                    IF @debug = 1 BEGIN RAISERROR(N'new @min_id: %i', 0, 1, @min_id) WITH NOWAIT; END;
            
                    IF @min_id IS NULL BREAK;
            
                    SET @spe = N'.sys.sp_executesql ';
            
                END;
            
                UPDATE #human_events_worker SET is_view_created = 1 OPTION(RECOMPILE);
                SET @view_tracker = 1;        
        END;
    END;

    /*This section handles inserting data into tables*/
    IF EXISTS
    (
        SELECT 1/0
        FROM #human_events_worker AS hew
        WHERE hew.is_table_created = 1
        AND   hew.last_checked < DATEADD(SECOND, -5, SYSDATETIME())
    )
    BEGIN
    
        RAISERROR(N'Sessions that need data found, starting loop.', 0, 1) WITH NOWAIT;
        
        SELECT @min_id = MIN(hew.id), 
               @max_id = MAX(hew.id)
        FROM #human_events_worker AS hew
        WHERE hew.is_table_created = 1
        OPTION (RECOMPILE);

        WHILE @min_id <= @max_id
        BEGIN

        DECLARE @date_filter DATETIME;

            SELECT @event_type_check  = hew.event_type,
                   @object_name_check = QUOTENAME(hew.output_database)
                                      + N'.'
                                      + QUOTENAME(hew.output_schema)
                                      + N'.'
                                      + hew.output_table,
                   @date_filter       = DATEADD(MINUTE, DATEDIFF(MINUTE, SYSDATETIME(), GETUTCDATE()), hew.last_checked)
            FROM #human_events_worker AS hew
            WHERE hew.id = @min_id
            AND hew.is_table_created = 1
            OPTION (RECOMPILE);
        
            IF OBJECT_ID(@object_name_check) IS NOT NULL
            BEGIN
            RAISERROR(N'Generating insert table statement for %s', 0, 1, @event_type_check) WITH NOWAIT;
                SELECT @table_sql =  
                  CASE WHEN @event_type_check LIKE N'%wait%' /*Wait stats!*/
                       THEN N'INSERT INTO ' + @object_name_check + N' WITH(TABLOCK) ' + NCHAR(10) + 
                            N'( server_name, event_time, event_type, database_name, wait_type, duration_ms, ' + NCHAR(10) +
                            N'  signal_duration_ms, wait_resource,  query_plan_hash_signed, query_hash_signed, plan_handle )' + NCHAR(10) +
                            N'SELECT @@SERVERNAME,
        DATEADD(MINUTE, DATEDIFF(MINUTE, GETUTCDATE(), SYSDATETIME()), c.value(''@timestamp'', ''DATETIME2'')) AS event_time,
        c.value(''@name'', ''NVARCHAR(256)'') AS event_type,
        c.value(''(action[@name="database_name"]/value)[1]'', ''NVARCHAR(256)'') AS database_name,                
        c.value(''(data[@name="wait_type"]/text)[1]'', ''NVARCHAR(256)'') AS wait_type,
        c.value(''(data[@name="duration"]/value)[1]'', ''BIGINT'')  AS duration_ms,
        c.value(''(data[@name="signal_duration"]/value)[1]'', ''BIGINT'') AS signal_duration_ms,' + NCHAR(10) +
CASE WHEN @v = 11 /*We can't get the wait resource on older versions of SQL Server*/
     THEN N'        ''Not Available < 2014'', ' + NCHAR(10)
     ELSE N'        c.value(''(data[@name="wait_resource"]/value)[1]'', ''NVARCHAR(256)'')  AS wait_resource, ' + NCHAR(10)
END + N'        CONVERT(BINARY(8), c.value(''(action[@name="query_plan_hash_signed"]/value)[1]'', ''BIGINT'')) AS query_plan_hash_signed,
        CONVERT(BINARY(8), c.value(''(action[@name="query_hash_signed"]/value)[1]'', ''BIGINT'')) AS query_hash_signed,
        c.value(''xs:hexBinary((action[@name="plan_handle"]/value/text())[1])'', ''VARBINARY(64)'') AS plan_handle
FROM #human_events_xml_internal AS xet
OUTER APPLY xet.human_events_xml.nodes(''//event'') AS oa(c)
WHERE c.exist(''(data[@name="duration"]/value/text()[. > 0])'') = 1 
AND   c.exist(''@timestamp[. > sql:variable("@date_filter")]'') = 1
OPTION(RECOMPILE);'
                       WHEN @event_type_check LIKE N'%lock%' /*Blocking!*/
                                                             /*To cut down on nonsense, I'm only inserting new blocking scenarios*/
                                                             /*Any existing blocking scenarios will update the blocking duration*/
                       THEN N'INSERT INTO ' + @object_name_check + N' WITH(TABLOCK) ' + NCHAR(10) + 
                            N'( server_name, event_time, activity, database_name, database_id, object_id, ' + NCHAR(10) +
                            N'  transaction_id, resource_owner_type, monitor_loop, spid, ecid, query_text, wait_time, ' + NCHAR(10) +
                            N'  transaction_name,  last_transaction_started, lock_mode, status, priority, ' + NCHAR(10) +
                            N'  transaction_count, client_app, host_name, login_name, isolation_level, sql_handle, blocked_process_report )' + NCHAR(10) +
N'
SELECT server_name, event_time, activity, database_name, database_id, object_id, 
       transaction_id, resource_owner_type, monitor_loop, spid, ecid, text, waittime, 
       transactionname,  lasttranstarted, lockmode, status, priority, 
       trancount, clientapp, hostname, loginname, isolationlevel, sqlhandle, process_report
FROM ( 
SELECT *, ROW_NUMBER() OVER( PARTITION BY x.spid, x.ecid, x.transaction_id, x.activity 
                             ORDER BY     x.spid, x.ecid, x.transaction_id, x.activity ) AS x
FROM (
    SELECT @@SERVERNAME AS server_name,
           DATEADD(MINUTE, DATEDIFF(MINUTE, GETUTCDATE(), SYSDATETIME()), c.value(''@timestamp'', ''DATETIME2'')) AS event_time,        
           ''blocked'' AS activity,
           DB_NAME(c.value(''(data[@name="database_id"]/value)[1]'', ''INT'')) AS database_name,
           c.value(''(data[@name="database_id"]/value)[1]'', ''INT'') AS database_id,
           c.value(''(data[@name="object_id"]/value)[1]'', ''INT'') AS object_id,
           c.value(''(data[@name="transaction_id"]/value)[1]'', ''BIGINT'') AS transaction_id,
           c.value(''(data[@name="resource_owner_type"]/text)[1]'', ''NVARCHAR(256)'') AS resource_owner_type,
           c.value(''(//@monitorLoop)[1]'', ''INT'') AS monitor_loop,
           bd.value(''(process/@spid)[1]'', ''INT'') AS spid,
           bd.value(''(process/@ecid)[1]'', ''INT'') AS ecid,
           bd.value(''(process/inputbuf/text())[1]'', ''NVARCHAR(MAX)'') AS text,
           bd.value(''(process/@waittime)[1]'', ''BIGINT'') AS waittime,
           bd.value(''(process/@transactionname)[1]'', ''NVARCHAR(256)'') AS transactionname,
           bd.value(''(process/@lasttranstarted)[1]'', ''DATETIME2'') AS lasttranstarted,
           bd.value(''(process/@lockMode)[1]'', ''NVARCHAR(10)'') AS lockmode,
           bd.value(''(process/@status)[1]'', ''NVARCHAR(10)'') AS status,
           bd.value(''(process/@priority)[1]'', ''INT'') AS priority,
           bd.value(''(process/@trancount)[1]'', ''INT'') AS trancount,
           bd.value(''(process/@clientapp)[1]'', ''NVARCHAR(256)'') AS clientapp,
           bd.value(''(process/@hostname)[1]'', ''NVARCHAR(256)'') AS hostname,
           bd.value(''(process/@loginname)[1]'', ''NVARCHAR(256)'') AS loginname,
           bd.value(''(process/@isolationlevel)[1]'', ''NVARCHAR(50)'') AS isolationlevel,
           CONVERT(VARBINARY(64), bd.value(''(process/executionStack/frame/@sqlhandle)[1]'', ''NVARCHAR(100)'')) AS sqlhandle,
           c.query(''.'') AS process_report
    FROM #human_events_xml_internal AS xet
    OUTER APPLY xet.human_events_xml.nodes(''//event'') AS oa(c)
    OUTER APPLY oa.c.nodes(''//blocked-process-report/blocked-process'') AS bd(bd)
    WHERE c.exist(''@timestamp[. > sql:variable("@date_filter")]'') = 1
    
    UNION ALL
    
    SELECT @@SERVERNAME AS server_name,
           DATEADD(MINUTE, DATEDIFF(MINUTE, GETUTCDATE(), SYSDATETIME()), c.value(''@timestamp'', ''DATETIME2'')) AS event_time,        
           ''blocking'' AS activity,
           DB_NAME(c.value(''(data[@name="database_id"]/value)[1]'', ''INT'')) AS database_name,
           c.value(''(data[@name="database_id"]/value)[1]'', ''INT'') AS database_id,
           c.value(''(data[@name="object_id"]/value)[1]'', ''INT'') AS object_id,
           c.value(''(data[@name="transaction_id"]/value)[1]'', ''BIGINT'') AS transaction_id,
           c.value(''(data[@name="resource_owner_type"]/text)[1]'', ''NVARCHAR(256)'') AS resource_owner_type,
           c.value(''(//@monitorLoop)[1]'', ''INT'') AS monitor_loop,
           bg.value(''(process/@spid)[1]'', ''INT'') AS spid,
           bg.value(''(process/@ecid)[1]'', ''INT'') AS ecid,
           bg.value(''(process/inputbuf/text())[1]'', ''NVARCHAR(MAX)'') AS text,
           NULL AS waittime,
           NULL AS transactionname,
           NULL AS lasttranstarted,
           NULL AS lockmode,
           bg.value(''(process/@status)[1]'', ''NVARCHAR(10)'') AS status,
           bg.value(''(process/@priority)[1]'', ''INT'') AS priority,
           bg.value(''(process/@trancount)[1]'', ''INT'') AS trancount,
           bg.value(''(process/@clientapp)[1]'', ''NVARCHAR(256)'') AS clientapp,
           bg.value(''(process/@hostname)[1]'', ''NVARCHAR(256)'') AS hostname,
           bg.value(''(process/@loginname)[1]'', ''NVARCHAR(256)'') AS loginname,
           bg.value(''(process/@isolationlevel)[1]'', ''NVARCHAR(50)'') AS isolationlevel,
           NULL AS sqlhandle,
           c.query(''.'') AS process_report
    FROM #human_events_xml_internal AS xet
    OUTER APPLY xet.human_events_xml.nodes(''//event'') AS oa(c)
    OUTER APPLY oa.c.nodes(''//blocked-process-report/blocking-process'') AS bg(bg)
    WHERE c.exist(''@timestamp[. > sql:variable("@date_filter")]'') = 1
) AS x
) AS x
WHERE NOT EXISTS
(
    SELECT 1/0
    FROM ' + @object_name_check + N' AS x2
    WHERE x.database_id = x2.database_id
    AND   x.object_id = x2.object_id
    AND   x.transaction_id = x2.transaction_id
    AND   x.spid = x2.spid
    AND   x.ecid = x2.ecid
    AND   x.clientapp = x2.client_app
    AND   x.hostname = x2.host_name
    AND   x.loginname = x2.login_name
)
AND x.x = 1
OPTION (RECOMPILE);

UPDATE x2
    SET x2.wait_time = x.waittime
FROM ' + @object_name_check + N' AS x2
JOIN 
(
    SELECT @@SERVERNAME AS server_name,       
           ''blocked'' AS activity,
           c.value(''(data[@name="database_id"]/value)[1]'', ''INT'') AS database_id,
           c.value(''(data[@name="object_id"]/value)[1]'', ''INT'') AS object_id,
           c.value(''(data[@name="transaction_id"]/value)[1]'', ''BIGINT'') AS transaction_id,
           c.value(''(//@monitorLoop)[1]'', ''INT'') AS monitor_loop,
           bd.value(''(process/@spid)[1]'', ''INT'') AS spid,
           bd.value(''(process/@ecid)[1]'', ''INT'') AS ecid,
           bd.value(''(process/@waittime)[1]'', ''BIGINT'') AS waittime,
           bd.value(''(process/@clientapp)[1]'', ''NVARCHAR(256)'') AS clientapp,
           bd.value(''(process/@hostname)[1]'', ''NVARCHAR(256)'') AS hostname,
           bd.value(''(process/@loginname)[1]'', ''NVARCHAR(256)'') AS loginname
    FROM #human_events_xml_internal AS xet
    OUTER APPLY xet.human_events_xml.nodes(''//event'') AS oa(c)
    OUTER APPLY oa.c.nodes(''//blocked-process-report/blocked-process'') AS bd(bd)
    WHERE c.exist(''@timestamp[. > sql:variable("@date_filter")]'') = 1
) AS x
    ON    x.database_id = x2.database_id
    AND   x.object_id = x2.object_id
    AND   x.transaction_id = x2.transaction_id
    AND   x.spid = x2.spid
    AND   x.ecid = x2.ecid
    AND   x.clientapp = x2.client_app
    AND   x.hostname = x2.host_name
    AND   x.loginname = x2.login_name
OPTION (RECOMPILE);
'
                       WHEN @event_type_check LIKE N'%quer%' /*Queries!*/
                       THEN N'INSERT INTO ' + @object_name_check + N' WITH(TABLOCK) ' + NCHAR(10) + 
                            N'( server_name, event_time, event_type, database_name, object_name, sql_text, statement, ' + NCHAR(10) +
                            N'  showplan_xml, cpu_ms, logical_reads, physical_reads, duration_ms, writes_mb, ' + NCHAR(10) +
                            N'  spills_mb, row_count, estimated_rows, dop,  serial_ideal_memory_mb, ' + NCHAR(10) +
                            N'  requested_memory_mb, used_memory_mb, ideal_memory_mb, granted_memory_mb, ' + NCHAR(10) +
                            N'  query_plan_hash_signed, query_hash_signed, plan_handle )' + NCHAR(10) +
                            N'SELECT @@SERVERNAME, 
       DATEADD(MINUTE, DATEDIFF(MINUTE, GETUTCDATE(), SYSDATETIME()), c.value(''@timestamp'', ''DATETIME2'')) AS event_time,
       c.value(''@name'', ''NVARCHAR(256)'') AS event_type,
       c.value(''(action[@name="database_name"]/value)[1]'', ''NVARCHAR(256)'') AS database_name,                
       c.value(''(data[@name="object_name"]/value)[1]'', ''NVARCHAR(256)'') AS [object_name],
       c.value(''(action[@name="sql_text"]/value)[1]'', ''NVARCHAR(MAX)'') AS sql_text,
       c.value(''(data[@name="statement"]/value)[1]'', ''NVARCHAR(MAX)'') AS statement,
       c.query(''(data[@name="showplan_xml"]/value/*)[1]'') AS [showplan_xml],
       c.value(''(data[@name="cpu_time"]/value)[1]'', ''BIGINT'') / 1000. AS cpu_ms,
      (c.value(''(data[@name="logical_reads"]/value)[1]'', ''BIGINT'') * 8) / 1024. AS logical_reads,
      (c.value(''(data[@name="physical_reads"]/value)[1]'', ''BIGINT'') * 8) / 1024. AS physical_reads,
       c.value(''(data[@name="duration"]/value)[1]'', ''BIGINT'') / 1000. AS duration_ms,
      (c.value(''(data[@name="writes"]/value)[1]'', ''BIGINT'') * 8) / 1024. AS writes_mb,
      (c.value(''(data[@name="spills"]/value)[1]'', ''BIGINT'') * 8) / 1024. AS spills_mb,
       c.value(''(data[@name="row_count"]/value)[1]'', ''BIGINT'') AS row_count,
       c.value(''(data[@name="estimated_rows"]/value)[1]'', ''BIGINT'') AS estimated_rows,
       c.value(''(data[@name="dop"]/value)[1]'', ''INT'') AS dop,
       c.value(''(data[@name="serial_ideal_memory_kb"]/value)[1]'', ''BIGINT'') / 1024. AS serial_ideal_memory_mb,
       c.value(''(data[@name="requested_memory_kb"]/value)[1]'', ''BIGINT'') / 1024. AS requested_memory_mb,
       c.value(''(data[@name="used_memory_kb"]/value)[1]'', ''BIGINT'') / 1024. AS used_memory_mb,
       c.value(''(data[@name="ideal_memory_kb"]/value)[1]'', ''BIGINT'') / 1024. AS ideal_memory_mb,
       c.value(''(data[@name="granted_memory_kb"]/value)[1]'', ''BIGINT'') / 1024. AS granted_memory_mb,
       CONVERT(BINARY(8), c.value(''(action[@name="query_plan_hash_signed"]/value)[1]'', ''BIGINT'')) AS query_plan_hash_signed,
       CONVERT(BINARY(8), c.value(''(action[@name="query_hash_signed"]/value)[1]'', ''BIGINT'')) AS query_hash_signed,
       c.value(''xs:hexBinary((action[@name="plan_handle"]/value/text())[1])'', ''VARBINARY(64)'') AS plan_handle
FROM #human_events_xml_internal AS xet
OUTER APPLY xet.human_events_xml.nodes(''//event'') AS oa(c)
WHERE c.exist(''@timestamp[. > sql:variable("@date_filter")]'') = 1
AND   c.exist(''(action[@name="query_hash_signed"]/value[. != 0])'') = 1
OPTION(RECOMPILE); '
                       WHEN @event_type_check LIKE N'%recomp%' /*Recompiles!*/
                       THEN N'INSERT INTO ' + @object_name_check + N' WITH(TABLOCK) ' + NCHAR(10) + 
                            N'( server_name, event_time,  event_type,  ' + NCHAR(10) +
                            N'  database_name, object_name, recompile_cause, statement_text '
                            + CASE WHEN @compile_events = 1 THEN N', compile_cpu_ms, compile_duration_ms )' ELSE N' )' END + NCHAR(10) +
                            N'SELECT @@SERVERNAME,
       DATEADD(MINUTE, DATEDIFF(MINUTE, GETUTCDATE(), SYSDATETIME()), c.value(''@timestamp'', ''DATETIME2'')) AS event_time,
       c.value(''@name'', ''NVARCHAR(256)'') AS event_type,
       c.value(''(action[@name="database_name"]/value)[1]'', ''NVARCHAR(256)'') AS database_name,                
       c.value(''(data[@name="object_name"]/value)[1]'', ''NVARCHAR(256)'') AS [object_name],
       c.value(''(data[@name="recompile_cause"]/text)[1]'', ''NVARCHAR(256)'') AS recompile_cause,
       c.value(''(data[@name="statement"]/value)[1]'', ''NVARCHAR(MAX)'') AS statement_text '
   + CASE WHEN @compile_events = 1 /*Only get these columns if we're using the newer XE: sql_statement_post_compile*/
          THEN 
   N'  , 
       c.value(''(data[@name="cpu_time"]/value)[1]'', ''BIGINT'') AS compile_cpu_ms,
       c.value(''(data[@name="duration"]/value)[1]'', ''BIGINT'') AS compile_duration_ms'
          ELSE N''
     END + N'
FROM #human_events_xml_internal AS xet
OUTER APPLY xet.human_events_xml.nodes(''//event'') AS oa(c)
WHERE 1 = 1 '
      + CASE WHEN @compile_events = 1 /*Same here, where we need to filter data*/
             THEN 
N'
AND c.exist(''(data[@name="is_recompile"]/value[. = "false"])'') = 0 '
             ELSE N''
        END + N'
AND c.exist(''@timestamp[. > sql:variable("@date_filter")]'') = 1
ORDER BY event_time
OPTION (RECOMPILE);'
                       WHEN @event_type_check LIKE N'%comp%' AND @event_type_check NOT LIKE N'%re%' /*Compiles!*/
                       THEN N'INSERT INTO ' + REPLACE(@object_name_check, N'_parameterization', N'') + N' WITH(TABLOCK) ' + NCHAR(10) + 
                            N'( server_name, event_time,  event_type,  ' + NCHAR(10) +
                            N'  database_name, object_name, statement_text '
                            + CASE WHEN @compile_events = 1 THEN N', compile_cpu_ms, compile_duration_ms )' ELSE N' )' END + NCHAR(10) +
                            N'SELECT @@SERVERNAME,
       DATEADD(MINUTE, DATEDIFF(MINUTE, GETUTCDATE(), SYSDATETIME()), c.value(''@timestamp'', ''DATETIME2'')) AS event_time,
       c.value(''@name'', ''NVARCHAR(256)'') AS event_type,
       c.value(''(action[@name="database_name"]/value)[1]'', ''NVARCHAR(256)'') AS database_name,                
       c.value(''(data[@name="object_name"]/value)[1]'', ''NVARCHAR(256)'') AS [object_name],
       c.value(''(data[@name="statement"]/value)[1]'', ''NVARCHAR(MAX)'') AS statement_text '
   + CASE WHEN @compile_events = 1 /*Only get these columns if we're using the newer XE: sql_statement_post_compile*/
          THEN 
   N'  , 
       c.value(''(data[@name="cpu_time"]/value)[1]'', ''BIGINT'') AS compile_cpu_ms,
       c.value(''(data[@name="duration"]/value)[1]'', ''BIGINT'') AS compile_duration_ms'
          ELSE N''
     END + N'
FROM #human_events_xml_internal AS xet
OUTER APPLY xet.human_events_xml.nodes(''//event'') AS oa(c)
WHERE 1 = 1 '
      + CASE WHEN @compile_events = 1 /*Just like above*/
             THEN 
N' 
AND c.exist(''(data[@name="is_recompile"]/value[. = "false"])'') = 1 '
             ELSE N''
        END + N'
AND   c.exist(''@name[.= "sql_statement_post_compile"]'') = 1
AND   c.exist(''@timestamp[. > sql:variable("@date_filter")]'') = 1
ORDER BY event_time
OPTION (RECOMPILE);' + NCHAR(10)
                            + CASE WHEN @parameterization_events = 1 /*The query_parameterization_data XE is only 2017+*/
                                   THEN 
                            NCHAR(10) + 
                            N'INSERT INTO ' + REPLACE(@object_name_check, N'_parameterization', N'') + N'_parameterization' + N' WITH(TABLOCK) ' + NCHAR(10) + 
                            N'( server_name, event_time,  event_type, database_name, sql_text, compile_cpu_time_ms, ' + NCHAR(10) +
                            N'  compile_duration_ms, query_param_type, is_cached, is_recompiled, compile_code, has_literals, ' + NCHAR(10) +
                            N'  is_parameterizable, parameterized_values_count, query_plan_hash, query_hash, plan_handle, statement_sql_hash ) ' + NCHAR(10) +
                            N'SELECT @@SERVERNAME,
       DATEADD(MINUTE, DATEDIFF(MINUTE, GETUTCDATE(), SYSDATETIME()), c.value(''@timestamp'', ''DATETIME2'')) AS event_time,
       c.value(''@name'', ''NVARCHAR(256)'') AS event_type,
       c.value(''(action[@name="database_name"]/value)[1]'', ''NVARCHAR(256)'') AS database_name,                
       c.value(''(action[@name="sql_text"]/value)[1]'', ''NVARCHAR(MAX)'') AS sql_text,
       c.value(''(data[@name="compile_cpu_time"]/value)[1]'', ''BIGINT'') / 1000. AS compile_cpu_time_ms,
       c.value(''(data[@name="compile_duration"]/value)[1]'', ''BIGINT'') / 1000. AS compile_duration_ms,
       c.value(''(data[@name="query_param_type"]/value)[1]'', ''INT'') AS query_param_type,
       c.value(''(data[@name="is_cached"]/value)[1]'', ''BIT'') AS is_cached,
       c.value(''(data[@name="is_recompiled"]/value)[1]'', ''BIT'') AS is_recompiled,
       c.value(''(data[@name="compile_code"]/text)[1]'', ''NVARCHAR(256)'') AS compile_code,                  
       c.value(''(data[@name="has_literals"]/value)[1]'', ''BIT'') AS has_literals,
       c.value(''(data[@name="is_parameterizable"]/value)[1]'', ''BIT'') AS is_parameterizable,
       c.value(''(data[@name="parameterized_values_count"]/value)[1]'', ''BIGINT'') AS parameterized_values_count,
       c.value(''xs:hexBinary((data[@name="query_plan_hash"]/value/text())[1])'', ''BINARY(8)'') AS query_plan_hash,
       c.value(''xs:hexBinary((data[@name="query_hash"]/value/text())[1])'', ''BINARY(8)'') AS query_hash,
       c.value(''xs:hexBinary((action[@name="plan_handle"]/value/text())[1])'', ''VARBINARY(64)'') AS plan_handle, 
       c.value(''xs:hexBinary((data[@name="statement_sql_hash"]/value/text())[1])'', ''VARBINARY(64)'') AS statement_sql_hash
FROM #human_events_xml_internal AS xet
OUTER APPLY xet.human_events_xml.nodes(''//event'') AS oa(c)
WHERE c.exist(''@name[.= "query_parameterization_data"]'') = 1
AND   c.exist(''(data[@name="is_recompiled"]/value[. = "false"])'') = 1
AND   c.exist(''@timestamp[. > sql:variable("@date_filter")]'') = 1
ORDER BY event_time
OPTION (RECOMPILE);'
                                   ELSE N'' 
                              END  
                       ELSE N''
                  END;
            
            --this table is only used for the inserts, hence the "internal" in the name
            SELECT @x = CONVERT(XML, t.target_data)
            FROM   sys.dm_xe_session_targets AS t
            JOIN   sys.dm_xe_sessions AS s
                ON s.address = t.event_session_address
            WHERE  s.name = @event_type_check
            AND    t.target_name = N'ring_buffer'
            OPTION (RECOMPILE);
            
            INSERT #human_events_xml_internal WITH (TABLOCK)
                   (human_events_xml)            
            SELECT e.x.query('.') AS human_events_xml
            FROM   @x.nodes('/RingBufferTarget/event') AS e(x)
            OPTION (RECOMPILE);
            
            IF @debug = 1
            BEGIN 
                PRINT SUBSTRING(@table_sql, 0, 4000);
                PRINT SUBSTRING(@table_sql, 4000, 8000);
                PRINT SUBSTRING(@table_sql, 8000, 12000);
                PRINT SUBSTRING(@table_sql, 12000, 16000);
                PRINT SUBSTRING(@table_sql, 16000, 20000);
                PRINT SUBSTRING(@table_sql, 20000, 24000);
                PRINT SUBSTRING(@table_sql, 24000, 28000);
                PRINT SUBSTRING(@table_sql, 28000, 32000);
                PRINT SUBSTRING(@table_sql, 32000, 36000);
                PRINT SUBSTRING(@table_sql, 36000, 40000);           
            END;
            
            --this executes the insert
            EXEC sys.sp_executesql @table_sql, N'@date_filter DATETIME', @date_filter;
            
            /*Update the worker table's last checked, and conditionally, updated dates*/
            UPDATE hew
                   SET hew.last_checked = SYSDATETIME(),
                       hew.last_updated = CASE WHEN @@ROWCOUNT > 0 
                                               THEN SYSDATETIME()
                                               ELSE hew.last_updated
                                          END 
            FROM #human_events_worker AS hew
            WHERE hew.id = @min_id
            OPTION (RECOMPILE);
            
            IF @debug = 1 BEGIN SELECT N'#human_events_worker' AS table_name, * FROM #human_events_worker AS hew OPTION (RECOMPILE); END;
            IF @debug = 1 BEGIN SELECT N'#human_events_xml_internal' AS table_name, * FROM #human_events_xml_internal AS hew OPTION (RECOMPILE); END;

            /*Clear the table out between runs*/
            TRUNCATE TABLE #human_events_xml_internal;

            IF @debug = 1 BEGIN RAISERROR(N'@min_id: %i', 0, 1, @min_id) WITH NOWAIT; END;

            RAISERROR(N'Setting next id after %i out of %i total', 0, 1, @min_id, @max_id) WITH NOWAIT;
            
            SET @min_id = 
            (
                SELECT TOP (1) hew.id
                FROM #human_events_worker AS hew
                WHERE hew.id > @min_id
                AND   hew.is_table_created = 1
                ORDER BY hew.id
            );

            IF @debug = 1 BEGIN RAISERROR(N'new @min_id: %i', 0, 1, @min_id) WITH NOWAIT; END;

            IF @min_id IS NULL BREAK;
            
            END;
        END;
    
    END;


/*This sesion handles deleting data from tables older than the retention period*/
/*The idea is to only check once an hour so we're not constantly purging*/
DECLARE @Time TIME = SYSDATETIME();
IF ( DATEPART(MINUTE, @Time) <= 5 )
BEGIN     
    DECLARE @delete_tracker INT;
    
    IF (@delete_tracker IS NULL
            OR @delete_tracker <> DATEPART(HOUR, @Time) )
    BEGIN     
        DECLARE @the_deleter_must_awaken NVARCHAR(MAX) = N'';    
        
        SELECT @the_deleter_must_awaken += 
          N' DELETE FROM ' + QUOTENAME(hew.output_database) + N'.' +
                           + QUOTENAME(hew.output_schema)   + N'.' +
                           + QUOTENAME(hew.event_type)   
        + N' WHERE event_time < DATEADD(DAY, (-1 * @delete_retention_days), SYSDATETIME())
             OPTION (RECOMPILE); ' + NCHAR(10)
        FROM #human_events_worker AS hew
        OPTION (RECOMPILE);
        
        IF @debug = 1 BEGIN RAISERROR(@the_deleter_must_awaken, 0, 1) WITH NOWAIT; END;
        
        --execute the delete
        EXEC sys.sp_executesql @the_deleter_must_awaken, N'@delete_retention_days INT', @delete_retention_days;
        
        --set this to the hour it was last checked
        SET @delete_tracker = DATEPART(HOUR, SYSDATETIME());    
    END;
END;

/*Wait 5 seconds, then start the output loop again*/
WAITFOR DELAY '00:00:05.000';

END;

/*This section handles cleaning up stuff.*/
cleanup:
BEGIN     
    RAISERROR(N'CLEAN UP PARTY TONIGHT', 0, 1) WITH NOWAIT;

    DECLARE @executer NVARCHAR(MAX) = QUOTENAME(@output_database_name) + N'.sys.sp_executesql ';

    /*Clean up sessions, this isn't database-specific*/
    DECLARE @cleanup_sessions NVARCHAR(MAX) = N'';             
    SELECT @cleanup_sessions +=   
    N'DROP EVENT SESSION ' + ses.name + N' ON SERVER;' + NCHAR(10)  
    FROM sys.server_event_sessions AS ses  
    LEFT JOIN sys.dm_xe_sessions AS dxs  
        ON dxs.name = ses.name  
    WHERE ses.name LIKE N'%HumanEvents_%';  
        
    EXEC sys.sp_executesql @cleanup_sessions;  
    IF @debug = 1 BEGIN RAISERROR(@cleanup_sessions, 0, 1) WITH NOWAIT; END;
  

    /*Clean up tables*/
    RAISERROR(N'CLEAN UP PARTY TONIGHT', 0, 1) WITH NOWAIT;

    DECLARE @cleanup_tables NVARCHAR(MAX) = N'';
    DECLARE @drop_holder NVARCHAR(MAX) = N'';
  
    SELECT @cleanup_tables += N'
    SELECT @i_cleanup_tables += N''DROP TABLE ''  
           + SCHEMA_NAME(s.schema_id)
           + N''.''
           + QUOTENAME(s.name)
           + ''; ''
           + NCHAR(10)
    FROM ' + QUOTENAME(@output_database_name) + N'.sys.tables AS s
    WHERE s.name LIKE ''' + '%HumanEvents%' + N''' OPTION(RECOMPILE);';
    
    EXEC sys.sp_executesql @cleanup_tables, N'@i_cleanup_tables NVARCHAR(MAX) OUTPUT', @i_cleanup_tables = @drop_holder OUTPUT;  
    IF @debug = 1 
    BEGIN
        RAISERROR(@executer, 0, 1) WITH NOWAIT;
        RAISERROR(@drop_holder, 0, 1) WITH NOWAIT;
    END;
    
    EXEC @executer @drop_holder;
  
    /*Cleanup views*/
    RAISERROR(N'CLEAN UP PARTY TONIGHT', 0, 1) WITH NOWAIT;

    DECLARE @cleanup_views NVARCHAR(MAX) = N'';
    SET @drop_holder = N'';
  
    SELECT @cleanup_views += N'
    SELECT @i_cleanup_views += N''DROP VIEW ''  
           + SCHEMA_NAME(v.schema_id)
           + N''.''
           + QUOTENAME(v.name)
           + ''; ''
           + NCHAR(10)
    FROM ' + QUOTENAME(@output_database_name) + N'.sys.views AS v
    WHERE v.name LIKE ''' + '%HumanEvents%' + N''' OPTION(RECOMPILE);';
    
    EXEC sys.sp_executesql @cleanup_views, N'@i_cleanup_views NVARCHAR(MAX) OUTPUT', @i_cleanup_views = @drop_holder OUTPUT;  
    IF @debug = 1 
    BEGIN
        RAISERROR(@executer, 0, 1) WITH NOWAIT;
        RAISERROR(@drop_holder, 0, 1) WITH NOWAIT;
    END;

    EXEC @executer @drop_holder;

    RETURN;
END; 


END TRY

/*Error handling, I guess*/
BEGIN CATCH
    BEGIN
    
    IF @@TRANCOUNT > 0 
        ROLLBACK TRANSACTION;
    
    DECLARE @msg NVARCHAR(2048) = N'';
    SELECT  @msg += N'Error number '
                 +  RTRIM(ERROR_NUMBER()) 
                 +  N' with severity '
                 +  RTRIM(ERROR_SEVERITY()) 
                 +  N' and a state of '
                 +  RTRIM(ERROR_STATE()) 
                 +  N' in procedure ' 
                 +  ERROR_PROCEDURE() 
                 +  N' on line '  
                 +  RTRIM(ERROR_LINE())
                 +  NCHAR(10)
                 +  ERROR_MESSAGE(); 
          
        /*Only try to drop a session if we're not outputting*/
        IF ( @output_database_name = N''
              AND @output_schema_name = N'' )
        BEGIN
            IF @debug = 1 BEGIN RAISERROR(@stop_sql, 0, 1) WITH NOWAIT; END;
            RAISERROR(N'all done, stopping session', 0, 1) WITH NOWAIT;
            EXEC (@stop_sql);
            
            IF @debug = 1 BEGIN RAISERROR(@drop_sql, 0, 1) WITH NOWAIT; END;
            RAISERROR(N'and dropping session', 0, 1) WITH NOWAIT;
            EXEC (@drop_sql);
        END;

        RAISERROR (@msg, 16, 1) WITH NOWAIT;
        THROW;

        RETURN -138;
    END;
END CATCH;

END;
GO
/****** Object:  StoredProcedure [dbo].[sp_PressureDetector]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_PressureDetector] (  @what_to_check NVARCHAR(6) = N'both',     
                                           @version VARCHAR(5) = NULL OUTPUT,
                                           @versiondate DATETIME = NULL OUTPUT )
WITH RECOMPILE
AS 
BEGIN
SET NOCOUNT, XACT_ABORT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    
SELECT @version = '1.0', @versiondate = '20200301';

/*
Designed to fill in some blank spots in sp_WhoIsActive and other monitoring scripts, this focuses on two key areas:

What’s happening with your CPUs
What’s happening with your RAM
*/

/*
        Copyright (c) 2020 Darling Data, LLC 
  
        https://erikdarlingdata.com/
  
        MIT License

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
*/

    /*
    Check to see if the DAC is enabled.
    If it's not, give people some helpful information.
    */
    IF ( SELECT c.value_in_use
         FROM sys.configurations AS c
         WHERE c.name = N'remote admin connections' ) = 0
    BEGIN
        SELECT 'This works a lot better on a troublesome server with the DAC enabled' AS message,
               'EXEC sp_configure ''remote admin connections'', 1; RECONFIGURE;' AS command_to_run,
               'https://bit.ly/RemoteDAC' AS how_to_use_the_dac;
    END;
    
    /*
    See if someone else is using the DAC.
    Return some helpful information if they are.
    */
    IF EXISTS ( SELECT 1/0
                FROM sys.endpoints AS ep
                JOIN sys.dm_exec_sessions AS ses
                    ON ep.endpoint_id = ses.endpoint_id
                WHERE ep.name = N'Dedicated Admin Connection'
                AND   ses.session_id <> @@SPID )
    BEGIN
        SELECT N'who stole the dac?' AS dac_thief,
               ses.session_id,
               ses.login_time,
               ses.host_name,
               ses.program_name,
               ses.login_name,
               ses.nt_domain,
               ses.nt_user_name,
               ses.status,
               ses.last_request_start_time,
               ses.last_request_end_time
        FROM sys.endpoints AS ep
        JOIN sys.dm_exec_sessions AS ses
            ON ep.endpoint_id = ses.endpoint_id
        WHERE ep.name = N'Dedicated Admin Connection'
        AND   ses.session_id <> @@SPID;
    END;


    /*Memory Grant info*/
    IF @what_to_check IN (N'both', N'memory')
    BEGIN

    DECLARE @mem_sql NVARCHAR(MAX) = N'';
    DECLARE @helpful_new_columns BIT = 0;  
    
    IF ( SELECT COUNT(*)
         FROM sys.all_columns AS ac 
         WHERE OBJECT_NAME(ac.object_id) = N'dm_exec_query_memory_grants'
         AND ac.name IN (N'reserved_worker_count', N'used_worker_count') ) = 2
    BEGIN
        SET @helpful_new_columns = 1;
    END;    

    SET @mem_sql += N'
    SELECT      deqmg.session_id,
                deqmg.request_time,
                deqmg.grant_time,
                (deqmg.requested_memory_kb / 1024.) requested_memory_mb,
                (deqmg.granted_memory_kb / 1024.) granted_memory_mb,
                (deqmg.ideal_memory_kb / 1024.) ideal_memory_mb,        
                (deqmg.required_memory_kb / 1024.) required_memory_mb,
                (deqmg.used_memory_kb / 1024.) used_memory_mb,
                (deqmg.max_used_memory_kb / 1024.) max_used_memory_mb,
                deqmg.queue_id,
                deqmg.wait_order,
                deqmg.is_next_candidate,
                (deqmg.wait_time_ms / 1000.) wait_time_s,
                (waits.wait_duration_ms / 1000.) wait_duration_s,
                deqmg.dop,
                waits.wait_type,'
                + CASE WHEN @helpful_new_columns = 1
                       THEN N'
                deqmg.reserved_worker_count,
                deqmg.used_worker_count,'
                       ELSE N''
                END
                + N'
                deqp.query_plan,
                deqmg.plan_handle
    FROM        sys.dm_exec_query_memory_grants AS deqmg
    OUTER APPLY ( SELECT   TOP (1) *
                  FROM     sys.dm_os_waiting_tasks AS dowt
                  WHERE    dowt.session_id = deqmg.session_id
                  ORDER BY dowt.session_id ) AS waits
    OUTER APPLY sys.dm_exec_query_plan(deqmg.plan_handle) AS deqp
    WHERE deqmg.session_id <> @@SPID
    ORDER BY deqmg.request_time
    OPTION(MAXDOP 1);
    ';

    EXEC sys.sp_executesql @mem_sql;
    
    /*Resource semaphore info*/
    SELECT  deqrs.resource_semaphore_id,
            (deqrs.target_memory_kb / 1024.) target_memory_mb,
            (deqrs.max_target_memory_kb / 1024.) max_target_memory_mb,
            (deqrs.total_memory_kb / 1024.) total_memory_mb,
            (deqrs.available_memory_kb / 1024.) available_memory_mb,
            (deqrs.granted_memory_kb / 1024.) granted_memory_mb,
            (deqrs.used_memory_kb / 1024.) used_memory_mb,
            deqrs.grantee_count,
            deqrs.waiter_count,
            deqrs.timeout_error_count,
            deqrs.forced_grant_count,
            deqrs.pool_id
    FROM sys.dm_exec_query_resource_semaphores AS deqrs
    WHERE deqrs.resource_semaphore_id = 0
    AND   deqrs.pool_id = 2
    OPTION(MAXDOP 1);
    END;

    IF @what_to_check IN (N'cpu', N'both')
    BEGIN
    /*Thread usage*/
    SELECT     MAX(osi.max_workers_count) AS total_threads,
               SUM(dos.active_workers_count) AS used_threads,
               MAX(osi.max_workers_count) - SUM(dos.active_workers_count) AS available_threads,
               SUM(dos.runnable_tasks_count) AS threads_waiting_for_cpu,
               SUM(dos.work_queue_count) AS requests_waiting_for_threads,
               SUM(dos.current_workers_count) AS current_workers
    FROM       sys.dm_os_schedulers AS dos
    CROSS JOIN sys.dm_os_sys_info AS osi
    WHERE      dos.status = N'VISIBLE ONLINE'
    OPTION(MAXDOP 1);

    
    /*Any threadpool waits*/
    SELECT dowt.session_id,
           dowt.wait_duration_ms,
           dowt.wait_type
    FROM sys.dm_os_waiting_tasks AS dowt
    WHERE dowt.wait_type = N'THREADPOOL'
    ORDER BY dowt.wait_duration_ms DESC
    OPTION(MAXDOP 1);


    /*Figure out who's using a lot of CPU*/
    DECLARE @cpu_sql NVARCHAR(MAX) = N'';
    DECLARE @cool_new_columns BIT = 0;
    
    IF ( SELECT COUNT(*)
         FROM sys.all_columns AS ac 
         WHERE OBJECT_NAME(ac.object_id) = N'dm_exec_requests'
         AND ac.name IN (N'dop', N'parallel_worker_count') ) = 2
    BEGIN
        SET @cool_new_columns = 1;
    END;
    
    SET @cpu_sql += N'
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    
    SELECT der.session_id,
           DB_NAME(der.database_id) AS database_name,
           der.start_time,
           SUBSTRING(
                    dest.text, ( der.statement_start_offset / 2 ) + 1,
                    (( CASE der.statement_end_offset WHEN -1 THEN DATALENGTH(dest.text) ELSE der.statement_end_offset END
                       - der.statement_start_offset ) / 2 ) + 1) AS query_text,
           deqp.query_plan,
           der.plan_handle,
           der.status,
           der.blocking_session_id,
           der.wait_type,
           der.wait_time,
           der.wait_resource,
           der.cpu_time,
           der.total_elapsed_time,
           der.reads,
           der.writes,
           der.logical_reads,
           CASE 
               WHEN der.transaction_isolation_level = 0 THEN ''Unspecified''
               WHEN der.transaction_isolation_level = 1 THEN ''Read Uncommitted''
               WHEN der.transaction_isolation_level = 2 AND EXISTS ( SELECT 1/0 FROM sys.dm_tran_active_snapshot_database_transactions AS trn WHERE der.session_id = trn.session_id AND is_snapshot = 0 ) THEN ''Read Committed Snapshot Isolation''
               WHEN der.transaction_isolation_level = 2 AND NOT EXISTS ( SELECT 1/0 FROM sys.dm_tran_active_snapshot_database_transactions AS trn WHERE der.session_id = trn.session_id AND is_snapshot = 0 ) THEN ''Read Committed''
               WHEN der.transaction_isolation_level = 3 THEN ''Repeatable Read''
               WHEN der.transaction_isolation_level = 4 THEN ''Serializable''
               WHEN der.transaction_isolation_level = 5 THEN ''Snapshot''
               ELSE ''???''
           END AS transaction_isolation_level ,
           der.granted_query_memory'
           + CASE WHEN @cool_new_columns = 1
                  THEN N',
           der.dop,
           der.parallel_worker_count'
                  ELSE N''
             END
           + N'
    FROM sys.dm_exec_requests AS der
    CROSS APPLY sys.dm_exec_sql_text(der.plan_handle) AS dest
    CROSS APPLY sys.dm_exec_query_plan(der.plan_handle) AS deqp
    WHERE der.session_id <> @@SPID
    AND der.session_id >= 50
    ORDER BY ' + CASE WHEN @cool_new_columns = 1
                      THEN N'der.parallel_worker_count DESC
                     OPTION(MAXDOP 1);'
                      ELSE N'der.cpu_time DESC
                     OPTION(MAXDOP 1);'
             END;
    
    EXEC sys.sp_executesql @cpu_sql;
    END;
END;
GO
/****** Object:  StoredProcedure [metrics].[loadAllDBFileMetrics]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [metrics].[loadAllDBFileMetrics]
AS

/**************************************************************************
	Author: Eric Cobb - http://www.sqlnuggets.com/
		License:
			MIT License
			Copyright (c) 2017 Eric Cobb
			View full license disclosure: https://github.com/ericcobb/SQL-Server-Metrics-Pack/blob/master/LICENSE
			
	Purpose: 
			This stored procedure is used to collect Database File Metrics for all databases on the server,
		    this data is persisted in the metrics.DatabaseFileMetrics table. 

	Parameters:
			NONE

	Usage:	
			--Collect Database File Metrics for all databases
			EXEC [metrics].[loadAllDBFileMetrics];

***************************************************************************/

BEGIN
	SET NOCOUNT ON;

	DECLARE @tmpDatabases TABLE (
				ID INT IDENTITY PRIMARY KEY
				,DatabaseName NVARCHAR(128)
				,Completed BIT
			);

	DECLARE @CurrentID INT;
	DECLARE @CurrentDatabaseName NVARCHAR(128);

	INSERT INTO @tmpDatabases (DatabaseName, Completed)
	SELECT [Name], 0
	FROM sys.databases
	WHERE state = 0
	AND source_database_id IS NULL
	ORDER BY [Name] ASC


	WHILE EXISTS (SELECT * FROM @tmpDatabases WHERE Completed = 0)
	BEGIN
		SELECT TOP 1 @CurrentID = ID,
					 @CurrentDatabaseName = DatabaseName
		FROM @tmpDatabases
		WHERE Completed = 0
		ORDER BY ID ASC

		EXEC [metrics].[loadDatabaseFileMetrics] @DBName = @CurrentDatabaseName

		-- Update that the database is completed
		UPDATE @tmpDatabases
		SET Completed = 1
		WHERE ID = @CurrentID

		-- Clear variables
		SET @CurrentID = NULL
		SET @CurrentDatabaseName = NULL
	END
END
GO
/****** Object:  StoredProcedure [metrics].[loadDatabaseFileMetrics]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [metrics].[loadDatabaseFileMetrics]
	@DBName NVARCHAR(128) --Name of the Database you want to collect Database File Metrics for.
AS 

/**************************************************************************
	Author: Eric Cobb - http://www.sqlnuggets.com/
		License:
			MIT License
			Copyright (c) 2017 Eric Cobb
			View full license disclosure: https://github.com/ericcobb/SQL-Server-Metrics-Pack/blob/master/LICENSE
			
	Purpose: 
			This stored procedure is used to collect Database File Metrics from multiple DMVs,
		    this data is persisted in the metrics.DatabaseFileMetrics table. 

	Parameters:
			@DBName - Name of the Database you want to collect Index Metrics for.

	Usage:	
			--Collect Database File Metrics for the MyDB database
			EXEC [metrics].[loadDatabaseFileMetrics] @DBName='MyDB';

	Knows Issues:
			@DBName currently only supports a single database, so the loadDatabaseFileMetrics procedure will have to be run individually for 
			each database that you want to gather Index Metrics for.  Future enhancements will allow for muliple databases.
***************************************************************************/

BEGIN

	SET NOCOUNT ON
	
	DECLARE @sql NVARCHAR(MAX)
	DECLARE @crlf NCHAR(2) = NCHAR(13)+NCHAR(10) 
	DECLARE @CaptureDate [datetime] = SYSDATETIME()

	CREATE TABLE #DBFileInfo(
		[DatabaseID] [smallint] NULL,
		[DatabaseName] [nvarchar](128) NULL,
		[FileID] [int] NOT NULL,
		[FileName] [nvarchar](128) NOT NULL,
		[FileType] [nvarchar](60) NULL,
		[FileLocation] [nvarchar](260) NOT NULL,
		[CurrentState] [nvarchar](60) NULL,
		[isReadOnly] [bit] NOT NULL,
		[CurrentSizeMB] [decimal](10, 2) NULL,
		[SpaceUsedMB] [decimal](10, 2) NULL,
		[PercentUsed] [decimal](10, 2) NULL,
		[FreeSpaceMB] [decimal](10, 2) NULL,
		[PercentFree] [decimal](10, 2) NULL,
		[AutoGrowth] [varchar](128) NULL
	) ON [PRIMARY]


	SET @sql = N'
	USE '+ @DBName +' 
	' + @crlf

	--Load the Database File Metrics into our Temp table
	SET @sql = @sql +  N'INSERT INTO #DBFileInfo ([DatabaseID],[DatabaseName],[FileID],[FileName],[FileType],[FileLocation],[CurrentState],[isReadOnly],[CurrentSizeMB],[SpaceUsedMB],[PercentUsed],[FreeSpaceMB],[PercentFree],[AutoGrowth])
	SELECT [DatabaseID] = f.database_id
		,[DatabaseName] = DB_NAME()
		,[FileID] = d.file_id
		,[FileName] = d.name
		,[FileType] = d.type_desc
		,[FileLocation] = f.physical_name
		,[CurrentState] = d.state_desc
		,[isReadOnly] = d.is_read_only
		,[CurrentSizeMB] = CONVERT(DECIMAL(10,2),d.SIZE/128.0)
		,[SpaceUsedMB] = CONVERT(DECIMAL(10,2),CAST(FILEPROPERTY(d.name, ''SPACEUSED'') AS INT)/128.0)
		,[PercentUsed] = CAST((CAST(FILEPROPERTY(d.name, ''SPACEUSED'')/128.0 AS DECIMAL(10,2))/CAST(d.SIZE/128.0 AS DECIMAL(10,2)))*100 AS DECIMAL(10,2))
		,[FreeSpaceMB] = CONVERT(DECIMAL(10,2),d.SIZE/128.0 - CAST(FILEPROPERTY(d.name, ''SPACEUSED'') AS INT)/128.0)
		,[PercentFree] = CONVERT(DECIMAL(10,2),((d.SIZE/128.0 - CAST(FILEPROPERTY(d.name, ''SPACEUSED'') AS INT)/128.0)/(d.SIZE/128.0))*100)
		,[AutoGrowth] = ''By '' + CASE d.is_percent_growth 
								WHEN 0 THEN CAST(d.GROWTH/128 AS VARCHAR(10)) + '' MB -''
								WHEN 1 THEN CAST(d.GROWTH AS VARCHAR(10)) + ''% -'' ELSE '''' END 
							+ CASE d.max_size 
								WHEN 0 THEN ''DISABLED'' 
								WHEN -1 THEN '' Unrestricted'' 
								ELSE '' Restricted to '' + CAST(d.max_size/(128*1024) AS VARCHAR(10)) + '' GB'' END  
	FROM sys.database_files d 
	INNER JOIN sys.master_files f ON f.file_id = d.file_id  --join to sys.master_files to get physical_name because if the database is hosted by an AlwaysOn readable secondary replica, sys.database_files.physical_name indicates the file location of the primary replica database instead.
	WHERE f.database_id = DB_ID()
	OPTION (MAXDOP 2);'

	--run the generated T-SQL
	EXECUTE sp_executesql @sql

	INSERT INTO [metrics].[DatabaseFileMetrics]
			   ([DatabaseID]
			   ,[DatabaseName]
			   ,[FileID]
			   ,[FileName]
			   ,[FileType]
			   ,[FileLocation]
			   ,[CurrentState]
			   ,[isReadOnly]
			   ,[CurrentSizeMB]
			   ,[SpaceUsedMB]
			   ,[PercentUsed]
			   ,[FreeSpaceMB]
			   ,[PercentFree]
			   ,[AutoGrowth]
			   ,[CaptureDate])
	SELECT [DatabaseID]
		  ,[DatabaseName]
		  ,[FileID]
		  ,[FileName]
		  ,[FileType]
		  ,[FileLocation]
		  ,[CurrentState]
		  ,[isReadOnly]
		  ,[CurrentSizeMB]
		  ,[SpaceUsedMB]
		  ,[PercentUsed]
		  ,[FreeSpaceMB]
		  ,[PercentFree]
		  ,[AutoGrowth]
		  ,@CaptureDate
	  FROM #DBFileInfo

	DROP TABLE #DBFileInfo
END
GO
/****** Object:  StoredProcedure [metrics].[loadIndexMetrics]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [metrics].[loadIndexMetrics]
	@DBName sysname
	,@IndexTypes NVARCHAR(256) = 'ALL'
AS 

/**************************************************************************
	Author: Eric Cobb - http://www.sqlnuggets.com/
		License:
			MIT License
			Copyright (c) 2017 Eric Cobb
			View full license disclosure: https://github.com/ericcobb/SQL-Server-Metrics-Pack/blob/master/LICENSE
			
			Portions of this code (as noted in the comments) were adapted from 
			Ola Hallengren's SQL Server Maintenance Solution (https://ola.hallengren.com/), 
			and are provided under the MIT license, Copyright (c) 2017 Ola Hallengren.
	Purpose: 
			This stored procedure is used to collect Index metrics from multiple DMVs,
			this data is then persisted in the metrics.IndexMetrics table.
	Parameters:
			@DBName - Name of the Database you want to collect Index Metrics for.
			@IndexTypes - Type of indexes you want to collect Index Metrics for. 
						- Supported IndexTypes: ALL,HEAP,CLUSTERED,NONCLUSTERED,XML,SPATIAL,CLUSTERED_COLUMNSTORE,NONCLUSTERED_COLUMNSTORE
	Usage:	
			--Collect ALL index metrics for the MyDB database
			EXEC [metrics].[loadIndexMetrics] @DBName='MyDB';
			--Collect only CLUSTERED and NONCLUSTERED index metrics for the MyDB database
			--Mulitple IndexTypes can be can be combined with a comma (,)
			EXEC [metrics].[loadIndexMetrics] @DBName='MyDB', @IndexTypes=N'CLUSTERED,NONCLUSTERED';
			--Collect ALL index metrics except for HEAPs for the MyDB database
			--The hyphen character (-) can be used to exclude IndexTypes
			EXEC [metrics].[loadIndexMetrics] @DBName='MyDB', @IndexTypes=N'ALL,-HEAP';
	Knows Issues:
			@DBName currently only supports a single database, so the loadIndexMetrics procedure will have to be run individually for 
			each database that you want to gather Index Metrics for.  Future enhancements will allow for muliple databases.
***************************************************************************/

BEGIN
	SET NOCOUNT ON

	DECLARE @sql NVARCHAR(MAX)
	DECLARE @crlf NCHAR(2) = NCHAR(13)+NCHAR(10) 
	DECLARE @IndexTypeList TABLE ([IndexType] NVARCHAR(60), [Selected] BIT DEFAULT 0);

	INSERT INTO @IndexTypeList([IndexType]) VALUES(N'HEAP'),(N'CLUSTERED'),(N'NONCLUSTERED');

	/* 
	This section of code was adapted from Ola Hallengren's SQL Server Maintenance Solution (https://ola.hallengren.com/).
	If you are not using Ola's Solution, stop what you are doing and go get it!
	*/
	SET @IndexTypes = REPLACE(@IndexTypes, CHAR(10), '');
	SET @IndexTypes = REPLACE(@IndexTypes, CHAR(13), '');

	WHILE CHARINDEX(', ',@IndexTypes) > 0 SET @IndexTypes = REPLACE(@IndexTypes,', ',',');
	WHILE CHARINDEX(' ,',@IndexTypes) > 0 SET @IndexTypes = REPLACE(@IndexTypes,' ,',',');

	SET @IndexTypes = LTRIM(RTRIM(@IndexTypes));

	IF (CHARINDEX('ALL', @IndexTypes)) > 0
		UPDATE @IndexTypeList SET [Selected] = 1;

	WITH idx1 (StartPosition, EndPosition, IndexType) AS
		(SELECT 1 AS StartPosition,
				ISNULL(NULLIF(CHARINDEX(',', @IndexTypes, 1), 0), LEN(@IndexTypes) + 1) AS EndPosition,
				SUBSTRING(@IndexTypes, 1, ISNULL(NULLIF(CHARINDEX(',', @IndexTypes, 1), 0), LEN(@IndexTypes) + 1) - 1) AS IndexType
		WHERE @IndexTypes IS NOT NULL
		UNION ALL
		SELECT CAST(EndPosition AS int) + 1 AS StartPosition,
				ISNULL(NULLIF(CHARINDEX(',', @IndexTypes, EndPosition + 1), 0), LEN(@IndexTypes) + 1) AS EndPosition,
				SUBSTRING(@IndexTypes, EndPosition + 1, ISNULL(NULLIF(CHARINDEX(',', @IndexTypes, EndPosition + 1), 0), LEN(@IndexTypes) + 1) - EndPosition - 1) AS IndexType
		FROM idx1
		WHERE EndPosition < LEN(@IndexTypes) + 1
	),
		idx2 (IndexType, Selected) AS
		(SELECT CASE WHEN IndexType LIKE '-%' THEN RIGHT(IndexType,LEN(IndexType) - 1) ELSE IndexType END AS IndexType,
				CASE WHEN IndexType LIKE '-%' THEN 0 ELSE 1 END AS Selected
		FROM idx1
	)
	
	UPDATE itl
	SET itl.Selected = idx2.Selected
		,itl.IndexType = REPLACE(itl.IndexType,'_',' ')
	FROM @IndexTypeList AS itl
	INNER JOIN idx2 ON itl.IndexType = idx2.IndexType;
	/*
	End adaptation of Ola Hallengren's code.
	*/

	DELETE FROM @IndexTypeList WHERE Selected = 0;

	CREATE TABLE #IndexMetrics(
		[DatabaseID] [int]
		,[DatabaseName] [nvarchar](128) NULL
		,[SchemaName] [sysname] NOT NULL
		,[TableName] [nvarchar](128) NULL
		,[IndexName] [sysname] NULL
		,[IndexID] [int] NOT NULL
		,[IndexType] [nvarchar](60) NULL
		,[PartitionNumber] [int] NULL
		,[Rows] [bigint] NULL
		,[UserSeeks] [bigint] NULL
		,[UserScans] [bigint] NULL
		,[UserLookups] [bigint] NULL
		,[UserUpdates] [bigint] NULL
		,[IndexSizeMB] [decimal](18, 2) NULL
		,[IndexMetricsChecks] [int] NOT NULL
		,[LastUserSeek] [datetime] NULL
		,[LastUserScan] [datetime] NULL
		,[LastUserLookup] [datetime] NULL
		,[LastUserUpdate] [datetime] NULL
		,[SystemSeeks] [bigint] NULL
		,[SystemScans] [bigint] NULL
		,[SystemLookups] [bigint] NULL
		,[SystemUpdates] [bigint] NULL
		,[LastSystemSeek] [datetime] NULL
		,[LastSystemScan] [datetime] NULL
		,[LastSystemLookup] [datetime] NULL
		,[LastSystemUpdate] [datetime] NULL
		,[isUnique] [bit] NULL
		,[isUniqueConstraint] [bit] NULL
		,[isPrimaryKey] [bit] NULL
		,[isDisabled] [bit] NULL
		,[isHypothetical] [bit] NULL
		,[allowRowLocks] [bit] NULL
		,[allowPageLocks] [bit] NULL
		,[FillFactor] [tinyint] NOT NULL
		,[hasFilter] [bit] NULL
		,[Filter] [nvarchar](max) NULL
		,[DateLastChecked] [datetime] NOT NULL
		,[SQLServerStartTime] [datetime] NULL
		,[DropStatement] [nvarchar](1000) NULL
	)

	SET @sql = '
	USE '+ @DBName +' 
	
	DECLARE @sqlserver_start_time datetime, @date_last_checked datetime = GETDATE()
	SELECT @sqlserver_start_time = sqlserver_start_time from sys.dm_os_sys_info' + @crlf

	--Load the Index Metrics into our Temp table
	SET @sql = @sql +  'INSERT INTO #IndexMetrics([DatabaseID],[DatabaseName],[SchemaName],[TableName],[IndexName],[IndexID],[IndexType],[PartitionNumber],[Rows],[UserSeeks],[UserScans],[UserLookups],[UserUpdates],[IndexSizeMB],[IndexMetricsChecks],[LastUserSeek],[LastUserScan],[LastUserLookup],[LastUserUpdate],[SystemSeeks],[SystemScans],[SystemLookups],[SystemUpdates],[LastSystemSeek],[LastSystemScan],[LastSystemLookup],[LastSystemUpdate],[isUnique],[isUniqueConstraint],[isPrimaryKey],[isDisabled],[isHypothetical],[allowRowLocks],[allowPageLocks],[FillFactor],[hasFilter],[Filter],[DateLastChecked],[SQLServerStartTime],[DropStatement])
	SELECT  [DatabaseID] = DB_ID()
			,[DatabaseName] = DB_NAME()
			,[SchemaName] = s.name
			,[TableName] = OBJECT_NAME(i.OBJECT_ID)
			,[IndexName] = i.name
			,[IndexID] = i.index_id
			,[IndexType] = i.type_desc
			,[PartitionNumber] = ps.partition_number
			,[Rows] = p.TableRows
			,[UserSeeks] = COALESCE(ius.user_seeks,0)
			,[UserScans] = COALESCE(ius.user_scans,0)
			,[UserLookups] = COALESCE(ius.user_lookups,0)
			,[UserUpdates] = COALESCE(ius.user_updates,0)
			,[IndexSizeMB] = CASE WHEN ps.usedpages > ps.pages 
									THEN (ps.usedpages - ps.pages) 
									ELSE 0 
							END * 8 / 1024.0 
			,[IndexMetricsChecks] = 1
			,[LastUserSeek] = ius.last_user_seek
			,[LastUserScan] = ius.last_user_scan
			,[LastUserLookup] = ius.last_user_lookup
			,[LastUserUpdate] = ius.last_user_update
			,[SystemSeeks] = COALESCE(ius.system_seeks,0)
			,[SystemScans] = COALESCE(ius.system_scans,0)
			,[SystemLookups] = COALESCE(ius.system_lookups,0)
			,[SystemUpdates] = COALESCE(ius.system_updates,0)
			,[LastSystemSeek] = ius.last_system_seek
			,[LastSystemScan] = ius.last_system_scan
			,[LastSystemLookup] = ius.last_system_lookup
			,[LastSystemUpdate] = ius.last_system_update
			,[isUnique] = i.is_unique
			,[isUniqueConstraint] = i.is_unique_constraint
			,[isPrimaryKey] = i.is_primary_key
			,[isDisabled] = i.is_disabled
			,[isHypothetical] = i.is_hypothetical
			,[allowRowLocks] = i.allow_row_locks
			,[allowPageLocks] = i.allow_page_locks
			,[FillFactor] = i.fill_factor
			,[hasFilter] = i.has_filter
			,[Filter] = i.filter_definition
			,[DateLastChecked] = @date_last_checked
			,[SQLServerStartTime] = @sqlserver_start_time
			,[DropStatement] = CASE WHEN i.index_id >1 THEN ''DROP INDEX '' + QUOTENAME(i.name) + '' ON ['' +DB_NAME()+''].''+ QUOTENAME(s.name) + ''.'' + QUOTENAME(OBJECT_NAME(i.OBJECT_ID)) ELSE NULL END
	FROM sys.indexes i WITH (NOLOCK)
	LEFT JOIN sys.dm_db_index_usage_stats ius WITH (NOLOCK) ON ius.index_id = i.index_id AND ius.OBJECT_ID = i.OBJECT_ID
	INNER JOIN (SELECT sch.name, sch.schema_id, o.OBJECT_ID, o.create_date FROM sys.schemas sch  WITH (NOLOCK)
				INNER JOIN sys.objects o ON o.schema_id = sch.schema_id) s ON s.OBJECT_ID = i.OBJECT_ID
	LEFT JOIN (SELECT SUM(p.rows) TableRows, p.index_id, p.OBJECT_ID FROM sys.partitions p  WITH (NOLOCK)
				GROUP BY p.index_id, p.OBJECT_ID) p ON p.index_id = i.index_id AND i.OBJECT_ID = p.OBJECT_ID
	LEFT JOIN (SELECT OBJECT_ID, index_id, partition_number, SUM(used_page_count) AS usedpages,
						SUM(CASE WHEN (index_id < 2) 
								THEN (in_row_data_page_count + lob_used_page_count + row_overflow_used_page_count) 
								ELSE lob_used_page_count + row_overflow_used_page_count 
							END) AS pages
					FROM sys.dm_db_partition_stats WITH (NOLOCK)
					GROUP BY object_id, index_id, partition_number) AS ps ON i.object_id = ps.object_id AND i.index_id = ps.index_id
	WHERE OBJECTPROPERTY(i.OBJECT_ID,''IsUserTable'') = 1
	AND (ius.database_id = DB_ID() OR ius.database_id IS NULL)
	OPTION (MAXDOP 2)'

	--run the generated T-SQL
	EXECUTE sp_executesql @sql

	--Merge our temp data set into our existing table
	MERGE INTO metrics.IndexMetrics AS Target
			USING (select [DatabaseID]
						,[DatabaseName]
						,[SchemaName]
						,[TableName]
						,[IndexName]
						,[IndexID]
						,i.[IndexType]
						,[PartitionNumber]
						,[Rows]
						,[UserSeeks]
						,[UserScans]
						,[UserLookups]
						,[UserUpdates]
						,[IndexSizeMB]
						,[IndexMetricsChecks]
						,[LastUserSeek]
						,[LastUserScan]
						,[LastUserLookup]
						,[LastUserUpdate]
						,[SystemSeeks]
						,[SystemScans]
						,[SystemLookups]
						,[SystemUpdates]
						,[LastSystemSeek]
						,[LastSystemScan]
						,[LastSystemLookup]
						,[LastSystemUpdate]
						,[isUnique]
						,[isUniqueConstraint]
						,[isPrimaryKey]
						,[isDisabled]
						,[isHypothetical]
						,[allowRowLocks]
						,[allowPageLocks]
						,[FillFactor]
						,[hasFilter]
						,[Filter]
						,[DateLastChecked]
						,[SQLServerStartTime]
						,[DropStatement]
						--Generate hash to compare records with; have to use a SHA1 hash here so that we're compatible with SQL Server 2008
						,[Hash] = HASHBYTES('SHA1', CAST(i.[DatabaseID] AS NVARCHAR)
										+ i.[DatabaseName]
										+ CAST(i.[SchemaName] AS NVARCHAR(128))
										+ CAST(i.[TableName] AS NVARCHAR(128))
										+ CAST(COALESCE(i.[IndexName],'NA') AS NVARCHAR(128))
										+ CAST(i.[IndexID] AS NVARCHAR)
										+ CAST(i.[IndexType] AS NVARCHAR)
										+ CAST(i.[PartitionNumber] AS NVARCHAR))
				FROM #IndexMetrics i
				--Filter on the specified Index Types; It's faster to do it here than when loading the #IndexMetrics temp table 
				INNER JOIN @IndexTypeList itl ON itl.[IndexType] = i.[IndexType] 
			) AS Source ([DatabaseID],[DatabaseName],[SchemaName],[TableName],[IndexName],[IndexID],[IndexType],[PartitionNumber],[Rows],[UserSeeks],[UserScans],[UserLookups],[UserUpdates],[IndexSizeMB],[IndexMetricsChecks],[LastUserSeek],[LastUserScan],[LastUserLookup],[LastUserUpdate],[SystemSeeks],[SystemScans],[SystemLookups],[SystemUpdates],[LastSystemSeek],[LastSystemScan],[LastSystemLookup],[LastSystemUpdate],[isUnique],[isUniqueConstraint],[isPrimaryKey],[isDisabled],[isHypothetical],[allowRowLocks],[allowPageLocks],[FillFactor],[hasFilter],[Filter],[DateLastChecked],[SQLServerStartTime],[DropStatement],[Hash])
			ON ( Target.[Hash] = Source.[Hash] AND Target.SQLServerStartTime = Source.SQLServerStartTime)
			WHEN NOT MATCHED THEN 
				INSERT ([DatabaseID],[DatabaseName],[SchemaName],[TableName],[IndexName],[IndexID],[IndexType],[PartitionNumber],[Rows],[UserSeeks],[UserScans],[UserLookups],[UserUpdates],[IndexSizeMB],[IndexMetricsChecks],[LastUserSeek],[LastUserScan],[LastUserLookup],[LastUserUpdate],[SystemSeeks],[SystemScans],[SystemLookups],[SystemUpdates],[LastSystemSeek],[LastSystemScan],[LastSystemLookup],[LastSystemUpdate],[isUnique],[isUniqueConstraint],[isPrimaryKey],[isDisabled],[isHypothetical],[allowRowLocks],[allowPageLocks],[FillFactor],[hasFilter],[Filter],[DateLastChecked],[SQLServerStartTime],[DropStatement],[Hash])
				VALUES ([DatabaseID],[DatabaseName],[SchemaName],[TableName],[IndexName],[IndexID],[IndexType],[PartitionNumber],[Rows],[UserSeeks],[UserScans],[UserLookups],[UserUpdates],[IndexSizeMB],[IndexMetricsChecks],[LastUserSeek],[LastUserScan],[LastUserLookup],[LastUserUpdate],[SystemSeeks],[SystemScans],[SystemLookups],[SystemUpdates],[LastSystemSeek],[LastSystemScan],[LastSystemLookup],[LastSystemUpdate],[isUnique],[isUniqueConstraint],[isPrimaryKey],[isDisabled],[isHypothetical],[allowRowLocks],[allowPageLocks],[FillFactor],[hasFilter],[Filter],[DateLastChecked],[SQLServerStartTime],[DropStatement],[Hash])
			WHEN MATCHED THEN 
				UPDATE SET
						target.[Rows] = source.[Rows]
						,target.[UserSeeks] = source.[UserSeeks]
						,target.[UserScans] = source.[UserScans]
						,target.[UserLookups] = source.[UserLookups]
						,target.[UserUpdates] = source.[UserUpdates]
						,target.[IndexSizeMB] = source.[IndexSizeMB]
						,target.[IndexMetricsChecks] = target.IndexMetricsChecks + 1
						,target.[LastUserSeek] = source.[LastUserSeek]
						,target.[LastUserScan] = source.[LastUserScan]
						,target.[LastUserLookup] = source.[LastUserLookup]
						,target.[LastUserUpdate] = source.[LastUserUpdate]
						,target.[SystemSeeks] = source.[SystemSeeks]
						,target.[SystemScans] = source.[SystemScans]
						,target.[SystemLookups] = source.[SystemLookups]
						,target.[SystemUpdates] = source.[SystemUpdates]
						,target.[LastSystemSeek] = source.[LastSystemSeek]
						,target.[LastSystemScan] = source.[LastSystemScan]
						,target.[LastSystemLookup] = source.[LastSystemLookup]
						,target.[LastSystemUpdate] = source.[LastSystemUpdate]
						,target.[isUnique] = source.[isUnique]
						,target.[isUniqueConstraint] = source.[isUniqueConstraint]
						,target.[isPrimaryKey] = source.[isPrimaryKey]
						,target.[isDisabled] = source.[isDisabled]
						,target.[isHypothetical] = source.[isHypothetical]
						,target.[allowRowLocks] = source.[allowRowLocks]
						,target.[allowPageLocks] = source.[allowPageLocks]
						,target.[FillFactor] = source.[FillFactor]
						,target.[hasFilter] = source.[hasFilter]
						,target.[Filter] = source.[Filter]
						,target.[DateLastChecked] = source.[DateLastChecked]
		;

	DROP TABLE #IndexMetrics;

END
GO
/****** Object:  StoredProcedure [perms].[applyPermissions]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [perms].[applyPermissions]
	@DBName NVARCHAR(128),
	@SnapshotID INT = NULL,
	@User NVARCHAR(256) = NULL,
	@CreateLogins BIT = 1,
	@ExecuteScript BIT = 0,	
	@CopySID BIT = 1, --Copies the SID of a SQL user
	@DestinationDatabase  NVARCHAR(128) = NULL,
	@AltUserNames XML = NULL
AS

/**************************************************************************
	Author: Eric Cobb - http://www.sqlnuggets.com/
		License:
			MIT License
			Copyright (c) 2017 Eric Cobb
			View full license disclosure: https://github.com/ericcobb/SQL-Server-Permissions-Manager/blob/master/LICENSE
			
	Purpose: 
			This stored procedure is used to apply a Permissions Snapshot to a specified database; 
			If a Snapshot ID is specified, it will restore that Snapshot, 
			otherwise it defaults to the most recent Snapshot for the specified database;
	Parameters:
			@DBName - REQUIRED - Name of the Database you want to apply a Permissions Snapshot to.
			@SnapshotID - OPTIONAL - ID of the specific Snapshot you want to apply.
			@User - OPTIONAL - User Name of a specific user you want permissions applied for.
			@CreateLogins - OPTIONAL - Flag for whether or not to generate the CREATE LOGIN scripts for the user(s) listed in the Permissions Snapshot.
			@ExecuteScript - OPTIONAL -	Flag for whether or not to actually apply the Permissions Snapshot.
										If 1: Automatically apply the permissions to the databse.
										If 0: Generates the permissions script to be reviewed/run manually.
			@CopySID - OPTIONAL - Generates the SID of a SQL user as part of the script
			@DestinationDatabase - OPTIONAL - Database to apply Permissions Snapshot to; defaults to the specified @DBName.
			@AltUserNames - OPTIONAL - Used for cloning a specified user's permissions to a new user. (see [perms].[clonePermissions] procedure)
				VALUE FOR @AltUserNames = 
				<altusers>
					<user>
						<original>OriginalUser</original>	-- REQUIRED. original UserName, as found in the perms.Users table
						<new>NewUser</new>			-- REQUIRED. new UserName. should include domain name if appropriate - e.g. HCA\ibm8561
						<DefaultSchema>dbo</DefaultSchema>	-- OPTIONAL. default schema
						<LoginName></LoginName>		-- OPTIONAL. login name. Defaults to new UserName
						<LoginType></LoginType>	-- OPTIONAL, defaults to U. S = SQL User, U = Windows User, G = Windows Group
					</user>
				</altusers>
	Usage:	
			--Apply the most recent Permissions Snapshot to the MyDB database.
			EXEC [perms].[applyPermissions] @DBName='MyDB';
***************************************************************************/

BEGIN
	SET NOCOUNT ON;

	DECLARE @SQLSTMT NVARCHAR(4000);
	DECLARE @SQLSTMT2 NVARCHAR(4000);
	DECLARE @VSnapshotID INT = NULL;

	DECLARE @CRLF NCHAR(2) = NCHAR(13) + NCHAR(10);

	-- Create Temp Table
	CREATE TABLE #SQLResults
	(
		ID		INT IDENTITY(1,1) NOT NULL,
		STMT	NVARCHAR(1000)	NOT NULL
	)

	-- Determine Correct Snapshot ID
	IF @SnapshotID IS NULL
		SELECT TOP 1 @VSnapshotID = [ID] FROM [perms].[Snapshots] WHERE [DatabaseName] = @DBName ORDER BY [CaptureDate] DESC;
	ELSE
		SELECT TOP 1 @VSnapshotID = [ID] FROM [perms].[Snapshots] WHERE [DatabaseName] = @DBName AND [ID] = @SnapshotID; --ORDER BY [CaptureDate] DESC

	IF @VSnapshotID IS NULL -- STILL???
	BEGIN
		RAISERROR(N'No Valid Snapshot Available',16,1);
		RETURN;
	END

	IF @DestinationDatabase IS NULL
		SET @DestinationDatabase = @DBName;

	-- Setup Alternate UserNames Capability
	CREATE TABLE #AltUsers (
		OriginalUser NVARCHAR(256) NOT NULL,
		NewUser NVARCHAR(256) NOT NULL,
		DefaultSchema NVARCHAR(128) NULL,
		LoginName NVARCHAR(128) NULL,
		LoginType CHAR(1) NULL DEFAULT 'U'
	);

	IF @AltUserNames IS NOT NULL
	BEGIN
		INSERT INTO #AltUsers (OriginalUser, NewUser, DefaultSchema, LoginName, LoginType)
		SELECT Tbl.Col.value('original[1]', 'sysname'),
			Tbl.Col.value('new[1]','sysname'),
			Tbl.Col.value('DefaultSchema[1]','sysname'),
			Tbl.Col.value('LoginName[1]','sysname'),
			Tbl.Col.value('LoginType[1]','char(1)')
		FROM @AltUserNames.nodes('/altusers/user') Tbl(Col);
	END;

	INSERT INTO #AltUsers (OriginalUser, NewUser, DefaultSchema, LoginName, LoginType)
	SELECT UserName, UserName, DefaultSchema, LoginName, LoginType
	FROM perms.Users
	WHERE UserName NOT IN (SELECT OriginalUser FROM #AltUsers)
		AND SnapshotID = @VSnapshotID

	UPDATE #AltUsers
	SET #AltUsers.DefaultSchema = u.DefaultSchema
	FROM #AltUsers
	JOIN perms.Users u ON #AltUsers.OriginalUser = u.UserName
	WHERE #AltUsers.DefaultSchema IS NULL

	UPDATE #AltUsers
	SET LoginName = NewUser
	WHERE LoginName IS NULL

	UPDATE #AltUsers
	SET LoginType = 'U'
	WHERE LoginType IS Null

	INSERT INTO #SQLResults (STMT)
	SELECT '-- Database: ' + @DBName
	INSERT INTO #SQLResults (STMT)
	SELECT '-- Snapshot ID: ' + CAST(@VsnapshotID AS varchar(10))

	INSERT INTO #SQLResults(STMT) VALUES ('')

	INSERT INTO #SQLResults(STMT) VALUES ('USE [' + @DestinationDatabase + '];')

	INSERT INTO #SQLResults(STMT) VALUES ('')


	-- ### LOGINS ###
	INSERT INTO #SQLResults(STMT) VALUES ('-- ### LOGINS ###')

	-- U, S, G
	IF @CreateLogins = 1
	BEGIN
		INSERT INTO #SQLResults (STMT)
		SELECT 'IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = N''' + u.LoginName + ''') '
			+ 'BEGIN '
			+ 'CREATE LOGIN ' + QUOTENAME(u.LoginName)
			+ CASE
				WHEN u.LoginType = 'U' THEN ' FROM WINDOWS '
				WHEN u.LoginType = 'G' THEN ' FROM WINDOWS '
				ELSE ' WITH PASSWORD = ' + CONVERT(VARCHAR(MAX), p.[PasswordHash], 1) + ' HASHED'
			  END
			+ CASE 
				WHEN @CopySID = 1 AND u.LoginType = 'S' THEN ', SID=' + CONVERT(varchar(max), p.SID, 1)-- ALTER LOGIN ' + QUOTENAME(LoginName) + ' DISABLE '
				ELSE ''
			  END
			+ ' END'
		FROM #AltUsers u
		INNER JOIN [perms].[Users] p ON p.LoginName = u.OriginalUser
		WHERE (@User IS NULL OR u.OriginalUser = @User)
		AND p.SnapshotID = @VSnapshotID;

		INSERT INTO #SQLResults (STMT)
		SELECT 'ALTER LOGIN ' + QUOTENAME(LoginName) + ' DISABLE'
		FROM [perms].[Users] u
		WHERE u.SnapshotID = @VSnapshotID
			AND (u.isDisabled = 1)
			AND (@User IS NULL OR u.UserName = @User);

	END;

	INSERT INTO #SQLResults(STMT) VALUES ('')

	-- ### REPAIR EXISTING USERS ###
	INSERT INTO #SQLResults(STMT) VALUES ('-- ### REPAIR USERS ###')

	INSERT INTO #SQLResults (STMT)
	SELECT 'IF EXISTS (SELECT * FROM sys.database_principals dp '
		+ 'LEFT JOIN sys.server_principals sp ON dp.sid = sp.sid '
		+ 'WHERE dp.type = ''S'' '
		+ 'AND sp.sid IS NULL '
		+ 'AND dp.name = N' + QUOTENAME(NewUser,'''') + ') '
		+ 'EXEC sp_change_users_login ''Auto_Fix'', ' + QUOTENAME(NewUser,'''') + ';'
	FROM #AltUsers u
	WHERE (@User IS NULL OR u.OriginalUser = @User)
		AND u.LoginType = 'S';

	INSERT INTO #SQLResults(STMT) VALUES ('')

	-- ### USERS ###
	INSERT INTO #SQLResults(STMT) VALUES ('-- ### USERS ###')

	INSERT INTO #SQLResults (STMT)
	SELECT 'IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N' + QUOTENAME(NewUser,'''') + ') '
		+ 'CREATE USER ' + QUOTENAME(NewUser) + ' FOR LOGIN ' + QUOTENAME(LoginName)
		+ CASE
			WHEN DefaultSchema IS NOT NULL THEN	' WITH DEFAULT_SCHEMA=' + QUOTENAME(DefaultSchema)
			ELSE ''
		  END
		+ ';'
	FROM #AltUsers u
	WHERE (@User IS NULL OR u.OriginalUser = @User);

	INSERT INTO #SQLResults(STMT) VALUES ('')

	-- ### ROLES ###
	/* First things first, we need to put the roles into #AltUsers so that when
	we do the actual permissions, they are there */
	INSERT INTO #AltUsers (OriginalUser, NewUser)
	SELECT RoleName, RoleName
	FROM perms.Roles
	WHERE SnapshotID = @VSnapshotID

	-- First, do Database Roles
	INSERT INTO #SQLResults(STMT) VALUES ('-- ### ROLES ###')
	INSERT INTO #SQLResults (STMT)
	SELECT 'IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N' + QUOTENAME(RoleName,'''') + ' AND type = ''R'') '
		+ 'CREATE ROLE ' + QUOTENAME(RoleName) + ' AUTHORIZATION [dbo]'
	FROM [perms].[Roles] r
	WHERE r.SnapshotID = @VSnapshotID
		AND r.RoleType = 'R'
		AND (@User IS NULL OR r.RoleName = @User);

	-- Then, do Application Roles.  Note, doesn't transfer password
	INSERT INTO #SQLResults (STMT)
	SELECT 'IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N''' + QUOTENAME(RoleName) + ''' AND type = ''A'') '
		+ 'CREATE APPLICATION ROLE ' + QUOTENAME(RoleName) + ' WITH PASSWORD = ''Healthtrust123'' '
		+ CASE 
			WHEN DefaultSchema IS NOT NULL THEN	', DEFAULT_SCHEMA=' + QUOTENAME(DefaultSchema)
			ELSE ''
		  END
	FROM [perms].[Roles] r
	WHERE r.SnapshotID = @VSnapshotID
		AND r.RoleType = 'A'
		AND (@User IS NULL);


	INSERT INTO #SQLResults(STMT) VALUES ('')

	-- ### ROLE ASSIGNMENTS ###
	INSERT INTO #SQLResults(STMT) VALUES ('-- ### ROLE ASSIGNMENTS ###')
	INSERT INTO #SQLResults (STMT)
	SELECT 'IF IS_ROLEMEMBER(' + QUOTENAME(RoleName,'''') + ',' + QUOTENAME(au.NewUser,'''') + ') = 0 '
		+ 'EXEC sp_addrolemember @RoleName = ' + QUOTENAME(RoleName,'''') + ', @membername = ' + QUOTENAME(au.NewUser,'''')
	FROM [perms].[RoleMemberships] rm
	JOIN #AltUsers au ON rm.UserName = au.OriginalUser
	WHERE rm.SnapshotID = @VSnapshotID
		AND (@User IS NULL OR rm.UserName = @User);

	INSERT INTO #SQLResults(STMT) VALUES ('')


	-- ### OBJECT PERMISSIONS ###
	INSERT INTO #SQLResults(STMT) VALUES ('-- ### OBJECT PERMISSIONS ###')
	INSERT INTO #SQLResults (STMT)
	SELECT 'IF NOT EXISTS (SELECT * FROM sys.database_permissions '
		+ 'WHERE class_desc = ''OBJECT_OR_COLUMN'' '
		+ 'AND grantee_principal_id = DATABASE_PRINCIPAL_ID(' + QUOTENAME(au.NewUser,'''') + ') '
		+ 'AND Permission_Name = ' + QUOTENAME(PermissionName,'''')
		+ ' AND State_Desc = ' + QUOTENAME(StateDesc,'''')
		+ ' AND major_id = OBJECT_ID(N' + QUOTENAME(ObjectName,'''') + ') '
		+ CASE
			WHEN ColumNname IS NULL THEN SPACE(0)
			ELSE 'AND minor_id = columnproperty(object_id(N''' + SchemaName + '.' + ObjectName + '''),N''' + ColumNname + ''', ''columnid'') '
		  END
		+ ') '
		+ CASE
			WHEN [State]<> 'W' THEN StateDesc + SPACE(1)
			ELSE 'GRANT '
		  END
		+ PermissionName 
		+ ' ON ' + QUOTENAME(SchemaName) + '.' + QUOTENAME(ObjectName)
		+  CASE
			WHEN ColumNname IS NULL THEN SPACE(1)
			ELSE ' (' + QUOTENAME(ColumNname) + ')'
		   END
		+ 'TO ' + QUOTENAME(au.NewUser)
		+ CASE
			WHEN [State]<> 'W' THEN SPACE(0)
			ELSE ' WITH GRANT OPTION'
		  END
	FROM [perms].[ObjectPermissions] op
		JOIN #AltUsers au ON op.UserName = au.OriginalUser
	WHERE op.SnapshotID = @VSnapshotID
		AND (@User IS NULL OR op.UserName = @User);

	INSERT INTO #SQLResults(STMT) VALUES ('')

	-- ### SCHEMA PERMISSIONS ###
	INSERT INTO #SQLResults(STMT) VALUES ('-- ### SCHEMA PERMISSIONS ###')
	INSERT INTO #SQLResults (STMT)
	SELECT 'IF NOT EXISTS (SELECT * FROM sys.database_permissions '
		+ 'WHERE class_desc = ''SCHEMA'' '
		+ 'AND grantee_principal_id = DATABASE_PRINCIPAL_ID(' + QUOTENAME(au.NewUser,'''') + ') '
		+ 'AND Permission_Name = ' + QUOTENAME(PermissionName,'''')
		+ ' AND State_Desc = ' + QUOTENAME(StateDesc,'''')
		+ ' AND major_id = SCHEMA_ID(N' + QUOTENAME(SchemaName,'''') + ')) '
		+ CASE
			WHEN [State]<> 'W' THEN StateDesc + SPACE(1)
			ELSE 'GRANT '
		  END
		+ PermissionName 
		+ ' ON SCHEMA :: ' + SchemaName
		+ ' TO ' + QUOTENAME(au.NewUser)
		+ CASE
			WHEN [State]<> 'W' THEN ';'
			ELSE ' WITH GRANT OPTION;'
		  END
	FROM [perms].[SchemaPermissions] sp
		JOIN #AltUsers au ON sp.UserName = au.OriginalUser
	WHERE sp.SnapshotID = @VSnapshotID
		AND (@User IS NULL OR sp.UserName = @User);

	INSERT INTO #SQLResults(STMT) VALUES ('')

	-- ### DATABASE PERMISSIONS ###
	INSERT INTO #SQLResults(STMT) VALUES ('-- ### DATABASE PERMISSIONS ###')
	INSERT INTO #SQLResults (STMT)
	SELECT 'IF NOT EXISTS (SELECT * FROM sys.database_permissions '
		+ 'WHERE class_desc = ''DATABASE'' '
		+ 'AND grantee_principal_id = DATABASE_PRINCIPAL_ID(' + QUOTENAME(au.NewUser,'''') + ') '
		+ 'AND Permission_Name = ' + QUOTENAME(PermissionName,'''')
		+ ' AND State_Desc = ' + QUOTENAME(StateDesc,'''')
		+ ' AND major_id = 0) '
		+ CASE
			WHEN [State]<> 'W' THEN StateDesc + SPACE(1)
			ELSE 'GRANT '
		  END
		+ PermissionName 
		+ ' TO ' + QUOTENAME(au.NewUser)
		+ CASE
			WHEN [State]<> 'W' THEN ';'
			ELSE ' WITH GRANT OPTION;'
		  END
	FROM [perms].[DatabasePermissions] dp
		JOIN #AltUsers au ON dp.UserName = au.OriginalUser
	WHERE dp.SnapshotID = @VSnapshotID
		AND (@User IS NULL OR dp.UserName = @User);

	--If @executeScript = 0, return the statements.
	IF @ExecuteScript = 0
	BEGIN
		SELECT 
			CAST((STUFF
			(
				(
					SELECT @CRLF + STMT
					FROM #SQLResults
					ORDER BY ID
					FOR XML PATH(''), TYPE
				).value('.[1]','NVARCHAR(MAX)'), 1, 2, '')
			) AS XML) AS sqlSTMT

	END
	ELSE
	BEGIN
		DECLARE @sqlSTMT_prep NVARCHAR(4000)
		DECLARE sql_cursor CURSOR LOCAL FAST_FORWARD FOR
		SELECT STMT FROM #SQLResults 
		WHERE STMT <> '' AND STMT NOT LIKE 'USE %' AND STMT NOT LIKE '--%'
		ORDER BY ID
	
		OPEN sql_cursor
		FETCH NEXT FROM sql_cursor INTO @sqlSTMT
	
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT @sqlSTMT_prep = 'USE [' + @DestinationDatabase + ']; ';
			SELECT @sqlSTMT_prep = @sqlSTMT_prep + @sqlSTMT;
			exec sp_ExecuteSQL @sqlSTMT_prep;
			--SELECT @sqlSTMT_prep;
		
			FETCH NEXT FROM sql_cursor INTO @sqlSTMT
		END
	
		CLOSE sql_cursor
		DEALLOCATE sql_cursor
	END

	DROP TABLE #SQLResults;
	DROP TABLE #AltUsers;

END

GO
/****** Object:  StoredProcedure [perms].[clonePermissions]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [perms].[clonePermissions]
	@UserName NVARCHAR(256)
	,@NewUser NVARCHAR(256)
	,@logintype CHAR(1) = 'U'
	,@CopySID BIT = 0
	,@CreateLogins BIT = 1
	,@ExecuteScript BIT = 0
		
AS 

/**************************************************************************
	Author: Eric Cobb - http://www.sqlnuggets.com/
		License:
			MIT License
			Copyright (c) 2017 Eric Cobb
			View full license disclosure: https://github.com/ericcobb/SQL-Server-Permissions-Manager/blob/master/LICENSE
			
	Purpose: 
			This stored procedure is used to copy all of the permissions from a given user and assign those permissions to another user.
			It will do this for every database on a server, so if a user has permissions on 3 databases, the new user and permissions will be added to those 3 databases.
	Parameters:
			@UserName - REQUIRED - the user we want to clone
			@NewUser - REQUIRED - the user name of the new user we want to create
			@logintype - OPTIONAL - defaults to U. S = SQL User, U = Windows User, G = Windows Group	
			@CopySID - OPTIONAL - Copies the SID of a SQL user
			@CreateLogins - OPTIONAL - Flag for whether or not to generate the CREATE LOGIN scripts for the user(s) listed in the Permissions Snapshot.
			@ExecuteScript - OPTIONAL -	Flag for whether or not to actually apply the Permissions Snapshot.
										If 1: Automatically apply the permissions to the databse.
										If 0 (Default): Generates the permissions script to be reviewed/run manually.
	Usage:	
			--Generate a script to create User2 with all of the permissions that User1 has, but do not automatically run the generated script;
			EXEC [perms].[clonePermissions] @UserName = 'user1', @NewUser = 'user2', @CreateLogins = 1, @ExecuteScript = 0
***************************************************************************/

BEGIN
	SET NOCOUNT ON;

	DECLARE @sql NVARCHAR(4000)
			,@db NVARCHAR(128)
	-- List the DBs this user has access to, based on the most recent Snapshots
	SELECT DISTINCT
			[ID] = s1.ID,
			[DB] = databasename,
			[CaptureDate]
	INTO    #CurrentSnaps
	FROM    perms.Snapshots s1
			INNER JOIN perms.RoleMemberships rm ON rm.SnapshotID = s1.ID
			INNER JOIN sys.databases db ON db.name = s1.databasename and state_desc = 'ONLINE'--only return active, online databases
	WHERE   rm.username = @UserName
			AND CaptureDate IN ( SELECT    MAX(CaptureDate)
							  FROM      perms.Snapshots s2
							  WHERE     s2.databasename = s1.databasename )
	ORDER BY [DB];

	--SELECT * FROM #CurrentSnaps

	--IF there are databases found, we need to add the new user to them
	IF (SELECT COUNT(*) FROM #CurrentSnaps) > 0
	BEGIN
		--Create an XML string to pass to the permissions proc; this tells it what user we want to clone the new user as.
		DECLARE @AltUsernames XML = '<altusers><user><original>'+@UserName+'</original><new>'+@NewUser+'</new><logintype>'+@logintype+'</logintype></user></altusers>'

		--In case our user has permission on more than 1 database, we're going to loop through the list to make sure we get them all.
		DECLARE cur CURSOR LOCAL FAST_FORWARD FOR SELECT DB FROM #CurrentSnaps
		OPEN cur

		FETCH NEXT FROM cur INTO @db

		WHILE @@FETCH_STATUS = 0 
		BEGIN
			-- 1) Write our SQL string that calls the PROC that actually applies the permissions.
			SET @SQL = '
			EXEC [perms].[applyPermissions]
				@DBName = ['+@db+'],
				@User = ['+@UserName+'],
				@CreateLogins = '+CAST(@CreateLogins AS CHAR(1))+',
				@ExecuteScript = '+CAST(@ExecuteScript AS CHAR(1))+',
				@CopySID = '+CAST(@CopySID AS CHAR(1))+',
				@AltUsernames = '''+CAST(@AltUsernames AS NVARCHAR(500))+'''
			'
			--make sure the DB is there, we've had cases where dabases got snapshotted, but were later deleted. 
			IF DB_ID(@db) IS NOT NULL
			BEGIN
				-- 2) now run the command to call the PROC listed above
				EXEC sp_executesql @SQL	
			END

			FETCH NEXT FROM cur INTO @db
		END
		CLOSE cur    
		DEALLOCATE cur

	END

	DROP TABLE #CurrentSnaps

END

GO
/****** Object:  StoredProcedure [perms].[createDatabaseSnapshot]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [perms].[createDatabaseSnapshot]
(
	@DBName	NVARCHAR(128)
)
AS

/**************************************************************************
	Author: Eric Cobb - http://www.sqlnuggets.com/
		License:
			MIT License
			Copyright (c) 2017 Eric Cobb
			View full license disclosure: https://github.com/ericcobb/SQL-Server-Permissions-Manager/blob/master/LICENSE
			
	Purpose: 
			This stored procedure is used to create a snapshot of the current permissions in a given database
	Parameters:
			@DBName - REQUIRED - Name of the Database you want to create a Permissions Snapshot for.
	Usage:	
			--Take a Permissions Snapshot for the MyDB database
			EXEC [perms].[createDatabaseSnapshot] @DBName='MyDB';
***************************************************************************/

BEGIN
	SET NOCOUNT ON;
	
	DECLARE @SnapshotID BIGINT;
	DECLARE @CRLF NCHAR(2) = NCHAR(13)+NCHAR(10);

	INSERT INTO [perms].[Snapshots] (DatabaseName) VALUES (@DBName);
	SELECT @SnapshotID = SCOPE_IDENTITY();

	DECLARE @SQLStmt NVARCHAR(MAX);
	SELECT @SQLStmt = N'USE ' + QUOTENAME(@DBName) +';
	' + @CRLF

	/* 
		##-Users-##
	*/
	CREATE TABLE #Users(
		[UserName] [nvarchar](128) NOT NULL,
		[UserType] [char](1) NOT NULL,
		[UserTypeDesc] [nvarchar](60) NOT NULL,
		[DefaultSchema] [nvarchar](128) NULL,
		[LoginName] [nvarchar](128) NOT NULL,
		[LoginType] [char](1) NOT NULL,
		[isDisabled] [bit] NOT NULL,
		[SID] [varbinary](85) NULL,
		[PasswordHash] [varbinary](256) NULL
	);

	SELECT @SQLStmt = @SQLStmt + N'
	INSERT INTO #Users([UserName], [UserType], [UserTypeDesc], [DefaultSchema], [LoginName], [LoginType], [isDisabled], [SID], [PasswordHash])
	SELECT dp.name
		,dp.type
		,dp.type_desc
		,dp.default_schema_name
		,sp.name
		,sp.type
		,sp.is_disabled
		,sp.sid
		,l.password_hash
	FROM sys.database_principals dp
	JOIN sys.server_principals sp on dp.sid = sp.sid
	LEFT JOIN sys.sql_logins l on l.principal_id = sp.principal_id 
	WHERE dp.type_desc IN (''WINDOWS_GROUP'',''WINDOWS_USER'',''SQL_USER'')
	AND dp.name NOT IN (''dbo'',''guest'',''INFORMATION_SCHEMA'',''sys'');
	' + @CRLF
	

	/* 
		##-Database Roles-##
	*/
	CREATE TABLE #Roles(
		[RoleName] [nvarchar](128) NOT NULL,
		[RoleType] [char](1) NOT NULL,
		[RoleTypeDesc] [nvarchar](60) NOT NULL,
		[DefaultSchema] [nvarchar](128) NULL
	);

	SELECT @SQLStmt = @SQLStmt + N'
	INSERT INTO #Roles ([RoleName], [RoleType], [RoleTypeDesc], [DefaultSchema])
	SELECT name
		,type
		,type_desc
		,default_schema_name
	FROM sys.database_principals
	WHERE type_desc IN (''DATABASE_ROLE'',''APPLICATION_ROLE'')
	AND is_fixed_role = 0
	AND principal_id <> 0;
	' + @CRLF


	/* 
		##-Role Memberships-##
	*/
	CREATE TABLE #RoleMemberships(
		[RoleName] [nvarchar](256) NOT NULL,
		[UserName] [nvarchar](256) NOT NULL
	);
	SELECT @SQLStmt = @SQLStmt + N'
	INSERT INTO #RoleMemberships([RoleName], [UserName])
	SELECT USER_NAME(role_principal_id)
		,USER_NAME(member_principal_id)
	FROM sys.database_role_members;
	' + @CRLF


	/* 
		##-Object permissions - GRANT, DENY, REVOKE statements-##
	*/
	CREATE TABLE #ObjectPermissions(
		[State] [char](1) NOT NULL,
		[StateDesc] [nvarchar](60) NOT NULL,
		[PermissionName] [nvarchar](128) NOT NULL,
		[SchemaName] [nvarchar](128) NOT NULL,
		[ObjectName] [nvarchar](128) NOT NULL,
		[UserName] [nvarchar](256) NOT NULL,
		[ClassDesc] [nvarchar](60) NOT NULL,
		[ColumnName] [nvarchar](128) NULL
	);
	SELECT @SQLStmt = @SQLStmt + N'
	INSERT INTO #ObjectPermissions ([State], [StateDesc], [PermissionName], [SchemaName], [ObjectName], [UserName], [ClassDesc], [ColumnName])
	SELECT perm.state -- D (DENY), R (REVOKE), G (GRANT), W (GRANT_WITH_GRANT_OPTION)
		,perm.state_desc -- actual state command for D, R, G, W
		,perm.permission_name
		,SCHEMA_NAME(obj.schema_id)
		,obj.name
		,USER_NAME(perm.grantee_principal_id)
		,perm.class_desc
		,cl.name
	FROM sys.database_permissions AS perm
	INNER JOIN sys.objects AS obj ON perm.major_id = obj.[object_id]
	LEFT JOIN sys.columns AS cl ON cl.column_id = perm.minor_id AND cl.[object_id] = perm.major_id
	WHERE perm.class_desc = ''OBJECT_OR_COLUMN'';
	' + @CRLF


	/* 
		##-Schema assignments - GRANT, DENY, REVOKE statements-##
	*/

	CREATE TABLE #SchemaPermissions(
		[State] [char](1) NOT NULL,
		[StateDesc] [nvarchar](60) NOT NULL,
		[PermissionName] [nvarchar](128) NOT NULL,
		[SchemaName] [nvarchar](128) NOT NULL,
		[UserName] [nvarchar](256) NOT NULL
	);
	SELECT @SQLStmt = @SQLStmt + N'
	INSERT INTO #SchemaPermissions ([State], [StateDesc], [PermissionName], [SchemaName], [UserName])
	SELECT perm.state
		,perm.state_desc
		,perm.permission_name
		,SCHEMA_NAME(major_id)
		,USER_NAME(grantee_principal_id)
	FROM sys.database_permissions perm
	WHERE class_desc = ''SCHEMA'';
	' + @CRLF


	/* 
		##-Database permissions - GRANT, DENY, REVOKE-##
	*/

	CREATE TABLE #DatabasePermissions(
		[State] [char](1) NOT NULL,
		[StateDesc] [nvarchar](60) NOT NULL,
		[PermissionName] [nvarchar](128) NOT NULL,
		[UserName] [nvarchar](256) NOT NULL
	);

	SELECT @SQLStmt = @SQLStmt + N'
	INSERT INTO #DatabasePermissions ([State], [StateDesc], [PermissionName], [UserName])
	SELECT perm.state -- D (DENY), R (REVOKE), G (GRANT), W (GRANT_WITH_GRANT_OPTION)
		,perm.state_desc -- actual state command for D, R, G; GRANT_WITH_GRANT_OPTION for W
		,perm.permission_name
		,USER_NAME(perm.grantee_principal_id)
	FROM sys.database_permissions AS perm
	WHERE class_desc = ''DATABASE'';
	' + @CRLF

	--PRINT @SQLStmt
	EXECUTE sp_executesql @SQLStmt

	
	/* 
		##-Load Database permissions into real tables-##
	*/

	INSERT INTO [perms].[Users]([SnapshotID], [UserName], [UserType], [UserTypeDesc], [DefaultSchema], [LoginName], [LoginType], [isDisabled], [SID], [PasswordHash])
	SELECT @SnapshotID, [UserName], [UserType], [UserTypeDesc], [DefaultSchema], [LoginName], [LoginType], [isDisabled], [SID], [PasswordHash] FROM #Users;
	
	INSERT INTO [perms].[Roles] ([SnapshotID], [RoleName], [RoleType], [RoleTypeDesc], [DefaultSchema])
	SELECT @SnapshotID, [RoleName], [RoleType], [RoleTypeDesc], [DefaultSchema] FROM #Roles;

	INSERT INTO [perms].[RoleMemberships]([SnapshotID], [RoleName], [UserName])
	SELECT @SnapshotID, [RoleName], [UserName] FROM #RoleMemberships;

	INSERT INTO [perms].[ObjectPermissions] ([SnapshotID], [State], [StateDesc], [PermissionName], [SchemaName], [ObjectName], [UserName], [ClassDesc], [ColumnName])
	SELECT @SnapshotID, [State], [StateDesc], [PermissionName], [SchemaName], [ObjectName], [UserName], [ClassDesc], [ColumnName] FROM #ObjectPermissions;

	INSERT INTO [perms].[SchemaPermissions] ([SnapshotID], [State], [StateDesc], [PermissionName], [SchemaName], [UserName])
	SELECT @SnapshotID, [State], [StateDesc], [PermissionName], [SchemaName], [UserName] FROM #SchemaPermissions;

	INSERT INTO [perms].[DatabasePermissions] ([SnapshotID], [State], [StateDesc], [PermissionName], [UserName])
	SELECT @SnapshotID, [State], [StateDesc], [PermissionName], [UserName] FROM #DatabasePermissions;

	DROP TABLE #Users;
	DROP TABLE #Roles;
	DROP TABLE #RoleMemberships;
	DROP TABLE #ObjectPermissions;
	DROP TABLE #SchemaPermissions;
	DROP TABLE #DatabasePermissions;

END
GO
/****** Object:  StoredProcedure [perms].[createSeverSnapshot]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [perms].[createSeverSnapshot]

AS

/**************************************************************************
	Author: Eric Cobb - http://www.sqlnuggets.com/
		License:
			MIT License
			Copyright (c) 2017-2018 Eric Cobb
			View full license disclosure: https://github.com/ericcobb/SQL-Server-Permissions-Manager/blob/master/LICENSE
			
	Purpose: 
			This stored procedure is used to create a snapshot of the current Server level permissions on this SQL Server
	Parameters:
			NONE
	Usage:	
			--Take a Permissions Snapshot of this SQL Sever
			EXEC [perms].[createSeverSnapshot];
***************************************************************************/

BEGIN

	SET NOCOUNT ON;
	
	DECLARE @SnapshotID BIGINT;

	INSERT INTO [perms].[Snapshots] (DatabaseName) VALUES (N'{Server-Permissions}');
	SELECT @SnapshotID = SCOPE_IDENTITY();
	
	--server level roles	
	INSERT INTO [perms].[ServerPermissions]
           ([SnapshotID]
           ,[PermissionName]
           ,[PermissionTypeDesc]
           ,[LoginName])
	SELECT @SnapshotID
			,r.name
			,r.type_desc
			,m.name
	FROM sys.server_role_members  rm
	INNER JOIN sys.server_principals AS r ON rm.role_principal_id = r.principal_id  
	INNER JOIN sys.server_principals AS m ON rm.member_principal_id = m.principal_id
	WHERE rm.member_principal_id > 1

	--server level permissions	
	INSERT INTO [perms].[ServerPermissions]
           ([SnapshotID]
           ,[PermissionName]
           ,[PermissionTypeDesc]
           ,[LoginName])
	SELECT @SnapshotID
			,SrvPerm.state_desc +' '+ SrvPerm.permission_name
			,N'SERVER_PERMISSION'
			,SP.name	
	FROM sys.server_permissions AS SrvPerm 
	INNER JOIN sys.server_principals AS SP ON SrvPerm.grantee_principal_id = SP.principal_id 
	WHERE   SP.type IN ( 'S', 'U', 'G' ) 
	AND SP.name NOT LIKE '##%##'
	AND SP.name NOT LIKE 'NT AUTHORITY%'
	AND SP.name NOT LIKE 'NT SERVICE%'
	AND SP.name <> ('sa');

END
GO
/****** Object:  StoredProcedure [perms].[purgeSnapshots]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [perms].[purgeSnapshots]
	@DaysToKeep INT = 90
AS

/**************************************************************************
	Author: Eric Cobb - http://www.sqlnuggets.com/
		License:
			MIT License
			Copyright (c) 2017 Eric Cobb
			View full license disclosure: https://github.com/ericcobb/SQL-Server-Permissions-Manager/blob/master/LICENSE
			
	Purpose: 
			This stored procedure is used to purge old Permission Snapshots from the database
	Parameters:
			@DaysToKeep - REQUIRED - How many days worth of data do you want to keep?  Anything older than this number (defualts to 90 days) will be deleted. 
	Usage:	
			--Delete all snapshots older than 90 days (default);
			EXEC [perms].[purgeSnapshots];
			--Delete all snapshots older than 120 days;
			EXEC [perms].[purgeSnapshots] @DaysToKeep = 120;
***************************************************************************/

BEGIN
	SET NOCOUNT ON;

	BEGIN TRANSACTION

		BEGIN TRY

		DECLARE @snapshots TABLE ([SnapshotID] INT PRIMARY KEY CLUSTERED NOT NULL);
		
		--create a list of the snapshots to delete
		INSERT INTO @snapshots ([SnapshotID])
		SELECT ID FROM [perms].[Snapshots] ss
		WHERE ss.[CaptureDate] < DATEADD(day,0-@DaysToKeep,GETDATE())

		--go forth and delete
		DELETE p
		FROM [perms].[DatabasePermissions] p
		INNER JOIN @snapshots s ON s.[SnapshotID] = p.[SnapshotID];

		DELETE p
		FROM [perms].[SchemaPermissions] p
		INNER JOIN @snapshots s ON s.[SnapshotID] = p.[SnapshotID];
		
		DELETE p
		FROM [perms].[ObjectPermissions] p
		INNER JOIN @snapshots s ON s.[SnapshotID] = p.[SnapshotID];
		
		DELETE p
		FROM [perms].[RoleMemberships] p
		INNER JOIN @snapshots s ON s.[SnapshotID] = p.[SnapshotID];
		
		DELETE p
		FROM [perms].[Roles] p
		INNER JOIN @snapshots s ON s.[SnapshotID] = p.[SnapshotID];
		
		DELETE p
		FROM [perms].[Users] p
		INNER JOIN @snapshots s ON s.[SnapshotID] = p.[SnapshotID];
		
		DELETE p
		FROM [perms].[Snapshots] p
		INNER JOIN @snapshots s ON s.[SnapshotID] = p.[ID];

		DELETE p
		FROM [perms].[ServerPermissions] p
		INNER JOIN @snapshots s ON s.[SnapshotID] = p.[SnapshotID];


		COMMIT TRANSACTION
		END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
	END CATCH
END

GO
/****** Object:  StoredProcedure [perms].[removeAllUsersFromDB]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [perms].[removeAllUsersFromDB] (
	@DBName NVARCHAR(128)
 )
AS

/**************************************************************************
	Author: Eric Cobb - http://www.sqlnuggets.com/
		License:
			MIT License
			Copyright (c) 2017 Eric Cobb
			View full license disclosure: https://github.com/ericcobb/SQL-Server-Permissions-Manager/blob/master/LICENSE
			
	Purpose: 
			This stored procedure is used to drop all users from a database.
			Users that own certificates, and default system users, will not be dropped.
            Users can be added back using the latest permissions snapshot for that database.
	Parameters:
			@DBName - REQUIRED - Database you wish to remove all user from.
	Usage:	
			--Remove all users from the MyDB database;
			EXEC [perms].[removeAllUsersFromDB] @DBName='MyDB';
			
***************************************************************************/

BEGIN
	SET NOCOUNT ON;
    DECLARE @Message NVARCHAR(255);
    DECLARE @sql NVARCHAR(4000);
    DECLARE @Error NVARCHAR(400);

    --ensure parameters supplied are compatible.
    SET @Error = 0;
    IF @DBName = ''
    BEGIN
		SET @Message = 'The value for parameter @DBName is not supported.' + CHAR(13) + CHAR(10)
		RAISERROR(@Message,16,1) WITH NOWAIT
		SET @Error = @@ERROR
    END

    SET @sql = N'USE ' + @DBName + ';
	'

    SET @sql = @sql + N'
			DECLARE @UserID       varchar(128)
			DECLARE @SQLstmt      varchar(255)
			PRINT ''Fix Database Users''
			PRINT ''Server:   '' + @@servername
			PRINT ''Database: '' + DB_NAME()
			
			--avoid dropping users that were creating using certificates
			DECLARE DropUserCursor CURSOR LOCAL FAST_FORWARD FOR
			SELECT p.name FROM sys.database_principals p
			LEFT JOIN sys.certificates c ON p.principal_id = c.principal_id
			WHERE p.type <> ''R''
			AND p.principal_id >=5
			AND c.principal_id IS NULL
			OPEN DropUserCursor
			FETCH NEXT FROM DropUserCursor INTO @UserID
			WHILE @@FETCH_STATUS = 0
				BEGIN
					SELECT @SQLstmt = ''exec sp_revokedbaccess '''''' + @UserID + ''''''''
				PRINT @SQLstmt
				EXEC (@SQLstmt)
				FETCH NEXT FROM DropUserCursor INTO @UserID
			END
			CLOSE DropUserCursor
			DEALLOCATE DropUserCursor
	   '
   EXECUTE sp_executesql @sql
   --PRINT @sql
 
END
GO
/****** Object:  StoredProcedure [perms].[removeLogin]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [perms].[removeLogin] (
	@UserName NVARCHAR(256),
	@ExecuteScript BIT = 0,
	@DropLogin BIT = 1
)
AS

/**************************************************************************
	Author: Eric Cobb - http://www.sqlnuggets.com/
		License:
			MIT License
			Copyright (c) 2017 Eric Cobb
			View full license disclosure: https://github.com/ericcobb/SQL-Server-Permissions-Manager/blob/master/LICENSE
			
	Purpose: 
			This stored procedure is used to remove a user from all databases, then drop the login for that user.
			Users that own certificates, and default system users, will not be dropped.
	Parameters:
			@UserName - REQUIRED - the user we want to clone
			@ExecuteScript - OPTIONAL -	Flag for whether or not to actually apply the Permissions Snapshot.
										If 1: Automatically apply the permissions to the databse.
										If 0 (Default): Generates the permissions script to be reviewed/run manually.
			@DropLogin - OPTIONAL - Flag for where or not to actually drop the login after the user has been removed from all databases.
	Usage:	
			--Generate script to remove User1 from all databases and drop login;
			EXEC [perms].[removeLogin] @UserName = N'User1', @ExecuteScript = 0, @DropLogin = 1;
			
***************************************************************************/

BEGIN
	SET NOCOUNT ON;

	DECLARE @SQL NVARCHAR(4000);
	DECLARE @DBname NVARCHAR(128);

	DECLARE @dblist TABLE ([DBname] NVARCHAR(128));
	DECLARE @protectedUsers TABLE ([username] NVARCHAR(256));

	IF @ExecuteScript = 0
	BEGIN
		--SELECT 'THIS IS ONLY A TEST; THE SCRIPT HAS NOT EXECUTED AND THE USER HAS NOT BEEN REMOVED!'
		PRINT 'THIS IS ONLY A TEST; THE SCRIPT HAS NOT EXECUTED AND THE USER HAS NOT BEEN REMOVED!'
	END

	--get list of users that were creating using certificates
	INSERT INTO @protectedUsers
	SELECT distinct p.name 
	FROM sys.database_principals p
	INNER JOIN sys.certificates c ON p.principal_id = c.principal_id
	WHERE p.type <> 'R'
	
	IF @UserName IN (select coalesce(username,'N/A') from @protectedUsers)
	THROW 51000, 'This user is attached to a certificate and cannot be deleted!', 1;  
	
	--get list of system users
	INSERT INTO @protectedUsers
	SELECT  p.name 
	FROM sys.database_principals p
	WHERE p.type <> 'R'
	AND p.principal_id < 5
	
	IF @UserName IN (select username from @protectedUsers)
	THROW 51000, 'This is a system user and cannot be deleted!', 1;  
 
	--get list of databases this user has access to
	--TODO: I don't like using sp_MSforeachdb, find a replacement query
	SET @sql ='SELECT ''[?]'' AS DBName FROM [?].sys.database_principals WHERE name=''' + @UserName + ''''
	INSERT INTO @dblist
	EXEC sp_MSforeachdb @command1=@sql
		
	IF EXISTS (SELECT DBname FROM @dblist)
		BEGIN
			DECLARE DBList CURSOR LOCAL FAST_FORWARD FOR
			SELECT DBname FROM @dblist

			OPEN DBList
			FETCH NEXT FROM DBList INTO @DBname
			WHILE @@FETCH_STATUS = 0
			BEGIN
				SET @sql = N'USE ' + @DBName + ';'
				SET @sql = @sql + N'
				DROP USER ['+@UserName+'];'
				PRINT 'Dropping user from ' +	+ @DBName + ';'
		
				IF @ExecuteScript = 1
					EXECUTE sp_executesql @sql
				--ELSE
				--	SELECT @sql

				FETCH NEXT FROM DBList INTO @DBname
			END

			CLOSE DBList
			DEALLOCATE DBList
		
		END
	ELSE PRINT 'User ''' +@UserName+''' Is Not Assigned To Any Databases.'

	--if the login exists, drop it!
	IF @DropLogin = 1 AND EXISTS (select loginname from master.dbo.syslogins where name = @UserName)
		BEGIN
			PRINT 'Dropping Login ' +@UserName+''
			SET @sql = N'DROP LOGIN [' +@UserName+']' 
			IF @ExecuteScript = 1
				EXECUTE sp_executesql @sql
			--ELSE
			--	SELECT @sql
		END
	ELSE 
	IF @DropLogin = 1 
	PRINT 'Login ''' +@UserName+''' Does Not Exist'
	
END
GO
/****** Object:  StoredProcedure [perms].[restorePerms]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [perms].[restorePerms](
    @DBname NVARCHAR(128),
	@SnapshotID INT = NULL
 )
AS

/**************************************************************************
	Author: Eric Cobb - http://www.sqlnuggets.com/
		License:
			MIT License
			Copyright (c) 2017 Eric Cobb
			View full license disclosure: https://github.com/ericcobb/SQL-Server-Permissions-Manager/blob/master/LICENSE
			
	Purpose: 
			This stored procedure is used to remove all users from a database,
            then Users will be added back using the latest permissions snapshot for that database.
	Parameters:
			@DBName - REQUIRED - Name of the Database you want to drop users and apply a Permissions Snapshot to.
			@SnapshotID - OPTIONAL - ID of the specific Snapshot you want to apply.
	Usage:	
			--Drop all users from MyDB and restore the latest Permissions Snapshot for that database;
			EXEC [perms].[restorePerms] @DBName='MyDB';
			
***************************************************************************/

BEGIN
	SET NOCOUNT ON;

	--Drop all Users from the database
	EXEC perms.removeAllUsersFromDB @DBname

	--Restore Users from latest snapshot
	EXEC perms.applyPermissions 
		@DBName = @DBname,
		@SnapshotID = @SnapshotID,
		@CreateLogins = 1,
		@ExecuteScript = 1

END

GO
/****** Object:  StoredProcedure [perms].[snapshotAllDatabases]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [perms].[snapshotAllDatabases]
	@IncludeSysDatabases bit = 1
AS

/**************************************************************************
	Author: Eric Cobb - http://www.sqlnuggets.com/
		License:
			MIT License
			Copyright (c) 2017 Eric Cobb
			View full license disclosure: https://github.com/ericcobb/SQL-Server-Permissions-Manager/blob/master/LICENSE
			
	Purpose: 
			This stored procedure is used to create a snapshot of the current permissions in all databases on a server.
	Parameters:
			NONE
	Usage:	
			--Take a Permissions Snapshot for all databases.
			EXEC [perms].[snapshotAllDatabases];
***************************************************************************/

BEGIN
	SET NOCOUNT ON;

	DECLARE @tmpDatabases TABLE (
				ID INT IDENTITY PRIMARY KEY
				,DatabaseName NVARCHAR(128)
				,Completed BIT
			);

	DECLARE @CurrentID INT;
	DECLARE @CurrentDatabaseName NVARCHAR(128);

	IF @IncludeSysDatabases = 1
		BEGIN
			INSERT INTO @tmpDatabases (DatabaseName, Completed)
			SELECT [Name], 0
			FROM sys.databases
			WHERE state = 0
			AND source_database_id IS NULL
			ORDER BY [Name] ASC
		END
		ELSE BEGIN
			INSERT INTO @tmpDatabases (DatabaseName, Completed)
			SELECT [Name], 0
			FROM sys.databases
			WHERE state = 0 AND database_id > 4
			AND source_database_id IS NULL
			ORDER BY [Name] ASC
		END

	WHILE EXISTS (SELECT * FROM @tmpDatabases WHERE Completed = 0)
	BEGIN
		SELECT TOP 1 @CurrentID = ID,
					 @CurrentDatabaseName = DatabaseName
		FROM @tmpDatabases
		WHERE Completed = 0
		ORDER BY ID ASC

		EXEC [perms].[createDatabaseSnapshot] @DBName = @CurrentDatabaseName

		-- Update that the database is completed
		UPDATE @tmpDatabases
		SET Completed = 1
		WHERE ID = @CurrentID

		-- Clear variables
		SET @CurrentID = NULL
		SET @CurrentDatabaseName = NULL
	END
END
GO
/****** Object:  StoredProcedure [perms].[snapshotEverything]    Script Date: 11/16/2020 10:42:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [perms].[snapshotEverything]

AS

/**************************************************************************
	Author: Eric Cobb - http://www.sqlnuggets.com/
		License:
			MIT License
			Copyright (c) 2017-2018 Eric Cobb
			View full license disclosure: https://github.com/ericcobb/SQL-Server-Permissions-Manager/blob/master/LICENSE
			
	Purpose: 
			This stored procedure is used to create a snapshot of all of the current Server & Database level permissions on this SQL Server
	Parameters:
			NONE
	Usage:	
			--Take a Permissions Snapshot of this SQL Sever
			EXEC [perms].[snapshotEverything];
***************************************************************************/

BEGIN
	
	SET NOCOUNT ON;
	--snapshot the server permissions
	EXEC [perms].[createSeverSnapshot];
	--snapshot all of the database permissions
    EXEC [perms].[snapshotAllDatabases];

END
GO
