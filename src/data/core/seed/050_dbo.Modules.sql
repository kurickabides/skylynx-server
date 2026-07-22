/*
  SkyLynx SQL Seed Export
  Database: skylynxnet_coredb
  Section: Seed dbo.Modules
  Generated: 2026-07-22T22:36:46.797Z
  Intended use: fresh database seeding after core schema install.
*/
GO

SET NOCOUNT ON;
INSERT INTO [dbo].[Modules] ([ModuleID], [ModuleName], [ModuleDescription], [ImageFilePath], [ModuleVersion], [componentPath], [CreatedOnDate], [componentName], [ComponentConfig], [StyledID]) VALUES (N'1D8F6ED2-0032-494E-95FB-4EBC611232FD', N'EDPDFModule', N'Engineering Drawing PDF Viewer & Markup', N'/assets/images/edpdf-module.png', 1, N'/modules/edPDFModule', N'2025-08-08 20:19:18.210', N'EDPDFModule', NULL, NULL);
INSERT INTO [dbo].[Modules] ([ModuleID], [ModuleName], [ModuleDescription], [ImageFilePath], [ModuleVersion], [componentPath], [CreatedOnDate], [componentName], [ComponentConfig], [StyledID]) VALUES (N'5E9D4C67-1215-4E8F-AEAF-7CB79A73D7F9', N'AuthModule', N'Authentication & User Account Manager', N'/assets/images/auth-module_sm.png', 1, N'/modules/authModule', N'2025-08-08 20:19:18.213', N'AuthModule', NULL, NULL);
INSERT INTO [dbo].[Modules] ([ModuleID], [ModuleName], [ModuleDescription], [ImageFilePath], [ModuleVersion], [componentPath], [CreatedOnDate], [componentName], [ComponentConfig], [StyledID]) VALUES (N'6B532EDF-EABE-4566-AEA4-831FE6FB583E', N'ESRIMapModule', N'Esri Map Viewer', N'/assets/images/esriMap-module.png', 1, N'/modules/esriMapModule', N'2025-08-08 20:19:18.213', N'ESRIMapModule', NULL, NULL);
INSERT INTO [dbo].[Modules] ([ModuleID], [ModuleName], [ModuleDescription], [ImageFilePath], [ModuleVersion], [componentPath], [CreatedOnDate], [componentName], [ComponentConfig], [StyledID]) VALUES (N'B4055488-B1E6-4A0D-B189-AB4560CB2440', N'PaymentModuleAuthorizeNet', N'Authorize.Net Payment Integration', N'/assets/images/payment-module.png', 1, N'/modules/paymentModule', N'2025-09-23 22:34:50.590', N'PaymentModuleAuthorizeNet', NULL, NULL);
INSERT INTO [dbo].[Modules] ([ModuleID], [ModuleName], [ModuleDescription], [ImageFilePath], [ModuleVersion], [componentPath], [CreatedOnDate], [componentName], [ComponentConfig], [StyledID]) VALUES (N'102AB7AE-3DDB-41E1-85EB-BCF88AD44343', N'GalleryListView', N'This is a gallery View for a image gallery or can have list or table ', N' /assets/images/galleryModule.png', 1, N'/modules/gallerylistviewmod', N'2025-07-15 16:40:15.083', N'GalleryListView', NULL, NULL);
INSERT INTO [dbo].[Modules] ([ModuleID], [ModuleName], [ModuleDescription], [ImageFilePath], [ModuleVersion], [componentPath], [CreatedOnDate], [componentName], [ComponentConfig], [StyledID]) VALUES (N'B7423668-3549-48F1-9A1D-EFF8F5FF1C8B', N'UserProfileModule', N'Handles user accounts, roles, and profile management.', N'/assets/images/user-module.png', 1, N'/modules/userprofilemod', N'2025-07-04 17:01:35.610', N'UserProfileModule', NULL, NULL);
GO
