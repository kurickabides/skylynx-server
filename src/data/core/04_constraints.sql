/*
  SkyLynx SQL Export
  Database: skylynxnet_coredb
  Section: Primary key, unique, and check constraints
  Generated: 2026-07-22T22:35:59.602Z
*/
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__DyFormDo__962C58A89EDFE18F')
ALTER TABLE [dbo].[DyFormDomainType] ADD CONSTRAINT [PK__DyFormDo__962C58A89EDFE18F] PRIMARY KEY CLUSTERED ([DomainTypeID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'UQ__DyFormDo__F806513CBA837319')
ALTER TABLE [dbo].[DyFormDomainType] ADD CONSTRAINT [UQ__DyFormDo__F806513CBA837319] UNIQUE CLUSTERED ([DomainTypeName]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__Modules__2B7477876E97D02B')
ALTER TABLE [dbo].[Modules] ADD CONSTRAINT [PK__Modules__2B7477876E97D02B] PRIMARY KEY CLUSTERED ([ModuleID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__Transact__55433A4B0C96FE2C')
ALTER TABLE [dbo].[Transactions] ADD CONSTRAINT [PK__Transact__55433A4B0C96FE2C] PRIMARY KEY CLUSTERED ([TransactionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__DyFormDF__2498D770F483C86B')
ALTER TABLE [dbo].[DyFormDomains] ADD CONSTRAINT [PK__DyFormDF__2498D770F483C86B] PRIMARY KEY CLUSTERED ([DomainID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'UQ__DyFormDF__737584F6CCB5A4EB')
ALTER TABLE [dbo].[DyFormDomains] ADD CONSTRAINT [UQ__DyFormDF__737584F6CCB5A4EB] UNIQUE CLUSTERED ([Name]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__DyFormRu__97F1DB9F48B8D750')
ALTER TABLE [dbo].[DyFormRuleSyntax] ADD CONSTRAINT [PK__DyFormRu__97F1DB9F48B8D750] PRIMARY KEY CLUSTERED ([RuleSyntaxID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'UQ__DyFormRu__F54862C9E4D5F1A6')
ALTER TABLE [dbo].[DyFormRuleSyntax] ADD CONSTRAINT [UQ__DyFormRu__F54862C9E4D5F1A6] UNIQUE CLUSTERED ([SyntaxName]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK_DyFormExpression')
ALTER TABLE [dbo].[DyFormExpression] ADD CONSTRAINT [PK_DyFormExpression] PRIMARY KEY CLUSTERED ([DyFormExpressionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK_PackagedModules')
ALTER TABLE [dbo].[SkyLynxConfig_PackagedModules] ADD CONSTRAINT [PK_PackagedModules] PRIMARY KEY CLUSTERED ([PackagedModuleID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__DyFormDF__7A8DEF2458B339A6')
ALTER TABLE [dbo].[DyFormDomainValues] ADD CONSTRAINT [PK__DyFormDF__7A8DEF2458B339A6] PRIMARY KEY CLUSTERED ([DomainValueID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK_API_Owners')
ALTER TABLE [dbo].[API_Owners] ADD CONSTRAINT [PK_API_Owners] PRIMARY KEY CLUSTERED ([OwnerUUID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK_ProtosTemplate')
ALTER TABLE [dbo].[ProtosTemplate] ADD CONSTRAINT [PK_ProtosTemplate] PRIMARY KEY CLUSTERED ([TemplateID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'UQ_ProtosTemplateName')
ALTER TABLE [dbo].[ProtosTemplate] ADD CONSTRAINT [UQ_ProtosTemplateName] UNIQUE CLUSTERED ([TemplateName]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__Resolver__CCCD4FB5A7CFD2D9')
ALTER TABLE [dbo].[ResolverTypes] ADD CONSTRAINT [PK__Resolver__CCCD4FB5A7CFD2D9] PRIMARY KEY CLUSTERED ([ResolverType]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__StatePro__9122A971B1811FB6')
ALTER TABLE [dbo].[StateProvinces] ADD CONSTRAINT [PK__StatePro__9122A971B1811FB6] PRIMARY KEY CLUSTERED ([StateProvinceID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'UQ__StatePro__272D13836AAE91ED')
ALTER TABLE [dbo].[StateProvinces] ADD CONSTRAINT [UQ__StatePro__272D13836AAE91ED] UNIQUE CLUSTERED ([StateAbbreviation]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'UQ__StatePro__5547631509C9C840')
ALTER TABLE [dbo].[StateProvinces] ADD CONSTRAINT [UQ__StatePro__5547631509C9C840] UNIQUE CLUSTERED ([StateName]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK_DyFormRuleDefinition')
ALTER TABLE [dbo].[DyFormRuleDefinition] ADD CONSTRAINT [PK_DyFormRuleDefinition] PRIMARY KEY CLUSTERED ([RuleDefinitionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'UQ_RuleKey')
ALTER TABLE [dbo].[DyFormRuleDefinition] ADD CONSTRAINT [UQ_RuleKey] UNIQUE CLUSTERED ([RuleKey]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__DyFormFi__74418A825FD4399A')
ALTER TABLE [dbo].[DyFormFieldType] ADD CONSTRAINT [PK__DyFormFi__74418A825FD4399A] PRIMARY KEY CLUSTERED ([FieldTypeID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'UQ__DyFormFi__1FB4D9A1B2AADAC7')
ALTER TABLE [dbo].[DyFormFieldType] ADD CONSTRAINT [UQ__DyFormFi__1FB4D9A1B2AADAC7] UNIQUE CLUSTERED ([FieldTypeName]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__Resolver__8B970423E446D1FA')
ALTER TABLE [dbo].[Resolvers] ADD CONSTRAINT [PK__Resolver__8B970423E446D1FA] PRIMARY KEY CLUSTERED ([ResolverID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK_UserProviderProfiles')
ALTER TABLE [dbo].[UserProviderProfiles] ADD CONSTRAINT [PK_UserProviderProfiles] PRIMARY KEY CLUSTERED ([UserID], [ProviderID], [FieldID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__DyFormRu__ECFDFEE497021540')
ALTER TABLE [dbo].[DyFormRuleType] ADD CONSTRAINT [PK__DyFormRu__ECFDFEE497021540] PRIMARY KEY CLUSTERED ([RuleTypeID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'UQ__DyFormRu__737584F6B6FF2C82')
ALTER TABLE [dbo].[DyFormRuleType] ADD CONSTRAINT [UQ__DyFormRu__737584F6B6FF2C82] UNIQUE CLUSTERED ([Name]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK_DyFormRuleTarget')
ALTER TABLE [dbo].[DyFormRuleTarget] ADD CONSTRAINT [PK_DyFormRuleTarget] PRIMARY KEY CLUSTERED ([RuleTargetID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK_PackagedManifest')
ALTER TABLE [dbo].[SkyLynxConfig_PackagedManifest] ADD CONSTRAINT [PK_PackagedManifest] PRIMARY KEY CLUSTERED ([ManifestID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK_ProtosTemplateVersion')
ALTER TABLE [dbo].[ProtosTemplateVersion] ADD CONSTRAINT [PK_ProtosTemplateVersion] PRIMARY KEY CLUSTERED ([TemplateVersionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__DyFormRe__94953CC7E0BDDAE8')
ALTER TABLE [dbo].[DyFormResolverType] ADD CONSTRAINT [PK__DyFormRe__94953CC7E0BDDAE8] PRIMARY KEY CLUSTERED ([ResolverTypeID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'UQ__DyFormRe__737584F67A195732')
ALTER TABLE [dbo].[DyFormResolverType] ADD CONSTRAINT [UQ__DyFormRe__737584F67A195732] UNIQUE CLUSTERED ([Name]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__DyFormDF__FB05B7BDEE2C1358')
ALTER TABLE [dbo].[DyForm] ADD CONSTRAINT [PK__DyFormDF__FB05B7BDEE2C1358] PRIMARY KEY CLUSTERED ([FormID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'UQ__DyFormDF__81B78A2F579F7987')
ALTER TABLE [dbo].[DyForm] ADD CONSTRAINT [UQ__DyFormDF__81B78A2F579F7987] UNIQUE CLUSTERED ([FormName]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__OwnerTyp__CA4838354617CD09')
ALTER TABLE [dbo].[OwnerTypes] ADD CONSTRAINT [PK__OwnerTyp__CA4838354617CD09] PRIMARY KEY CLUSTERED ([OwnerTypeID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'UQ__OwnerTyp__1F4306164E7F7E59')
ALTER TABLE [dbo].[OwnerTypes] ADD CONSTRAINT [UQ__OwnerTyp__1F4306164E7F7E59] UNIQUE CLUSTERED ([OwnerTypeName]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__SystemVa__A8C5113A3D4C87F6')
ALTER TABLE [dbo].[SystemValueTypes] ADD CONSTRAINT [PK__SystemVa__A8C5113A3D4C87F6] PRIMARY KEY CLUSTERED ([ValueType]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__AspNetUs__3214EC0739722573')
ALTER TABLE [dbo].[AspNetUsers] ADD CONSTRAINT [PK__AspNetUs__3214EC0739722573] PRIMARY KEY CLUSTERED ([Id]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'UQ__AspNetUs__A9D105341967E1DB')
ALTER TABLE [dbo].[AspNetUsers] ADD CONSTRAINT [UQ__AspNetUs__A9D105341967E1DB] UNIQUE CLUSTERED ([Email]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'UQ__AspNetUs__C9F28456C157D863')
ALTER TABLE [dbo].[AspNetUsers] ADD CONSTRAINT [UQ__AspNetUs__C9F28456C157D863] UNIQUE CLUSTERED ([UserName]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__UserPortals')
ALTER TABLE [dbo].[PortalOwners] ADD CONSTRAINT [PK__UserPortals] PRIMARY KEY CLUSTERED ([UserID], [PortalID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__DyFormDF__80EF08923D73B9EA')
ALTER TABLE [dbo].[DyFormSection] ADD CONSTRAINT [PK__DyFormDF__80EF08923D73B9EA] PRIMARY KEY CLUSTERED ([SectionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__API_KEYS__2F134312F1B372F1')
ALTER TABLE [dbo].[API_KEYS] ADD CONSTRAINT [PK__API_KEYS__2F134312F1B372F1] PRIMARY KEY CLUSTERED ([ApiKeyID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__SettingK__F45F9B1A414603A1')
ALTER TABLE [dbo].[SettingKeys] ADD CONSTRAINT [PK__SettingK__F45F9B1A414603A1] PRIMARY KEY CLUSTERED ([SettingKeyID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'UQ__SettingK__F0A2A337A7A1FB55')
ALTER TABLE [dbo].[SettingKeys] ADD CONSTRAINT [UQ__SettingK__F0A2A337A7A1FB55] UNIQUE CLUSTERED ([KeyName]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK_ProtosTemplateLineage')
ALTER TABLE [dbo].[ProtosTemplateLineage] ADD CONSTRAINT [PK_ProtosTemplateLineage] PRIMARY KEY CLUSTERED ([LineageID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK_PortalRoles')
ALTER TABLE [dbo].[PortalRoles] ADD CONSTRAINT [PK_PortalRoles] PRIMARY KEY CLUSTERED ([PortalID], [RoleID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__AspNetRo__3214EC07A92A024D')
ALTER TABLE [dbo].[AspNetRoles] ADD CONSTRAINT [PK__AspNetRo__3214EC07A92A024D] PRIMARY KEY CLUSTERED ([Id]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'UQ__AspNetRo__737584F64F0D07FB')
ALTER TABLE [dbo].[AspNetRoles] ADD CONSTRAINT [UQ__AspNetRo__737584F64F0D07FB] UNIQUE CLUSTERED ([Name]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'GlobalPortalSettings_PK')
ALTER TABLE [dbo].[GlobalPortalSettings] ADD CONSTRAINT [GlobalPortalSettings_PK] PRIMARY KEY CLUSTERED ([SettingKeyID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__AspNetUs__AF2760ADB53597C0')
ALTER TABLE [dbo].[AspNetUserRoles] ADD CONSTRAINT [PK__AspNetUs__AF2760ADB53597C0] PRIMARY KEY CLUSTERED ([UserId], [RoleId]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK_PortalProfileProviders')
ALTER TABLE [dbo].[PortalProfileProviders] ADD CONSTRAINT [PK_PortalProfileProviders] PRIMARY KEY CLUSTERED ([PortalID], [ProviderID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK_DefaultUserRoles')
ALTER TABLE [dbo].[DefaultUserRoles] ADD CONSTRAINT [PK_DefaultUserRoles] PRIMARY KEY CLUSTERED ([PortalID], [RoleID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__ComponentT__74418A825FD4399A')
ALTER TABLE [dbo].[StyledTypes] ADD CONSTRAINT [PK__ComponentT__74418A825FD4399A] PRIMARY KEY CLUSTERED ([StyledID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__AspNetUs__3214EC0757A34252')
ALTER TABLE [dbo].[AspNetUserClaims] ADD CONSTRAINT [PK__AspNetUs__3214EC0757A34252] PRIMARY KEY CLUSTERED ([Id]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK_ProtosTemplateLink')
ALTER TABLE [dbo].[ProtosTemplateLink] ADD CONSTRAINT [PK_ProtosTemplateLink] PRIMARY KEY CLUSTERED ([TemplateLinkID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__PortalMo__EE57A35691645435')
ALTER TABLE [dbo].[PortalPageModules] ADD CONSTRAINT [PK__PortalMo__EE57A35691645435] PRIMARY KEY CLUSTERED ([PortalPageModuleID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__DyFormDF__C8B6FF2714CA2BE0')
ALTER TABLE [dbo].[DyFormField] ADD CONSTRAINT [PK__DyFormDF__C8B6FF2714CA2BE0] PRIMARY KEY CLUSTERED ([DyFormFieldID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK_UserProfiles')
ALTER TABLE [dbo].[UserProfiles] ADD CONSTRAINT [PK_UserProfiles] PRIMARY KEY CLUSTERED ([UserID], [ProviderID], [PortalID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__AspNetUs__663BD39ED50FA159')
ALTER TABLE [dbo].[AspNetUserLogins] ADD CONSTRAINT [PK__AspNetUs__663BD39ED50FA159] PRIMARY KEY CLUSTERED ([LoginProvider], [ProviderKey], [UserId]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__AspNetUs__8CC498419715C77C')
ALTER TABLE [dbo].[AspNetUserTokens] ADD CONSTRAINT [PK__AspNetUs__8CC498419715C77C] PRIMARY KEY CLUSTERED ([UserId], [LoginProvider], [Name]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__Address__28C3792E01669536')
ALTER TABLE [dbo].[Address] ADD CONSTRAINT [PK__Address__28C3792E01669536] PRIMARY KEY CLUSTERED ([addyId]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__Portals__B87D58339CAC2063')
ALTER TABLE [dbo].[Portals] ADD CONSTRAINT [PK__Portals__B87D58339CAC2063] PRIMARY KEY CLUSTERED ([PortalID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'UQ__Portals__D7EC7AFAEE507250')
ALTER TABLE [dbo].[Portals] ADD CONSTRAINT [UQ__Portals__D7EC7AFAEE507250] UNIQUE CLUSTERED ([PortalName]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__DyFormDF__110458C28796AF3F')
ALTER TABLE [dbo].[DyFormFieldRule] ADD CONSTRAINT [PK__DyFormDF__110458C28796AF3F] PRIMARY KEY CLUSTERED ([RuleID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK_ProtosTemplateStatus')
ALTER TABLE [dbo].[ProtosTemplateStatus] ADD CONSTRAINT [PK_ProtosTemplateStatus] PRIMARY KEY CLUSTERED ([TemplateStatusID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'UQ_ProtosTemplateStatusName')
ALTER TABLE [dbo].[ProtosTemplateStatus] ADD CONSTRAINT [UQ_ProtosTemplateStatusName] UNIQUE CLUSTERED ([StatusName]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK_DyFormFieldSectionDefinition')
ALTER TABLE [dbo].[DyFormDataSourceDefinition] ADD CONSTRAINT [PK_DyFormFieldSectionDefinition] PRIMARY KEY CLUSTERED ([DyFormDSDefinitionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__ProfileP__B54C689D2B0F43B6')
ALTER TABLE [dbo].[ProfileProviders] ADD CONSTRAINT [PK__ProfileP__B54C689D2B0F43B6] PRIMARY KEY CLUSTERED ([ProviderID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'UQ__ProfileP__7D057CE5BD2AE21A')
ALTER TABLE [dbo].[ProfileProviders] ADD CONSTRAINT [UQ__ProfileP__7D057CE5BD2AE21A] UNIQUE CLUSTERED ([ProviderName]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__Layouts__203586F524547931')
ALTER TABLE [dbo].[Layouts] ADD CONSTRAINT [PK__Layouts__203586F524547931] PRIMARY KEY CLUSTERED ([LayoutID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__Customer__B54C689DF4CE1472')
ALTER TABLE [dbo].[CustomerProfile_Providers] ADD CONSTRAINT [PK__Customer__B54C689DF4CE1472] PRIMARY KEY CLUSTERED ([ProviderID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__DyFormVi__31CE8BA7807F0980')
ALTER TABLE [dbo].[DyFormViewModelDefinition] ADD CONSTRAINT [PK__DyFormVi__31CE8BA7807F0980] PRIMARY KEY CLUSTERED ([ViewModelDefinitionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK_ProtosViewModelDefinition')
ALTER TABLE [dbo].[ProtosViewModelDefinition] ADD CONSTRAINT [PK_ProtosViewModelDefinition] PRIMARY KEY CLUSTERED ([ViewModelDefinitionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK_GlobalModuleSettings')
ALTER TABLE [dbo].[GlobalModuleSettings] ADD CONSTRAINT [PK_GlobalModuleSettings] PRIMARY KEY CLUSTERED ([ModuleID], [SettingKeyID], [RoleID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK_ProtosTargetType')
ALTER TABLE [dbo].[ProtosTargetType] ADD CONSTRAINT [PK_ProtosTargetType] PRIMARY KEY CLUSTERED ([TargetTypeID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'UQ_ProtosTargetTypeName')
ALTER TABLE [dbo].[ProtosTargetType] ADD CONSTRAINT [UQ_ProtosTargetTypeName] UNIQUE CLUSTERED ([TargetTypeName]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__Provider__C8B6FF278AA5F13D')
ALTER TABLE [dbo].[ProviderProfileFields] ADD CONSTRAINT [PK__Provider__C8B6FF278AA5F13D] PRIMARY KEY CLUSTERED ([FieldID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__BankAcco__4FC8E7419BC6FAF3')
ALTER TABLE [dbo].[BankAccounts] ADD CONSTRAINT [PK__BankAcco__4FC8E7419BC6FAF3] PRIMARY KEY CLUSTERED ([BankAccountID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK_Payments_Provider')
ALTER TABLE [Payments].[Provider] ADD CONSTRAINT [PK_Payments_Provider] PRIMARY KEY CLUSTERED ([ProviderID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK_PortalSettings')
ALTER TABLE [dbo].[PortalSettings] ADD CONSTRAINT [PK_PortalSettings] PRIMARY KEY CLUSTERED ([PortalID], [SettingKeyID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__LayoutTy__A488933DA436BE2B')
ALTER TABLE [dbo].[LayoutTypes] ADD CONSTRAINT [PK__LayoutTy__A488933DA436BE2B] PRIMARY KEY CLUSTERED ([LayoutTypeID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'UQ__LayoutTy__30D021EC1490FDAD')
ALTER TABLE [dbo].[LayoutTypes] ADD CONSTRAINT [UQ__LayoutTy__30D021EC1490FDAD] UNIQUE CLUSTERED ([LayoutTypeName]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__DyFormSe__5386849853847E06')
ALTER TABLE [dbo].[DyFormFieldSectionDefinition] ADD CONSTRAINT [PK__DyFormSe__5386849853847E06] PRIMARY KEY CLUSTERED ([SectionDefinitionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'UQ_SectionDefinition')
ALTER TABLE [dbo].[DyFormFieldSectionDefinition] ADD CONSTRAINT [UQ_SectionDefinition] UNIQUE CLUSTERED ([SectionID], [DyFormFieldID], [ViewModelDefinitionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK_Payments_Webhook')
ALTER TABLE [Payments].[Webhook] ADD CONSTRAINT [PK_Payments_Webhook] PRIMARY KEY CLUSTERED ([WebhookID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__ThemeDef__9AB80435DB5E9253')
ALTER TABLE [dbo].[ThemeDefinitions] ADD CONSTRAINT [PK__ThemeDef__9AB80435DB5E9253] PRIMARY KEY CLUSTERED ([ThemeDefinitionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__ProtosDa__E6D7469D21BC5DB9')
ALTER TABLE [dbo].[ProtosDataModelDefinition] ADD CONSTRAINT [PK__ProtosDa__E6D7469D21BC5DB9] PRIMARY KEY CLUSTERED ([DataModelID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'UQ__ProtosDa__EA848152ED0457D8')
ALTER TABLE [dbo].[ProtosDataModelDefinition] ADD CONSTRAINT [UQ__ProtosDa__EA848152ED0457D8] UNIQUE CLUSTERED ([DataModelName]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK_Payments_Intent')
ALTER TABLE [Payments].[Intent] ADD CONSTRAINT [PK_Payments_Intent] PRIMARY KEY CLUSTERED ([PaymentIntentID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__PaymentM__DC31C1F36B3399A0')
ALTER TABLE [dbo].[PaymentMethods] ADD CONSTRAINT [PK__PaymentM__DC31C1F36B3399A0] PRIMARY KEY CLUSTERED ([PaymentMethodID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__Provider__74418A8222DD7CE5')
ALTER TABLE [dbo].[ProviderProfileFieldType] ADD CONSTRAINT [PK__Provider__74418A8222DD7CE5] PRIMARY KEY CLUSTERED ([FieldTypeID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK_ModuleSettings')
ALTER TABLE [dbo].[ModuleSettings] ADD CONSTRAINT [PK_ModuleSettings] PRIMARY KEY CLUSTERED ([PortalPageModuleID], [SettingKeyID], [RoleID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK_Payments_ProviderSecret')
ALTER TABLE [Payments].[ProviderSecret] ADD CONSTRAINT [PK_Payments_ProviderSecret] PRIMARY KEY CLUSTERED ([ProviderID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK_DyFormViewModelLineage')
ALTER TABLE [dbo].[DyFormViewModelLineage] ADD CONSTRAINT [PK_DyFormViewModelLineage] PRIMARY KEY CLUSTERED ([ViewModelDefinitionID], [ChildViewModelDefinitionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__Subscrip__9A2B24BD28A9A258')
ALTER TABLE [dbo].[SubscriptionPlans] ADD CONSTRAINT [PK__Subscrip__9A2B24BD28A9A258] PRIMARY KEY CLUSTERED ([SubscriptionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK_Payments_TargetLink')
ALTER TABLE [Payments].[TargetLink] ADD CONSTRAINT [PK_Payments_TargetLink] PRIMARY KEY CLUSTERED ([PaymentIntentID], [TargetDomain], [TargetID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK_Payments_Txn')
ALTER TABLE [Payments].[Txn] ADD CONSTRAINT [PK_Payments_Txn] PRIMARY KEY CLUSTERED ([PaymentTxnID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__DyFormRe__CD859DCA2C2CC700')
ALTER TABLE [dbo].[DyFormResolverContext] ADD CONSTRAINT [PK__DyFormRe__CD859DCA2C2CC700] PRIMARY KEY CLUSTERED ([Context]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'ProtosTemplateTree_PK')
ALTER TABLE [dbo].[ProtosTemplateTree] ADD CONSTRAINT [ProtosTemplateTree_PK] PRIMARY KEY CLUSTERED ([ParentVersionID], [ChildVersionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__DyFormSe__3887B22A5C0E1A88')
ALTER TABLE [dbo].[DyFormSections] ADD CONSTRAINT [PK__DyFormSe__3887B22A5C0E1A88] PRIMARY KEY CLUSTERED ([FormSectionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'UQ_DyForm_FormID_SectionID')
ALTER TABLE [dbo].[DyFormSections] ADD CONSTRAINT [UQ_DyForm_FormID_SectionID] UNIQUE CLUSTERED ([FormID], [SectionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK_DyFormSectionResolvers')
ALTER TABLE [dbo].[DyFormSectionResolvers] ADD CONSTRAINT [PK_DyFormSectionResolvers] PRIMARY KEY CLUSTERED ([DyFormID], [SectionID], [ResolverContext]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__SystemFi__1A3CE5A5A4D058DF')
ALTER TABLE [dbo].[SystemFileTypes] ADD CONSTRAINT [PK__SystemFi__1A3CE5A5A4D058DF] PRIMARY KEY CLUSTERED ([FileType]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__ISO6391___8B8C8A350942FA0C')
ALTER TABLE [dbo].[ISO6391_Languages] ADD CONSTRAINT [PK__ISO6391___8B8C8A350942FA0C] PRIMARY KEY CLUSTERED ([LanguageCode]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK_PageDefinition')
ALTER TABLE [dbo].[PageDefinition] ADD CONSTRAINT [PK_PageDefinition] PRIMARY KEY CLUSTERED ([PageID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.key_constraints WHERE name=N'PK__SystemLo__5E5499A8FACF969A')
ALTER TABLE [dbo].[SystemLogs] ADD CONSTRAINT [PK__SystemLo__5E5499A8FACF969A] PRIMARY KEY CLUSTERED ([LogID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name=N'CK__CustomerP__Provi__498EEC8D')
ALTER TABLE [dbo].[CustomerProfile_Providers] ADD CONSTRAINT [CK__CustomerP__Provi__498EEC8D] CHECK ([ProviderType]='Payment' OR [ProviderType]='OAuth');
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name=N'CK__CustomerP__Provi__4A8310C6')
ALTER TABLE [dbo].[CustomerProfile_Providers] ADD CONSTRAINT [CK__CustomerP__Provi__4A8310C6] CHECK ([ProviderName]='PayPal' OR [ProviderName]='AzureAD' OR [ProviderName]='Facebook' OR [ProviderName]='Stripe' OR [ProviderName]='Authorize.Net' OR [ProviderName]='Google');
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name=N'CK__PaymentMet__Type__5AB9788F')
ALTER TABLE [dbo].[PaymentMethods] ADD CONSTRAINT [CK__PaymentMet__Type__5AB9788F] CHECK ([Type]='BankAccount' OR [Type]='CreditCard');
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name=N'CK__Subscript__Billi__607251E5')
ALTER TABLE [dbo].[SubscriptionPlans] ADD CONSTRAINT [CK__Subscript__Billi__607251E5] CHECK ([BillingCycle]='Yearly' OR [BillingCycle]='Monthly');
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name=N'CK__Subscript__Statu__6166761E')
ALTER TABLE [dbo].[SubscriptionPlans] ADD CONSTRAINT [CK__Subscript__Statu__6166761E] CHECK ([Status]='Cancelled' OR [Status]='Active');
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name=N'CK__SystemLog__LogTy__01D345B0')
ALTER TABLE [dbo].[SystemLogs] ADD CONSTRAINT [CK__SystemLog__LogTy__01D345B0] CHECK ([LogType]='Info' OR [LogType]='Warning' OR [LogType]='Error');
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name=N'CK__Transacti__Statu__078C1F06')
ALTER TABLE [dbo].[Transactions] ADD CONSTRAINT [CK__Transacti__Statu__078C1F06] CHECK ([Status]='Refunded' OR [Status]='Failed' OR [Status]='Completed' OR [Status]='Pending');
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name=N'CK_Payments_Intent_Currency')
ALTER TABLE [Payments].[Intent] ADD CONSTRAINT [CK_Payments_Intent_Currency] CHECK (len(ltrim(rtrim([Currency])))=(3));
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name=N'CK_Payments_Intent_Status')
ALTER TABLE [Payments].[Intent] ADD CONSTRAINT [CK_Payments_Intent_Status] CHECK ([Status]=N'Refunded' OR [Status]=N'Voided' OR [Status]=N'Failed' OR [Status]=N'Captured' OR [Status]=N'Authorized' OR [Status]=N'Pending');
GO

IF NOT EXISTS (SELECT 1 FROM sys.check_constraints WHERE name=N'CK_Payments_ProviderSecret_Mode')
ALTER TABLE [Payments].[ProviderSecret] ADD CONSTRAINT [CK_Payments_ProviderSecret_Mode] CHECK ([Mode]=N'production' OR [Mode]=N'sandbox');
GO
