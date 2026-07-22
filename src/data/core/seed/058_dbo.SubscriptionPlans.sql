/*
  SkyLynx SQL Seed Export
  Database: skylynxnet_coredb
  Section: Seed dbo.SubscriptionPlans
  Generated: 2026-07-22T22:36:46.836Z
  Intended use: fresh database seeding after core schema install.
*/
GO

SET NOCOUNT ON;
INSERT INTO [dbo].[SubscriptionPlans] ([SubscriptionID], [UserID], [PlanName], [Price], [BillingCycle], [Status], [StartDate], [EndDate], [SubscriptionPlanID], [CreatedAt]) VALUES (N'5034C74F-B7FB-4094-8AC0-72007228E909', N'admin@skylynx.com', N'Premium Plan', 19.99, N'Monthly', N'Active', N'2025-03-21 23:32:12.713', NULL, N'7011FEE1-BC90-4C56-A5A1-4BC99C03FCB0', N'2025-03-21 23:32:12.713');
GO
