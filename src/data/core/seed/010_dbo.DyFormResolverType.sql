/*
  SkyLynx SQL Seed Export
  Database: skylynxnet_coredb
  Section: Seed dbo.DyFormResolverType
  Generated: 2026-07-22T22:36:46.581Z
  Intended use: fresh database seeding after core schema install.
*/
GO

SET NOCOUNT ON;
INSERT INTO [dbo].[DyFormResolverType] ([ResolverTypeID], [Name], [Description]) VALUES (N'B6FFD1AB-07B8-443D-9C3A-2EB3D8385FFE', N'RuleEngine', N'Evaluated using the central rule engine on server');
INSERT INTO [dbo].[DyFormResolverType] ([ResolverTypeID], [Name], [Description]) VALUES (N'9D7E7F7B-8D47-4FB6-A42C-33495AF0A408', N'TSQL', N'Evaluates expression using Transact-SQL on the server');
INSERT INTO [dbo].[DyFormResolverType] ([ResolverTypeID], [Name], [Description]) VALUES (N'F3F73436-23F6-4DAB-88A8-3DE002FC9F7F', N'StaticValue', N'Used to return static or default values');
INSERT INTO [dbo].[DyFormResolverType] ([ResolverTypeID], [Name], [Description]) VALUES (N'848B183C-DCE9-4547-AA40-53E7F588A5F4', N'python', N'python script');
INSERT INTO [dbo].[DyFormResolverType] ([ResolverTypeID], [Name], [Description]) VALUES (N'7AE6455B-BFCE-4BD1-8096-58FDB465648F', N'pivot', N'use a pivot view');
INSERT INTO [dbo].[DyFormResolverType] ([ResolverTypeID], [Name], [Description]) VALUES (N'C09A6DBF-6893-4B65-951E-5BD408BFFB05', N'JSONLogic', N'Client-side JSON logic processor for conditional rules');
INSERT INTO [dbo].[DyFormResolverType] ([ResolverTypeID], [Name], [Description]) VALUES (N'C35D1CDB-48AA-4D90-863D-98BDE47CCE9E', N'table', N'use a table as source');
INSERT INTO [dbo].[DyFormResolverType] ([ResolverTypeID], [Name], [Description]) VALUES (N'483BE7B8-AB0D-41A1-9A28-BF9DEDC35673', N'JSFunction', N'JavaScript function evaluated in React context');
INSERT INTO [dbo].[DyFormResolverType] ([ResolverTypeID], [Name], [Description]) VALUES (N'EC5FB16F-BCAC-4726-8004-D9C723053C75', N'ServerScript', N'Backend-executed business rule (e.g., in .NET or Node)');
INSERT INTO [dbo].[DyFormResolverType] ([ResolverTypeID], [Name], [Description]) VALUES (N'5F684430-6673-4000-BACA-ED4CA044987C', N'sp', N'call Sp as source');
GO
