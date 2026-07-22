/*
  SkyLynx SQL Seed Export
  Database: skylynxnet_coredb
  Section: Seed dbo.ThemeDefinitions
  Generated: 2026-07-22T22:36:46.704Z
  Intended use: fresh database seeding after core schema install.
*/
GO

SET NOCOUNT ON;
INSERT INTO [dbo].[ThemeDefinitions] ([ThemeDefinitionID], [ThemeName], [DisplayName], [ThemeOption], [IsBase], [Description], [CreatedAt], [componentName], [componentPath], [ComponentConfig], [DefaultMode]) VALUES (N'1D527102-59D3-4121-893E-002A18EC9547', N'appTheme', N'Skylynx Themes', N'deafultTheme', 1, N'This is base them for Skylynx Portal', N'2025-07-09 20:47:16.520', N'appTheme', N'/theme', NULL, N'light');
INSERT INTO [dbo].[ThemeDefinitions] ([ThemeDefinitionID], [ThemeName], [DisplayName], [ThemeOption], [IsBase], [Description], [CreatedAt], [componentName], [componentPath], [ComponentConfig], [DefaultMode]) VALUES (N'A7D5B27C-E234-49F9-A987-51EC6E900483', N'deafultTheme', N'deafult_colors', N'', 0, N'This is the default color sytem for new Skylynx sites', N'2025-07-09 20:55:12.960', N'defaultThemeColors', N'/theme', NULL, N'dark');
INSERT INTO [dbo].[ThemeDefinitions] ([ThemeDefinitionID], [ThemeName], [DisplayName], [ThemeOption], [IsBase], [Description], [CreatedAt], [componentName], [componentPath], [ComponentConfig], [DefaultMode]) VALUES (N'343DBD2B-CFCF-4B50-9E9B-97FA474FC754', N'cryoRIO_colors', N'CryoRIO', N'', 0, N'Cool-toned palette used by CryoRIO team', N'2025-07-08 21:00:51.980', N'cryoRIOColors', N'/theme', NULL, N'dark');
INSERT INTO [dbo].[ThemeDefinitions] ([ThemeDefinitionID], [ThemeName], [DisplayName], [ThemeOption], [IsBase], [Description], [CreatedAt], [componentName], [componentPath], [ComponentConfig], [DefaultMode]) VALUES (N'824AECC0-9F4E-46C6-A89D-F3D6506547D6', N'fieldPro_colors', N'Field Pro', N'', 0, N'Earthy utility styling used in FieldPro environments', N'2025-07-08 21:00:51.980', N'fieldProColors', N'/theme', NULL, N'dark');
GO
