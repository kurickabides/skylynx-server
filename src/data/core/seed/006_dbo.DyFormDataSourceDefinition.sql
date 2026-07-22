/*
  SkyLynx SQL Seed Export
  Database: skylynxnet_coredb
  Section: Seed dbo.DyFormDataSourceDefinition
  Generated: 2026-07-22T22:36:46.557Z
  Intended use: fresh database seeding after core schema install.
*/
GO

SET NOCOUNT ON;
INSERT INTO [dbo].[DyFormDataSourceDefinition] ([DyFormDSDefinitionID], [SourceKey], [IsDirectProperty], [SourcePath]) VALUES (N'C8D2E2BC-33AD-444C-9B44-074751377775', N'PhoneNumberConfirmed', 1, N'AspNetUsers');
INSERT INTO [dbo].[DyFormDataSourceDefinition] ([DyFormDSDefinitionID], [SourceKey], [IsDirectProperty], [SourcePath]) VALUES (N'30DD3653-5EC8-4E36-B4D4-0C4E4F9E4A0B', N'LockoutEnabled', 1, N'AspNetUsers');
INSERT INTO [dbo].[DyFormDataSourceDefinition] ([DyFormDSDefinitionID], [SourceKey], [IsDirectProperty], [SourcePath]) VALUES (N'F9101766-F5A7-44B7-B049-1C01230F9F7B', N'ProviderName', 1, N'PortalProviders');
INSERT INTO [dbo].[DyFormDataSourceDefinition] ([DyFormDSDefinitionID], [SourceKey], [IsDirectProperty], [SourcePath]) VALUES (N'C66BC941-6223-42CC-A3A3-1F525A9EDF2A', N'IsPortalDefault', 1, N'PortalProviders');
INSERT INTO [dbo].[DyFormDataSourceDefinition] ([DyFormDSDefinitionID], [SourceKey], [IsDirectProperty], [SourcePath]) VALUES (N'F06EA58F-F95B-48D3-83A6-29448D16973F', N'UpdatedAt', 0, N'ProviderProfileFields.FieldName');
INSERT INTO [dbo].[DyFormDataSourceDefinition] ([DyFormDSDefinitionID], [SourceKey], [IsDirectProperty], [SourcePath]) VALUES (N'93CED709-0D9A-4949-A95E-299A8CAA0D6A', N'Address1', 1, N'Address');
INSERT INTO [dbo].[DyFormDataSourceDefinition] ([DyFormDSDefinitionID], [SourceKey], [IsDirectProperty], [SourcePath]) VALUES (N'88F98DCF-9879-41AE-8167-3040080CE66C', N'addyId', 1, N'Address');
INSERT INTO [dbo].[DyFormDataSourceDefinition] ([DyFormDSDefinitionID], [SourceKey], [IsDirectProperty], [SourcePath]) VALUES (N'746CA7FE-03CB-43F2-9328-33D0D9AC5A9C', N'Zip', 1, N'Address');
INSERT INTO [dbo].[DyFormDataSourceDefinition] ([DyFormDSDefinitionID], [SourceKey], [IsDirectProperty], [SourcePath]) VALUES (N'598B782D-0BDE-4731-AE2C-4EE0B919474B', N'UserID', 0, N'AspNetUsers');
INSERT INTO [dbo].[DyFormDataSourceDefinition] ([DyFormDSDefinitionID], [SourceKey], [IsDirectProperty], [SourcePath]) VALUES (N'38160382-98B2-494A-A561-53B43EBF7DB7', N'TwoFactorEnabled', 1, N'AspNetUsers');
INSERT INTO [dbo].[DyFormDataSourceDefinition] ([DyFormDSDefinitionID], [SourceKey], [IsDirectProperty], [SourcePath]) VALUES (N'2D5FA345-B890-429B-B975-5814B8DA1060', N'DateOfBirth', 0, N'ProviderProfileFields.FieldName');
INSERT INTO [dbo].[DyFormDataSourceDefinition] ([DyFormDSDefinitionID], [SourceKey], [IsDirectProperty], [SourcePath]) VALUES (N'AD3AD5FC-5B1B-4FD9-AE4F-5904850FC1E8', N'EmailConfirmed', 1, N'AspNetUsers');
INSERT INTO [dbo].[DyFormDataSourceDefinition] ([DyFormDSDefinitionID], [SourceKey], [IsDirectProperty], [SourcePath]) VALUES (N'BCB6B2E5-23D2-4EC5-9584-64CFA68C8AA3', N'AccessFailedCount', 1, N'AspNetUsers');
INSERT INTO [dbo].[DyFormDataSourceDefinition] ([DyFormDSDefinitionID], [SourceKey], [IsDirectProperty], [SourcePath]) VALUES (N'D4CA7736-D0DB-4FDD-9C93-6DBDC990BD49', N'UserName', 1, N'AspNetUsers');
INSERT INTO [dbo].[DyFormDataSourceDefinition] ([DyFormDSDefinitionID], [SourceKey], [IsDirectProperty], [SourcePath]) VALUES (N'4EFB00C9-D045-4C45-811C-703589EDA741', N'LastName', 0, N'ProviderProfileFields.FieldName');
INSERT INTO [dbo].[DyFormDataSourceDefinition] ([DyFormDSDefinitionID], [SourceKey], [IsDirectProperty], [SourcePath]) VALUES (N'0FE22E71-D988-457F-AC40-706E5C77F0FC', N'PreferredLanguage', 0, N'ProviderProfileFields.FieldName');
INSERT INTO [dbo].[DyFormDataSourceDefinition] ([DyFormDSDefinitionID], [SourceKey], [IsDirectProperty], [SourcePath]) VALUES (N'2B8917E6-D866-4DA5-832A-87A7DCB9365A', N'PortalDescription', 1, N'Portals');
INSERT INTO [dbo].[DyFormDataSourceDefinition] ([DyFormDSDefinitionID], [SourceKey], [IsDirectProperty], [SourcePath]) VALUES (N'E81C8424-A8E2-49FF-A16B-88F8EC8C8AF8', N'Phone', 0, N'ProviderProfileFields.FieldName');
INSERT INTO [dbo].[DyFormDataSourceDefinition] ([DyFormDSDefinitionID], [SourceKey], [IsDirectProperty], [SourcePath]) VALUES (N'405D82D8-86B6-47C3-AAD2-8A0B243EC0BA', N'PhoneNumber', 1, N'AspNetUsers');
INSERT INTO [dbo].[DyFormDataSourceDefinition] ([DyFormDSDefinitionID], [SourceKey], [IsDirectProperty], [SourcePath]) VALUES (N'CA0FD584-AC42-47DA-982F-98B9FCC25F72', N'CreatedDate', 0, N'ProviderProfileFields.FieldName');
INSERT INTO [dbo].[DyFormDataSourceDefinition] ([DyFormDSDefinitionID], [SourceKey], [IsDirectProperty], [SourcePath]) VALUES (N'F47DFE41-C7FF-4B04-8F1C-99D80F8A59FF', N'LockoutEndDate', 1, N'AspNetUsers');
INSERT INTO [dbo].[DyFormDataSourceDefinition] ([DyFormDSDefinitionID], [SourceKey], [IsDirectProperty], [SourcePath]) VALUES (N'D20A6CAB-207C-4B13-88D2-9C2F96F71D00', N'SecurityStamp', 1, N'AspNetUsers');
INSERT INTO [dbo].[DyFormDataSourceDefinition] ([DyFormDSDefinitionID], [SourceKey], [IsDirectProperty], [SourcePath]) VALUES (N'3112BC5D-E6FF-4D6F-BAEF-9FE5F525DE19', N'Address2', 1, N'Address');
INSERT INTO [dbo].[DyFormDataSourceDefinition] ([DyFormDSDefinitionID], [SourceKey], [IsDirectProperty], [SourcePath]) VALUES (N'A05087D6-F55F-4E55-B074-A6774F74AC5B', N'City', 1, N'Address');
INSERT INTO [dbo].[DyFormDataSourceDefinition] ([DyFormDSDefinitionID], [SourceKey], [IsDirectProperty], [SourcePath]) VALUES (N'0E8E640D-911A-4DC3-9693-B203DBE658F9', N'Email', 1, N'AspNetUsers');
INSERT INTO [dbo].[DyFormDataSourceDefinition] ([DyFormDSDefinitionID], [SourceKey], [IsDirectProperty], [SourcePath]) VALUES (N'D56770CA-E071-4928-A714-BF953864DEB5', N'PortalName', 1, N'Portals');
INSERT INTO [dbo].[DyFormDataSourceDefinition] ([DyFormDSDefinitionID], [SourceKey], [IsDirectProperty], [SourcePath]) VALUES (N'41072C54-F30F-42F0-832E-C30D12FD0806', N'IsSystemDefault', 1, N'PortalProviders');
INSERT INTO [dbo].[DyFormDataSourceDefinition] ([DyFormDSDefinitionID], [SourceKey], [IsDirectProperty], [SourcePath]) VALUES (N'9F662B90-08A4-44DB-8B62-D39D9F1C91C7', N'StateProvinceID', 1, N'Address');
INSERT INTO [dbo].[DyFormDataSourceDefinition] ([DyFormDSDefinitionID], [SourceKey], [IsDirectProperty], [SourcePath]) VALUES (N'DECDD7E8-079C-45C1-9114-DEF4DB7DC4EF', N'Photo', 0, N'ProviderProfileFields.FieldName');
INSERT INTO [dbo].[DyFormDataSourceDefinition] ([DyFormDSDefinitionID], [SourceKey], [IsDirectProperty], [SourcePath]) VALUES (N'01AE8CD1-6494-445A-B6D6-E6CE158A04FF', N'CreatedAt', 1, N'Portals');
INSERT INTO [dbo].[DyFormDataSourceDefinition] ([DyFormDSDefinitionID], [SourceKey], [IsDirectProperty], [SourcePath]) VALUES (N'DF3E45B8-E3ED-46D1-9772-F063C08F660C', N'FirstName', 0, N'ProviderProfileFields.FieldName');
GO
