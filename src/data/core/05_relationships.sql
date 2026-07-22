/*
  SkyLynx SQL Export
  Database: skylynxnet_coredb
  Section: Foreign key relationships
  Generated: 2026-07-22T22:35:59.603Z
*/
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_Address_StateProvinces')
ALTER TABLE [dbo].[Address] ADD CONSTRAINT [FK_Address_StateProvinces] FOREIGN KEY ([StateProvinceID]) REFERENCES [dbo].[StateProvinces] ([StateProvinceID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_API_KEYS_Owners')
ALTER TABLE [dbo].[API_KEYS] ADD CONSTRAINT [FK_API_KEYS_Owners] FOREIGN KEY ([OwnerUUID]) REFERENCES [dbo].[API_Owners] ([OwnerUUID]) ON DELETE CASCADE;
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'API_Owners_OwnerTypes_FK')
ALTER TABLE [dbo].[API_Owners] ADD CONSTRAINT [API_Owners_OwnerTypes_FK] FOREIGN KEY ([OwnerTypeID]) REFERENCES [dbo].[OwnerTypes] ([OwnerTypeID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_API_Owners_Portals')
ALTER TABLE [dbo].[API_Owners] ADD CONSTRAINT [FK_API_Owners_Portals] FOREIGN KEY ([PortalID]) REFERENCES [dbo].[Portals] ([PortalID]) ON DELETE CASCADE;
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_API_Owners_Users')
ALTER TABLE [dbo].[API_Owners] ADD CONSTRAINT [FK_API_Owners_Users] FOREIGN KEY ([UserID]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE;
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK__AspNetUse__UserI__33D4B598')
ALTER TABLE [dbo].[AspNetUserClaims] ADD CONSTRAINT [FK__AspNetUse__UserI__33D4B598] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE;
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK__AspNetUse__UserI__36B12243')
ALTER TABLE [dbo].[AspNetUserLogins] ADD CONSTRAINT [FK__AspNetUse__UserI__36B12243] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE;
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK__AspNetUse__RoleI__30F848ED')
ALTER TABLE [dbo].[AspNetUserRoles] ADD CONSTRAINT [FK__AspNetUse__RoleI__30F848ED] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[AspNetRoles] ([Id]) ON DELETE CASCADE;
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK__AspNetUse__UserI__300424B4')
ALTER TABLE [dbo].[AspNetUserRoles] ADD CONSTRAINT [FK__AspNetUse__UserI__300424B4] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE;
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK__AspNetUse__UserI__398D8EEE')
ALTER TABLE [dbo].[AspNetUserTokens] ADD CONSTRAINT [FK__AspNetUse__UserI__398D8EEE] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE;
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK__BankAccou__UserI__5165187F')
ALTER TABLE [dbo].[BankAccounts] ADD CONSTRAINT [FK__BankAccou__UserI__5165187F] FOREIGN KEY ([UserID]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE;
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK__CustomerP__UserI__4C6B5938')
ALTER TABLE [dbo].[CustomerProfile_Providers] ADD CONSTRAINT [FK__CustomerP__UserI__4C6B5938] FOREIGN KEY ([UserID]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE;
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_DefaultUserRoles_PortalRoles')
ALTER TABLE [dbo].[DefaultUserRoles] ADD CONSTRAINT [FK_DefaultUserRoles_PortalRoles] FOREIGN KEY ([PortalID], [RoleID]) REFERENCES [dbo].[PortalRoles] ([PortalID], [RoleID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK__DyFormDFo__Domai__086B34A6')
ALTER TABLE [dbo].[DyFormDomains] ADD CONSTRAINT [FK__DyFormDFo__Domai__086B34A6] FOREIGN KEY ([DomainTypeID]) REFERENCES [dbo].[DyFormDomainType] ([DomainTypeID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK__DyFormDFo__Domai__0D2FE9C3')
ALTER TABLE [dbo].[DyFormDomainValues] ADD CONSTRAINT [FK__DyFormDFo__Domai__0D2FE9C3] FOREIGN KEY ([DomainID]) REFERENCES [dbo].[DyFormDomains] ([DomainID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_DyFormExpression_ResolverType')
ALTER TABLE [dbo].[DyFormExpression] ADD CONSTRAINT [FK_DyFormExpression_ResolverType] FOREIGN KEY ([ResolverTypeID]) REFERENCES [dbo].[DyFormResolverType] ([ResolverTypeID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_DyFormField_DomainID')
ALTER TABLE [dbo].[DyFormField] ADD CONSTRAINT [FK_DyFormField_DomainID] FOREIGN KEY ([DomainID]) REFERENCES [dbo].[DyFormDomains] ([DomainID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_DyFormField_FieldTypeID')
ALTER TABLE [dbo].[DyFormField] ADD CONSTRAINT [FK_DyFormField_FieldTypeID] FOREIGN KEY ([FieldTypeID]) REFERENCES [dbo].[DyFormFieldType] ([FieldTypeID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK__DyFormDFo__Resol__45A94D10')
ALTER TABLE [dbo].[DyFormFieldRule] ADD CONSTRAINT [FK__DyFormDFo__Resol__45A94D10] FOREIGN KEY ([ResolverTypeID]) REFERENCES [dbo].[DyFormResolverType] ([ResolverTypeID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK__DyFormDFo__RuleT__44B528D7')
ALTER TABLE [dbo].[DyFormFieldRule] ADD CONSTRAINT [FK__DyFormDFo__RuleT__44B528D7] FOREIGN KEY ([RuleTypeID]) REFERENCES [dbo].[DyFormRuleType] ([RuleTypeID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'DyFormFieldSectionDefinition_DyFormDataSourceDefinition_FK')
ALTER TABLE [dbo].[DyFormFieldSectionDefinition] ADD CONSTRAINT [DyFormFieldSectionDefinition_DyFormDataSourceDefinition_FK] FOREIGN KEY ([DyFormDSDefinitionID]) REFERENCES [dbo].[DyFormDataSourceDefinition] ([DyFormDSDefinitionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'DyFormFieldSectionDefinition_DyFormField_FK')
ALTER TABLE [dbo].[DyFormFieldSectionDefinition] ADD CONSTRAINT [DyFormFieldSectionDefinition_DyFormField_FK] FOREIGN KEY ([DyFormFieldID]) REFERENCES [dbo].[DyFormField] ([DyFormFieldID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_SecDef_Section')
ALTER TABLE [dbo].[DyFormFieldSectionDefinition] ADD CONSTRAINT [FK_SecDef_Section] FOREIGN KEY ([SectionID]) REFERENCES [dbo].[DyFormSection] ([SectionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_SecDef_ViewModel')
ALTER TABLE [dbo].[DyFormFieldSectionDefinition] ADD CONSTRAINT [FK_SecDef_ViewModel] FOREIGN KEY ([ViewModelDefinitionID]) REFERENCES [dbo].[DyFormViewModelDefinition] ([ViewModelDefinitionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_RuleDef_Expression')
ALTER TABLE [dbo].[DyFormRuleDefinition] ADD CONSTRAINT [FK_RuleDef_Expression] FOREIGN KEY ([DyFormExpressionID]) REFERENCES [dbo].[DyFormExpression] ([DyFormExpressionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_RuleDef_ResolverType')
ALTER TABLE [dbo].[DyFormRuleDefinition] ADD CONSTRAINT [FK_RuleDef_ResolverType] FOREIGN KEY ([ResolverTypeID]) REFERENCES [dbo].[DyFormResolverType] ([ResolverTypeID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_RuleTarget_Definition')
ALTER TABLE [dbo].[DyFormRuleTarget] ADD CONSTRAINT [FK_RuleTarget_Definition] FOREIGN KEY ([RuleDefinitionID]) REFERENCES [dbo].[DyFormRuleDefinition] ([RuleDefinitionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_RuleTarget_Field')
ALTER TABLE [dbo].[DyFormRuleTarget] ADD CONSTRAINT [FK_RuleTarget_Field] FOREIGN KEY ([DyFormFieldID]) REFERENCES [dbo].[DyFormField] ([DyFormFieldID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_RuleTarget_Section')
ALTER TABLE [dbo].[DyFormRuleTarget] ADD CONSTRAINT [FK_RuleTarget_Section] FOREIGN KEY ([SectionID]) REFERENCES [dbo].[DyFormSection] ([SectionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_RuleTarget_ViewModel')
ALTER TABLE [dbo].[DyFormRuleTarget] ADD CONSTRAINT [FK_RuleTarget_ViewModel] FOREIGN KEY ([ViewModelDefinitionID]) REFERENCES [dbo].[DyFormViewModelDefinition] ([ViewModelDefinitionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_SectionResolver_Context')
ALTER TABLE [dbo].[DyFormSectionResolvers] ADD CONSTRAINT [FK_SectionResolver_Context] FOREIGN KEY ([ResolverContext]) REFERENCES [dbo].[DyFormResolverContext] ([Context]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_SectionResolver_DyForm')
ALTER TABLE [dbo].[DyFormSectionResolvers] ADD CONSTRAINT [FK_SectionResolver_DyForm] FOREIGN KEY ([DyFormID]) REFERENCES [dbo].[DyForm] ([FormID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_SectionResolver_Section')
ALTER TABLE [dbo].[DyFormSectionResolvers] ADD CONSTRAINT [FK_SectionResolver_Section] FOREIGN KEY ([SectionID]) REFERENCES [dbo].[DyFormSection] ([SectionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_SectionResolver_Type')
ALTER TABLE [dbo].[DyFormSectionResolvers] ADD CONSTRAINT [FK_SectionResolver_Type] FOREIGN KEY ([ResolverTypeID]) REFERENCES [dbo].[DyFormResolverType] ([ResolverTypeID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_DyFormSections_Form')
ALTER TABLE [dbo].[DyFormSections] ADD CONSTRAINT [FK_DyFormSections_Form] FOREIGN KEY ([FormID]) REFERENCES [dbo].[DyForm] ([FormID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_DyFormSections_Parent')
ALTER TABLE [dbo].[DyFormSections] ADD CONSTRAINT [FK_DyFormSections_Parent] FOREIGN KEY ([ParentFormSectionID]) REFERENCES [dbo].[DyFormSections] ([FormSectionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_DyFormSections_Section')
ALTER TABLE [dbo].[DyFormSections] ADD CONSTRAINT [FK_DyFormSections_Section] FOREIGN KEY ([SectionID]) REFERENCES [dbo].[DyFormSection] ([SectionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_VM_Child')
ALTER TABLE [dbo].[DyFormViewModelLineage] ADD CONSTRAINT [FK_VM_Child] FOREIGN KEY ([ChildViewModelDefinitionID]) REFERENCES [dbo].[DyFormViewModelDefinition] ([ViewModelDefinitionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_VM_Parent')
ALTER TABLE [dbo].[DyFormViewModelLineage] ADD CONSTRAINT [FK_VM_Parent] FOREIGN KEY ([ViewModelDefinitionID]) REFERENCES [dbo].[DyFormViewModelDefinition] ([ViewModelDefinitionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_GMS_Key')
ALTER TABLE [dbo].[GlobalModuleSettings] ADD CONSTRAINT [FK_GMS_Key] FOREIGN KEY ([SettingKeyID]) REFERENCES [dbo].[SettingKeys] ([SettingKeyID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_GMS_Role')
ALTER TABLE [dbo].[GlobalModuleSettings] ADD CONSTRAINT [FK_GMS_Role] FOREIGN KEY ([RoleID]) REFERENCES [dbo].[AspNetRoles] ([Id]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'GlobalModuleSettings_Modules_FK')
ALTER TABLE [dbo].[GlobalModuleSettings] ADD CONSTRAINT [GlobalModuleSettings_Modules_FK] FOREIGN KEY ([ModuleID]) REFERENCES [dbo].[Modules] ([ModuleID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_GlobalPortalSettings_Key')
ALTER TABLE [dbo].[GlobalPortalSettings] ADD CONSTRAINT [FK_GlobalPortalSettings_Key] FOREIGN KEY ([SettingKeyID]) REFERENCES [dbo].[SettingKeys] ([SettingKeyID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'Layouts_StyledTypes_FK')
ALTER TABLE [dbo].[Layouts] ADD CONSTRAINT [Layouts_StyledTypes_FK] FOREIGN KEY ([StyledID]) REFERENCES [dbo].[StyledTypes] ([StyledID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'Modules_StyledTypes_FK')
ALTER TABLE [dbo].[Modules] ADD CONSTRAINT [Modules_StyledTypes_FK] FOREIGN KEY ([StyledID]) REFERENCES [dbo].[StyledTypes] ([StyledID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_ModuleSettings_Key')
ALTER TABLE [dbo].[ModuleSettings] ADD CONSTRAINT [FK_ModuleSettings_Key] FOREIGN KEY ([SettingKeyID]) REFERENCES [dbo].[SettingKeys] ([SettingKeyID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_ModuleSettings_PortalModule')
ALTER TABLE [dbo].[ModuleSettings] ADD CONSTRAINT [FK_ModuleSettings_PortalModule] FOREIGN KEY ([PortalPageModuleID]) REFERENCES [dbo].[PortalPageModules] ([PortalPageModuleID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_ModuleSettings_Role')
ALTER TABLE [dbo].[ModuleSettings] ADD CONSTRAINT [FK_ModuleSettings_Role] FOREIGN KEY ([RoleID]) REFERENCES [dbo].[AspNetRoles] ([Id]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'PageDefinition_AspNetRoles_FK')
ALTER TABLE [dbo].[PageDefinition] ADD CONSTRAINT [PageDefinition_AspNetRoles_FK] FOREIGN KEY ([RoleID]) REFERENCES [dbo].[AspNetRoles] ([Id]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'PageDefinition_StyledTypes_FK')
ALTER TABLE [dbo].[PageDefinition] ADD CONSTRAINT [PageDefinition_StyledTypes_FK] FOREIGN KEY ([StyledID]) REFERENCES [dbo].[StyledTypes] ([StyledID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK__PaymentMe__UserI__5CA1C101')
ALTER TABLE [dbo].[PaymentMethods] ADD CONSTRAINT [FK__PaymentMe__UserI__5CA1C101] FOREIGN KEY ([UserID]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE;
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'PortalOwners_AspNetUsers_FK')
ALTER TABLE [dbo].[PortalOwners] ADD CONSTRAINT [PortalOwners_AspNetUsers_FK] FOREIGN KEY ([UserID]) REFERENCES [dbo].[AspNetUsers] ([Id]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'PortalOwners_Portals_FK')
ALTER TABLE [dbo].[PortalOwners] ADD CONSTRAINT [PortalOwners_Portals_FK] FOREIGN KEY ([PortalID]) REFERENCES [dbo].[Portals] ([PortalID]) ON DELETE CASCADE ON UPDATE CASCADE;
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_PortalModules_Module')
ALTER TABLE [dbo].[PortalPageModules] ADD CONSTRAINT [FK_PortalModules_Module] FOREIGN KEY ([ModuleID]) REFERENCES [dbo].[Modules] ([ModuleID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_PortalModules_Page')
ALTER TABLE [dbo].[PortalPageModules] ADD CONSTRAINT [FK_PortalModules_Page] FOREIGN KEY ([PageID]) REFERENCES [dbo].[PageDefinition] ([PageID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_PortalModules_Portal')
ALTER TABLE [dbo].[PortalPageModules] ADD CONSTRAINT [FK_PortalModules_Portal] FOREIGN KEY ([PortalID]) REFERENCES [dbo].[Portals] ([PortalID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_PortalProfileProviders_Portals')
ALTER TABLE [dbo].[PortalProfileProviders] ADD CONSTRAINT [FK_PortalProfileProviders_Portals] FOREIGN KEY ([PortalID]) REFERENCES [dbo].[Portals] ([PortalID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_PortalProfileProviders_Providers')
ALTER TABLE [dbo].[PortalProfileProviders] ADD CONSTRAINT [FK_PortalProfileProviders_Providers] FOREIGN KEY ([ProviderID]) REFERENCES [dbo].[ProfileProviders] ([ProviderID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_PortalRoles_Portals')
ALTER TABLE [dbo].[PortalRoles] ADD CONSTRAINT [FK_PortalRoles_Portals] FOREIGN KEY ([PortalID]) REFERENCES [dbo].[Portals] ([PortalID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_PortalRoles_Roles')
ALTER TABLE [dbo].[PortalRoles] ADD CONSTRAINT [FK_PortalRoles_Roles] FOREIGN KEY ([RoleID]) REFERENCES [dbo].[AspNetRoles] ([Id]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_PortalSettings_Key')
ALTER TABLE [dbo].[PortalSettings] ADD CONSTRAINT [FK_PortalSettings_Key] FOREIGN KEY ([SettingKeyID]) REFERENCES [dbo].[SettingKeys] ([SettingKeyID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_PortalSettings_Portal')
ALTER TABLE [dbo].[PortalSettings] ADD CONSTRAINT [FK_PortalSettings_Portal] FOREIGN KEY ([PortalID]) REFERENCES [dbo].[Portals] ([PortalID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_ProtosTemplateLineage_ChildVersion')
ALTER TABLE [dbo].[ProtosTemplateLineage] ADD CONSTRAINT [FK_ProtosTemplateLineage_ChildVersion] FOREIGN KEY ([ChildVersionID]) REFERENCES [dbo].[ProtosTemplateVersion] ([TemplateVersionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_ProtosTemplateLineage_ParentVersion')
ALTER TABLE [dbo].[ProtosTemplateLineage] ADD CONSTRAINT [FK_ProtosTemplateLineage_ParentVersion] FOREIGN KEY ([ParentVersionID]) REFERENCES [dbo].[ProtosTemplateVersion] ([TemplateVersionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_ProtosTemplateLink_ProtosTemplateVersion')
ALTER TABLE [dbo].[ProtosTemplateLink] ADD CONSTRAINT [FK_ProtosTemplateLink_ProtosTemplateVersion] FOREIGN KEY ([TemplateVersionID]) REFERENCES [dbo].[ProtosTemplateVersion] ([TemplateVersionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_ProtosTemplateLink_TargetType')
ALTER TABLE [dbo].[ProtosTemplateLink] ADD CONSTRAINT [FK_ProtosTemplateLink_TargetType] FOREIGN KEY ([TargetTypeID]) REFERENCES [dbo].[ProtosTargetType] ([TargetTypeID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'ProtosTemplateLink_Resolvers_FK')
ALTER TABLE [dbo].[ProtosTemplateLink] ADD CONSTRAINT [ProtosTemplateLink_Resolvers_FK] FOREIGN KEY ([ResolverID]) REFERENCES [dbo].[Resolvers] ([ResolverID]) ON UPDATE CASCADE;
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'ProtosTemplateTree_ProtosTemplateVersion_FK')
ALTER TABLE [dbo].[ProtosTemplateTree] ADD CONSTRAINT [ProtosTemplateTree_ProtosTemplateVersion_FK] FOREIGN KEY ([ParentVersionID]) REFERENCES [dbo].[ProtosTemplateVersion] ([TemplateVersionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'ProtosTemplateTree_ProtosTemplateVersion_FK_1')
ALTER TABLE [dbo].[ProtosTemplateTree] ADD CONSTRAINT [ProtosTemplateTree_ProtosTemplateVersion_FK_1] FOREIGN KEY ([ChildVersionID]) REFERENCES [dbo].[ProtosTemplateVersion] ([TemplateVersionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_ProtosTemplateVersion_ProtosTemplate')
ALTER TABLE [dbo].[ProtosTemplateVersion] ADD CONSTRAINT [FK_ProtosTemplateVersion_ProtosTemplate] FOREIGN KEY ([TemplateID]) REFERENCES [dbo].[ProtosTemplate] ([TemplateID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_ProtosViewModel_TemplateVersion')
ALTER TABLE [dbo].[ProtosViewModelDefinition] ADD CONSTRAINT [FK_ProtosViewModel_TemplateVersion] FOREIGN KEY ([TemplateVersionID]) REFERENCES [dbo].[ProtosTemplateVersion] ([TemplateVersionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'ProtosViewModelDefinition_ProtosTemplateLink_FK')
ALTER TABLE [dbo].[ProtosViewModelDefinition] ADD CONSTRAINT [ProtosViewModelDefinition_ProtosTemplateLink_FK] FOREIGN KEY ([TemplateLinkID]) REFERENCES [dbo].[ProtosTemplateLink] ([TemplateLinkID]) ON DELETE CASCADE ON UPDATE CASCADE;
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK__ProviderP__Provi__4DE98D56')
ALTER TABLE [dbo].[ProviderProfileFields] ADD CONSTRAINT [FK__ProviderP__Provi__4DE98D56] FOREIGN KEY ([ProviderID]) REFERENCES [dbo].[ProfileProviders] ([ProviderID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'ProviderProfileFields_ProviderProfileFieldType_FK')
ALTER TABLE [dbo].[ProviderProfileFields] ADD CONSTRAINT [ProviderProfileFields_ProviderProfileFieldType_FK] FOREIGN KEY ([FieldTypeID]) REFERENCES [dbo].[ProviderProfileFieldType] ([FieldTypeID]) ON DELETE CASCADE ON UPDATE CASCADE;
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_SettingKeys_Domain')
ALTER TABLE [dbo].[SettingKeys] ADD CONSTRAINT [FK_SettingKeys_Domain] FOREIGN KEY ([DomainID]) REFERENCES [dbo].[DyFormDomains] ([DomainID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_SettingKeys_ValueType')
ALTER TABLE [dbo].[SettingKeys] ADD CONSTRAINT [FK_SettingKeys_ValueType] FOREIGN KEY ([ValueType]) REFERENCES [dbo].[SystemValueTypes] ([ValueType]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_PackagedManifest_PackagedModules')
ALTER TABLE [dbo].[SkyLynxConfig_PackagedManifest] ADD CONSTRAINT [FK_PackagedManifest_PackagedModules] FOREIGN KEY ([PackagedModuleID]) REFERENCES [dbo].[SkyLynxConfig_PackagedModules] ([PackagedModuleID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_PackagedManifest_Resolvers')
ALTER TABLE [dbo].[SkyLynxConfig_PackagedManifest] ADD CONSTRAINT [FK_PackagedManifest_Resolvers] FOREIGN KEY ([ResolverID]) REFERENCES [dbo].[Resolvers] ([ResolverID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_PackagedManifest_TemplateVersion')
ALTER TABLE [dbo].[SkyLynxConfig_PackagedManifest] ADD CONSTRAINT [FK_PackagedManifest_TemplateVersion] FOREIGN KEY ([TemplateVersionID]) REFERENCES [dbo].[ProtosTemplateVersion] ([TemplateVersionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_PackagedModules_TemplateVersion')
ALTER TABLE [dbo].[SkyLynxConfig_PackagedModules] ADD CONSTRAINT [FK_PackagedModules_TemplateVersion] FOREIGN KEY ([TemplateVersionID]) REFERENCES [dbo].[ProtosTemplateVersion] ([TemplateVersionID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK__Subscript__UserI__634EBE90')
ALTER TABLE [dbo].[SubscriptionPlans] ADD CONSTRAINT [FK__Subscript__UserI__634EBE90] FOREIGN KEY ([UserID]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE;
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK__Transacti__Payme__0A688BB1')
ALTER TABLE [dbo].[Transactions] ADD CONSTRAINT [FK__Transacti__Payme__0A688BB1] FOREIGN KEY ([PaymentMethodID]) REFERENCES [dbo].[PaymentMethods] ([PaymentMethodID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK__Transacti__UserI__09746778')
ALTER TABLE [dbo].[Transactions] ADD CONSTRAINT [FK__Transacti__UserI__09746778] FOREIGN KEY ([UserID]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE;
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_UserProfiles_Address')
ALTER TABLE [dbo].[UserProfiles] ADD CONSTRAINT [FK_UserProfiles_Address] FOREIGN KEY ([AddressID]) REFERENCES [dbo].[Address] ([addyId]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_UserProfiles_BillingAddress')
ALTER TABLE [dbo].[UserProfiles] ADD CONSTRAINT [FK_UserProfiles_BillingAddress] FOREIGN KEY ([BillingAddressID]) REFERENCES [dbo].[Address] ([addyId]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_UserProfiles_PortalProfileProviders')
ALTER TABLE [dbo].[UserProfiles] ADD CONSTRAINT [FK_UserProfiles_PortalProfileProviders] FOREIGN KEY ([PortalID], [ProviderID]) REFERENCES [dbo].[PortalProfileProviders] ([PortalID], [ProviderID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'UserProfiles_AspNetUsers_FK')
ALTER TABLE [dbo].[UserProfiles] ADD CONSTRAINT [UserProfiles_AspNetUsers_FK] FOREIGN KEY ([UserID]) REFERENCES [dbo].[AspNetUsers] ([Id]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_UserProviderProfiles_Field')
ALTER TABLE [dbo].[UserProviderProfiles] ADD CONSTRAINT [FK_UserProviderProfiles_Field] FOREIGN KEY ([FieldID]) REFERENCES [dbo].[ProviderProfileFields] ([FieldID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_UserProviderProfiles_Provider')
ALTER TABLE [dbo].[UserProviderProfiles] ADD CONSTRAINT [FK_UserProviderProfiles_Provider] FOREIGN KEY ([ProviderID]) REFERENCES [dbo].[ProfileProviders] ([ProviderID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_UserProviderProfiles_User')
ALTER TABLE [dbo].[UserProviderProfiles] ADD CONSTRAINT [FK_UserProviderProfiles_User] FOREIGN KEY ([UserID]) REFERENCES [dbo].[AspNetUsers] ([Id]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_Payments_Intent_Provider')
ALTER TABLE [Payments].[Intent] ADD CONSTRAINT [FK_Payments_Intent_Provider] FOREIGN KEY ([ProviderID]) REFERENCES [Payments].[Provider] ([ProviderID]);
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_Payments_ProviderSecret_Provider')
ALTER TABLE [Payments].[ProviderSecret] ADD CONSTRAINT [FK_Payments_ProviderSecret_Provider] FOREIGN KEY ([ProviderID]) REFERENCES [Payments].[Provider] ([ProviderID]) ON DELETE CASCADE;
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_Payments_TargetLink_Intent')
ALTER TABLE [Payments].[TargetLink] ADD CONSTRAINT [FK_Payments_TargetLink_Intent] FOREIGN KEY ([PaymentIntentID]) REFERENCES [Payments].[Intent] ([PaymentIntentID]) ON DELETE CASCADE;
GO

IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name=N'FK_Payments_Txn_Intent')
ALTER TABLE [Payments].[Txn] ADD CONSTRAINT [FK_Payments_Txn_Intent] FOREIGN KEY ([PaymentIntentID]) REFERENCES [Payments].[Intent] ([PaymentIntentID]) ON DELETE CASCADE;
GO
