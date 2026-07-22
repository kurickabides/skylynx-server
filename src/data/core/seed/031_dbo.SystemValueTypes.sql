/*
  SkyLynx SQL Seed Export
  Database: skylynxnet_coredb
  Section: Seed dbo.SystemValueTypes
  Generated: 2026-07-22T22:36:46.699Z
  Intended use: fresh database seeding after core schema install.
*/
GO

SET NOCOUNT ON;
INSERT INTO [dbo].[SystemValueTypes] ([ValueType], [Description], [IsStructured], [CreatedAt]) VALUES (N'boolean', N'True or false values', 0, N'2025-08-08 04:09:30.997');
INSERT INTO [dbo].[SystemValueTypes] ([ValueType], [Description], [IsStructured], [CreatedAt]) VALUES (N'date', N'Date or datetime string', 0, N'2025-08-08 04:09:31.040');
INSERT INTO [dbo].[SystemValueTypes] ([ValueType], [Description], [IsStructured], [CreatedAt]) VALUES (N'decimal', N'Decimal number', 0, N'2025-08-08 04:09:31.020');
INSERT INTO [dbo].[SystemValueTypes] ([ValueType], [Description], [IsStructured], [CreatedAt]) VALUES (N'guid', N'Globally unique identifier', 0, N'2025-08-08 04:09:31.037');
INSERT INTO [dbo].[SystemValueTypes] ([ValueType], [Description], [IsStructured], [CreatedAt]) VALUES (N'html', N'HTML content block', 1, N'2025-08-08 04:09:31.060');
INSERT INTO [dbo].[SystemValueTypes] ([ValueType], [Description], [IsStructured], [CreatedAt]) VALUES (N'integer', N'Whole number', 0, N'2025-08-08 04:09:31.010');
INSERT INTO [dbo].[SystemValueTypes] ([ValueType], [Description], [IsStructured], [CreatedAt]) VALUES (N'json', N'JSON object or array', 1, N'2025-08-08 04:09:31.050');
INSERT INTO [dbo].[SystemValueTypes] ([ValueType], [Description], [IsStructured], [CreatedAt]) VALUES (N'list', N'Comma-separated list', 0, N'2025-08-08 04:09:31.063');
INSERT INTO [dbo].[SystemValueTypes] ([ValueType], [Description], [IsStructured], [CreatedAt]) VALUES (N'markdown', N'Markdown formatted text', 1, N'2025-08-08 04:09:31.070');
INSERT INTO [dbo].[SystemValueTypes] ([ValueType], [Description], [IsStructured], [CreatedAt]) VALUES (N'string', N'Free text', 0, N'2025-08-08 04:09:31.030');
GO
