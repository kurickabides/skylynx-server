/*
  SkyLynx SQL Seed Export
  Database: skylynxnet_coredb
  Section: Seed Payments.Provider
  Generated: 2026-07-22T22:36:46.525Z
  Intended use: fresh database seeding after core schema install.
*/
GO

SET NOCOUNT ON;
INSERT INTO [Payments].[Provider] ([ProviderID], [Name], [Type], [IsActive], [IsSandbox], [CreatedAt], [UpdatedAt]) VALUES (N'3EEF0176-A836-4B61-B370-8F3E8E8A7C10', N'Authorize.Net Sandbox', N'Authorize.Net', 1, 1, N'2025-09-23 20:52:55.370', N'2025-09-23 20:52:55.370');
GO
