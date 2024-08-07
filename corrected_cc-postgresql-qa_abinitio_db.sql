-- create database schema

CREATE OR REPLACE FUNCTION create_language_plpgsql()
RETURNS BOOLEAN AS $$
BEGIN
    CREATE LANGUAGE plpgsql;
    RETURN TRUE;
EXCEPTION
    WHEN others THEN
        RETURN FALSE;
END;
$$ LANGUAGE plpgsql;


SELECT CASE WHEN NOT
    (
        SELECT  TRUE AS exists
        FROM    pg_language
        WHERE   lanname = 'plpgsql'
        UNION
        SELECT  FALSE AS exists
        ORDER BY exists DESC
        LIMIT 1
    )
THEN
    create_language_plpgsql()
ELSE
    FALSE
END AS plpgsql_created;

DROP FUNCTION create_language_plpgsql();
create table OpAnalysisAggregator (
       AnalysisAggregatorId int8 not null,
        AnalysisObjectId int8 not null,
        Name varchar(256) not null,
        MetricName varchar(256) not null,
        Units varchar(256) not null,
        AggregationType varchar(256) not null,
        primary key (AnalysisAggregatorId),
        unique (AnalysisObjectId, MetricName, Units, AggregationType),
        unique (AnalysisObjectId, Name)
    );
 
create table OpAnalysisAggregatorSQL (
       AnalysisAggregatorSQLId int8 not null,
        AnalysisAggregatorId int8 not null,
        JoinTableName varchar(256),
        JoinPKName varchar(256),
        BaseTableName varchar(256),
        BaseFKName varchar(256),
        JoinType varchar(256),
        AggregatorSQL varchar(2048) not null,
        SelectSQL varchar(2048),
        primary key (AnalysisAggregatorSQLId)
    );
 
create table OpAnalysisObject (
       AnalysisObjectId int8 not null,
        Name varchar(256) not null,
        TableName varchar(256) not null,
        BucketSQL varchar(2048) not null,
        primary key (AnalysisObjectId),
        unique (Name)
    );
 
create table OpAnalysisRow (
       AnalysisRowId int8 not null,
        AnalysisObjectId int8 not null,
        Name varchar(256) not null,
        primary key (AnalysisRowId),
        unique (AnalysisObjectId, Name)
    );
 
create table OpAnalysisRowSQL (
       AnalysisRowSQLId int8 not null,
        AnalysisRowId int8 not null,
        JoinTableName varchar(256) not null,
        JoinPKName varchar(256) not null,
        BaseTableName varchar(256) not null,
        BaseFKName varchar(256) not null,
        JoinType varchar(256) not null,
        SelectSQL varchar(2048),
        primary key (AnalysisRowSQLId)
    );
 
create table OpApplication (
       ApplicationId int8 not null,
        SystemId int8 not null,
        Name varchar(128) not null,
        Description varchar(1024),
        EndJobCutHorizon timestamp,
        IsApplicationNeverAutoGen char(1) not null,
        WarningNotificationGroupId int8,
        ErrorNotificationGroupId int8,
        SuccessNotificationGroupId int8,
        primary key (ApplicationId),
        unique (SystemId, Name)
    );
 
create table OpAudit (
       AuditId int8 not null,
        UpdateStamp timestamp not null,
        PrincipalId int8 not null,
        PrincipalName varchar(128) not null,
        Verb varchar(32) not null,
        VerbContext varchar(1024),
        ObjectTable varchar(32) not null,
        ObjectId int8 not null,
        ObjectLogicalIdentifier varchar(1024) not null,
        SystemId int8,
        SystemName varchar(128),
        primary key (AuditId)
    );
 
create table OpAutoGenStats (
       AutoGenStatsId int8 not null,
        SystemId int8 not null,
        LastRun timestamp,
        LastNumJobs int4,
        LastStartInclusive timestamp,
        LastEndExclusive timestamp,
        NextRun timestamp,
        NextStartInclusive timestamp,
        NextEndExclusive timestamp,
        primary key (AutoGenStatsId),
        unique (SystemId)
    );
 
create table OpBridge (
       BridgeId int8 not null,
        HostId int8 not null,
        Port int4 not null,
        IsHttps char(1) not null,
        RPCUsername varchar(128),
        RPCPassword varchar(2048),
        SecurityConfig varchar(256),
        SecurityTypeEnum varchar(64) not null,
        SecurityHashTypeEnum varchar(64) not null,
        primary key (BridgeId),
        unique (HostId, Port)
    );
 
create table OpCalendar (
       CalendarId int8 not null,
        SystemId int8 not null,
        Name varchar(128) not null,
        BookDate varchar(64),
        primary key (CalendarId),
        unique (SystemId, Name)
    );
 
create table OpCalendarYear (
       CalendarId int8 not null,
        Year int4 not null,
        Days varchar(366),
        primary key (CalendarId, Year)
    );
 
create table OpConfigValue (
       ConfigValueId int8 not null,
        Name varchar(128) not null,
        Description varchar(1024),
        ValueTypeEnum varchar(64),
        IsHidden char(1) not null,
        Value varchar(2048),
        primary key (ConfigValueId),
        unique (Name)
    );
 
create table OpDailyCpuUsage (
       DailyCpuUsageId int8 not null,
        KeyId int8,
        Hostname varchar(128) not null,
        ApplicationId int8 not null,
        CollectionDay timestamp not null,
        ExecutableEnum varchar(64) not null,
        Username varchar(128) not null,
        HostnamePlace varchar(128) not null,
        AbAgreementEnvironment varchar(128) not null,
        AbAgreementProject varchar(128) not null,
        Value float8,
        primary key (DailyCpuUsageId),
        unique (KeyId, Hostname, ApplicationId, CollectionDay, ExecutableEnum, Username, HostnamePlace, AbAgreementEnvironment, AbAgreementProject)
    );
 
create table OpDailyCpuUsageRollupState (
       DailyCpuUsageRollupStateId int8 not null,
        UpdateStamp timestamp not null,
        CollectionDay timestamp not null,
        RollupStateEnum varchar(64) not null,
        primary key (DailyCpuUsageRollupStateId),
        unique (CollectionDay)
    );
 
create table OpDay (
       JobDefinitionId int8 not null,
        DayIndex int4 not null,
        DayModeEnum varchar(64) not null,
        MonthDayOffset int4,
        NonOperationalOffset int4,
        DayOfWeekEnum varchar(64),
        WeekOfMonthEnum varchar(64),
        primary key (JobDefinitionId, DayIndex)
    );
 
create table OpEmeExecutable (
       EmeExecutableId int8 not null,
        UpdateStamp timestamp not null,
        AbAirRoot varchar(256) not null,
        AbAirBranch varchar(256) not null,
        EmeUrl varchar(256) not null,
        PublishedEmeName varchar(256),
        primary key (EmeExecutableId),
        unique (AbAirRoot, AbAirBranch, EmeUrl)
    );
 
create table OpExecutable (
       ExecutableId int8 not null,
        UpdateStamp timestamp not null,
        SystemId int8 not null,
        Hostname varchar(128) not null,
        ExpandedPath varchar(512) not null,
        ExecutableEnum varchar(64) not null,
        PrototypeExecutableId int8,
        FrequencyEnum varchar(64) not null,
        Frequency int4 not null,
        MicrographEnum varchar(64) not null,
        EmeExecutableId int8,
        primary key (ExecutableId),
        unique (SystemId, Hostname, ExpandedPath)
    );
 
create table OpFileAndEventConstraint (
       FileAndEventConstraintId int8 not null,
        ConstraintDiscriminator varchar(32) not null,
        JobDefinitionId int8,
        FileURL varchar(4000),
        FileRetryIntervalSec varchar(64),
        IsRepeatableForFileCreateTime char(1),
        PropertyTypeId int8,
        IsRegExSyntax char(1),
        IsFirstMatchOnly char(1),
        EventName varchar(256),
        ListSeparator varchar(64),
        ConstraintIndex int4,
        primary key (FileAndEventConstraintId)
    );
 
create table OpFileSystem (
       FileSystemId int8 not null,
        HostId int8 not null,
        Path varchar(512) not null,
        primary key (FileSystemId),
        unique (HostId, Path)
    );
 
create table OpFileSystemMetric (
       FileSystemMetricId int8 not null,
        FileSystemId int8 not null,
        Name varchar(32) not null,
        Units varchar(255) not null,
        ThresholdComparisonEnum varchar(32),
        WarningThreshold float8,
        ErrorThreshold float8,
        primary key (FileSystemMetricId),
        unique (FileSystemId, Name)
    );
 
create table OpFileSystemMetricValue (
       FileSystemMetricValueId int8 not null,
        FileSystemMetricId int8 not null,
        CollectionTime timestamp not null,
        Value float8 not null,
        primary key (FileSystemMetricValueId),
        unique (FileSystemMetricId, CollectionTime)
    );
 
create table OpGroupXref (
       ChildPrincipalId int8 not null,
        ParentGroupId int8 not null,
        primary key (ChildPrincipalId, ParentGroupId)
    );
 
create table OpHomeView (
       HomeViewId int8 not null,
        UpdateStamp timestamp not null,
        Name varchar(128) not null,
        Ordinal int4 not null,
        IsMonitored char(1) not null,
        primary key (HomeViewId),
        unique (Name)
    );
 
create table OpHomeViewBox (
       HomeViewBoxId int8 not null,
        UpdateStamp timestamp not null,
        HomeViewId int8 not null,
        Type varchar(32) not null,
        Name varchar(256) not null,
        Ordinal int4 not null,
        primary key (HomeViewBoxId),
        unique (HomeViewId, Type, Name)
    );
 
create table OpHost (
       HostId int8 not null,
        HostDiscriminator varchar(32) not null,
        Hostname varchar(255) not null,
        IsMonitored char(1),
        Tag varchar(32),
        OperatingSystem varchar(256),
        OperatingSystemDetail varchar(256),
        CpuClass varchar(256),
        NumberOfCpus float8,
        NumberOfLogicalCpus float8,
        MaxEffectiveCpu float8,
        CpuSpeedMhz float8,
        MaxWorkload float8,
        IsEphemeralHost char(1),
        WarningNotificationGroupId int8,
        ErrorNotificationGroupId int8,
        FatalNotificationGroupId int8,
        HostClusterId int8,
        NetworkHostName varchar(256),
        IsMultiScheduling char(1),
        PhysicalHostId int8,
        primary key (HostId),
        unique (Hostname)
    );
 
create table OpHostMetric (
       HostMetricId int8 not null,
        HostId int8 not null,
        Name varchar(32) not null,
        Units varchar(255) not null,
        ThresholdComparisonEnum varchar(32),
        WarningThreshold float8,
        ErrorThreshold float8,
        primary key (HostMetricId),
        unique (HostId, Name)
    );
 
create table OpHostMetricValue (
       HostMetricValueId int8 not null,
        HostMetricId int8 not null,
        CollectionTime timestamp not null,
        Value float8 not null,
        primary key (HostMetricValueId),
        unique (HostMetricId, CollectionTime)
    );
 
create table OpJamonHourlyReport (
       ReportId int8 not null,
        Label varchar(1000) not null,
        NodeIdentifier varchar(100) not null,
        IntervalStart timestamp not null,
        IntervalEnd timestamp not null,
        Count int8,
        MeanValue float8,
        StandardDeviation float8,
        MaxValue float8,
        MinValue float8,
        MaxActive float8,
        primary key (ReportId),
        unique (Label, NodeIdentifier, IntervalStart, IntervalEnd)
    );
 
create table OpJamonPFSReport (
       ReportId int8 not null,
        Label varchar(1000) not null,
        NodeIdentifier varchar(100) not null,
        IntervalStart timestamp not null,
        IntervalEnd timestamp not null,
        Count int8,
        MeanValue float8,
        StandardDeviation float8,
        MaxValue float8,
        MinValue float8,
        MaxActive float8,
        primary key (ReportId),
        unique (Label, NodeIdentifier, IntervalStart, IntervalEnd)
    );
 
create table OpJob (
       JobId int8 not null,
        UpdateStamp timestamp not null,
        JobGuid varchar(64) not null,
        ApplicationId int8 not null,
        ParentJobId int8,
        JobDefinitionId int8,
        ScheduledStartTime timestamp,
        EffectiveScheduledStartTime timestamp,
        ScheduledStartTimeHHMM varchar(5),
        ExecutableId int8,
        RerunSuccessorJobId int8,
        RerunPredecessorJobId int8,
        RerunGuid varchar(64),
        RunCount int4,
        Vmid varchar(64),
        IsPriorRerunJobSucceeded char(1) not null,
        IsManuallyStopped char(1),
        IsForcedJobState char(1),
        TestSetGuid varchar(64),
        IsRestartable char(1) not null,
        IsIgnoredAsPredecessor char(1) not null,
        IsIssuesIgnored char(1) not null,
        CommandLine varchar(4000) not null,
        JobEnum varchar(64) not null,
        ActionEnum varchar(64),
        WorkingDirectory varchar(1024),
        Username varchar(128),
        AbWorkDir varchar(512),
        AbDataDir varchar(1024),
        MonitorDirectory varchar(512),
        AbHome varchar(1024) not null,
        RecFile varchar(1024),
        StdoutPath varchar(1024),
        StderrPath varchar(1024),
        TrackingPath varchar(1024),
        TrackingChannel varchar(256),
        ResolvedGraphPath varchar(1024),
        Version varchar(16),
        AbAgreementEnvironment varchar(128),
        AbAgreementProject varchar(128),
        HostClusterName varchar(256),
        ResolvedHostname varchar(256) not null,
        StateEnum varchar(64) not null,
        EndTime timestamp,
        StartTime timestamp,
        SeverestEventGuid varchar(64),
        HighestEventGuid varchar(64),
        IsMeasured char(1) not null,
        CPU float8 not null,
        HostCPU float8 not null,
        DriverCPU float8 not null,
        StartupCPU float8 not null,
        RollupCPU float8 not null,
        NumViewChildren int4 not null,
        NumRunningChildren int4 not null,
        ViewParentJobId int8 not null,
        ViewStart timestamp not null,
        ViewEnd timestamp not null,
        MaxViewEndOfCompletedChildren timestamp,
        IsSupportsDependencies char(1) not null,
        EmeVersion int8,
        EmeTag varchar(256),
        EmeStatus varchar(64),
        DerivedName varchar(256) not null,
        JobDefinitionName varchar(128) not null,
        JobDefinitionGroupName varchar(128) not null,
        AnalysisDisabled bool,
        TraceId varchar(64),
        TraceDirectoryPath varchar(1024),
        TraceExtraArgs varchar(512),
        IsTracing bool,
        primary key (JobId),
        unique (JobGuid)
    );
 
create table OpJobCompletion (
       JobCompletionId int8 not null,
        UpdateStamp timestamp not null,
        WatcherKey varchar(128) not null,
        EndTime timestamp not null,
        primary key (JobCompletionId),
        unique (WatcherKey)
    );
 
create table OpJobDefinition (
       JobDefinitionId int8 not null,
        UpdateStamp timestamp not null,
        JobDefinitionDiscriminator varchar(32) not null,
        JobDefinitionGuid varchar(64) not null,
        Name varchar(128) not null,
        Description varchar(1024),
        ApplicationId int8 not null,
        ApproveEnum varchar(64),
        AutoIgnoreFailure char(1),
        AutoIgnoreOnlyLastFailure char(1),
        EmailOnSuccess char(1),
        IsEnabled char(1),
        RuntimeId int8,
        Sandbox varchar(1024),
        JobPrefix varchar(256),
        KillExpiredJobs char(1),
        IsNoMatchAnError char(1),
        DurationDefaultSec int4,
        StdoutFile varchar(1024),
        IsStdoutAppend char(1),
        IsStdoutToLog char(1),
        StderrFile varchar(1024),
        IsStderrAppend char(1),
        IsStderrToLog char(1),
        AutoRerunAttemptWindow int4,
        AutoRerunAttempts int4,
        AutoRerunDelay int4,
        TraceId varchar(64),
        TraceDirectoryPath varchar(1024),
        TraceExtraArgs varchar(512),
        ForceStart varchar(64),
        JobDefinitionGroupId int8,
        SuccessNotificationGroupId int8,
        WarningNotificationGroupId int8,
        ErrorNotificationGroupId int8,
        IsManuallyGeneratedOnly char(1),
        IsOperatorVisible char(1),
        TraceStartDateTime timestamp,
        TraceEndDateTime timestamp,
        ClusterNodeLabel varchar(255),
        IsOriginalSLA char(1),
        ScheduledStartTime timestamp,
        EffectiveScheduledStartTime timestamp,
        ProductionDayToUse timestamp,
        primary key (JobDefinitionId),
        unique (JobDefinitionGuid, ApproveEnum, ScheduledStartTime, EffectiveScheduledStartTime)
    );
 
create table OpJobDefinitionAction (
       JobDefinitionActionId int8 not null,
        ActionDiscriminator varchar(32) not null,
        JobDefinitionId int8,
        ExecutablePath varchar(256),
        ExecutableEnum varchar(64),
        WorkingDirectory varchar(256),
        IsEnabled char(1),
        IsNotification char(1),
        DurationSec int4,
        AutoIgnoreIssue char(1),
        ActionEnum varchar(64),
        primary key (JobDefinitionActionId)
    );
 
create table OpJobDefinitionActionArgument (
       JobDefinitionActionId int8 not null,
        ArgumentIndex int4 not null,
        Value varchar(4000),
        IsExpandable char(1) not null,
        primary key (JobDefinitionActionId, ArgumentIndex)
    );
 
create table OpJobDefinitionDependency (
       JobDefinitionId int8 not null,
        PredecessorJobDefinitionGuid varchar(64) not null,
        primary key (JobDefinitionId, PredecessorJobDefinitionGuid)
    );
 
create table OpJobDefinitionPropertyValue (
       JobDefinitionId int8 not null,
        PropertyTypeId int8 not null,
        PropertyValue varchar(1024),
        IsWildcard char(1) not null,
        primary key (JobDefinitionId, PropertyTypeId)
    );
 
create table OpJobDefinitionStats (
       JobDefinitionStatsId int8 not null,
        JobDefinitionGuid varchar(255) not null,
        ScheduledStartTimeHHMM varchar(5) not null,
        NumSuccessfulJobs int4 not null,
        AvgStartDelaySec float8 not null,
        AvgDurationSec float8 not null,
        primary key (JobDefinitionStatsId),
        unique (JobDefinitionGuid, ScheduledStartTimeHHMM)
    );
 
create table OpJobEvent (
       JobEventId int8 not null,
        JobEventGuid varchar(64) not null,
        JobId int8 not null,
        EventTypeEnum varchar(64) not null,
        EventSeverity int4 not null,
        EventTime timestamp not null,
        ArrivalOrder int4 not null,
        Source varchar(64),
        EventValue varchar(512),
        Summary varchar(512),
        Detail varchar(1024),
        primary key (JobEventId),
        unique (JobEventGuid)
    );
 
create table OpJobPredictedState (
       JobId int8 not null,
        IsWedged char(1) not null,
        PredictedStartTime timestamp,
        PredictedEndTime timestamp,
        HighestSeverity int4 not null,
        LateStartTime timestamp,
        ExpiredStartTime timestamp,
        LateEndTime timestamp,
        ExpiredEndTime timestamp,
        primary key (JobId)
    );
 
create table OpJobPropertyValue (
       JobId int8 not null,
        PropertyTypeId int8 not null,
        PropertyValue varchar(1024),
        primary key (JobId, PropertyTypeId)
    );
 
create table OpJobSet (
       JobSetId int8 not null,
        UpdateStamp timestamp not null,
        JobSetGuid varchar(128) not null,
        Name varchar(128) not null,
        IsMonitored char(1) not null,
        SystemId int8,
        HostName varchar(255),
        GroupByName varchar(32) not null,
        GroupByLabel varchar(256),
        FilterText varchar(1024),
        BadStatusTypeEnum varchar(64) not null,
        IssuesSeverityOrderEnum varchar(64) not null,
        OrderByName varchar(32) not null,
        IsOrderAscending char(1) not null,
        IsShowOrderByLabel char(1) not null,
        JobMax int4 not null,
        Tag varchar(32),
        primary key (JobSetId),
        unique (Name),
        unique (JobSetGuid)
    );
 
create table OpKey (
       KeyId int8 not null,
        KeyGuid varchar(512) not null,
        Hostname varchar(128),
        HostRole varchar(512),
        CoreRating float8,
        CustomerProject varchar(512),
        CustomerRole varchar(512),
        NumberOfCpus float8,
        NumberOfLogicalCpus float8,
        primary key (KeyId),
        unique (KeyGuid)
    );
 
create table OpKeyFile (
       KeyFileId int8 not null,
        KeyId int8 not null,
        ImportTime timestamp not null,
        KeyDocument text not null,
        primary key (KeyFileId),
        unique (KeyId)
    );
 
create table OpKeyServerReport (
       KeyServerReportId int8 not null,
        UpdateStamp timestamp not null,
        ProductId int8 not null,
        JobId varchar(64) not null,
        ReportStatus varchar(64) not null,
        ReportMode varchar(64) not null,
        ErrorMessage varchar(64) not null,
        Report text not null,
        primary key (KeyServerReportId)
    );
 
create table OpMetric (
       MetricId int8 not null,
        ExecutableId int8,
        EmeExecutableId int8,
        Name varchar(128) not null,
        Expression varchar(1024) not null,
        IsRuntime char(1) not null,
        IsSummary char(1) not null,
        Units varchar(255),
        WarningExpression varchar(255),
        ErrorExpression varchar(255),
        MinimumVersion varchar(32),
        FrequencyEnum varchar(64),
        Frequency int4,
        primary key (MetricId),
        unique (ExecutableId, EmeExecutableId, Name)
    );
 
create table OpMetricValue (
       MetricValueId int8 not null,
        JobId int8 not null,
        MetricId int8 not null,
        CollectionTime timestamp not null,
        IsSummary char(1) not null,
        Hostname varchar(128),
        KeyId int8,
        Value float8,
        StringValue varchar(255),
        Error varchar(1024),
        ApplicationId int8 not null,
        SystemId int8 not null,
        ExecutableId int8,
        JobDefinitionGuid varchar(64),
        JobGuid varchar(64) not null,
        Bucket int8 not null,
        ActionEnum varchar(64),
        StateEnum varchar(64) not null,
        ScheduledStartTime timestamp,
        ScheduledStartTimeHHMM varchar(5),
        AnalysisDisabled bool,
        primary key (MetricValueId),
        unique (JobId, MetricId, CollectionTime, IsSummary, Hostname, KeyId)
    );
 
create table OpMonitoredEvent (
       MonitoredEventId int8 not null,
        UpdateStamp timestamp not null,
        EventTypeDiscriminator varchar(32) not null,
        MonitoredEventGuid varchar(128) not null,
        ErrorCode varchar(64),
        EventCategory varchar(64),
        EventSeverity int4 not null,
        EventTime timestamp not null,
        EventValue varchar(512),
        Summary varchar(512),
        Detail varchar(1024),
        SourceObjectGuid varchar(128),
        SourceObjectType varchar(32),
        LifecycleState varchar(32) not null,
        DismissComment varchar(1024),
        MonitoredObjectGuid varchar(256) not null,
        RepeatCount int4,
        RepeatStartTime timestamp,
        SystemId int8,
        ReporterId int8,
        ProductId int8,
        HostId int8,
        primary key (MonitoredEventId),
        unique (MonitoredEventGuid)
    );
 
create table OpMonitoredStatus (
       MonitoredStatusId int8 not null,
        StatusTypeDiscriminator varchar(32) not null,
        LastEventId int8,
        SeverestEventId int8,
        HostId int8,
        ProductId int8,
        ReporterId int8,
        SystemId int8,
        primary key (MonitoredStatusId)
    );
 
create table OpNotificationGroup (
       NotificationGroupId int8 not null,
        Name varchar(128) not null,
        Description varchar(1024),
        primary key (NotificationGroupId),
        unique (Name)
    );
 
create table OpNotificationGroupRecipient (
       NotificationGroupId int8 not null,
        RecipientId int8 not null,
        primary key (NotificationGroupId, RecipientId)
    );
 
create table OpOSAuthentication (
       OSAuthenticationId int8 not null,
        OSAuthenticationGuid varchar(64) not null,
        OSAuthenticationTypeEnum varchar(64) not null,
        HostId int8,
        VirtualHostname varchar(256),
        Username varchar(128),
        Password varchar(2048),
        FunctionalUser varchar(256),
        primary key (OSAuthenticationId),
        unique (HostId, VirtualHostname, Username, FunctionalUser),
        unique (OSAuthenticationGuid)
    );
 
create table OpPrincipal (
       PrincipalId int8 not null,
        PrincipalDiscriminator varchar(32) not null,
        Name varchar(128) not null,
        LCName varchar(128) not null,
        DisplayName varchar(128),
        Description varchar(1024),
        IsBuiltin char(1) not null,
        IsEnabled char(1),
        Password varchar(2048),
        primary key (PrincipalId),
        unique (LCName),
        unique (Name)
    );
 
create table OpPrivilege (
       PrivilegeId int8 not null,
        PrincipalId int8 not null,
        RoleEnum varchar(32) not null,
        SystemId int8,
        primary key (PrivilegeId),
        unique (PrincipalId, RoleEnum, SystemId)
    );
 
create table OpProduct (
       ProductId int8 not null,
        UpdateStamp timestamp not null,
        ProductGuid varchar(128) not null,
        ProductTypeId int8 not null,
        ProductName varchar(256) not null,
        Version varchar(128),
        Description varchar(256),
        IsDetected char(1) not null,
        IsItThisCC char(1) not null,
        IsMonitored char(1) not null,
        Tag varchar(32),
        HostId int8 not null,
        MonitorDirectory varchar(512),
        ConfigurationUser varchar(64),
        ContextRoot varchar(128),
        Url varchar(512),
        LogFilePath varchar(1024),
        AbApplicationHub varchar(1024),
        AbHome varchar(1024),
        AbWorkDir varchar(512),
        AbDataDir varchar(1024),
        RootDirectory varchar(1024),
        WorkDir varchar(1024),
        ConfigFile varchar(1024),
        JdbcUrl varchar(256),
        KeyNumCpus varchar(64),
        KeyExpiryDate timestamp,
        KeyFilePath varchar(1024),
        Port int4,
        KeyServerGroup varchar(256),
        KeyBundleId varchar(256),
        KeyBundleKeyType varchar(32),
        PathEnvValue varchar(1024),
        StartCommandString varchar(256),
        StopCommandString varchar(256),
        RestartCommandString varchar(256),
        StatusCommandString varchar(256),
        GoodStatusRegex varchar(512),
        GoodStatusText varchar(128),
        BadStatusRegex varchar(512),
        BadStatusText varchar(128),
        ProductStatusEnum varchar(64) not null,
        WarningNotificationGroupId int8,
        ErrorNotificationGroupId int8,
        FatalNotificationGroupId int8,
        primary key (ProductId),
        unique (ProductName),
        unique (ProductGuid)
    );
 
create table OpProductType (
       ProductTypeId int8 not null,
        TypeName varchar(64) not null,
        ProductName varchar(256) not null,
        ProductNameString varchar(256),
        ProductVendor varchar(128) not null,
        ProductVariety varchar(16) not null,
        KeyFileProductId varchar(64),
        IsAddByAdmin char(1) not null,
        ConfigurationUserTreatment varchar(16) not null,
        ContextRootTreatment varchar(16) not null,
        UrlTreatment varchar(16) not null,
        LogFilePathTreatment varchar(16) not null,
        AbHomeTreatment varchar(16) not null,
        AbApplicationHubTreatment varchar(16) not null,
        AbWorkDirTreatment varchar(16) not null,
        AbDataDirTreatment varchar(16) not null,
        RootDirectoryTreatment varchar(16) not null,
        WorkDirTreatment varchar(16) not null,
        ConfigFileTreatment varchar(16) not null,
        PortTreatment varchar(16) not null,
        VersionTreatment varchar(16) not null,
        RootDirectoryEnvVar varchar(64),
        StartCommandString varchar(256),
        StopCommandString varchar(256),
        RestartCommandString varchar(256),
        StatusCommandString varchar(256),
        GoodStatusRegex varchar(512),
        GoodStatusText varchar(128),
        BadStatusRegex varchar(512),
        BadStatusText varchar(128),
        AbAppIdentifier varchar(256),
        primary key (ProductTypeId),
        unique (TypeName)
    );
 
create table OpProductXref (
       LeftProductId int8 not null,
        ProductRelationship varchar(16) not null,
        RightProductId int8 not null,
        primary key (LeftProductId, ProductRelationship, RightProductId)
    );
 
create table OpPropertyType (
       PropertyTypeId int8 not null,
        PropertyTypeDiscriminator varchar(32) not null,
        SystemId int8 not null,
        Name varchar(128) not null,
        Description varchar(1024),
        MarkForDelete char(1),
        ColumnSequence int4 not null,
        DefaultValue varchar(1024),
        CustomTypeEnum varchar(64),
        BuiltinPropertyExpression varchar(256),
        primary key (PropertyTypeId),
        unique (SystemId, ColumnSequence),
        unique (SystemId, Name)
    );
 
create table OpQueue (
       QueueId int8 not null,
        UpdateStamp timestamp not null,
        HostId int8 not null,
        Directory varchar(256) not null,
        MonitorDirectory varchar(512),
        SystemId int8 not null,
        Name varchar(128) not null,
        QueueType varchar(256) not null,
        QueueVersion int4 not null,
        Owner varchar(128) not null,
        NumPartitions int4 not null,
        QueueAttributes varchar(256),
        WarningNotificationGroupId int8,
        ErrorNotificationGroupId int8,
        IsIssuesIgnored char(1) not null,
        IsQueueDeleted char(1) not null,
        primary key (QueueId),
        unique (SystemId, Name),
        unique (HostId, Directory)
    );
 
create table OpQueueClient (
       QueueClientId int8 not null,
        QueueId int8 not null,
        QueueSubscriberId int8,
        JobId int8 not null,
        GraphComponent varchar(256) not null,
        GraphComponentEnum varchar(32) not null,
        EventTime timestamp not null,
        primary key (QueueClientId)
    );
 
create table OpQueueMetric (
       QueueMetricId int8 not null,
        QueueMetricDiscriminator varchar(32) not null,
        ThresholdComparisonEnum varchar(32) not null,
        WarningThreshold int4,
        ErrorThreshold int4,
        MetricEnum varchar(32) not null,
        QueueId int8,
        QueueSubscriberId int8,
        primary key (QueueMetricId)
    );
 
create table OpQueueMetricValue (
       QueueMetricValueId int8 not null,
        QueueMetricId int8 not null,
        CollectionTime timestamp not null,
        Value float8 not null,
        MetricStatusEnum varchar(32) not null,
        primary key (QueueMetricValueId),
        unique (QueueMetricId, CollectionTime)
    );
 
create table OpQueueStats (
       QueueStatsId int8 not null,
        QueueId int8 not null,
        LastCollectionTime timestamp not null,
        QueueStatusEnum varchar(32) not null,
        LastAlertTime timestamp,
        primary key (QueueStatsId),
        unique (QueueId)
    );
 
create table OpQueueSubscriber (
       QueueSubscriberId int8 not null,
        QueueId int8 not null,
        IdSubdirectory varchar(256) not null,
        IsIssuesIgnored char(1) not null,
        IsSubscriberDeleted char(1) not null,
        primary key (QueueSubscriberId)
    );
 
create table OpQuickLink (
       QuickLinkId int8 not null,
        Name varchar(128),
        Description varchar(1024),
        Url varchar(2048),
        IconName varchar(128),
        IsHidden char(1) not null,
        Sequence int4 not null,
        primary key (QuickLinkId)
    );
 
create table OpRecipient (
       RecipientId int8 not null,
        RecipientTypeDiscriminator varchar(32) not null,
        Name varchar(128) not null,
        Description varchar(1024),
        EmailAddresses varchar(2048),
        HttpAddress varchar(2048),
        primary key (RecipientId),
        unique (Name)
    );
 
create table OpRecipientHeader (
       RecipientHeaderId int8 not null,
        RecipientId int8 not null,
        Type varchar(64) not null,
        Name varchar(128) not null,
        Value varchar(1024),
        Sequence int4 not null,
        Properties varchar(1024),
        primary key (RecipientHeaderId),
        unique (RecipientId, Type, Name)
    );
 
create table OpReporter (
       ReporterId int8 not null,
        PhysicalHostId int8 not null,
        WorkingDirectory varchar(512) not null,
        ReporterGuid varchar(128) not null,
        ProductId int8,
        LogicalHostId int8 not null,
        Username varchar(128),
        AbHome varchar(256),
        ReporterUserModeEnum varchar(32),
        IsScheduling char(1),
        WebServiceVersion varchar(16) not null,
        ReporterConfigPath varchar(256),
        ReporterLogPath varchar(256),
        LastWebServiceTime timestamp not null,
        IsStopped char(1),
        IncludeInCCStatus char(1) not null,
        NeedsRestart char(1) not null,
        ReporterConfigSetId int8,
        primary key (ReporterId),
        unique (PhysicalHostId, WorkingDirectory)
    );
 
create table OpReporterConfigItem (
       ReporterConfigItemId int8 not null,
        PropertyTypeDiscriminator varchar(32) not null,
        ReporterDefaultConfigItemId int8,
        LongValue int8,
        DoubleValue float8,
        StringValue varchar(1024),
        BooleanValue char(1),
        PasswordValue varchar(2048),
        ReporterConfigSetId int8 not null,
        primary key (ReporterConfigItemId)
    );
 
create table OpReporterConfigSet (
       ReporterConfigSetId int8 not null,
        Name varchar(256) not null,
        Source varchar(1024) not null,
        Version varchar(64) not null,
        Description varchar(1024),
        ReporterConfigSetType varchar(32) not null,
        ReporterConfigSetPatternType varchar(32),
        ReporterConfigSetPattern varchar(1024),
        primary key (ReporterConfigSetId),
        unique (Name)
    );
 
create table OpReporterDefaultConfigItem (
       ReporterDefaultConfigItemId int8 not null,
        Name varchar(256) not null,
        StartVersion varchar(16) not null,
        EndVersion varchar(16),
        Description varchar(255),
        ItemType varchar(64) not null,
        Value varchar(255),
        ReporterParameterGroupType varchar(32) not null,
        ReporterConfigValueType varchar(32) not null,
        primary key (ReporterDefaultConfigItemId),
        unique (Name)
    );
 
create table OpReporterDirectory (
       ReporterId int8 not null,
        Directory varchar(256)
    );
 
create table OpResourcePart (
       ResourcePartId int8 not null,
        UpdateStamp timestamp not null,
        ResourceRequestId int8 not null,
        ResourceSettingId int8 not null,
        InstanceName varchar(256),
        RequiredQuantity int4 not null,
        primary key (ResourcePartId),
        unique (ResourceRequestId, ResourceSettingId)
    );
 
create table OpResourcePool (
       ResourcePoolId int8 not null,
        UpdateStamp timestamp not null,
        ResourceServerId int8 not null,
        Url varchar(512) not null,
        primary key (ResourcePoolId),
        unique (ResourceServerId, Url)
    );
 
create table OpResourceRequest (
       ResourceRequestId int8 not null,
        UpdateStamp timestamp not null,
        ResourceRequestDiscriminator varchar(32) not null,
        ResourceServerId int8 not null,
        Handle int4 not null,
        WhenRequested timestamp,
        WhenGranted timestamp,
        ClientSandboxUrl varchar(1024),
        ClientProject varchar(1024),
        ClientPlanName varchar(1024),
        ClientPrincipal varchar(256),
        ClientJobGuid varchar(256),
        ResourceTaskName varchar(1024),
        ResourcePriority int4,
        ResourceIsTentative char(1),
        ResourceEventName varchar(1024),
        primary key (ResourceRequestId),
        unique (ResourceServerId, Handle)
    );
 
create table OpResourceServer (
       ResourceServerId int8 not null,
        UpdateStamp timestamp not null,
        Hostname varchar(256) not null,
        AbWorkDir varchar(512) not null,
        MonitorDirectory varchar(512),
        ArrivalOrder int4 not null,
        StartStamp timestamp,
        StopStamp timestamp,
        ProductId int8,
        primary key (ResourceServerId),
        unique (Hostname, AbWorkDir)
    );
 
create table OpResourceSetting (
       ResourceSettingId int8 not null,
        UpdateStamp timestamp not null,
        ResourcePoolId int8 not null,
        SettingName varchar(256) not null,
        IsGroup char(1) not null,
        SettingGroup varchar(256),
        MaxQuantity int4 not null,
        UsedQuantity int4 not null,
        IsVariable char(1) not null,
        primary key (ResourceSettingId),
        unique (ResourcePoolId, SettingName, IsGroup)
    );
 
create table OpRuntime (
       RuntimeId int8 not null,
        RuntimeTypeDiscriminator varchar(32) not null,
        Name varchar(128) not null,
        OSAuthenticationId int8 not null,
        BridgeId int8 not null,
        AbHome varchar(256) not null,
        SystemId int8,
        FilesystemRoot varchar(1024),
        ConfigEnvGuid varchar(64),
        Tag varchar(32),
        primary key (RuntimeId),
        unique (Name, SystemId)
    );
 
create table OpSystem (
       SystemId int8 not null,
        UpdateStamp timestamp not null,
        SystemGuid varchar(128) not null,
        Name varchar(128) not null,
        Description varchar(1024),
        ProductionDayHHMM varchar(64) not null,
        TimeZoneId varchar(64) not null,
        ExcludeJobColumns varchar(1024),
        ExcludeJobDefinitionColumns varchar(1024),
        IsAutoGenEnabled char(1) not null,
        AutoGenRangeMins int4 not null,
        AutoGenOffsetMins int4 not null,
        AutoGenDailyFrequency int4 not null,
        primary key (SystemId),
        unique (Name),
        unique (SystemGuid)
    );
 
create table OpTimeConstraint (
       JobDefinitionId int8 not null,
        ModeEnum varchar(64) not null,
        StartDate timestamp,
        EndDate timestamp,
        TimeZoneId varchar(128),
        StartTimes varchar(512),
        MonthsOfYear varchar(64),
        CalendarId int8,
        primary key (JobDefinitionId)
    );
 
create table OpZMVDenormalizedDay (
       DenormalizedDayId int8 not null,
        JobId int8 not null,
        ApplicationId int8 not null,
        ExecutableId int8,
        Hostname varchar(128),
        KeyId int8,
        MetricId int8 not null,
        CollectionDay timestamp not null,
        CollectionTime timestamp not null,
        Value float8,
        primary key (DenormalizedDayId),
        unique (JobId, ApplicationId, ExecutableId, Hostname, KeyId, MetricId, CollectionDay, CollectionTime)
    );
 
create table OpZMVDifference (
       DifferenceId int8 not null,
        JobId int8 not null,
        ApplicationId int8 not null,
        ExecutableId int8,
        Hostname varchar(128),
        KeyId int8,
        MetricId int8 not null,
        CollectionDay timestamp not null,
        CollectionTime timestamp not null,
        Value float8,
        primary key (DifferenceId),
        unique (JobId, ApplicationId, ExecutableId, Hostname, KeyId, MetricId, CollectionDay, CollectionTime)
    );
-- create constraints
create sequence hibernate_sequence start 1 increment 1;
 
create index IDX_JDPROPVALUE_PROPTYPEID on OpJobDefinitionPropertyValue (PropertyTypeId);
 
create index IDX_JOBPROPVALUE_PROPTYPEID on OpJobPropertyValue (PropertyTypeId);
 
alter table OpAnalysisAggregator 
       add constraint FKrfit5fi48b9jragbnu88jte7b 
       foreign key (AnalysisObjectId) 
       references OpAnalysisObject;
 
alter table OpAnalysisAggregatorSQL 
       add constraint FK1hnbwq56yhs2yuy1d4cooh4l8 
       foreign key (AnalysisAggregatorId) 
       references OpAnalysisAggregator;
 
alter table OpAnalysisRow 
       add constraint FKkck9t25618jy83xsleeoeiovw 
       foreign key (AnalysisObjectId) 
       references OpAnalysisObject;
 
alter table OpAnalysisRowSQL 
       add constraint FKjrb0ul88q3jv0u0frxwrq0e2 
       foreign key (AnalysisRowId) 
       references OpAnalysisRow;
 
alter table OpApplication 
       add constraint FKkdgdh04oj75sec9dwiyhg16ye 
       foreign key (SystemId) 
       references OpSystem;
 
alter table OpApplication 
       add constraint FKmc3ylwrh5i9d0aakg5vk8rlx5 
       foreign key (WarningNotificationGroupId) 
       references OpNotificationGroup;
 
alter table OpApplication 
       add constraint FKc9bq3d4daq4ee597etpnm4g97 
       foreign key (ErrorNotificationGroupId) 
       references OpNotificationGroup;
 
alter table OpApplication 
       add constraint FKjpcf8tq0npea5s9mf6tbrrioi 
       foreign key (SuccessNotificationGroupId) 
       references OpNotificationGroup;
 
alter table OpAutoGenStats 
       add constraint FKs0xei25r31jtsghpelm9p3sg0 
       foreign key (SystemId) 
       references OpSystem;
 
alter table OpBridge 
       add constraint FKm1n717usrfscv5xywbh93kotc 
       foreign key (HostId) 
       references OpHost;
 
alter table OpCalendar 
       add constraint FK37katf1nkit4d6okja33erenk 
       foreign key (SystemId) 
       references OpSystem;
 
alter table OpCalendarYear 
       add constraint FKci2yumr9qfmm7es3n6b2xbc4 
       foreign key (CalendarId) 
       references OpCalendar;
 
alter table OpDailyCpuUsage 
       add constraint FKshn2d7ldgnpjt8wids5ffhog3 
       foreign key (KeyId) 
       references OpKey;
 
alter table OpDailyCpuUsage 
       add constraint FKi9hybiyfiu4k57mog9cp3d5ve 
       foreign key (ApplicationId) 
       references OpApplication;
 
alter table OpDay 
       add constraint FKbtr4fr587l83sp43h7b0nkgrf 
       foreign key (JobDefinitionId) 
       references OpTimeConstraint;
 
alter table OpExecutable 
       add constraint FK1o5714a6kc0h91ohhjf6womjm 
       foreign key (SystemId) 
       references OpSystem;
 
alter table OpExecutable 
       add constraint FKk2hb991clofp9lrgyuxe617hd 
       foreign key (PrototypeExecutableId) 
       references OpExecutable;
 
alter table OpExecutable 
       add constraint FKn6n881daxoes4m1jmjmybor4y 
       foreign key (EmeExecutableId) 
       references OpEmeExecutable;
 
alter table OpFileAndEventConstraint 
       add constraint FKeyxv51r0ufj61m24wku8777m 
       foreign key (JobDefinitionId) 
       references OpJobDefinition;
 
alter table OpFileAndEventConstraint 
       add constraint FK6426q08fm01ultq8g5ul2x2io 
       foreign key (PropertyTypeId) 
       references OpPropertyType;
 
alter table OpFileSystem 
       add constraint FKk1o6ur8hu9b7rkxoxvn2ccp3n 
       foreign key (HostId) 
       references OpHost;
 
alter table OpFileSystemMetric 
       add constraint FKe211qe0w7lql8o9ip4dnu9ept 
       foreign key (FileSystemId) 
       references OpFileSystem;
 
alter table OpFileSystemMetricValue 
       add constraint FKefhmrbke9v6hjj6xc8n7d7k5y 
       foreign key (FileSystemMetricId) 
       references OpFileSystemMetric;
 
alter table OpGroupXref 
       add constraint FKnsceus2ues6hh1q9h6660xdbx 
       foreign key (ParentGroupId) 
       references OpPrincipal;
 
alter table OpGroupXref 
       add constraint FK4dk4e99w6vm2f4ljj3roopiqe 
       foreign key (ChildPrincipalId) 
       references OpPrincipal;
 
alter table OpHomeViewBox 
       add constraint FK1au4or6bwn2bmv275ia14q2uc 
       foreign key (HomeViewId) 
       references OpHomeView;
 
alter table OpHost 
       add constraint FK6pxxhbxnx4eyg84vsq7qpju36 
       foreign key (WarningNotificationGroupId) 
       references OpNotificationGroup;
 
alter table OpHost 
       add constraint FKfrocf12l5kpt8p9ykpi3l757g 
       foreign key (ErrorNotificationGroupId) 
       references OpNotificationGroup;
 
alter table OpHost 
       add constraint FK6q3t3oxkw9ug5ktdhjh6jdcqd 
       foreign key (FatalNotificationGroupId) 
       references OpNotificationGroup;
 
alter table OpHost 
       add constraint FK81x4ia1lxpc5xii088bw204nf 
       foreign key (HostClusterId) 
       references OpHost;
 
alter table OpHost 
       add constraint FKn3gq0uk9idjjtgrwnavc1fbeu 
       foreign key (PhysicalHostId) 
       references OpHost;
 
alter table OpHostMetric 
       add constraint FK5ovk29s5qkp3b0uuss5kjqw9i 
       foreign key (HostId) 
       references OpHost;
 
alter table OpHostMetricValue 
       add constraint FKnyba4hteseqrvjs2wk8pdtdoy 
       foreign key (HostMetricId) 
       references OpHostMetric;
 
alter table OpJob 
       add constraint FKryte4ef9b98pyway03ue994t9 
       foreign key (ApplicationId) 
       references OpApplication;
 
alter table OpJob 
       add constraint FKme88sr2rpdmjlbguyt74doma9 
       foreign key (ParentJobId) 
       references OpJob;
 
alter table OpJob 
       add constraint FKgb0kywo3kkkm7ool7ac46h3gd 
       foreign key (JobDefinitionId) 
       references OpJobDefinition;
 
alter table OpJob 
       add constraint FK4x5f4lc1bbxd1byakigqicdg 
       foreign key (ExecutableId) 
       references OpExecutable;
 
alter table OpJob 
       add constraint FK45aou1q6yltpf6pbbn1eh1bb1 
       foreign key (RerunSuccessorJobId) 
       references OpJob;
 
alter table OpJob 
       add constraint FKc38c9mppospavtgvq6rogiok0 
       foreign key (RerunPredecessorJobId) 
       references OpJob;
 
alter table OpJobDefinition 
       add constraint FKjamygtsh883or4w03pspxumo1 
       foreign key (ApplicationId) 
       references OpApplication;
 
alter table OpJobDefinition 
       add constraint FKmjg16wiu5c330j6mntdyovvf7 
       foreign key (RuntimeId) 
       references OpRuntime;
 
alter table OpJobDefinition 
       add constraint FK6q9s91u88wokobh9tusv5655d 
       foreign key (JobDefinitionGroupId) 
       references OpJobDefinition;
 
alter table OpJobDefinition 
       add constraint FKnfxldt2fyaoj877hpjobvovfl 
       foreign key (SuccessNotificationGroupId) 
       references OpNotificationGroup;
 
alter table OpJobDefinition 
       add constraint FK4vybvi3jvkm6usnxu789txwao 
       foreign key (WarningNotificationGroupId) 
       references OpNotificationGroup;
 
alter table OpJobDefinition 
       add constraint FKj6bencvu7xqur6501xshhrs55 
       foreign key (ErrorNotificationGroupId) 
       references OpNotificationGroup;
 
alter table OpJobDefinitionAction 
       add constraint FKaicpaly3wmew35gu3qxxtdpn5 
       foreign key (JobDefinitionId) 
       references OpJobDefinition;
 
alter table OpJobDefinitionActionArgument 
       add constraint FK1j1mmr7nlakd24hg4i3dpq1u7 
       foreign key (JobDefinitionActionId) 
       references OpJobDefinitionAction;
 
alter table OpJobDefinitionDependency 
       add constraint FKd9fimu675rh94yo0fxmmavrgc 
       foreign key (JobDefinitionId) 
       references OpJobDefinition;
 
alter table OpJobDefinitionPropertyValue 
       add constraint FKpo8nop1ypy9fhuvshrs9asbm4 
       foreign key (JobDefinitionId) 
       references OpJobDefinition;
 
alter table OpJobDefinitionPropertyValue 
       add constraint FK6k3bf9fx2s1fcgb2wrlgs1y0t 
       foreign key (PropertyTypeId) 
       references OpPropertyType;
 
alter table OpJobEvent 
       add constraint FK46o9dp9a3lnttt11pa37ho2ay 
       foreign key (JobId) 
       references OpJob;
 
alter table OpJobPropertyValue 
       add constraint FK1ebxtnscc18dmvkmtfel4cf8y 
       foreign key (JobId) 
       references OpJob;
 
alter table OpJobPropertyValue 
       add constraint FKdntbqa4i4wncug5qwye4c345l 
       foreign key (PropertyTypeId) 
       references OpPropertyType;
 
alter table OpKeyFile 
       add constraint FK4w9i06ubaolelk4cgoejlnsi9 
       foreign key (KeyId) 
       references OpKey;
 
alter table OpKeyServerReport 
       add constraint FK2xrnkcbm7714ysx1qwx304myy 
       foreign key (ProductId) 
       references OpProduct;
 
alter table OpMetric 
       add constraint FKb28q210jlj42tbswaxt6stk4c 
       foreign key (ExecutableId) 
       references OpExecutable;
 
alter table OpMetric 
       add constraint FKnbgnqfw3e7qapn21bhjx4cy3t 
       foreign key (EmeExecutableId) 
       references OpEmeExecutable;
 
alter table OpMetricValue 
       add constraint FKmmiurng5qel6n6v8wiueehnaf 
       foreign key (JobId) 
       references OpJob;
 
alter table OpMetricValue 
       add constraint FKli9jusdh24vepx5l0nglmgn6a 
       foreign key (MetricId) 
       references OpMetric;
 
alter table OpMetricValue 
       add constraint FKslcmi9t763y8l5es34qe7k4eo 
       foreign key (KeyId) 
       references OpKey;
 
alter table OpMetricValue 
       add constraint FK1ty7451rfhcsag9v0nesb22nf 
       foreign key (ApplicationId) 
       references OpApplication;
 
alter table OpMetricValue 
       add constraint FK8y27w9d7x359k7cnwtlfy0yj7 
       foreign key (SystemId) 
       references OpSystem;
 
alter table OpMetricValue 
       add constraint FKivvhfj1nvmxdoxd3apsdvj2x0 
       foreign key (ExecutableId) 
       references OpExecutable;
 
alter table OpMonitoredEvent 
       add constraint FK70yshhxuf8jnjc2gi9vlcr5uk 
       foreign key (SystemId) 
       references OpSystem;
 
alter table OpMonitoredEvent 
       add constraint FK4d28knr51jhkh2l5jfn1i6kg8 
       foreign key (ReporterId) 
       references OpReporter;
 
alter table OpMonitoredEvent 
       add constraint FKkf3i7vdebueiqk41idsrsn4e0 
       foreign key (ProductId) 
       references OpProduct;
 
alter table OpMonitoredEvent 
       add constraint FKh21l4ot9lyfor6uq3yv45v772 
       foreign key (HostId) 
       references OpHost;
 
alter table OpMonitoredStatus 
       add constraint FK8c31p3qvnq7ti7fds43ca6gii 
       foreign key (LastEventId) 
       references OpMonitoredEvent;
 
alter table OpMonitoredStatus 
       add constraint FKq1rgfe82j85asdsw5b50h7n4w 
       foreign key (SeverestEventId) 
       references OpMonitoredEvent;
 
alter table OpMonitoredStatus 
       add constraint FKnehhcev0cbdn84wi8pp676axw 
       foreign key (HostId) 
       references OpHost;
 
alter table OpMonitoredStatus 
       add constraint FKrrybo9f78euqjmh7yl2ss0w6l 
       foreign key (ProductId) 
       references OpProduct;
 
alter table OpMonitoredStatus 
       add constraint FKteg48m6ky3wkdc1cp2ivvs2bc 
       foreign key (ReporterId) 
       references OpReporter;
 
alter table OpMonitoredStatus 
       add constraint FKf4go69un31nj25swrwsgr4qrg 
       foreign key (SystemId) 
       references OpSystem;
 
alter table OpNotificationGroupRecipient 
       add constraint FK4185w3mulcvyewr3layxajfq1 
       foreign key (RecipientId) 
       references OpRecipient;
 
alter table OpNotificationGroupRecipient 
       add constraint FK7l4kih5xn6c0g33nrr5k808sa 
       foreign key (NotificationGroupId) 
       references OpNotificationGroup;
 
alter table OpOSAuthentication 
       add constraint FKkhrotlmhsuawhb64jvglgkwxa 
       foreign key (HostId) 
       references OpHost;
 
alter table OpPrivilege 
       add constraint FKiimwxq78w88nmjfr9bung2o2d 
       foreign key (PrincipalId) 
       references OpPrincipal;
 
alter table OpPrivilege 
       add constraint FK7yjy1dq3pxdbgqxak8b9tm4j2 
       foreign key (SystemId) 
       references OpSystem;
 
alter table OpProduct 
       add constraint FKsmpiwa7pwrlmoaf6yn4p8innp 
       foreign key (ProductTypeId) 
       references OpProductType;
 
alter table OpProduct 
       add constraint FKo152j20ftrguq9kd6t58eoycd 
       foreign key (HostId) 
       references OpHost;
 
alter table OpProduct 
       add constraint FK14ja326m0vi6bsdwxhe7lfhok 
       foreign key (WarningNotificationGroupId) 
       references OpNotificationGroup;
 
alter table OpProduct 
       add constraint FKhrphhg40gqdukkwn3bmnbvbkx 
       foreign key (ErrorNotificationGroupId) 
       references OpNotificationGroup;
 
alter table OpProduct 
       add constraint FKq48qupxdp2rk0gslh7h9s6g5s 
       foreign key (FatalNotificationGroupId) 
       references OpNotificationGroup;
 
alter table OpProductXref 
       add constraint FK4ij6847j66o3uekjkrlyxqw3y 
       foreign key (LeftProductId) 
       references OpProduct;
 
alter table OpProductXref 
       add constraint FK2huotylket4dff0ja7g8irayc 
       foreign key (RightProductId) 
       references OpProduct;
 
alter table OpPropertyType 
       add constraint FKpb7ap21sodo2uxnmoawh16sqo 
       foreign key (SystemId) 
       references OpSystem;
 
alter table OpQueue 
       add constraint FK6q02htq4sfo3sn2rsejamvebt 
       foreign key (HostId) 
       references OpHost;
 
alter table OpQueue 
       add constraint FKqv232547og7vbih7alhdjtkvw 
       foreign key (SystemId) 
       references OpSystem;
 
alter table OpQueue 
       add constraint FKes8fkpy2peo54oht7eag4wdu7 
       foreign key (WarningNotificationGroupId) 
       references OpNotificationGroup;
 
alter table OpQueue 
       add constraint FKdomo5ght0xr5d2honmvvxipog 
       foreign key (ErrorNotificationGroupId) 
       references OpNotificationGroup;
 
alter table OpQueueClient 
       add constraint FK3gybwnrpp0sm8489hr5ew7j8f 
       foreign key (QueueId) 
       references OpQueue;
 
alter table OpQueueClient 
       add constraint FKgl0qsapws57gk4yvy8o6e3w8u 
       foreign key (QueueSubscriberId) 
       references OpQueueSubscriber;
 
alter table OpQueueClient 
       add constraint FKp4fdvgf5wrmqy465ptpp3bwr7 
       foreign key (JobId) 
       references OpJob;
 
alter table OpQueueMetric 
       add constraint FKohtmlnaw1hltr3bknh8y15wdx 
       foreign key (QueueId) 
       references OpQueue;
 
alter table OpQueueMetric 
       add constraint FK4ghmtqvwvdm4kt2hbe5c0eqso 
       foreign key (QueueSubscriberId) 
       references OpQueueSubscriber;
 
alter table OpQueueMetricValue 
       add constraint FK99m0tb4fhl9fi8ohrj19bj45m 
       foreign key (QueueMetricId) 
       references OpQueueMetric;
 
alter table OpQueueStats 
       add constraint FKdh147844yh1k6gqat0yd30i2k 
       foreign key (QueueId) 
       references OpQueue;
 
alter table OpQueueSubscriber 
       add constraint FKk9wjbkpcr28yfdyrenpgxak4d 
       foreign key (QueueId) 
       references OpQueue;
 
alter table OpRecipientHeader 
       add constraint FKekn0l0d44xmo3lbbenmn5skbq 
       foreign key (RecipientId) 
       references OpRecipient;
 
alter table OpReporter 
       add constraint FKptip1tkucm4efk0veuu4ygm6j 
       foreign key (PhysicalHostId) 
       references OpHost;
 
alter table OpReporter 
       add constraint FKinynsh2b4q88emwciwb4i0akq 
       foreign key (ProductId) 
       references OpProduct;
 
alter table OpReporter 
       add constraint FK6bfovefxv4cllw6hy6mq1v263 
       foreign key (LogicalHostId) 
       references OpHost;
 
alter table OpReporter 
       add constraint FKs1k4765v2piti3iu3h2oks7e9 
       foreign key (ReporterConfigSetId) 
       references OpReporterConfigSet;
 
alter table OpReporterConfigItem 
       add constraint FKdyi1q8bnvo8yjmbk4eqah7gvo 
       foreign key (ReporterDefaultConfigItemId) 
       references OpReporterDefaultConfigItem;
 
alter table OpReporterConfigItem 
       add constraint FKfn2lk24trdsp8yycppk9hlki5 
       foreign key (ReporterConfigSetId) 
       references OpReporterConfigSet;
 
alter table OpReporterDirectory 
       add constraint FKbolhvku7wt6s93tt7y8wgkgho 
       foreign key (ReporterId) 
       references OpReporter;
 
alter table OpResourcePart 
       add constraint FK4ih4eaxqodwau0bt2pk6d43s1 
       foreign key (ResourceRequestId) 
       references OpResourceRequest;
 
alter table OpResourcePart 
       add constraint FKc1uvg9eqvbw9x89jnqyfwmtb1 
       foreign key (ResourceSettingId) 
       references OpResourceSetting;
 
alter table OpResourcePool 
       add constraint FKa1reo39pgvs37qvaalkdmdtnd 
       foreign key (ResourceServerId) 
       references OpResourceServer;
 
alter table OpResourceRequest 
       add constraint FKndw95jdnv9aaipau7pnf8wu64 
       foreign key (ResourceServerId) 
       references OpResourceServer;
 
alter table OpResourceServer 
       add constraint FKr6j8gtqxndq6ba24v5nq1v3cr 
       foreign key (ProductId) 
       references OpProduct;
 
alter table OpResourceSetting 
       add constraint FK2v4dt3hkpe4gyweqeuyojd0cu 
       foreign key (ResourcePoolId) 
       references OpResourcePool;
 
alter table OpRuntime 
       add constraint FKh9j023pv4vhjkdq6f7ohhm5c4 
       foreign key (OSAuthenticationId) 
       references OpOSAuthentication;
 
alter table OpRuntime 
       add constraint FK91f6p6or4iiv0ay5ldbot20ju 
       foreign key (BridgeId) 
       references OpBridge;
 
alter table OpRuntime 
       add constraint FK79o2xoov16babuwujmp6ks11j 
       foreign key (SystemId) 
       references OpSystem;
 
alter table OpTimeConstraint 
       add constraint FK9n4in5nmm36xytda9ukxilj88 
       foreign key (JobDefinitionId) 
       references OpJobDefinition;
 
alter table OpTimeConstraint 
       add constraint FKfkvdlbhber0as1joi8hgwh58y 
       foreign key (CalendarId) 
       references OpCalendar;
 
alter table OpZMVDenormalizedDay 
       add constraint FKs0tp2h8l8i44pvw97p6ttco6c 
       foreign key (JobId) 
       references OpJob;
 
alter table OpZMVDenormalizedDay 
       add constraint FKdt1m9cg6s92phsk2swa72itn6 
       foreign key (ApplicationId) 
       references OpApplication;
 
alter table OpZMVDenormalizedDay 
       add constraint FKav0n3tidhacdc7l0l1ee0nmex 
       foreign key (ExecutableId) 
       references OpExecutable;
 
alter table OpZMVDenormalizedDay 
       add constraint FK2d3xu46hrjn5v8oy4rrip9onu 
       foreign key (KeyId) 
       references OpKey;
 
alter table OpZMVDenormalizedDay 
       add constraint FKsgsnnswtmgmc3k1gsfrcu7o5k 
       foreign key (MetricId) 
       references OpMetric;
 
alter table OpZMVDifference 
       add constraint FK44536lkj3y99mqt7vqk8u9sw9 
       foreign key (JobId) 
       references OpJob;
 
alter table OpZMVDifference 
       add constraint FK2l9lnao4dop8ftqq8483dw8vf 
       foreign key (ApplicationId) 
       references OpApplication;
 
alter table OpZMVDifference 
       add constraint FK3hetm17drihbsk82b3n4rrbmk 
       foreign key (ExecutableId) 
       references OpExecutable;
 
alter table OpZMVDifference 
       add constraint FKm24ly70d5dnv1547ba45lx0kh 
       foreign key (KeyId) 
       references OpKey;
 
alter table OpZMVDifference 
       add constraint FKpboia9fdjshagewo4xbydpwk0 
       foreign key (MetricId) 
       references OpMetric;
-- create indexes
-- Generated at 2023-11-14 16:10:20.406709
\set ON_ERROR_STOP true
--start-script
-- ---------------------------------------------------
create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_app_warnnotifygrpid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opapplication'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_APP_WARNNOTIFYGRPID ON OpApplication (WarningNotificationGroupId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_app_errornotifygrpid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opapplication'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_APP_ERRORNOTIFYGRPID ON OpApplication (ErrorNotificationGroupId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_audit_updatestamp'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opaudit'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_AUDIT_UPDATESTAMP ON OpAudit (UpdateStamp)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_bridge_hostid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opbridge'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_BRIDGE_HOSTID ON OpBridge (HostId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_osauthentication_hostid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'oposauthentication'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_OSAUTHENTICATION_HOSTID ON OpOSAuthentication (HostId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_runtime_osauthenticationid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opruntime'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_RUNTIME_OSAUTHENTICATIONID ON OpRuntime (OSAuthenticationId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_runtime_bridgeid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opruntime'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_RUNTIME_BRIDGEID ON OpRuntime (BridgeId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_host_physicalhostid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'ophost'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_HOST_PHYSICALHOSTID ON OpHost (PhysicalHostId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_fsmv_colltime'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opfilesystemmetricvalue'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_FSMV_COLLTIME ON OpFileSystemMetricValue (CollectionTime)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_host_mv_colltime'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'ophostmetricvalue'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_HOST_MV_COLLTIME ON OpHostMetricValue (CollectionTime)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_jhr_label'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjamonhourlyreport'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JHR_LABEL ON OpJamonHourlyReport (Label)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_jhr_nodeidentifier'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjamonhourlyreport'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JHR_NODEIDENTIFIER ON OpJamonHourlyReport (NodeIdentifier)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_jhr_lni'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjamonhourlyreport'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JHR_LNI ON OpJamonHourlyReport (Label, NodeIdentifier)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_jpr_label'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjamonpfsreport'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JPR_LABEL ON OpJamonPFSReport (Label)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_jpr_nodeidentifier'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjamonpfsreport'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JPR_NODEIDENTIFIER ON OpJamonPFSReport (NodeIdentifier)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_executable_hostname'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opexecutable'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_EXECUTABLE_HOSTNAME ON OpExecutable (Hostname)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_executable_prototype'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opexecutable'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_EXECUTABLE_PROTOTYPE ON OpExecutable (PrototypeExecutableId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_metricval_jobidctime'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opmetricvalue'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_METRICVAL_JOBIDCTIME ON OpMetricValue (JobId, CollectionTime)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_metricval_midsummctime'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opmetricvalue'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_METRICVAL_MIDSUMMCTIME ON OpMetricValue (MetricId, IsSummary, CollectionTime)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_metricval_midsummval'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opmetricvalue'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_METRICVAL_MIDSUMMVAL ON OpMetricValue (MetricId, IsSummary, Value)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_metricvalue_metricid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opmetricvalue'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_METRICVALUE_METRICID ON OpMetricValue (MetricId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_mv_jgaeseisctsshhmm'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opmetricvalue'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_MV_JGAESEISCTSSHHMM ON OpMetricValue (JobDefinitionGuid, ActionEnum, StateEnum, MetricId, IsSummary, CollectionTime, ScheduledStartTimeHHMM)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_mv_midsumexecoljidjgv'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opmetricvalue'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_MV_MIDSUMEXECOLJIDJGV ON OpMetricValue (MetricId, IsSummary, ExecutableId, CollectionTime, JobId, JobGuid, Value)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_mv_jgaesemidisctjgvsstjid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opmetricvalue'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_MV_JGAESEMIDISCTJGVSSTJID ON OpMetricValue (JobDefinitionGuid, ActionEnum, StateEnum, MetricId, IsSummary, CollectionTime, JobGuid, Value, ScheduledStartTime, JobId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_mv_jdgeisemiisctssthhmm'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opmetricvalue'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_MV_JDGEISEMIISCTSSTHHMM ON OpMetricValue (JobDefinitionGuid, ExecutableId, StateEnum, MetricId, IsSummary, CollectionTime, ScheduledStartTimeHHMM, ScheduledStartTime, JobId, JobGuid, Value)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_mv_bucket'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opmetricvalue'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_MV_BUCKET ON OpMetricValue (Bucket)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_mv_keyid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opmetricvalue'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_MV_KEYID ON OpMetricValue (KeyId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_job_toplevel_effshdstart'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjob'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JOB_TOPLEVEL_EFFSHDSTART ON OpJob (ParentJobId, RerunSuccessorJobId, IsSupportsDependencies, EffectiveScheduledStartTime)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_job_toplevel_stateendtime'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjob'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JOB_TOPLEVEL_STATEENDTIME ON OpJob (ParentJobId, RerunSuccessorJobId, IsSupportsDependencies, StateEnum, EndTime)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_derived_name'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjob'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_DERIVED_NAME ON OpJob (DerivedName)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_eff_scheduled_start_time'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjob'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_EFF_SCHEDULED_START_TIME ON OpJob (EffectiveScheduledStartTime)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_job_end_start_abworkdir'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjob'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JOB_END_START_ABWORKDIR ON OpJob (EndTime, StartTime, AbWorkDir)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_job_executableid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjob'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JOB_EXECUTABLEID ON OpJob (ExecutableId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_job_exeidendtime'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjob'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JOB_EXEIDENDTIME ON OpJob (ExecutableId, EndTime)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_job_exestatestartend'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjob'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JOB_EXESTATESTARTEND ON OpJob (ExecutableId, StateEnum, StartTime, EndTime)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_job_exeschedstartend'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjob'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JOB_EXESCHEDSTARTEND ON OpJob (ExecutableId, ScheduledStartTime, StartTime, EndTime)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_job_jobdefinitionid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjob'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JOB_JOBDEFINITIONID ON OpJob (JobDefinitionId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_job_jobenum_estart_etime'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjob'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JOB_JOBENUM_ESTART_ETIME ON OpJob (JobEnum, EffectiveScheduledStartTime, EndTime)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_parent_job_id'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjob'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_PARENT_JOB_ID ON OpJob (ParentJobId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_job_appvwprjb_vwendstart'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjob'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JOB_APPVWPRJB_VWENDSTART ON OpJob (ApplicationId, ViewParentJobId, ViewEnd, ViewStart)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_job_hstvwprjb_vwendstart'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjob'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JOB_HSTVWPRJB_VWENDSTART ON OpJob (ResolvedHostname, ViewParentJobId, ViewEnd, ViewStart)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_job_parrrsuccetypestart'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjob'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JOB_PARRRSUCCETYPESTART ON OpJob (ParentJobId, RerunSuccessorJobId, JobEnum, EffectiveScheduledStartTime)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_job_rerunpredecessorjobid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjob'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JOB_RERUNPREDECESSORJOBID ON OpJob (RerunPredecessorJobId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_job_rerunsuccessorjobid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjob'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JOB_RERUNSUCCESSORJOBID ON OpJob (RerunSuccessorJobId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_scheduled_start_time'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjob'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_SCHEDULED_START_TIME ON OpJob (ScheduledStartTime)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_severest_event_guid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjob'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_SEVEREST_EVENT_GUID ON OpJob (SeverestEventGuid)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_job_vwparjob_viewendstart'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjob'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JOB_VWPARJOB_VIEWENDSTART ON OpJob (ViewParentJobId, ViewEnd, ViewStart)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_job_vwparjob_viewstart'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjob'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JOB_VWPARJOB_VIEWSTART ON OpJob (ViewParentJobId, ViewStart)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_job_starttime'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjob'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JOB_STARTTIME ON OpJob (StartTime)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_job_stateenum'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjob'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JOB_STATEENUM ON OpJob (StateEnum)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_job_vmid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjob'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JOB_VMID ON OpJob (Vmid)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_job_rerun'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjob'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JOB_RERUN ON OpJob (RerunGuid, EndTime, StateEnum)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_job_reparent'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjob'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JOB_REPARENT ON OpJob (JobDefinitionId, ViewParentJobId, StateEnum, IsIssuesIgnored, ViewEnd)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_job_testsetguid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjob'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JOB_TESTSETGUID ON OpJob (TestSetGuid)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_jobevent_jobid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjobevent'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JOBEVENT_JOBID ON OpJobEvent (JobId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_jobcompletion_endtime'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjobcompletion'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JOBCOMPLETION_ENDTIME ON OpJobCompletion (EndTime)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_jobcompletion_updatestamp'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjobcompletion'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JOBCOMPLETION_UPDATESTAMP ON OpJobCompletion (UpdateStamp)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_monev_mguidevt'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opmonitoredevent'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_MONEV_MGUIDEVT ON OpMonitoredEvent (MonitoredObjectGuid, EventTime)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_monev_mguilifevt'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opmonitoredevent'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_MONEV_MGUILIFEVT ON OpMonitoredEvent (MonitoredObjectGuid, LifecycleState, EventTime)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_monev_evt'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opmonitoredevent'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_MONEV_EVT ON OpMonitoredEvent (EventTime)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_monev_hostid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opmonitoredevent'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_MONEV_HOSTID ON OpMonitoredEvent (HostId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_monev_reporterid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opmonitoredevent'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_MONEV_REPORTERID ON OpMonitoredEvent (ReporterId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_monev_productid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opmonitoredevent'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_MONEV_PRODUCTID ON OpMonitoredEvent (ProductId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_monev_systemid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opmonitoredevent'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_MONEV_SYSTEMID ON OpMonitoredEvent (SystemId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_monev_errorcode'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opmonitoredevent'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_MONEV_ERRORCODE ON OpMonitoredEvent (ErrorCode)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_monst_hostid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opmonitoredstatus'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_MONST_HOSTID ON OpMonitoredStatus (HostId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_monst_reporterid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opmonitoredstatus'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_MONST_REPORTERID ON OpMonitoredStatus (ReporterId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_monst_productid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opmonitoredstatus'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_MONST_PRODUCTID ON OpMonitoredStatus (ProductId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_monst_systemid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opmonitoredstatus'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_MONST_SYSTEMID ON OpMonitoredStatus (SystemId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_monst_sevevtid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opmonitoredstatus'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_MONST_SEVEVTID ON OpMonitoredStatus (SeverestEventId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_monst_lastevtid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opmonitoredstatus'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_MONST_LASTEVTID ON OpMonitoredStatus (LastEventId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_product_hostid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opproduct'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_PRODUCT_HOSTID ON OpProduct (HostId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_queue_systemid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opqueue'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_QUEUE_SYSTEMID ON OpQueue (SystemId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_queue_warnnotifygrpid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opqueue'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_QUEUE_WARNNOTIFYGRPID ON OpQueue (WarningNotificationGroupId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_queue_errornotifygrpid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opqueue'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_QUEUE_ERRORNOTIFYGRPID ON OpQueue (ErrorNotificationGroupId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_queueclient_queueid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opqueueclient'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_QUEUECLIENT_QUEUEID ON OpQueueClient (QueueId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_queueclient_subsid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opqueueclient'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_QUEUECLIENT_SUBSID ON OpQueueClient (QueueSubscriberId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_queueclient_jobid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opqueueclient'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_QUEUECLIENT_JOBID ON OpQueueClient (JobId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_queuesubs_queueid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opqueuesubscriber'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_QUEUESUBS_QUEUEID ON OpQueueSubscriber (QueueId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_queuemetric_queueid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opqueuemetric'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_QUEUEMETRIC_QUEUEID ON OpQueueMetric (QueueId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_queuemetric_subsid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opqueuemetric'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_QUEUEMETRIC_SUBSID ON OpQueueMetric (QueueSubscriberId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_rspool_rsserver'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opresourcepool'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_RSPOOL_RSSERVER ON OpResourcePool (ResourceServerId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_rssetting_rspool'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opresourcesetting'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_RSSETTING_RSPOOL ON OpResourceSetting (ResourcePoolId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_rsrequest_rsserver'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opresourcerequest'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_RSREQUEST_RSSERVER ON OpResourceRequest (ResourceServerId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_rspart_rsrequest'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opresourcepart'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_RSPART_RSREQUEST ON OpResourcePart (ResourceRequestId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_rspart_rssetting'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opresourcepart'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_RSPART_RSSETTING ON OpResourcePart (ResourceSettingId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_jobdef_name'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjobdefinition'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JOBDEF_NAME ON OpJobDefinition (Name)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_jobdef_application'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjobdefinition'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JOBDEF_APPLICATION ON OpJobDefinition (ApplicationId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_jobdef_runtime'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjobdefinition'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JOBDEF_RUNTIME ON OpJobDefinition (RuntimeId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_jobdef_jobdefgrp'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjobdefinition'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JOBDEF_JOBDEFGRP ON OpJobDefinition (JobDefinitionGroupId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_jobdef_discrimeffsstime'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjobdefinition'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JOBDEF_DISCRIMEFFSSTIME ON OpJobDefinition (JobDefinitionDiscriminator, EffectiveScheduledStartTime)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_feconstraint_jdid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opfileandeventconstraint'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_FECONSTRAINT_JDID ON OpFileAndEventConstraint (JobDefinitionId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_filebatch_property_type'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opfileandeventconstraint'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_FILEBATCH_PROPERTY_TYPE ON OpFileAndEventConstraint (PropertyTypeId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_timeconstraint_calendarid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'optimeconstraint'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_TIMECONSTRAINT_CALENDARID ON OpTimeConstraint (CalendarId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_jdaction_jdid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opjobdefinitionaction'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_JDACTION_JDID ON OpJobDefinitionAction (JobDefinitionId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_groupxref_parentgroupid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opgroupxref'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_GROUPXREF_PARENTGROUPID ON OpGroupXref (ParentGroupId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from pg_class where relname = 'idx_privilege_systemid'
    and relkind = 'i'
    and oid in (
       select indexrelid from pg_index idx, pg_class tbl
       where tbl.relname = 'opprivilege'
         and idx.indrelid = tbl.oid
         and idx.indisunique != 't'
         and idx.indisprimary != 't');
  if (cnt = 0) then
    execute E'CREATE INDEX IDX_PRIVILEGE_SYSTEMID ON OpPrivilege (SystemId)';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


--end-script
-- populate database with default data
-- Generated at 2024-02-09 07:05:47.782181
\set ON_ERROR_STOP true
--start-script
-- ---------------------------------------------------
create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpSystem (SystemId, SystemGuid, Name, Description, UpdateStamp, ProductionDayHHMM, TimeZoneId, ExcludeJobColumns, ExcludeJobDefinitionColumns , IsAutoGenEnabled, AutoGenRangeMins, AutoGenOffsetMins, AutoGenDailyFrequency) values (nextval(''hibernate_sequence''),  ''sys:DEFAULT:20240209070547'', ''DEFAULT'', ''Default system'', to_timestamp(''1970-01-01 00:00:00.000'', ''YYYY-MM-DD HH24:MI:SS.MS''), ''00:00'', ''UTC'', ''End,Host Cluster,Job Definition,Job Definition Group,Job GUID'','''' , ''Y'', 1440, 30, 1)';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpApplication (ApplicationId, SystemId, Name, Description, IsApplicationNeverAutoGen) select nextval(''hibernate_sequence''),  SystemId, ''DEFAULT'', ''Default Application'', ''N'' from OpSystem where Name = ''DEFAULT''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpAutoGenStats (AutoGenStatsId, SystemId) select nextval(''hibernate_sequence''),  SystemId from OpSystem';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpMonitoredStatus (MonitoredStatusId, StatusTypeDiscriminator, SystemId)  select nextval(''hibernate_sequence''), ''SYSTEM'', s.SystemId from OpSystem s  left outer join OpMonitoredStatus oms on s.SystemId = oms.SystemId  where oms.SystemId is null';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


-- ---------------------------------------------------
create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPropertyType (PropertyTypeId, PropertyTypeDiscriminator, SystemId, Name, Description, ColumnSequence, CustomTypeEnum) select nextval(''hibernate_sequence''),  ''CUSTOM'', SystemId, ''PROCESS_REGION'', ''Region'', 10, ''STRING'' from OpSystem where Name = ''DEFAULT''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPropertyType (PropertyTypeId, PropertyTypeDiscriminator, SystemId, Name, Description, ColumnSequence, DefaultValue, BuiltinPropertyExpression) select nextval(''hibernate_sequence''),  ''BUILTIN'', SystemId, ''BOOK_DATE'', ''Book Date'', 60, ''Unknown Book Date'', ''timeConstraint.calendar.bookDate'' from OpSystem where Name = ''DEFAULT''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


-- ---------------------------------------------------
create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpJobSet  (JobSetId, UpdateStamp, JobSetGuid, Name, IsMonitored, SystemId, GroupByName, BadStatusTypeEnum, IssuesSeverityOrderEnum, OrderByName, IsOrderAscending, IsShowOrderByLabel, JobMax)   select nextval(''hibernate_sequence''),    current_timestamp at time zone ''UTC'',  ''JobSet.'' ||  SystemGuid, ''All jobs in ''  ||  Name,  ''Y'', SystemId, ''Application'', ''FAILED_JOBS'', ''ALL_ACTUAL_HIGHER'', ''Start'', ''N'', ''Y'', 0 from OpSystem ';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


-- ---------------------------------------------------
create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpQuickLink (QuickLinkId, Name, Description, Url, IconName, IsHidden, Sequence) values (nextval(''hibernate_sequence''),  '''', ''Last Viewed Queues'', ''area=jobs&silo=system&subarea=queues'', ''ViewQueues'', ''N'', 0)';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpQuickLink (QuickLinkId, Name, Description, Url, IconName, IsHidden, Sequence) values (nextval(''hibernate_sequence''),  '''', ''Last Viewed Resources'', ''area=jobs&silo=system&subarea=resources'', ''ViewResources'', ''N'', 1)';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpQuickLink (QuickLinkId, Name, Description, Url, IconName, IsHidden, Sequence) values (nextval(''hibernate_sequence''),  '''', ''Last Viewed Schedule'', ''area=jobs&silo=system&subarea=schedule'', ''ViewSchedule'', ''N'', 2)';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


-- ---------------------------------------------------
create or replace function anonymous() returns void as $$
begin
  execute E'DELETE FROM OpAnalysisRowSQL';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'DELETE FROM OpAnalysisAggregatorSQL';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'DELETE FROM OpAnalysisRow';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'DELETE FROM OpAnalysisAggregator';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'DELETE FROM OpAnalysisObject';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisObject (AnalysisObjectId, Name, TableName, BucketSQL) VALUES (nextval(''hibernate_sequence''),  ''Jobs'', ''OpMetricValue'', ''OpMetricValue.Bucket'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRow (AnalysisRowId, AnalysisObjectId, Name) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Jobs''), ''System'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRow (AnalysisRowId, AnalysisObjectId, Name) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Jobs''), ''Host'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRow (AnalysisRowId, AnalysisObjectId, Name) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Jobs''), ''Application'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRow (AnalysisRowId, AnalysisObjectId, Name) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Jobs''), ''User'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRow (AnalysisRowId, AnalysisObjectId, Name) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Jobs''), ''Executable'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRow (AnalysisRowId, AnalysisObjectId, Name) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Jobs''), ''Type'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRow (AnalysisRowId, AnalysisObjectId, Name) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Jobs''), ''WorkingDirectory'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRow (AnalysisRowId, AnalysisObjectId, Name) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Jobs''), ''AB_WORK_DIR'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRow (AnalysisRowId, AnalysisObjectId, Name) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Jobs''), ''AB_HOME'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRow (AnalysisRowId, AnalysisObjectId, Name) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Jobs''), ''JobDefinition'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRowSQL(AnalysisRowSQLId, AnalysisRowId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisRowId FROM OpAnalysisRow JOIN OpAnalysisObject ON OpAnalysisRow.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Jobs'' AND OpAnalysisRow.Name = ''System''), ''OpSystem'', ''SystemId'', ''OpMetricValue'', ''SystemId'', ''LEFT OUTER JOIN'', ''COALESCE(OpSystem.Name, ''''null'''')'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRowSQL(AnalysisRowSQLId, AnalysisRowId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisRowId FROM OpAnalysisRow JOIN OpAnalysisObject ON OpAnalysisRow.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Jobs'' AND OpAnalysisRow.Name = ''Host''), ''OpExecutable'', ''ExecutableId'', ''OpMetricValue'', ''ExecutableId'', ''LEFT OUTER JOIN'', ''COALESCE(OpMetricValue.Hostname, OpExecutable.Hostname, ''''null'''')'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRowSQL(AnalysisRowSQLId, AnalysisRowId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisRowId FROM OpAnalysisRow JOIN OpAnalysisObject ON OpAnalysisRow.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Jobs'' AND OpAnalysisRow.Name = ''Application''), ''OpApplication'', ''ApplicationId'', ''OpMetricValue'', ''ApplicationId'', ''LEFT OUTER JOIN'', ''COALESCE(OpApplication.Name, ''''null'''')'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRowSQL(AnalysisRowSQLId, AnalysisRowId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisRowId FROM OpAnalysisRow JOIN OpAnalysisObject ON OpAnalysisRow.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Jobs'' AND OpAnalysisRow.Name = ''User''), ''OpJob'', ''JobId'', ''OpMetricValue'', ''JobId'', ''LEFT OUTER JOIN'', ''COALESCE(OpJob.Username, ''''null'''')'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRowSQL(AnalysisRowSQLId, AnalysisRowId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisRowId FROM OpAnalysisRow JOIN OpAnalysisObject ON OpAnalysisRow.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Jobs'' AND OpAnalysisRow.Name = ''Executable''), ''OpExecutable'', ''ExecutableId'', ''OpMetricValue'', ''ExecutableId'', ''LEFT OUTER JOIN'', ''COALESCE(OpExecutable.ExpandedPath, ''''null'''')'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRowSQL(AnalysisRowSQLId, AnalysisRowId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisRowId FROM OpAnalysisRow JOIN OpAnalysisObject ON OpAnalysisRow.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Jobs'' AND OpAnalysisRow.Name = ''Type''), ''OpExecutable'', ''ExecutableId'', ''OpMetricValue'', ''ExecutableId'', ''LEFT OUTER JOIN'', ''COALESCE(OpExecutable.ExecutableEnum, ''''null'''')'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRowSQL(AnalysisRowSQLId, AnalysisRowId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisRowId FROM OpAnalysisRow JOIN OpAnalysisObject ON OpAnalysisRow.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Jobs'' AND OpAnalysisRow.Name = ''WorkingDirectory''), ''OpJob'', ''JobId'', ''OpMetricValue'', ''JobId'', ''LEFT OUTER JOIN'', ''COALESCE(OpJob.WorkingDirectory, ''''null'''')'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRowSQL(AnalysisRowSQLId, AnalysisRowId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisRowId FROM OpAnalysisRow JOIN OpAnalysisObject ON OpAnalysisRow.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Jobs'' AND OpAnalysisRow.Name = ''AB_WORK_DIR''), ''OpJob'', ''JobId'', ''OpMetricValue'', ''JobId'', ''LEFT OUTER JOIN'', ''COALESCE(OpJob.AbWorkDir, ''''null'''')'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRowSQL(AnalysisRowSQLId, AnalysisRowId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisRowId FROM OpAnalysisRow JOIN OpAnalysisObject ON OpAnalysisRow.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Jobs'' AND OpAnalysisRow.Name = ''AB_HOME''), ''OpJob'', ''JobId'', ''OpMetricValue'', ''JobId'', ''LEFT OUTER JOIN'', ''COALESCE(OpJob.AbHome, ''''null'''')'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRowSQL(AnalysisRowSQLId, AnalysisRowId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisRowId FROM OpAnalysisRow JOIN OpAnalysisObject ON OpAnalysisRow.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Jobs'' AND OpAnalysisRow.Name = ''JobDefinition''), ''OpJob'', ''JobId'', ''OpMetricValue'', ''JobId'', ''LEFT OUTER JOIN'', null)';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRowSQL(AnalysisRowSQLId, AnalysisRowId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisRowId FROM OpAnalysisRow JOIN OpAnalysisObject ON OpAnalysisRow.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Jobs'' AND OpAnalysisRow.Name = ''JobDefinition''), ''OpJobDefinition'', ''JobDefinitionId'', ''OpJob'', ''JobDefinitionId'', ''LEFT OUTER JOIN'', ''COALESCE(OpJobDefinition.Name, ''''null'''')'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregator(AnalysisAggregatorId, AnalysisObjectId, MetricName, Name, Units, AggregationType) VALUES(nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Jobs''), ''Startup CPU'', ''Startup CPU'', ''seconds'', ''SUM'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregator(AnalysisAggregatorId, AnalysisObjectId, MetricName, Name, Units, AggregationType) VALUES(nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Jobs''), ''System CPU'', ''System CPU'', ''seconds'', ''SUM'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregator(AnalysisAggregatorId, AnalysisObjectId, MetricName, Name, Units, AggregationType) VALUES(nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Jobs''), ''Total CPU'', ''Total CPU'', ''seconds'', ''SUM'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregator(AnalysisAggregatorId, AnalysisObjectId, MetricName, Name, Units, AggregationType) VALUES(nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Jobs''), ''Total read'', ''Total read'', ''kilobytes'', ''SUM'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregator(AnalysisAggregatorId, AnalysisObjectId, MetricName, Name, Units, AggregationType) VALUES(nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Jobs''), ''Total read, records'', ''Total read, records'', ''records'', ''SUM'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregator(AnalysisAggregatorId, AnalysisObjectId, MetricName, Name, Units, AggregationType) VALUES(nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Jobs''), ''Total rejected'', ''Total rejected'', ''records'', ''SUM'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregator(AnalysisAggregatorId, AnalysisObjectId, MetricName, Name, Units, AggregationType) VALUES(nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Jobs''), ''Total written'', ''Total written'', ''kilobytes'', ''SUM'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregator(AnalysisAggregatorId, AnalysisObjectId, MetricName, Name, Units, AggregationType) VALUES(nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Jobs''), ''Total written, records'', ''Total written, records'', ''records'', ''SUM'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregator(AnalysisAggregatorId, AnalysisObjectId, MetricName, Name, Units, AggregationType) VALUES(nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Jobs''), ''User CPU'', ''User CPU'', ''seconds'', ''SUM'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregator(AnalysisAggregatorId, AnalysisObjectId, MetricName, Name, Units, AggregationType) VALUES(nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Jobs''), ''Job Count'', ''Job Count'', ''count'', ''SUM'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregatorSQL(AnalysisAggregatorSQLId, AnalysisAggregatorId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, AggregatorSQL, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisAggregatorId FROM OpAnalysisAggregator JOIN OpAnalysisObject ON OpAnalysisAggregator.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Jobs'' AND OpAnalysisAggregator.Name = ''Startup CPU''), ''OpMetric'', ''MetricId'', ''OpMetricValue'', ''MetricId'', ''JOIN'', ''SUM(OpMetricValue.Value)'', ''OpMetric.Name'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregatorSQL(AnalysisAggregatorSQLId, AnalysisAggregatorId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, AggregatorSQL, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisAggregatorId FROM OpAnalysisAggregator JOIN OpAnalysisObject ON OpAnalysisAggregator.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Jobs'' AND OpAnalysisAggregator.Name = ''System CPU''), ''OpMetric'', ''MetricId'', ''OpMetricValue'', ''MetricId'', ''JOIN'', ''SUM(OpMetricValue.Value)'', ''OpMetric.Name'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregatorSQL(AnalysisAggregatorSQLId, AnalysisAggregatorId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, AggregatorSQL, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisAggregatorId FROM OpAnalysisAggregator JOIN OpAnalysisObject ON OpAnalysisAggregator.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Jobs'' AND OpAnalysisAggregator.Name = ''Total CPU''), ''OpMetric'', ''MetricId'', ''OpMetricValue'', ''MetricId'', ''JOIN'', ''SUM(OpMetricValue.Value)'', ''OpMetric.Name'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregatorSQL(AnalysisAggregatorSQLId, AnalysisAggregatorId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, AggregatorSQL, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisAggregatorId FROM OpAnalysisAggregator JOIN OpAnalysisObject ON OpAnalysisAggregator.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Jobs'' AND OpAnalysisAggregator.Name = ''Total read''), ''OpMetric'', ''MetricId'', ''OpMetricValue'', ''MetricId'', ''JOIN'', ''SUM(OpMetricValue.Value)'', ''OpMetric.Name'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregatorSQL(AnalysisAggregatorSQLId, AnalysisAggregatorId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, AggregatorSQL, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisAggregatorId FROM OpAnalysisAggregator JOIN OpAnalysisObject ON OpAnalysisAggregator.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Jobs'' AND OpAnalysisAggregator.Name = ''Total read, records''), ''OpMetric'', ''MetricId'', ''OpMetricValue'', ''MetricId'', ''JOIN'', ''SUM(OpMetricValue.Value)'', ''OpMetric.Name'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregatorSQL(AnalysisAggregatorSQLId, AnalysisAggregatorId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, AggregatorSQL, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisAggregatorId FROM OpAnalysisAggregator JOIN OpAnalysisObject ON OpAnalysisAggregator.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Jobs'' AND OpAnalysisAggregator.Name = ''Total rejected''), ''OpMetric'', ''MetricId'', ''OpMetricValue'', ''MetricId'', ''JOIN'', ''SUM(OpMetricValue.Value)'', ''OpMetric.Name'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregatorSQL(AnalysisAggregatorSQLId, AnalysisAggregatorId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, AggregatorSQL, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisAggregatorId FROM OpAnalysisAggregator JOIN OpAnalysisObject ON OpAnalysisAggregator.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Jobs'' AND OpAnalysisAggregator.Name = ''Total written''), ''OpMetric'', ''MetricId'', ''OpMetricValue'', ''MetricId'', ''JOIN'', ''SUM(OpMetricValue.Value)'', ''OpMetric.Name'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregatorSQL(AnalysisAggregatorSQLId, AnalysisAggregatorId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, AggregatorSQL, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisAggregatorId FROM OpAnalysisAggregator JOIN OpAnalysisObject ON OpAnalysisAggregator.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Jobs'' AND OpAnalysisAggregator.Name = ''Total written, records''), ''OpMetric'', ''MetricId'', ''OpMetricValue'', ''MetricId'', ''JOIN'', ''SUM(OpMetricValue.Value)'', ''OpMetric.Name'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregatorSQL(AnalysisAggregatorSQLId, AnalysisAggregatorId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, AggregatorSQL, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisAggregatorId FROM OpAnalysisAggregator JOIN OpAnalysisObject ON OpAnalysisAggregator.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Jobs'' AND OpAnalysisAggregator.Name = ''User CPU''), ''OpMetric'', ''MetricId'', ''OpMetricValue'', ''MetricId'', ''JOIN'', ''SUM(OpMetricValue.Value)'', ''OpMetric.Name'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregatorSQL(AnalysisAggregatorSQLId, AnalysisAggregatorId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, AggregatorSQL, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisAggregatorId FROM OpAnalysisAggregator JOIN OpAnalysisObject ON OpAnalysisAggregator.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Jobs'' AND OpAnalysisAggregator.Name = ''Job Count''), ''OpJob'', ''JobId'', ''OpMetricValue'', ''JobId'', ''JOIN'', ''COUNT(DISTINCT OpMetricValue.JobId)'', null)';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisObject (AnalysisObjectId, Name, TableName, BucketSQL) VALUES (nextval(''hibernate_sequence''),  ''Hosts'', ''OpHostMetricValue'', ''BUCKET OpHostMetricValue.CollectionTime'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRow (AnalysisRowId, AnalysisObjectId, Name) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Hosts''), ''Hostname'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRow (AnalysisRowId, AnalysisObjectId, Name) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Hosts''), ''Category'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRow (AnalysisRowId, AnalysisObjectId, Name) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Hosts''), ''OperatingSystem'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRowSQL(AnalysisRowSQLId, AnalysisRowId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisRowId FROM OpAnalysisRow JOIN OpAnalysisObject ON OpAnalysisRow.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Hosts'' AND OpAnalysisRow.Name = ''Hostname''), ''OpHostMetric'', ''HostMetricId'', ''OpHostMetricValue'', ''HostMetricId'', ''JOIN'', null)';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRowSQL(AnalysisRowSQLId, AnalysisRowId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisRowId FROM OpAnalysisRow JOIN OpAnalysisObject ON OpAnalysisRow.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Hosts'' AND OpAnalysisRow.Name = ''Hostname''), ''OpHost'', ''HostId'', ''OpHostMetric'', ''HostId'', ''JOIN'', ''COALESCE(OpHost.Hostname, ''''null'''')'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRowSQL(AnalysisRowSQLId, AnalysisRowId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisRowId FROM OpAnalysisRow JOIN OpAnalysisObject ON OpAnalysisRow.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Hosts'' AND OpAnalysisRow.Name = ''Category''), ''OpHostMetric'', ''HostMetricId'', ''OpHostMetricValue'', ''HostMetricId'', ''JOIN'', null)';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRowSQL(AnalysisRowSQLId, AnalysisRowId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisRowId FROM OpAnalysisRow JOIN OpAnalysisObject ON OpAnalysisRow.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Hosts'' AND OpAnalysisRow.Name = ''Category''), ''OpHost'', ''HostId'', ''OpHostMetric'', ''HostId'', ''JOIN'', ''COALESCE(OpHost.Tag, ''''null'''')'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRowSQL(AnalysisRowSQLId, AnalysisRowId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisRowId FROM OpAnalysisRow JOIN OpAnalysisObject ON OpAnalysisRow.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Hosts'' AND OpAnalysisRow.Name = ''OperatingSystem''), ''OpHostMetric'', ''HostMetricId'', ''OpHostMetricValue'', ''HostMetricId'', ''JOIN'', null)';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRowSQL(AnalysisRowSQLId, AnalysisRowId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisRowId FROM OpAnalysisRow JOIN OpAnalysisObject ON OpAnalysisRow.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Hosts'' AND OpAnalysisRow.Name = ''OperatingSystem''), ''OpHost'', ''HostId'', ''OpHostMetric'', ''HostId'', ''JOIN'', ''COALESCE(OpHost.OperatingSystem, ''''null'''')'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregator(AnalysisAggregatorId, AnalysisObjectId, MetricName, Name, Units, AggregationType) VALUES(nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Hosts''), ''cpuTotalUsage'', ''Average Total CPU'', ''percent'', ''AVG'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregator(AnalysisAggregatorId, AnalysisObjectId, MetricName, Name, Units, AggregationType) VALUES(nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Hosts''), ''cpuUsageIdle'', ''Average Idle CPU'', ''percent'', ''AVG'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregator(AnalysisAggregatorId, AnalysisObjectId, MetricName, Name, Units, AggregationType) VALUES(nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Hosts''), ''cpuUsageSystem'', ''Average System CPU'', ''percent'', ''AVG'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregator(AnalysisAggregatorId, AnalysisObjectId, MetricName, Name, Units, AggregationType) VALUES(nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Hosts''), ''cpuUsageUser'', ''Average User CPU'', ''percent'', ''AVG'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregator(AnalysisAggregatorId, AnalysisObjectId, MetricName, Name, Units, AggregationType) VALUES(nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Hosts''), ''cpuTotalUsage'', ''Max Total CPU'', ''percent'', ''MAX'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregator(AnalysisAggregatorId, AnalysisObjectId, MetricName, Name, Units, AggregationType) VALUES(nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Hosts''), ''cpuUsageIdle'', ''Max Idle CPU'', ''percent'', ''MAX'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregator(AnalysisAggregatorId, AnalysisObjectId, MetricName, Name, Units, AggregationType) VALUES(nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Hosts''), ''cpuUsageSystem'', ''Max System CPU'', ''percent'', ''MAX'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregator(AnalysisAggregatorId, AnalysisObjectId, MetricName, Name, Units, AggregationType) VALUES(nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Hosts''), ''cpuUsageUser'', ''Max User CPU'', ''percent'', ''MAX'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregator(AnalysisAggregatorId, AnalysisObjectId, MetricName, Name, Units, AggregationType) VALUES(nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Hosts''), ''cpuTotalUsage'', ''Min Total CPU'', ''percent'', ''MIN'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregator(AnalysisAggregatorId, AnalysisObjectId, MetricName, Name, Units, AggregationType) VALUES(nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Hosts''), ''cpuUsageIdle'', ''Min Idle CPU'', ''percent'', ''MIN'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregator(AnalysisAggregatorId, AnalysisObjectId, MetricName, Name, Units, AggregationType) VALUES(nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Hosts''), ''cpuUsageSystem'', ''Min System CPU'', ''percent'', ''MIN'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregator(AnalysisAggregatorId, AnalysisObjectId, MetricName, Name, Units, AggregationType) VALUES(nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Hosts''), ''cpuUsageUser'', ''Min User CPU'', ''percent'', ''MIN'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregatorSQL(AnalysisAggregatorSQLId, AnalysisAggregatorId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, AggregatorSQL, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisAggregatorId FROM OpAnalysisAggregator JOIN OpAnalysisObject ON OpAnalysisAggregator.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Hosts'' AND OpAnalysisAggregator.Name = ''Average Total CPU''), ''OpHostMetric'', ''HostMetricId'', ''OpHostMetricValue'', ''HostMetricId'', ''JOIN'', ''AVG(OpHostMetricValue.Value)'', ''OpHostMetric.Name'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregatorSQL(AnalysisAggregatorSQLId, AnalysisAggregatorId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, AggregatorSQL, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisAggregatorId FROM OpAnalysisAggregator JOIN OpAnalysisObject ON OpAnalysisAggregator.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Hosts'' AND OpAnalysisAggregator.Name = ''Average Idle CPU''), ''OpHostMetric'', ''HostMetricId'', ''OpHostMetricValue'', ''HostMetricId'', ''JOIN'', ''AVG(OpHostMetricValue.Value)'', ''OpHostMetric.Name'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregatorSQL(AnalysisAggregatorSQLId, AnalysisAggregatorId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, AggregatorSQL, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisAggregatorId FROM OpAnalysisAggregator JOIN OpAnalysisObject ON OpAnalysisAggregator.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Hosts'' AND OpAnalysisAggregator.Name = ''Average System CPU''), ''OpHostMetric'', ''HostMetricId'', ''OpHostMetricValue'', ''HostMetricId'', ''JOIN'', ''AVG(OpHostMetricValue.Value)'', ''OpHostMetric.Name'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregatorSQL(AnalysisAggregatorSQLId, AnalysisAggregatorId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, AggregatorSQL, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisAggregatorId FROM OpAnalysisAggregator JOIN OpAnalysisObject ON OpAnalysisAggregator.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Hosts'' AND OpAnalysisAggregator.Name = ''Average User CPU''), ''OpHostMetric'', ''HostMetricId'', ''OpHostMetricValue'', ''HostMetricId'', ''JOIN'', ''AVG(OpHostMetricValue.Value)'', ''OpHostMetric.Name'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregatorSQL(AnalysisAggregatorSQLId, AnalysisAggregatorId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, AggregatorSQL, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisAggregatorId FROM OpAnalysisAggregator JOIN OpAnalysisObject ON OpAnalysisAggregator.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Hosts'' AND OpAnalysisAggregator.Name = ''Max Total CPU''), ''OpHostMetric'', ''HostMetricId'', ''OpHostMetricValue'', ''HostMetricId'', ''JOIN'', ''MAX(OpHostMetricValue.Value)'', ''OpHostMetric.Name'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregatorSQL(AnalysisAggregatorSQLId, AnalysisAggregatorId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, AggregatorSQL, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisAggregatorId FROM OpAnalysisAggregator JOIN OpAnalysisObject ON OpAnalysisAggregator.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Hosts'' AND OpAnalysisAggregator.Name = ''Max Idle CPU''), ''OpHostMetric'', ''HostMetricId'', ''OpHostMetricValue'', ''HostMetricId'', ''JOIN'', ''MAX(OpHostMetricValue.Value)'', ''OpHostMetric.Name'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregatorSQL(AnalysisAggregatorSQLId, AnalysisAggregatorId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, AggregatorSQL, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisAggregatorId FROM OpAnalysisAggregator JOIN OpAnalysisObject ON OpAnalysisAggregator.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Hosts'' AND OpAnalysisAggregator.Name = ''Max System CPU''), ''OpHostMetric'', ''HostMetricId'', ''OpHostMetricValue'', ''HostMetricId'', ''JOIN'', ''MAX(OpHostMetricValue.Value)'', ''OpHostMetric.Name'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregatorSQL(AnalysisAggregatorSQLId, AnalysisAggregatorId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, AggregatorSQL, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisAggregatorId FROM OpAnalysisAggregator JOIN OpAnalysisObject ON OpAnalysisAggregator.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Hosts'' AND OpAnalysisAggregator.Name = ''Max User CPU''), ''OpHostMetric'', ''HostMetricId'', ''OpHostMetricValue'', ''HostMetricId'', ''JOIN'', ''MAX(OpHostMetricValue.Value)'', ''OpHostMetric.Name'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregatorSQL(AnalysisAggregatorSQLId, AnalysisAggregatorId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, AggregatorSQL, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisAggregatorId FROM OpAnalysisAggregator JOIN OpAnalysisObject ON OpAnalysisAggregator.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Hosts'' AND OpAnalysisAggregator.Name = ''Min Total CPU''), ''OpHostMetric'', ''HostMetricId'', ''OpHostMetricValue'', ''HostMetricId'', ''JOIN'', ''MIN(OpHostMetricValue.Value)'', ''OpHostMetric.Name'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregatorSQL(AnalysisAggregatorSQLId, AnalysisAggregatorId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, AggregatorSQL, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisAggregatorId FROM OpAnalysisAggregator JOIN OpAnalysisObject ON OpAnalysisAggregator.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Hosts'' AND OpAnalysisAggregator.Name = ''Min Idle CPU''), ''OpHostMetric'', ''HostMetricId'', ''OpHostMetricValue'', ''HostMetricId'', ''JOIN'', ''MIN(OpHostMetricValue.Value)'', ''OpHostMetric.Name'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregatorSQL(AnalysisAggregatorSQLId, AnalysisAggregatorId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, AggregatorSQL, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisAggregatorId FROM OpAnalysisAggregator JOIN OpAnalysisObject ON OpAnalysisAggregator.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Hosts'' AND OpAnalysisAggregator.Name = ''Min System CPU''), ''OpHostMetric'', ''HostMetricId'', ''OpHostMetricValue'', ''HostMetricId'', ''JOIN'', ''MIN(OpHostMetricValue.Value)'', ''OpHostMetric.Name'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregatorSQL(AnalysisAggregatorSQLId, AnalysisAggregatorId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, AggregatorSQL, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisAggregatorId FROM OpAnalysisAggregator JOIN OpAnalysisObject ON OpAnalysisAggregator.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Hosts'' AND OpAnalysisAggregator.Name = ''Min User CPU''), ''OpHostMetric'', ''HostMetricId'', ''OpHostMetricValue'', ''HostMetricId'', ''JOIN'', ''MIN(OpHostMetricValue.Value)'', ''OpHostMetric.Name'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisObject (AnalysisObjectId, Name, TableName, BucketSQL) VALUES (nextval(''hibernate_sequence''),  ''Queues'', ''OpQueueMetricValue'', ''BUCKET OpQueueMetricValue.CollectionTime'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRow (AnalysisRowId, AnalysisObjectId, Name) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Queues''), ''QueueName'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRow (AnalysisRowId, AnalysisObjectId, Name) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Queues''), ''Host'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRow (AnalysisRowId, AnalysisObjectId, Name) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Queues''), ''System'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRow (AnalysisRowId, AnalysisObjectId, Name) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Queues''), ''Directory'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRow (AnalysisRowId, AnalysisObjectId, Name) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Queues''), ''Type'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRow (AnalysisRowId, AnalysisObjectId, Name) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Queues''), ''Owner'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRow (AnalysisRowId, AnalysisObjectId, Name) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Queues''), ''Version'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRowSQL(AnalysisRowSQLId, AnalysisRowId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisRowId FROM OpAnalysisRow JOIN OpAnalysisObject ON OpAnalysisRow.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Queues'' AND OpAnalysisRow.Name = ''QueueName''), ''OpQueueMetric'', ''QueueMetricId'', ''OpQueueMetricValue'', ''QueueMetricId'', ''LEFT OUTER JOIN'', null)';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRowSQL(AnalysisRowSQLId, AnalysisRowId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisRowId FROM OpAnalysisRow JOIN OpAnalysisObject ON OpAnalysisRow.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Queues'' AND OpAnalysisRow.Name = ''QueueName''), ''OpQueue'', ''QueueId'', ''OpQueueMetric'', ''QueueId'', ''JOIN'', ''COALESCE(OpQueue.Name, ''''null'''')'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRowSQL(AnalysisRowSQLId, AnalysisRowId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisRowId FROM OpAnalysisRow JOIN OpAnalysisObject ON OpAnalysisRow.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Queues'' AND OpAnalysisRow.Name = ''Host''), ''OpQueueMetric'', ''QueueMetricId'', ''OpQueueMetricValue'', ''QueueMetricId'', ''LEFT OUTER JOIN'', null)';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRowSQL(AnalysisRowSQLId, AnalysisRowId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisRowId FROM OpAnalysisRow JOIN OpAnalysisObject ON OpAnalysisRow.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Queues'' AND OpAnalysisRow.Name = ''Host''), ''OpQueue'', ''QueueId'', ''OpQueueMetric'', ''QueueId'', ''JOIN'', null)';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRowSQL(AnalysisRowSQLId, AnalysisRowId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisRowId FROM OpAnalysisRow JOIN OpAnalysisObject ON OpAnalysisRow.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Queues'' AND OpAnalysisRow.Name = ''Host''), ''OpHost'', ''HostId'', ''OpQueue'', ''HostId'', ''JOIN'', ''COALESCE(OpHost.Hostname, ''''null'''')'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRowSQL(AnalysisRowSQLId, AnalysisRowId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisRowId FROM OpAnalysisRow JOIN OpAnalysisObject ON OpAnalysisRow.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Queues'' AND OpAnalysisRow.Name = ''System''), ''OpQueueMetric'', ''QueueMetricId'', ''OpQueueMetricValue'', ''QueueMetricId'', ''LEFT OUTER JOIN'', null)';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRowSQL(AnalysisRowSQLId, AnalysisRowId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisRowId FROM OpAnalysisRow JOIN OpAnalysisObject ON OpAnalysisRow.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Queues'' AND OpAnalysisRow.Name = ''System''), ''OpQueue'', ''QueueId'', ''OpQueueMetric'', ''QueueId'', ''JOIN'', null)';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRowSQL(AnalysisRowSQLId, AnalysisRowId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisRowId FROM OpAnalysisRow JOIN OpAnalysisObject ON OpAnalysisRow.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Queues'' AND OpAnalysisRow.Name = ''System''), ''OpSystem'', ''SystemId'', ''OpQueue'', ''SystemId'', ''JOIN'', ''COALESCE(OpSystem.Name, ''''null'''')'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRowSQL(AnalysisRowSQLId, AnalysisRowId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisRowId FROM OpAnalysisRow JOIN OpAnalysisObject ON OpAnalysisRow.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Queues'' AND OpAnalysisRow.Name = ''Directory''), ''OpQueueMetric'', ''QueueMetricId'', ''OpQueueMetricValue'', ''QueueMetricId'', ''LEFT OUTER JOIN'', null)';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRowSQL(AnalysisRowSQLId, AnalysisRowId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisRowId FROM OpAnalysisRow JOIN OpAnalysisObject ON OpAnalysisRow.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Queues'' AND OpAnalysisRow.Name = ''Directory''), ''OpQueue'', ''QueueId'', ''OpQueueMetric'', ''QueueId'', ''JOIN'', ''COALESCE(OpQueue.Directory, ''''null'''')'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRowSQL(AnalysisRowSQLId, AnalysisRowId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisRowId FROM OpAnalysisRow JOIN OpAnalysisObject ON OpAnalysisRow.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Queues'' AND OpAnalysisRow.Name = ''Type''), ''OpQueueMetric'', ''QueueMetricId'', ''OpQueueMetricValue'', ''QueueMetricId'', ''LEFT OUTER JOIN'', null)';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRowSQL(AnalysisRowSQLId, AnalysisRowId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisRowId FROM OpAnalysisRow JOIN OpAnalysisObject ON OpAnalysisRow.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Queues'' AND OpAnalysisRow.Name = ''Type''), ''OpQueue'', ''QueueId'', ''OpQueueMetric'', ''QueueId'', ''JOIN'', ''COALESCE(OpQueue.QueueType, ''''null'''')'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRowSQL(AnalysisRowSQLId, AnalysisRowId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisRowId FROM OpAnalysisRow JOIN OpAnalysisObject ON OpAnalysisRow.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Queues'' AND OpAnalysisRow.Name = ''Owner''), ''OpQueueMetric'', ''QueueMetricId'', ''OpQueueMetricValue'', ''QueueMetricId'', ''LEFT OUTER JOIN'', null)';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRowSQL(AnalysisRowSQLId, AnalysisRowId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisRowId FROM OpAnalysisRow JOIN OpAnalysisObject ON OpAnalysisRow.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Queues'' AND OpAnalysisRow.Name = ''Owner''), ''OpQueue'', ''QueueId'', ''OpQueueMetric'', ''QueueId'', ''JOIN'', ''COALESCE(OpQueue.Owner, ''''null'''')'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRowSQL(AnalysisRowSQLId, AnalysisRowId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisRowId FROM OpAnalysisRow JOIN OpAnalysisObject ON OpAnalysisRow.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Queues'' AND OpAnalysisRow.Name = ''Version''), ''OpQueueMetric'', ''QueueMetricId'', ''OpQueueMetricValue'', ''QueueMetricId'', ''LEFT OUTER JOIN'', null)';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisRowSQL(AnalysisRowSQLId, AnalysisRowId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisRowId FROM OpAnalysisRow JOIN OpAnalysisObject ON OpAnalysisRow.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Queues'' AND OpAnalysisRow.Name = ''Version''), ''OpQueue'', ''QueueId'', ''OpQueueMetric'', ''QueueId'', ''JOIN'', ''COALESCE(OpQueue.QueueVersion, -1)'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregator(AnalysisAggregatorId, AnalysisObjectId, MetricName, Name, Units, AggregationType) VALUES(nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Queues''), ''MAX_DISK_SPACE'', ''Max Disk Space'', ''bytes'', ''MAX'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregator(AnalysisAggregatorId, AnalysisObjectId, MetricName, Name, Units, AggregationType) VALUES(nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Queues''), ''MAX_FILES'', ''Max Files'', ''count'', ''MAX'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregator(AnalysisAggregatorId, AnalysisObjectId, MetricName, Name, Units, AggregationType) VALUES(nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Queues''), ''MAX_READ_COLLECTION_DELTA'', ''Max Read Collection Delta'', ''seconds'', ''MAX'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregator(AnalysisAggregatorId, AnalysisObjectId, MetricName, Name, Units, AggregationType) VALUES(nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Queues''), ''MAX_RECORDS'', ''Max Records'', ''count'', ''MAX'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregator(AnalysisAggregatorId, AnalysisObjectId, MetricName, Name, Units, AggregationType) VALUES(nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Queues''), ''MAX_RECORDS_SPACE'', ''Max Records Space'', ''percent'', ''MAX'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregator(AnalysisAggregatorId, AnalysisObjectId, MetricName, Name, Units, AggregationType) VALUES(nextval(''hibernate_sequence''),  (SELECT AnalysisObjectId FROM OpAnalysisObject WHERE Name = ''Queues''), ''WRITE_COLLECTION_DELTA'', ''Write Collection Delta'', ''seconds'', ''MAX'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregatorSQL(AnalysisAggregatorSQLId, AnalysisAggregatorId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, AggregatorSQL, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisAggregatorId FROM OpAnalysisAggregator JOIN OpAnalysisObject ON OpAnalysisAggregator.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Queues'' AND OpAnalysisAggregator.Name = ''Max Disk Space''), ''OpQueueMetric'', ''QueueMetricId'', ''OpQueueMetricValue'', ''QueueMetricId'', ''JOIN'', ''MAX(OpQueueMetricValue.Value)'', ''OpQueueMetric.MetricEnum'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregatorSQL(AnalysisAggregatorSQLId, AnalysisAggregatorId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, AggregatorSQL, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisAggregatorId FROM OpAnalysisAggregator JOIN OpAnalysisObject ON OpAnalysisAggregator.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Queues'' AND OpAnalysisAggregator.Name = ''Max Files''), ''OpQueueMetric'', ''QueueMetricId'', ''OpQueueMetricValue'', ''QueueMetricId'', ''JOIN'', ''MAX(OpQueueMetricValue.Value)'', ''OpQueueMetric.MetricEnum'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregatorSQL(AnalysisAggregatorSQLId, AnalysisAggregatorId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, AggregatorSQL, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisAggregatorId FROM OpAnalysisAggregator JOIN OpAnalysisObject ON OpAnalysisAggregator.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Queues'' AND OpAnalysisAggregator.Name = ''Max Read Collection Delta''), ''OpQueueMetric'', ''QueueMetricId'', ''OpQueueMetricValue'', ''QueueMetricId'', ''JOIN'', ''MAX(OpQueueMetricValue.Value)'', ''OpQueueMetric.MetricEnum'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregatorSQL(AnalysisAggregatorSQLId, AnalysisAggregatorId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, AggregatorSQL, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisAggregatorId FROM OpAnalysisAggregator JOIN OpAnalysisObject ON OpAnalysisAggregator.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Queues'' AND OpAnalysisAggregator.Name = ''Max Records''), ''OpQueueMetric'', ''QueueMetricId'', ''OpQueueMetricValue'', ''QueueMetricId'', ''JOIN'', ''MAX(OpQueueMetricValue.Value)'', ''OpQueueMetric.MetricEnum'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregatorSQL(AnalysisAggregatorSQLId, AnalysisAggregatorId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, AggregatorSQL, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisAggregatorId FROM OpAnalysisAggregator JOIN OpAnalysisObject ON OpAnalysisAggregator.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Queues'' AND OpAnalysisAggregator.Name = ''Max Records Space''), ''OpQueueMetric'', ''QueueMetricId'', ''OpQueueMetricValue'', ''QueueMetricId'', ''JOIN'', ''MAX(OpQueueMetricValue.Value)'', ''OpQueueMetric.MetricEnum'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpAnalysisAggregatorSQL(AnalysisAggregatorSQLId, AnalysisAggregatorId, JoinTableName, JoinPKName, BaseTableName, BaseFKName, JoinType, AggregatorSQL, SelectSQL) VALUES (nextval(''hibernate_sequence''),  (SELECT AnalysisAggregatorId FROM OpAnalysisAggregator JOIN OpAnalysisObject ON OpAnalysisAggregator.AnalysisObjectId = OpAnalysisObject.AnalysisObjectId WHERE OpAnalysisObject.Name = ''Queues'' AND OpAnalysisAggregator.Name = ''Write Collection Delta''), ''OpQueueMetric'', ''QueueMetricId'', ''OpQueueMetricValue'', ''QueueMetricId'', ''JOIN'', ''MAX(OpQueueMetricValue.Value)'', ''OpQueueMetric.MetricEnum'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


-- ---------------------------------------------------
create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrincipal (PrincipalId, PrincipalDiscriminator, Name, LCName, IsEnabled, IsBuiltin, DisplayName) values (nextval(''hibernate_sequence''), ''GROUP'', ''Admins'', ''admins'', ''Y'', ''N'', ''Admins'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrincipal (PrincipalId, PrincipalDiscriminator, Name, LCName, IsEnabled, IsBuiltin, DisplayName) values (nextval(''hibernate_sequence''), ''GROUP'', ''Account Admins'', ''account admins'', ''Y'', ''N'', ''Account Administration'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrincipal (PrincipalId, PrincipalDiscriminator, Name, LCName, IsEnabled, IsBuiltin, DisplayName) values (nextval(''hibernate_sequence''), ''GROUP'', ''Environment Admins'', ''environment admins'', ''Y'', ''N'', ''Environment Configuration Administration'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrincipal (PrincipalId, PrincipalDiscriminator, Name, LCName, IsEnabled, IsBuiltin, DisplayName) values (nextval(''hibernate_sequence''), ''GROUP'', ''Jobs Monitors (DEFAULT)'', ''jobs monitors (default)'', ''Y'', ''N'', ''Jobs Monitors (DEFAULT)'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrincipal (PrincipalId, PrincipalDiscriminator, Name, LCName, IsEnabled, IsBuiltin, DisplayName) values (nextval(''hibernate_sequence''), ''GROUP'', ''Jobs Operators (DEFAULT)'', ''jobs operators (default)'', ''Y'', ''N'', ''Jobs Operators (DEFAULT)'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrincipal (PrincipalId, PrincipalDiscriminator, Name, LCName, IsEnabled, IsBuiltin, DisplayName) values (nextval(''hibernate_sequence''), ''GROUP'', ''Jobs Schedulers (DEFAULT)'', ''jobs schedulers (default)'', ''Y'', ''N'', ''Jobs Schedulers (DEFAULT)'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrincipal (PrincipalId, PrincipalDiscriminator, Name, LCName, IsEnabled, IsBuiltin, DisplayName) values (nextval(''hibernate_sequence''), ''GROUP'', ''Jobs Approvers (DEFAULT)'', ''jobs approvers (default)'', ''Y'', ''N'', ''Jobs Approvers (DEFAULT)'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrincipal (PrincipalId, PrincipalDiscriminator, Name, LCName, IsEnabled, IsBuiltin, DisplayName) values (nextval(''hibernate_sequence''), ''GROUP'', ''Jobs System Admins (DEFAULT)'', ''jobs system admins (default)'', ''Y'', ''N'', ''Jobs System Admins (DEFAULT)'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrincipal (PrincipalId, PrincipalDiscriminator, Name, LCName, IsEnabled, IsBuiltin, DisplayName) values (nextval(''hibernate_sequence''), ''GROUP'', ''Host Monitors'', ''host monitors'', ''Y'', ''N'', ''Host Monitors'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrincipal (PrincipalId, PrincipalDiscriminator, Name, LCName, IsEnabled, IsBuiltin, DisplayName) values (nextval(''hibernate_sequence''), ''GROUP'', ''Host Admins'', ''host admins'', ''Y'', ''N'', ''Host Admins'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrincipal (PrincipalId, PrincipalDiscriminator, Name, LCName, IsEnabled, IsBuiltin, DisplayName) values (nextval(''hibernate_sequence''), ''GROUP'', ''Product Monitors'', ''product monitors'', ''Y'', ''N'', ''Product Monitors'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrincipal (PrincipalId, PrincipalDiscriminator, Name, LCName, IsEnabled, IsBuiltin, DisplayName) values (nextval(''hibernate_sequence''), ''GROUP'', ''Product Operators'', ''product operators'', ''Y'', ''N'', ''Product Operators'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrincipal (PrincipalId, PrincipalDiscriminator, Name, LCName, IsEnabled, IsBuiltin, DisplayName) values (nextval(''hibernate_sequence''), ''GROUP'', ''Product Admins'', ''product admins'', ''Y'', ''N'', ''Product Admins'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrivilege (PrivilegeId, PrincipalId, RoleEnum) select nextval(''hibernate_sequence''), P.PrincipalId, ''ROLE_OP_ADMIN'' from OpPrincipal P where P.Name = ''Admins''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrivilege (PrivilegeId, PrincipalId, RoleEnum) select nextval(''hibernate_sequence''), P.PrincipalId, ''ROLE_OP_ACCOUNT_ADMIN'' from OpPrincipal P where P.Name = ''Account Admins''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrivilege (PrivilegeId, PrincipalId, RoleEnum) select nextval(''hibernate_sequence''), P.PrincipalId, ''ROLE_OP_ENV_ADMIN'' from OpPrincipal P where P.Name = ''Environment Admins''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrivilege (PrivilegeId, PrincipalId, RoleEnum) select nextval(''hibernate_sequence''), P.PrincipalId, ''ROLE_OP_HOST_MONITOR'' from OpPrincipal P where P.Name = ''Host Monitors''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrivilege (PrivilegeId, PrincipalId, RoleEnum) select nextval(''hibernate_sequence''), P.PrincipalId, ''ROLE_OP_COMPUTER_KEY_ADMIN'' from OpPrincipal P where P.Name = ''Host Admins''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrivilege (PrivilegeId, PrincipalId, RoleEnum) select nextval(''hibernate_sequence''), P.PrincipalId, ''ROLE_OP_HOST_ADMIN'' from OpPrincipal P where P.Name = ''Host Admins''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrivilege (PrivilegeId, PrincipalId, RoleEnum) select nextval(''hibernate_sequence''), P.PrincipalId, ''ROLE_OP_PRODUCT_MONITOR'' from OpPrincipal P where P.Name = ''Product Monitors''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrivilege (PrivilegeId, PrincipalId, RoleEnum) select nextval(''hibernate_sequence''), P.PrincipalId, ''ROLE_OP_PRODUCT_OPERATOR'' from OpPrincipal P where P.Name = ''Product Operators''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrivilege (PrivilegeId, PrincipalId, RoleEnum) select nextval(''hibernate_sequence''), P.PrincipalId, ''ROLE_OP_USER_KEY_ADMIN'' from OpPrincipal P where P.Name = ''Product Admins''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrivilege (PrivilegeId, PrincipalId, RoleEnum) select nextval(''hibernate_sequence''), P.PrincipalId, ''ROLE_OP_PRODUCT_ADMIN'' from OpPrincipal P where P.Name = ''Product Admins''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  default_system integer;
begin
  select SystemId into default_system from OpSystem where name = 'DEFAULT';
  execute E'insert into OpPrivilege (PrivilegeId, PrincipalId, RoleEnum, SystemId) select nextval(''hibernate_sequence''), P.PrincipalId, ''ROLE_OP_OPERATOR'', ' || default_system || ' from OpPrincipal P where P.Name = ''Jobs Operators (DEFAULT)''';
  execute E'insert into OpPrivilege (PrivilegeId, PrincipalId, RoleEnum, SystemId) select nextval(''hibernate_sequence''), P.PrincipalId, ''ROLE_OP_MONITOR'', ' || default_system || ' from OpPrincipal P where P.Name = ''Jobs Monitors (DEFAULT)''';
  execute E'insert into OpPrivilege (PrivilegeId, PrincipalId, RoleEnum, SystemId) select nextval(''hibernate_sequence''), P.PrincipalId, ''ROLE_OP_DATA_VIEWER'', ' || default_system || ' from OpPrincipal P where P.Name = ''Jobs Monitors (DEFAULT)''';
  execute E'insert into OpPrivilege (PrivilegeId, PrincipalId, RoleEnum, SystemId) select nextval(''hibernate_sequence''), P.PrincipalId, ''ROLE_OP_SCHEDULER'', ' || default_system || ' from OpPrincipal P where P.Name = ''Jobs Schedulers (DEFAULT)''';
  execute E'insert into OpPrivilege (PrivilegeId, PrincipalId, RoleEnum, SystemId) select nextval(''hibernate_sequence''), P.PrincipalId, ''ROLE_OP_DATA_EDITOR'', ' || default_system || ' from OpPrincipal P where P.Name = ''Jobs Schedulers (DEFAULT)''';
  execute E'insert into OpPrivilege (PrivilegeId, PrincipalId, RoleEnum, SystemId) select nextval(''hibernate_sequence''), P.PrincipalId, ''ROLE_OP_APPROVER'', ' || default_system || ' from OpPrincipal P where P.Name = ''Jobs Approvers (DEFAULT)''';
  execute E'insert into OpPrivilege (PrivilegeId, PrincipalId, RoleEnum, SystemId) select nextval(''hibernate_sequence''), P.PrincipalId, ''ROLE_OP_SYSTEM_ADMIN'', ' || default_system || ' from OpPrincipal P where P.Name = ''Jobs System Admins (DEFAULT)''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrincipal (PrincipalId, PrincipalDiscriminator, Name, LCName, IsEnabled, IsBuiltin) values (nextval(''hibernate_sequence''), ''USER'', ''ocagent'', ''ocagent'', ''Y'', ''Y'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrincipal (PrincipalId, PrincipalDiscriminator, Name, LCName, IsEnabled, IsBuiltin) values (nextval(''hibernate_sequence''), ''USER'', ''admin'', ''admin'', ''N'', ''N'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrincipal (PrincipalId, PrincipalDiscriminator, Name, LCName, IsEnabled, IsBuiltin) values (nextval(''hibernate_sequence''), ''USER'', ''accountAdmin'', ''accountadmin'', ''N'', ''N'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrincipal (PrincipalId, PrincipalDiscriminator, Name, LCName, IsEnabled, IsBuiltin) values (nextval(''hibernate_sequence''), ''USER'', ''envAdmin'', ''envadmin'', ''N'', ''N'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrincipal (PrincipalId, PrincipalDiscriminator, Name, LCName, IsEnabled, IsBuiltin) values (nextval(''hibernate_sequence''), ''USER'', ''monitor'', ''monitor'', ''N'', ''N'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrincipal (PrincipalId, PrincipalDiscriminator, Name, LCName, IsEnabled, IsBuiltin) values (nextval(''hibernate_sequence''), ''USER'', ''operator'', ''operator'', ''N'', ''N'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrincipal (PrincipalId, PrincipalDiscriminator, Name, LCName, IsEnabled, IsBuiltin) values (nextval(''hibernate_sequence''), ''USER'', ''scheduler'', ''scheduler'', ''N'', ''N'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrincipal (PrincipalId, PrincipalDiscriminator, Name, LCName, IsEnabled, IsBuiltin) values (nextval(''hibernate_sequence''), ''USER'', ''approver'', ''approver'', ''N'', ''N'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrincipal (PrincipalId, PrincipalDiscriminator, Name, LCName, IsEnabled, IsBuiltin) values (nextval(''hibernate_sequence''), ''USER'', ''sysAdmin'', ''sysadmin'', ''N'', ''N'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrincipal (PrincipalId, PrincipalDiscriminator, Name, LCName, IsEnabled, IsBuiltin) values (nextval(''hibernate_sequence''), ''USER'', ''hostMonitor'', ''hostmonitor'', ''N'', ''N'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrincipal (PrincipalId, PrincipalDiscriminator, Name, LCName, IsEnabled, IsBuiltin) values (nextval(''hibernate_sequence''), ''USER'', ''hostAdmin'', ''hostadmin'', ''N'', ''N'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrincipal (PrincipalId, PrincipalDiscriminator, Name, LCName, IsEnabled, IsBuiltin) values (nextval(''hibernate_sequence''), ''USER'', ''productMonitor'', ''productmonitor'', ''N'', ''N'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrincipal (PrincipalId, PrincipalDiscriminator, Name, LCName, IsEnabled, IsBuiltin) values (nextval(''hibernate_sequence''), ''USER'', ''productOperator'', ''productoperator'', ''N'', ''N'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrincipal (PrincipalId, PrincipalDiscriminator, Name, LCName, IsEnabled, IsBuiltin) values (nextval(''hibernate_sequence''), ''USER'', ''productAdmin'', ''productadmin'', ''N'', ''N'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrincipal (PrincipalId, PrincipalDiscriminator, Name, LCName, IsEnabled, IsBuiltin) values (nextval(''hibernate_sequence''), ''USER'', ''analyst'', ''analyst'', ''N'', ''N'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrivilege (PrivilegeId, PrincipalId, RoleEnum) select nextval(''hibernate_sequence''), P.PrincipalId, ''ROLE_OP_OCAGENT'' from OpPrincipal P where P.Name = ''ocagent''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpPrivilege (PrivilegeId, PrincipalId, RoleEnum) select nextval(''hibernate_sequence''), P.PrincipalId, ''ROLE_OP_ANALYST'' from OpPrincipal P where P.Name = ''analyst''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpGroupXref (ChildPrincipalId, ParentGroupId) select C.PrincipalId, P.PrincipalId from OpPrincipal C, OpPrincipal P where C.Name = ''admin'' and P.Name = ''Admins''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpGroupXref (ChildPrincipalId, ParentGroupId) select C.PrincipalId, P.PrincipalId from OpPrincipal C, OpPrincipal P where C.Name = ''accountAdmin'' and P.Name = ''Account Admins''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpGroupXref (ChildPrincipalId, ParentGroupId) select C.PrincipalId, P.PrincipalId from OpPrincipal C, OpPrincipal P where C.Name = ''envAdmin'' and P.Name = ''Environment Admins''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpGroupXref (ChildPrincipalId, ParentGroupId) select C.PrincipalId, P.PrincipalId from OpPrincipal C, OpPrincipal P where C.Name = ''monitor'' and P.Name = ''Jobs Monitors (DEFAULT)''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpGroupXref (ChildPrincipalId, ParentGroupId) select C.PrincipalId, P.PrincipalId from OpPrincipal C, OpPrincipal P where C.Name = ''operator'' and P.Name = ''Jobs Operators (DEFAULT)''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpGroupXref (ChildPrincipalId, ParentGroupId) select C.PrincipalId, P.PrincipalId from OpPrincipal C, OpPrincipal P where C.Name = ''scheduler'' and P.Name = ''Jobs Schedulers (DEFAULT)''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpGroupXref (ChildPrincipalId, ParentGroupId) select C.PrincipalId, P.PrincipalId from OpPrincipal C, OpPrincipal P where C.Name = ''approver'' and P.Name = ''Jobs Approvers (DEFAULT)''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpGroupXref (ChildPrincipalId, ParentGroupId) select C.PrincipalId, P.PrincipalId from OpPrincipal C, OpPrincipal P where C.Name = ''sysAdmin'' and P.Name = ''Jobs System Admins (DEFAULT)''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpGroupXref (ChildPrincipalId, ParentGroupId) select C.PrincipalId, P.PrincipalId from OpPrincipal C, OpPrincipal P where C.Name = ''hostMonitor'' and P.Name = ''Host Monitors''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpGroupXref (ChildPrincipalId, ParentGroupId) select C.PrincipalId, P.PrincipalId from OpPrincipal C, OpPrincipal P where C.Name = ''hostAdmin'' and P.Name = ''Host Admins''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpGroupXref (ChildPrincipalId, ParentGroupId) select C.PrincipalId, P.PrincipalId from OpPrincipal C, OpPrincipal P where C.Name = ''productMonitor'' and P.Name = ''Product Monitors''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpGroupXref (ChildPrincipalId, ParentGroupId) select C.PrincipalId, P.PrincipalId from OpPrincipal C, OpPrincipal P where C.Name = ''productOperator'' and P.Name = ''Product Operators''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpGroupXref (ChildPrincipalId, ParentGroupId) select C.PrincipalId, P.PrincipalId from OpPrincipal C, OpPrincipal P where C.Name = ''productAdmin'' and P.Name = ''Product Admins''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


-- ---------------------------------------------------
create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpCalendar (CalendarId, SystemId, Name) select nextval(''hibernate_sequence''),  SystemId, ''Everyday Calendar'' from OpSystem where Name = ''DEFAULT''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpCalendar (CalendarId, SystemId, Name) select nextval(''hibernate_sequence''),  SystemId, ''Weekdays Calendar'' from OpSystem where Name = ''DEFAULT''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpCalendar (CalendarId, SystemId, Name) select nextval(''hibernate_sequence''),  SystemId, ''Workdays Calendar'' from OpSystem where Name = ''DEFAULT''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpCalendarYear (CalendarId, Days, Year) select CalendarId, ''111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'', 2022 from OpCalendar where Name = ''Everyday Calendar''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpCalendarYear (CalendarId, Days, Year) select CalendarId, ''001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100'', 2022 from OpCalendar where Name = ''Weekdays Calendar''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpCalendarYear (CalendarId, Days, Year) select CalendarId, ''001111100111110011111001111100111110011111001111100011110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111000111100111110011111001111100111110001111001111100111110011111001111100111110011111001111100111110001111001111100111110011111001111100111110011111001111100111110011111001111100111000011111001111100111110011111000111100'', 2022 from OpCalendar where Name = ''Workdays Calendar''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpCalendarYear (CalendarId, Days, Year) select CalendarId, ''111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'', 2023 from OpCalendar where Name = ''Everyday Calendar''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpCalendarYear (CalendarId, Days, Year) select CalendarId, ''011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001'', 2023 from OpCalendar where Name = ''Weekdays Calendar''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpCalendarYear (CalendarId, Days, Year) select CalendarId, ''001111001111100111110011111001111100111110011111000111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110001111001111100111110011111001111100101110011111001111100111110011111001111100111110011111001111100011110011111001111100111110011111001111100111110011111001111100111110011111001110000111110011111001111100111110001111000'', 2023 from OpCalendar where Name = ''Workdays Calendar''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpCalendarYear (CalendarId, Days, Year) select CalendarId, ''111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'', 2024 from OpCalendar where Name = ''Everyday Calendar''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpCalendarYear (CalendarId, Days, Year) select CalendarId, ''111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011'', 2024 from OpCalendar where Name = ''Weekdays Calendar''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpCalendarYear (CalendarId, Days, Year) select CalendarId, ''011110011111001111100111110011111001111100111110001111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100011110011111001111100111110011111001110100111110011111001111100111110011111001111100111110011111000111100111110011111001111100111110011111001111100111110011111001111100111110011111001110000111110011111001111100110110011'', 2024 from OpCalendar where Name = ''Workdays Calendar''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpCalendarYear (CalendarId, Days, Year) select CalendarId, ''111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'', 2025 from OpCalendar where Name = ''Everyday Calendar''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpCalendarYear (CalendarId, Days, Year) select CalendarId, ''111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111'', 2025 from OpCalendar where Name = ''Weekdays Calendar''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpCalendarYear (CalendarId, Days, Year) select CalendarId, ''011001111100111110011111001111100111110011111000111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110001111001111100111110011111001111100111100011111001111100111110011111001111100111110011111001111100011110011111001111100111110011111001111100111110011111001111100111110011111001111100111000011111001111100111110011101001110'', 2025 from OpCalendar where Name = ''Workdays Calendar''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpCalendarYear (CalendarId, Days, Year) select CalendarId, ''111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'', 2026 from OpCalendar where Name = ''Everyday Calendar''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpCalendarYear (CalendarId, Days, Year) select CalendarId, ''110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111'', 2026 from OpCalendar where Name = ''Weekdays Calendar''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpCalendarYear (CalendarId, Days, Year) select CalendarId, ''010011111001111100111110011111001111100111110001111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100011110011111001111100111110011111001111000111110011111001111100111110011111001111100111110011111001111100011110011111001111100111110011111001111100111110011111001111100111110011111001110000111110011111001111100111100011110'', 2026 from OpCalendar where Name = ''Workdays Calendar''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpCalendarYear (CalendarId, Days, Year) select CalendarId, ''111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'', 2027 from OpCalendar where Name = ''Everyday Calendar''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpCalendarYear (CalendarId, Days, Year) select CalendarId, ''100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100111110'', 2027 from OpCalendar where Name = ''Weekdays Calendar''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'insert into OpCalendarYear (CalendarId, Days, Year) select CalendarId, ''000111110011111001111100111110011111001111100011110011111001111100111110011111001111100111110011111001111100111110011111001111100111110011111001111100011110011111001111100111110011111000111100111110011111001111100111110011111001111100111110011111000111100111110011111001111100111110011111001111100111110011111001111100111110011100001111100111110011111001111000111100'', 2027 from OpCalendar where Name = ''Workdays Calendar''';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


-- ---------------------------------------------------
create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.analysisArea.maxDays';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''The maximum number of days over which the Control>Center can perform an analysis. Default: 31'' WHERE Name = ''client.analysisArea.maxDays''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.analysisArea.maxDays'', ''The maximum number of days over which the Control>Center can perform an analysis. Default: 31'', ''INTEGER'', ''31'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.analysisArea.chart.maxColumns';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''The maximum number of columns that the Control>Center can display in the Analysis area Timeline chart. Default: 48'' WHERE Name = ''client.analysisArea.chart.maxColumns''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.analysisArea.chart.maxColumns'', ''The maximum number of columns that the Control>Center can display in the Analysis area Timeline chart. Default: 48'', ''INTEGER'', ''48'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.analysisArea.chart.minColumnWidthSecs';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''The minimum width in seconds of a column in the Analysis area Timeline chart.  Default: 86400 (1 day)'' WHERE Name = ''client.analysisArea.chart.minColumnWidthSecs''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.analysisArea.chart.minColumnWidthSecs'', ''The minimum width in seconds of a column in the Analysis area Timeline chart.  Default: 86400 (1 day)'', ''INTEGER'', ''86400'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.analysisArea.chart.displayGapMinutes';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''The maximum number of minutes between metric line graph data points that should be regarded as continuous. Larger intervals result in the display of gaps.  Default: 10'' WHERE Name = ''client.analysisArea.chart.displayGapMinutes''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.analysisArea.chart.displayGapMinutes'', ''The maximum number of minutes between metric line graph data points that should be regarded as continuous. Larger intervals result in the display of gaps.  Default: 10'', ''INTEGER'', ''10'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.automatedJobGeneration.allowPerApplication';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Allows you to disable automated job generation on a particular application in systems where automated job generation is enabled. Default: 0'' WHERE Name = ''client.automatedJobGeneration.allowPerApplication''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.automatedJobGeneration.allowPerApplication'', ''Allows you to disable automated job generation on a particular application in systems where automated job generation is enabled. Default: 0'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.configParamUnlock';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Control to limit configuration parameter access: 0 - no access, 1 - edit values, 2 - full control, including creating and deleting parameters. Default: 1'' WHERE Name = ''client.configParamUnlock''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.configParamUnlock'', ''Control to limit configuration parameter access: 0 - no access, 1 - edit values, 2 - full control, including creating and deleting parameters. Default: 1'', ''INTEGER'', ''1'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.disableParameterEval';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''When set to 1, disables viewing of a graph or plan where viewing would cause a re-evaluation of the graph or plan''''s parameters. Default: 0'' WHERE Name = ''client.disableParameterEval''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.disableParameterEval'', ''When set to 1, disables viewing of a graph or plan where viewing would cause a re-evaluation of the graph or plan''''s parameters. Default: 0'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.excludeJobColumns';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''Comma-delimited list of columns to exclude from the Daily Jobs Area.'' WHERE Name = ''client.excludeJobColumns''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.excludeJobColumns'', ''Comma-delimited list of columns to exclude from the Daily Jobs Area.'', ''STRING'', ''End,Host Cluster,Job Definition,Job Definition Group,Job GUID'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.excludeJobsWithIssuesListColumns';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''Comma-delimited list of columns to exclude from the Jobs list in the Jobs Overview for All Systems sub-area. Default: <blank>'' WHERE Name = ''client.excludeJobsWithIssuesListColumns''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.excludeJobsWithIssuesListColumns'', ''Comma-delimited list of columns to exclude from the Jobs list in the Jobs Overview for All Systems sub-area. Default: <blank>'', ''STRING'', '''', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.groupByAlso.job';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''Y'', Description = ''FOR INTERNAL USE ONLY. Choices for the Daily Jobs sub-areas Group by menus. Comma-delimited list of <label>:<OpJobPropertyView expression>. Default: Application:application.name,Status:status.label,Progress:status.coarseLabel,Issues:highestEventSeverityEnum.label,Predicted issues:highestPredictedIssueSeverityEnum.predictedLabel,Host cluster:hostClusterName,Host:hostname,User:username,Type:executableEnum.label,Working directory:workingDirectory,AB_WORK_DIR:abWorkDir,AB_HOME:abHome,Job definition group:jobDefinitionGroupName,Manually generated:testSetDescription'' WHERE Name = ''client.groupByAlso.job''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.groupByAlso.job'', ''FOR INTERNAL USE ONLY. Choices for the Daily Jobs sub-areas Group by menus. Comma-delimited list of <label>:<OpJobPropertyView expression>. Default: Application:application.name,Status:status.label,Progress:status.coarseLabel,Issues:highestEventSeverityEnum.label,Predicted issues:highestPredictedIssueSeverityEnum.predictedLabel,Host cluster:hostClusterName,Host:hostname,User:username,Type:executableEnum.label,Working directory:workingDirectory,AB_WORK_DIR:abWorkDir,AB_HOME:abHome,Job definition group:jobDefinitionGroupName,Manually generated:testSetDescription'', ''STRING'', ''Application:application.name,Status:status.label,Progress:status.coarseLabel,Issues:highestEventSeverityEnum.label,Predicted issues:highestPredictedIssueSeverityEnum.predictedLabel,Host cluster:hostClusterName,Host:hostname,User:username,Type:executableEnum.label,Working directory:workingDirectory,AB_WORK_DIR:abWorkDir,AB_HOME:abHome,Job definition group:jobDefinitionGroupName,Manually generated:testSetDescription'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.groupByAlso.jobDefinition';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''Y'', Description = ''FOR INTERNAL USE ONLY. Choices for the Schedule for System sub-area Group by menu. Comma-delimited list of <label>:<OpJobDefinition property expression>. Default: Application:application.name,Runtime environment:runtime.name,Status:status.label,Job definition group:jobDefinitionGroup.name,Type:mainAction.executableEnum.label'' WHERE Name = ''client.groupByAlso.jobDefinition''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.groupByAlso.jobDefinition'', ''FOR INTERNAL USE ONLY. Choices for the Schedule for System sub-area Group by menu. Comma-delimited list of <label>:<OpJobDefinition property expression>. Default: Application:application.name,Runtime environment:runtime.name,Status:status.label,Job definition group:jobDefinitionGroup.name,Type:mainAction.executableEnum.label'', ''STRING'', ''Application:application.name,Runtime environment:runtime.name,Status:status.label,Job definition group:jobDefinitionGroup.name,Type:mainAction.executableEnum.label'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.groupBy.product';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''Y'', Description = ''FOR INTERNAL USE ONLY. Choices for the Products area Group by menu. Comma-delimited list of <label>:<OpProduct property expression>. Default: Type:productType.unqualifiedName,Class:productType.productVarietyEnum.label,Host:hostname,Status:statusEnum.coarsened.label,Issues:issuesEnum.label,Tag:tag'' WHERE Name = ''client.groupBy.product''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.groupBy.product'', ''FOR INTERNAL USE ONLY. Choices for the Products area Group by menu. Comma-delimited list of <label>:<OpProduct property expression>. Default: Type:productType.unqualifiedName,Class:productType.productVarietyEnum.label,Host:hostname,Status:statusEnum.coarsened.label,Issues:issuesEnum.label,Tag:tag'', ''STRING'', ''Type:productType.unqualifiedName,Class:productType.productVarietyEnum.label,Host:hostname,Status:statusEnum.coarsened.label,Issues:issuesEnum.label,Tag:tag'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.home.hostSnapshotsVisible';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Show host items on the Home area for all roles, not just host-based roles. Default: 1'' WHERE Name = ''client.home.hostSnapshotsVisible''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.home.hostSnapshotsVisible'', ''Show host items on the Home area for all roles, not just host-based roles. Default: 1'', ''INTEGER'', ''1'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.home.productSnapshotsVisible';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Show product items on the Home area for all roles, not just product-based roles. Default: 1'' WHERE Name = ''client.home.productSnapshotsVisible''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.home.productSnapshotsVisible'', ''Show product items on the Home area for all roles, not just product-based roles. Default: 1'', ''INTEGER'', ''1'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.home.systemSnapshotsVisibleOnlyWhenProblems';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Show system items on the Home area only for systems with problems. Default: 1'' WHERE Name = ''client.home.systemSnapshotsVisibleOnlyWhenProblems''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.home.systemSnapshotsVisibleOnlyWhenProblems'', ''Show system items on the Home area only for systems with problems. Default: 1'', ''INTEGER'', ''1'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.hostsArea.enableAddButton';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Show the Add button in the Hosts area to allow creation of host profiles, runtime environments, and schedules for unmonitored hosts.  Default: 1'' WHERE Name = ''client.hostsArea.enableAddButton''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.hostsArea.enableAddButton'', ''Show the Add button in the Hosts area to allow creation of host profiles, runtime environments, and schedules for unmonitored hosts.  Default: 1'', ''INTEGER'', ''1'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.hostsArea.pollingSec';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Number of seconds the browser waits between successive requests to the app server for host metric values. This value is rounded up the nearest multiple of client.pollingSec. Default: 60'' WHERE Name = ''client.hostsArea.pollingSec''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.hostsArea.pollingSec'', ''Number of seconds the browser waits between successive requests to the app server for host metric values. This value is rounded up the nearest multiple of client.pollingSec. Default: 60'', ''INTEGER'', ''60'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.idleTimeoutMinutes';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''The number of minutes that a user is idle before the Control>Center client stops polling for updates. The user session will expire after another few minutes. When set to -1, polling is disabled, and the Control>Center client must be refreshed manually. Default=25'' WHERE Name = ''client.idleTimeoutMinutes''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.idleTimeoutMinutes'', ''The number of minutes that a user is idle before the Control>Center client stops polling for updates. The user session will expire after another few minutes. When set to -1, polling is disabled, and the Control>Center client must be refreshed manually. Default=25'', ''INTEGER'', ''25'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.idleNoRefreshWarningMinutes';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''When client.idleTimeoutMinutes is set to -1, this controls the number of minutes before a warning is presented to the user prompting them to refresh. Default=15'' WHERE Name = ''client.idleNoRefreshWarningMinutes''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.idleNoRefreshWarningMinutes'', ''When client.idleTimeoutMinutes is set to -1, this controls the number of minutes before a warning is presented to the user prompting them to refresh. Default=15'', ''INTEGER'', ''15'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.idleNoRefreshWarningSnoozeMinutes';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''When client.idleTimeoutMinutes configuration parameter is set to -1, controls the number of minutes that the warning controlled by the client.idleNoRefreshWarningMinutes configuration parameter can be hidden.'' WHERE Name = ''client.idleNoRefreshWarningSnoozeMinutes''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.idleNoRefreshWarningSnoozeMinutes'', ''When client.idleTimeoutMinutes configuration parameter is set to -1, controls the number of minutes that the warning controlled by the client.idleNoRefreshWarningMinutes configuration parameter can be hidden.'', ''INTEGER'', ''30'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.jobsOverview.byHosts.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Enable Jobs Overview by Hosts view. Default: 1'' WHERE Name = ''client.jobsOverview.byHosts.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.jobsOverview.byHosts.enabled'', ''Enable Jobs Overview by Hosts view. Default: 1'', ''INTEGER'', ''1'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.jobsOverview.showAllKnownHosts';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Show all hosts, even if they have aliases. Applies to the Jobs Overview for All Systems sub-area (group by Host). Default: 0 (hide aliased hosts)'' WHERE Name = ''client.jobsOverview.showAllKnownHosts''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.jobsOverview.showAllKnownHosts'', ''Show all hosts, even if they have aliases. Applies to the Jobs Overview for All Systems sub-area (group by Host). Default: 0 (hide aliased hosts)'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.jobsOverviewForAllHosts.maxSecs';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''The maximum time in seconds that the Control>Center can include in its calculation of the job metric totals displayed in the Jobs Overview for All Hosts view. Default: 86400'' WHERE Name = ''client.jobsOverviewForAllHosts.maxSecs''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.jobsOverviewForAllHosts.maxSecs'', ''The maximum time in seconds that the Control>Center can include in its calculation of the job metric totals displayed in the Jobs Overview for All Hosts view. Default: 86400'', ''INTEGER'', ''86400'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.jobsHistoryForHost.maxDays';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''The maximum number of days that the Control>Center can include in a host History chart. Default: 30'' WHERE Name = ''client.jobsHistoryForHost.maxDays''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.jobsHistoryForHost.maxDays'', ''The maximum number of days that the Control>Center can include in a host History chart. Default: 30'', ''INTEGER'', ''30'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.jobsHistoryForHost.maxBars';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''The maximum number of bars that the Control>Center can include in a host History chart. Default: 48'' WHERE Name = ''client.jobsHistoryForHost.maxBars''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.jobsHistoryForHost.maxBars'', ''The maximum number of bars that the Control>Center can include in a host History chart. Default: 48'', ''INTEGER'', ''48'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.jobsHistoryForHost.useFixedScale';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''For the jobs axis in the host History chart, fix the scale at the maximum available effective cpu. Default: 0'' WHERE Name = ''client.jobsHistoryForHost.useFixedScale''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.jobsHistoryForHost.useFixedScale'', ''For the jobs axis in the host History chart, fix the scale at the maximum available effective cpu. Default: 0'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.jobsHistoryForHost.displayGapMinutes';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''The maximum number of minutes between metric line graph data points that should be regarded as continuous. Larger intervals result in the display of gaps.  Default: 10'' WHERE Name = ''client.jobsHistoryForHost.displayGapMinutes''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.jobsHistoryForHost.displayGapMinutes'', ''The maximum number of minutes between metric line graph data points that should be regarded as continuous. Larger intervals result in the display of gaps.  Default: 10'', ''INTEGER'', ''10'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.instanceLabel';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''User-specified label for UI customization. If non-blank, the value appears in the UI tab label and header bar, as well as in the browser''''s title bar. This is the ''''branding'''' for this instance of the Control>Center, and can be used to identify the DEV/TEST/PROD instance, for example. If you specify a blank value, the default string "Control>Center" will nevertheless appear. Default: Control>Center'' WHERE Name = ''client.instanceLabel''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.instanceLabel'', ''User-specified label for UI customization. If non-blank, the value appears in the UI tab label and header bar, as well as in the browser''''s title bar. This is the ''''branding'''' for this instance of the Control>Center, and can be used to identify the DEV/TEST/PROD instance, for example. If you specify a blank value, the default string "Control>Center" will nevertheless appear. Default: Control>Center'', ''STRING'', ''Control>Center'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.deploymentName';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''Y'', Description = ''The deployment name of this Control>Center.'' WHERE Name = ''client.deploymentName''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.deploymentName'', ''The deployment name of this Control>Center.'', ''STRING'', '''', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.limitGroupByValues';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Maximum number of second-level groups shown in the left pane for the sub-areas: Jobs Overview for All Systems, Daily Jobs for System, Daily Jobs for Host. Excess groups (e.g., applications, hosts, users) appear under ''''Others.'''' Default: 100'' WHERE Name = ''client.limitGroupByValues''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.limitGroupByValues'', ''Maximum number of second-level groups shown in the left pane for the sub-areas: Jobs Overview for All Systems, Daily Jobs for System, Daily Jobs for Host. Excess groups (e.g., applications, hosts, users) appear under ''''Others.'''' Default: 100'', ''INTEGER'', ''100'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.limitMonitorDiagramJobNodes';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Maximum number of top-level objects shown in any Jobs area dependency view. No dependency view is shown if this number is exceeded. Default: 1000'' WHERE Name = ''client.limitMonitorDiagramJobNodes''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.limitMonitorDiagramJobNodes'', ''Maximum number of top-level objects shown in any Jobs area dependency view. No dependency view is shown if this number is exceeded. Default: 1000'', ''INTEGER'', ''1000'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.limitMonitorDiagramJobDefinitionNodes';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Maximum number of top-level objects shown in any Schedule area dependency view. No dependency view is shown if this number is exceeded. Default: 1000'' WHERE Name = ''client.limitMonitorDiagramJobDefinitionNodes''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.limitMonitorDiagramJobDefinitionNodes'', ''Maximum number of top-level objects shown in any Schedule area dependency view. No dependency view is shown if this number is exceeded. Default: 1000'', ''INTEGER'', ''1000'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.limitOutputFileSize';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Maximum allowable size (MB) for a text file viewed from the Control>Center. Default: 16'' WHERE Name = ''client.limitOutputFileSize''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.limitOutputFileSize'', ''Maximum allowable size (MB) for a text file viewed from the Control>Center. Default: 16'', ''INTEGER'', ''16'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.markjobs.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Control whether the Mark As Failed, Mark As Succeeded job actions are enabled. Default: 1'' WHERE Name = ''client.markjobs.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.markjobs.enabled'', ''Control whether the Mark As Failed, Mark As Succeeded job actions are enabled. Default: 1'', ''INTEGER'', ''1'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.mpxGraphViewerActions.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Enable Info Bubble actions to view mpx graphs. Default: 1'' WHERE Name = ''client.mpxGraphViewerActions.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.mpxGraphViewerActions.enabled'', ''Enable Info Bubble actions to view mpx graphs. Default: 1'', ''INTEGER'', ''1'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.muxURISchemes';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''Corresponds to the Co>Operating System configuration variable AB_MUX_URI_SCHEMES, which is a colon separated list of allowable Uniform Resource Identifier path prefixes. Default: maprfs:s3a:gs:wasb:wasbs:abfs:abfss'' WHERE Name = ''client.muxURISchemes''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.muxURISchemes'', ''Corresponds to the Co>Operating System configuration variable AB_MUX_URI_SCHEMES, which is a colon separated list of allowable Uniform Resource Identifier path prefixes. Default: maprfs:s3a:gs:wasb:wasbs:abfs:abfss'', ''STRING'', ''maprfs:s3a:gs:wasb:wasbs:abfs:abfss'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.permitBrowseAllIcons';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Controls the palette of icons that you can assign to quick links. Set to 0 to restrict the palette to a manageable number of the most useful icons. Set to 1 to expand the palette fully. Default: 0'' WHERE Name = ''client.permitBrowseAllIcons''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.permitBrowseAllIcons'', ''Controls the palette of icons that you can assign to quick links. Set to 0 to restrict the palette to a manageable number of the most useful icons. Set to 1 to expand the palette fully. Default: 0'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.permitF8';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Enables the F8 key to run commands on a host. Default: 1'' WHERE Name = ''client.permitF8''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.permitF8'', ''Enables the F8 key to run commands on a host. Default: 1'', ''INTEGER'', ''1'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.permitIBStopAndDrop';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Enables the Stop Monitoring action on the Product, Host and Jobset info bubbles and enables Drop From Control>Center action on the Product and Jobset info bubbles. Default: 0'' WHERE Name = ''client.permitIBStopAndDrop''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.permitIBStopAndDrop'', ''Enables the Stop Monitoring action on the Product, Host and Jobset info bubbles and enables Drop From Control>Center action on the Product and Jobset info bubbles. Default: 0'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.permitJobDefinitionTest';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Enables the Manually Generate Job action on the Job Definition info bubble and the Test Schedule action on the System info bubble. Default: 1'' WHERE Name = ''client.permitJobDefinitionTest''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.permitJobDefinitionTest'', ''Enables the Manually Generate Job action on the Job Definition info bubble and the Test Schedule action on the System info bubble. Default: 1'', ''INTEGER'', ''1'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.permitJobDelete';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Enables job deletion from the UI by an Administrator user. Default: 1'' WHERE Name = ''client.permitJobDelete''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.permitJobDelete'', ''Enables job deletion from the UI by an Administrator user. Default: 1'', ''INTEGER'', ''1'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.permitCommandsAllProducts';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Enable the commands tab on all products, not just Other Product and Other Service.  Default: 0'' WHERE Name = ''client.permitCommandsAllProducts''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.permitCommandsAllProducts'', ''Enable the commands tab on all products, not just Other Product and Other Service.  Default: 0'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.permitHostnameKeys';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Enable support for hostname keys.  Default: 1'' WHERE Name = ''client.permitHostnameKeys''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.permitHostnameKeys'', ''Enable support for hostname keys.  Default: 1'', ''INTEGER'', ''1'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.permitOperatorEditableJobDefProperties';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Determines whether the operator can edit Properties when creating a job from a job definition. Default: 0'' WHERE Name = ''client.permitOperatorEditableJobDefProperties''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.permitOperatorEditableJobDefProperties'', ''Determines whether the operator can edit Properties when creating a job from a job definition. Default: 0'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.permitOperatorVisibleSchedule';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Determines whether the operator can see the Schedule tab and the Manually Generate Job action. Default: 0'' WHERE Name = ''client.permitOperatorVisibleSchedule''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.permitOperatorVisibleSchedule'', ''Determines whether the operator can see the Schedule tab and the Manually Generate Job action. Default: 0'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.pollingSec';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Number of seconds the browser waits between successive requests to the app server for new data. The installer creates this value. Default: 5'' WHERE Name = ''client.pollingSec''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.pollingSec'', ''Number of seconds the browser waits between successive requests to the app server for new data. The installer creates this value. Default: 5'', ''INTEGER'', ''5'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.recentEventsLimit.count';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Maximum number of events or issue displayed in events/issues grid. Default: 500'' WHERE Name = ''client.recentEventsLimit.count''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.recentEventsLimit.count'', ''Maximum number of events or issue displayed in events/issues grid. Default: 500'', ''INTEGER'', ''500'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.recentEventsLimit.days';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Maximum age of events or issue displayed in events/issues grid. Default: 30'' WHERE Name = ''client.recentEventsLimit.days''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.recentEventsLimit.days'', ''Maximum age of events or issue displayed in events/issues grid. Default: 30'', ''INTEGER'', ''30'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.reporterCpuMonitoring.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Enables display and edit of reporter cpuMonitoring configuration. Default: 0'' WHERE Name = ''client.reporterCpuMonitoring.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.reporterCpuMonitoring.enabled'', ''Enables display and edit of reporter cpuMonitoring configuration. Default: 0'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.rerun.SLAPrompt.default';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Determines default choice for rerun prompt where user chooses between original SLA (1) or adjusted SLA (0) for rerun set. Default: 0'' WHERE Name = ''client.rerun.SLAPrompt.default''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.rerun.SLAPrompt.default'', ''Determines default choice for rerun prompt where user chooses between original SLA (1) or adjusted SLA (0) for rerun set. Default: 0'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.restrictAccountAdmin';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Allows only Administrators to create Administrator accounts. Default: 1'' WHERE Name = ''client.restrictAccountAdmin''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.restrictAccountAdmin'', ''Allows only Administrators to create Administrator accounts. Default: 1'', ''INTEGER'', ''1'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.runtimes.permitHostsWithAliases';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Allows Runtime Environments to use Hosts that have Host Aliases. Default: 0'' WHERE Name = ''client.runtimes.permitHostsWithAliases''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.runtimes.permitHostsWithAliases'', ''Allows Runtime Environments to use Hosts that have Host Aliases. Default: 0'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.supportedTimeZones';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''Comma-separated list of time zones to choose when creating or editing a job definition. Default: EST5EDT,PST8PDT,UTC'' WHERE Name = ''client.supportedTimeZones''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.supportedTimeZones'', ''Comma-separated list of time zones to choose when creating or editing a job definition. Default: EST5EDT,PST8PDT,UTC'', ''STRING'', ''EST5EDT,PST8PDT,UTC'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.tagLabel';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''Y'', Description = ''FOR INTERNAL USE ONLY. Label used when displaying ''''tag'''' values. Default: Category'' WHERE Name = ''client.tagLabel''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.tagLabel'', ''FOR INTERNAL USE ONLY. Label used when displaying ''''tag'''' values. Default: Category'', ''STRING'', ''Category'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.tagLabelPlural';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''Y'', Description = ''FOR INTERNAL USE ONLY. Label used when displaying ''''tag'''' values in plural. Default: Categories'' WHERE Name = ''client.tagLabelPlural''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.tagLabelPlural'', ''FOR INTERNAL USE ONLY. Label used when displaying ''''tag'''' values in plural. Default: Categories'', ''STRING'', ''Categories'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'client.tagScope';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''Y'', Description = ''FOR INTERNAL USE ONLY. Scope used to display already-in-use tag values.  One of ''''OBJECT'''' or ''''GLOBAL''''. Default: OBJECT'' WHERE Name = ''client.tagScope''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''client.tagScope'', ''FOR INTERNAL USE ONLY. Scope used to display already-in-use tag values.  One of ''''OBJECT'''' or ''''GLOBAL''''. Default: OBJECT'', ''STRING'', ''OBJECT'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'cluster.autoConfig.protocol';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''Protocol used to communicate between cluster nodes.  Options are either TCP (preferred) or UDP. Default: TCP'' WHERE Name = ''cluster.autoConfig.protocol''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''cluster.autoConfig.protocol'', ''Protocol used to communicate between cluster nodes.  Options are either TCP (preferred) or UDP. Default: TCP'', ''STRING'', ''TCP'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'cluster.autoConfig.hosts';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''Required for TCP only: must specify all hosts in cluster using a comma-separated syntax like: host1,host2. Default: <blank>'' WHERE Name = ''cluster.autoConfig.hosts''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''cluster.autoConfig.hosts'', ''Required for TCP only: must specify all hosts in cluster using a comma-separated syntax like: host1,host2. Default: <blank>'', ''STRING'', '''', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'cluster.autoConfig.nic';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''Optional for TCP/UDP: name of network interface card for every node (e.g., "etho0").  If not specified, defaults to first non-loopback nic on every node, which is usually sufficient. Default: <blank>'' WHERE Name = ''cluster.autoConfig.nic''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''cluster.autoConfig.nic'', ''Optional for TCP/UDP: name of network interface card for every node (e.g., "etho0").  If not specified, defaults to first non-loopback nic on every node, which is usually sufficient. Default: <blank>'', ''STRING'', '''', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'cluster.autoConfig.port';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Required for TCP/UDP: port used to communicate between cluster nodes.  If zero, defaults to 7800 (TCP) or 45588 (UDP). Default: 0'' WHERE Name = ''cluster.autoConfig.port''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''cluster.autoConfig.port'', ''Required for TCP/UDP: port used to communicate between cluster nodes.  If zero, defaults to 7800 (TCP) or 45588 (UDP). Default: 0'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'cluster.configUrl';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''Location of existing jgroups configuration file.  Use only if autoConfig options are not sufficient.  Default: <blank>'' WHERE Name = ''cluster.configUrl''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''cluster.configUrl'', ''Location of existing jgroups configuration file.  Use only if autoConfig options are not sufficient.  Default: <blank>'', ''STRING'', '''', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'cluster.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Enables clustering. Only enable if installed on a clustered application server.  Default: 0'' WHERE Name = ''cluster.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''cluster.enabled'', ''Enables clustering. Only enable if installed on a clustered application server.  Default: 0'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'cpuMonitoring.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''FOR INTERNAL USE ONLY - Do not change. This Control>Center instance will run CPU monitoring reports. Default: 0'' WHERE Name = ''cpuMonitoring.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''cpuMonitoring.enabled'', ''FOR INTERNAL USE ONLY - Do not change. This Control>Center instance will run CPU monitoring reports. Default: 0'', ''INTEGER'', ''0'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'cpuMonitoring.digest';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''Y'', Description = ''FOR INTERNAL USE ONLY - Do not change. Control>Center instance digest for CPU monitoring reports. Default: <blank>'' WHERE Name = ''cpuMonitoring.digest''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''cpuMonitoring.digest'', ''FOR INTERNAL USE ONLY - Do not change. Control>Center instance digest for CPU monitoring reports. Default: <blank>'', ''STRING'', '''', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'cpuUsageReportCheck.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''This Control>Center instance will run and check CPU usage reports. Default: 0'' WHERE Name = ''cpuUsageReportCheck.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''cpuUsageReportCheck.enabled'', ''This Control>Center instance will run and check CPU usage reports. Default: 0'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'cpuUsageReportCheck.digest';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''Y'', Description = ''FOR INTERNAL USE ONLY. Control>Center instance digest for CPU usage report checking.'' WHERE Name = ''cpuUsageReportCheck.digest''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''cpuUsageReportCheck.digest'', ''FOR INTERNAL USE ONLY. Control>Center instance digest for CPU usage report checking.'', ''STRING'', '''', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'cpuUsageReportCheck.digestRequestTime';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''DATE'', IsHidden = ''Y'', Description = ''FOR INTERNAL USE ONLY. Generation time of request for CPU usage report check digest.'' WHERE Name = ''cpuUsageReportCheck.digestRequestTime''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''cpuUsageReportCheck.digestRequestTime'', ''FOR INTERNAL USE ONLY. Generation time of request for CPU usage report check digest.'', ''DATE'', ''2000-01-01 00:00:00.000 UTC'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'cpuUsageReportCheck.digestCreationTime';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''DATE'', IsHidden = ''Y'', Description = ''FOR INTERNAL USE ONLY. Creation time of CPU usage report check digest from keys@abinitio.com.'' WHERE Name = ''cpuUsageReportCheck.digestCreationTime''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''cpuUsageReportCheck.digestCreationTime'', ''FOR INTERNAL USE ONLY. Creation time of CPU usage report check digest from keys@abinitio.com.'', ''DATE'', ''2000-01-01 00:00:00.000 UTC'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'cpuUsageReportCheck.digestExpirationTime';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''DATE'', IsHidden = ''Y'', Description = ''FOR INTERNAL USE ONLY. Expiration time of CPU usage report check digest.'' WHERE Name = ''cpuUsageReportCheck.digestExpirationTime''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''cpuUsageReportCheck.digestExpirationTime'', ''FOR INTERNAL USE ONLY. Expiration time of CPU usage report check digest.'', ''DATE'', ''2000-01-01 00:00:00.000 UTC'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'config.lastUpdatedAt';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''Y'', Description = ''FOR INTERNAL USE ONLY - Do not change. Timestamp for when the OpConfigValue table was last changed.'' WHERE Name = ''config.lastUpdatedAt''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''config.lastUpdatedAt'', ''FOR INTERNAL USE ONLY - Do not change. Timestamp for when the OpConfigValue table was last changed.'', ''STRING'', '''', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'dbsetup.lastUpdatedAt';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''Y'', Description = ''FOR INTERNAL USE ONLY - Do not change. Timestamp for when the installation parameters were last changed.'' WHERE Name = ''dbsetup.lastUpdatedAt''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''dbsetup.lastUpdatedAt'', ''FOR INTERNAL USE ONLY - Do not change. Timestamp for when the installation parameters were last changed.'', ''STRING'', '''', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'cluster.jgroups.debug';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Controls JGroups logging verbosity for troubleshooting. Default is disabled. Select the checkbox to enable verbose logging. IMPORTANT: This change results in large amount of logging output.'' WHERE Name = ''cluster.jgroups.debug''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''cluster.jgroups.debug'', ''Controls JGroups logging verbosity for troubleshooting. Default is disabled. Select the checkbox to enable verbose logging. IMPORTANT: This change results in large amount of logging output.'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'jobsWatcher.checkJobsDelayMinutes';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Delay between a change to the Control>Center job schedule and when a check is made to see if any jobs are unclaimed. Default: 5 minutes'' WHERE Name = ''jobsWatcher.checkJobsDelayMinutes''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''jobsWatcher.checkJobsDelayMinutes'', ''Delay between a change to the Control>Center job schedule and when a check is made to see if any jobs are unclaimed. Default: 5 minutes'', ''INTEGER'', ''5'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'jobsWatcher.createJobIssues.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Enables creating "job not claimed" issues on scheduled jobs when no reporter has fetched the job details. Default: 1 (enabled)'' WHERE Name = ''jobsWatcher.createJobIssues.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''jobsWatcher.createJobIssues.enabled'', ''Enables creating "job not claimed" issues on scheduled jobs when no reporter has fetched the job details. Default: 1 (enabled)'', ''INTEGER'', ''1'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'productService.defaultWarningNotificationGroup';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''The default warning notification group for products/services. Default: <blank>'' WHERE Name = ''productService.defaultWarningNotificationGroup''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''productService.defaultWarningNotificationGroup'', ''The default warning notification group for products/services. Default: <blank>'', ''STRING'', '''', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'productService.defaultErrorNotificationGroup';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''The default error notification group for products/services. Default: <blank>'' WHERE Name = ''productService.defaultErrorNotificationGroup''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''productService.defaultErrorNotificationGroup'', ''The default error notification group for products/services. Default: <blank>'', ''STRING'', '''', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'productService.defaultCriticalErrorNotificationGroup';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''The default critical error notification group for products/services. Default: <blank>'' WHERE Name = ''productService.defaultCriticalErrorNotificationGroup''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''productService.defaultCriticalErrorNotificationGroup'', ''The default critical error notification group for products/services. Default: <blank>'', ''STRING'', '''', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'reporter.defaultWarningNotificationGroup';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''The default warning notification group for reporter issues. Default: <blank>'' WHERE Name = ''reporter.defaultWarningNotificationGroup''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''reporter.defaultWarningNotificationGroup'', ''The default warning notification group for reporter issues. Default: <blank>'', ''STRING'', '''', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'reporter.defaultErrorNotificationGroup';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''The default error notification group for reporter issues. Default: <blank>'' WHERE Name = ''reporter.defaultErrorNotificationGroup''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''reporter.defaultErrorNotificationGroup'', ''The default error notification group for reporter issues. Default: <blank>'', ''STRING'', '''', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'reporter.defaultCriticalErrorNotificationGroup';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''The default critical error notification group for reporter issues. Default: <blank>'' WHERE Name = ''reporter.defaultCriticalErrorNotificationGroup''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''reporter.defaultCriticalErrorNotificationGroup'', ''The default critical error notification group for reporter issues. Default: <blank>'', ''STRING'', '''', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'reporter.reporterMissingThresholdMins';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Interval (minutes) before reporter is considered inactive. Default: 10'' WHERE Name = ''reporter.reporterMissingThresholdMins''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''reporter.reporterMissingThresholdMins'', ''Interval (minutes) before reporter is considered inactive. Default: 10'', ''INTEGER'', ''10'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'reporter.reporterMissingSeverity';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''Issue severity for "Reporter last seen active ..." issues. One of ''''info'''', ''''warning'''', ''''error'''', or ''''critical'''' Default: critical'' WHERE Name = ''reporter.reporterMissingSeverity''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''reporter.reporterMissingSeverity'', ''Issue severity for "Reporter last seen active ..." issues. One of ''''info'''', ''''warning'''', ''''error'''', or ''''critical'''' Default: critical'', ''STRING'', ''critical'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'host.defaultWarningNotificationGroup';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''The default warning notification group for hosts. Default: <blank>'' WHERE Name = ''host.defaultWarningNotificationGroup''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''host.defaultWarningNotificationGroup'', ''The default warning notification group for hosts. Default: <blank>'', ''STRING'', '''', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'host.defaultErrorNotificationGroup';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''The default error notification group for hosts. Default: <blank>'' WHERE Name = ''host.defaultErrorNotificationGroup''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''host.defaultErrorNotificationGroup'', ''The default error notification group for hosts. Default: <blank>'', ''STRING'', '''', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'host.defaultCriticalErrorNotificationGroup';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''The default critical error notification group for hosts. Default: <blank>'' WHERE Name = ''host.defaultCriticalErrorNotificationGroup''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''host.defaultCriticalErrorNotificationGroup'', ''The default critical error notification group for hosts. Default: <blank>'', ''STRING'', '''', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'reporterConfig.wssEncryptedPasswordFormat';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''The format to be used for encrypted web service account passwords. Can be 0, 1 or 2. Default: 0'' WHERE Name = ''reporterConfig.wssEncryptedPasswordFormat''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''reporterConfig.wssEncryptedPasswordFormat'', ''The format to be used for encrypted web service account passwords. Can be 0, 1 or 2. Default: 0'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'email.browserUrl';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''The base URL needed to reach the Control>Center -- for example: https://acme.org:1234/controlcenter. Enables Control>Center to email links to views of jobs or other objects of interest. Default: <blank>'' WHERE Name = ''email.browserUrl''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''email.browserUrl'', ''The base URL needed to reach the Control>Center -- for example: https://acme.org:1234/controlcenter. Enables Control>Center to email links to views of jobs or other objects of interest. Default: <blank>'', ''STRING'', '''', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'email.fromAddress';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''Address from which email notifications will be sent. Default: <blank>'' WHERE Name = ''email.fromAddress''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''email.fromAddress'', ''Address from which email notifications will be sent. Default: <blank>'', ''STRING'', '''', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'email.mailHost';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''SMTP server hostname used to send email notifications. Default: <blank>'' WHERE Name = ''email.mailHost''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''email.mailHost'', ''SMTP server hostname used to send email notifications. Default: <blank>'', ''STRING'', '''', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'email.port';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''SMTP server port used to send email notifications. Default: 25'' WHERE Name = ''email.port''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''email.port'', ''SMTP server port used to send email notifications. Default: 25'', ''INTEGER'', ''25'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'email.protocol';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''Protocol used to send email notifications. Can be smtp or smtps. Default: smtp'' WHERE Name = ''email.protocol''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''email.protocol'', ''Protocol used to send email notifications. Can be smtp or smtps. Default: smtp'', ''STRING'', ''smtp'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'email.username';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''Username to use for authenticating email notifications.'' WHERE Name = ''email.username''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''email.username'', ''Username to use for authenticating email notifications.'', ''STRING'', '''', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'email.password';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''PASSWORD'', IsHidden = ''N'', Description = ''Password to use for authenticating email notifications.'' WHERE Name = ''email.password''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''email.password'', ''Password to use for authenticating email notifications.'', ''PASSWORD'', '''', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'email.uiLink.include';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''Include link(s) to UI in email, NONE, FLEX, HTML5, or ALL: Default: ALL'' WHERE Name = ''email.uiLink.include''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''email.uiLink.include'', ''Include link(s) to UI in email, NONE, FLEX, HTML5, or ALL: Default: ALL'', ''STRING'', ''ALL'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'interop.help.url';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''The URL needed to access the Ab Initio Help server, for example, http://helpserver:8080/help. Default: <blank>'' WHERE Name = ''interop.help.url''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''interop.help.url'', ''The URL needed to access the Ab Initio Help server, for example, http://helpserver:8080/help. Default: <blank>'', ''STRING'', '''', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'help.version';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''Y'', Description = ''FOR INTERNAL USE ONLY. The version of help requested from the Ab Initio Help server. Default: 4.2.3'' WHERE Name = ''help.version''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''help.version'', ''FOR INTERNAL USE ONLY. The version of help requested from the Ab Initio Help server. Default: 4.2.3'', ''STRING'', ''4.2.3'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'integration.appconf.propertyTypes';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''List of Application Configuration property types: Name1:Description1,...'' WHERE Name = ''integration.appconf.propertyTypes''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''integration.appconf.propertyTypes'', ''List of Application Configuration property types: Name1:Description1,...'', ''STRING'', ''LOGICAL_USER:User account requesting Application Configuration Environment job.,APPLICATION_CONFIGURATION:Name of the configuration for the Application Configuration Environment job,APPLICATION_TEMPLATE:Name of the template for the Application Configuration Environment job'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'interop.trw.url';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''URL for the EME Technical Repository Web Interface. Default: <blank>'' WHERE Name = ''interop.trw.url''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''interop.trw.url'', ''URL for the EME Technical Repository Web Interface. Default: <blank>'', ''STRING'', '''', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'metrics.allHostsMetricWindowSecs';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Maximum number of seconds to search back for host history metrics. Default: 604800 (7 days)'' WHERE Name = ''metrics.allHostsMetricWindowSecs''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''metrics.allHostsMetricWindowSecs'', ''Maximum number of seconds to search back for host history metrics. Default: 604800 (7 days)'', ''INTEGER'', ''604800'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'metrics.maxChartPoints';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Maximum number of points shown in the history chart. Default: 50'' WHERE Name = ''metrics.maxChartPoints''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''metrics.maxChartPoints'', ''Maximum number of points shown in the history chart. Default: 50'', ''INTEGER'', ''50'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'metrics.maxMetricValueHistoryDepth';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Maximum number of history values sent to the CoS for history-based metrics. Default: 50'' WHERE Name = ''metrics.maxMetricValueHistoryDepth''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''metrics.maxMetricValueHistoryDepth'', ''Maximum number of history values sent to the CoS for history-based metrics. Default: 50'', ''INTEGER'', ''50'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'metrics.minMetricValueHistoryDepth';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Minimum number of history values sent to the CoS for history-based metrics. Default: 3'' WHERE Name = ''metrics.minMetricValueHistoryDepth''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''metrics.minMetricValueHistoryDepth'', ''Minimum number of history values sent to the CoS for history-based metrics. Default: 3'', ''INTEGER'', ''3'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'metrics.recalcHistoryStatsSecs';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Interval in seconds between recalculations of history stats. Default: 3600'' WHERE Name = ''metrics.recalcHistoryStatsSecs''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''metrics.recalcHistoryStatsSecs'', ''Interval in seconds between recalculations of history stats. Default: 3600'', ''INTEGER'', ''3600'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'metrics.staleHostMetricValueIntervalSecs';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Interval in seconds after which values in the Hosts grid become stale. Default: 300'' WHERE Name = ''metrics.staleHostMetricValueIntervalSecs''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''metrics.staleHostMetricValueIntervalSecs'', ''Interval in seconds after which values in the Hosts grid become stale. Default: 300'', ''INTEGER'', ''300'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'network.DNS.expand';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Indicates whether the Control>Center should use a Domain Network Service (DNS) to expand host addresses into fully-qualified domain names. Default: 1'' WHERE Name = ''network.DNS.expand''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''network.DNS.expand'', ''Indicates whether the Control>Center should use a Domain Network Service (DNS) to expand host addresses into fully-qualified domain names. Default: 1'', ''INTEGER'', ''1'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'network.rfc2396.validate';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Determines whether the Control>Center validates host and host alias names according to RFC 2396. To validate existing hostnames, restart the Control>Center web application. Default: 0'' WHERE Name = ''network.rfc2396.validate''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''network.rfc2396.validate'', ''Determines whether the Control>Center validates host and host alias names according to RFC 2396. To validate existing hostnames, restart the Control>Center web application. Default: 0'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'ocagent.scheduler.identification';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''Identifies each Co>Operating System host''''s unique scheduling reporter. Only necessary when a host is configured with multiple reporters for multiple graph execution spaces. Example: host1.acme.org=/ab/workdir. Default: <blank>'' WHERE Name = ''ocagent.scheduler.identification''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''ocagent.scheduler.identification'', ''Identifies each Co>Operating System host''''s unique scheduling reporter. Only necessary when a host is configured with multiple reporters for multiple graph execution spaces. Example: host1.acme.org=/ab/workdir. Default: <blank>'', ''STRING'', '''', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'predictiveMonitoring.avgJobDuration.defaultSeconds';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Default duration (seconds) to use when too few jobs are available to calculate average job duration from job history. Default: 60'' WHERE Name = ''predictiveMonitoring.avgJobDuration.defaultSeconds''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''predictiveMonitoring.avgJobDuration.defaultSeconds'', ''Default duration (seconds) to use when too few jobs are available to calculate average job duration from job history. Default: 60'', ''INTEGER'', ''60'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'predictiveMonitoring.avgJobDuration.minHistoryDepth';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Minimum number of successful job runs in the past 28 days required to use the calculated average duration. Default: 3'' WHERE Name = ''predictiveMonitoring.avgJobDuration.minHistoryDepth''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''predictiveMonitoring.avgJobDuration.minHistoryDepth'', ''Minimum number of successful job runs in the past 28 days required to use the calculated average duration. Default: 3'', ''INTEGER'', ''3'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'purgeData.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Enables automated purge. Default: 1'' WHERE Name = ''purgeData.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''purgeData.enabled'', ''Enables automated purge. Default: 1'', ''INTEGER'', ''1'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'purgeData.nextRun';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''DATE'', IsHidden = ''Y'', Description = ''When the next automated purge should run; 1-Jan-2000 means never.  Default: 2000-01-01 00:00:00.000 UTC'' WHERE Name = ''purgeData.nextRun''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''purgeData.nextRun'', ''When the next automated purge should run; 1-Jan-2000 means never.  Default: 2000-01-01 00:00:00.000 UTC'', ''DATE'', ''2000-01-01 00:00:00.000 UTC'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'purgeData.howOften';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''Y'', Description = ''Whether automated purge runs daily or weekly.  Default: daily'' WHERE Name = ''purgeData.howOften''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''purgeData.howOften'', ''Whether automated purge runs daily or weekly.  Default: daily'', ''STRING'', ''daily'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'purgeData.daysToRun';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''Y'', Description = ''Comma-separated list of days to run automated purge; 0=Sunday, 1=Monday...  Default: <blank>'' WHERE Name = ''purgeData.daysToRun''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''purgeData.daysToRun'', ''Comma-separated list of days to run automated purge; 0=Sunday, 1=Monday...  Default: <blank>'', ''STRING'', '''', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'purgeData.timeOfDay';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''Y'', Description = ''Time of day to run automated purge. Default: 00:00'' WHERE Name = ''purgeData.timeOfDay''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''purgeData.timeOfDay'', ''Time of day to run automated purge. Default: 00:00'', ''STRING'', ''00:00'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'purgeData.timeZone';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''Y'', Description = ''Time zone in which to run automated purge. Default: UTC'' WHERE Name = ''purgeData.timeZone''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''purgeData.timeZone'', ''Time zone in which to run automated purge. Default: UTC'', ''STRING'', ''UTC'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'purgeData.jobs.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Enabled automated purge of jobs and job history.  Default: 1'' WHERE Name = ''purgeData.jobs.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''purgeData.jobs.enabled'', ''Enabled automated purge of jobs and job history.  Default: 1'', ''INTEGER'', ''1'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'purgeData.jobs.olderThanDays';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Days of job history to keep for automated purge.  Default: 365'' WHERE Name = ''purgeData.jobs.olderThanDays''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''purgeData.jobs.olderThanDays'', ''Days of job history to keep for automated purge.  Default: 365'', ''INTEGER'', ''365'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'purgeData.forcePurgeOldMetricValues.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Purges all metric values older than the user specified job purge threshold. The practical effect is to limit the metric data associated with long-running jobs. Default: 1'' WHERE Name = ''purgeData.forcePurgeOldMetricValues.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''purgeData.forcePurgeOldMetricValues.enabled'', ''Purges all metric values older than the user specified job purge threshold. The practical effect is to limit the metric data associated with long-running jobs. Default: 1'', ''INTEGER'', ''1'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'purgeData.forcePurgeKeyData.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Purges all key data for which there are no references. Default: 1'' WHERE Name = ''purgeData.forcePurgeKeyData.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''purgeData.forcePurgeKeyData.enabled'', ''Purges all key data for which there are no references. Default: 1'', ''INTEGER'', ''1'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'purgeData.purgeUnusedExecutables.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Purges all executables that are no longer associated with a job, metric, or other executable. Default: 0'' WHERE Name = ''purgeData.purgeUnusedExecutables.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''purgeData.purgeUnusedExecutables.enabled'', ''Purges all executables that are no longer associated with a job, metric, or other executable. Default: 0'', ''INTEGER'', ''0'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'purgeData.purgeUnusedEmeExecutables.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Purges all EME executables that are no longer associated with a metric or executable. Default: 0'' WHERE Name = ''purgeData.purgeUnusedEmeExecutables.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''purgeData.purgeUnusedEmeExecutables.enabled'', ''Purges all EME executables that are no longer associated with a metric or executable. Default: 0'', ''INTEGER'', ''0'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'purgeData.purgeOldResources.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Purges all resource servers and requests older than the user specified job purge threshold. Default: 0'' WHERE Name = ''purgeData.purgeOldResources.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''purgeData.purgeOldResources.enabled'', ''Purges all resource servers and requests older than the user specified job purge threshold. Default: 0'', ''INTEGER'', ''0'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'purgeData.jobs.runningAlso';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Should automated purge delete running jobs?  Default: 0'' WHERE Name = ''purgeData.jobs.runningAlso''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''purgeData.jobs.runningAlso'', ''Should automated purge delete running jobs?  Default: 0'', ''INTEGER'', ''0'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'purgeData.jobs.scheduledAlso';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Should automated purge delete scheduled jobs?  Default: 1'' WHERE Name = ''purgeData.jobs.scheduledAlso''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''purgeData.jobs.scheduledAlso'', ''Should automated purge delete scheduled jobs?  Default: 1'', ''INTEGER'', ''1'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'purgeData.queues.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Enable automated purge of queue history.  Default: 1'' WHERE Name = ''purgeData.queues.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''purgeData.queues.enabled'', ''Enable automated purge of queue history.  Default: 1'', ''INTEGER'', ''1'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'purgeData.queues.olderThanDays';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Days of queue history to keep for automated purge.  Default: 365'' WHERE Name = ''purgeData.queues.olderThanDays''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''purgeData.queues.olderThanDays'', ''Days of queue history to keep for automated purge.  Default: 365'', ''INTEGER'', ''365'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'purgeData.hosts.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Enable automated purge of host history.  Default: 1'' WHERE Name = ''purgeData.hosts.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''purgeData.hosts.enabled'', ''Enable automated purge of host history.  Default: 1'', ''INTEGER'', ''1'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'purgeData.hosts.olderThanDays';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Days of host history to keep for automated purge.  Default: 365'' WHERE Name = ''purgeData.hosts.olderThanDays''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''purgeData.hosts.olderThanDays'', ''Days of host history to keep for automated purge.  Default: 365'', ''INTEGER'', ''365'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'purgeData.products.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Enable automated purge of product history.  Default: 1'' WHERE Name = ''purgeData.products.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''purgeData.products.enabled'', ''Enable automated purge of product history.  Default: 1'', ''INTEGER'', ''1'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'purgeData.products.olderThanDays';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Days of product history to keep for automated purge.  Default: 365'' WHERE Name = ''purgeData.products.olderThanDays''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''purgeData.products.olderThanDays'', ''Days of product history to keep for automated purge.  Default: 365'', ''INTEGER'', ''365'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'purgeData.propertyTypes.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Purges all property types that are marked for delete and have no remaining references. Default: 1'' WHERE Name = ''purgeData.propertyTypes.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''purgeData.propertyTypes.enabled'', ''Purges all property types that are marked for delete and have no remaining references. Default: 1'', ''INTEGER'', ''1'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'purgeData.reporters.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Enable automated purge of reporter history.  Default: 1'' WHERE Name = ''purgeData.reporters.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''purgeData.reporters.enabled'', ''Enable automated purge of reporter history.  Default: 1'', ''INTEGER'', ''1'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'purgeData.reporters.olderThanDays';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Days of reporter history to keep for automated purge.  Default: 365'' WHERE Name = ''purgeData.reporters.olderThanDays''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''purgeData.reporters.olderThanDays'', ''Days of reporter history to keep for automated purge.  Default: 365'', ''INTEGER'', ''365'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'purgeData.systems.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Enable automated purge of reporter history.  Default: 1'' WHERE Name = ''purgeData.systems.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''purgeData.systems.enabled'', ''Enable automated purge of reporter history.  Default: 1'', ''INTEGER'', ''1'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'purgeData.systems.olderThanDays';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Days of system history to keep for automated purge.  Default: 365'' WHERE Name = ''purgeData.systems.olderThanDays''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''purgeData.systems.olderThanDays'', ''Days of system history to keep for automated purge.  Default: 365'', ''INTEGER'', ''365'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'purgeData.jamon.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Enable automated purge of JAMon report history.  Default: 1'' WHERE Name = ''purgeData.jamon.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''purgeData.jamon.enabled'', ''Enable automated purge of JAMon report history.  Default: 1'', ''INTEGER'', ''1'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'purgeData.jamon.olderThanDays';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Days of hourly JAMon report history to keep for automated purge.  Default: 14'' WHERE Name = ''purgeData.jamon.olderThanDays''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''purgeData.jamon.olderThanDays'', ''Days of hourly JAMon report history to keep for automated purge.  Default: 14'', ''INTEGER'', ''14'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'dailyCpuRollup.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Enable daily CPU rollup background task. Default: 0'' WHERE Name = ''dailyCpuRollup.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''dailyCpuRollup.enabled'', ''Enable daily CPU rollup background task. Default: 0'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'dailyCpuRollup.lookBackDays';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Recent days covered by daily CPU rollup task.  Default: 7'' WHERE Name = ''dailyCpuRollup.lookBackDays''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''dailyCpuRollup.lookBackDays'', ''Recent days covered by daily CPU rollup task.  Default: 7'', ''INTEGER'', ''7'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'dailyCpuRollup.timeOfDay';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''Y'', Description = ''Time of day to run daily CPU rollup background task. Default: 03:00'' WHERE Name = ''dailyCpuRollup.timeOfDay''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''dailyCpuRollup.timeOfDay'', ''Time of day to run daily CPU rollup background task. Default: 03:00'', ''STRING'', ''03:00'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'dailyCpuRollup.timeZone';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''Y'', Description = ''Time zone of dailyCpuRollup.timeOfDay. Default: UTC'' WHERE Name = ''dailyCpuRollup.timeZone''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''dailyCpuRollup.timeZone'', ''Time zone of dailyCpuRollup.timeOfDay. Default: UTC'', ''STRING'', ''UTC'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'dailyCpuRollup.nextRun';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''DATE'', IsHidden = ''Y'', Description = ''Scheduled time for new run of daily CPU rollup background task. Read-only. No default.'' WHERE Name = ''dailyCpuRollup.nextRun''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''dailyCpuRollup.nextRun'', ''Scheduled time for new run of daily CPU rollup background task. Read-only. No default.'', ''DATE'', ''2000-01-01 00:00:00.000 UTC'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'dbHealthReport.queries.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Enable running DB health report queries at application start. Default: 0'' WHERE Name = ''dbHealthReport.queries.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''dbHealthReport.queries.enabled'', ''Enable running DB health report queries at application start. Default: 0'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'dbHealthReport.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Enable running DB health report at application start. Default: 1'' WHERE Name = ''dbHealthReport.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''dbHealthReport.enabled'', ''Enable running DB health report at application start. Default: 1'', ''INTEGER'', ''1'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'jdbc.maxActiveConnections';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''The maximum number of outstanding JDBC connections to the database. Default: 8'' WHERE Name = ''jdbc.maxActiveConnections''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''jdbc.maxActiveConnections'', ''The maximum number of outstanding JDBC connections to the database. Default: 8'', ''INTEGER'', ''8'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'queue.multipublisher.keepAsClientMins';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Number of minutes after job completion a graph job will be associated with its target multipublisher queue. Default: 1440 (1 day)'' WHERE Name = ''queue.multipublisher.keepAsClientMins''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''queue.multipublisher.keepAsClientMins'', ''Number of minutes after job completion a graph job will be associated with its target multipublisher queue. Default: 1440 (1 day)'', ''INTEGER'', ''1440'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'queue.email.sendIntervalMinutes';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''A floor on how often issue emails will be sent for any one queue. Default: 60 (1 hour)'' WHERE Name = ''queue.email.sendIntervalMinutes''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''queue.email.sendIntervalMinutes'', ''A floor on how often issue emails will be sent for any one queue. Default: 60 (1 hour)'', ''INTEGER'', ''60'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'queue.email.sendOnResolvedIssue.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Send emails on any queue status change, or (disabled) send email on queue status change from OK to any or from WARN to ERROR. Default: 0 (disabled)'' WHERE Name = ''queue.email.sendOnResolvedIssue.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''queue.email.sendOnResolvedIssue.enabled'', ''Send emails on any queue status change, or (disabled) send email on queue status change from OK to any or from WARN to ERROR. Default: 0 (disabled)'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'SchemaVersion';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''Y'', Description = ''FOR INTERNAL USE ONLY. The internal value for the database schema. The Schema Upgrade scripts consult this value to decide which upgrades to perform. Default: 4.2.3'' WHERE Name = ''SchemaVersion''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''SchemaVersion'', ''FOR INTERNAL USE ONLY. The internal value for the database schema. The Schema Upgrade scripts consult this value to decide which upgrades to perform. Default: 4.2.3'', ''STRING'', ''4.2.3'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'security.adminpage.sqlconsole.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Determine whether SQL console on the admin page is enabled. Default: 1'' WHERE Name = ''security.adminpage.sqlconsole.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''security.adminpage.sqlconsole.enabled'', ''Determine whether SQL console on the admin page is enabled. Default: 1'', ''INTEGER'', ''1'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'security.adminpage.jobdeletion.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Determine whether job deletion from the admin page is enabled. Default: 0'' WHERE Name = ''security.adminpage.jobdeletion.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''security.adminpage.jobdeletion.enabled'', ''Determine whether job deletion from the admin page is enabled. Default: 0'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'authorizationGateway.url';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''Y'', Description = ''URL for Authorization Gateway. Default: http://myAGHost:8080/AuthGateway/'' WHERE Name = ''authorizationGateway.url''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''authorizationGateway.url'', ''URL for Authorization Gateway. Default: http://myAGHost:8080/AuthGateway/'', ''STRING'', ''http://myAGHost:8080/AuthGateway/'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'authorizationGateway.username';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''Y'', Description = ''Authorization Gateway username used when connecting to AG. User must be defined in OC database. Default: agUser'' WHERE Name = ''authorizationGateway.username''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''authorizationGateway.username'', ''Authorization Gateway username used when connecting to AG. User must be defined in OC database. Default: agUser'', ''STRING'', ''agUser'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'authorizationGateway.password';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''PASSWORD'', IsHidden = ''Y'', Description = ''AES-encrypted Authorization Gateway password used when connecting to AG. Default: <blank>'' WHERE Name = ''authorizationGateway.password''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''authorizationGateway.password'', ''AES-encrypted Authorization Gateway password used when connecting to AG. Default: <blank>'', ''PASSWORD'', '''', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'authorizationGateway.productName';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''Y'', Description = ''Name displayed within Authorization Gateway for this OC instance. If blank, the product name is generated by OC based on the database configuration values. If you specify a name, it must be unique (no other product within AG has the same name). Default: <blank>'' WHERE Name = ''authorizationGateway.productName''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''authorizationGateway.productName'', ''Name displayed within Authorization Gateway for this OC instance. If blank, the product name is generated by OC based on the database configuration values. If you specify a name, it must be unique (no other product within AG has the same name). Default: <blank>'', ''STRING'', '''', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'authorizationGateway.productDescription';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''Y'', Description = ''Description for Authorization Gateway for this OC. Default: <blank>'' WHERE Name = ''authorizationGateway.productDescription''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''authorizationGateway.productDescription'', ''Description for Authorization Gateway for this OC. Default: <blank>'', ''STRING'', '''', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'security.requireSecureTransport.httpsPort';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Application server HTTPS port number. Default: 8443'' WHERE Name = ''security.requireSecureTransport.httpsPort''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''security.requireSecureTransport.httpsPort'', ''Application server HTTPS port number. Default: 8443'', ''INTEGER'', ''8443'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'authentication.type';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''The authentication provider used to authenticate user accounts. Can be one of SSO, AG or Local. Default: Local'' WHERE Name = ''authentication.type''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''authentication.type'', ''The authentication provider used to authenticate user accounts. Can be one of SSO, AG or Local. Default: Local'', ''STRING'', ''Local'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'authorization.type';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''The authorization provider that manages roles and groups for authenticated users. Can be one of AG or Local. This value should match the value of the authorization.type parameter (unless the value of the authorization.type parameters is SSO). Default: Local'' WHERE Name = ''authorization.type''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''authorization.type'', ''The authorization provider that manages roles and groups for authenticated users. Can be one of AG or Local. This value should match the value of the authorization.type parameter (unless the value of the authorization.type parameters is SSO). Default: Local'', ''STRING'', ''Local'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'isAGJoined';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Is the application joined to the AG'' WHERE Name = ''isAGJoined''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''isAGJoined'', ''Is the application joined to the AG'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'authentication.enableDirectLogin';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Determines whether authentication is allowed via the Control_Center_base_URL/authenticate/login.jsp endpoint. If the Control>Center is connected to an Authorization Gateway, this endpoint will use the Authorization Gateway to authenticate credentials. If the Control>Center is not connected to an Authorization Gateway, the endpoint will use the local database to authenticate credentials. Select the Value checkbox to allow authentication via the Control_Center_base_URL/authenticate/login.jsp endpoint. NOTE: The value of this parameter will only be used when the value of the authentication.type parameter is set to SSO. Default: 1'' WHERE Name = ''authentication.enableDirectLogin''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''authentication.enableDirectLogin'', ''Determines whether authentication is allowed via the Control_Center_base_URL/authenticate/login.jsp endpoint. If the Control>Center is connected to an Authorization Gateway, this endpoint will use the Authorization Gateway to authenticate credentials. If the Control>Center is not connected to an Authorization Gateway, the endpoint will use the local database to authenticate credentials. Select the Value checkbox to allow authentication via the Control_Center_base_URL/authenticate/login.jsp endpoint. NOTE: The value of this parameter will only be used when the value of the authentication.type parameter is set to SSO. Default: 1'', ''INTEGER'', ''1'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'security.requireSecureTransport.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Require secure https protocol used by browsers and web service clients (reporters). Default: 1'' WHERE Name = ''security.requireSecureTransport.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''security.requireSecureTransport.enabled'', ''Require secure https protocol used by browsers and web service clients (reporters). Default: 1'', ''INTEGER'', ''1'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'security.concurrentSessionPrevention.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Controls whether concurrent session prevention for browser access is enabled. If set to 1, a user may not have more than one active session at any time. Changing this value requires application restart. Default: 0'' WHERE Name = ''security.concurrentSessionPrevention.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''security.concurrentSessionPrevention.enabled'', ''Controls whether concurrent session prevention for browser access is enabled. If set to 1, a user may not have more than one active session at any time. Changing this value requires application restart. Default: 0'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'security.concurrentSessionPrevention.invalidateSession';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Controls whether disabled concurrent session is also invalidated. Note, this can result in loss of work. Only effective when security.concurrentSessionPrevention.enabled is set to 1. Changing this value requires application restart. Default: 0'' WHERE Name = ''security.concurrentSessionPrevention.invalidateSession''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''security.concurrentSessionPrevention.invalidateSession'', ''Controls whether disabled concurrent session is also invalidated. Note, this can result in loss of work. Only effective when security.concurrentSessionPrevention.enabled is set to 1. Changing this value requires application restart. Default: 0'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'security.csrfPreventionEnabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Controls whether CSRF Prevention for browser access is enabled. Changing this value requires application restart. Default: 1'' WHERE Name = ''security.csrfPreventionEnabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''security.csrfPreventionEnabled'', ''Controls whether CSRF Prevention for browser access is enabled. Changing this value requires application restart. Default: 1'', ''INTEGER'', ''1'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'security.http.headers.xContentTypeOptions.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Determines whether X-Content-Type-Options header is set in server responses. Changing this value requires application restart. Default: 1'' WHERE Name = ''security.http.headers.xContentTypeOptions.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''security.http.headers.xContentTypeOptions.enabled'', ''Determines whether X-Content-Type-Options header is set in server responses. Changing this value requires application restart. Default: 1'', ''INTEGER'', ''1'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'security.headers.xFrameOptions';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''Sets X-Frame-Options header in the server responses. Valid options are DENY, SAMEORIGIN, None. Header is turned off if None is selected. Changing this value requires application restart. Default: DENY'' WHERE Name = ''security.headers.xFrameOptions''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''security.headers.xFrameOptions'', ''Sets X-Frame-Options header in the server responses. Valid options are DENY, SAMEORIGIN, None. Header is turned off if None is selected. Changing this value requires application restart. Default: DENY'', ''STRING'', ''DENY'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'security.http.headers.xXssProtection.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Determines whether X-XSS-Protection header is set in server responses.  Changing this value requires application restart. Default: 1'' WHERE Name = ''security.http.headers.xXssProtection.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''security.http.headers.xXssProtection.enabled'', ''Determines whether X-XSS-Protection header is set in server responses.  Changing this value requires application restart. Default: 1'', ''INTEGER'', ''1'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'security.secureCookiesEnabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''If security.requireSecureTransport.enabled is set to "false", the value of this parameter determines whether the application sets the "secure" flag on cookies it returns.'' WHERE Name = ''security.secureCookiesEnabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''security.secureCookiesEnabled'', ''If security.requireSecureTransport.enabled is set to "false", the value of this parameter determines whether the application sets the "secure" flag on cookies it returns.'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'authentication.logoutUrl';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''URL through which Single Sign-On Provider (e.g., Siteminder) is notified upon Control>Center user logout. Contact your SSO administrator for correct URL. Default: /controlcenter.html'' WHERE Name = ''authentication.logoutUrl''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''authentication.logoutUrl'', ''URL through which Single Sign-On Provider (e.g., Siteminder) is notified upon Control>Center user logout. Contact your SSO administrator for correct URL. Default: /controlcenter.html'', ''STRING'', ''/controlcenter.html'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'security.password.length.min';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Minimum length in characters of OC account passwords. Default: 1'' WHERE Name = ''security.password.length.min''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''security.password.length.min'', ''Minimum length in characters of OC account passwords. Default: 1'', ''INTEGER'', ''1'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'packageForSupport.encrypted';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''Determines whether or not encryption will be performed when creating a Package for Support. ''''Never'''' means a Package for Support will never be encrypted. ''''Always'''' means a Package for Support will always be encrypted. ''''EncryptForNonAdmins'''' means the Package for Support will only be encrypted when created by a user who does not have Administrator privileges. Default: ''''EncryptForNonAdmins'''''' WHERE Name = ''packageForSupport.encrypted''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''packageForSupport.encrypted'', ''Determines whether or not encryption will be performed when creating a Package for Support. ''''Never'''' means a Package for Support will never be encrypted. ''''Always'''' means a Package for Support will always be encrypted. ''''EncryptForNonAdmins'''' means the Package for Support will only be encrypted when created by a user who does not have Administrator privileges. Default: ''''EncryptForNonAdmins'''''', ''STRING'', ''EncryptForNonAdmins'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'authentication.sso.type';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''Specifies the type of SSO pre-authentication to be used. One of ''''Header'''', ''''OAuth2'''', ''''J2EE'''', or ''''SAML2''''. Default: Header'' WHERE Name = ''authentication.sso.type''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''authentication.sso.type'', ''Specifies the type of SSO pre-authentication to be used. One of ''''Header'''', ''''OAuth2'''', ''''J2EE'''', or ''''SAML2''''. Default: Header'', ''STRING'', ''Header'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'authentication.sso.requestHeader';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''Request header attribute name that contains the pre-authenticated user ID. Only used when pre-authentication type is Header. Default: SM_USER'' WHERE Name = ''authentication.sso.requestHeader''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''authentication.sso.requestHeader'', ''Request header attribute name that contains the pre-authenticated user ID. Only used when pre-authentication type is Header. Default: SM_USER'', ''STRING'', ''SM_USER'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'security.webservice.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Controls whether Web Service Security is in force. Default: 1'' WHERE Name = ''security.webservice.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''security.webservice.enabled'', ''Controls whether Web Service Security is in force. Default: 1'', ''INTEGER'', ''1'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'security.webservice.sqlselect.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Controls whether SQL Select access via Web Service is in enabled. Default: 1'' WHERE Name = ''security.webservice.sqlselect.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''security.webservice.sqlselect.enabled'', ''Controls whether SQL Select access via Web Service is in enabled. Default: 1'', ''INTEGER'', ''1'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'security.webservice.sqlupdate.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Controls whether SQL Update access via Web Service is in enabled. Default: 1'' WHERE Name = ''security.webservice.sqlupdate.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''security.webservice.sqlupdate.enabled'', ''Controls whether SQL Update access via Web Service is in enabled. Default: 1'', ''INTEGER'', ''1'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'security.webservice.generatejobs.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Controls whether the Generate Jobs webservice is enabled. Default: 1'' WHERE Name = ''security.webservice.generatejobs.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''security.webservice.generatejobs.enabled'', ''Controls whether the Generate Jobs webservice is enabled. Default: 1'', ''INTEGER'', ''1'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'security.webservice.markjobs.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Control whether the Mark Jobs As Failed, Mark Jobs As Succeeded webservices are enabled. Default: 1'' WHERE Name = ''security.webservice.markjobs.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''security.webservice.markjobs.enabled'', ''Control whether the Mark Jobs As Failed, Mark Jobs As Succeeded webservices are enabled. Default: 1'', ''INTEGER'', ''1'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'security.webservice.approvedraft.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Controls whether approvers can approve draft job definitions via web service. For compatibility with pre 3.5.1 operation. Default: 0.'' WHERE Name = ''security.webservice.approvedraft.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''security.webservice.approvedraft.enabled'', ''Controls whether approvers can approve draft job definitions via web service. For compatibility with pre 3.5.1 operation. Default: 0.'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'security.allowManualGenerationOfApprovedJdsOnly.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Controls whether the ''''Manually Generate'''' option is available only for Job Definitions which have been approved. By default the action is available for in-progress and submitted Job Definitions as well. Default: 0'' WHERE Name = ''security.allowManualGenerationOfApprovedJdsOnly.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''security.allowManualGenerationOfApprovedJdsOnly.enabled'', ''Controls whether the ''''Manually Generate'''' option is available only for Job Definitions which have been approved. By default the action is available for in-progress and submitted Job Definitions as well. Default: 0'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'websockets.forceDisable';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Set to ''''1'''' if WebSockets are not working correctly in your environment.'' WHERE Name = ''websockets.forceDisable''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''websockets.forceDisable'', ''Set to ''''1'''' if WebSockets are not working correctly in your environment.'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'schedule.jobGeneration.predecessorOrderingCheck.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Determines if Job Generation checks for predecessor jobs that might not have been generated. Default: 1'' WHERE Name = ''schedule.jobGeneration.predecessorOrderingCheck.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''schedule.jobGeneration.predecessorOrderingCheck.enabled'', ''Determines if Job Generation checks for predecessor jobs that might not have been generated. Default: 1'', ''INTEGER'', ''1'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'schedule.strictFunctionalUserScheduledJobDistribution.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Scheduled jobs associated with Functional User OSAuthentications will be provided only to Functional User mode reporters. For compatibility with pre 3.5.3 operation where these jobs were provided to reporters with any mode. Default: 0.'' WHERE Name = ''schedule.strictFunctionalUserScheduledJobDistribution.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''schedule.strictFunctionalUserScheduledJobDistribution.enabled'', ''Scheduled jobs associated with Functional User OSAuthentications will be provided only to Functional User mode reporters. For compatibility with pre 3.5.3 operation where these jobs were provided to reporters with any mode. Default: 0.'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'system.defaultApplicationName';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''Name of the application used for detected jobs when AB_APPLICATION_NAME is not in the job''''s parameter environment. The installer creates this value. Default: DEFAULT'' WHERE Name = ''system.defaultApplicationName''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''system.defaultApplicationName'', ''Name of the application used for detected jobs when AB_APPLICATION_NAME is not in the job''''s parameter environment. The installer creates this value. Default: DEFAULT'', ''STRING'', ''DEFAULT'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'system.defaultSystemName';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''Name of the system used for detected jobs when AB_SYSTEM_NAME is not in the job''''s parameter environment. The installer creates this value. Default: DEFAULT'' WHERE Name = ''system.defaultSystemName''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''system.defaultSystemName'', ''Name of the system used for detected jobs when AB_SYSTEM_NAME is not in the job''''s parameter environment. The installer creates this value. Default: DEFAULT'', ''STRING'', ''DEFAULT'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'viewEndUpdateService.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Enable the running of job view end processing. This allows a completed parent job to remain in the UI when still-running child jobs run over to subsequent production days. Default: 0'' WHERE Name = ''viewEndUpdateService.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''viewEndUpdateService.enabled'', ''Enable the running of job view end processing. This allows a completed parent job to remain in the UI when still-running child jobs run over to subsequent production days. Default: 0'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'viewEndUpdateService.batchSize';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Number of jobs updated by job view end processing. Default: 100 jobs'' WHERE Name = ''viewEndUpdateService.batchSize''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''viewEndUpdateService.batchSize'', ''Number of jobs updated by job view end processing. Default: 100 jobs'', ''INTEGER'', ''100'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'viewEndUpdateService.delayMinutes';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Delay after application startup before running job view end processing. Default: 5 minutes'' WHERE Name = ''viewEndUpdateService.delayMinutes''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''viewEndUpdateService.delayMinutes'', ''Delay after application startup before running job view end processing. Default: 5 minutes'', ''INTEGER'', ''5'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'viewEndUpdateService.wakeupMinutes';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''How often job view end processing is run. Default: 10 minutes'' WHERE Name = ''viewEndUpdateService.wakeupMinutes''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''viewEndUpdateService.wakeupMinutes'', ''How often job view end processing is run. Default: 10 minutes'', ''INTEGER'', ''10'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'appserverType';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = '''' WHERE Name = ''appserverType''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''appserverType'', '''', ''STRING'', '''', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'urlFromBrowser';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''The base URL a web browser uses to reach the application server. For example, https://host:443/context.'' WHERE Name = ''urlFromBrowser''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''urlFromBrowser'', ''The base URL a web browser uses to reach the application server. For example, https://host:443/context.'', ''STRING'', '''', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'authentication.sso.saml.idp.metadataFile';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''SAML Identity Provider Metadata XML file path. Must be identical for all cluster members.'' WHERE Name = ''authentication.sso.saml.idp.metadataFile''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''authentication.sso.saml.idp.metadataFile'', ''SAML Identity Provider Metadata XML file path. Must be identical for all cluster members.'', ''STRING'', '''', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'authentication.sso.saml.entityId';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''This SAML Service Provider entity ID. IMPORTANT: 1. The urlFromBrowser setting must be set; 2. Do not change authentication method to SAML before the fields in this section are properly configured,  and the Service Provider metadata XML is generated. Changes require new SP metadata be submitted to IdP. You can generate this from the Administration page of the HTML5 user interface.'' WHERE Name = ''authentication.sso.saml.entityId''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''authentication.sso.saml.entityId'', ''This SAML Service Provider entity ID. IMPORTANT: 1. The urlFromBrowser setting must be set; 2. Do not change authentication method to SAML before the fields in this section are properly configured,  and the Service Provider metadata XML is generated. Changes require new SP metadata be submitted to IdP. You can generate this from the Administration page of the HTML5 user interface.'', ''STRING'', '''', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'authentication.sso.saml.requireSigned';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''When set to Yes, the application will require signed SAML assertions. Changes require new SP metadata be submitted to IdP. You can generate this from the Administration page of the HTML5 user interface.'' WHERE Name = ''authentication.sso.saml.requireSigned''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''authentication.sso.saml.requireSigned'', ''When set to Yes, the application will require signed SAML assertions. Changes require new SP metadata be submitted to IdP. You can generate this from the Administration page of the HTML5 user interface.'', ''INTEGER'', ''1'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'authentication.sso.saml.key.keyStorePath';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''File path to JKS keystore used for SAML encryption and signing. Must be identical for all cluster members. Changes require new SP metadata be submitted to IdP. You can generate this from the Administration page of the HTML5 user interface.'' WHERE Name = ''authentication.sso.saml.key.keyStorePath''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''authentication.sso.saml.key.keyStorePath'', ''File path to JKS keystore used for SAML encryption and signing. Must be identical for all cluster members. Changes require new SP metadata be submitted to IdP. You can generate this from the Administration page of the HTML5 user interface.'', ''STRING'', '''', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'authentication.sso.saml.key.keyStorePassword';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''PASSWORD'', IsHidden = ''N'', Description = ''Password for the SAML keystore.'' WHERE Name = ''authentication.sso.saml.key.keyStorePassword''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''authentication.sso.saml.key.keyStorePassword'', ''Password for the SAML keystore.'', ''PASSWORD'', '''', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'authentication.sso.saml.key.signingKeyAlias';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''Alias for key used for signing SAML requests. Can be empty if not signing. Changes require new SP metadata be submitted to IdP. You can generate this from the Administration page of the HTML5 user interface.'' WHERE Name = ''authentication.sso.saml.key.signingKeyAlias''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''authentication.sso.saml.key.signingKeyAlias'', ''Alias for key used for signing SAML requests. Can be empty if not signing. Changes require new SP metadata be submitted to IdP. You can generate this from the Administration page of the HTML5 user interface.'', ''STRING'', '''', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'authentication.sso.saml.key.signingKeyPassphrase';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''PASSWORD'', IsHidden = ''N'', Description = ''Passphrase for key used for signing SAML requests. Can be empty if not signing.'' WHERE Name = ''authentication.sso.saml.key.signingKeyPassphrase''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''authentication.sso.saml.key.signingKeyPassphrase'', ''Passphrase for key used for signing SAML requests. Can be empty if not signing.'', ''PASSWORD'', '''', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'authentication.sso.saml.key.encryptionKeyAlias';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''Alias  for key used for decrypting SAML assertions. Can be empty if not IdP is not encrypting. Changes require new SP metadata be submitted to IdP. You can generate this from the Administration page of the HTML5 user interface.'' WHERE Name = ''authentication.sso.saml.key.encryptionKeyAlias''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''authentication.sso.saml.key.encryptionKeyAlias'', ''Alias  for key used for decrypting SAML assertions. Can be empty if not IdP is not encrypting. Changes require new SP metadata be submitted to IdP. You can generate this from the Administration page of the HTML5 user interface.'', ''STRING'', '''', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'authentication.sso.saml.key.encryptionKeyPassphrase';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''PASSWORD'', IsHidden = ''N'', Description = ''Passphrase for key used for decrypting SAML assertions. Can be empty if IdP is not encrypting.'' WHERE Name = ''authentication.sso.saml.key.encryptionKeyPassphrase''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''authentication.sso.saml.key.encryptionKeyPassphrase'', ''Passphrase for key used for decrypting SAML assertions. Can be empty if IdP is not encrypting.'', ''PASSWORD'', '''', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'authentication.sso.saml.idp.otherDomainAllowed';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Allows the identity provider your organization uses to have a domain name different from your organization''''s domain name. Default is disabled. Select the checkbox to enable using a different domain name.'' WHERE Name = ''authentication.sso.saml.idp.otherDomainAllowed''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''authentication.sso.saml.idp.otherDomainAllowed'', ''Allows the identity provider your organization uses to have a domain name different from your organization''''s domain name. Default is disabled. Select the checkbox to enable using a different domain name.'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'authentication.sso.saml.debug';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''When set to Yes, additional information, including SAML assertions is logged. For troubleshooting only: may log user-identifiable information.'' WHERE Name = ''authentication.sso.saml.debug''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''authentication.sso.saml.debug'', ''When set to Yes, additional information, including SAML assertions is logged. For troubleshooting only: may log user-identifiable information.'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'security.sanitizeExceptions';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''When set to Yes, java exceptions and stack traces are suppressed when returned to users.'' WHERE Name = ''security.sanitizeExceptions''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''security.sanitizeExceptions'', ''When set to Yes, java exceptions and stack traces are suppressed when returned to users.'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'cc.initialized';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Whether or not this Control>Center has been initialized using external configuration'' WHERE Name = ''cc.initialized''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''cc.initialized'', ''Whether or not this Control>Center has been initialized using external configuration'', ''INTEGER'', ''0'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'jamon.timeZone';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''Y'', Description = ''Time zone in which to run JAMon aggregation. Default: UTC'' WHERE Name = ''jamon.timeZone''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''jamon.timeZone'', ''Time zone in which to run JAMon aggregation. Default: UTC'', ''STRING'', ''UTC'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'jamon.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Enable the collection of JAMon reports, which replace standard JAMon monitoring.'' WHERE Name = ''jamon.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''jamon.enabled'', ''Enable the collection of JAMon reports, which replace standard JAMon monitoring.'', ''INTEGER'', ''1'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'calendar.missing.horizon';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Days in advance of New Years Day in which to start checking for in-use calendars which lack entries for next year.'' WHERE Name = ''calendar.missing.horizon''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''calendar.missing.horizon'', ''Days in advance of New Years Day in which to start checking for in-use calendars which lack entries for next year.'', ''INTEGER'', ''30'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'job.alert.sendOnTimerEvents.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''N'', Description = ''Turns on HTTP alerts when SLA timers expire. This may result in lots of alerts. Default 1'' WHERE Name = ''job.alert.sendOnTimerEvents.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''job.alert.sendOnTimerEvents.enabled'', ''Turns on HTTP alerts when SLA timers expire. This may result in lots of alerts. Default 1'', ''INTEGER'', ''1'', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'server.memoryWarn.threshold';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Deprecated as of 4.2.3. Was: "Threshold percentage between peak memory usage and maximum configured before a warning is issued.  Default: 80"'' WHERE Name = ''server.memoryWarn.threshold''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''server.memoryWarn.threshold'', ''Deprecated as of 4.2.3. Was: "Threshold percentage between peak memory usage and maximum configured before a warning is issued.  Default: 80"'', ''INTEGER'', ''80'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'schedule.cluster.balance.task.intervalSec';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Experimental: The rate in seconds at which to check if any jobs should move from one cluster node to another or are in need of an initial cluster node assignment. Lower values will allow recovering from failed nodes faster while increasing processing load on the server & database. Default=60'' WHERE Name = ''schedule.cluster.balance.task.intervalSec''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''schedule.cluster.balance.task.intervalSec'', ''Experimental: The rate in seconds at which to check if any jobs should move from one cluster node to another or are in need of an initial cluster node assignment. Lower values will allow recovering from failed nodes faster while increasing processing load on the server & database. Default=60'', ''INTEGER'', ''60'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'schedule.cluster.balance.task.initialDelaySec';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Experimental: The delay after application-startup to start the task governed by ''''schedule.cluster.balance.task.intervalSec''''. A delay after startup allows for reporters to catch up if the application was stopped for a while. Default=60'' WHERE Name = ''schedule.cluster.balance.task.initialDelaySec''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''schedule.cluster.balance.task.initialDelaySec'', ''Experimental: The delay after application-startup to start the task governed by ''''schedule.cluster.balance.task.intervalSec''''. A delay after startup allows for reporters to catch up if the application was stopped for a while. Default=60'', ''INTEGER'', ''60'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'schedule.cluster.balance.cache.secondsUntilNodeStale';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Experimental: The number of seconds of not hearing from a reporter at which it is considered stale. At this point jobs assigned to that cluster node might be candidates for moving to another node. Default=120'' WHERE Name = ''schedule.cluster.balance.cache.secondsUntilNodeStale''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''schedule.cluster.balance.cache.secondsUntilNodeStale'', ''Experimental: The number of seconds of not hearing from a reporter at which it is considered stale. At this point jobs assigned to that cluster node might be candidates for moving to another node. Default=120'', ''INTEGER'', ''120'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'schedule.cluster.balance.bufferBeforeJobStartMins';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Experimental: When deciding whether to move jobs from one cluster node to another, don''''t move jobs scheduled to start within this many minutes if they already have a valid assignment. This should be somewhat greater than the total time spent waiting before moving a job, which is dictated by config params  ''''schedule.cluster.balance.cache.secondsUntilNodeStale'''', ''''schedule.cluster.balance.reassignTaskRetries'''' and ''''schedule.cluster.balance.reassignTaskRetryIntervalSec''''. Default=5'' WHERE Name = ''schedule.cluster.balance.bufferBeforeJobStartMins''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''schedule.cluster.balance.bufferBeforeJobStartMins'', ''Experimental: When deciding whether to move jobs from one cluster node to another, don''''t move jobs scheduled to start within this many minutes if they already have a valid assignment. This should be somewhat greater than the total time spent waiting before moving a job, which is dictated by config params  ''''schedule.cluster.balance.cache.secondsUntilNodeStale'''', ''''schedule.cluster.balance.reassignTaskRetries'''' and ''''schedule.cluster.balance.reassignTaskRetryIntervalSec''''. Default=5'', ''INTEGER'', ''2'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'schedule.cluster.balance.defaultStrategy.maxNodeJobCountDiff';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Experimental: When using the ''''Default'''' cluster balance strategy, this is the default maximum difference in job count between two nodes. If one node has this many more jobs than another, some jobs will be moved to attempt to evenly distribute the processing load. Default=5'' WHERE Name = ''schedule.cluster.balance.defaultStrategy.maxNodeJobCountDiff''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''schedule.cluster.balance.defaultStrategy.maxNodeJobCountDiff'', ''Experimental: When using the ''''Default'''' cluster balance strategy, this is the default maximum difference in job count between two nodes. If one node has this many more jobs than another, some jobs will be moved to attempt to evenly distribute the processing load. Default=5'', ''INTEGER'', ''5'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'schedule.cluster.balance.reassignTaskRetries';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Experimental: When moving jobs from one cluster node to another, check this many times to see if reporters have noticed & relinquished their previous schedules. Default=12'' WHERE Name = ''schedule.cluster.balance.reassignTaskRetries''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''schedule.cluster.balance.reassignTaskRetries'', ''Experimental: When moving jobs from one cluster node to another, check this many times to see if reporters have noticed & relinquished their previous schedules. Default=12'', ''INTEGER'', ''12'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'schedule.cluster.balance.reassignTaskRetryIntervalSec';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Experimental: When moving jobs from one cluster node to another, wait this long between checks to see if reporters of relinquished their previous schedule. Default=10'' WHERE Name = ''schedule.cluster.balance.reassignTaskRetryIntervalSec''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''schedule.cluster.balance.reassignTaskRetryIntervalSec'', ''Experimental: When moving jobs from one cluster node to another, wait this long between checks to see if reporters of relinquished their previous schedule. Default=10'', ''INTEGER'', ''10'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'schedule.cluster.balance.enabled';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''INTEGER'', IsHidden = ''Y'', Description = ''Experimental: Enable dynamically moving jobs between cluster nodes. Each cluster must have ''''Redistribute jobs'''' set. Default=0'' WHERE Name = ''schedule.cluster.balance.enabled''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''schedule.cluster.balance.enabled'', ''Experimental: Enable dynamically moving jobs between cluster nodes. Each cluster must have ''''Redistribute jobs'''' set. Default=0'', ''INTEGER'', ''0'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'security.http.headers.contentSecurityPolicy';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''N'', Description = ''The value of the Content-Security-Policy header for the Control>Center. In the Value text box, enter an HTTP header. If no value is specified, then no Content-Security-Policy header will be emitted. NOTE: Contact Ab Initio Support for information about the recommended policy directives.'' WHERE Name = ''security.http.headers.contentSecurityPolicy''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''security.http.headers.contentSecurityPolicy'', ''The value of the Content-Security-Policy header for the Control>Center. In the Value text box, enter an HTTP header. If no value is specified, then no Content-Security-Policy header will be emitted. NOTE: Contact Ab Initio Support for information about the recommended policy directives.'', ''STRING'', '''', ''N'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


-- ---------------------------------------------------
create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpProductType WHERE TypeName = 'AB_APP';
  if (cnt > 0) then
    execute E'UPDATE OpProductType SET ProductName=E''Ab Initio Servlet Container'', ProductNameString=E''${officialProductName} (${contextRoot})'', KeyFileProductId=E'''', ProductVendor=E''Ab Initio'', ProductVariety=E''SERVICE'', IsAddByAdmin=E''Y'', VersionTreatment=E''AUTOMATIC'', AbHomeTreatment=E''AUTOMATIC'', AbApplicationHubTreatment=E''AUTOMATIC'', RootDirectoryTreatment=E''KEY'', RootDirectoryEnvVar=E''AB_APP_HOME'', ContextRootTreatment=E''KEY'', ConfigFileTreatment=E''AUTOMATIC'', ConfigurationUserTreatment=E''REQUIRED'', PortTreatment=E''AUTOMATIC'', UrlTreatment=E''NA'', AbWorkDirTreatment=E''AUTOMATIC'', AbDataDirTreatment=E''AUTOMATIC'', LogFilePathTreatment=E''AUTOMATIC'', WorkDirTreatment=E''NA'', StartCommandString=E''ab-app start ${contextRoot}'', StopCommandString=E''ab-app stop ${contextRoot}'', RestartCommandString=E'''', StatusCommandString=E''ab-app status ${contextRoot}'', GoodStatusRegex=E''is running'', BadStatusRegex=E''is stopped'', AbAppIdentifier=E'''' WHERE TypeName = ''AB_APP''';
  else
    execute E'INSERT INTO OpProductType (ProductTypeId, TypeName,ProductName,ProductNameString,KeyFileProductId,ProductVendor,ProductVariety,IsAddByAdmin,VersionTreatment,AbHomeTreatment,AbApplicationHubTreatment,RootDirectoryTreatment,RootDirectoryEnvVar,ContextRootTreatment,ConfigFileTreatment,ConfigurationUserTreatment,PortTreatment,UrlTreatment,AbWorkDirTreatment,AbDataDirTreatment,LogFilePathTreatment,WorkDirTreatment,StartCommandString,StopCommandString,RestartCommandString,StatusCommandString,GoodStatusRegex,BadStatusRegex,AbAppIdentifier) VALUES (nextval(''hibernate_sequence''),  E''AB_APP'',E''Ab Initio Servlet Container'',E''${officialProductName} (${contextRoot})'',E'''',E''Ab Initio'',E''SERVICE'',E''Y'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''KEY'',E''AB_APP_HOME'',E''KEY'',E''AUTOMATIC'',E''REQUIRED'',E''AUTOMATIC'',E''NA'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''NA'',E''ab-app start ${contextRoot}'',E''ab-app stop ${contextRoot}'',E'''',E''ab-app status ${contextRoot}'',E''is running'',E''is stopped'',E'''')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpProductType WHERE TypeName = 'AB_APP_INSTANCE';
  if (cnt > 0) then
    execute E'UPDATE OpProductType SET ProductName=E''Ab Initio Web Application'', ProductNameString=E''${contextRoot} - ${officialProductName}'', KeyFileProductId=E'''', ProductVendor=E''Ab Initio'', ProductVariety=E''PRODUCT'', IsAddByAdmin=E''Y'', VersionTreatment=E''AUTOMATIC'', AbHomeTreatment=E''AUTOMATIC'', AbApplicationHubTreatment=E''AUTOMATIC'', RootDirectoryTreatment=E''KEY'', RootDirectoryEnvVar=E''AB_APP_HOME'', ContextRootTreatment=E''KEY'', ConfigFileTreatment=E''AUTOMATIC'', ConfigurationUserTreatment=E''REQUIRED'', PortTreatment=E''AUTOMATIC'', UrlTreatment=E''AUTOMATIC'', AbWorkDirTreatment=E''AUTOMATIC'', AbDataDirTreatment=E''AUTOMATIC'', LogFilePathTreatment=E''AUTOMATIC'', WorkDirTreatment=E''NA'', StartCommandString=E''ab-app start ${contextRoot}'', StopCommandString=E''ab-app stop ${contextRoot}'', RestartCommandString=E'''', StatusCommandString=E''ab-app status ${contextRoot}'', GoodStatusRegex=E''is running'', BadStatusRegex=E''is stopped'', AbAppIdentifier=E'''' WHERE TypeName = ''AB_APP_INSTANCE''';
  else
    execute E'INSERT INTO OpProductType (ProductTypeId, TypeName,ProductName,ProductNameString,KeyFileProductId,ProductVendor,ProductVariety,IsAddByAdmin,VersionTreatment,AbHomeTreatment,AbApplicationHubTreatment,RootDirectoryTreatment,RootDirectoryEnvVar,ContextRootTreatment,ConfigFileTreatment,ConfigurationUserTreatment,PortTreatment,UrlTreatment,AbWorkDirTreatment,AbDataDirTreatment,LogFilePathTreatment,WorkDirTreatment,StartCommandString,StopCommandString,RestartCommandString,StatusCommandString,GoodStatusRegex,BadStatusRegex,AbAppIdentifier) VALUES (nextval(''hibernate_sequence''),  E''AB_APP_INSTANCE'',E''Ab Initio Web Application'',E''${contextRoot} - ${officialProductName}'',E'''',E''Ab Initio'',E''PRODUCT'',E''Y'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''KEY'',E''AB_APP_HOME'',E''KEY'',E''AUTOMATIC'',E''REQUIRED'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''NA'',E''ab-app start ${contextRoot}'',E''ab-app stop ${contextRoot}'',E'''',E''ab-app status ${contextRoot}'',E''is running'',E''is stopped'',E'''')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpProductType WHERE TypeName = 'AB_DB';
  if (cnt > 0) then
    execute E'UPDATE OpProductType SET ProductName=E''Ab Initio Database'', ProductNameString=E''${officialProductName} (${contextRoot})'', KeyFileProductId=E'''', ProductVendor=E''Ab Initio'', ProductVariety=E''SERVICE'', IsAddByAdmin=E''Y'', VersionTreatment=E''AUTOMATIC'', AbHomeTreatment=E''NA'', AbApplicationHubTreatment=E''AUTOMATIC'', RootDirectoryTreatment=E''KEY'', RootDirectoryEnvVar=E''AB_DB_DATA_DIR'', ContextRootTreatment=E''KEY'', ConfigFileTreatment=E''AUTOMATIC'', ConfigurationUserTreatment=E''REQUIRED'', PortTreatment=E''AUTOMATIC'', UrlTreatment=E''NA'', AbWorkDirTreatment=E''AUTOMATIC'', AbDataDirTreatment=E''AUTOMATIC'', LogFilePathTreatment=E''AUTOMATIC'', WorkDirTreatment=E''NA'', StartCommandString=E''ab-db start ${contextRoot}'', StopCommandString=E''ab-db stop ${contextRoot}'', RestartCommandString=E'''', StatusCommandString=E''ab-db status ${contextRoot}'', GoodStatusRegex=E''\\\\s+Running\\\\s+'', BadStatusRegex=E''\\\\s+(Unknown|Stopped)\\\\s+'', AbAppIdentifier=E'''' WHERE TypeName = ''AB_DB''';
  else
    execute E'INSERT INTO OpProductType (ProductTypeId, TypeName,ProductName,ProductNameString,KeyFileProductId,ProductVendor,ProductVariety,IsAddByAdmin,VersionTreatment,AbHomeTreatment,AbApplicationHubTreatment,RootDirectoryTreatment,RootDirectoryEnvVar,ContextRootTreatment,ConfigFileTreatment,ConfigurationUserTreatment,PortTreatment,UrlTreatment,AbWorkDirTreatment,AbDataDirTreatment,LogFilePathTreatment,WorkDirTreatment,StartCommandString,StopCommandString,RestartCommandString,StatusCommandString,GoodStatusRegex,BadStatusRegex,AbAppIdentifier) VALUES (nextval(''hibernate_sequence''),  E''AB_DB'',E''Ab Initio Database'',E''${officialProductName} (${contextRoot})'',E'''',E''Ab Initio'',E''SERVICE'',E''Y'',E''AUTOMATIC'',E''NA'',E''AUTOMATIC'',E''KEY'',E''AB_DB_DATA_DIR'',E''KEY'',E''AUTOMATIC'',E''REQUIRED'',E''AUTOMATIC'',E''NA'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''NA'',E''ab-db start ${contextRoot}'',E''ab-db stop ${contextRoot}'',E'''',E''ab-db status ${contextRoot}'',E''\\\\s+Running\\\\s+'',E''\\\\s+(Unknown|Stopped)\\\\s+'',E'''')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpProductType WHERE TypeName = 'ABSQL_QUERY_IT';
  if (cnt > 0) then
    execute E'UPDATE OpProductType SET ProductName=E''Ab Initio Query>It Administrator'', ProductNameString=E''${contextRoot} - ${officialProductName}'', KeyFileProductId=E'''', ProductVendor=E''Ab Initio'', ProductVariety=E''PRODUCT'', IsAddByAdmin=E''Y'', VersionTreatment=E''AUTOMATIC'', AbHomeTreatment=E''AUTOMATIC'', AbApplicationHubTreatment=E''AUTOMATIC'', RootDirectoryTreatment=E''KEY'', RootDirectoryEnvVar=E''AB_APP_HOME'', ContextRootTreatment=E''KEY'', ConfigFileTreatment=E''AUTOMATIC'', ConfigurationUserTreatment=E''REQUIRED'', PortTreatment=E''AUTOMATIC'', UrlTreatment=E''AUTOMATIC'', AbWorkDirTreatment=E''AUTOMATIC'', AbDataDirTreatment=E''AUTOMATIC'', LogFilePathTreatment=E''AUTOMATIC'', WorkDirTreatment=E''NA'', StartCommandString=E''ab-app start ${contextRoot}'', StopCommandString=E''ab-app stop ${contextRoot}'', RestartCommandString=E'''', StatusCommandString=E''ab-app status ${contextRoot}'', GoodStatusRegex=E''is running'', BadStatusRegex=E''is stopped'', AbAppIdentifier=E''AbSqlAdmin'' WHERE TypeName = ''ABSQL_QUERY_IT''';
  else
    execute E'INSERT INTO OpProductType (ProductTypeId, TypeName,ProductName,ProductNameString,KeyFileProductId,ProductVendor,ProductVariety,IsAddByAdmin,VersionTreatment,AbHomeTreatment,AbApplicationHubTreatment,RootDirectoryTreatment,RootDirectoryEnvVar,ContextRootTreatment,ConfigFileTreatment,ConfigurationUserTreatment,PortTreatment,UrlTreatment,AbWorkDirTreatment,AbDataDirTreatment,LogFilePathTreatment,WorkDirTreatment,StartCommandString,StopCommandString,RestartCommandString,StatusCommandString,GoodStatusRegex,BadStatusRegex,AbAppIdentifier) VALUES (nextval(''hibernate_sequence''),  E''ABSQL_QUERY_IT'',E''Ab Initio Query>It Administrator'',E''${contextRoot} - ${officialProductName}'',E'''',E''Ab Initio'',E''PRODUCT'',E''Y'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''KEY'',E''AB_APP_HOME'',E''KEY'',E''AUTOMATIC'',E''REQUIRED'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''NA'',E''ab-app start ${contextRoot}'',E''ab-app stop ${contextRoot}'',E'''',E''ab-app status ${contextRoot}'',E''is running'',E''is stopped'',E''AbSqlAdmin'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpProductType WHERE TypeName = 'ACE';
  if (cnt > 0) then
    execute E'UPDATE OpProductType SET ProductName=E''Ab Initio Express>It'', ProductNameString=E''${contextRoot} - ${officialProductName}'', KeyFileProductId=E'''', ProductVendor=E''Ab Initio'', ProductVariety=E''PRODUCT'', IsAddByAdmin=E''Y'', VersionTreatment=E''AUTOMATIC'', AbHomeTreatment=E''AUTOMATIC'', AbApplicationHubTreatment=E''AUTOMATIC'', RootDirectoryTreatment=E''KEY'', RootDirectoryEnvVar=E''AB_APP_HOME'', ContextRootTreatment=E''KEY'', ConfigFileTreatment=E''AUTOMATIC'', ConfigurationUserTreatment=E''NA'', PortTreatment=E''AUTOMATIC'', UrlTreatment=E''AUTOMATIC'', AbWorkDirTreatment=E''AUTOMATIC'', AbDataDirTreatment=E''AUTOMATIC'', LogFilePathTreatment=E''AUTOMATIC'', WorkDirTreatment=E''NA'', StartCommandString=E''ab-app start ${contextRoot}'', StopCommandString=E''ab-app stop ${contextRoot}'', RestartCommandString=E'''', StatusCommandString=E''ab-app status ${contextRoot}'', GoodStatusRegex=E''is running'', BadStatusRegex=E''is stopped'', AbAppIdentifier=E''appconf'' WHERE TypeName = ''ACE''';
  else
    execute E'INSERT INTO OpProductType (ProductTypeId, TypeName,ProductName,ProductNameString,KeyFileProductId,ProductVendor,ProductVariety,IsAddByAdmin,VersionTreatment,AbHomeTreatment,AbApplicationHubTreatment,RootDirectoryTreatment,RootDirectoryEnvVar,ContextRootTreatment,ConfigFileTreatment,ConfigurationUserTreatment,PortTreatment,UrlTreatment,AbWorkDirTreatment,AbDataDirTreatment,LogFilePathTreatment,WorkDirTreatment,StartCommandString,StopCommandString,RestartCommandString,StatusCommandString,GoodStatusRegex,BadStatusRegex,AbAppIdentifier) VALUES (nextval(''hibernate_sequence''),  E''ACE'',E''Ab Initio Express>It'',E''${contextRoot} - ${officialProductName}'',E'''',E''Ab Initio'',E''PRODUCT'',E''Y'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''KEY'',E''AB_APP_HOME'',E''KEY'',E''AUTOMATIC'',E''NA'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''NA'',E''ab-app start ${contextRoot}'',E''ab-app stop ${contextRoot}'',E'''',E''ab-app status ${contextRoot}'',E''is running'',E''is stopped'',E''appconf'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpProductType WHERE TypeName = 'AIW';
  if (cnt > 0) then
    execute E'UPDATE OpProductType SET ProductName=E''Technical Repository Web Interface'', ProductNameString=E''${contextRoot} - ${officialProductName}'', KeyFileProductId=E''p0203'', ProductVendor=E''Ab Initio'', ProductVariety=E''PRODUCT'', IsAddByAdmin=E''Y'', VersionTreatment=E''AUTOMATIC'', AbHomeTreatment=E''AUTOMATIC'', AbApplicationHubTreatment=E''AUTOMATIC'', RootDirectoryTreatment=E''KEY'', RootDirectoryEnvVar=E''AB_APP_HOME'', ContextRootTreatment=E''KEY'', ConfigFileTreatment=E''AUTOMATIC'', ConfigurationUserTreatment=E''REQUIRED'', PortTreatment=E''AUTOMATIC'', UrlTreatment=E''AUTOMATIC'', AbWorkDirTreatment=E''AUTOMATIC'', AbDataDirTreatment=E''AUTOMATIC'', LogFilePathTreatment=E''AUTOMATIC'', WorkDirTreatment=E''NA'', StartCommandString=E''ab-app start ${contextRoot}'', StopCommandString=E''ab-app stop ${contextRoot}'', RestartCommandString=E'''', StatusCommandString=E''ab-app status ${contextRoot}'', GoodStatusRegex=E''is running'', BadStatusRegex=E''is stopped'', AbAppIdentifier=E''aiw'' WHERE TypeName = ''AIW''';
  else
    execute E'INSERT INTO OpProductType (ProductTypeId, TypeName,ProductName,ProductNameString,KeyFileProductId,ProductVendor,ProductVariety,IsAddByAdmin,VersionTreatment,AbHomeTreatment,AbApplicationHubTreatment,RootDirectoryTreatment,RootDirectoryEnvVar,ContextRootTreatment,ConfigFileTreatment,ConfigurationUserTreatment,PortTreatment,UrlTreatment,AbWorkDirTreatment,AbDataDirTreatment,LogFilePathTreatment,WorkDirTreatment,StartCommandString,StopCommandString,RestartCommandString,StatusCommandString,GoodStatusRegex,BadStatusRegex,AbAppIdentifier) VALUES (nextval(''hibernate_sequence''),  E''AIW'',E''Technical Repository Web Interface'',E''${contextRoot} - ${officialProductName}'',E''p0203'',E''Ab Initio'',E''PRODUCT'',E''Y'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''KEY'',E''AB_APP_HOME'',E''KEY'',E''AUTOMATIC'',E''REQUIRED'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''NA'',E''ab-app start ${contextRoot}'',E''ab-app stop ${contextRoot}'',E'''',E''ab-app status ${contextRoot}'',E''is running'',E''is stopped'',E''aiw'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpProductType WHERE TypeName = 'APP_HUB';
  if (cnt > 0) then
    execute E'UPDATE OpProductType SET ProductName=E''Application Hub'', ProductNameString=E''${officialProductName} ($(version))'', KeyFileProductId=E'''', ProductVendor=E''Ab Initio'', ProductVariety=E''PRODUCT'', IsAddByAdmin=E''Y'', VersionTreatment=E''AUTOMATIC'', AbHomeTreatment=E''AUTOMATIC'', AbApplicationHubTreatment=E''KEY'', RootDirectoryTreatment=E''NA'', RootDirectoryEnvVar=E'''', ContextRootTreatment=E''NA'', ConfigFileTreatment=E''AUTOMATIC'', ConfigurationUserTreatment=E''REQUIRED'', PortTreatment=E''NA'', UrlTreatment=E''NA'', AbWorkDirTreatment=E''AUTOMATIC'', AbDataDirTreatment=E''AUTOMATIC'', LogFilePathTreatment=E''NA'', WorkDirTreatment=E''NA'', StartCommandString=E'''', StopCommandString=E'''', RestartCommandString=E'''', StatusCommandString=E'''', GoodStatusRegex=E'''', BadStatusRegex=E'''', AbAppIdentifier=E'''' WHERE TypeName = ''APP_HUB''';
  else
    execute E'INSERT INTO OpProductType (ProductTypeId, TypeName,ProductName,ProductNameString,KeyFileProductId,ProductVendor,ProductVariety,IsAddByAdmin,VersionTreatment,AbHomeTreatment,AbApplicationHubTreatment,RootDirectoryTreatment,RootDirectoryEnvVar,ContextRootTreatment,ConfigFileTreatment,ConfigurationUserTreatment,PortTreatment,UrlTreatment,AbWorkDirTreatment,AbDataDirTreatment,LogFilePathTreatment,WorkDirTreatment,StartCommandString,StopCommandString,RestartCommandString,StatusCommandString,GoodStatusRegex,BadStatusRegex,AbAppIdentifier) VALUES (nextval(''hibernate_sequence''),  E''APP_HUB'',E''Application Hub'',E''${officialProductName} ($(version))'',E'''',E''Ab Initio'',E''PRODUCT'',E''Y'',E''AUTOMATIC'',E''AUTOMATIC'',E''KEY'',E''NA'',E'''',E''NA'',E''AUTOMATIC'',E''REQUIRED'',E''NA'',E''NA'',E''AUTOMATIC'',E''AUTOMATIC'',E''NA'',E''NA'',E'''',E'''',E'''',E'''',E'''',E'''',E'''')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpProductType WHERE TypeName = 'AUTHORIZATION_GATEWAY';
  if (cnt > 0) then
    execute E'UPDATE OpProductType SET ProductName=E''Authorization Gateway'', ProductNameString=E''${contextRoot} - ${officialProductName}'', KeyFileProductId=E'''', ProductVendor=E''Ab Initio'', ProductVariety=E''PRODUCT'', IsAddByAdmin=E''Y'', VersionTreatment=E''AUTOMATIC'', AbHomeTreatment=E''AUTOMATIC'', AbApplicationHubTreatment=E''AUTOMATIC'', RootDirectoryTreatment=E''KEY'', RootDirectoryEnvVar=E''AB_APP_HOME'', ContextRootTreatment=E''KEY'', ConfigFileTreatment=E''AUTOMATIC'', ConfigurationUserTreatment=E''REQUIRED'', PortTreatment=E''AUTOMATIC'', UrlTreatment=E''AUTOMATIC'', AbWorkDirTreatment=E''AUTOMATIC'', AbDataDirTreatment=E''AUTOMATIC'', LogFilePathTreatment=E''AUTOMATIC'', WorkDirTreatment=E''NA'', StartCommandString=E''ab-app start ${contextRoot}'', StopCommandString=E''ab-app stop ${contextRoot}'', RestartCommandString=E'''', StatusCommandString=E''ab-app status ${contextRoot}'', GoodStatusRegex=E''is running'', BadStatusRegex=E''is stopped'', AbAppIdentifier=E''ag|auth|gate'' WHERE TypeName = ''AUTHORIZATION_GATEWAY''';
  else
    execute E'INSERT INTO OpProductType (ProductTypeId, TypeName,ProductName,ProductNameString,KeyFileProductId,ProductVendor,ProductVariety,IsAddByAdmin,VersionTreatment,AbHomeTreatment,AbApplicationHubTreatment,RootDirectoryTreatment,RootDirectoryEnvVar,ContextRootTreatment,ConfigFileTreatment,ConfigurationUserTreatment,PortTreatment,UrlTreatment,AbWorkDirTreatment,AbDataDirTreatment,LogFilePathTreatment,WorkDirTreatment,StartCommandString,StopCommandString,RestartCommandString,StatusCommandString,GoodStatusRegex,BadStatusRegex,AbAppIdentifier) VALUES (nextval(''hibernate_sequence''),  E''AUTHORIZATION_GATEWAY'',E''Authorization Gateway'',E''${contextRoot} - ${officialProductName}'',E'''',E''Ab Initio'',E''PRODUCT'',E''Y'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''KEY'',E''AB_APP_HOME'',E''KEY'',E''AUTOMATIC'',E''REQUIRED'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''NA'',E''ab-app start ${contextRoot}'',E''ab-app stop ${contextRoot}'',E'''',E''ab-app status ${contextRoot}'',E''is running'',E''is stopped'',E''ag|auth|gate'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpProductType WHERE TypeName = 'BRIDGE';
  if (cnt > 0) then
    execute E'UPDATE OpProductType SET ProductName=E''Ab Initio Bridge (pre-3.2.5)'', ProductNameString=E''Ab Initio Bridge (${port})'', KeyFileProductId=E'''', ProductVendor=E''Ab Initio'', ProductVariety=E''SERVICE'', IsAddByAdmin=E''Y'', VersionTreatment=E''AUTOMATIC'', AbHomeTreatment=E''AUTOMATIC'', AbApplicationHubTreatment=E''AUTOMATIC'', RootDirectoryTreatment=E''NA'', RootDirectoryEnvVar=E'''', ContextRootTreatment=E''NA'', ConfigFileTreatment=E''KEY'', ConfigurationUserTreatment=E''REQUIRED'', PortTreatment=E''AUTOMATIC'', UrlTreatment=E''AUTOMATIC'', AbWorkDirTreatment=E''AUTOMATIC'', AbDataDirTreatment=E''AUTOMATIC'', LogFilePathTreatment=E''AUTOMATIC'', WorkDirTreatment=E''NA'', StartCommandString=E''ab-bridge start -config ${configFile}'', StopCommandString=E''ab-bridge stop -config ${configFile}'', RestartCommandString=E''ab-bridge restart -config ${configFile}'', StatusCommandString=E''ab-bridge status -config ${configFile}'', GoodStatusRegex=E''is running'', BadStatusRegex=E''is not running'', AbAppIdentifier=E'''' WHERE TypeName = ''BRIDGE''';
  else
    execute E'INSERT INTO OpProductType (ProductTypeId, TypeName,ProductName,ProductNameString,KeyFileProductId,ProductVendor,ProductVariety,IsAddByAdmin,VersionTreatment,AbHomeTreatment,AbApplicationHubTreatment,RootDirectoryTreatment,RootDirectoryEnvVar,ContextRootTreatment,ConfigFileTreatment,ConfigurationUserTreatment,PortTreatment,UrlTreatment,AbWorkDirTreatment,AbDataDirTreatment,LogFilePathTreatment,WorkDirTreatment,StartCommandString,StopCommandString,RestartCommandString,StatusCommandString,GoodStatusRegex,BadStatusRegex,AbAppIdentifier) VALUES (nextval(''hibernate_sequence''),  E''BRIDGE'',E''Ab Initio Bridge (pre-3.2.5)'',E''Ab Initio Bridge (${port})'',E'''',E''Ab Initio'',E''SERVICE'',E''Y'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''NA'',E'''',E''NA'',E''KEY'',E''REQUIRED'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''NA'',E''ab-bridge start -config ${configFile}'',E''ab-bridge stop -config ${configFile}'',E''ab-bridge restart -config ${configFile}'',E''ab-bridge status -config ${configFile}'',E''is running'',E''is not running'',E'''')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpProductType WHERE TypeName = 'BRIDGE_325';
  if (cnt > 0) then
    execute E'UPDATE OpProductType SET ProductName=E''Ab Initio Bridge'', ProductNameString=E''${officialProductName} (${port})'', KeyFileProductId=E'''', ProductVendor=E''Ab Initio'', ProductVariety=E''SERVICE'', IsAddByAdmin=E''Y'', VersionTreatment=E''AUTOMATIC'', AbHomeTreatment=E''AUTOMATIC'', AbApplicationHubTreatment=E''AUTOMATIC'', RootDirectoryTreatment=E''KEY'', RootDirectoryEnvVar=E''AB_BRIDGE_CONFIGURATION_DIR'', ContextRootTreatment=E''KEY'', ConfigFileTreatment=E''AUTOMATIC'', ConfigurationUserTreatment=E''REQUIRED'', PortTreatment=E''AUTOMATIC'', UrlTreatment=E''AUTOMATIC'', AbWorkDirTreatment=E''AUTOMATIC'', AbDataDirTreatment=E''AUTOMATIC'', LogFilePathTreatment=E''AUTOMATIC'', WorkDirTreatment=E''NA'', StartCommandString=E''ab-bridge start -name ${contextRoot}'', StopCommandString=E''ab-bridge stop -name ${contextRoot}'', RestartCommandString=E''ab-bridge restart -name ${contextRoot}'', StatusCommandString=E''ab-bridge status -name ${contextRoot}'', GoodStatusRegex=E''is running'', BadStatusRegex=E''is not running'', AbAppIdentifier=E'''' WHERE TypeName = ''BRIDGE_325''';
  else
    execute E'INSERT INTO OpProductType (ProductTypeId, TypeName,ProductName,ProductNameString,KeyFileProductId,ProductVendor,ProductVariety,IsAddByAdmin,VersionTreatment,AbHomeTreatment,AbApplicationHubTreatment,RootDirectoryTreatment,RootDirectoryEnvVar,ContextRootTreatment,ConfigFileTreatment,ConfigurationUserTreatment,PortTreatment,UrlTreatment,AbWorkDirTreatment,AbDataDirTreatment,LogFilePathTreatment,WorkDirTreatment,StartCommandString,StopCommandString,RestartCommandString,StatusCommandString,GoodStatusRegex,BadStatusRegex,AbAppIdentifier) VALUES (nextval(''hibernate_sequence''),  E''BRIDGE_325'',E''Ab Initio Bridge'',E''${officialProductName} (${port})'',E'''',E''Ab Initio'',E''SERVICE'',E''Y'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''KEY'',E''AB_BRIDGE_CONFIGURATION_DIR'',E''KEY'',E''AUTOMATIC'',E''REQUIRED'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''NA'',E''ab-bridge start -name ${contextRoot}'',E''ab-bridge stop -name ${contextRoot}'',E''ab-bridge restart -name ${contextRoot}'',E''ab-bridge status -name ${contextRoot}'',E''is running'',E''is not running'',E'''')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpProductType WHERE TypeName = 'CO_OPERATING_SYSTEM';
  if (cnt > 0) then
    execute E'UPDATE OpProductType SET ProductName=E''Co>Operating System'', ProductNameString=E''${contextRoot} - ${officialProductName}||${officialProductName} ($(version))'', KeyFileProductId=E''p0101'', ProductVendor=E''Ab Initio'', ProductVariety=E''PRODUCT'', IsAddByAdmin=E''Y'', VersionTreatment=E''AUTOMATIC'', AbHomeTreatment=E''KEY'', AbApplicationHubTreatment=E''AUTOMATIC'', RootDirectoryTreatment=E''NA'', RootDirectoryEnvVar=E'''', ContextRootTreatment=E''AUTOMATIC'', ConfigFileTreatment=E''AUTOMATIC'', ConfigurationUserTreatment=E''REQUIRED'', PortTreatment=E''NA'', UrlTreatment=E''NA'', AbWorkDirTreatment=E''AUTOMATIC'', AbDataDirTreatment=E''AUTOMATIC'', LogFilePathTreatment=E''NA'', WorkDirTreatment=E''NA'', StartCommandString=E'''', StopCommandString=E'''', RestartCommandString=E'''', StatusCommandString=E'''', GoodStatusRegex=E'''', BadStatusRegex=E'''', AbAppIdentifier=E'''' WHERE TypeName = ''CO_OPERATING_SYSTEM''';
  else
    execute E'INSERT INTO OpProductType (ProductTypeId, TypeName,ProductName,ProductNameString,KeyFileProductId,ProductVendor,ProductVariety,IsAddByAdmin,VersionTreatment,AbHomeTreatment,AbApplicationHubTreatment,RootDirectoryTreatment,RootDirectoryEnvVar,ContextRootTreatment,ConfigFileTreatment,ConfigurationUserTreatment,PortTreatment,UrlTreatment,AbWorkDirTreatment,AbDataDirTreatment,LogFilePathTreatment,WorkDirTreatment,StartCommandString,StopCommandString,RestartCommandString,StatusCommandString,GoodStatusRegex,BadStatusRegex,AbAppIdentifier) VALUES (nextval(''hibernate_sequence''),  E''CO_OPERATING_SYSTEM'',E''Co>Operating System'',E''${contextRoot} - ${officialProductName}||${officialProductName} ($(version))'',E''p0101'',E''Ab Initio'',E''PRODUCT'',E''Y'',E''AUTOMATIC'',E''KEY'',E''AUTOMATIC'',E''NA'',E'''',E''AUTOMATIC'',E''AUTOMATIC'',E''REQUIRED'',E''NA'',E''NA'',E''AUTOMATIC'',E''AUTOMATIC'',E''NA'',E''NA'',E'''',E'''',E'''',E'''',E'''',E'''',E'''')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpProductType WHERE TypeName = 'CONDUCT_IT';
  if (cnt > 0) then
    execute E'UPDATE OpProductType SET ProductName=E''Conduct>It'', ProductNameString=E''${officialProductName} ($(version))||${officialProductName}'', KeyFileProductId=E''p0401'', ProductVendor=E''Ab Initio'', ProductVariety=E''PRODUCT'', IsAddByAdmin=E''N'', VersionTreatment=E''AUTOMATIC'', AbHomeTreatment=E''KEY'', AbApplicationHubTreatment=E''AUTOMATIC'', RootDirectoryTreatment=E''NA'', RootDirectoryEnvVar=E'''', ContextRootTreatment=E''NA'', ConfigFileTreatment=E''NA'', ConfigurationUserTreatment=E''NA'', PortTreatment=E''NA'', UrlTreatment=E''NA'', AbWorkDirTreatment=E''AUTOMATIC'', AbDataDirTreatment=E''AUTOMATIC'', LogFilePathTreatment=E''NA'', WorkDirTreatment=E''NA'', StartCommandString=E'''', StopCommandString=E'''', RestartCommandString=E'''', StatusCommandString=E'''', GoodStatusRegex=E'''', BadStatusRegex=E'''', AbAppIdentifier=E'''' WHERE TypeName = ''CONDUCT_IT''';
  else
    execute E'INSERT INTO OpProductType (ProductTypeId, TypeName,ProductName,ProductNameString,KeyFileProductId,ProductVendor,ProductVariety,IsAddByAdmin,VersionTreatment,AbHomeTreatment,AbApplicationHubTreatment,RootDirectoryTreatment,RootDirectoryEnvVar,ContextRootTreatment,ConfigFileTreatment,ConfigurationUserTreatment,PortTreatment,UrlTreatment,AbWorkDirTreatment,AbDataDirTreatment,LogFilePathTreatment,WorkDirTreatment,StartCommandString,StopCommandString,RestartCommandString,StatusCommandString,GoodStatusRegex,BadStatusRegex,AbAppIdentifier) VALUES (nextval(''hibernate_sequence''),  E''CONDUCT_IT'',E''Conduct>It'',E''${officialProductName} ($(version))||${officialProductName}'',E''p0401'',E''Ab Initio'',E''PRODUCT'',E''N'',E''AUTOMATIC'',E''KEY'',E''AUTOMATIC'',E''NA'',E'''',E''NA'',E''NA'',E''NA'',E''NA'',E''NA'',E''AUTOMATIC'',E''AUTOMATIC'',E''NA'',E''NA'',E'''',E'''',E'''',E'''',E'''',E'''',E'''')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpProductType WHERE TypeName = 'CONTINUOUS_FLOWS';
  if (cnt > 0) then
    execute E'UPDATE OpProductType SET ProductName=E''Continuous Flows'', ProductNameString=E''${officialProductName} ($(version))||${officialProductName}'', KeyFileProductId=E''p0301'', ProductVendor=E''Ab Initio'', ProductVariety=E''PRODUCT'', IsAddByAdmin=E''N'', VersionTreatment=E''AUTOMATIC'', AbHomeTreatment=E''KEY'', AbApplicationHubTreatment=E''AUTOMATIC'', RootDirectoryTreatment=E''NA'', RootDirectoryEnvVar=E'''', ContextRootTreatment=E''NA'', ConfigFileTreatment=E''NA'', ConfigurationUserTreatment=E''NA'', PortTreatment=E''NA'', UrlTreatment=E''NA'', AbWorkDirTreatment=E''AUTOMATIC'', AbDataDirTreatment=E''AUTOMATIC'', LogFilePathTreatment=E''NA'', WorkDirTreatment=E''NA'', StartCommandString=E'''', StopCommandString=E'''', RestartCommandString=E'''', StatusCommandString=E'''', GoodStatusRegex=E'''', BadStatusRegex=E'''', AbAppIdentifier=E'''' WHERE TypeName = ''CONTINUOUS_FLOWS''';
  else
    execute E'INSERT INTO OpProductType (ProductTypeId, TypeName,ProductName,ProductNameString,KeyFileProductId,ProductVendor,ProductVariety,IsAddByAdmin,VersionTreatment,AbHomeTreatment,AbApplicationHubTreatment,RootDirectoryTreatment,RootDirectoryEnvVar,ContextRootTreatment,ConfigFileTreatment,ConfigurationUserTreatment,PortTreatment,UrlTreatment,AbWorkDirTreatment,AbDataDirTreatment,LogFilePathTreatment,WorkDirTreatment,StartCommandString,StopCommandString,RestartCommandString,StatusCommandString,GoodStatusRegex,BadStatusRegex,AbAppIdentifier) VALUES (nextval(''hibernate_sequence''),  E''CONTINUOUS_FLOWS'',E''Continuous Flows'',E''${officialProductName} ($(version))||${officialProductName}'',E''p0301'',E''Ab Initio'',E''PRODUCT'',E''N'',E''AUTOMATIC'',E''KEY'',E''AUTOMATIC'',E''NA'',E'''',E''NA'',E''NA'',E''NA'',E''NA'',E''NA'',E''AUTOMATIC'',E''AUTOMATIC'',E''NA'',E''NA'',E'''',E'''',E'''',E'''',E'''',E'''',E'''')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpProductType WHERE TypeName = 'CONTROL_CENTER';
  if (cnt > 0) then
    execute E'UPDATE OpProductType SET ProductName=E''Ab Initio Control>Center'', ProductNameString=E''${contextRoot} - ${officialProductName}'', KeyFileProductId=E'''', ProductVendor=E''Ab Initio'', ProductVariety=E''PRODUCT'', IsAddByAdmin=E''Y'', VersionTreatment=E''AUTOMATIC'', AbHomeTreatment=E''AUTOMATIC'', AbApplicationHubTreatment=E''AUTOMATIC'', RootDirectoryTreatment=E''KEY'', RootDirectoryEnvVar=E''AB_APP_HOME'', ContextRootTreatment=E''KEY'', ConfigFileTreatment=E''AUTOMATIC'', ConfigurationUserTreatment=E''REQUIRED'', PortTreatment=E''AUTOMATIC'', UrlTreatment=E''AUTOMATIC'', AbWorkDirTreatment=E''AUTOMATIC'', AbDataDirTreatment=E''AUTOMATIC'', LogFilePathTreatment=E''AUTOMATIC'', WorkDirTreatment=E''NA'', StartCommandString=E''ab-app start ${contextRoot}'', StopCommandString=E''ab-app stop ${contextRoot}'', RestartCommandString=E'''', StatusCommandString=E''ab-app status ${contextRoot}'', GoodStatusRegex=E''is running'', BadStatusRegex=E''is stopped'', AbAppIdentifier=E''control'' WHERE TypeName = ''CONTROL_CENTER''';
  else
    execute E'INSERT INTO OpProductType (ProductTypeId, TypeName,ProductName,ProductNameString,KeyFileProductId,ProductVendor,ProductVariety,IsAddByAdmin,VersionTreatment,AbHomeTreatment,AbApplicationHubTreatment,RootDirectoryTreatment,RootDirectoryEnvVar,ContextRootTreatment,ConfigFileTreatment,ConfigurationUserTreatment,PortTreatment,UrlTreatment,AbWorkDirTreatment,AbDataDirTreatment,LogFilePathTreatment,WorkDirTreatment,StartCommandString,StopCommandString,RestartCommandString,StatusCommandString,GoodStatusRegex,BadStatusRegex,AbAppIdentifier) VALUES (nextval(''hibernate_sequence''),  E''CONTROL_CENTER'',E''Ab Initio Control>Center'',E''${contextRoot} - ${officialProductName}'',E'''',E''Ab Initio'',E''PRODUCT'',E''Y'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''KEY'',E''AB_APP_HOME'',E''KEY'',E''AUTOMATIC'',E''REQUIRED'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''NA'',E''ab-app start ${contextRoot}'',E''ab-app stop ${contextRoot}'',E'''',E''ab-app status ${contextRoot}'',E''is running'',E''is stopped'',E''control'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpProductType WHERE TypeName = 'EME_TR';
  if (cnt > 0) then
    execute E'UPDATE OpProductType SET ProductName=E''EME Technical Repository Server'', ProductNameString=E''${contextRoot} - ${officialProductName}'', KeyFileProductId=E''p0205'', ProductVendor=E''Ab Initio'', ProductVariety=E''SERVICE'', IsAddByAdmin=E''Y'', VersionTreatment=E''AUTOMATIC'', AbHomeTreatment=E''AUTOMATIC'', AbApplicationHubTreatment=E''NA'', RootDirectoryTreatment=E''KEY'', RootDirectoryEnvVar=E''AB_AIR_ROOT'', ContextRootTreatment=E''AUTOMATIC'', ConfigFileTreatment=E''NA'', ConfigurationUserTreatment=E''NA'', PortTreatment=E''NA'', UrlTreatment=E''NA'', AbWorkDirTreatment=E''AUTOMATIC'', AbDataDirTreatment=E''AUTOMATIC'', LogFilePathTreatment=E''NA'', WorkDirTreatment=E''NA'', StartCommandString=E''air -root ${rootDirectory} repository start'', StopCommandString=E''air -root ${rootDirectory} repository shutdown'', RestartCommandString=E''air -root ${rootDirectory} repository restart'', StatusCommandString=E''air -root ${rootDirectory} repository show-server'', GoodStatusRegex=E''Server ID:'', BadStatusRegex=E''Command Failed:'', AbAppIdentifier=E'''' WHERE TypeName = ''EME_TR''';
  else
    execute E'INSERT INTO OpProductType (ProductTypeId, TypeName,ProductName,ProductNameString,KeyFileProductId,ProductVendor,ProductVariety,IsAddByAdmin,VersionTreatment,AbHomeTreatment,AbApplicationHubTreatment,RootDirectoryTreatment,RootDirectoryEnvVar,ContextRootTreatment,ConfigFileTreatment,ConfigurationUserTreatment,PortTreatment,UrlTreatment,AbWorkDirTreatment,AbDataDirTreatment,LogFilePathTreatment,WorkDirTreatment,StartCommandString,StopCommandString,RestartCommandString,StatusCommandString,GoodStatusRegex,BadStatusRegex,AbAppIdentifier) VALUES (nextval(''hibernate_sequence''),  E''EME_TR'',E''EME Technical Repository Server'',E''${contextRoot} - ${officialProductName}'',E''p0205'',E''Ab Initio'',E''SERVICE'',E''Y'',E''AUTOMATIC'',E''AUTOMATIC'',E''NA'',E''KEY'',E''AB_AIR_ROOT'',E''AUTOMATIC'',E''NA'',E''NA'',E''NA'',E''NA'',E''AUTOMATIC'',E''AUTOMATIC'',E''NA'',E''NA'',E''air -root ${rootDirectory} repository start'',E''air -root ${rootDirectory} repository shutdown'',E''air -root ${rootDirectory} repository restart'',E''air -root ${rootDirectory} repository show-server'',E''Server ID:'',E''Command Failed:'',E'''')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpProductType WHERE TypeName = 'HELP_SERVER';
  if (cnt > 0) then
    execute E'UPDATE OpProductType SET ProductName=E''Ab Initio Help'', ProductNameString=E'''', KeyFileProductId=E'''', ProductVendor=E''Ab Initio'', ProductVariety=E''PRODUCT'', IsAddByAdmin=E''Y'', VersionTreatment=E''AUTOMATIC'', AbHomeTreatment=E''AUTOMATIC'', AbApplicationHubTreatment=E''AUTOMATIC'', RootDirectoryTreatment=E''KEY'', RootDirectoryEnvVar=E''AB_APP_HOME'', ContextRootTreatment=E''KEY'', ConfigFileTreatment=E''AUTOMATIC'', ConfigurationUserTreatment=E''REQUIRED'', PortTreatment=E''AUTOMATIC'', UrlTreatment=E''AUTOMATIC'', AbWorkDirTreatment=E''AUTOMATIC'', AbDataDirTreatment=E''AUTOMATIC'', LogFilePathTreatment=E''AUTOMATIC'', WorkDirTreatment=E''NA'', StartCommandString=E''ab-app start ${contextRoot}'', StopCommandString=E''ab-app stop ${contextRoot}'', RestartCommandString=E'''', StatusCommandString=E''ab-app status ${contextRoot}'', GoodStatusRegex=E''is running'', BadStatusRegex=E''is stopped'', AbAppIdentifier=E''help'' WHERE TypeName = ''HELP_SERVER''';
  else
    execute E'INSERT INTO OpProductType (ProductTypeId, TypeName,ProductName,ProductNameString,KeyFileProductId,ProductVendor,ProductVariety,IsAddByAdmin,VersionTreatment,AbHomeTreatment,AbApplicationHubTreatment,RootDirectoryTreatment,RootDirectoryEnvVar,ContextRootTreatment,ConfigFileTreatment,ConfigurationUserTreatment,PortTreatment,UrlTreatment,AbWorkDirTreatment,AbDataDirTreatment,LogFilePathTreatment,WorkDirTreatment,StartCommandString,StopCommandString,RestartCommandString,StatusCommandString,GoodStatusRegex,BadStatusRegex,AbAppIdentifier) VALUES (nextval(''hibernate_sequence''),  E''HELP_SERVER'',E''Ab Initio Help'',E'''',E'''',E''Ab Initio'',E''PRODUCT'',E''Y'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''KEY'',E''AB_APP_HOME'',E''KEY'',E''AUTOMATIC'',E''REQUIRED'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''NA'',E''ab-app start ${contextRoot}'',E''ab-app stop ${contextRoot}'',E'''',E''ab-app status ${contextRoot}'',E''is running'',E''is stopped'',E''help'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpProductType WHERE TypeName = 'KEY_CLIENT_DAEMON';
  if (cnt > 0) then
    execute E'UPDATE OpProductType SET ProductName=E''Ab Initio Key Client'', ProductNameString=E''${officialProductName}'', KeyFileProductId=E'''', ProductVendor=E''Ab Initio'', ProductVariety=E''SERVICE'', IsAddByAdmin=E''Y'', VersionTreatment=E''AUTOMATIC'', AbHomeTreatment=E''AUTOMATIC'', AbApplicationHubTreatment=E''AUTOMATIC'', RootDirectoryTreatment=E''NA'', RootDirectoryEnvVar=E'''', ContextRootTreatment=E''NA'', ConfigFileTreatment=E''AUTOMATIC'', ConfigurationUserTreatment=E''REQUIRED'', PortTreatment=E''NA'', UrlTreatment=E''NA'', AbWorkDirTreatment=E''AUTOMATIC'', AbDataDirTreatment=E''AUTOMATIC'', LogFilePathTreatment=E''AUTOMATIC'', WorkDirTreatment=E''KEY'', StartCommandString=E''abkc-control start ${workDir}'', StopCommandString=E''abkc-control stop ${workDir}'', RestartCommandString=E''abkc-control restart ${workDir}'', StatusCommandString=E''abkc-control status ${workDir}'', GoodStatusRegex=E''RUNNING-.*'', BadStatusRegex=E''STOPPED'', AbAppIdentifier=E'''' WHERE TypeName = ''KEY_CLIENT_DAEMON''';
  else
    execute E'INSERT INTO OpProductType (ProductTypeId, TypeName,ProductName,ProductNameString,KeyFileProductId,ProductVendor,ProductVariety,IsAddByAdmin,VersionTreatment,AbHomeTreatment,AbApplicationHubTreatment,RootDirectoryTreatment,RootDirectoryEnvVar,ContextRootTreatment,ConfigFileTreatment,ConfigurationUserTreatment,PortTreatment,UrlTreatment,AbWorkDirTreatment,AbDataDirTreatment,LogFilePathTreatment,WorkDirTreatment,StartCommandString,StopCommandString,RestartCommandString,StatusCommandString,GoodStatusRegex,BadStatusRegex,AbAppIdentifier) VALUES (nextval(''hibernate_sequence''),  E''KEY_CLIENT_DAEMON'',E''Ab Initio Key Client'',E''${officialProductName}'',E'''',E''Ab Initio'',E''SERVICE'',E''Y'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''NA'',E'''',E''NA'',E''AUTOMATIC'',E''REQUIRED'',E''NA'',E''NA'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''KEY'',E''abkc-control start ${workDir}'',E''abkc-control stop ${workDir}'',E''abkc-control restart ${workDir}'',E''abkc-control status ${workDir}'',E''RUNNING-.*'',E''STOPPED'',E'''')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpProductType WHERE TypeName = 'KEY_SERVER';
  if (cnt > 0) then
    execute E'UPDATE OpProductType SET ProductName=E''Ab Initio Key Server'', ProductNameString=E''${officialProductName}'', KeyFileProductId=E''p3001'', ProductVendor=E''Ab Initio'', ProductVariety=E''SERVICE'', IsAddByAdmin=E''Y'', VersionTreatment=E''AUTOMATIC'', AbHomeTreatment=E''AUTOMATIC'', AbApplicationHubTreatment=E''AUTOMATIC'', RootDirectoryTreatment=E''NA'', RootDirectoryEnvVar=E'''', ContextRootTreatment=E''NA'', ConfigFileTreatment=E''KEY'', ConfigurationUserTreatment=E''REQUIRED'', PortTreatment=E''AUTOMATIC'', UrlTreatment=E''AUTOMATIC'', AbWorkDirTreatment=E''AUTOMATIC'', AbDataDirTreatment=E''AUTOMATIC'', LogFilePathTreatment=E''AUTOMATIC'', WorkDirTreatment=E''NA'', StartCommandString=E''abks-control start ${configFile} ${keyServerGroup}'', StopCommandString=E''abks-control stop ${configFile} ${keyServerGroup}'', RestartCommandString=E''abks-control restart ${configFile} ${keyServerGroup}'', StatusCommandString=E''abks-control status abks://${hostname}:${port}'', GoodStatusRegex=E''status=ks_server_online'', BadStatusRegex=E''.*'', AbAppIdentifier=E'''' WHERE TypeName = ''KEY_SERVER''';
  else
    execute E'INSERT INTO OpProductType (ProductTypeId, TypeName,ProductName,ProductNameString,KeyFileProductId,ProductVendor,ProductVariety,IsAddByAdmin,VersionTreatment,AbHomeTreatment,AbApplicationHubTreatment,RootDirectoryTreatment,RootDirectoryEnvVar,ContextRootTreatment,ConfigFileTreatment,ConfigurationUserTreatment,PortTreatment,UrlTreatment,AbWorkDirTreatment,AbDataDirTreatment,LogFilePathTreatment,WorkDirTreatment,StartCommandString,StopCommandString,RestartCommandString,StatusCommandString,GoodStatusRegex,BadStatusRegex,AbAppIdentifier) VALUES (nextval(''hibernate_sequence''),  E''KEY_SERVER'',E''Ab Initio Key Server'',E''${officialProductName}'',E''p3001'',E''Ab Initio'',E''SERVICE'',E''Y'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''NA'',E'''',E''NA'',E''KEY'',E''REQUIRED'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''NA'',E''abks-control start ${configFile} ${keyServerGroup}'',E''abks-control stop ${configFile} ${keyServerGroup}'',E''abks-control restart ${configFile} ${keyServerGroup}'',E''abks-control status abks://${hostname}:${port}'',E''status=ks_server_online'',E''.*'',E'''')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpProductType WHERE TypeName = 'METADATA_HUB';
  if (cnt > 0) then
    execute E'UPDATE OpProductType SET ProductName=E''Ab Initio Metadata Hub'', ProductNameString=E''${contextRoot} - ${officialProductName}'', KeyFileProductId=E'''', ProductVendor=E''Ab Initio'', ProductVariety=E''PRODUCT'', IsAddByAdmin=E''Y'', VersionTreatment=E''AUTOMATIC'', AbHomeTreatment=E''AUTOMATIC'', AbApplicationHubTreatment=E''AUTOMATIC'', RootDirectoryTreatment=E''KEY'', RootDirectoryEnvVar=E''AB_APP_HOME'', ContextRootTreatment=E''KEY'', ConfigFileTreatment=E''AUTOMATIC'', ConfigurationUserTreatment=E''REQUIRED'', PortTreatment=E''AUTOMATIC'', UrlTreatment=E''AUTOMATIC'', AbWorkDirTreatment=E''AUTOMATIC'', AbDataDirTreatment=E''AUTOMATIC'', LogFilePathTreatment=E''AUTOMATIC'', WorkDirTreatment=E''NA'', StartCommandString=E''ab-app start ${contextRoot}'', StopCommandString=E''ab-app stop ${contextRoot}'', RestartCommandString=E'''', StatusCommandString=E''ab-app status ${contextRoot}'', GoodStatusRegex=E''is running'', BadStatusRegex=E''is stopped'', AbAppIdentifier=E''meta|mhub'' WHERE TypeName = ''METADATA_HUB''';
  else
    execute E'INSERT INTO OpProductType (ProductTypeId, TypeName,ProductName,ProductNameString,KeyFileProductId,ProductVendor,ProductVariety,IsAddByAdmin,VersionTreatment,AbHomeTreatment,AbApplicationHubTreatment,RootDirectoryTreatment,RootDirectoryEnvVar,ContextRootTreatment,ConfigFileTreatment,ConfigurationUserTreatment,PortTreatment,UrlTreatment,AbWorkDirTreatment,AbDataDirTreatment,LogFilePathTreatment,WorkDirTreatment,StartCommandString,StopCommandString,RestartCommandString,StatusCommandString,GoodStatusRegex,BadStatusRegex,AbAppIdentifier) VALUES (nextval(''hibernate_sequence''),  E''METADATA_HUB'',E''Ab Initio Metadata Hub'',E''${contextRoot} - ${officialProductName}'',E'''',E''Ab Initio'',E''PRODUCT'',E''Y'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''KEY'',E''AB_APP_HOME'',E''KEY'',E''AUTOMATIC'',E''REQUIRED'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''NA'',E''ab-app start ${contextRoot}'',E''ab-app stop ${contextRoot}'',E'''',E''ab-app status ${contextRoot}'',E''is running'',E''is stopped'',E''meta|mhub'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpProductType WHERE TypeName = 'OP_CONSOLE';
  if (cnt > 0) then
    execute E'UPDATE OpProductType SET ProductName=E''Ab Initio Operational Console'', ProductNameString=E''${contextRoot} - ${officialProductName}'', KeyFileProductId=E'''', ProductVendor=E''Ab Initio'', ProductVariety=E''PRODUCT'', IsAddByAdmin=E''Y'', VersionTreatment=E''AUTOMATIC'', AbHomeTreatment=E''AUTOMATIC'', AbApplicationHubTreatment=E''AUTOMATIC'', RootDirectoryTreatment=E''KEY'', RootDirectoryEnvVar=E''AB_APP_HOME'', ContextRootTreatment=E''KEY'', ConfigFileTreatment=E''AUTOMATIC'', ConfigurationUserTreatment=E''REQUIRED'', PortTreatment=E''AUTOMATIC'', UrlTreatment=E''AUTOMATIC'', AbWorkDirTreatment=E''AUTOMATIC'', AbDataDirTreatment=E''AUTOMATIC'', LogFilePathTreatment=E''AUTOMATIC'', WorkDirTreatment=E''NA'', StartCommandString=E''ab-app start ${contextRoot}'', StopCommandString=E''ab-app stop ${contextRoot}'', RestartCommandString=E'''', StatusCommandString=E''ab-app status ${contextRoot}'', GoodStatusRegex=E''is running'', BadStatusRegex=E''is stopped'', AbAppIdentifier=E''oc|opconsole'' WHERE TypeName = ''OP_CONSOLE''';
  else
    execute E'INSERT INTO OpProductType (ProductTypeId, TypeName,ProductName,ProductNameString,KeyFileProductId,ProductVendor,ProductVariety,IsAddByAdmin,VersionTreatment,AbHomeTreatment,AbApplicationHubTreatment,RootDirectoryTreatment,RootDirectoryEnvVar,ContextRootTreatment,ConfigFileTreatment,ConfigurationUserTreatment,PortTreatment,UrlTreatment,AbWorkDirTreatment,AbDataDirTreatment,LogFilePathTreatment,WorkDirTreatment,StartCommandString,StopCommandString,RestartCommandString,StatusCommandString,GoodStatusRegex,BadStatusRegex,AbAppIdentifier) VALUES (nextval(''hibernate_sequence''),  E''OP_CONSOLE'',E''Ab Initio Operational Console'',E''${contextRoot} - ${officialProductName}'',E'''',E''Ab Initio'',E''PRODUCT'',E''Y'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''KEY'',E''AB_APP_HOME'',E''KEY'',E''AUTOMATIC'',E''REQUIRED'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''NA'',E''ab-app start ${contextRoot}'',E''ab-app stop ${contextRoot}'',E'''',E''ab-app status ${contextRoot}'',E''is running'',E''is stopped'',E''oc|opconsole'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpProductType WHERE TypeName = 'OTHER_PRODUCT';
  if (cnt > 0) then
    execute E'UPDATE OpProductType SET ProductName=E''Other Product'', ProductNameString=E'''', KeyFileProductId=E'''', ProductVendor=E''Other'', ProductVariety=E''PRODUCT'', IsAddByAdmin=E''Y'', VersionTreatment=E''OPTIONAL'', AbHomeTreatment=E''OPTIONAL'', AbApplicationHubTreatment=E''AUTOMATIC'', RootDirectoryTreatment=E''NA'', RootDirectoryEnvVar=E'''', ContextRootTreatment=E''NA'', ConfigFileTreatment=E''OPTIONAL'', ConfigurationUserTreatment=E''OPTIONAL'', PortTreatment=E''OPTIONAL'', UrlTreatment=E''OPTIONAL'', AbWorkDirTreatment=E''AUTOMATIC'', AbDataDirTreatment=E''AUTOMATIC'', LogFilePathTreatment=E''OPTIONAL'', WorkDirTreatment=E''OPTIONAL'', StartCommandString=E'''', StopCommandString=E'''', RestartCommandString=E'''', StatusCommandString=E'''', GoodStatusRegex=E'''', BadStatusRegex=E'''', AbAppIdentifier=E'''' WHERE TypeName = ''OTHER_PRODUCT''';
  else
    execute E'INSERT INTO OpProductType (ProductTypeId, TypeName,ProductName,ProductNameString,KeyFileProductId,ProductVendor,ProductVariety,IsAddByAdmin,VersionTreatment,AbHomeTreatment,AbApplicationHubTreatment,RootDirectoryTreatment,RootDirectoryEnvVar,ContextRootTreatment,ConfigFileTreatment,ConfigurationUserTreatment,PortTreatment,UrlTreatment,AbWorkDirTreatment,AbDataDirTreatment,LogFilePathTreatment,WorkDirTreatment,StartCommandString,StopCommandString,RestartCommandString,StatusCommandString,GoodStatusRegex,BadStatusRegex,AbAppIdentifier) VALUES (nextval(''hibernate_sequence''),  E''OTHER_PRODUCT'',E''Other Product'',E'''',E'''',E''Other'',E''PRODUCT'',E''Y'',E''OPTIONAL'',E''OPTIONAL'',E''AUTOMATIC'',E''NA'',E'''',E''NA'',E''OPTIONAL'',E''OPTIONAL'',E''OPTIONAL'',E''OPTIONAL'',E''AUTOMATIC'',E''AUTOMATIC'',E''OPTIONAL'',E''OPTIONAL'',E'''',E'''',E'''',E'''',E'''',E'''',E'''')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpProductType WHERE TypeName = 'OTHER_SERVICE';
  if (cnt > 0) then
    execute E'UPDATE OpProductType SET ProductName=E''Other Service'', ProductNameString=E'''', KeyFileProductId=E'''', ProductVendor=E''Other'', ProductVariety=E''SERVICE'', IsAddByAdmin=E''Y'', VersionTreatment=E''OPTIONAL'', AbHomeTreatment=E''OPTIONAL'', AbApplicationHubTreatment=E''AUTOMATIC'', RootDirectoryTreatment=E''NA'', RootDirectoryEnvVar=E'''', ContextRootTreatment=E''NA'', ConfigFileTreatment=E''OPTIONAL'', ConfigurationUserTreatment=E''OPTIONAL'', PortTreatment=E''OPTIONAL'', UrlTreatment=E''OPTIONAL'', AbWorkDirTreatment=E''AUTOMATIC'', AbDataDirTreatment=E''AUTOMATIC'', LogFilePathTreatment=E''OPTIONAL'', WorkDirTreatment=E''OPTIONAL'', StartCommandString=E'''', StopCommandString=E'''', RestartCommandString=E'''', StatusCommandString=E'''', GoodStatusRegex=E'''', BadStatusRegex=E'''', AbAppIdentifier=E'''' WHERE TypeName = ''OTHER_SERVICE''';
  else
    execute E'INSERT INTO OpProductType (ProductTypeId, TypeName,ProductName,ProductNameString,KeyFileProductId,ProductVendor,ProductVariety,IsAddByAdmin,VersionTreatment,AbHomeTreatment,AbApplicationHubTreatment,RootDirectoryTreatment,RootDirectoryEnvVar,ContextRootTreatment,ConfigFileTreatment,ConfigurationUserTreatment,PortTreatment,UrlTreatment,AbWorkDirTreatment,AbDataDirTreatment,LogFilePathTreatment,WorkDirTreatment,StartCommandString,StopCommandString,RestartCommandString,StatusCommandString,GoodStatusRegex,BadStatusRegex,AbAppIdentifier) VALUES (nextval(''hibernate_sequence''),  E''OTHER_SERVICE'',E''Other Service'',E'''',E'''',E''Other'',E''SERVICE'',E''Y'',E''OPTIONAL'',E''OPTIONAL'',E''AUTOMATIC'',E''NA'',E'''',E''NA'',E''OPTIONAL'',E''OPTIONAL'',E''OPTIONAL'',E''OPTIONAL'',E''AUTOMATIC'',E''AUTOMATIC'',E''OPTIONAL'',E''OPTIONAL'',E'''',E'''',E'''',E'''',E'''',E'''',E'''')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpProductType WHERE TypeName = 'REPORTER';
  if (cnt > 0) then
    execute E'UPDATE OpProductType SET ProductName=E''Reporter'', ProductNameString=E''${officialProductName} (${hostname})'', KeyFileProductId=E'''', ProductVendor=E''Ab Initio'', ProductVariety=E''SERVICE'', IsAddByAdmin=E''N'', VersionTreatment=E''AUTOMATIC'', AbHomeTreatment=E''AUTOMATIC'', AbApplicationHubTreatment=E''AUTOMATIC'', RootDirectoryTreatment=E''NA'', RootDirectoryEnvVar=E'''', ContextRootTreatment=E''NA'', ConfigFileTreatment=E''AUTOMATIC'', ConfigurationUserTreatment=E''AUTOMATIC'', PortTreatment=E''NA'', UrlTreatment=E''NA'', AbWorkDirTreatment=E''AUTOMATIC'', AbDataDirTreatment=E''AUTOMATIC'', LogFilePathTreatment=E''AUTOMATIC'', WorkDirTreatment=E''KEY'', StartCommandString=E''ab-reporter start -config ${configFile}'', StopCommandString=E''ab-reporter stop -config ${configFile}'', RestartCommandString=E''ab-reporter restart -config ${configFile}'', StatusCommandString=E''ab-reporter status -config ${configFile}'', GoodStatusRegex=E''is running'', BadStatusRegex=E'''', AbAppIdentifier=E'''' WHERE TypeName = ''REPORTER''';
  else
    execute E'INSERT INTO OpProductType (ProductTypeId, TypeName,ProductName,ProductNameString,KeyFileProductId,ProductVendor,ProductVariety,IsAddByAdmin,VersionTreatment,AbHomeTreatment,AbApplicationHubTreatment,RootDirectoryTreatment,RootDirectoryEnvVar,ContextRootTreatment,ConfigFileTreatment,ConfigurationUserTreatment,PortTreatment,UrlTreatment,AbWorkDirTreatment,AbDataDirTreatment,LogFilePathTreatment,WorkDirTreatment,StartCommandString,StopCommandString,RestartCommandString,StatusCommandString,GoodStatusRegex,BadStatusRegex,AbAppIdentifier) VALUES (nextval(''hibernate_sequence''),  E''REPORTER'',E''Reporter'',E''${officialProductName} (${hostname})'',E'''',E''Ab Initio'',E''SERVICE'',E''N'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''NA'',E'''',E''NA'',E''AUTOMATIC'',E''AUTOMATIC'',E''NA'',E''NA'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''KEY'',E''ab-reporter start -config ${configFile}'',E''ab-reporter stop -config ${configFile}'',E''ab-reporter restart -config ${configFile}'',E''ab-reporter status -config ${configFile}'',E''is running'',E'''',E'''')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpProductType WHERE TypeName = 'RESOURCE_SERVER';
  if (cnt > 0) then
    execute E'UPDATE OpProductType SET ProductName=E''Ab Initio Resource Server'', ProductNameString=E''${officialProductName}'', KeyFileProductId=E'''', ProductVendor=E''Ab Initio'', ProductVariety=E''SERVICE'', IsAddByAdmin=E''N'', VersionTreatment=E''NA'', AbHomeTreatment=E''NA'', AbApplicationHubTreatment=E''NA'', RootDirectoryTreatment=E''NA'', RootDirectoryEnvVar=E'''', ContextRootTreatment=E''NA'', ConfigFileTreatment=E''NA'', ConfigurationUserTreatment=E''NA'', PortTreatment=E''NA'', UrlTreatment=E''NA'', AbWorkDirTreatment=E''KEY'', AbDataDirTreatment=E''NA'', LogFilePathTreatment=E''AUTOMATIC'', WorkDirTreatment=E''NA'', StartCommandString=E''resource-admin queue'', StopCommandString=E''resource-admin shutdown'', RestartCommandString=E''resource-admin shutdown; resource-admin queue'', StatusCommandString=E'''', GoodStatusRegex=E'''', BadStatusRegex=E'''', AbAppIdentifier=E'''' WHERE TypeName = ''RESOURCE_SERVER''';
  else
    execute E'INSERT INTO OpProductType (ProductTypeId, TypeName,ProductName,ProductNameString,KeyFileProductId,ProductVendor,ProductVariety,IsAddByAdmin,VersionTreatment,AbHomeTreatment,AbApplicationHubTreatment,RootDirectoryTreatment,RootDirectoryEnvVar,ContextRootTreatment,ConfigFileTreatment,ConfigurationUserTreatment,PortTreatment,UrlTreatment,AbWorkDirTreatment,AbDataDirTreatment,LogFilePathTreatment,WorkDirTreatment,StartCommandString,StopCommandString,RestartCommandString,StatusCommandString,GoodStatusRegex,BadStatusRegex,AbAppIdentifier) VALUES (nextval(''hibernate_sequence''),  E''RESOURCE_SERVER'',E''Ab Initio Resource Server'',E''${officialProductName}'',E'''',E''Ab Initio'',E''SERVICE'',E''N'',E''NA'',E''NA'',E''NA'',E''NA'',E'''',E''NA'',E''NA'',E''NA'',E''NA'',E''NA'',E''KEY'',E''NA'',E''AUTOMATIC'',E''NA'',E''resource-admin queue'',E''resource-admin shutdown'',E''resource-admin shutdown; resource-admin queue'',E'''',E'''',E'''',E'''')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpProductType WHERE TypeName = 'WEB_SERVICES';
  if (cnt > 0) then
    execute E'UPDATE OpProductType SET ProductName=E''Ab Initio Web Services'', ProductNameString=E''${contextRoot} - ${officialProductName}'', KeyFileProductId=E'''', ProductVendor=E''Ab Initio'', ProductVariety=E''SERVICE'', IsAddByAdmin=E''Y'', VersionTreatment=E''AUTOMATIC'', AbHomeTreatment=E''AUTOMATIC'', AbApplicationHubTreatment=E''NA'', RootDirectoryTreatment=E''KEY'', RootDirectoryEnvVar=E''AB_APP_HOME'', ContextRootTreatment=E''KEY'', ConfigFileTreatment=E''AUTOMATIC'', ConfigurationUserTreatment=E''REQUIRED'', PortTreatment=E''AUTOMATIC'', UrlTreatment=E''AUTOMATIC'', AbWorkDirTreatment=E''AUTOMATIC'', AbDataDirTreatment=E''AUTOMATIC'', LogFilePathTreatment=E''AUTOMATIC'', WorkDirTreatment=E''NA'', StartCommandString=E''ab-app start ${contextRoot}'', StopCommandString=E''ab-app stop ${contextRoot}'', RestartCommandString=E'''', StatusCommandString=E''ab-app status ${contextRoot}'', GoodStatusRegex=E''is running'', BadStatusRegex=E''is stopped'', AbAppIdentifier=E''AIWebServices'' WHERE TypeName = ''WEB_SERVICES''';
  else
    execute E'INSERT INTO OpProductType (ProductTypeId, TypeName,ProductName,ProductNameString,KeyFileProductId,ProductVendor,ProductVariety,IsAddByAdmin,VersionTreatment,AbHomeTreatment,AbApplicationHubTreatment,RootDirectoryTreatment,RootDirectoryEnvVar,ContextRootTreatment,ConfigFileTreatment,ConfigurationUserTreatment,PortTreatment,UrlTreatment,AbWorkDirTreatment,AbDataDirTreatment,LogFilePathTreatment,WorkDirTreatment,StartCommandString,StopCommandString,RestartCommandString,StatusCommandString,GoodStatusRegex,BadStatusRegex,AbAppIdentifier) VALUES (nextval(''hibernate_sequence''),  E''WEB_SERVICES'',E''Ab Initio Web Services'',E''${contextRoot} - ${officialProductName}'',E'''',E''Ab Initio'',E''SERVICE'',E''Y'',E''AUTOMATIC'',E''AUTOMATIC'',E''NA'',E''KEY'',E''AB_APP_HOME'',E''KEY'',E''AUTOMATIC'',E''REQUIRED'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''NA'',E''ab-app start ${contextRoot}'',E''ab-app stop ${contextRoot}'',E'''',E''ab-app status ${contextRoot}'',E''is running'',E''is stopped'',E''AIWebServices'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpProductType WHERE TypeName = 'WORKLOAD_MANAGER';
  if (cnt > 0) then
    execute E'UPDATE OpProductType SET ProductName=E''Ab Initio Workload Manager'', ProductNameString=E'''', KeyFileProductId=E'''', ProductVendor=E''Ab Initio'', ProductVariety=E''SERVICE'', IsAddByAdmin=E''N'', VersionTreatment=E''AUTOMATIC'', AbHomeTreatment=E''KEY'', AbApplicationHubTreatment=E''AUTOMATIC'', RootDirectoryTreatment=E''NA'', RootDirectoryEnvVar=E'''', ContextRootTreatment=E''NA'', ConfigFileTreatment=E''OPTIONAL'', ConfigurationUserTreatment=E''OPTIONAL'', PortTreatment=E''NA'', UrlTreatment=E''NA'', AbWorkDirTreatment=E''AUTOMATIC'', AbDataDirTreatment=E''AUTOMATIC'', LogFilePathTreatment=E''AUTOMATIC'', WorkDirTreatment=E''NA'', StartCommandString=E''abwlm-control start'', StopCommandString=E''abwlm-control stop'', RestartCommandString=E''abwlm-control restart'', StatusCommandString=E''abwlm-control status'', GoodStatusRegex=E''wl_status'', BadStatusRegex=E''connection information could not be found'', AbAppIdentifier=E'''' WHERE TypeName = ''WORKLOAD_MANAGER''';
  else
    execute E'INSERT INTO OpProductType (ProductTypeId, TypeName,ProductName,ProductNameString,KeyFileProductId,ProductVendor,ProductVariety,IsAddByAdmin,VersionTreatment,AbHomeTreatment,AbApplicationHubTreatment,RootDirectoryTreatment,RootDirectoryEnvVar,ContextRootTreatment,ConfigFileTreatment,ConfigurationUserTreatment,PortTreatment,UrlTreatment,AbWorkDirTreatment,AbDataDirTreatment,LogFilePathTreatment,WorkDirTreatment,StartCommandString,StopCommandString,RestartCommandString,StatusCommandString,GoodStatusRegex,BadStatusRegex,AbAppIdentifier) VALUES (nextval(''hibernate_sequence''),  E''WORKLOAD_MANAGER'',E''Ab Initio Workload Manager'',E'''',E'''',E''Ab Initio'',E''SERVICE'',E''N'',E''AUTOMATIC'',E''KEY'',E''AUTOMATIC'',E''NA'',E'''',E''NA'',E''OPTIONAL'',E''OPTIONAL'',E''NA'',E''NA'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''NA'',E''abwlm-control start'',E''abwlm-control stop'',E''abwlm-control restart'',E''abwlm-control status'',E''wl_status'',E''connection information could not be found'',E'''')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpProductType WHERE TypeName = 'THIS_CC';
  if (cnt > 0) then
    execute E'UPDATE OpProductType SET ProductName=E''Control>Center'', ProductNameString=E''${officialProductName}'', KeyFileProductId=E'''', ProductVendor=E''Ab Initio'', ProductVariety=E''PRODUCT'', IsAddByAdmin=E''N'', VersionTreatment=E''AUTOMATIC'', AbHomeTreatment=E''NA'', AbApplicationHubTreatment=E''NA'', RootDirectoryTreatment=E''NA'', RootDirectoryEnvVar=E'''', ContextRootTreatment=E''NA'', ConfigFileTreatment=E''NA'', ConfigurationUserTreatment=E''NA'', PortTreatment=E''NA'', UrlTreatment=E''NA'', AbWorkDirTreatment=E''NA'', AbDataDirTreatment=E''NA'', LogFilePathTreatment=E''NA'', WorkDirTreatment=E''NA'', StartCommandString=E'''', StopCommandString=E'''', RestartCommandString=E'''', StatusCommandString=E'''', GoodStatusRegex=E'''', BadStatusRegex=E'''', AbAppIdentifier=E'''' WHERE TypeName = ''THIS_CC''';
  else
    execute E'INSERT INTO OpProductType (ProductTypeId, TypeName,ProductName,ProductNameString,KeyFileProductId,ProductVendor,ProductVariety,IsAddByAdmin,VersionTreatment,AbHomeTreatment,AbApplicationHubTreatment,RootDirectoryTreatment,RootDirectoryEnvVar,ContextRootTreatment,ConfigFileTreatment,ConfigurationUserTreatment,PortTreatment,UrlTreatment,AbWorkDirTreatment,AbDataDirTreatment,LogFilePathTreatment,WorkDirTreatment,StartCommandString,StopCommandString,RestartCommandString,StatusCommandString,GoodStatusRegex,BadStatusRegex,AbAppIdentifier) VALUES (nextval(''hibernate_sequence''),  E''THIS_CC'',E''Control>Center'',E''${officialProductName}'',E'''',E''Ab Initio'',E''PRODUCT'',E''N'',E''AUTOMATIC'',E''NA'',E''NA'',E''NA'',E'''',E''NA'',E''NA'',E''NA'',E''NA'',E''NA'',E''NA'',E''NA'',E''NA'',E''NA'',E'''',E'''',E'''',E'''',E'''',E'''',E'''')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpProductType WHERE TypeName = 'TRW';
  if (cnt > 0) then
    execute E'UPDATE OpProductType SET ProductName=E''EME Technical Repository Web Interface'', ProductNameString=E''${contextRoot} - ${officialProductName}'', KeyFileProductId=E''p0203'', ProductVendor=E''Ab Initio'', ProductVariety=E''PRODUCT'', IsAddByAdmin=E''Y'', VersionTreatment=E''AUTOMATIC'', AbHomeTreatment=E''AUTOMATIC'', AbApplicationHubTreatment=E''AUTOMATIC'', RootDirectoryTreatment=E''KEY'', RootDirectoryEnvVar=E''AB_APP_HOME'', ContextRootTreatment=E''KEY'', ConfigFileTreatment=E''AUTOMATIC'', ConfigurationUserTreatment=E''REQUIRED'', PortTreatment=E''AUTOMATIC'', UrlTreatment=E''AUTOMATIC'', AbWorkDirTreatment=E''AUTOMATIC'', AbDataDirTreatment=E''AUTOMATIC'', LogFilePathTreatment=E''AUTOMATIC'', WorkDirTreatment=E''NA'', StartCommandString=E''ab-app start ${contextRoot}'', StopCommandString=E''ab-app stop ${contextRoot}'', RestartCommandString=E'''', StatusCommandString=E''ab-app status ${contextRoot}'', GoodStatusRegex=E''is running'', BadStatusRegex=E''is stopped'', AbAppIdentifier=E''trw'' WHERE TypeName = ''TRW''';
  else
    execute E'INSERT INTO OpProductType (ProductTypeId, TypeName,ProductName,ProductNameString,KeyFileProductId,ProductVendor,ProductVariety,IsAddByAdmin,VersionTreatment,AbHomeTreatment,AbApplicationHubTreatment,RootDirectoryTreatment,RootDirectoryEnvVar,ContextRootTreatment,ConfigFileTreatment,ConfigurationUserTreatment,PortTreatment,UrlTreatment,AbWorkDirTreatment,AbDataDirTreatment,LogFilePathTreatment,WorkDirTreatment,StartCommandString,StopCommandString,RestartCommandString,StatusCommandString,GoodStatusRegex,BadStatusRegex,AbAppIdentifier) VALUES (nextval(''hibernate_sequence''),  E''TRW'',E''EME Technical Repository Web Interface'',E''${contextRoot} - ${officialProductName}'',E''p0203'',E''Ab Initio'',E''PRODUCT'',E''Y'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''KEY'',E''AB_APP_HOME'',E''KEY'',E''AUTOMATIC'',E''REQUIRED'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''AUTOMATIC'',E''NA'',E''ab-app start ${contextRoot}'',E''ab-app stop ${contextRoot}'',E'''',E''ab-app status ${contextRoot}'',E''is running'',E''is stopped'',E''trw'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


-- ---------------------------------------------------
create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'AbDataDirs';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.80'', EndVersion=E''1.130'', Description=E''Monitored AB_DATA_DIR paths'', ItemType=E''STRING'', Value=E''/~ab_data_dir'', ReporterParameterGroupType=E''OBSOLETE'', ReporterConfigValueType=E''ARRAY'' WHERE Name = ''AbDataDirs''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''AbDataDirs'',E''1.80'',E''1.130'',E''Monitored AB_DATA_DIR paths'',E''STRING'',E''/~ab_data_dir'',E''OBSOLETE'',E''ARRAY'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'AbOpsMonitorDirectorys';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.130'', EndVersion=NULL, Description=E''Monitored AB_OPS_MONITOR_DIRECTORY paths'', ItemType=E''STRING'', Value=E''/~$AB_OPS_MONITOR_DIRECTORY'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''ARRAY'' WHERE Name = ''AbOpsMonitorDirectorys''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''AbOpsMonitorDirectorys'',E''1.130'',NULL,E''Monitored AB_OPS_MONITOR_DIRECTORY paths'',E''STRING'',E''/~$AB_OPS_MONITOR_DIRECTORY'',E''NORMAL'',E''ARRAY'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'ApplicationsPollInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=E''1.40'', Description=E''Polling interval (seconds) for checking for OpApplication updates (Applicable only to Operational Console 3.0.x and Operational Console 3.1.1.x)'', ItemType=E''DOUBLE'', Value=E''3600'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''ApplicationsPollInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''ApplicationsPollInterval'',E''1.20'',E''1.40'',E''Polling interval (seconds) for checking for OpApplication updates (Applicable only to Operational Console 3.0.x and Operational Console 3.1.1.x)'',E''DOUBLE'',E''3600'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'CCInstallableExtractCommand';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.90'', EndVersion=NULL, Description=E''Command to be used to fetch and unpack the "Control>Center installable files" tar file'', ItemType=E''STRING'', Value=E''cc-installable-extract'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''CCInstallableExtractCommand''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''CCInstallableExtractCommand'',E''1.90'',NULL,E''Command to be used to fetch and unpack the "Control>Center installable files" tar file'',E''STRING'',E''cc-installable-extract'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'CacheVersionsPollInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.40'', EndVersion=NULL, Description=E''Polling interval (seconds) for checking Control>Center data cache updates (Operational Console 3.1.2 or later)'', ItemType=E''DOUBLE'', Value=E''5'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''CacheVersionsPollInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''CacheVersionsPollInterval'',E''1.40'',NULL,E''Polling interval (seconds) for checking Control>Center data cache updates (Operational Console 3.1.2 or later)'',E''DOUBLE'',E''5'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'CalendarsPollInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=E''1.40'', Description=E''Polling interval (seconds) for checking for calendar updates (Applicable only to Operational Console 3.0.x and Operational Console 3.1.1.x)'', ItemType=E''DOUBLE'', Value=E''120'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''CalendarsPollInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''CalendarsPollInterval'',E''1.20'',E''1.40'',E''Polling interval (seconds) for checking for calendar updates (Applicable only to Operational Console 3.0.x and Operational Console 3.1.1.x)'',E''DOUBLE'',E''120'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'ConfigValuesPollInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=E''1.40'', Description=E''Polling interval (seconds) for checking for OpConfigValue updates (Applicable only to Operational Console 3.0.x and Operational Console 3.1.1.x)'', ItemType=E''DOUBLE'', Value=E''3600'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''ConfigValuesPollInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''ConfigValuesPollInterval'',E''1.20'',E''1.40'',E''Polling interval (seconds) for checking for OpConfigValue updates (Applicable only to Operational Console 3.0.x and Operational Console 3.1.1.x)'',E''DOUBLE'',E''3600'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'CpuMonitorMaxBufferedSnapshots';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.170'', EndVersion=NULL, Description=E''The maximum number of run snapshots the cpu-monitor will retain in memory'', ItemType=E''LONG'', Value=E''1000'', ReporterParameterGroupType=E''CPU_MONITOR'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''CpuMonitorMaxBufferedSnapshots''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''CpuMonitorMaxBufferedSnapshots'',E''1.170'',NULL,E''The maximum number of run snapshots the cpu-monitor will retain in memory'',E''LONG'',E''1000'',E''CPU_MONITOR'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'CpuMonitorMaxOutstandingJobs';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.170'', EndVersion=NULL, Description=E''Maximum number of jobs that the cpu-monitor processes simultaneously'', ItemType=E''LONG'', Value=E''200'', ReporterParameterGroupType=E''CPU_MONITOR'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''CpuMonitorMaxOutstandingJobs''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''CpuMonitorMaxOutstandingJobs'',E''1.170'',NULL,E''Maximum number of jobs that the cpu-monitor processes simultaneously'',E''LONG'',E''200'',E''CPU_MONITOR'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'CpuMonitorSnapshotShelfLife';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.170'', EndVersion=NULL, Description=E''The maximum number of seconds the cpu-monitor will retain a run snapshot in memory before flushing it to disk'', ItemType=E''DOUBLE'', Value=E''1800.000'', ReporterParameterGroupType=E''CPU_MONITOR'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''CpuMonitorSnapshotShelfLife''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''CpuMonitorSnapshotShelfLife'',E''1.170'',NULL,E''The maximum number of seconds the cpu-monitor will retain a run snapshot in memory before flushing it to disk'',E''DOUBLE'',E''1800.000'',E''CPU_MONITOR'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'CpuMonitoringInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.170'', EndVersion=NULL, Description=E''The interval in seconds upon which the cpu-monitor checks deadlines'', ItemType=E''DOUBLE'', Value=E''3600.000'', ReporterParameterGroupType=E''CPU_MONITOR'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''CpuMonitoringInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''CpuMonitoringInterval'',E''1.170'',NULL,E''The interval in seconds upon which the cpu-monitor checks deadlines'',E''DOUBLE'',E''3600.000'',E''CPU_MONITOR'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'DataLoggingMaxSize';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.70'', EndVersion=NULL, Description=E''Maximum size of data logged in certain reporter.log messages.  See ReadLoggingPrefixes.'', ItemType=E''LONG'', Value=E''256'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''DataLoggingMaxSize''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''DataLoggingMaxSize'',E''1.70'',NULL,E''Maximum size of data logged in certain reporter.log messages.  See ReadLoggingPrefixes.'',E''LONG'',E''256'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'EnvironmentScrub';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=NULL, Description=E''Unsets these variables in the constraint-server and ops-monitor environment'', ItemType=E''STRING'', Value=E''PROJECT_DIR'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''EnvironmentScrub''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''EnvironmentScrub'',E''1.20'',NULL,E''Unsets these variables in the constraint-server and ops-monitor environment'',E''STRING'',E''PROJECT_DIR'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'ExecutablesPollInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=E''1.40'', Description=E''Polling interval (seconds) for checking for executable metric definition updates (Applicable only to Operational Console 3.0.x and Operational Console 3.1.1.x)'', ItemType=E''DOUBLE'', Value=E''30'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''ExecutablesPollInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''ExecutablesPollInterval'',E''1.20'',E''1.40'',E''Polling interval (seconds) for checking for executable metric definition updates (Applicable only to Operational Console 3.0.x and Operational Console 3.1.1.x)'',E''DOUBLE'',E''30'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'FileAbandonGraceTime';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.70'', EndVersion=NULL, Description=E''Seconds after reporter seeing file writer unlock before file is considered abandoned'', ItemType=E''DOUBLE'', Value=E''60'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''FileAbandonGraceTime''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''FileAbandonGraceTime'',E''1.70'',NULL,E''Seconds after reporter seeing file writer unlock before file is considered abandoned'',E''DOUBLE'',E''60'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'FileLandingRetryInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=NULL, Description=E''Interval (seconds) before retrying failing file write'', ItemType=E''DOUBLE'', Value=E''12'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''FileLandingRetryInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''FileLandingRetryInterval'',E''1.20'',NULL,E''Interval (seconds) before retrying failing file write'',E''DOUBLE'',E''12'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'FileSystemMetricUnit';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.80'', EndVersion=NULL, Description=E''Units in which file-system storage sizes are reported. Choices: MBytes or GBytes.'', ItemType=E''STRING'', Value=E''MBytes'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''FileSystemMetricUnit''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''FileSystemMetricUnit'',E''1.80'',NULL,E''Units in which file-system storage sizes are reported. Choices: MBytes or GBytes.'',E''STRING'',E''MBytes'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'FileSystemsPollInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.80'', EndVersion=E''1.40'', Description=E''Polling interval (seconds) for checking for file-system updates (for collecting metric values)'', ItemType=E''DOUBLE'', Value=E''60'', ReporterParameterGroupType=E''OBSOLETE'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''FileSystemsPollInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''FileSystemsPollInterval'',E''1.80'',E''1.40'',E''Polling interval (seconds) for checking for file-system updates (for collecting metric values)'',E''DOUBLE'',E''60'',E''OBSOLETE'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'FullGraphMetrics';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.180'', EndVersion=NULL, Description=E''Collect all graph metrics or just metrics for CPU usage.'', ItemType=E''BOOLEAN'', Value=E''Y'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''FullGraphMetrics''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''FullGraphMetrics'',E''1.180'',NULL,E''Collect all graph metrics or just metrics for CPU usage.'',E''BOOLEAN'',E''Y'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'FunctionalUser';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.40'', EndVersion=NULL, Description=E''Operating system account for reporter, graph monitors, and schedulers.'', ItemType=E''STRING'', Value=E''<emptyString/>'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''FunctionalUser''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''FunctionalUser'',E''1.40'',NULL,E''Operating system account for reporter, graph monitors, and schedulers.'',E''STRING'',E''<emptyString/>'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'GraphMonitorProcessLimit';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=NULL, Description=E''Maximum number of graph tracking monitor processes allowed to run at once'', ItemType=E''LONG'', Value=E''100'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''GraphMonitorProcessLimit''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''GraphMonitorProcessLimit'',E''1.20'',NULL,E''Maximum number of graph tracking monitor processes allowed to run at once'',E''LONG'',E''100'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'HostMetricValueElementsLimit';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.80'', EndVersion=NULL, Description=E''Maximum number of host metric values in single SOAP request'', ItemType=E''LONG'', Value=E''200'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''HostMetricValueElementsLimit''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''HostMetricValueElementsLimit'',E''1.80'',NULL,E''Maximum number of host metric values in single SOAP request'',E''LONG'',E''200'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'HostMetricValuesRefreshInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.80'', EndVersion=NULL, Description=E''Interval (seconds) between checking for new host metric values data'', ItemType=E''DOUBLE'', Value=E''5'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''HostMetricValuesRefreshInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''HostMetricValuesRefreshInterval'',E''1.80'',NULL,E''Interval (seconds) between checking for new host metric values data'',E''DOUBLE'',E''5'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'HostMetricValuesSubmitInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.80'', EndVersion=NULL, Description=E''Seconds between host metric value SOAP request submissions'', ItemType=E''DOUBLE'', Value=E''0.5'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''HostMetricValuesSubmitInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''HostMetricValuesSubmitInterval'',E''1.80'',NULL,E''Seconds between host metric value SOAP request submissions'',E''DOUBLE'',E''0.5'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'HostMonitorRunInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.80'', EndVersion=NULL, Description=E''Interval (seconds) between runs of ops-host-monitor to collect host metric values'', ItemType=E''DOUBLE'', Value=E''60'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''HostMonitorRunInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''HostMonitorRunInterval'',E''1.80'',NULL,E''Interval (seconds) between runs of ops-host-monitor to collect host metric values'',E''DOUBLE'',E''60'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'IsEphemeralHost';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.180'', EndVersion=NULL, Description=E''This reporter is configured for a short-lived host, typically a container.'', ItemType=E''BOOLEAN'', Value=E''N'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''IsEphemeralHost''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''IsEphemeralHost'',E''1.180'',NULL,E''This reporter is configured for a short-lived host, typically a container.'',E''BOOLEAN'',E''N'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'JobCompletionsPollInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=E''1.40'', Description=E''Polling interval (seconds) for checking for inter-host job completion updates (Applicable only to Operational Console 3.0.x and Operational Console 3.1.1.x)'', ItemType=E''DOUBLE'', Value=E''60'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''JobCompletionsPollInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''JobCompletionsPollInterval'',E''1.20'',E''1.40'',E''Polling interval (seconds) for checking for inter-host job completion updates (Applicable only to Operational Console 3.0.x and Operational Console 3.1.1.x)'',E''DOUBLE'',E''60'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'JobDirectoryCreateAhead';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.130'', EndVersion=NULL, Description=E''Number of days ahead to create yyyy-mm-dd directories under ops/log, ops/error, ops/tracking'', ItemType=E''LONG'', Value=E''7'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''JobDirectoryCreateAhead''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''JobDirectoryCreateAhead'',E''1.130'',NULL,E''Number of days ahead to create yyyy-mm-dd directories under ops/log, ops/error, ops/tracking'',E''LONG'',E''7'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'KeyInfoElementsLimit';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.120'', EndVersion=NULL, Description=E''Maximum number of keys in a single SOAP request'', ItemType=E''LONG'', Value=E''5'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''KeyInfoElementsLimit''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''KeyInfoElementsLimit'',E''1.120'',NULL,E''Maximum number of keys in a single SOAP request'',E''LONG'',E''5'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'KeyInfoRefreshInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.120'', EndVersion=NULL, Description=E''Interval (seconds) between checking key cache directory for new key data'', ItemType=E''DOUBLE'', Value=E''60'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''KeyInfoRefreshInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''KeyInfoRefreshInterval'',E''1.120'',NULL,E''Interval (seconds) between checking key cache directory for new key data'',E''DOUBLE'',E''60'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'KeyServerUrls';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.170'', EndVersion=NULL, Description=E''Key servers for logging CPU time-oriented job monitoring'', ItemType=E''STRING'', Value=E''<emptyString/>'', ReporterParameterGroupType=E''CPU_MONITOR'', ReporterConfigValueType=E''ARRAY'' WHERE Name = ''KeyServerUrls''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''KeyServerUrls'',E''1.170'',NULL,E''Key servers for logging CPU time-oriented job monitoring'',E''STRING'',E''<emptyString/>'',E''CPU_MONITOR'',E''ARRAY'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'LogFile';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=NULL, Description=E''Path of log file'', ItemType=E''STRING'', Value=E''/~$AB_OPS_MONITOR_DIRECTORY/log/reporter.log'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''LogFile''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''LogFile'',E''1.20'',NULL,E''Path of log file'',E''STRING'',E''/~$AB_OPS_MONITOR_DIRECTORY/log/reporter.log'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'LogFileSizeLimit';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=NULL, Description=E''Threshold (MB) for log file rollover'', ItemType=E''LONG'', Value=E''16'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''LogFileSizeLimit''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''LogFileSizeLimit'',E''1.20'',NULL,E''Threshold (MB) for log file rollover'',E''LONG'',E''16'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'MaxWebServiceRetryInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.150'', EndVersion=NULL, Description=E''Limit on interval (seconds) between web service retry attempts'', ItemType=E''DOUBLE'', Value=E''300'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''MaxWebServiceRetryInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''MaxWebServiceRetryInterval'',E''1.150'',NULL,E''Limit on interval (seconds) between web service retry attempts'',E''DOUBLE'',E''300'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'MetadataBatchSubmitInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=NULL, Description=E''Interval (seconds) between posting metrics objects information to the Metadata Hub (enabled by setting configvar AB_METADATA_HUB_URL)'', ItemType=E''DOUBLE'', Value=E''5'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''MetadataBatchSubmitInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''MetadataBatchSubmitInterval'',E''1.20'',NULL,E''Interval (seconds) between posting metrics objects information to the Metadata Hub (enabled by setting configvar AB_METADATA_HUB_URL)'',E''DOUBLE'',E''5'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'MetadataElementsLimit';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=NULL, Description=E''Maximum number of metrics objects data items for Metadata Hub in single SOAP request'', ItemType=E''LONG'', Value=E''200'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''MetadataElementsLimit''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''MetadataElementsLimit'',E''1.20'',NULL,E''Maximum number of metrics objects data items for Metadata Hub in single SOAP request'',E''LONG'',E''200'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'MetadataFileRefreshInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=NULL, Description=E''Interval (seconds) between checking for new metrics objects data for Metadata Hub'', ItemType=E''DOUBLE'', Value=E''1800'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''MetadataFileRefreshInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''MetadataFileRefreshInterval'',E''1.20'',NULL,E''Interval (seconds) between checking for new metrics objects data for Metadata Hub'',E''DOUBLE'',E''1800'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'MetadataHubExecutableFilter';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.40'', EndVersion=NULL, Description=E''Regular expression (pcre) exclusion filter run against executable path in Metadata Hub data'', ItemType=E''STRING'', Value=E''<emptyString/>'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''MetadataHubExecutableFilter''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''MetadataHubExecutableFilter'',E''1.40'',NULL,E''Regular expression (pcre) exclusion filter run against executable path in Metadata Hub data'',E''STRING'',E''<emptyString/>'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'MetadataHubFilesLimit';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=NULL, Description=E''Limit on nubmer of metric object files (mo-*.xml) being actively monitored for import into the Metadata Hub.'', ItemType=E''LONG'', Value=E''200'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''MetadataHubFilesLimit''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''MetadataHubFilesLimit'',E''1.20'',NULL,E''Limit on nubmer of metric object files (mo-*.xml) being actively monitored for import into the Metadata Hub.'',E''LONG'',E''200'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'MetadataHubImport';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.80'', EndVersion=NULL, Description=E''Enable import of executable metrics and data set metrics in to the Metadata Hub'', ItemType=E''BOOLEAN'', Value=E''Y'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''MetadataHubImport''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''MetadataHubImport'',E''1.80'',NULL,E''Enable import of executable metrics and data set metrics in to the Metadata Hub'',E''BOOLEAN'',E''Y'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'MetadataHubMainBranch';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=NULL, Description=E''Main branch name used for import of operational data to the Metadata Hub'', ItemType=E''STRING'', Value=E''mhub_main'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''MetadataHubMainBranch''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''MetadataHubMainBranch'',E''1.20'',NULL,E''Main branch name used for import of operational data to the Metadata Hub'',E''STRING'',E''mhub_main'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'MetadataHubProfile';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=NULL, Description=E''Profile import of operational data to the Metadata Hub'', ItemType=E''BOOLEAN'', Value=E''N'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''MetadataHubProfile''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''MetadataHubProfile'',E''1.20'',NULL,E''Profile import of operational data to the Metadata Hub'',E''BOOLEAN'',E''N'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'MetadataHubSubmitWithoutSourceLoc';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.40'', EndVersion=NULL, Description=E''Accept Metadata Hub object data lacking source location (EME TR AB_AIR_ROOT)'', ItemType=E''BOOLEAN'', Value=E''N'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''MetadataHubSubmitWithoutSourceLoc''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''MetadataHubSubmitWithoutSourceLoc'',E''1.40'',NULL,E''Accept Metadata Hub object data lacking source location (EME TR AB_AIR_ROOT)'',E''BOOLEAN'',E''N'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'MetadataHubVersionPollInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=NULL, Description=E''Polling interval (seconds) for checking Metadata Hub web service version'', ItemType=E''DOUBLE'', Value=E''3600'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''MetadataHubVersionPollInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''MetadataHubVersionPollInterval'',E''1.20'',NULL,E''Polling interval (seconds) for checking Metadata Hub web service version'',E''DOUBLE'',E''3600'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'MetadataHubWssPassword';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=NULL, Description=E''Encrypted (m_password) web service security password used for Metadata Hub import'', ItemType=E''PASSWORD'', Value=E''vDTBC0PWtzeW5VJIpqwx9p'', ReporterParameterGroupType=E''CREDENTIALS'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''MetadataHubWssPassword''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''MetadataHubWssPassword'',E''1.20'',NULL,E''Encrypted (m_password) web service security password used for Metadata Hub import'',E''PASSWORD'',E''vDTBC0PWtzeW5VJIpqwx9p'',E''CREDENTIALS'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'MetadataHubWssUsername';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=NULL, Description=E''Web service security username used for Metadata Hub import'', ItemType=E''STRING'', Value=E''admin'', ReporterParameterGroupType=E''CREDENTIALS'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''MetadataHubWssUsername''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''MetadataHubWssUsername'',E''1.20'',NULL,E''Web service security username used for Metadata Hub import'',E''STRING'',E''admin'',E''CREDENTIALS'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'MonitorCpu';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.170'', EndVersion=NULL, Description=E''Enable CPU time-oriented monitoring of graph jobs to be sent to KeyServerUrls'', ItemType=E''BOOLEAN'', Value=E''N'', ReporterParameterGroupType=E''CPU_MONITOR'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''MonitorCpu''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''MonitorCpu'',E''1.170'',NULL,E''Enable CPU time-oriented monitoring of graph jobs to be sent to KeyServerUrls'',E''BOOLEAN'',E''N'',E''CPU_MONITOR'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'MonitorHosts';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.80'', EndVersion=NULL, Description=E''Enable gathering of host and file metrics on this host for use in the Control>Center'', ItemType=E''BOOLEAN'', Value=E''Y'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''MonitorHosts''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''MonitorHosts'',E''1.80'',NULL,E''Enable gathering of host and file metrics on this host for use in the Control>Center'',E''BOOLEAN'',E''Y'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'MonitorJobs';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.80'', EndVersion=NULL, Description=E''Enable monitoring of graph and plan jobs by the Control>Center'', ItemType=E''BOOLEAN'', Value=E''Y'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''MonitorJobs''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''MonitorJobs'',E''1.80'',NULL,E''Enable monitoring of graph and plan jobs by the Control>Center'',E''BOOLEAN'',E''Y'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'MonitorKeyInfo';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.120'', EndVersion=NULL, Description=E''Enable gathering of key information from running graphs for use in the Control>Center'', ItemType=E''BOOLEAN'', Value=E''Y'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''MonitorKeyInfo''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''MonitorKeyInfo'',E''1.120'',NULL,E''Enable gathering of key information from running graphs for use in the Control>Center'',E''BOOLEAN'',E''Y'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'MonitorProducts';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.80'', EndVersion=NULL, Description=E''Enable discovery and status updates of Ab Initio products on this host for use in the Control>Center'', ItemType=E''BOOLEAN'', Value=E''Y'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''MonitorProducts''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''MonitorProducts'',E''1.80'',NULL,E''Enable discovery and status updates of Ab Initio products on this host for use in the Control>Center'',E''BOOLEAN'',E''Y'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'OSAuthenticationsConnectionMethod';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.70'', EndVersion=NULL, Description=E''Connection method (see AB_CONNECTION) used for OSAuthentication-launched processes'', ItemType=E''STRING'', Value=E''rexec'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''OSAuthenticationsConnectionMethod''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''OSAuthenticationsConnectionMethod'',E''1.70'',NULL,E''Connection method (see AB_CONNECTION) used for OSAuthentication-launched processes'',E''STRING'',E''rexec'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'OSAuthenticationsPollInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.70'', EndVersion=E''1.40'', Description=E''Polling interval (seconds) for checking for OSAuthentication updates'', ItemType=E''DOUBLE'', Value=E''60'', ReporterParameterGroupType=E''OBSOLETE'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''OSAuthenticationsPollInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''OSAuthenticationsPollInterval'',E''1.70'',E''1.40'',E''Polling interval (seconds) for checking for OSAuthentication updates'',E''DOUBLE'',E''60'',E''OBSOLETE'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'OpConsoleFilesLimit';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=NULL, Description=E''Limit on number of job event files (cst-, pi-, and mp-*.xml) being actively monitored for import into the Control>Center.'', ItemType=E''LONG'', Value=E''200'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''OpConsoleFilesLimit''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''OpConsoleFilesLimit'',E''1.20'',NULL,E''Limit on number of job event files (cst-, pi-, and mp-*.xml) being actively monitored for import into the Control>Center.'',E''LONG'',E''200'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'OpConsoleOperationalArtifactFilesLimit';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.70'', EndVersion=E''1.80'', Description=E''Maximum number of operational event file handles to hold open.'', ItemType=E''LONG'', Value=E''200'', ReporterParameterGroupType=E''OBSOLETE'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''OpConsoleOperationalArtifactFilesLimit''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''OpConsoleOperationalArtifactFilesLimit'',E''1.70'',E''1.80'',E''Maximum number of operational event file handles to hold open.'',E''LONG'',E''200'',E''OBSOLETE'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'OpConsoleProductFilesLimit';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.80'', EndVersion=NULL, Description=E''Limit on number of product event files (pm-*.xml) being actively monitored for import into the Control>Center.'', ItemType=E''LONG'', Value=E''10'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''OpConsoleProductFilesLimit''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''OpConsoleProductFilesLimit'',E''1.80'',NULL,E''Limit on number of product event files (pm-*.xml) being actively monitored for import into the Control>Center.'',E''LONG'',E''10'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'OpConsoleQueueFilesLimit';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.50'', EndVersion=NULL, Description=E''Maximum number of operational queue file handles held open'', ItemType=E''LONG'', Value=E''200'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''OpConsoleQueueFilesLimit''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''OpConsoleQueueFilesLimit'',E''1.50'',NULL,E''Maximum number of operational queue file handles held open'',E''LONG'',E''200'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'OpConsoleRsFilesLimit';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=NULL, Description=E''Limit on number of resource server event files (rs-*.xml) being actively monitored for import into the Control>Center.'', ItemType=E''LONG'', Value=E''10'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''OpConsoleRsFilesLimit''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''OpConsoleRsFilesLimit'',E''1.20'',NULL,E''Limit on number of resource server event files (rs-*.xml) being actively monitored for import into the Control>Center.'',E''LONG'',E''10'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'OpConsoleWssPassword';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=NULL, Description=E''Encrypted (m_password) web service security password used for Control>Center web service requests'', ItemType=E''PASSWORD'', Value=E''h1D9hGrEWJ4_t9xh7arGss'', ReporterParameterGroupType=E''CREDENTIALS'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''OpConsoleWssPassword''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''OpConsoleWssPassword'',E''1.20'',NULL,E''Encrypted (m_password) web service security password used for Control>Center web service requests'',E''PASSWORD'',E''h1D9hGrEWJ4_t9xh7arGss'',E''CREDENTIALS'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'OpConsoleWssUsername';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=NULL, Description=E''Web service security username used for Control>Center web service requests'', ItemType=E''STRING'', Value=E''ocagent'', ReporterParameterGroupType=E''CREDENTIALS'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''OpConsoleWssUsername''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''OpConsoleWssUsername'',E''1.20'',NULL,E''Web service security username used for Control>Center web service requests'',E''STRING'',E''ocagent'',E''CREDENTIALS'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'OpenFilesLimit';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=NULL, Description=E''Maximum number of operational event data file handles held open'', ItemType=E''LONG'', Value=E''500'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''OpenFilesLimit''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''OpenFilesLimit'',E''1.20'',NULL,E''Maximum number of operational event data file handles held open'',E''LONG'',E''500'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'OperationalArtifactElementsLimit';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.70'', EndVersion=E''1.80'', Description=E''Maximum number of operational artifact events in single SOAP request.'', ItemType=E''LONG'', Value=E''100'', ReporterParameterGroupType=E''OBSOLETE'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''OperationalArtifactElementsLimit''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''OperationalArtifactElementsLimit'',E''1.70'',E''1.80'',E''Maximum number of operational artifact events in single SOAP request.'',E''LONG'',E''100'',E''OBSOLETE'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'OperationalArtifactRefreshInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.70'', EndVersion=E''1.80'', Description=E''Interval (seconds) between checks for new operational artifact event data.'', ItemType=E''DOUBLE'', Value=E''10'', ReporterParameterGroupType=E''OBSOLETE'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''OperationalArtifactRefreshInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''OperationalArtifactRefreshInterval'',E''1.70'',E''1.80'',E''Interval (seconds) between checks for new operational artifact event data.'',E''DOUBLE'',E''10'',E''OBSOLETE'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'OpsFileElementsLimit';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=NULL, Description=E''Maximum number of operational event data items in single SOAP request'', ItemType=E''LONG'', Value=E''50'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''OpsFileElementsLimit''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''OpsFileElementsLimit'',E''1.20'',NULL,E''Maximum number of operational event data items in single SOAP request'',E''LONG'',E''50'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'OpsFileRefreshInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=NULL, Description=E''Interval (seconds) between checking for new job event data'', ItemType=E''DOUBLE'', Value=E''1'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''OpsFileRefreshInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''OpsFileRefreshInterval'',E''1.20'',NULL,E''Interval (seconds) between checking for new job event data'',E''DOUBLE'',E''1'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'OpsItemBatchSubmitInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=NULL, Description=E''Seconds between operational item batch SOAP request submissions'', ItemType=E''DOUBLE'', Value=E''0.1'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''OpsItemBatchSubmitInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''OpsItemBatchSubmitInterval'',E''1.20'',NULL,E''Seconds between operational item batch SOAP request submissions'',E''DOUBLE'',E''0.1'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'OpsSingleItemEventSubmitInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=E''1.80'', Description=E''[Obsolete] Seconds between operational single item SOAP request submissions'', ItemType=E''DOUBLE'', Value=E''0.25'', ReporterParameterGroupType=E''OBSOLETE'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''OpsSingleItemEventSubmitInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''OpsSingleItemEventSubmitInterval'',E''1.20'',E''1.80'',E''[Obsolete] Seconds between operational single item SOAP request submissions'',E''DOUBLE'',E''0.25'',E''OBSOLETE'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'ProcessControl';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.90'', EndVersion=NULL, Description=E''Process control library used to manage child processes.  Only use under direction of Ab Initio Support.'', ItemType=E''STRING'', Value=E''local'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''ProcessControl''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''ProcessControl'',E''1.90'',NULL,E''Process control library used to manage child processes.  Only use under direction of Ab Initio Support.'',E''STRING'',E''local'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'ProcessStartupHoldInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.70'', EndVersion=NULL, Description=E''Interval (seconds) after reporter startup before proceeding without reaching the Control>Center'', ItemType=E''DOUBLE'', Value=E''120'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''ProcessStartupHoldInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''ProcessStartupHoldInterval'',E''1.70'',NULL,E''Interval (seconds) after reporter startup before proceeding without reaching the Control>Center'',E''DOUBLE'',E''120'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'ProductDiscoveryRunInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.80'', EndVersion=NULL, Description=E''Interval (seconds) between runs of ops-product-monitor to discover products on this host'', ItemType=E''DOUBLE'', Value=E''21600'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''ProductDiscoveryRunInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''ProductDiscoveryRunInterval'',E''1.80'',NULL,E''Interval (seconds) between runs of ops-product-monitor to discover products on this host'',E''DOUBLE'',E''21600'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'ProductElementsLimit';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.80'', EndVersion=NULL, Description=E''Maximum number of product values in single SOAP request'', ItemType=E''LONG'', Value=E''100'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''ProductElementsLimit''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''ProductElementsLimit'',E''1.80'',NULL,E''Maximum number of product values in single SOAP request'',E''LONG'',E''100'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'ProductMonitorRefreshInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.80'', EndVersion=NULL, Description=E''Polling interval (seconds) for checking for additional product information'', ItemType=E''DOUBLE'', Value=E''5'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''ProductMonitorRefreshInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''ProductMonitorRefreshInterval'',E''1.80'',NULL,E''Polling interval (seconds) for checking for additional product information'',E''DOUBLE'',E''5'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'ProductStatusRunInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.80'', EndVersion=NULL, Description=E''Interval (seconds) between runs of ops-product-monitor to collect status information on known products'', ItemType=E''DOUBLE'', Value=E''60'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''ProductStatusRunInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''ProductStatusRunInterval'',E''1.80'',NULL,E''Interval (seconds) between runs of ops-product-monitor to collect status information on known products'',E''DOUBLE'',E''60'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'ProductsPollInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.80'', EndVersion=E''1.40'', Description=E''Polling interval (seconds) for checking for product updates'', ItemType=E''DOUBLE'', Value=E''60'', ReporterParameterGroupType=E''OBSOLETE'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''ProductsPollInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''ProductsPollInterval'',E''1.80'',E''1.40'',E''Polling interval (seconds) for checking for product updates'',E''DOUBLE'',E''60'',E''OBSOLETE'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'QueueElementsLimit';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.50'', EndVersion=NULL, Description=E''Maximum number of queue status items in single SOAP request'', ItemType=E''LONG'', Value=E''100'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''QueueElementsLimit''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''QueueElementsLimit'',E''1.50'',NULL,E''Maximum number of queue status items in single SOAP request'',E''LONG'',E''100'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'QueueGatherStatusInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.50'', EndVersion=NULL, Description=E''Interval (seconds) for running ops-queue-monitor to gather queue status'', ItemType=E''DOUBLE'', Value=E''600'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''QueueGatherStatusInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''QueueGatherStatusInterval'',E''1.50'',NULL,E''Interval (seconds) for running ops-queue-monitor to gather queue status'',E''DOUBLE'',E''600'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'QueueRefreshInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.50'', EndVersion=NULL, Description=E''Interval (seconds) between checking for new operational queue data'', ItemType=E''DOUBLE'', Value=E''10'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''QueueRefreshInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''QueueRefreshInterval'',E''1.50'',NULL,E''Interval (seconds) between checking for new operational queue data'',E''DOUBLE'',E''10'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'QueuesPollInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.50'', EndVersion=E''1.40'', Description=E''Polling interval (seconds) for checking for queue updates'', ItemType=E''DOUBLE'', Value=E''60'', ReporterParameterGroupType=E''OBSOLETE'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''QueuesPollInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''QueuesPollInterval'',E''1.50'',E''1.40'',E''Polling interval (seconds) for checking for queue updates'',E''DOUBLE'',E''60'',E''OBSOLETE'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'ReadLoggingPrefixes';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.70'', EndVersion=NULL, Description=E''Colon separated list of prefixes (for example "pi:mp:cst") for logging of stage-directory file reads. This debugging option will cause the reporter.log file to very quickly roll over.'', ItemType=E''STRING'', Value=E''<emptyString/>'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''ReadLoggingPrefixes''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''ReadLoggingPrefixes'',E''1.70'',NULL,E''Colon separated list of prefixes (for example "pi:mp:cst") for logging of stage-directory file reads. This debugging option will cause the reporter.log file to very quickly roll over.'',E''STRING'',E''<emptyString/>'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'ReporterEventsElementsLimit';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.80'', EndVersion=NULL, Description=E''Maximum number of reporter events in a single SOAP request'', ItemType=E''LONG'', Value=E''50'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''ReporterEventsElementsLimit''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''ReporterEventsElementsLimit'',E''1.80'',NULL,E''Maximum number of reporter events in a single SOAP request'',E''LONG'',E''50'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'ReporterEventsFileRefreshInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.80'', EndVersion=NULL, Description=E''Interval (seconds) between checking stage directory for new reporter event data'', ItemType=E''DOUBLE'', Value=E''5'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''ReporterEventsFileRefreshInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''ReporterEventsFileRefreshInterval'',E''1.80'',NULL,E''Interval (seconds) between checking stage directory for new reporter event data'',E''DOUBLE'',E''5'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'ReporterEventsFilesLimit';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.80'', EndVersion=NULL, Description=E''Maximum number of reporter event file handles held open'', ItemType=E''LONG'', Value=E''2'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''ReporterEventsFilesLimit''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''ReporterEventsFilesLimit'',E''1.80'',NULL,E''Maximum number of reporter event file handles held open'',E''LONG'',E''2'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'ReporterHostMetricCommand';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.80'', EndVersion=NULL, Description=E''Reserved for Ab Initio use'', ItemType=E''STRING'', Value=E''<emptyString/>'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''ReporterHostMetricCommand''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''ReporterHostMetricCommand'',E''1.80'',NULL,E''Reserved for Ab Initio use'',E''STRING'',E''<emptyString/>'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'ResourceServerBatchSubmitInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=NULL, Description=E''Seconds between resource server batch SOAP request submissions'', ItemType=E''DOUBLE'', Value=E''3'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''ResourceServerBatchSubmitInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''ResourceServerBatchSubmitInterval'',E''1.20'',NULL,E''Seconds between resource server batch SOAP request submissions'',E''DOUBLE'',E''3'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'ResourceServerElementsLimit';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=NULL, Description=E''Maximum number of resource server event data items in single SOAP request'', ItemType=E''LONG'', Value=E''100'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''ResourceServerElementsLimit''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''ResourceServerElementsLimit'',E''1.20'',NULL,E''Maximum number of resource server event data items in single SOAP request'',E''LONG'',E''100'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'ResourceServerFileRefreshInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=NULL, Description=E''Interval (seconds) between checking for new resource server event data'', ItemType=E''DOUBLE'', Value=E''5'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''ResourceServerFileRefreshInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''ResourceServerFileRefreshInterval'',E''1.20'',NULL,E''Interval (seconds) between checking for new resource server event data'',E''DOUBLE'',E''5'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'ResourceServerSingleSubmitInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=E''1.100'', Description=E''[Obsolete] Seconds between resource server single item SOAP request submissions'', ItemType=E''DOUBLE'', Value=E''0.25'', ReporterParameterGroupType=E''OBSOLETE'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''ResourceServerSingleSubmitInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''ResourceServerSingleSubmitInterval'',E''1.20'',E''1.100'',E''[Obsolete] Seconds between resource server single item SOAP request submissions'',E''DOUBLE'',E''0.25'',E''OBSOLETE'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'RunFileRefreshInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.40'', EndVersion=NULL, Description=E''Interval (seconds) between checking for new graph job run files'', ItemType=E''DOUBLE'', Value=E''1'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''RunFileRefreshInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''RunFileRefreshInterval'',E''1.40'',NULL,E''Interval (seconds) between checking for new graph job run files'',E''DOUBLE'',E''1'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'RunningJobsRefreshInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=NULL, Description=E''Wait interval (seconds) between submitting runnning jobs guids to Control>Center'', ItemType=E''DOUBLE'', Value=E''3600'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''RunningJobsRefreshInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''RunningJobsRefreshInterval'',E''1.20'',NULL,E''Wait interval (seconds) between submitting runnning jobs guids to Control>Center'',E''DOUBLE'',E''3600'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'ScheduleJobs';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=NULL, Description=E''Enable running of scheduled jobs as directed by Control>Center'', ItemType=E''BOOLEAN'', Value=E''Y'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''ScheduleJobs''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''ScheduleJobs'',E''1.20'',NULL,E''Enable running of scheduled jobs as directed by Control>Center'',E''BOOLEAN'',E''Y'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'SchedulePollInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=E''1.40'', Description=E''Polling interval (seconds) for checking for schedule updates (Applicable only to Operational Console 3.0.x and Operational Console 3.1.1.x)'', ItemType=E''DOUBLE'', Value=E''30'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''SchedulePollInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''SchedulePollInterval'',E''1.20'',E''1.40'',E''Polling interval (seconds) for checking for schedule updates (Applicable only to Operational Console 3.0.x and Operational Console 3.1.1.x)'',E''DOUBLE'',E''30'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'ShutdownInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=NULL, Description=E''Wait interval (seconds) for subprocess completions at reporter shutdown'', ItemType=E''DOUBLE'', Value=E''60'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''ShutdownInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''ShutdownInterval'',E''1.20'',NULL,E''Wait interval (seconds) for subprocess completions at reporter shutdown'',E''DOUBLE'',E''60'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'SoapRetryInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=NULL, Description=E''Interval (seconds) before retry after transport error of failed web service request'', ItemType=E''DOUBLE'', Value=E''10'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''SoapRetryInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''SoapRetryInterval'',E''1.20'',NULL,E''Interval (seconds) before retry after transport error of failed web service request'',E''DOUBLE'',E''10'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'SoapTrace';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=NULL, Description=E''Log text of SOAP web service requests and responses'', ItemType=E''BOOLEAN'', Value=E''N'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''SoapTrace''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''SoapTrace'',E''1.20'',NULL,E''Log text of SOAP web service requests and responses'',E''BOOLEAN'',E''N'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'StageDirectoryAlertThreshold';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.90'', EndVersion=NULL, Description=E''Create warning and error events as the number of stage-directory files crosses 1X, 2X, etc'', ItemType=E''LONG'', Value=E''1000'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''StageDirectoryAlertThreshold''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''StageDirectoryAlertThreshold'',E''1.90'',NULL,E''Create warning and error events as the number of stage-directory files crosses 1X, 2X, etc'',E''LONG'',E''1000'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'StageDirectoryRefreshInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.80'', EndVersion=NULL, Description=E''Interval (seconds) between checking stage directory for new operational event data'', ItemType=E''DOUBLE'', Value=E''1'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''StageDirectoryRefreshInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''StageDirectoryRefreshInterval'',E''1.80'',NULL,E''Interval (seconds) between checking stage directory for new operational event data'',E''DOUBLE'',E''1'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'StageDirFlushTimeout';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.180'', EndVersion=NULL, Description=E''How long (seconds) this reporter will try to flush data to Control>Center, if flushing on reporter shutdown is requested.'', ItemType=E''LONG'', Value=E''10'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''StageDirFlushTimeout''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''StageDirFlushTimeout'',E''1.180'',NULL,E''How long (seconds) this reporter will try to flush data to Control>Center, if flushing on reporter shutdown is requested.'',E''LONG'',E''10'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'SystemsPollInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=E''1.40'', Description=E''Polling interval (seconds) for checking for OpSystem and associated data updates (Applicable only to Operational Console 3.0.x and Operational Console 3.1.1.x)'', ItemType=E''DOUBLE'', Value=E''3600'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''SystemsPollInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''SystemsPollInterval'',E''1.20'',E''1.40'',E''Polling interval (seconds) for checking for OpSystem and associated data updates (Applicable only to Operational Console 3.0.x and Operational Console 3.1.1.x)'',E''DOUBLE'',E''3600'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'SystemPropertiesVersion';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.200'', EndVersion=NULL, Description=E''Control>Center web services version corresponding to oldest Co>Operating System to be monitored for jobs'', ItemType=E''STRING'', Value=E''1.90'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''SystemPropertiesVersion''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''SystemPropertiesVersion'',E''1.200'',NULL,E''Control>Center web services version corresponding to oldest Co>Operating System to be monitored for jobs'',E''STRING'',E''1.90'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'UserHostMetricCommand';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.80'', EndVersion=NULL, Description=E''Executable and arguments that produce user defined host metric values'', ItemType=E''STRING'', Value=E''<emptyString/>'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''UserHostMetricCommand''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''UserHostMetricCommand'',E''1.80'',NULL,E''Executable and arguments that produce user defined host metric values'',E''STRING'',E''<emptyString/>'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'VersionNegotiationPollInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=NULL, Description=E''Polling interval (seconds) for checking Control>Center web service version'', ItemType=E''DOUBLE'', Value=E''300'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''VersionNegotiationPollInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''VersionNegotiationPollInterval'',E''1.20'',NULL,E''Polling interval (seconds) for checking Control>Center web service version'',E''DOUBLE'',E''300'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'VirtualHostUsernamePrefix';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.20'', EndVersion=NULL, Description=E''Prefix added to username to map username to hetero configuration virtual host entry'', ItemType=E''STRING'', Value=E''ops-'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''VirtualHostUsernamePrefix''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''VirtualHostUsernamePrefix'',E''1.20'',NULL,E''Prefix added to username to map username to hetero configuration virtual host entry'',E''STRING'',E''ops-'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'XmlParseErrorCountLimit';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.80'', EndVersion=NULL, Description=E''Number of retries of XML parse errors tolerated before a file is "dropped"'', ItemType=E''LONG'', Value=E''6'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''XmlParseErrorCountLimit''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''XmlParseErrorCountLimit'',E''1.80'',NULL,E''Number of retries of XML parse errors tolerated before a file is "dropped"'',E''LONG'',E''6'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterDefaultConfigItem WHERE Name = 'XmlParseErrorInterval';
  if (cnt > 0) then
    execute E'UPDATE OpReporterDefaultConfigItem SET StartVersion=E''1.80'', EndVersion=NULL, Description=E''Number of seconds before the XML parse error count is reset to zero'', ItemType=E''DOUBLE'', Value=E''30'', ReporterParameterGroupType=E''NORMAL'', ReporterConfigValueType=E''CONFIG'' WHERE Name = ''XmlParseErrorInterval''';
  else
    execute E'INSERT INTO OpReporterDefaultConfigItem (ReporterDefaultConfigItemId, Name,StartVersion,EndVersion,Description,ItemType,Value,ReporterParameterGroupType,ReporterConfigValueType) VALUES (nextval(''hibernate_sequence''),  E''XmlParseErrorInterval'',E''1.80'',NULL,E''Number of seconds before the XML parse error count is reset to zero'',E''DOUBLE'',E''30'',E''NORMAL'',E''CONFIG'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


-- ---------------------------------------------------
create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterConfigSet WHERE ReporterConfigSetType = 'BUILTIN';
  if (cnt > 0) then
    execute E'UPDATE OpReporterConfigSet SET Source=E''Built-in defaults'', Version=E''3.3.1'', Description=E''Built-in default values for all reporter parameters.'', ReporterConfigSetType=E''BUILTIN'' WHERE ReporterConfigSetType = ''BUILTIN''';
  else
    execute E'INSERT INTO OpReporterConfigSet (ReporterConfigSetId, Name,Source,Version,Description,ReporterConfigSetType) VALUES (nextval(''hibernate_sequence''),  E''Ab Initio Default'',E''Built-in defaults'',E''3.3.1'',E''Built-in default values for all reporter parameters.'',E''BUILTIN'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpReporterConfigItem (ReporterConfigItemId, PropertyTypeDiscriminator, ReporterDefaultConfigItemId, LongValue, ReporterConfigSetId) SELECT nextval(''hibernate_sequence''),  D.ItemType AS PropertyTypeDiscriminator, D.ReporterDefaultConfigItemId,  CAST(D.Value AS int8) as LongValue, S.ReporterConfigSetId from OpReporterDefaultConfigItem D, OpReporterConfigSet S WHERE D.ItemType=''LONG'' AND S.ReporterConfigSetType=''BUILTIN'' AND D.ReporterDefaultConfigItemId NOT IN (SELECT D2.ReporterDefaultConfigItemId FROM OpReporterConfigSet S2 JOIN OpReporterConfigItem I2 ON I2.ReporterConfigSetId = S2.ReporterConfigSetId JOIN OpReporterDefaultConfigItem D2 ON D2.ReporterDefaultConfigItemId = I2.ReporterDefaultConfigItemId WHERE D2.ItemType=''LONG'' AND S2.ReporterConfigSetType=''BUILTIN'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpReporterConfigItem (ReporterConfigItemId, PropertyTypeDiscriminator, ReporterDefaultConfigItemId, DoubleValue, ReporterConfigSetId) SELECT nextval(''hibernate_sequence''),  D.ItemType AS PropertyTypeDiscriminator, D.ReporterDefaultConfigItemId,  CAST(D.Value AS DOUBLE PRECISION) as DoubleValue, S.ReporterConfigSetId from OpReporterDefaultConfigItem D, OpReporterConfigSet S WHERE D.ItemType=''DOUBLE'' AND S.ReporterConfigSetType=''BUILTIN'' AND D.ReporterDefaultConfigItemId NOT IN (SELECT D2.ReporterDefaultConfigItemId FROM OpReporterConfigSet S2 JOIN OpReporterConfigItem I2 ON I2.ReporterConfigSetId = S2.ReporterConfigSetId JOIN OpReporterDefaultConfigItem D2 ON D2.ReporterDefaultConfigItemId = I2.ReporterDefaultConfigItemId WHERE D2.ItemType=''DOUBLE'' AND S2.ReporterConfigSetType=''BUILTIN'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpReporterConfigItem (ReporterConfigItemId, PropertyTypeDiscriminator, ReporterDefaultConfigItemId, StringValue, ReporterConfigSetId) SELECT nextval(''hibernate_sequence''),  D.ItemType AS PropertyTypeDiscriminator, D.ReporterDefaultConfigItemId,  D.Value as StringValue, S.ReporterConfigSetId from OpReporterDefaultConfigItem D, OpReporterConfigSet S WHERE D.ItemType=''STRING'' AND S.ReporterConfigSetType=''BUILTIN'' AND D.ReporterDefaultConfigItemId NOT IN (SELECT D2.ReporterDefaultConfigItemId FROM OpReporterConfigSet S2 JOIN OpReporterConfigItem I2 ON I2.ReporterConfigSetId = S2.ReporterConfigSetId JOIN OpReporterDefaultConfigItem D2 ON D2.ReporterDefaultConfigItemId = I2.ReporterDefaultConfigItemId WHERE D2.ItemType=''STRING'' AND S2.ReporterConfigSetType=''BUILTIN'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpReporterConfigItem (ReporterConfigItemId, PropertyTypeDiscriminator, ReporterDefaultConfigItemId, BooleanValue, ReporterConfigSetId) SELECT nextval(''hibernate_sequence''),  D.ItemType AS PropertyTypeDiscriminator, D.ReporterDefaultConfigItemId,  CAST(D.Value AS char(1)) as BooleanValue, S.ReporterConfigSetId from OpReporterDefaultConfigItem D, OpReporterConfigSet S WHERE D.ItemType=''BOOLEAN'' AND S.ReporterConfigSetType=''BUILTIN'' AND D.ReporterDefaultConfigItemId NOT IN (SELECT D2.ReporterDefaultConfigItemId FROM OpReporterConfigSet S2 JOIN OpReporterConfigItem I2 ON I2.ReporterConfigSetId = S2.ReporterConfigSetId JOIN OpReporterDefaultConfigItem D2 ON D2.ReporterDefaultConfigItemId = I2.ReporterDefaultConfigItemId WHERE D2.ItemType=''BOOLEAN'' AND S2.ReporterConfigSetType=''BUILTIN'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
begin
  execute E'INSERT INTO OpReporterConfigItem (ReporterConfigItemId, PropertyTypeDiscriminator, ReporterDefaultConfigItemId, PasswordValue, ReporterConfigSetId) SELECT nextval(''hibernate_sequence''),  D.ItemType AS PropertyTypeDiscriminator, D.ReporterDefaultConfigItemId,  D.Value as PasswordValue, S.ReporterConfigSetId from OpReporterDefaultConfigItem D, OpReporterConfigSet S WHERE D.ItemType=''PASSWORD'' AND S.ReporterConfigSetType=''BUILTIN'' AND D.ReporterDefaultConfigItemId NOT IN (SELECT D2.ReporterDefaultConfigItemId FROM OpReporterConfigSet S2 JOIN OpReporterConfigItem I2 ON I2.ReporterConfigSetId = S2.ReporterConfigSetId JOIN OpReporterDefaultConfigItem D2 ON D2.ReporterDefaultConfigItemId = I2.ReporterDefaultConfigItemId WHERE D2.ItemType=''PASSWORD'' AND S2.ReporterConfigSetType=''BUILTIN'')';
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


-- ---------------------------------------------------
create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpReporterConfigSet WHERE ReporterConfigSetType = 'STANDARD';
  if (cnt = 0) then
    execute E'INSERT INTO OpReporterConfigSet (ReporterConfigSetId, Name,Source,Version,Description,ReporterConfigSetType) VALUES (nextval(''hibernate_sequence''),  E''Standard'',E''OPDB Install'',E''3.3.1'',E''Standard reporter configuration definition.'',E''STANDARD'')';
    execute E'INSERT INTO OpReporterConfigItem (ReporterConfigItemId, PropertyTypeDiscriminator, StringValue, ReporterDefaultConfigItemId, ReporterConfigSetId) SELECT nextval(''hibernate_sequence''),  ''STRING'', ''/~$AB_OPS_MONITOR_DIRECTORY'', D.ReporterDefaultConfigItemId, S.ReporterConfigSetId FROM OpReporterDefaultConfigItem D, OpReporterConfigSet S WHERE D.Name=''AbOpsMonitorDirectorys'' AND D.ItemType=''STRING'' AND S.ReporterConfigSetType=''STANDARD''';
    execute E'INSERT INTO OpReporterConfigItem (ReporterConfigItemId, PropertyTypeDiscriminator, StringValue, ReporterDefaultConfigItemId, ReporterConfigSetId) SELECT nextval(''hibernate_sequence''),  ''STRING'', ''ocagent'', D.ReporterDefaultConfigItemId, S.ReporterConfigSetId FROM OpReporterDefaultConfigItem D, OpReporterConfigSet S WHERE D.Name=''OpConsoleWssUsername'' AND D.ItemType=''STRING'' AND S.ReporterConfigSetType=''STANDARD''';
    execute E'INSERT INTO OpReporterConfigItem (ReporterConfigItemId, PropertyTypeDiscriminator, StringValue, ReporterDefaultConfigItemId, ReporterConfigSetId) SELECT nextval(''hibernate_sequence''),  ''STRING'', ''admin'', D.ReporterDefaultConfigItemId, S.ReporterConfigSetId FROM OpReporterDefaultConfigItem D, OpReporterConfigSet S WHERE D.Name=''MetadataHubWssUsername'' AND D.ItemType=''STRING'' AND S.ReporterConfigSetType=''STANDARD''';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


-- ---------------------------------------------------
create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'SchemaVersion';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''Y'', Description = ''Database schema number'', Value = ''4.2.3'' WHERE Name = ''SchemaVersion''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''SchemaVersion'', ''Database schema number'', ''STRING'', ''4.2.3'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


create or replace function anonymous() returns void as $$
declare 
  cnt integer;
begin
  select count(*) into cnt from OpConfigValue where Name = 'help.version';
  if (cnt > 0) then
    execute E'UPDATE OpConfigValue SET ValueTypeEnum = ''STRING'', IsHidden = ''Y'', Description = ''FOR INTERNAL USE ONLY. The version of help requested from the Ab Initio Help server.'', Value = ''4.2.3'' WHERE Name = ''help.version''';
  else
    execute E'INSERT INTO OpConfigValue (ConfigValueId, Name, Description, ValueTypeEnum, Value, IsHidden) VALUES (nextval(''hibernate_sequence''),  ''help.version'', ''FOR INTERNAL USE ONLY. The version of help requested from the Ab Initio Help server.'', ''STRING'', ''4.2.3'', ''Y'')';
  end if;
end;
$$ LANGUAGE plpgsql;
select anonymous();
drop function anonymous();


--end-script
