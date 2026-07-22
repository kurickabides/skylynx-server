/*
  SkyLynx SQL Seed Export
  Database: skylynxnet_coredb
  Section: Seed dbo.Layouts
  Generated: 2026-07-22T22:36:46.792Z
  Intended use: fresh database seeding after core schema install.
*/
GO

SET NOCOUNT ON;
INSERT INTO [dbo].[Layouts] ([LayoutID], [DisplayName], [LayoutType], [Description], [HasSidebar], [HasHeader], [HasFooter], [HasNavigation], [HasContentPane], [CreatedAt], [StyledID], [componentName], [componentPath], [ComponentConfig]) VALUES (N'C9E524AC-A56A-4249-A619-34512F01E9F4', N'Page Layout', N'Page', N'Layout for app pages', 0, 1, 0, 1, 1, N'2025-07-08 20:46:49.320', N'0E7AAE3E-31F9-4D79-AECC-671CBC24BA27', NULL, NULL, NULL);
INSERT INTO [dbo].[Layouts] ([LayoutID], [DisplayName], [LayoutType], [Description], [HasSidebar], [HasHeader], [HasFooter], [HasNavigation], [HasContentPane], [CreatedAt], [StyledID], [componentName], [componentPath], [ComponentConfig]) VALUES (N'ECFA9F7B-5E54-4232-AA9A-6CC49CA3BCC9', N'Auth Layout', N'Shell', N'Used for login and signup wizard', 0, 1, 0, 0, 1, N'2025-07-09 21:50:00.023', N'CDC4EE97-AE4F-4BF8-BE1C-C638C6918C47', NULL, NULL, NULL);
INSERT INTO [dbo].[Layouts] ([LayoutID], [DisplayName], [LayoutType], [Description], [HasSidebar], [HasHeader], [HasFooter], [HasNavigation], [HasContentPane], [CreatedAt], [StyledID], [componentName], [componentPath], [ComponentConfig]) VALUES (N'C1B70BF0-E3C6-45A5-BEC1-7E9158FEBF05', N'Shell Layout', N'Shell', N'Full layout shell', 1, 1, 1, 1, 1, N'2025-07-08 20:46:49.320', N'C6F52236-97F7-4BD5-AC40-8CF157CA207F', NULL, NULL, NULL);
INSERT INTO [dbo].[Layouts] ([LayoutID], [DisplayName], [LayoutType], [Description], [HasSidebar], [HasHeader], [HasFooter], [HasNavigation], [HasContentPane], [CreatedAt], [StyledID], [componentName], [componentPath], [ComponentConfig]) VALUES (N'87A95C77-F855-45E1-8E1C-BAFEE98AEBA4', N'Content Block', N'Content', N'Section container layout', 0, 0, 0, 0, 1, N'2025-07-08 20:46:49.320', N'0E7AAE3E-31F9-4D79-AECC-671CBC24BA27', NULL, NULL, NULL);
GO
