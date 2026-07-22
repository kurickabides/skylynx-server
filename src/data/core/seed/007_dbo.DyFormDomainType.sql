/*
  SkyLynx SQL Seed Export
  Database: skylynxnet_coredb
  Section: Seed dbo.DyFormDomainType
  Generated: 2026-07-22T22:36:46.564Z
  Intended use: fresh database seeding after core schema install.
*/
GO

SET NOCOUNT ON;
INSERT INTO [dbo].[DyFormDomainType] ([DomainTypeID], [DomainTypeName], [Description]) VALUES (N'DC04B79C-F040-404E-9345-0294E0DB6E27', N'range', N'Used for numeric or date range constraints');
INSERT INTO [dbo].[DyFormDomainType] ([DomainTypeID], [DomainTypeName], [Description]) VALUES (N'008AF890-88C9-4ACB-9C45-45103B5F7889', N'valueList', N'Used for dropdowns or list lookups (static table)');
GO
