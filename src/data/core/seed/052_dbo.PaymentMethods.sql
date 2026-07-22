/*
  SkyLynx SQL Seed Export
  Database: skylynxnet_coredb
  Section: Seed dbo.PaymentMethods
  Generated: 2026-07-22T22:36:46.804Z
  Intended use: fresh database seeding after core schema install.
*/
GO

SET NOCOUNT ON;
INSERT INTO [dbo].[PaymentMethods] ([PaymentMethodID], [UserID], [Type], [Last4Digits], [ExpirationDate], [CreatedAt]) VALUES (N'A6FF1013-693B-44FD-BF74-7D48936B8FD8', N'admin@skylynx.com', N'CreditCard', N'1234', N'12/25', N'2025-03-21 23:32:12.693');
GO
