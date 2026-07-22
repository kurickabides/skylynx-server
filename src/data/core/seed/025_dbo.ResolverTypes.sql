/*
  SkyLynx SQL Seed Export
  Database: skylynxnet_coredb
  Section: Seed dbo.ResolverTypes
  Generated: 2026-07-22T22:36:46.666Z
  Intended use: fresh database seeding after core schema install.
*/
GO

SET NOCOUNT ON;
INSERT INTO [dbo].[ResolverTypes] ([ResolverType], [Description], [CreatedAt]) VALUES (N'GraphQL', N'Queries a GraphQL endpoint', N'2025-07-02 04:31:51.050');
INSERT INTO [dbo].[ResolverTypes] ([ResolverType], [Description], [CreatedAt]) VALUES (N'HttpGet', N'Fetches data via HTTP GET', N'2025-07-02 04:31:51.050');
INSERT INTO [dbo].[ResolverTypes] ([ResolverType], [Description], [CreatedAt]) VALUES (N'HttpInsert', N'Sends POST request to insert data into external API', N'2025-07-02 04:31:51.050');
INSERT INTO [dbo].[ResolverTypes] ([ResolverType], [Description], [CreatedAt]) VALUES (N'HttpUpdate', N'Sends PUT/PATCH request to update external data', N'2025-07-02 04:31:51.050');
INSERT INTO [dbo].[ResolverTypes] ([ResolverType], [Description], [CreatedAt]) VALUES (N'JSON', N'Returns embedded JSON payload. Used for mocks or static config.', N'2025-07-02 04:31:51.050');
INSERT INTO [dbo].[ResolverTypes] ([ResolverType], [Description], [CreatedAt]) VALUES (N'Pivot', N'Transforms result set into pivoted or matrix format', N'2025-07-02 04:31:51.050');
INSERT INTO [dbo].[ResolverTypes] ([ResolverType], [Description], [CreatedAt]) VALUES (N'Python', N'Executes dynamic Python logic (experimental/future)', N'2025-07-02 04:31:51.050');
INSERT INTO [dbo].[ResolverTypes] ([ResolverType], [Description], [CreatedAt]) VALUES (N'RuleEngine', N'Resolves via internal rule or validation engine', N'2025-07-02 04:31:51.050');
INSERT INTO [dbo].[ResolverTypes] ([ResolverType], [Description], [CreatedAt]) VALUES (N'ServerScript', N'Executes named JS function or inline logic on server', N'2025-07-02 04:31:51.050');
INSERT INTO [dbo].[ResolverTypes] ([ResolverType], [Description], [CreatedAt]) VALUES (N'StaticValue', N'Returns hardcoded static values', N'2025-07-02 04:31:51.050');
INSERT INTO [dbo].[ResolverTypes] ([ResolverType], [Description], [CreatedAt]) VALUES (N'StoredProcedure', N'Executes a SQL Server stored procedure', N'2025-07-02 04:31:51.050');
INSERT INTO [dbo].[ResolverTypes] ([ResolverType], [Description], [CreatedAt]) VALUES (N'Table', N'Loads static SQL table or view directly', N'2025-07-02 04:31:51.050');
INSERT INTO [dbo].[ResolverTypes] ([ResolverType], [Description], [CreatedAt]) VALUES (N'TSQL', N'Executes inline T-SQL block (not stored procedure)', N'2025-07-02 04:31:51.050');
GO
