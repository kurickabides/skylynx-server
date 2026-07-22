/*
  SkyLynx SQL Seed Export
  Database: skylynxnet_coredb
  Section: Seed dbo.Transactions
  Generated: 2026-07-22T22:36:46.919Z
  Intended use: fresh database seeding after core schema install.
*/
GO

SET NOCOUNT ON;
INSERT INTO [dbo].[Transactions] ([TransactionID], [UserID], [Amount], [Currency], [PaymentMethodID], [Status], [TransactionDate], [TransactionReference], [CreatedAt]) VALUES (N'F80F72A6-8577-4F1F-83B7-E26C6F769AE4', N'admin@skylynx.com', 99.99, N'USD', N'A6FF1013-693B-44FD-BF74-7D48936B8FD8', N'Completed', N'2025-03-21 23:32:12.707', NULL, N'2025-03-21 23:32:12.707');
GO
