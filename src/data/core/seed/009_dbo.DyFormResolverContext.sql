/*
  SkyLynx SQL Seed Export
  Database: skylynxnet_coredb
  Section: Seed dbo.DyFormResolverContext
  Generated: 2026-07-22T22:36:46.574Z
  Intended use: fresh database seeding after core schema install.
*/
GO

SET NOCOUNT ON;
INSERT INTO [dbo].[DyFormResolverContext] ([Context], [Description]) VALUES (N'Delete', N'Resolver for deletion logic');
INSERT INTO [dbo].[DyFormResolverContext] ([Context], [Description]) VALUES (N'Get', N'Resolve section data for display');
INSERT INTO [dbo].[DyFormResolverContext] ([Context], [Description]) VALUES (N'Insert', N'Resolver for inserting new data');
INSERT INTO [dbo].[DyFormResolverContext] ([Context], [Description]) VALUES (N'Update', N'Resolver for updating existing data');
GO
