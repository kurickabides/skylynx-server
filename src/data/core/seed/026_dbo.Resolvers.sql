/*
  SkyLynx SQL Seed Export
  Database: skylynxnet_coredb
  Section: Seed dbo.Resolvers
  Generated: 2026-07-22T22:36:46.672Z
  Intended use: fresh database seeding after core schema install.
*/
GO

SET NOCOUNT ON;
INSERT INTO [dbo].[Resolvers] ([ResolverID], [ResolverType], [Target], [Description], [CreatedAt], [UpdatedAt]) VALUES (N'D9389D0C-E067-4BA2-A53C-05CB4120FA4B', N'HttpGet', N'GetModuleById', N'This get a Module by id used when Module is the target object', N'2025-07-18 02:42:37.833', N'1900-01-01 00:00:00.000');
INSERT INTO [dbo].[Resolvers] ([ResolverID], [ResolverType], [Target], [Description], [CreatedAt], [UpdatedAt]) VALUES (N'0689D3D3-AE69-4A32-8591-09EE5B7BBF4C', N'HttpGet', N'GetThemeById', N'This get a Theme by idead used with Theme is the target object', N'2025-07-18 02:40:09.150', N'1900-01-01 00:00:00.000');
INSERT INTO [dbo].[Resolvers] ([ResolverID], [ResolverType], [Target], [Description], [CreatedAt], [UpdatedAt]) VALUES (N'502DBC80-54E9-4001-A7F2-3FFA28A222DE', N'HttpGet', N'GetPageById', N'This get a Page by id used when Page is the target object', N'2025-07-18 02:41:48.500', N'1900-01-01 00:00:00.000');
INSERT INTO [dbo].[Resolvers] ([ResolverID], [ResolverType], [Target], [Description], [CreatedAt], [UpdatedAt]) VALUES (N'CE6CE7AC-0E59-4C42-BBD8-4FFF1E69C7C1', N'HttpGet', N'GetDyFormById', N'This get a DyForm by id used when DyForm is the target object', N'2025-07-18 02:50:45.867', N'1900-01-01 00:00:00.000');
INSERT INTO [dbo].[Resolvers] ([ResolverID], [ResolverType], [Target], [Description], [CreatedAt], [UpdatedAt]) VALUES (N'8D0AF701-8385-44C9-8805-5D80032DCC00', N'HttpInsert', N'CreateUserSignUp', N'Inserts a new user account with roles and profile', N'2025-06-21 01:16:29.080', NULL);
INSERT INTO [dbo].[Resolvers] ([ResolverID], [ResolverType], [Target], [Description], [CreatedAt], [UpdatedAt]) VALUES (N'C8486F76-0557-4E8E-B086-7B0E5EF7F73D', N'HttpUpdate', N'UpdateUserFullProfileViewModel', N'Updates a user profile record and custom fields', N'2025-06-21 01:16:29.083', NULL);
INSERT INTO [dbo].[Resolvers] ([ResolverID], [ResolverType], [Target], [Description], [CreatedAt], [UpdatedAt]) VALUES (N'91DA792A-D4D0-43C4-8BF5-92A152E17065', N'HttpGet', N'GetLayoutById', N'This get a Layout by idead used with Layout is the target object', N'2025-07-18 02:41:00.913', N'1900-01-01 00:00:00.000');
INSERT INTO [dbo].[Resolvers] ([ResolverID], [ResolverType], [Target], [Description], [CreatedAt], [UpdatedAt]) VALUES (N'270376C5-006C-4EE9-8CA0-9BA2DCC0ADEC', N'HttpGet', N'GetPortalById', N'This get a portal by idead used with Portal is the target object', N'2025-07-18 02:38:51.037', N'1900-01-01 00:00:00.000');
INSERT INTO [dbo].[Resolvers] ([ResolverID], [ResolverType], [Target], [Description], [CreatedAt], [UpdatedAt]) VALUES (N'DDD526A4-94A5-4BCB-90AF-D61E1C89B8EF', N'HttpGet', N'GetDataModelById', N'This get a DataModel by id used when DataModel is the target object', N'2025-07-18 02:43:22.913', N'1900-01-01 00:00:00.000');
INSERT INTO [dbo].[Resolvers] ([ResolverID], [ResolverType], [Target], [Description], [CreatedAt], [UpdatedAt]) VALUES (N'5F684430-6673-4000-BACA-ED4CA044987C', N'HttpGet', N'LoadUserFullProfileViewModel', N'Loads the full profile view for a user', N'2025-06-21 01:16:29.070', NULL);
INSERT INTO [dbo].[Resolvers] ([ResolverID], [ResolverType], [Target], [Description], [CreatedAt], [UpdatedAt]) VALUES (N'17DFB05B-C398-47E5-B41E-FB8D1479D18E', N'HttpGet', N'GetDyFormViewModelDefinitionById', N'This get a ViewModelDefinition by id used when ViewModelDefinition is the target object', N'2025-07-18 02:53:53.663', N'1900-01-01 00:00:00.000');
GO
