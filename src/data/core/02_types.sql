/*
  SkyLynx SQL Export
  Database: skylynxnet_coredb
  Section: User-defined table types
  Generated: 2026-07-22T22:35:59.597Z
*/
GO

IF TYPE_ID(N'dbo.KeyValuePairType') IS NULL
    EXEC(N'CREATE TYPE [dbo].[KeyValuePairType] AS TABLE (
    [Key] [nvarchar](100) NULL,
    [Value] [nvarchar](MAX) NULL
    )');
GO

IF TYPE_ID(N'dbo.ProviderProfileFieldListType') IS NULL
    EXEC(N'CREATE TYPE [dbo].[ProviderProfileFieldListType] AS TABLE (
    [FieldID] [uniqueidentifier] NULL,
    [FieldName] [nvarchar](100) NULL,
    [FieldTypeID] [nvarchar](50) NULL,
    [IsRequired] [bit] NULL,
    [SortOrder] [int] NULL
    )');
GO

IF TYPE_ID(N'dbo.UserProfileField') IS NULL
    EXEC(N'CREATE TYPE [dbo].[UserProfileField] AS TABLE (
    [FieldID] [uniqueidentifier] NOT NULL,
    [FieldValue] [nvarchar](MAX) NOT NULL,
    [FieldName] [nvarchar](256) NULL
    )');
GO

IF TYPE_ID(N'dbo.UserProfileViewModelType') IS NULL
    EXEC(N'CREATE TYPE [dbo].[UserProfileViewModelType] AS TABLE (
    [UserID] [nvarchar](128) NULL,
    [UserName] [nvarchar](256) NULL,
    [Email] [nvarchar](256) NULL,
    [PhoneNumber] [nvarchar](50) NULL,
    [PortalID] [uniqueidentifier] NULL,
    [ProviderID] [uniqueidentifier] NULL,
    [MailingAddressID] [uniqueidentifier] NULL,
    [MailingAddress1] [nvarchar](255) NULL,
    [MailingAddress2] [nvarchar](255) NULL,
    [MailingCity] [nvarchar](100) NULL,
    [MailingStateProvinceID] [uniqueidentifier] NULL,
    [MailingZip] [nvarchar](20) NULL,
    [BillingAddressID] [uniqueidentifier] NULL,
    [BillingAddress1] [nvarchar](255) NULL,
    [BillingAddress2] [nvarchar](255) NULL,
    [BillingCity] [nvarchar](100) NULL,
    [BillingStateProvinceID] [uniqueidentifier] NULL,
    [BillingZip] [nvarchar](20) NULL
    )');
GO
