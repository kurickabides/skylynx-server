/*
  SkyLynx SQL Export
  Database: skylynx_portal_template
  Section: Triggers
  Generated: 2026-07-22T22:47:38.279Z
*/
GO


-- Trigger for validating PortalID in ANNOUNCEMENTS
CREATE TRIGGER trg_ValidatePortalID_Announcements
ON ANNOUNCEMENTS
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 FROM INSERTED i
        LEFT JOIN skylynxnet_coredb.dbo.Portals p ON i.PortalID = p.PortalID
        WHERE p.PortalID IS NULL
    )
    BEGIN
        RAISERROR('Invalid PortalID: The referenced Portal does not exist in skylynxnet_coredb.', 16, 1);
        ROLLBACK;
        RETURN;
    END;

    INSERT INTO ANNOUNCEMENTS (PortalID, CreatedDate, Title, URL, ExpireDate, Description, ViewOrder, CreatedByUser, PublishDate, ImageSource, Summary)
    SELECT PortalID, CreatedDate, Title, URL, ExpireDate, Description, ViewOrder, CreatedByUser, PublishDate, ImageSource, Summary FROM INSERTED;
END;

GO


-- Trigger for validating PortalID in CUSTOM_FORMS
CREATE TRIGGER trg_ValidatePortalID_Forms
ON CUSTOM_FORMS
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 FROM INSERTED i
        LEFT JOIN skylynxnet_coredb.dbo.Portals p ON i.PortalID = p.PortalID
        WHERE p.PortalID IS NULL
    )
    BEGIN
        RAISERROR('Invalid PortalID: The referenced Portal does not exist in skylynxnet_coredb.', 16, 1);
        ROLLBACK;
        RETURN;
    END;

    INSERT INTO CUSTOM_FORMS (FormID, PortalID, FormName, FormType, HtmlContent, CreatedAt)
    SELECT FormID, PortalID, FormName, FormType, HtmlContent, CreatedAt FROM INSERTED;
END;

GO


-- Trigger for validating PortalID in PAGE_VARIABLES
CREATE TRIGGER trg_ValidatePortalID_Variables
ON PAGE_VARIABLES
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 FROM INSERTED i
        LEFT JOIN skylynxnet_coredb.dbo.Portals p ON i.PortalID = p.PortalID
        WHERE p.PortalID IS NULL
    )
    BEGIN
        RAISERROR('Invalid PortalID: The referenced Portal does not exist in skylynxnet_coredb.', 16, 1);
        ROLLBACK;
        RETURN;
    END;

    INSERT INTO PAGE_VARIABLES (VariableID, PortalID, VariableName, VariableValue, CreatedAt)
    SELECT VariableID, PortalID, VariableName, VariableValue, CreatedAt FROM INSERTED;
END;

GO


-- =============================================
-- Triggers for Cross-Database Referential Integrity
-- =============================================

-- Trigger for validating PortalID in PORTAL_PAGES
CREATE TRIGGER trg_ValidatePortalID_Pages
ON PORTAL_PAGES
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 FROM INSERTED i
        LEFT JOIN skylynxnet_coredb.dbo.Portals p ON i.PortalID = p.PortalID
        WHERE p.PortalID IS NULL
    )
    BEGIN
        RAISERROR('Invalid PortalID: The referenced Portal does not exist in skylynxnet_coredb.', 16, 1);
        ROLLBACK;
        RETURN;
    END;

    INSERT INTO PORTAL_PAGES (PageID, PortalID, PageName, Slug, HtmlContent, IsPublic, CreatedAt)
    SELECT PageID, PortalID, PageName, Slug, HtmlContent, IsPublic, CreatedAt FROM INSERTED;
END;

GO
