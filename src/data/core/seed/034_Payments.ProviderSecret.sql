/*
  SkyLynx SQL Seed Export
  Database: skylynxnet_coredb
  Section: Seed Payments.ProviderSecret
  Generated: 2026-07-22T22:36:46.716Z
  Intended use: fresh database seeding after core schema install.
*/
GO

SET NOCOUNT ON;
INSERT INTO [Payments].[ProviderSecret] ([ProviderID], [ApiLoginID_enc], [TransactionKey_enc], [SignatureKeyHex_enc], [Mode], [UpdatedAt]) VALUES (N'3EEF0176-A836-4B61-B370-8F3E8E8A7C10', N'79ejkf82EBj', N'3r43MB7q5F8Tj3b4', N'169B4DBB5D4958C04DEB209E29B023D5F8A2B8AA7B51C54CABD56529D6039A7AB3163D047CE4843C4078AD4A7FAF9A7AD6915FBC57A09787AE0FC98F9015AFD5', N'Sandbox', N'2025-09-23 20:52:55.373');
GO
