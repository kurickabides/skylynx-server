/*
  SkyLynx SQL Seed Export
  Database: skylynxnet_coredb
  Section: Seed dbo.DyFormExpression
  Generated: 2026-07-22T22:36:46.769Z
  Intended use: fresh database seeding after core schema install.
*/
GO

SET NOCOUNT ON;
INSERT INTO [dbo].[DyFormExpression] ([DyFormExpressionID], [Expression], [ResolverTypeID], [Description]) VALUES (N'05D16CF1-89AB-41F9-8132-B57B51F18F76', N'value IS NOT NULL AND LTRIM(RTRIM(value)) <> ''''', N'B6FFD1AB-07B8-443D-9C3A-2EB3D8385FFE', N'Ensures the value is required (not null or empty)');
INSERT INTO [dbo].[DyFormExpression] ([DyFormExpressionID], [Expression], [ResolverTypeID], [Description]) VALUES (N'EE5D0775-4263-48B1-AADF-D12E2B8F5496', N'context.UserRole = ''admin''', N'B6FFD1AB-07B8-443D-9C3A-2EB3D8385FFE', N'Determines whether the field should be hidden for non-admin users');
GO
