/*
  SkyLynx SQL Seed Export
  Database: skylynxnet_coredb
  Section: Seed dbo.SkyLynxConfig_PackagedModules
  Generated: 2026-07-22T22:36:46.914Z
  Intended use: fresh database seeding after core schema install.
*/
GO

SET NOCOUNT ON;
INSERT INTO [dbo].[SkyLynxConfig_PackagedModules] ([PackagedModuleID], [PortalName], [ModuleName], [TemplateName], [TemplateVersionID], [InstalledAt], [InstalledBy], [Notes]) VALUES (N'4E2DFBA5-E6E6-41E7-84E0-5793C0947F5C', N'SkyLynxNet', N'ProfileManagement', N'tmpProfileManagement', N'6ADB27BA-8DBB-4EF6-9619-1A96794E4FC1', N'2025-07-07 02:52:31.727', N'ADMIN', N'Initial install of UserManagement module');
GO
