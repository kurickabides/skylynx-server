/*
  SkyLynx SQL Export
  Database: skylynxnet_coredb
  Section: Tables
  Generated: 2026-07-22T22:35:59.600Z
*/
GO

IF OBJECT_ID(N'dbo.Address', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[Address] (
    [addyId] [uniqueidentifier] CONSTRAINT [DF__Address__addyId__3E1D39E1] DEFAULT (newid()) NOT NULL,
    [address_1] [nvarchar](MAX) NULL,
    [address_2] [nvarchar](MAX) NULL,
    [City] [nvarchar](MAX) NULL,
    [StateProvinceID] [uniqueidentifier] NULL,
    [Zip] [nvarchar](10) NULL,
    [geoLocation] [geography] NULL,
    [isMailing] [bit] NULL,
    [ModifiedDate] [datetime] CONSTRAINT [DF__Address__Modifie__3F115E1A] DEFAULT (getdate()) NULL
);
END
GO

IF OBJECT_ID(N'dbo.API_KEYS', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[API_KEYS] (
    [ApiKeyID] [uniqueidentifier] CONSTRAINT [DF__API_KEYS__ApiKey__2739D489] DEFAULT (newid()) NOT NULL,
    [KeyHash] [nvarchar](256) NOT NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__API_KEYS__Create__282DF8C2] DEFAULT (getdate()) NOT NULL,
    [ExpiresAt] [datetime] NULL,
    [IsActive] [bit] CONSTRAINT [DF__API_KEYS__IsActi__29221CFB] DEFAULT ((1)) NOT NULL,
    [OwnerUUID] [uniqueidentifier] NOT NULL
);
END
GO

IF OBJECT_ID(N'dbo.API_Owners', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[API_Owners] (
    [OwnerUUID] [uniqueidentifier] CONSTRAINT [DF__API_Owner__Owner__0E04126B] DEFAULT (newid()) NOT NULL,
    [UserID] [nvarchar](128) NULL,
    [PortalID] [uniqueidentifier] NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__API_Owner__Creat__0EF836A4] DEFAULT (getdate()) NULL,
    [OwnerTypeID] [uniqueidentifier] NULL
);
END
GO

IF OBJECT_ID(N'dbo.AspNetRoles', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[AspNetRoles] (
    [Id] [nvarchar](128) NOT NULL,
    [Name] [nvarchar](256) NOT NULL
);
END
GO

IF OBJECT_ID(N'dbo.AspNetUserClaims', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[AspNetUserClaims] (
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [UserId] [nvarchar](128) NOT NULL,
    [ClaimType] [nvarchar](MAX) NULL,
    [ClaimValue] [nvarchar](MAX) NULL
);
END
GO

IF OBJECT_ID(N'dbo.AspNetUserLogins', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[AspNetUserLogins] (
    [LoginProvider] [nvarchar](128) NOT NULL,
    [ProviderKey] [nvarchar](128) NOT NULL,
    [UserId] [nvarchar](128) NOT NULL
);
END
GO

IF OBJECT_ID(N'dbo.AspNetUserRoles', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[AspNetUserRoles] (
    [UserId] [nvarchar](128) NOT NULL,
    [RoleId] [nvarchar](128) NOT NULL
);
END
GO

IF OBJECT_ID(N'dbo.AspNetUsers', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[AspNetUsers] (
    [Id] [nvarchar](128) NOT NULL,
    [UserName] [nvarchar](256) NOT NULL,
    [Email] [nvarchar](256) NULL,
    [EmailConfirmed] [bit] CONSTRAINT [DF__AspNetUse__Email__267ABA7A] DEFAULT ((0)) NOT NULL,
    [PasswordHash] [nvarchar](MAX) NULL,
    [SecurityStamp] [nvarchar](MAX) NULL,
    [PhoneNumber] [nvarchar](MAX) NULL,
    [PhoneNumberConfirmed] [bit] CONSTRAINT [DF__AspNetUse__Phone__276EDEB3] DEFAULT ((0)) NOT NULL,
    [TwoFactorEnabled] [bit] CONSTRAINT [DF__AspNetUse__TwoFa__286302EC] DEFAULT ((0)) NOT NULL,
    [LockoutEndDateUtc] [datetime] NULL,
    [LockoutEnabled] [bit] CONSTRAINT [DF__AspNetUse__Locko__29572725] DEFAULT ((1)) NOT NULL,
    [AccessFailedCount] [int] CONSTRAINT [DF__AspNetUse__Acces__2A4B4B5E] DEFAULT ((0)) NOT NULL
);
END
GO

IF OBJECT_ID(N'dbo.AspNetUserTokens', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[AspNetUserTokens] (
    [UserId] [nvarchar](128) NOT NULL,
    [LoginProvider] [nvarchar](128) NOT NULL,
    [Name] [nvarchar](128) NOT NULL,
    [Value] [nvarchar](MAX) NULL
);
END
GO

IF OBJECT_ID(N'dbo.BankAccounts', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[BankAccounts] (
    [BankAccountID] [uniqueidentifier] CONSTRAINT [DF__BankAccou__BankA__4D94879B] DEFAULT (newid()) NOT NULL,
    [UserID] [nvarchar](128) NOT NULL,
    [AccountHolderName] [nvarchar](100) NOT NULL,
    [AccountNumberEncrypted] [varbinary](MAX) NOT NULL,
    [RoutingNumber] [nvarchar](100) NOT NULL,
    [BankName] [nvarchar](100) NOT NULL,
    [AccountType] [nvarchar](50) NOT NULL,
    [Currency] [nvarchar](10) NOT NULL,
    [IsPrimary] [bit] CONSTRAINT [DF__BankAccou__IsPri__4E88ABD4] DEFAULT ((1)) NULL,
    [VerificationStatus] [nvarchar](50) CONSTRAINT [DF__BankAccou__Verif__4F7CD00D] DEFAULT ('Pending') NOT NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__BankAccou__Creat__5070F446] DEFAULT (getdate()) NULL
);
END
GO

IF OBJECT_ID(N'dbo.CustomerProfile_Providers', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[CustomerProfile_Providers] (
    [ProviderID] [uniqueidentifier] CONSTRAINT [DF__CustomerP__Provi__489AC854] DEFAULT (newid()) NOT NULL,
    [UserID] [nvarchar](128) NOT NULL,
    [ProviderType] [nvarchar](50) NOT NULL,
    [ProviderName] [nvarchar](100) NOT NULL,
    [ExternalProfileID] [nvarchar](255) NOT NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__CustomerP__Creat__4B7734FF] DEFAULT (getdate()) NULL
);
END
GO

IF OBJECT_ID(N'dbo.DefaultUserRoles', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[DefaultUserRoles] (
    [PortalID] [uniqueidentifier] NOT NULL,
    [RoleID] [nvarchar](128) NOT NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__DefaultUs__Creat__31D75E8D] DEFAULT (getdate()) NULL
);
END
GO

IF OBJECT_ID(N'dbo.DyForm', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[DyForm] (
    [FormID] [uniqueidentifier] CONSTRAINT [DF__DyFormDFo__FormI__2354350C] DEFAULT (newid()) NOT NULL,
    [FormName] [nvarchar](100) NOT NULL,
    [Description] [nvarchar](255) NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__DyFormDFo__Creat__24485945] DEFAULT (getdate()) NULL
);
END
GO

IF OBJECT_ID(N'dbo.DyFormDataSourceDefinition', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[DyFormDataSourceDefinition] (
    [DyFormDSDefinitionID] [uniqueidentifier] CONSTRAINT [DF__DyFormFie__DyFor__422DC1E7] DEFAULT (newid()) NOT NULL,
    [SourceKey] [nvarchar](255) NOT NULL,
    [IsDirectProperty] [bit] CONSTRAINT [DF__DyFormFie__IsDir__4321E620] DEFAULT ((0)) NOT NULL,
    [SourcePath] [nvarchar](MAX) NOT NULL
);
END
GO

IF OBJECT_ID(N'dbo.DyFormDomains', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[DyFormDomains] (
    [DomainID] [uniqueidentifier] CONSTRAINT [DF__DyFormDFo__Domai__0777106D] DEFAULT (newid()) NOT NULL,
    [Name] [nvarchar](100) NOT NULL,
    [DomainTypeID] [uniqueidentifier] NOT NULL,
    [Description] [nvarchar](255) NULL
);
END
GO

IF OBJECT_ID(N'dbo.DyFormDomainType', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[DyFormDomainType] (
    [DomainTypeID] [uniqueidentifier] CONSTRAINT [DF__DyFormDom__Domai__03A67F89] DEFAULT (newid()) NOT NULL,
    [DomainTypeName] [nvarchar](100) NOT NULL,
    [Description] [nvarchar](255) NULL
);
END
GO

IF OBJECT_ID(N'dbo.DyFormDomainValues', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[DyFormDomainValues] (
    [DomainValueID] [uniqueidentifier] CONSTRAINT [DF__DyFormDFo__Domai__0B47A151] DEFAULT (newid()) NOT NULL,
    [DomainID] [uniqueidentifier] NOT NULL,
    [Value] [nvarchar](200) NOT NULL,
    [Label] [nvarchar](200) NULL,
    [SortOrder] [int] CONSTRAINT [DF__DyFormDFo__SortO__0C3BC58A] DEFAULT ((0)) NULL
);
END
GO

IF OBJECT_ID(N'dbo.DyFormExpression', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[DyFormExpression] (
    [DyFormExpressionID] [uniqueidentifier] CONSTRAINT [DF__DyFormExp__DyFor__09B45E9A] DEFAULT (newid()) NOT NULL,
    [Expression] [nvarchar](MAX) NOT NULL,
    [ResolverTypeID] [uniqueidentifier] NOT NULL,
    [Description] [nvarchar](255) NULL
);
END
GO

IF OBJECT_ID(N'dbo.DyFormField', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[DyFormField] (
    [DyFormFieldID] [uniqueidentifier] CONSTRAINT [DF__DyFormDFo__Field__3572E547] DEFAULT (newid()) NOT NULL,
    [FieldTypeID] [uniqueidentifier] NOT NULL,
    [Tooltip] [nvarchar](255) NULL,
    [Label] [nvarchar](255) NULL,
    [DomainID] [uniqueidentifier] NULL
);
END
GO

IF OBJECT_ID(N'dbo.DyFormFieldRule', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[DyFormFieldRule] (
    [RuleID] [uniqueidentifier] CONSTRAINT [DF__DyFormDFo__RuleI__40E497F3] DEFAULT (newid()) NOT NULL,
    [FieldID] [uniqueidentifier] NOT NULL,
    [RuleTypeID] [uniqueidentifier] NOT NULL,
    [ResolverTypeID] [uniqueidentifier] NOT NULL,
    [RuleExpression] [nvarchar](MAX) NOT NULL,
    [IsEnabled] [bit] CONSTRAINT [DF__DyFormDFo__IsEna__41D8BC2C] DEFAULT ((1)) NULL,
    [Priority] [int] CONSTRAINT [DF__DyFormDFo__Prior__42CCE065] DEFAULT ((0)) NULL,
    [ErrorMessage] [nvarchar](255) NULL
);
END
GO

IF OBJECT_ID(N'dbo.DyFormFieldSectionDefinition', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[DyFormFieldSectionDefinition] (
    [SectionDefinitionID] [uniqueidentifier] CONSTRAINT [DF__DyFormSec__Secti__53584DE9] DEFAULT (newid()) NOT NULL,
    [SectionID] [uniqueidentifier] NOT NULL,
    [DyFormFieldID] [uniqueidentifier] NOT NULL,
    [ViewModelDefinitionID] [uniqueidentifier] NOT NULL,
    [SortOrder] [int] CONSTRAINT [DF__DyFormSec__SortO__544C7222] DEFAULT ((0)) NOT NULL,
    [DyFormDSDefinitionID] [uniqueidentifier] NOT NULL
);
END
GO

IF OBJECT_ID(N'dbo.DyFormFieldType', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[DyFormFieldType] (
    [FieldTypeID] [uniqueidentifier] CONSTRAINT [DF__DyFormFie__Field__17E28260] DEFAULT (newid()) NOT NULL,
    [FieldTypeName] [nvarchar](100) NOT NULL,
    [ComponentName] [nvarchar](100) NOT NULL
);
END
GO

IF OBJECT_ID(N'dbo.DyFormResolverContext', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[DyFormResolverContext] (
    [Context] [nvarchar](50) NOT NULL,
    [Description] [nvarchar](255) NULL
);
END
GO

IF OBJECT_ID(N'dbo.DyFormResolverType', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[DyFormResolverType] (
    [ResolverTypeID] [uniqueidentifier] CONSTRAINT [DF__DyFormRes__Resol__1F83A428] DEFAULT (newid()) NOT NULL,
    [Name] [nvarchar](100) NOT NULL,
    [Description] [nvarchar](255) NULL
);
END
GO

IF OBJECT_ID(N'dbo.DyFormRuleDefinition', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[DyFormRuleDefinition] (
    [RuleDefinitionID] [uniqueidentifier] CONSTRAINT [DF__DyFormRul__RuleD__170E59B8] DEFAULT (newid()) NOT NULL,
    [RuleKey] [nvarchar](100) NOT NULL,
    [ResolverTypeID] [uniqueidentifier] NOT NULL,
    [DyFormExpressionID] [uniqueidentifier] NOT NULL,
    [Description] [nvarchar](255) NULL
);
END
GO

IF OBJECT_ID(N'dbo.DyFormRuleSyntax', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[DyFormRuleSyntax] (
    [RuleSyntaxID] [uniqueidentifier] CONSTRAINT [DF__DyFormRul__RuleS__0A1E72EE] DEFAULT (newid()) NOT NULL,
    [SyntaxName] [nvarchar](100) NOT NULL,
    [Description] [nvarchar](255) NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__DyFormRul__Creat__0B129727] DEFAULT (getdate()) NULL,
    [UpdatedAt] [datetime] CONSTRAINT [DF__DyFormRul__Updat__0C06BB60] DEFAULT (getdate()) NULL
);
END
GO

IF OBJECT_ID(N'dbo.DyFormRuleTarget', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[DyFormRuleTarget] (
    [RuleTargetID] [uniqueidentifier] CONSTRAINT [DF__DyFormRul__RuleT__1BD30ED5] DEFAULT (newid()) NOT NULL,
    [RuleDefinitionID] [uniqueidentifier] NOT NULL,
    [ViewModelDefinitionID] [uniqueidentifier] NOT NULL,
    [DyFormFieldID] [uniqueidentifier] NULL,
    [SectionID] [uniqueidentifier] NULL,
    [SortOrder] [int] CONSTRAINT [DF__DyFormRul__SortO__1CC7330E] DEFAULT ((0)) NOT NULL,
    [Notes] [nvarchar](1000) NULL
);
END
GO

IF OBJECT_ID(N'dbo.DyFormRuleType', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[DyFormRuleType] (
    [RuleTypeID] [uniqueidentifier] CONSTRAINT [DF__DyFormRul__RuleT__1BB31344] DEFAULT (newid()) NOT NULL,
    [Name] [nvarchar](100) NOT NULL,
    [Description] [nvarchar](255) NULL
);
END
GO

IF OBJECT_ID(N'dbo.DyFormSection', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[DyFormSection] (
    [SectionID] [uniqueidentifier] CONSTRAINT [DF__DyFormDFo__Secti__2724C5F0] DEFAULT (newid()) NOT NULL,
    [SectionName] [nvarchar](100) NOT NULL,
    [SortOrder] [int] CONSTRAINT [DF__DyFormDFo__SortO__2818EA29] DEFAULT ((0)) NULL,
    [Label] [nvarchar](255) NULL
);
END
GO

IF OBJECT_ID(N'dbo.DyFormSectionResolvers', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[DyFormSectionResolvers] (
    [DyFormID] [uniqueidentifier] NOT NULL,
    [SectionID] [uniqueidentifier] NOT NULL,
    [ResolverContext] [nvarchar](50) NOT NULL,
    [ResolverTypeID] [uniqueidentifier] NOT NULL,
    [ResolverTarget] [nvarchar](255) NOT NULL,
    [IsActive] [bit] CONSTRAINT [DF__DyFormSec__IsAct__78BEDCC2] DEFAULT ((1)) NULL,
    [Notes] [nvarchar](1000) NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__DyFormSec__Creat__79B300FB] DEFAULT (getdate()) NULL,
    [UpdatedAt] [datetime] NULL
);
END
GO

IF OBJECT_ID(N'dbo.DyFormSections', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[DyFormSections] (
    [FormSectionID] [uniqueidentifier] CONSTRAINT [DF__DyFormSec__FormS__76177A41] DEFAULT (newid()) NOT NULL,
    [FormID] [uniqueidentifier] NOT NULL,
    [SectionID] [uniqueidentifier] NOT NULL,
    [ParentFormSectionID] [uniqueidentifier] NULL,
    [SortOrder] [int] CONSTRAINT [DF__DyFormSec__SortO__770B9E7A] DEFAULT ((0)) NULL
);
END
GO

IF OBJECT_ID(N'dbo.DyFormViewModelDefinition', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[DyFormViewModelDefinition] (
    [ViewModelDefinitionID] [uniqueidentifier] CONSTRAINT [DF__DyFormVie__ViewM__48DABF76] DEFAULT (newid()) NOT NULL,
    [ViewModelName] [nvarchar](100) NOT NULL,
    [DestKey] [nvarchar](255) NOT NULL
);
END
GO

IF OBJECT_ID(N'dbo.DyFormViewModelLineage', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[DyFormViewModelLineage] (
    [ViewModelDefinitionID] [uniqueidentifier] NOT NULL,
    [ChildViewModelDefinitionID] [uniqueidentifier] NOT NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__DyFormVie__Creat__5E94F66B] DEFAULT (getdate()) NULL
);
END
GO

IF OBJECT_ID(N'dbo.GlobalModuleSettings', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[GlobalModuleSettings] (
    [ModuleID] [uniqueidentifier] NOT NULL,
    [SettingKeyID] [uniqueidentifier] NOT NULL,
    [RoleID] [nvarchar](128) NOT NULL,
    [Value] [nvarchar](MAX) NOT NULL,
    [UpdatedAt] [datetime] CONSTRAINT [DF__GlobalMod__Updat__4AADF94F] DEFAULT (getdate()) NULL
);
END
GO

IF OBJECT_ID(N'dbo.GlobalPortalSettings', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[GlobalPortalSettings] (
    [SettingKeyID] [uniqueidentifier] NOT NULL,
    [Value] [nvarchar](MAX) NOT NULL,
    [UpdatedAt] [datetime] CONSTRAINT [DF__GlobalPor__Updat__2F05DEDA] DEFAULT (getdate()) NULL
);
END
GO

IF OBJECT_ID(N'dbo.ISO6391_Languages', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[ISO6391_Languages] (
    [LanguageCode] [nvarchar](2) NOT NULL,
    [LanguageName] [nvarchar](100) NOT NULL
);
END
GO

IF OBJECT_ID(N'dbo.Layouts', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[Layouts] (
    [LayoutID] [uniqueidentifier] CONSTRAINT [DF__Layouts__LayoutI__483BA0F8] DEFAULT (newid()) NOT NULL,
    [DisplayName] [nvarchar](255) NOT NULL,
    [LayoutType] [nvarchar](100) NULL,
    [Description] [nvarchar](255) NULL,
    [HasSidebar] [bit] CONSTRAINT [DF__Layouts__HasSide__492FC531] DEFAULT ((1)) NOT NULL,
    [HasHeader] [bit] CONSTRAINT [DF__Layouts__HasHead__4A23E96A] DEFAULT ((1)) NOT NULL,
    [HasFooter] [bit] CONSTRAINT [DF__Layouts__HasFoot__4B180DA3] DEFAULT ((1)) NOT NULL,
    [HasNavigation] [bit] CONSTRAINT [DF__Layouts__HasNavi__4C0C31DC] DEFAULT ((1)) NOT NULL,
    [HasContentPane] [bit] CONSTRAINT [DF__Layouts__HasCont__4D005615] DEFAULT ((1)) NOT NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__Layouts__Created__4DF47A4E] DEFAULT (getdate()) NULL,
    [StyledID] [uniqueidentifier] NULL,
    [componentName] [nvarchar](255) NULL,
    [componentPath] [nvarchar](255) NULL,
    [ComponentConfig] [nvarchar](MAX) NULL
);
END
GO

IF OBJECT_ID(N'dbo.LayoutTypes', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[LayoutTypes] (
    [LayoutTypeID] [uniqueidentifier] CONSTRAINT [DF__LayoutTyp__Layou__51C50B32] DEFAULT (newid()) NOT NULL,
    [LayoutTypeName] [nvarchar](50) NOT NULL,
    [Description] [nvarchar](255) NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__LayoutTyp__Creat__52B92F6B] DEFAULT (getdate()) NULL
);
END
GO

IF OBJECT_ID(N'dbo.Modules', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[Modules] (
    [ModuleID] [uniqueidentifier] CONSTRAINT [DF__Modules__ModuleI__02FC7413] DEFAULT (newid()) NOT NULL,
    [ModuleName] [nvarchar](50) NOT NULL,
    [ModuleDescription] [nvarchar](100) NOT NULL,
    [ImageFilePath] [nvarchar](MAX) NOT NULL,
    [ModuleVersion] [int] NOT NULL,
    [componentPath] [nvarchar](255) NOT NULL,
    [CreatedOnDate] [datetime] CONSTRAINT [DF__Modules__Created__03F0984C] DEFAULT (getdate()) NOT NULL,
    [componentName] [nvarchar](255) NULL,
    [ComponentConfig] [nvarchar](MAX) NULL,
    [StyledID] [uniqueidentifier] NULL
);
END
GO

IF OBJECT_ID(N'dbo.ModuleSettings', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[ModuleSettings] (
    [PortalPageModuleID] [uniqueidentifier] NOT NULL,
    [SettingKeyID] [uniqueidentifier] NOT NULL,
    [RoleID] [nvarchar](128) NOT NULL,
    [Value] [nvarchar](MAX) NOT NULL,
    [UpdatedAt] [datetime] CONSTRAINT [DF__ModuleSet__Updat__5CCCA98A] DEFAULT (getdate()) NULL
);
END
GO

IF OBJECT_ID(N'dbo.OwnerTypes', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[OwnerTypes] (
    [OwnerTypeID] [uniqueidentifier] CONSTRAINT [DF__OwnerType__Owner__245D67DE] DEFAULT (newid()) NOT NULL,
    [OwnerTypeName] [nvarchar](50) NOT NULL
);
END
GO

IF OBJECT_ID(N'dbo.PageDefinition', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[PageDefinition] (
    [PageID] [uniqueidentifier] CONSTRAINT [DF__PageDefin__PageI__7E97B1A9] DEFAULT (newid()) NOT NULL,
    [RoutePath] [nvarchar](255) NOT NULL,
    [PageTitle] [nvarchar](100) NULL,
    [MenuIcon] [nvarchar](100) NULL,
    [RequiresAuth] [bit] CONSTRAINT [DF__PageDefin__Requi__7F8BD5E2] DEFAULT ((1)) NULL,
    [RoleID] [nvarchar](128) NULL,
    [Notes] [nvarchar](255) NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__PageDefin__Creat__007FFA1B] DEFAULT (getdate()) NULL,
    [componentName] [nvarchar](255) NULL,
    [componentPath] [nvarchar](255) NULL,
    [ComponentConfig] [nvarchar](MAX) NULL,
    [StyledID] [uniqueidentifier] NULL
);
END
GO

IF OBJECT_ID(N'dbo.PaymentMethods', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[PaymentMethods] (
    [PaymentMethodID] [uniqueidentifier] CONSTRAINT [DF__PaymentMe__Payme__59C55456] DEFAULT (newid()) NOT NULL,
    [UserID] [nvarchar](128) NOT NULL,
    [Type] [nvarchar](50) NOT NULL,
    [Last4Digits] [nvarchar](4) NOT NULL,
    [ExpirationDate] [nvarchar](7) NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__PaymentMe__Creat__5BAD9CC8] DEFAULT (getdate()) NULL
);
END
GO

IF OBJECT_ID(N'dbo.PortalOwners', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[PortalOwners] (
    [UserID] [nvarchar](128) NOT NULL,
    [PortalID] [uniqueidentifier] NOT NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__Users_Por__Creat__24E777C3] DEFAULT (getdate()) NULL
);
END
GO

IF OBJECT_ID(N'dbo.PortalPageModules', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[PortalPageModules] (
    [PortalPageModuleID] [uniqueidentifier] CONSTRAINT [DF__PortalMod__Porta__3493CFA7] DEFAULT (newid()) NOT NULL,
    [PortalID] [uniqueidentifier] NOT NULL,
    [ModuleID] [uniqueidentifier] NOT NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__PortalMod__Creat__3587F3E0] DEFAULT (getdate()) NULL,
    [PageID] [uniqueidentifier] NOT NULL,
    [ContainerName] [nvarchar](100) NULL
);
END
GO

IF OBJECT_ID(N'dbo.PortalProfileProviders', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[PortalProfileProviders] (
    [PortalID] [uniqueidentifier] NOT NULL,
    [ProviderID] [uniqueidentifier] NOT NULL,
    [IsEnabled] [bit] CONSTRAINT [DF__PortalPro__IsEna__3118447E] DEFAULT ((1)) NULL,
    [IsPortalDefault] [bit] CONSTRAINT [DF__PortalPro__IsPor__3B60C8C7] DEFAULT ((0)) NOT NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__PortalPro__Creat__3D491139] DEFAULT (getdate()) NULL
);
END
GO

IF OBJECT_ID(N'dbo.PortalRoles', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[PortalRoles] (
    [PortalID] [uniqueidentifier] NOT NULL,
    [RoleID] [nvarchar](128) NOT NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__PortalRol__Creat__2D12A970] DEFAULT (getdate()) NULL
);
END
GO

IF OBJECT_ID(N'dbo.Portals', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[Portals] (
    [PortalID] [uniqueidentifier] CONSTRAINT [DF__Portals__PortalI__403A8C7D] DEFAULT (newid()) NOT NULL,
    [PortalName] [nvarchar](100) NOT NULL,
    [Description] [nvarchar](MAX) NULL,
    [CreatedDate] [datetime] CONSTRAINT [DF__Portals__Created__412EB0B6] DEFAULT (getdate()) NULL,
    [SplashImage] [nvarchar](255) NULL,
    [Status] [nvarchar](50) NULL,
    [LastUpdated] [datetime] NULL
);
END
GO

IF OBJECT_ID(N'dbo.PortalSettings', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[PortalSettings] (
    [PortalID] [uniqueidentifier] NOT NULL,
    [SettingKeyID] [uniqueidentifier] NOT NULL,
    [Value] [nvarchar](MAX) NOT NULL,
    [UpdatedAt] [datetime] CONSTRAINT [DF__PortalSet__Updat__5066D2A5] DEFAULT (getdate()) NULL
);
END
GO

IF OBJECT_ID(N'dbo.ProfileProviders', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[ProfileProviders] (
    [ProviderID] [uniqueidentifier] CONSTRAINT [DF__ProfilePr__Provi__4924D839] DEFAULT (newid()) NOT NULL,
    [ProviderName] [nvarchar](100) NOT NULL,
    [IsSystemDefault] [bit] CONSTRAINT [DF__ProfilePr__IsSys__54968AE5] DEFAULT ((0)) NOT NULL,
    [Description] [nvarchar](1080) NULL
);
END
GO

IF OBJECT_ID(N'dbo.ProtosDataModelDefinition', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[ProtosDataModelDefinition] (
    [DataModelID] [uniqueidentifier] CONSTRAINT [DF__ProtosDat__DataM__57B2EEB2] DEFAULT (newid()) NOT NULL,
    [DataModelName] [nvarchar](100) NOT NULL,
    [DataModelJSON] [nvarchar](MAX) NULL,
    [Description] [nvarchar](255) NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__ProtosDat__Creat__58A712EB] DEFAULT (getdate()) NOT NULL,
    [UpdatedAt] [datetime] CONSTRAINT [DF__ProtosDat__Updat__599B3724] DEFAULT (getdate()) NOT NULL
);
END
GO

IF OBJECT_ID(N'dbo.ProtosTargetType', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[ProtosTargetType] (
    [TargetTypeID] [uniqueidentifier] CONSTRAINT [DF__ProtosTar__Targe__4CE05A84] DEFAULT (newid()) NOT NULL,
    [TargetTypeName] [nvarchar](100) NOT NULL,
    [Description] [nvarchar](255) NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__ProtosTar__Creat__4DD47EBD] DEFAULT (getdate()) NULL,
    [UpdatedAt] [datetime] CONSTRAINT [DF__ProtosTar__Updat__4EC8A2F6] DEFAULT (getdate()) NULL
);
END
GO

IF OBJECT_ID(N'dbo.ProtosTemplate', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[ProtosTemplate] (
    [TemplateID] [uniqueidentifier] CONSTRAINT [DF__ProtosTem__Templ__149C0161] DEFAULT (newid()) NOT NULL,
    [TemplateName] [nvarchar](100) NOT NULL,
    [TemplateType] [nvarchar](100) NOT NULL,
    [Description] [nvarchar](255) NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__ProtosTem__Creat__1590259A] DEFAULT (getdate()) NULL,
    [UpdatedAt] [datetime] CONSTRAINT [DF__ProtosTem__Updat__168449D3] DEFAULT (getdate()) NULL
);
END
GO

IF OBJECT_ID(N'dbo.ProtosTemplateLineage', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[ProtosTemplateLineage] (
    [LineageID] [uniqueidentifier] CONSTRAINT [DF__ProtosTem__Linea__28A2FA0E] DEFAULT (newid()) NOT NULL,
    [ParentVersionID] [uniqueidentifier] NOT NULL,
    [ChildVersionID] [uniqueidentifier] NOT NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__ProtosTem__Creat__29971E47] DEFAULT (getdate()) NULL,
    [UpdatedAt] [datetime] CONSTRAINT [DF__ProtosTem__Updat__2A8B4280] DEFAULT (getdate()) NULL
);
END
GO

IF OBJECT_ID(N'dbo.ProtosTemplateLink', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[ProtosTemplateLink] (
    [TemplateLinkID] [uniqueidentifier] CONSTRAINT [DF__ProtosTem__Templ__3414ACBA] DEFAULT (newid()) NOT NULL,
    [TemplateVersionID] [uniqueidentifier] NOT NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__ProtosTem__Creat__3508D0F3] DEFAULT (getdate()) NULL,
    [UpdatedAt] [datetime] CONSTRAINT [DF__ProtosTem__Updat__35FCF52C] DEFAULT (getdate()) NULL,
    [IsDefault] [bit] CONSTRAINT [DF__ProtosTem__IsDef__36F11965] DEFAULT ((0)) NOT NULL,
    [OverrideJSON] [nvarchar](MAX) NULL,
    [TargetTypeID] [uniqueidentifier] NULL,
    [TargetObjectID] [uniqueidentifier] NULL,
    [ResolverID] [uniqueidentifier] NULL
);
END
GO

IF OBJECT_ID(N'dbo.ProtosTemplateStatus', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[ProtosTemplateStatus] (
    [TemplateStatusID] [uniqueidentifier] CONSTRAINT [DF__ProtosTem__Templ__4262CC11] DEFAULT (newid()) NOT NULL,
    [StatusName] [nvarchar](100) NOT NULL,
    [Description] [nvarchar](255) NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__ProtosTem__Creat__4356F04A] DEFAULT (getdate()) NULL,
    [UpdatedAt] [datetime] CONSTRAINT [DF__ProtosTem__Updat__444B1483] DEFAULT (getdate()) NULL
);
END
GO

IF OBJECT_ID(N'dbo.ProtosTemplateTree', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[ProtosTemplateTree] (
    [ParentVersionID] [uniqueidentifier] NOT NULL,
    [ChildVersionID] [uniqueidentifier] NOT NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__ProtosVie__Creat__729BEF18] DEFAULT (getdate()) NULL,
    [UpdatedAt] [datetime] CONSTRAINT [DF__ProtosVie__Updat__73901351] DEFAULT (getdate()) NULL,
    [SortOrder] [int] NULL
);
END
GO

IF OBJECT_ID(N'dbo.ProtosTemplateVersion', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[ProtosTemplateVersion] (
    [TemplateVersionID] [uniqueidentifier] CONSTRAINT [DF__ProtosTem__Templ__1E256B9B] DEFAULT (newid()) NOT NULL,
    [TemplateID] [uniqueidentifier] NOT NULL,
    [VersionNumber] [int] NOT NULL,
    [VersionLabel] [nvarchar](50) NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__ProtosTem__Creat__1F198FD4] DEFAULT (getdate()) NULL,
    [UpdatedAt] [datetime] CONSTRAINT [DF__ProtosTem__Updat__200DB40D] DEFAULT (getdate()) NULL,
    [StatusName] [nvarchar](100) NULL
);
END
GO

IF OBJECT_ID(N'dbo.ProtosViewModelDefinition', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[ProtosViewModelDefinition] (
    [ViewModelDefinitionID] [uniqueidentifier] CONSTRAINT [DF__ProtosVie__ViewM__4999D985] DEFAULT (newid()) NOT NULL,
    [ViewModelName] [nvarchar](100) NOT NULL,
    [TemplateVersionID] [uniqueidentifier] NOT NULL,
    [SortOrder] [int] CONSTRAINT [DF__ProtosVie__SortO__4A8DFDBE] DEFAULT ((0)) NOT NULL,
    [IsDefault] [bit] CONSTRAINT [DF__ProtosVie__IsDef__4B8221F7] DEFAULT ((0)) NOT NULL,
    [ViewModelContextJSON] [nvarchar](MAX) NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__ProtosVie__Creat__4C764630] DEFAULT (getdate()) NULL,
    [UpdatedAt] [datetime] CONSTRAINT [DF__ProtosVie__Updat__4D6A6A69] DEFAULT (getdate()) NULL,
    [TemplateLinkID] [uniqueidentifier] NULL
);
END
GO

IF OBJECT_ID(N'dbo.ProviderProfileFields', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[ProviderProfileFields] (
    [FieldID] [uniqueidentifier] CONSTRAINT [DF__ProviderP__Field__4C0144E4] DEFAULT (newid()) NOT NULL,
    [ProviderID] [uniqueidentifier] NOT NULL,
    [FieldName] [nvarchar](100) NOT NULL,
    [IsRequired] [bit] CONSTRAINT [DF__ProviderP__IsReq__4CF5691D] DEFAULT ((0)) NOT NULL,
    [FieldTypeID] [uniqueidentifier] NULL,
    [SortOrder] [int] NULL
);
END
GO

IF OBJECT_ID(N'dbo.ProviderProfileFieldType', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[ProviderProfileFieldType] (
    [FieldTypeID] [uniqueidentifier] CONSTRAINT [DF__ProviderP__Field__5C37ACAD] DEFAULT (newid()) NOT NULL,
    [FieldTypeName] [nvarchar](100) NOT NULL,
    [Description] [nvarchar](255) NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__ProviderP__Creat__5D2BD0E6] DEFAULT (getdate()) NULL,
    [UpdatedAt] [datetime] CONSTRAINT [DF__ProviderP__Updat__5E1FF51F] DEFAULT (getdate()) NULL
);
END
GO

IF OBJECT_ID(N'dbo.Resolvers', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[Resolvers] (
    [ResolverID] [uniqueidentifier] CONSTRAINT [DF__Resolvers__Resol__17CD73C7] DEFAULT (newid()) NOT NULL,
    [ResolverType] [nvarchar](100) NOT NULL,
    [Target] [nvarchar](MAX) NOT NULL,
    [Description] [nvarchar](255) NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__Resolvers__Creat__18C19800] DEFAULT (getdate()) NULL,
    [UpdatedAt] [datetime] NULL
);
END
GO

IF OBJECT_ID(N'dbo.ResolverTypes', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[ResolverTypes] (
    [ResolverType] [nvarchar](100) NOT NULL,
    [Description] [nvarchar](255) NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__ResolverT__Creat__13FCE2E3] DEFAULT (getdate()) NULL
);
END
GO

IF OBJECT_ID(N'dbo.SettingKeys', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[SettingKeys] (
    [SettingKeyID] [uniqueidentifier] CONSTRAINT [DF__SettingKe__Setti__294D0584] DEFAULT (newid()) NOT NULL,
    [KeyName] [nvarchar](100) NOT NULL,
    [Label] [nvarchar](255) NULL,
    [ValueType] [nvarchar](50) NOT NULL,
    [DomainID] [uniqueidentifier] NULL
);
END
GO

IF OBJECT_ID(N'dbo.SkyLynxConfig_PackagedManifest', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[SkyLynxConfig_PackagedManifest] (
    [ManifestID] [uniqueidentifier] CONSTRAINT [DF__SkyLynxCo__Manif__1C5D1EBA] DEFAULT (newid()) NOT NULL,
    [PackagedModuleID] [uniqueidentifier] NOT NULL,
    [TemplateVersionID] [uniqueidentifier] NOT NULL,
    [ResolverID] [uniqueidentifier] NULL,
    [Notes] [nvarchar](255) NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__SkyLynxCo__Creat__1D5142F3] DEFAULT (getdate()) NOT NULL
);
END
GO

IF OBJECT_ID(N'dbo.SkyLynxConfig_PackagedModules', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[SkyLynxConfig_PackagedModules] (
    [PackagedModuleID] [uniqueidentifier] CONSTRAINT [DF__SkyLynxCo__Packa__0A3E6E7F] DEFAULT (newid()) NOT NULL,
    [PortalName] [nvarchar](100) NOT NULL,
    [ModuleName] [nvarchar](50) NOT NULL,
    [TemplateName] [nvarchar](100) NOT NULL,
    [TemplateVersionID] [uniqueidentifier] NOT NULL,
    [InstalledAt] [datetime] CONSTRAINT [DF__SkyLynxCo__Insta__0B3292B8] DEFAULT (getdate()) NULL,
    [InstalledBy] [nvarchar](100) NULL,
    [Notes] [nvarchar](255) NULL
);
END
GO

IF OBJECT_ID(N'dbo.StateProvinces', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[StateProvinces] (
    [StateProvinceID] [uniqueidentifier] CONSTRAINT [DF__StateProv__State__178D7CA5] DEFAULT (newid()) NOT NULL,
    [StateName] [nvarchar](100) NOT NULL,
    [StateAbbreviation] [nvarchar](2) NOT NULL
);
END
GO

IF OBJECT_ID(N'dbo.StyledTypes', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[StyledTypes] (
    [StyledID] [uniqueidentifier] CONSTRAINT [DF__Component__Compo__321755AF] DEFAULT (newid()) NOT NULL,
    [StyledName] [nvarchar](255) NOT NULL,
    [StyledPath] [nvarchar](255) NOT NULL,
    [Description] [nvarchar](255) NOT NULL
);
END
GO

IF OBJECT_ID(N'dbo.SubscriptionPlans', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[SubscriptionPlans] (
    [SubscriptionID] [uniqueidentifier] CONSTRAINT [DF__Subscript__Subsc__5F7E2DAC] DEFAULT (newid()) NOT NULL,
    [UserID] [nvarchar](128) NOT NULL,
    [PlanName] [nvarchar](100) NOT NULL,
    [Price] [decimal](18,2) NOT NULL,
    [BillingCycle] [nvarchar](50) NOT NULL,
    [Status] [nvarchar](50) NOT NULL,
    [StartDate] [datetime] CONSTRAINT [DF__Subscript__Start__625A9A57] DEFAULT (getdate()) NULL,
    [EndDate] [datetime] NULL,
    [SubscriptionPlanID] [uniqueidentifier] CONSTRAINT [DF__Subscript__Subsc__5E54FF49] DEFAULT (newid()) NOT NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__Subscript__Creat__5F492382] DEFAULT (getdate()) NULL
);
END
GO

IF OBJECT_ID(N'dbo.SystemFileTypes', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[SystemFileTypes] (
    [FileType] [nvarchar](10) NOT NULL,
    [Description] [nvarchar](100) NULL,
    [MimeType] [nvarchar](100) NULL,
    [IsTextBased] [bit] NULL
);
END
GO

IF OBJECT_ID(N'dbo.SystemLogs', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[SystemLogs] (
    [LogID] [uniqueidentifier] CONSTRAINT [DF__SystemLog__LogID__00DF2177] DEFAULT (newid()) NOT NULL,
    [LogType] [nvarchar](50) NOT NULL,
    [LogMessage] [nvarchar](MAX) NOT NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__SystemLog__Creat__02C769E9] DEFAULT (getdate()) NULL
);
END
GO

IF OBJECT_ID(N'dbo.SystemValueTypes', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[SystemValueTypes] (
    [ValueType] [nvarchar](50) NOT NULL,
    [Description] [nvarchar](255) NULL,
    [IsStructured] [bit] CONSTRAINT [DF__SystemVal__IsStr__24885067] DEFAULT ((0)) NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__SystemVal__Creat__257C74A0] DEFAULT (getdate()) NULL
);
END
GO

IF OBJECT_ID(N'dbo.ThemeDefinitions', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[ThemeDefinitions] (
    [ThemeDefinitionID] [uniqueidentifier] CONSTRAINT [DF__ThemeDefi__Theme__5689C04F] DEFAULT (newid()) NOT NULL,
    [ThemeName] [nvarchar](100) NOT NULL,
    [DisplayName] [nvarchar](255) NULL,
    [ThemeOption] [nvarchar](100) NULL,
    [IsBase] [bit] CONSTRAINT [DF__ThemeDefi__IsDar__577DE488] DEFAULT ((0)) NULL,
    [Description] [nvarchar](255) NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__ThemeDefi__Creat__587208C1] DEFAULT (getdate()) NULL,
    [componentName] [nvarchar](255) NULL,
    [componentPath] [nvarchar](255) NULL,
    [ComponentConfig] [nvarchar](MAX) NULL,
    [DefaultMode] [nvarchar](10) NULL
);
END
GO

IF OBJECT_ID(N'dbo.Transactions', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[Transactions] (
    [TransactionID] [uniqueidentifier] CONSTRAINT [DF__Transacti__Trans__05A3D694] DEFAULT (newid()) NOT NULL,
    [UserID] [nvarchar](128) NOT NULL,
    [Amount] [decimal](18,2) NOT NULL,
    [Currency] [nvarchar](10) CONSTRAINT [DF__Transacti__Curre__0697FACD] DEFAULT ('USD') NOT NULL,
    [PaymentMethodID] [uniqueidentifier] NOT NULL,
    [Status] [nvarchar](50) NOT NULL,
    [TransactionDate] [datetime] CONSTRAINT [DF__Transacti__Trans__0880433F] DEFAULT (getdate()) NULL,
    [TransactionReference] [nvarchar](100) NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__Transacti__Creat__5D60DB10] DEFAULT (getdate()) NULL
);
END
GO

IF OBJECT_ID(N'dbo.UserProfiles', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[UserProfiles] (
    [UserID] [nvarchar](128) NOT NULL,
    [ProviderID] [uniqueidentifier] NOT NULL,
    [PortalID] [uniqueidentifier] NOT NULL,
    [BillingAddressID] [uniqueidentifier] NULL,
    [AddressID] [uniqueidentifier] NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__UserProfi__Creat__35DCF99B] DEFAULT (getdate()) NOT NULL,
    [UpdatedAt] [datetime] CONSTRAINT [DF__UserProfi__Updat__36D11DD4] DEFAULT (getdate()) NULL
);
END
GO

IF OBJECT_ID(N'dbo.UserProviderProfiles', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[UserProviderProfiles] (
    [UserID] [nvarchar](128) NOT NULL,
    [ProviderID] [uniqueidentifier] NOT NULL,
    [FieldID] [uniqueidentifier] NOT NULL,
    [FieldValue] [nvarchar](MAX) NULL
);
END
GO

IF OBJECT_ID(N'Payments.Intent', N'U') IS NULL
BEGIN
CREATE TABLE [Payments].[Intent] (
    [PaymentIntentID] [uniqueidentifier] NOT NULL,
    [ProviderID] [uniqueidentifier] NOT NULL,
    [PortalID] [uniqueidentifier] NOT NULL,
    [UserID] [uniqueidentifier] NOT NULL,
    [Amount] [decimal](18,2) NOT NULL,
    [Currency] [char](3) NOT NULL,
    [Status] [nvarchar](20) NOT NULL,
    [ClientRef] [nvarchar](100) NULL,
    [CreatedAt] [datetime2](3) CONSTRAINT [DF_Payments_Intent_CreatedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    [UpdatedAt] [datetime2](3) CONSTRAINT [DF_Payments_Intent_UpdatedAt] DEFAULT (sysutcdatetime()) NOT NULL
);
END
GO

IF OBJECT_ID(N'Payments.Provider', N'U') IS NULL
BEGIN
CREATE TABLE [Payments].[Provider] (
    [ProviderID] [uniqueidentifier] NOT NULL,
    [Name] [nvarchar](100) NOT NULL,
    [Type] [nvarchar](50) NOT NULL,
    [IsActive] [bit] CONSTRAINT [DF_Payments_Provider_IsActive] DEFAULT ((1)) NOT NULL,
    [IsSandbox] [bit] CONSTRAINT [DF_Payments_Provider_IsSandbox] DEFAULT ((1)) NOT NULL,
    [CreatedAt] [datetime2](3) CONSTRAINT [DF_Payments_Provider_CreatedAt] DEFAULT (sysutcdatetime()) NOT NULL,
    [UpdatedAt] [datetime2](3) CONSTRAINT [DF_Payments_Provider_UpdatedAt] DEFAULT (sysutcdatetime()) NOT NULL
);
END
GO

IF OBJECT_ID(N'Payments.ProviderSecret', N'U') IS NULL
BEGIN
CREATE TABLE [Payments].[ProviderSecret] (
    [ProviderID] [uniqueidentifier] NOT NULL,
    [ApiLoginID_enc] [nvarchar](200) NOT NULL,
    [TransactionKey_enc] [nvarchar](400) NOT NULL,
    [SignatureKeyHex_enc] [nvarchar](400) NOT NULL,
    [Mode] [nvarchar](20) NOT NULL,
    [UpdatedAt] [datetime2](3) CONSTRAINT [DF_Payments_ProviderSecret_UpdatedAt] DEFAULT (sysutcdatetime()) NOT NULL
);
END
GO

IF OBJECT_ID(N'Payments.TargetLink', N'U') IS NULL
BEGIN
CREATE TABLE [Payments].[TargetLink] (
    [PaymentIntentID] [uniqueidentifier] NOT NULL,
    [TargetDomain] [nvarchar](50) NOT NULL,
    [TargetID] [uniqueidentifier] NOT NULL
);
END
GO

IF OBJECT_ID(N'Payments.Txn', N'U') IS NULL
BEGIN
CREATE TABLE [Payments].[Txn] (
    [PaymentTxnID] [uniqueidentifier] NOT NULL,
    [PaymentIntentID] [uniqueidentifier] NOT NULL,
    [TxnType] [nvarchar](20) NOT NULL,
    [GatewayTxnID] [nvarchar](100) NULL,
    [AuthCode] [nvarchar](50) NULL,
    [ResultCode] [nvarchar](50) NULL,
    [RawJson] [nvarchar](MAX) NULL,
    [CreatedAt] [datetime2](3) CONSTRAINT [DF_Payments_Txn_CreatedAt] DEFAULT (sysutcdatetime()) NOT NULL
);
END
GO

IF OBJECT_ID(N'Payments.Webhook', N'U') IS NULL
BEGIN
CREATE TABLE [Payments].[Webhook] (
    [WebhookID] [uniqueidentifier] NOT NULL,
    [EventID] [nvarchar](200) NOT NULL,
    [EventType] [nvarchar](100) NOT NULL,
    [RawJson] [nvarchar](MAX) NOT NULL,
    [ProcessedAt] [datetime2](3) NULL
);
END
GO
