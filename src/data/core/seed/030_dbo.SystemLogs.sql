/*
  SkyLynx SQL Seed Export
  Database: skylynxnet_coredb
  Section: Seed dbo.SystemLogs
  Generated: 2026-07-22T22:36:46.694Z
  Intended use: fresh database seeding after core schema install.
*/
GO

SET NOCOUNT ON;
INSERT INTO [dbo].[SystemLogs] ([LogID], [LogType], [LogMessage], [CreatedAt]) VALUES (N'0941BF51-FE60-44E8-BDA5-21550C10B6B1', N'Warning', N'API Key usage limit reached.', N'2025-03-21 23:32:26.653');
INSERT INTO [dbo].[SystemLogs] ([LogID], [LogType], [LogMessage], [CreatedAt]) VALUES (N'4F7CAB52-28A5-4045-8516-2AE05C7E6613', N'Info', N'Created record in DyFormDFormDomainValues', N'2025-06-18 00:05:15.813');
INSERT INTO [dbo].[SystemLogs] ([LogID], [LogType], [LogMessage], [CreatedAt]) VALUES (N'891D60DF-CD02-41DF-886C-5930A06AFEDB', N'Info', N'Created record in DyFormDFormDomainValues', N'2025-06-18 00:05:15.820');
INSERT INTO [dbo].[SystemLogs] ([LogID], [LogType], [LogMessage], [CreatedAt]) VALUES (N'4DAEEDB7-0ED0-4B1D-8438-7A0498E85A2D', N'Info', N'User admin logged in.', N'2025-03-21 23:32:26.653');
INSERT INTO [dbo].[SystemLogs] ([LogID], [LogType], [LogMessage], [CreatedAt]) VALUES (N'7ADD45CC-75DE-4583-B693-9C9F08C622F2', N'Error', N'Payment failure for testuser.', N'2025-03-21 23:32:26.653');
GO
