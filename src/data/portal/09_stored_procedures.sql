/*
  SkyLynx SQL Export
  Database: skylynx_portal_template
  Section: Stored procedures
  Generated: 2026-07-22T22:47:38.278Z
*/
GO


-- =============================================
-- Stored Procedures for Page Variables (CRUD)
-- =============================================

-- Create Page Variable
CREATE PROCEDURE AddPageVariable
    @PortalID UNIQUEIDENTIFIER,
    @VariableName NVARCHAR(100),
    @VariableValue NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO PAGE_VARIABLES (PortalID, VariableName, VariableValue, CreatedAt)
    VALUES (@PortalID, @VariableName, @VariableValue, GETDATE());
END;

GO


-- =============================================
-- Stored Procedures for Custom Forms (CRUD)
-- =============================================

-- Create Custom Form
CREATE PROCEDURE CreateCustomForm
    @PortalID UNIQUEIDENTIFIER,
    @FormName NVARCHAR(100),
    @FormType NVARCHAR(50),
    @HtmlContent NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO CUSTOM_FORMS (PortalID, FormName, FormType, HtmlContent, CreatedAt)
    VALUES (@PortalID, @FormName, @FormType, @HtmlContent, GETDATE());
END;

GO

-- Create Portal Page
CREATE PROCEDURE CreatePortalPage
    @PortalID UNIQUEIDENTIFIER,
    @PageName NVARCHAR(100),
    @Slug NVARCHAR(256),
    @HtmlContent NVARCHAR(MAX),
    @IsPublic BIT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO PORTAL_PAGES (PortalID, PageName, Slug, HtmlContent, IsPublic, CreatedAt)
    VALUES (@PortalID, @PageName, @Slug, @HtmlContent, @IsPublic, GETDATE());
END;

GO


-- Delete Custom Form
CREATE PROCEDURE DeleteCustomForm
    @FormID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM CUSTOM_FORMS WHERE FormID = @FormID;
END;

GO


-- Delete Page Variable
CREATE PROCEDURE DeletePageVariable
    @VariableID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM PAGE_VARIABLES WHERE VariableID = @VariableID;
END;

GO


-- Delete Portal Page
CREATE PROCEDURE DeletePortalPage
    @PageID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM PORTAL_PAGES WHERE PageID = @PageID;
END;

GO


-- Get All Custom Forms
CREATE PROCEDURE GetAllCustomForms
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM CUSTOM_FORMS;
END;

GO


-- Get All Page Variables
CREATE PROCEDURE GetAllPageVariables
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM PAGE_VARIABLES;
END;

GO


-- Get All Portal Pages
CREATE PROCEDURE GetAllPortalPages
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM PORTAL_PAGES;
END;

GO


-- Get Custom Form By ID
CREATE PROCEDURE GetCustomFormById
    @FormID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM CUSTOM_FORMS WHERE FormID = @FormID;
END;

GO


-- Get Page Variable By ID
CREATE PROCEDURE GetPageVariableById
    @VariableID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM PAGE_VARIABLES WHERE VariableID = @VariableID;
END;

GO


-- Get Portal Page By ID
CREATE PROCEDURE GetPortalPageById
    @PageID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM PORTAL_PAGES WHERE PageID = @PageID;
END;

GO


-- Update Page Variable
CREATE PROCEDURE UpdatePageVariable
    @VariableID UNIQUEIDENTIFIER,
    @VariableValue NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE PAGE_VARIABLES
    SET VariableValue = @VariableValue
    WHERE VariableID = @VariableID;
END;

GO


-- Update Portal Page
CREATE PROCEDURE UpdatePortalPage
    @PageID UNIQUEIDENTIFIER,
    @PageName NVARCHAR(100),
    @Slug NVARCHAR(256),
    @HtmlContent NVARCHAR(MAX),
    @IsPublic BIT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE PORTAL_PAGES
    SET PageName = @PageName, Slug = @Slug, HtmlContent = @HtmlContent, IsPublic = @IsPublic
    WHERE PageID = @PageID;
END;

GO
