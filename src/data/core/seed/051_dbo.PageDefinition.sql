/*
  SkyLynx SQL Seed Export
  Database: skylynxnet_coredb
  Section: Seed dbo.PageDefinition
  Generated: 2026-07-22T22:36:46.801Z
  Intended use: fresh database seeding after core schema install.
*/
GO

SET NOCOUNT ON;
INSERT INTO [dbo].[PageDefinition] ([PageID], [RoutePath], [PageTitle], [MenuIcon], [RequiresAuth], [RoleID], [Notes], [CreatedAt], [componentName], [componentPath], [ComponentConfig], [StyledID]) VALUES (N'2D4762C3-7048-40DE-A836-2CB60E48361F', N'/settings', N'Settings', N'SettingsIcon', 1, N'10002', N'Auto-seeded from tree', N'2025-07-10 19:31:09.603', N'settings', N'/pages', NULL, NULL);
INSERT INTO [dbo].[PageDefinition] ([PageID], [RoutePath], [PageTitle], [MenuIcon], [RequiresAuth], [RoleID], [Notes], [CreatedAt], [componentName], [componentPath], [ComponentConfig], [StyledID]) VALUES (N'8785B403-A851-4480-B2DB-3E53FD10688A', N'/dashboard', N'Dashboard', N'DashboardIcon', 1, N'10002', N'Auto-seeded from tree', N'2025-07-10 19:28:57.837', N'dashboard', N'/pages', NULL, NULL);
INSERT INTO [dbo].[PageDefinition] ([PageID], [RoutePath], [PageTitle], [MenuIcon], [RequiresAuth], [RoleID], [Notes], [CreatedAt], [componentName], [componentPath], [ComponentConfig], [StyledID]) VALUES (N'F082D812-6841-4CF5-B84E-53F947D52011', N'/aboutus', N'About Us', N'AboutUsIcon', 1, NULL, N'Auto-seeded from tree', N'2025-07-10 19:30:13.670', N'aboutUs', N'/pages', NULL, NULL);
INSERT INTO [dbo].[PageDefinition] ([PageID], [RoutePath], [PageTitle], [MenuIcon], [RequiresAuth], [RoleID], [Notes], [CreatedAt], [componentName], [componentPath], [ComponentConfig], [StyledID]) VALUES (N'20D390EF-BAE0-450E-8A8D-7BB8D613334F', N'/userprofile', N'User Profile', N'UserProfileIcon', 1, N'10002', N'Auto-seeded from tree', N'2025-07-10 19:23:59.200', N'userProfile', N'/pages', NULL, NULL);
INSERT INTO [dbo].[PageDefinition] ([PageID], [RoutePath], [PageTitle], [MenuIcon], [RequiresAuth], [RoleID], [Notes], [CreatedAt], [componentName], [componentPath], [ComponentConfig], [StyledID]) VALUES (N'9F3B0F44-6553-4889-B3D7-93F4590EB263', N'/auth', N'Login', N'LoginIcon', 1, NULL, N'Auto-seeded from tree', N'2025-07-10 19:31:09.610', N'authPage', N'/pages', NULL, NULL);
INSERT INTO [dbo].[PageDefinition] ([PageID], [RoutePath], [PageTitle], [MenuIcon], [RequiresAuth], [RoleID], [Notes], [CreatedAt], [componentName], [componentPath], [ComponentConfig], [StyledID]) VALUES (N'3942FB7D-FE66-4320-84E1-9974CC681DDC', N'/home', N'Home', N'HomeIcon', 1, NULL, N'Auto-seeded from tree', N'2025-07-10 19:27:44.520', N'home', N'/pages', NULL, NULL);
GO
