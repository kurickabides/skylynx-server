/*
  SkyLynx SQL Seed Export
  Database: skylynxnet_coredb
  Section: Seed dbo.AspNetUsers
  Generated: 2026-07-22T22:36:46.544Z
  Intended use: fresh database seeding after core schema install.
*/
GO

SET NOCOUNT ON;
INSERT INTO [dbo].[AspNetUsers] ([Id], [UserName], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount]) VALUES (N'admin@skylynx.com', N'ADMIN', N'contact@cryptoriomarket.com', 1, N'$2b$12$bePn6NudkKtYKhFJpl/dRuFHFxK1Udfe2B01aTtMuMsgKerUTZIPW', N'6BF13EF0-7C4B-46DD-8BA7-AF9126A63E7B', N'6787724308', 1, 0, NULL, 1, 0);
INSERT INTO [dbo].[AspNetUsers] ([Id], [UserName], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount]) VALUES (N'SKYX-000001', N'cmTestUser', N'chad@advbuss.com', 0, N'$2b$12$bePn6NudkKtYKhFJpl/dRuFHFxK1Udfe2B01aTtMuMsgKerUTZIPW', N'78A4DF0B-39C9-4E71-A3F8-224FC70CC2F4', N'6787724308', 0, 0, NULL, 1, 0);
INSERT INTO [dbo].[AspNetUsers] ([Id], [UserName], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount]) VALUES (N'SKYX-000002', N'Kurick', N'kurickabides@gmail.com', 0, N'$2b$12$bePn6NudkKtYKhFJpl/dRuFHFxK1Udfe2B01aTtMuMsgKerUTZIPW', N'8C55BB76-FF9F-4AD6-9FDC-8B3DBEDF22C2', N'6787724308', 0, 0, NULL, 1, 0);
INSERT INTO [dbo].[AspNetUsers] ([Id], [UserName], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount]) VALUES (N'SKYX-000003', N'testUser', N'testuser@example.com', 0, N'$2b$12$VZw3VtKyjDrU8/Nqh1NDFOlWppV7ZCNae0gHMrD/daRaYAutZ5Pfq', N'C0F8E536-B457-493A-AFC0-6BD10A86CB80', NULL, 0, 0, NULL, 1, 0);
GO
