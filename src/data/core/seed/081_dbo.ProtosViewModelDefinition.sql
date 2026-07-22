/*
  SkyLynx SQL Seed Export
  Database: skylynxnet_coredb
  Section: Seed dbo.ProtosViewModelDefinition
  Generated: 2026-07-22T22:36:46.970Z
  Intended use: fresh database seeding after core schema install.
*/
GO

SET NOCOUNT ON;
INSERT INTO [dbo].[ProtosViewModelDefinition] ([ViewModelDefinitionID], [ViewModelName], [TemplateVersionID], [SortOrder], [IsDefault], [ViewModelContextJSON], [CreatedAt], [UpdatedAt], [TemplateLinkID]) VALUES (N'C1E86A28-0BFB-415C-A4FF-66B58384C90F', N'vmUserProfile_Edit', N'D7E098A9-1887-42BC-B08C-E38749655B58', 2, 0, N'{"method": "POST", "path": "/api/user/edit-profile", "type": "UserProfileEditSubmission"}', N'2025-06-28 01:44:34.553', N'2025-06-28 01:44:34.553', N'FFBF5E2E-C4B7-4523-BFFB-B05D0C21B990');
INSERT INTO [dbo].[ProtosViewModelDefinition] ([ViewModelDefinitionID], [ViewModelName], [TemplateVersionID], [SortOrder], [IsDefault], [ViewModelContextJSON], [CreatedAt], [UpdatedAt], [TemplateLinkID]) VALUES (N'5B6D426C-913D-4115-B9AE-84E89052E1DE', N'vmUserProfile_View', N'21FBA085-972D-4435-8739-08C77E71A91D', 1, 1, N'{"method": "GET", "path": "/api/dyform/viewmodel/vmUserProfile_View", "type": "UserProfileViewOnly"}', N'2025-06-28 01:44:34.553', N'2025-06-28 01:44:34.553', N'A20923CE-50B7-49BD-A1EF-D1BCE8C88E8B');
INSERT INTO [dbo].[ProtosViewModelDefinition] ([ViewModelDefinitionID], [ViewModelName], [TemplateVersionID], [SortOrder], [IsDefault], [ViewModelContextJSON], [CreatedAt], [UpdatedAt], [TemplateLinkID]) VALUES (N'9D8455F7-2D66-476D-8409-8EB0B3FAB8CF', N'vmUserProfile_Form', N'250625F9-6348-443F-9774-86576EA54FA0', 0, 1, N'{"method":"GET", "path":"/api/dyform/viewmodel/vmUserProfile_Form", "type":"UserProfileComposite"}', N'2025-06-29 22:21:55.830', N'2025-06-29 22:21:55.830', N'5EF8D6FF-32C2-4D50-AF83-A6B22CD293F9');
GO
