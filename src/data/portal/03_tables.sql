/*
  SkyLynx SQL Export
  Database: skylynx_portal_template
  Section: Tables
  Generated: 2026-07-22T22:47:38.274Z
*/
GO

IF OBJECT_ID(N'dbo.ANNOUNCEMENTS', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[ANNOUNCEMENTS] (
    [ItemID] [int] IDENTITY(1,1) NOT NULL,
    [PortalID] [uniqueidentifier] NOT NULL,
    [CreatedDate] [datetime] CONSTRAINT [DF__ANNOUNCEM__Creat__31EC6D26] DEFAULT (getdate()) NULL,
    [Title] [nvarchar](150) NOT NULL,
    [URL] [nvarchar](250) NULL,
    [ExpireDate] [datetime] NULL,
    [Description] [nvarchar](MAX) NULL,
    [ViewOrder] [int] NULL,
    [CreatedByUser] [nvarchar](128) NOT NULL,
    [PublishDate] [datetime] NULL,
    [ImageSource] [nvarchar](250) NULL,
    [Summary] [nvarchar](MAX) NULL
);
END
GO

IF OBJECT_ID(N'dbo.CUSTOM_FORMS', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[CUSTOM_FORMS] (
    [FormID] [uniqueidentifier] CONSTRAINT [DF__CUSTOM_FO__FormI__2E1BDC42] DEFAULT (newid()) NOT NULL,
    [PortalID] [uniqueidentifier] NOT NULL,
    [FormName] [nvarchar](100) NOT NULL,
    [FormType] [nvarchar](50) NOT NULL,
    [HtmlContent] [nvarchar](MAX) NOT NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__CUSTOM_FO__Creat__2F10007B] DEFAULT (getdate()) NULL
);
END
GO

IF OBJECT_ID(N'dbo.PAGE_VARIABLES', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[PAGE_VARIABLES] (
    [VariableID] [uniqueidentifier] CONSTRAINT [DF__PAGE_VARI__Varia__2A4B4B5E] DEFAULT (newid()) NOT NULL,
    [PortalID] [uniqueidentifier] NOT NULL,
    [VariableName] [nvarchar](100) NOT NULL,
    [VariableValue] [nvarchar](MAX) NOT NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__PAGE_VARI__Creat__2B3F6F97] DEFAULT (getdate()) NULL
);
END
GO

IF OBJECT_ID(N'dbo.PORTAL_PAGES', N'U') IS NULL
BEGIN
CREATE TABLE [dbo].[PORTAL_PAGES] (
    [PageID] [uniqueidentifier] CONSTRAINT [DF__PORTAL_PA__PageI__25869641] DEFAULT (newid()) NOT NULL,
    [PortalID] [uniqueidentifier] NOT NULL,
    [PageName] [nvarchar](100) NOT NULL,
    [Slug] [nvarchar](256) NOT NULL,
    [HtmlContent] [nvarchar](MAX) NOT NULL,
    [IsPublic] [bit] CONSTRAINT [DF__PORTAL_PA__IsPub__267ABA7A] DEFAULT ((1)) NULL,
    [CreatedAt] [datetime] CONSTRAINT [DF__PORTAL_PA__Creat__276EDEB3] DEFAULT (getdate()) NULL
);
END
GO
