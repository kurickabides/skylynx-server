/*
  SkyLynx SQL Seed Export
  Database: skylynxnet_coredb
  Section: Seed dbo.ProtosDataModelDefinition
  Generated: 2026-07-22T22:36:46.638Z
  Intended use: fresh database seeding after core schema install.
*/
GO

SET NOCOUNT ON;
INSERT INTO [dbo].[ProtosDataModelDefinition] ([DataModelID], [DataModelName], [DataModelJSON], [Description], [CreatedAt], [UpdatedAt]) VALUES (N'E22E73D6-A576-47C1-A872-0B445C98221B', N'dmSkylynxUserProfile', N'{
  "aspNetUserModel": [],
  "mailingAddressModel": [],
  "billingAddressModel": [],
  "providerProfileFieldModel": [],
  "providerProfileValueModel": []
}', N'DataModel for SkylynxUserProfile including dynamic provider fields', N'2025-07-05 00:40:38.577', N'2025-07-05 02:01:25.350');
GO
