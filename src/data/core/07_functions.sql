/*
  SkyLynx SQL Export
  Database: skylynxnet_coredb
  Section: Functions
  Generated: 2026-07-22T22:38:02.880Z
*/
GO

--put SQL code below
-- ================================================
-- ✅ Function: fn_GetDefaultProviderForPortal
-- Description: Returns Portal's explicitly assigned default ProviderID
-- ================================================
CREATE   FUNCTION fn_GetDefaultProviderForPortal (
    @PortalID UNIQUEIDENTIFIER
)
RETURNS UNIQUEIDENTIFIER
AS
BEGIN
    DECLARE @ProviderID UNIQUEIDENTIFIER;

    -- Prefer portal-specific default
    SELECT TOP 1 @ProviderID = ProviderID
    FROM PortalProfileProviders
    WHERE PortalID = @PortalID AND IsPortalDefault = 1;

    RETURN @ProviderID;
END;
GO

--put SQL code below
-- ================================================
-- ✅ Function: fn_GetDefaultRolesForPortal
-- Description: Returns default RoleIDs for a given PortalID
-- ================================================
CREATE FUNCTION fn_GetDefaultRolesForPortal (
    @PortalID UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN
    SELECT RoleID
    FROM DefaultUserRoles
    WHERE PortalID = @PortalID
GO

--put SQL code below
CREATE FUNCTION fn_GetNextSkylynxUserID ()
RETURNS NVARCHAR(128)
AS
BEGIN
    DECLARE @NextNumber INT;
    DECLARE @NewUserID NVARCHAR(128);

    SELECT @NextNumber = ISNULL(MAX(CAST(SUBSTRING(Id, 6, LEN(Id)) AS INT)), 0) + 1
    FROM AspNetUsers
    WHERE Id LIKE 'SKYX-%' AND ISNUMERIC(SUBSTRING(Id, 6, LEN(Id))) = 1;

    SET @NewUserID = CONCAT('SKYX-', FORMAT(@NextNumber, '000000'));

    RETURN @NewUserID;
END;
GO

--put SQL code beloww
-- ================================================
-- ✅ Function: fn_GetSystemDefaultForProvider
-- Description: Returns IsSystemDefault from ProfileProviders
-- ================================================
CREATE   FUNCTION fn_GetSystemDefaultForProvider (
    @ProviderID UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    DECLARE @Default BIT;

    SELECT @Default = IsSystemDefault
    FROM ProfileProviders
    WHERE ProviderID = @ProviderID;

    RETURN ISNULL(@Default, 0);
END;
GO

-- =============================================
-- ✅ Function: fn_HashPlainKey
-- Description: Returns SHA-256 hash of input key
-- =============================================
CREATE   FUNCTION fn_HashPlainKey (
    @RawApiKey NVARCHAR(MAX)
)
RETURNS NVARCHAR(256)
AS
BEGIN
    DECLARE @KeyHash NVARCHAR(256);
    SELECT @KeyHash = CONVERT(NVARCHAR(256), HASHBYTES('SHA2_256', @RawApiKey), 2);
    RETURN @KeyHash;
END;
GO

--put SQL code below
CREATE   FUNCTION fn_IsValidAPIKey (
    @PortalID UNIQUEIDENTIFIER,
    @KeyHash NVARCHAR(256)
)
RETURNS BIT
AS
BEGIN
    DECLARE @IsValid BIT;

    SELECT TOP 1 @IsValid = IsActive
    FROM vw_ActiveAPIKeys
    WHERE PortalID = @PortalID
      AND KeyHash = @KeyHash;

    RETURN ISNULL(@IsValid, 0);  -- default to 0 if no match found
END;
GO

-- 🔹 GetOwnerTypeName (returns string)
CREATE   FUNCTION GetOwnerTypeName (@ApiKeyID UNIQUEIDENTIFIER)
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @OwnerTypeName NVARCHAR(50);

    SELECT @OwnerTypeName = OwnerTypeName
    FROM vw_AllAPIKeys
    WHERE ApiKeyID = @ApiKeyID;

    RETURN @OwnerTypeName;
END;
GO

-- 🔹 OwnerIsModule
CREATE   FUNCTION OwnerIsModule (@ApiKeyID UNIQUEIDENTIFIER)
RETURNS BIT
AS
BEGIN
    DECLARE @Result BIT = 0;

    IF EXISTS (
        SELECT 1
        FROM vw_AllAPIKeys
        WHERE ApiKeyID = @ApiKeyID AND OwnerTypeName = 'Module'
    )
        SET @Result = 1;

    RETURN @Result;
END;
GO

--put SQL code below
-- =============================================
-- ✅ Owner Type Helper Functions (from vw_AllAPIKeys)
-- =============================================

-- 🔹 OwnerIsPortal
CREATE   FUNCTION OwnerIsPortal (@ApiKeyID UNIQUEIDENTIFIER)
RETURNS BIT
AS
BEGIN
    DECLARE @Result BIT = 0;

    IF EXISTS (
        SELECT 1
        FROM vw_AllAPIKeys
        WHERE ApiKeyID = @ApiKeyID AND OwnerTypeName = 'Portal'
    )
        SET @Result = 1;

    RETURN @Result;
END;
GO

-- 🔹 OwnerIsUser
CREATE   FUNCTION OwnerIsUser (@ApiKeyID UNIQUEIDENTIFIER)
RETURNS BIT
AS
BEGIN
    DECLARE @Result BIT = 0;

    IF EXISTS (
        SELECT 1
        FROM vw_AllAPIKeys
        WHERE ApiKeyID = @ApiKeyID AND OwnerTypeName = 'User'
    )
        SET @Result = 1;

    RETURN @Result;
END;
GO
