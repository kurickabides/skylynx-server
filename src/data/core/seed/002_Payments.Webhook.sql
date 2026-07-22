/*
  SkyLynx SQL Seed Export
  Database: skylynxnet_coredb
  Section: Seed Payments.Webhook
  Generated: 2026-07-22T22:36:46.533Z
  Intended use: fresh database seeding after core schema install.
*/
GO

SET NOCOUNT ON;
INSERT INTO [Payments].[Webhook] ([WebhookID], [EventID], [EventType], [RawJson], [ProcessedAt]) VALUES (N'514C2E32-3822-4A1A-834A-9547F585C3B6', N'test-evt-123', N'net.authorize.payment.authcapture.created', N'{"id":"test-evt-123"}', NULL);
GO
