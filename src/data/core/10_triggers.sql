/*
  SkyLynx SQL Export
  Database: skylynxnet_coredb
  Section: Triggers
  Generated: 2026-07-22T22:38:26.485Z
*/
GO

-- ================================================
-- ✅ Trigger 2: Validate value content matches declared ValueType (example for boolean + int)
-- ================================================
CREATE TRIGGER TR_ValidateSettings_ValueType
ON GlobalModuleSettings
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Boolean validation
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN SettingKeys sk ON sk.SettingKeyID = i.SettingKeyID
        WHERE sk.ValueType = 'boolean' AND i.Value NOT IN ('true', 'false')
    )
    BEGIN
        RAISERROR ('Invalid value for boolean setting.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Integer validation
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN SettingKeys sk ON sk.SettingKeyID = i.SettingKeyID
        WHERE sk.ValueType = 'int' AND TRY_CAST(i.Value AS INT) IS NULL
    )
    BEGIN
        RAISERROR ('Invalid value for int setting.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Add similar clauses for json, guid, etc., as needed
END;
GO

-- ================================================
-- ✅ Trigger: trg_ValidateLayoutType
-- Description: Ensures LayoutType value exists in LayoutTypes table
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE TRIGGER trg_ValidateLayoutType
ON skylynxnet_coredb.dbo.Layouts
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE i.LayoutType IS NOT NULL
        AND NOT EXISTS (
            SELECT 1
            FROM skylynxnet_coredb.dbo.LayoutTypes lt
            WHERE lt.LayoutTypeName = i.LayoutType
        )
    )
    BEGIN
        RAISERROR ('Invalid LayoutType. Must match an existing LayoutTypes.LayoutTypeName.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

-- ================================================
-- ✅ Trigger: trg_UpdatePortalLastModified
-- Description: Automatically updates LastUpdated field on row updates
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE TRIGGER trg_UpdatePortalLastModified
ON skylynxnet_coredb.dbo.Portals
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE P
    SET P.LastUpdated = GETDATE()
    FROM skylynxnet_coredb.dbo.Portals P
    INNER JOIN inserted I ON P.PortalID = I.PortalID;
END;
GO

-- ================================================
-- ✅ Trigger: trg_ValidateTemplateType
-- Description: Validates TemplateType in ProtosTemplate matches ProtosTargetType
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================

CREATE TRIGGER trg_ValidateTemplateType
ON skylynxnet_coredb.dbo.ProtosTemplate
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        LEFT JOIN skylynxnet_coredb.dbo.ProtosTargetType tt
            ON i.TemplateType = tt.TargetTypeName
        WHERE tt.TargetTypeName IS NULL
    )
    BEGIN
        RAISERROR (
          'Invalid TemplateType: Must match TargetTypeName in ProtosTargetType table.',
          16, 1
        );
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

CREATE TRIGGER trg_Validate_ProtosTemplateStatus
ON skylynxnet_coredb.dbo.ProtosTemplateVersion
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE i.StatusName IS NOT NULL
        AND NOT EXISTS (
            SELECT 1
            FROM skylynxnet_coredb.dbo.ProtosTemplateStatus s
            WHERE s.StatusName = i.StatusName
        )
    )
    BEGIN
        RAISERROR ('Invalid StatusName. No match found in ProtosTemplateStatus table.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO

-- ================================================
-- ✅ Trigger 1: Ensure ValueType exists in SystemValueTypes
-- ================================================
CREATE TRIGGER TR_ValidateSettingKey_ValueType
ON SettingKeys
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE NOT EXISTS (
            SELECT 1 FROM SystemValueTypes svt WHERE svt.ValueType = i.ValueType
        )
    )
    BEGIN
        RAISERROR ('Invalid ValueType. Must exist in SystemValueTypes.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO
