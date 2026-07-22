/*
  SkyLynx SQL Seed Export
  Database: skylynxnet_coredb
  Section: Seed dbo.DyFormRuleDefinition
  Generated: 2026-07-22T22:36:46.875Z
  Intended use: fresh database seeding after core schema install.
*/
GO

SET NOCOUNT ON;
INSERT INTO [dbo].[DyFormRuleDefinition] ([RuleDefinitionID], [RuleKey], [ResolverTypeID], [DyFormExpressionID], [Description]) VALUES (N'0D36D9FB-B017-4661-B9A7-7F785A80FC2A', N'IsRequiredRule', N'B6FFD1AB-07B8-443D-9C3A-2EB3D8385FFE', N'05D16CF1-89AB-41F9-8132-B57B51F18F76', N'Enforces required field validation.');
INSERT INTO [dbo].[DyFormRuleDefinition] ([RuleDefinitionID], [RuleKey], [ResolverTypeID], [DyFormExpressionID], [Description]) VALUES (N'6BDB4607-76E1-4D8A-AFEB-96BCB2E14C13', N'isHidden', N'B6FFD1AB-07B8-443D-9C3A-2EB3D8385FFE', N'EE5D0775-4263-48B1-AADF-D12E2B8F5496', N'Hides the field based on a dynamic condition.');
GO
