/*
  SkyLynx SQL Seed Export
  Database: skylynxnet_coredb
  Section: Seed dbo.LayoutTypes
  Generated: 2026-07-22T22:36:46.616Z
  Intended use: fresh database seeding after core schema install.
*/
GO

SET NOCOUNT ON;
INSERT INTO [dbo].[LayoutTypes] ([LayoutTypeID], [LayoutTypeName], [Description], [CreatedAt]) VALUES (N'5BC89DC7-1977-4029-B8A5-2E782CA0C39D', N'Page', N'Layout for full pages', N'2025-07-08 20:46:19.463');
INSERT INTO [dbo].[LayoutTypes] ([LayoutTypeID], [LayoutTypeName], [Description], [CreatedAt]) VALUES (N'D5C26242-6427-470E-8149-57EFE7978467', N'Shell', N'App-level root layout', N'2025-07-08 20:46:19.463');
INSERT INTO [dbo].[LayoutTypes] ([LayoutTypeID], [LayoutTypeName], [Description], [CreatedAt]) VALUES (N'A1177E7F-C171-4750-B28E-66F7784E9945', N'Content', N'Wrapper for page sections', N'2025-07-08 20:46:19.463');
GO
