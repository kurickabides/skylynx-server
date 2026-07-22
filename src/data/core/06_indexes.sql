/*
  SkyLynx SQL Export
  Database: skylynxnet_coredb
  Section: Indexes
  Generated: 2026-07-22T22:35:59.604Z
*/
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'IX_Email')
CREATE NONCLUSTERED INDEX [IX_Email] ON [dbo].[AspNetUsers] ([Email] ASC);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'UX_PortalModules_Instance')
CREATE UNIQUE NONCLUSTERED INDEX [UX_PortalModules_Instance] ON [dbo].[PortalPageModules] ([PortalID] ASC, [PageID] ASC, [ModuleID] ASC, [ContainerName] ASC);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'UX_PortalPageModules_Instance')
CREATE UNIQUE NONCLUSTERED INDEX [UX_PortalPageModules_Instance] ON [dbo].[PortalPageModules] ([PortalID] ASC, [PageID] ASC, [ModuleID] ASC, [ContainerName] ASC);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'IX_PortalName')
CREATE NONCLUSTERED INDEX [IX_PortalName] ON [dbo].[Portals] ([PortalName] ASC);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'IX_Payments_Intent_ClientRef')
CREATE NONCLUSTERED INDEX [IX_Payments_Intent_ClientRef] ON [Payments].[Intent] ([ClientRef] ASC);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'IX_Payments_Intent_ProviderPortalUserStatus')
CREATE NONCLUSTERED INDEX [IX_Payments_Intent_ProviderPortalUserStatus] ON [Payments].[Intent] ([ProviderID] ASC, [PortalID] ASC, [UserID] ASC, [Status] ASC);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'IX_Payments_TargetLink_DomainTarget')
CREATE NONCLUSTERED INDEX [IX_Payments_TargetLink_DomainTarget] ON [Payments].[TargetLink] ([TargetDomain] ASC, [TargetID] ASC);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'IX_Payments_Txn_Intent')
CREATE NONCLUSTERED INDEX [IX_Payments_Txn_Intent] ON [Payments].[Txn] ([PaymentIntentID] ASC);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'UQ_Payments_Txn_GatewayTxnID')
CREATE UNIQUE NONCLUSTERED INDEX [UQ_Payments_Txn_GatewayTxnID] ON [Payments].[Txn] ([GatewayTxnID] ASC) WHERE ([GatewayTxnID] IS NOT NULL);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'IX_Payments_Webhook_ProcessedAt')
CREATE NONCLUSTERED INDEX [IX_Payments_Webhook_ProcessedAt] ON [Payments].[Webhook] ([ProcessedAt] ASC);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name=N'UQ_Payments_Webhook_EventID')
CREATE UNIQUE NONCLUSTERED INDEX [UQ_Payments_Webhook_EventID] ON [Payments].[Webhook] ([EventID] ASC);
GO
