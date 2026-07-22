/*
  SkyLynx SQL Seed Export
  Database: skylynxnet_coredb
  Section: Seed dbo.ProfileProviders
  Generated: 2026-07-22T22:36:46.633Z
  Intended use: fresh database seeding after core schema install.
*/
GO

SET NOCOUNT ON;
INSERT INTO [dbo].[ProfileProviders] ([ProviderID], [ProviderName], [IsSystemDefault], [Description]) VALUES (N'08FED495-1A60-444E-9703-31AE51D6834F', N'AD', 0, N'Microsoft Active Directory provider for enterprise authentication.');
INSERT INTO [dbo].[ProfileProviders] ([ProviderID], [ProviderName], [IsSystemDefault], [Description]) VALUES (N'211CFD88-9A78-4932-BA14-96AED7F8E35E', N'Google', 0, N'Google profile provider used for OAuth-based sign-in.');
INSERT INTO [dbo].[ProfileProviders] ([ProviderID], [ProviderName], [IsSystemDefault], [Description]) VALUES (N'6216EF98-78FA-485E-BB17-A0F53E18A65D', N'SkylynxNet', 1, N'SkylynxNet Default Profile Provider used for native registrations.');
INSERT INTO [dbo].[ProfileProviders] ([ProviderID], [ProviderName], [IsSystemDefault], [Description]) VALUES (N'BFFC45F0-D094-43C3-BDF1-B3008D2DD8E4', N'GITHUB', 0, N'GitHub profile provider used for developer logins.');
GO
