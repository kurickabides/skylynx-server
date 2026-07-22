/*
  SkyLynx SQL Export
  Database: skylynxnet_coredb
  Section: Stored procedures
  Generated: 2026-07-22T22:38:02.882Z
*/
GO


CREATE PROCEDURE AssignModuleToPortal
    @ModuleID UNIQUEIDENTIFIER,
    @PortalID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO PortalModules (PortalModuleID, ModuleID, PortalID, CreatedAt)
    VALUES (NEWID(), @ModuleID, @PortalID, GETDATE());
END;

GO


CREATE PROCEDURE AssignUserRole
    @UserID NVARCHAR(128),
    @RoleID NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO AspNetUserRoles (UserId, RoleId) VALUES (@UserID, @RoleID);
END;

GO


CREATE PROCEDURE CancelSubscription
    @SubscriptionID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM SubscriptionPlans WHERE SubscriptionID = @SubscriptionID;
END;

GO

-- ================================================
-- ✅ CreateAddress
-- Description: Inserts a new address and returns the generated ID
-- ================================================
CREATE   PROCEDURE CreateAddress
    @Address1 NVARCHAR(MAX) = NULL,
    @Address2 NVARCHAR(MAX) = NULL,
    @City NVARCHAR(MAX) = NULL,
    @StateProvinceID UNIQUEIDENTIFIER = NULL,
    @Zip NVARCHAR(10) = NULL,
    @GeoLocation GEOGRAPHY = NULL,
    @IsMailing BIT = NULL,
    @AddyID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    SET @AddyID = NEWID();

    INSERT INTO Address (
        addyId, address_1, address_2, City, StateProvinceID,
        Zip, geoLocation, isMailing, ModifiedDate
    )
    VALUES (
        @AddyID, @Address1, @Address2, @City, @StateProvinceID,
        @Zip, @GeoLocation, @IsMailing, GETDATE()
    );

    SELECT @AddyID AS AddressID;
END;
GO

--put SQL code below

-- =============================================
-- ✅ CREATE PROCEDURE: CreateAPI_Owner
-- Inserts a new record into API_Owners
-- =============================================
CREATE PROCEDURE CreateAPI_Owner
    @UserID NVARCHAR(128),
    @ModuleID UNIQUEIDENTIFIER,
    @PortalID UNIQUEIDENTIFIER,
    @OwnerTypeID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO skylynxnet_coredb.dbo.API_Owners (OwnerUUID, UserID, ModuleID, PortalID, CreatedAt, OwnerTypeID)
    VALUES (NEWID(), @UserID, @ModuleID, @PortalID, GETDATE(), @OwnerTypeID);
END;
GO

--put SQL code below
CREATE PROCEDURE CreateApiKey
    @OwnerUUID UNIQUEIDENTIFIER,
    @ExpiresAt DATETIME = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- ✅ Step 1: Generate the raw API key (sent back to client)
    DECLARE @RawApiKey NVARCHAR(36) = CONVERT(NVARCHAR(36), NEWID());

    -- ✅ Step 2: Hash the key using fn_HashPlainKey
    DECLARE @KeyHash NVARCHAR(256) = dbo.fn_HashPlainKey(@RawApiKey);

    -- ✅ Step 3: Use raw key as deterministic ApiKeyID
    DECLARE @ApiKeyID UNIQUEIDENTIFIER = CONVERT(UNIQUEIDENTIFIER, @RawApiKey);

    -- ✅ Step 4: Insert into API_KEYS table (no OwnerTypeID now)
    INSERT INTO skylynxnet_coredb.dbo.API_KEYS (
        ApiKeyID, OwnerUUID, KeyHash, CreatedAt, ExpiresAt
    )
    VALUES (
        @ApiKeyID, @OwnerUUID, @KeyHash, GETDATE(), @ExpiresAt
    );

    -- ✅ Step 5: Return values for caller reference
    SELECT @ApiKeyID AS ApiKeyID, @RawApiKey AS PlainApiKey;
END;
GO

-- ================================================
-- ✅ Procedure: CreateAspNetUser
-- Description: Inserts a new record into AspNetUsers
-- ================================================
CREATE PROCEDURE CreateAspNetUser
(
    @UserID NVARCHAR(128) OUTPUT,
    @UserName NVARCHAR(256),
    @Email NVARCHAR(256),
    @PasswordHash NVARCHAR(MAX),
    @EmailConfirmed BIT = 0,
    @PhoneNumber NVARCHAR(50) = NULL,
    @PhoneNumberConfirmed BIT = 0,
    @TwoFactorEnabled BIT = 0,
    @AccessFailedCount INT = 0
)
AS
BEGIN
    SET NOCOUNT ON;
    SET @UserID = NEWID();

    INSERT INTO AspNetUsers (
        Id, UserName, Email, PasswordHash, EmailConfirmed,
        PhoneNumber, PhoneNumberConfirmed, TwoFactorEnabled, AccessFailedCount
    )
    VALUES (
        @UserID, @UserName, @Email, @PasswordHash, @EmailConfirmed,
        @PhoneNumber, @PhoneNumberConfirmed, @TwoFactorEnabled, @AccessFailedCount
    );
END;
GO


CREATE PROCEDURE CreateBankAccount
    @UserID NVARCHAR(128),
    @BankName NVARCHAR(100),
    @AccountHolderName NVARCHAR(100),
    @AccountNumberEncrypted VARBINARY(MAX),
    @RoutingNumber NVARCHAR(100),
    @AccountType NVARCHAR(50),
    @Currency NVARCHAR(10),
    @IsPrimary BIT,
    @VerificationStatus NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO BankAccounts (BankAccountID, UserID, BankName, AccountHolderName, AccountNumberEncrypted, RoutingNumber, AccountType, Currency, IsPrimary, VerificationStatus, CreatedAt)
    VALUES (NEWID(), @UserID, @BankName, @AccountHolderName, @AccountNumberEncrypted, @RoutingNumber, @AccountType, @Currency, @IsPrimary, @VerificationStatus, GETDATE());
END;

GO


-- =============================================
-- 🚀 Step 2: Create Stored Procedures
-- =============================================

-- ✅ Create a User Claim
CREATE PROCEDURE CreateClaim
    @UserID NVARCHAR(128),
    @ClaimType NVARCHAR(255),
    @ClaimValue NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO AspNetUserClaims (UserId, ClaimType, ClaimValue) VALUES (@UserID, @ClaimType, @ClaimValue);
END;

GO

--put SQL code below
-- ================================================
-- ✅ Stored Procedure: CreateDefaultUserRole
-- Description: Adds a default user role to a portal
-- ================================================
CREATE   PROCEDURE CreateDefaultUserRole
    @PortalID UNIQUEIDENTIFIER,
    @RoleID NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 FROM PortalRoles WHERE PortalID = @PortalID AND RoleID = @RoleID
    ) AND NOT EXISTS (
        SELECT 1 FROM DefaultUserRoles WHERE PortalID = @PortalID AND RoleID = @RoleID
    )
    BEGIN
        INSERT INTO DefaultUserRoles (PortalID, RoleID)
        VALUES (@PortalID, @RoleID);
    END
END;
GO

CREATE PROCEDURE dbo.CreateDyForm
(
    @FormID UNIQUEIDENTIFIER OUTPUT,
    @FormName NVARCHAR(100),
    @Description NVARCHAR(255) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    SET @FormID = NEWID();
    INSERT INTO dbo.DyForm (FormID, FormName, Description)
    VALUES (@FormID, @FormName, @Description);
END;
GO

-- ================================================
-- ✅ Stored Procedure: CreateDyFormDataSourceDefinition
-- Description: Create a new DyFormDataSourceDefinition
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE dbo.CreateDyFormDataSourceDefinition
    @DyFormDSDefinitionID UNIQUEIDENTIFIER OUTPUT,
    @SourceKey NVARCHAR(255),
    @IsDirectProperty BIT = 0,
    @SourcePath NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    SET @DyFormDSDefinitionID = NEWID();

    INSERT INTO dbo.DyFormDataSourceDefinition (
        DyFormDSDefinitionID,
        SourceKey,
        IsDirectProperty,
        SourcePath
    )
    VALUES (
        @DyFormDSDefinitionID,
        @SourceKey,
        @IsDirectProperty,
        @SourcePath
    );
END;
GO

CREATE PROCEDURE dbo.CreateDyFormDomain
(
    @DomainID UNIQUEIDENTIFIER OUTPUT,
    @Name NVARCHAR(100),
    @DomainTypeID UNIQUEIDENTIFIER,
    @Description NVARCHAR(255) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    SET @DomainID = NEWID();
    INSERT INTO dbo.DyFormDomains (DomainID, Name, DomainTypeID, Description)
    VALUES (@DomainID, @Name, @DomainTypeID, @Description);
END;
GO

CREATE PROCEDURE dbo.CreateDyFormDomainType
-- TODO: Copy parameters and logic from `CreateDyFormDomainType` or redefine clean
AS
BEGIN
    -- Placeholder logic, replace with actual logic
    PRINT 'Procedure CreateDyFormDomainType created.';
END;
GO

CREATE PROCEDURE dbo.CreateDyFormDomainValues
(
    @DomainValueID UNIQUEIDENTIFIER OUTPUT,
    @DomainID UNIQUEIDENTIFIER,
    @Value NVARCHAR(200),
    @Label NVARCHAR(200),
    @SortOrder INT
)
AS
BEGIN
    SET NOCOUNT ON;
    SET @DomainValueID = NEWID();
    INSERT INTO dbo.DyFormDomainValues (DomainValueID, DomainID, Value, Label, SortOrder)
    VALUES (@DomainValueID, @DomainID, @Value, @Label, @SortOrder);
END;
GO

CREATE PROCEDURE dbo.CreateDyFormExpression
(
    @DyFormExpressionID UNIQUEIDENTIFIER OUTPUT,
    @ResolverTypeID UNIQUEIDENTIFIER,
    @Expression NVARCHAR(MAX),
    @Description NVARCHAR(255)
)
AS
BEGIN
    SET NOCOUNT ON;

    SET @DyFormExpressionID = NEWID();

    INSERT INTO dbo.DyFormExpression (
        DyFormExpressionID,
        ResolverTypeID,
        Expression,
        Description
    )
    VALUES (
        @DyFormExpressionID,
        @ResolverTypeID,
        @Expression,
        @Description
    );
END;
GO

-- ================================================
-- ✅ Procedure: CreateDyFormField
-- Description: Create a DyFormField record
-- ================================================
CREATE PROCEDURE CreateDyFormField
    @DyFormFieldID UNIQUEIDENTIFIER OUTPUT,
    @FieldTypeID UNIQUEIDENTIFIER,
    @Tooltip NVARCHAR(255) = NULL,
    @Label NVARCHAR(255) = NULL,
    @DomainID UNIQUEIDENTIFIER = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET @DyFormFieldID = NEWID();

    INSERT INTO skylynxnet_coredb.dbo.DyFormField (
        DyFormFieldID, FieldTypeID, Tooltip, Label, DomainID
    )
    VALUES (
        @DyFormFieldID, @FieldTypeID, @Tooltip, @Label, @DomainID
    );
END;
GO

CREATE PROCEDURE dbo.CreateDyFormFieldRule
(
    @RuleID UNIQUEIDENTIFIER OUTPUT,
    @FieldID UNIQUEIDENTIFIER,
    @RuleTypeID UNIQUEIDENTIFIER,
    @ResolverTypeID UNIQUEIDENTIFIER,
    @RuleExpression NVARCHAR(MAX),
    @IsEnabled BIT,
    @Priority INT,
    @ErrorMessage NVARCHAR(255)
)
AS
BEGIN
    SET NOCOUNT ON;
    SET @RuleID = NEWID();
    INSERT INTO dbo.DyFormFieldRule (RuleID, FieldID, RuleTypeID, ResolverTypeID, RuleExpression, IsEnabled, Priority, ErrorMessage)
    VALUES (@RuleID, @FieldID, @RuleTypeID, @ResolverTypeID, @RuleExpression, @IsEnabled, @Priority, @ErrorMessage);
END;
GO

-- ================================================
-- ✅ Stored Procedure: CreateDyFormFieldSectionDefinition
-- Description: Create a new DyFormFieldSectionDefinition
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE dbo.CreateDyFormFieldSectionDefinition
    @SectionDefinitionID UNIQUEIDENTIFIER OUTPUT,
    @SectionID UNIQUEIDENTIFIER,
    @DyFormFieldID UNIQUEIDENTIFIER,
    @ViewModelDefinitionID UNIQUEIDENTIFIER,
    @SortOrder INT = 0,
    @DyFormDSDefinitionID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    SET @SectionDefinitionID = NEWID();

    INSERT INTO dbo.DyFormFieldSectionDefinition (
        SectionDefinitionID,
        SectionID,
        DyFormFieldID,
        ViewModelDefinitionID,
        SortOrder,
        DyFormDSDefinitionID
    )
    VALUES (
        @SectionDefinitionID,
        @SectionID,
        @DyFormFieldID,
        @ViewModelDefinitionID,
        @SortOrder,
        @DyFormDSDefinitionID
    );
END;
GO

CREATE PROCEDURE dbo.CreateDyFormFieldType
(
    @FieldTypeID UNIQUEIDENTIFIER OUTPUT,
    @FieldTypeName NVARCHAR(100),
    @ComponentName NVARCHAR(100)
)
AS
BEGIN
    SET NOCOUNT ON;
    SET @FieldTypeID = NEWID();
    INSERT INTO dbo.DyFormFieldType (FieldTypeID, FieldTypeName, ComponentName)
    VALUES (@FieldTypeID, @FieldTypeName, @ComponentName);
END;
GO

-- ================================================
-- ✅ Procedure: CreateDyFormResolver
-- Description: Insert a new DyFormResolver row
-- ================================================
CREATE PROCEDURE dbo.CreateDyFormResolver
    @DyFormID UNIQUEIDENTIFIER,
    @ResolverContext NVARCHAR(50),
    @ResolverTypeID UNIQUEIDENTIFIER,
    @ResolverTarget NVARCHAR(255),
    @Description NVARCHAR(1000) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.DyFormResolvers (
        DyFormID, ResolverContext, ResolverTypeID, ResolverTarget, Description
    )
    VALUES (
        @DyFormID, @ResolverContext, @ResolverTypeID, @ResolverTarget, @Description
    );
END;
GO

CREATE PROCEDURE dbo.CreateDyFormResolverType
(
    @ResolverTypeID UNIQUEIDENTIFIER OUTPUT,
    @Name NVARCHAR(100),
    @Description NVARCHAR(255)
)
AS
BEGIN
    SET NOCOUNT ON;
    SET @ResolverTypeID = NEWID();
    INSERT INTO dbo.DyFormResolverType (ResolverTypeID, Name, Description)
    VALUES (@ResolverTypeID, @Name, @Description);
END;
GO

CREATE PROCEDURE dbo.CreateDyFormRuleDefinition
    @RuleDefinitionID UNIQUEIDENTIFIER OUTPUT,
    @RuleKey NVARCHAR(100),
    @ResolverTypeID UNIQUEIDENTIFIER,
    @DyFormExpressionID UNIQUEIDENTIFIER,
    @Description NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET @RuleDefinitionID = NEWID();

    INSERT INTO dbo.DyFormRuleDefinition (
        RuleDefinitionID, RuleKey, ResolverTypeID, DyFormExpressionID, Description
    )
    VALUES (
        @RuleDefinitionID, @RuleKey, @ResolverTypeID, @DyFormExpressionID, @Description
    );
END;
GO

-- Create Rule Syntax
-- ================================================
-- ✅ Stored Procedure: CreateDyFormRuleSyntax
-- ================================================
CREATE PROCEDURE dbo.CreateDyFormRuleSyntax
(
    @RuleSyntaxID UNIQUEIDENTIFIER OUTPUT,  -- Output for generated RuleSyntaxID
    @SyntaxName NVARCHAR(100),              -- Syntax Name for the rule
    @Description NVARCHAR(255) = NULL       -- Optional Description for the rule
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Generate a new unique identifier for the RuleSyntaxID
    SET @RuleSyntaxID = NEWID();  -- Generates a new unique identifier for the rule

    -- Insert the new rule syntax into the table
    INSERT INTO skylynxnet_coredb.dbo.DyFormRuleSyntax (RuleSyntaxID, SyntaxName, Description)
    VALUES (@RuleSyntaxID, @SyntaxName, @Description);
END;
GO

-- ✅ CREATE
CREATE PROCEDURE dbo.CreateDyFormRuleTarget
    @RuleTargetID UNIQUEIDENTIFIER OUTPUT,
    @RuleDefinitionID UNIQUEIDENTIFIER,
    @ViewModelDefinitionID UNIQUEIDENTIFIER,
    @DyFormFieldID UNIQUEIDENTIFIER = NULL,
    @SectionID UNIQUEIDENTIFIER = NULL,
    @SortOrder INT = 0,
    @Notes NVARCHAR(1000) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET @RuleTargetID = NEWID();

    INSERT INTO dbo.DyFormRuleTarget (
        RuleTargetID, RuleDefinitionID, ViewModelDefinitionID, 
        DyFormFieldID, SectionID, SortOrder, Notes)
    VALUES (
        @RuleTargetID, @RuleDefinitionID, @ViewModelDefinitionID,
        @DyFormFieldID, @SectionID, @SortOrder, @Notes);
END;
GO

CREATE PROCEDURE dbo.CreateDyFormRuleType
(
    @RuleTypeID UNIQUEIDENTIFIER OUTPUT,
    @Name NVARCHAR(100),
    @Description NVARCHAR(255)
)
AS
BEGIN
    SET NOCOUNT ON;
    SET @RuleTypeID = NEWID();
    INSERT INTO dbo.DyFormRuleType (RuleTypeID, Name, Description)
    VALUES (@RuleTypeID, @Name, @Description);
END;
GO

CREATE PROCEDURE dbo.CreateDyFormSection
    @SectionID UNIQUEIDENTIFIER OUTPUT,
    @SectionName NVARCHAR(100),
    @Label NVARCHAR(255) = NULL,
    @SortOrder INT = 0
AS
BEGIN
    SET NOCOUNT ON;

    SET @SectionID = NEWID();

    INSERT INTO dbo.DyFormSection (SectionID, SectionName, Label, SortOrder)
    VALUES (@SectionID, @SectionName, @Label, @SortOrder);
END;
GO

CREATE PROCEDURE dbo.CreateDyFormSectionResolver
(
    @DyFormID UNIQUEIDENTIFIER,
    @SectionID UNIQUEIDENTIFIER,
    @ResolverContext NVARCHAR(50),
    @ResolverTypeID UNIQUEIDENTIFIER,
    @ResolverTarget NVARCHAR(255),
    @IsActive BIT = 1,
    @Notes NVARCHAR(1000) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.DyFormSectionResolvers
    (DyFormID, SectionID, ResolverContext, ResolverTypeID, ResolverTarget, IsActive, Notes)
    VALUES
    (@DyFormID, @SectionID, @ResolverContext, @ResolverTypeID, @ResolverTarget, @IsActive, @Notes);
END;
GO

-- ================================================
-- ✅ Procedure: CreateDyFormSections
-- Description: Insert section relationship into DyFormSections
-- ================================================
CREATE PROCEDURE dbo.CreateDyFormSections
(
    @FormSectionID UNIQUEIDENTIFIER OUTPUT,
    @FormID UNIQUEIDENTIFIER,
    @SectionID UNIQUEIDENTIFIER,
    @ParentFormSectionID UNIQUEIDENTIFIER = NULL,
    @SortOrder INT = 0
)
AS
BEGIN
    SET NOCOUNT ON;
    SET @FormSectionID = NEWID();

    INSERT INTO dbo.DyFormSections (
        FormSectionID,
        FormID,
        SectionID,
        ParentFormSectionID,
        SortOrder
    )
    VALUES (
        @FormSectionID,
        @FormID,
        @SectionID,
        @ParentFormSectionID,
        @SortOrder
    );
END;
GO

CREATE PROCEDURE CreateDyFormViewModelDefinition
    @ViewModelDefinitionID UNIQUEIDENTIFIER OUTPUT,
    @ViewModelName NVARCHAR(100),
    @DestKey NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    SET @ViewModelDefinitionID = NEWID();

    INSERT INTO DyFormViewModelDefinition (
        ViewModelDefinitionID,
        ViewModelName,
        DestKey
    )
    VALUES (
        @ViewModelDefinitionID,
        @ViewModelName,
        @DestKey
    );
END;
GO

-- ================================================
-- ✅ CRUD Stored Procedures for GlobalModuleSettings
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================

-- ================================================
-- 1️⃣ CREATE
-- ================================================
CREATE PROCEDURE dbo.CreateGlobalModuleSetting
(
    @ModuleID UNIQUEIDENTIFIER,
    @SettingKeyID UNIQUEIDENTIFIER,
    @RoleID NVARCHAR(128),
    @Value NVARCHAR(MAX)
)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.GlobalModuleSettings (ModuleID, SettingKeyID, RoleID, Value, UpdatedAt)
    VALUES (@ModuleID, @SettingKeyID, @RoleID, @Value, GETDATE());
END;
GO

-- ================================================
-- ✅ Stored Procedure: CreateGlobalPortalSetting
-- Description: Inserts a new global portal setting
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE CreateGlobalPortalSetting
  @SettingKeyID UNIQUEIDENTIFIER,
  @Value NVARCHAR(MAX)
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO GlobalPortalSettings (SettingKeyID, Value, UpdatedAt)
  VALUES (@SettingKeyID, @Value, GETDATE());
END;
GO

CREATE PROCEDURE CreateLanguage
    @LanguageCode NVARCHAR(2),
    @LanguageName NVARCHAR(100)
AS
BEGIN
    INSERT INTO ISO6391_Languages (LanguageCode, LanguageName)
    VALUES (@LanguageCode, @LanguageName);
END;
GO

CREATE PROCEDURE dbo.CreateLayout
(
    @LayoutID UNIQUEIDENTIFIER OUTPUT,
    @DisplayName NVARCHAR(255),
    @LayoutType NVARCHAR(100) = NULL,
    @Description NVARCHAR(255) = NULL,
    @HasSidebar BIT = 1,
    @HasHeader BIT = 1,
    @HasFooter BIT = 1,
    @HasNavigation BIT = 1,
    @HasContentPane BIT = 1,
    @StyledID UNIQUEIDENTIFIER = NULL,
    @componentName NVARCHAR(255) = NULL,
    @componentPath NVARCHAR(255) = NULL,
    @ComponentConfig NVARCHAR(MAX) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    SET @LayoutID = NEWID();

    INSERT INTO dbo.Layouts (
        LayoutID,
        DisplayName,
        LayoutType,
        Description,
        HasSidebar,
        HasHeader,
        HasFooter,
        HasNavigation,
        HasContentPane,
        CreatedAt,
        StyledID,
        componentName,
        componentPath,
        ComponentConfig
    )
    VALUES (
        @LayoutID,
        @DisplayName,
        @LayoutType,
        @Description,
        @HasSidebar,
        @HasHeader,
        @HasFooter,
        @HasNavigation,
        @HasContentPane,
        GETDATE(),
        @StyledID,
        @componentName,
        @componentPath,
        @ComponentConfig
    );
END;
GO

CREATE PROCEDURE dbo.CreateModule
(
    @ModuleID UNIQUEIDENTIFIER OUTPUT,
    @ModuleName NVARCHAR(50),
    @ModuleDescription NVARCHAR(100),
    @ImageFilePath NVARCHAR(MAX),
    @ModuleVersion INT,
    @componentPath NVARCHAR(255),
    @componentName NVARCHAR(255) = NULL,
    @ComponentConfig NVARCHAR(MAX) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    SET @ModuleID = NEWID();

    INSERT INTO dbo.Modules (
        ModuleID,
        ModuleName,
        ModuleDescription,
        ImageFilePath,
        ModuleVersion,
        componentPath,
        CreatedOnDate,
        componentName,
        ComponentConfig
    )
    VALUES (
        @ModuleID,
        @ModuleName,
        @ModuleDescription,
        @ImageFilePath,
        @ModuleVersion,
        @componentPath,
        GETDATE(),
        @componentName,
        @ComponentConfig
    );
END;
GO

-- ================================================
-- ✅ Stored Procedure: CreateModuleSetting
-- Description: Creates new setting for module+role+key
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE CreateModuleSetting
  @PortalModuleID UNIQUEIDENTIFIER,
  @SettingKeyID UNIQUEIDENTIFIER,
  @RoleID NVARCHAR(128),
  @Value NVARCHAR(MAX)
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO ModuleSettings (PortalModuleID, SettingKeyID, RoleID, Value, UpdatedAt)
  VALUES (@PortalModuleID, @SettingKeyID, @RoleID, @Value, GETDATE());
END;
GO


CREATE PROCEDURE CreateOwnerType
    @OwnerTypeName NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO OwnerTypes (OwnerTypeID, OwnerTypeName) VALUES (NEWID(), @OwnerTypeName);
END;

GO

CREATE PROCEDURE dbo.CreatePageDefinition
(
    @PageID UNIQUEIDENTIFIER OUTPUT,
    @RoutePath NVARCHAR(255),
    @PageTitle NVARCHAR(100) = NULL,
    @MenuIcon NVARCHAR(100) = NULL,
    @RequiresAuth BIT = 1,
    @RoleID NVARCHAR(128) = NULL,
    @Notes NVARCHAR(255) = NULL,
    @componentName NVARCHAR(255) = NULL,
    @componentPath NVARCHAR(255) = NULL,
    @ComponentConfig NVARCHAR(MAX) = NULL,
    @StyledID UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    SET @PageID = NEWID();

    INSERT INTO dbo.PageDefinition (
        PageID,
        RoutePath,
        PageTitle,
        MenuIcon,
        RequiresAuth,
        RoleID,
        Notes,
        CreatedAt,
        componentName,
        componentPath,
        ComponentConfig,
        StyledID
    )
    VALUES (
        @PageID,
        @RoutePath,
        @PageTitle,
        @MenuIcon,
        @RequiresAuth,
        @RoleID,
        @Notes,
        GETDATE(),
        @componentName,
        @componentPath,
        @ComponentConfig,
        @StyledID
    );
END;
GO

CREATE PROCEDURE CreatePortal 
    @PortalID UNIQUEIDENTIFIER,
    @PortalName NVARCHAR(100),
    @Description NVARCHAR(MAX),
    @OwnerID NVARCHAR(128),
    @SplashImage NVARCHAR(255) = NULL,
    @Status NVARCHAR(50) = 'Draft'
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO skylynxnet_coredb.dbo.Portals 
    (PortalID, PortalName, Description, CreatedDate, SplashImage, Status, LastUpdated)
    VALUES 
    (@PortalID, @PortalName, @Description, GETDATE(), @SplashImage, @Status, GETDATE());

    INSERT INTO skylynxnet_coredb.dbo.PortalOwners (UserID, PortalID)
    VALUES (@OwnerID, @PortalID);
END;
GO

-- ================================================
-- ✅ Stored Procedure: CreatePortalProfileProvider
-- Description: Adds a new PortalProfileProvider entry.
-- If @IsPortalDefault is NULL, it uses IsSystemDefault from ProfileProviders.
-- ================================================
CREATE   PROCEDURE CreatePortalProfileProvider
    @PortalID UNIQUEIDENTIFIER,
    @ProviderID UNIQUEIDENTIFIER,
    @IsPortalDefault BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @IsPortalDefault IS NULL
        SET @IsPortalDefault = dbo.fn_GetSystemDefaultForProvider(@ProviderID);

    INSERT INTO PortalProfileProviders (
        PortalID,
        ProviderID,
        IsPortalDefault,
        CreatedAt
    )
    VALUES (
        @PortalID,
        @ProviderID,
        @IsPortalDefault,
        GETDATE()
    );
END;
GO

--put SQL code below
-- ================================================
-- ✅ Stored Procedure: CreatePortalRole
-- Description: Adds a role to a portal
-- ================================================
CREATE   PROCEDURE CreatePortalRole
    @PortalID UNIQUEIDENTIFIER,
    @RoleID NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1 FROM PortalRoles WHERE PortalID = @PortalID AND RoleID = @RoleID
    )
    BEGIN
        INSERT INTO PortalRoles (PortalID, RoleID)
        VALUES (@PortalID, @RoleID);
    END
END;
GO

CREATE PROCEDURE CreateProfileProvider
    @ProviderName NVARCHAR(100),
    @IsSystemDefault BIT = 0,
    @Description NVARCHAR(255) = NULL
AS
BEGIN
    INSERT INTO ProfileProviders (ProviderID, ProviderName, IsSystemDefault, Description)
    VALUES (NEWID(), @ProviderName, @IsSystemDefault, @Description);
END;
GO

-- ================================================
-- ✅ Stored Procedure: CreateProtosDataModel
-- Description: Inserts a new ProtosDataModelDefinition record
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE dbo.CreateProtosDataModel
(
    @DataModelID UNIQUEIDENTIFIER OUTPUT,
    @DataModelName NVARCHAR(100),
    @DataModelJSON NVARCHAR(MAX) = NULL,
    @Description NVARCHAR(255) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    SET @DataModelID = NEWID();

    INSERT INTO dbo.ProtosDataModelDefinition (
        DataModelID,
        DataModelName,
        DataModelJSON,
        Description,
        CreatedAt,
        UpdatedAt
    )
    VALUES (
        @DataModelID,
        @DataModelName,
        @DataModelJSON,
        @Description,
        GETDATE(),
        GETDATE()
    );
END;
GO

-- ================================================
-- ✅ ProtosTargetType CRUD Procedures
-- ================================================
-- Create ProtosTargetType
CREATE PROCEDURE dbo.CreateProtosTargetType
(
    @TargetTypeID UNIQUEIDENTIFIER OUTPUT,
    @TargetTypeName NVARCHAR(100),
    @Description NVARCHAR(255) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    SET @TargetTypeID = NEWID();
    INSERT INTO skylynxnet_coredb.dbo.ProtosTargetType (TargetTypeID, TargetTypeName, Description)
    VALUES (@TargetTypeID, @TargetTypeName, @Description);
END;
GO

-- ================================================
-- ✅ ProtosTemplate CRUD Stored Procedures
-- ================================================
-- Create ProtosTemplate
CREATE PROCEDURE dbo.CreateProtosTemplate
(
    @TemplateID UNIQUEIDENTIFIER OUTPUT,
    @TemplateName NVARCHAR(100),
    @TemplateType NVARCHAR(50),
    @Description NVARCHAR(255) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    SET @TemplateID = NEWID();
    INSERT INTO skylynxnet_coredb.dbo.ProtosTemplate (TemplateID, TemplateName, TemplateType, Description)
    VALUES (@TemplateID, @TemplateName, @TemplateType, @Description);
END;
GO

-- ================================================
-- ✅ ProtosTemplateLineage CRUD Stored Procedures
-- ================================================
-- Create ProtosTemplateLineage
CREATE PROCEDURE dbo.CreateProtosTemplateLineage
(
    @LineageID UNIQUEIDENTIFIER OUTPUT,
    @ParentVersionID UNIQUEIDENTIFIER,
    @ChildVersionID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;
    SET @LineageID = NEWID();
    INSERT INTO skylynxnet_coredb.dbo.ProtosTemplateLineage (LineageID, ParentVersionID, ChildVersionID)
    VALUES (@LineageID, @ParentVersionID, @ChildVersionID);
END;
GO

CREATE PROCEDURE dbo.CreateProtosTemplateLink
(
    @TemplateLinkID UNIQUEIDENTIFIER OUTPUT,
    @TemplateVersionID UNIQUEIDENTIFIER,
    @TargetObjectID UNIQUEIDENTIFIER,
    @TargetTypeID UNIQUEIDENTIFIER,
    @IsDefault BIT = 0,
    @OverrideJSON NVARCHAR(MAX) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    SET @TemplateLinkID = NEWID();

    INSERT INTO ProtosTemplateLink (
        TemplateLinkID,
        TemplateVersionID,
        TargetObjectID,
        TargetTypeID,
        IsDefault,
        OverrideJSON
    )
    VALUES (
        @TemplateLinkID,
        @TemplateVersionID,
        @TargetObjectID,
        @TargetTypeID,
        @IsDefault,
        @OverrideJSON
    );
END;
GO

-- ================================================
-- ✅ ProtosTemplateStatus CRUD Procedures
-- ================================================
-- Create ProtosTemplateStatus
CREATE PROCEDURE dbo.CreateProtosTemplateStatus
(
    @TemplateStatusID UNIQUEIDENTIFIER OUTPUT,
    @StatusName NVARCHAR(100),
    @Description NVARCHAR(255) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;
    SET @TemplateStatusID = NEWID();
    INSERT INTO skylynxnet_coredb.dbo.ProtosTemplateStatus (TemplateStatusID, StatusName, Description)
    VALUES (@TemplateStatusID, @StatusName, @Description);
END;
GO

CREATE PROCEDURE dbo.CreateProtosTemplateVersion
(
    @TemplateVersionID UNIQUEIDENTIFIER OUTPUT,
    @TemplateID UNIQUEIDENTIFIER,
    @VersionNumber INT,
    @VersionLabel NVARCHAR(50),
    @StatusName NVARCHAR(100)
)
AS
BEGIN
    SET NOCOUNT ON;
    SET @TemplateVersionID = NEWID();

    INSERT INTO dbo.ProtosTemplateVersion (
        TemplateVersionID,
        TemplateID,
        VersionNumber,
        VersionLabel,
        StatusName,
        CreatedAt,
        UpdatedAt
    )
    VALUES (
        @TemplateVersionID,
        @TemplateID,
        @VersionNumber,
        @VersionLabel,
        @StatusName,
        GETDATE(),
        GETDATE()
    );
END;
GO

CREATE PROCEDURE CreateProviderProfileField
    @ProviderID UNIQUEIDENTIFIER,
    @FieldName NVARCHAR(100),
    @FieldTypeID UNIQUEIDENTIFIER,
    @IsRequired BIT
AS
BEGIN
    INSERT INTO ProviderProfileFields (FieldID, ProviderID, FieldName, FieldTypeID, IsRequired)
    VALUES (NEWID(), @ProviderID, @FieldName, @FieldTypeID, @IsRequired);
END;
GO

-- Step 4: Recreate the stored procedure using the updated type
CREATE PROCEDURE CreateProviderProfileFields
    @ProviderID UNIQUEIDENTIFIER,
    @FieldList dbo.ProviderProfileFieldListType READONLY
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO ProviderProfileFields (FieldID, ProviderID, FieldName, FieldTypeID, IsRequired, SortOrder)
    SELECT NEWID(), @ProviderID, FieldName, FieldTypeID, IsRequired, SortOrder
    FROM @FieldList;
END;
GO

-- ================================================
-- ✅ Create: Insert FieldType
-- ================================================
CREATE PROCEDURE CreateProviderProfileFieldType
  @FieldTypeName NVARCHAR(100),
  @Description NVARCHAR(255)
AS
BEGIN
  INSERT INTO ProviderProfileFieldType (FieldTypeID, FieldTypeName, Description, CreatedAt, UpdatedAt)
  VALUES (NEWID(), @FieldTypeName, @Description, GETDATE(), GETDATE());
END;
GO

CREATE PROCEDURE dbo.CreateResolver
  @ResolverID UNIQUEIDENTIFIER OUTPUT,
  @ResolverType NVARCHAR(100),
  @Target NVARCHAR(MAX),
  @Description NVARCHAR(255) = NULL
AS
BEGIN
  SET NOCOUNT ON;

  SET @ResolverID = NEWID();

  INSERT INTO dbo.Resolvers (ResolverID, ResolverType, Target, Description)
  VALUES (@ResolverID, @ResolverType, @Target, @Description);
END;
GO


CREATE PROCEDURE CreateRole
    @RoleName NVARCHAR(256)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO AspNetRoles (Id, Name) VALUES (NEWID(), @RoleName);
END;

GO

-- ================================================
-- ✅ Stored Procedure: CreateSettingKey
-- Description: Inserts a new setting key
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE CreateSettingKey
  @SettingKeyID UNIQUEIDENTIFIER OUTPUT,
  @KeyName NVARCHAR(100),
  @Label NVARCHAR(255) = NULL,
  @ValueType NVARCHAR(50),
  @DomainID UNIQUEIDENTIFIER = NULL
AS
BEGIN
  SET NOCOUNT ON;

  SET @SettingKeyID = NEWID();

  INSERT INTO SettingKeys (SettingKeyID, KeyName, Label, ValueType, DomainID)
  VALUES (@SettingKeyID, @KeyName, @Label, @ValueType, @DomainID);
END;

GO


CREATE PROCEDURE CreateSubscription
    @UserID NVARCHAR(128),
    @SubscriptionPlanID UNIQUEIDENTIFIER,
    @StartDate DATETIME,
    @EndDate DATETIME
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO SubscriptionPlans (SubscriptionID, UserID, SubscriptionPlanID, StartDate, EndDate, CreatedAt)
    VALUES (NEWID(), @UserID, @SubscriptionPlanID, @StartDate, @EndDate, GETDATE());
END;

GO

-- ================================================
-- ✅ Stored Procedure: CreateSystemValueType
-- Description: Inserts a new system value type record
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE CreateSystemValueType
  @ValueType NVARCHAR(50),
  @Description NVARCHAR(255) = NULL,
  @IsStructured BIT = 0
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO SystemValueTypes (ValueType, Description, IsStructured, CreatedAt)
  VALUES (@ValueType, @Description, @IsStructured, GETDATE());
END;
GO

-- ================================================
-- ✅ Stored Procedure: CreateThemeDefinition
-- Description: Inserts a new ThemeDefinition record
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE dbo.CreateThemeDefinition
(
    @ThemeDefinitionID UNIQUEIDENTIFIER OUTPUT,
    @ThemeName NVARCHAR(100),
    @DisplayName NVARCHAR(255) = NULL,
    @ThemeOption NVARCHAR(100) = NULL,
    @IsBase BIT = 0,
    @Description NVARCHAR(255) = NULL,
    @componentName NVARCHAR(255) = NULL,
    @componentPath NVARCHAR(255) = NULL,
    @ComponentConfig NVARCHAR(MAX) = NULL,
    @DefaultMode NVARCHAR(10) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    SET @ThemeDefinitionID = NEWID();

    INSERT INTO dbo.ThemeDefinitions (
        ThemeDefinitionID, ThemeName, DisplayName, ThemeOption, IsBase, Description,
        componentName, componentPath, ComponentConfig, DefaultMode
    )
    VALUES (
        @ThemeDefinitionID, @ThemeName, @DisplayName, @ThemeOption, @IsBase, @Description,
        @componentName, @componentPath, @ComponentConfig, @DefaultMode
    );
END;
GO


CREATE PROCEDURE CreateTransaction
    @UserID NVARCHAR(128),
    @PaymentMethodID UNIQUEIDENTIFIER,
    @Amount DECIMAL(18,2),
    @Currency NVARCHAR(10),
    @Status NVARCHAR(50),
    @TransactionReference NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Transactions (TransactionID, UserID, PaymentMethodID, Amount, Currency, Status, TransactionReference, CreatedAt)
    VALUES (NEWID(), @UserID, @PaymentMethodID, @Amount, @Currency, @Status, @TransactionReference, GETDATE());
END;

GO

-- ================================================
-- ✅ Stored Procedure: CreateUser
-- Description: Inserts a new user with optional custom ID
-- ================================================
CREATE   PROCEDURE CreateUser
    @UserID NVARCHAR(128) = NULL OUTPUT,
    @UserName NVARCHAR(256),
    @Email NVARCHAR(256),
    @PasswordHash NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    IF @UserID IS NULL
        SET @UserID = dbo.fn_GetNextSkylynxUserID();

    INSERT INTO AspNetUsers (
        Id, UserName, Email, EmailConfirmed,
        PasswordHash, SecurityStamp, PhoneNumberConfirmed,
        TwoFactorEnabled, LockoutEnabled, AccessFailedCount
    )
    VALUES (
        @UserID, @UserName, @Email, 0,
        @PasswordHash, NEWID(), 0,
        0, 1, 0
    );

    SELECT @UserID AS NewUserID;
END;
GO


-- ✅ Create a User Login Provider
CREATE PROCEDURE CreateUserLogin
    @UserID NVARCHAR(128),
    @LoginProvider NVARCHAR(128),
    @ProviderKey NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO AspNetUserLogins (UserId, LoginProvider, ProviderKey) VALUES (@UserID, @LoginProvider, @ProviderKey);
END;

GO

CREATE PROCEDURE CreateUserProfile
    @UserID NVARCHAR(128),
    @ProviderID UNIQUEIDENTIFIER,
    @PortalID UNIQUEIDENTIFIER,
    @BillingAddressID UNIQUEIDENTIFIER = NULL,
    @AddressID UNIQUEIDENTIFIER = NULL
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO UserProfiles (UserID, ProviderID, PortalID, BillingAddressID, AddressID, CreatedAt, UpdatedAt)
    VALUES (@UserID, @ProviderID, @PortalID, @BillingAddressID, @AddressID, GETDATE(), GETDATE());
END;
GO

--put SQL code beloww
-- ================================================
-- ✅ Stored Procedure: CreateUserProfileIfMissing
-- Description: Creates an empty UserProfile for a user if one doesn't exist
-- ================================================
CREATE   PROCEDURE CreateUserProfileIfMissing
    @UserID NVARCHAR(128)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM UserProfiles WHERE UserID = @UserID)
    BEGIN
        INSERT INTO UserProfiles (UserID, CreatedAt)
        VALUES (@UserID, GETDATE());
    END
END;
GO

CREATE PROCEDURE CreateUserProviderProfileData
    @UserID NVARCHAR(128),
    @ProviderID UNIQUEIDENTIFIER,
    @FieldID UNIQUEIDENTIFIER,
    @FieldValue NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO UserProviderProfiles (UserID, ProviderID, FieldID, FieldValue)
    VALUES (@UserID, @ProviderID, @FieldID, @FieldValue);
END;
GO

CREATE PROCEDURE CreateUserSignUp
    @PortalName NVARCHAR(256),
    @ProviderName NVARCHAR(256) = NULL,
    @UserID NVARCHAR(128) = NULL OUTPUT,
    @UserName NVARCHAR(256),
    @Email NVARCHAR(256),
    @PasswordHash NVARCHAR(MAX),
    @ProfileFields UserProfileField READONLY
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @PortalID UNIQUEIDENTIFIER;
        DECLARE @ProviderID UNIQUEIDENTIFIER;
        DECLARE @AddyID UNIQUEIDENTIFIER;
        DECLARE @DefaultRoleID NVARCHAR(128);

        -- Step 1: Resolve Portal and Provider
        IF @ProviderName IS NOT NULL
        BEGIN
            EXEC GetPortalProfileProviderByKeys
                @PortalName = @PortalName,
                @ProviderName = @ProviderName,
                @PortalID = @PortalID OUTPUT,
                @ProviderID = @ProviderID OUTPUT;
        END
        ELSE
        BEGIN
            EXEC GetDefaultProviderByPortalName
                @PortalName = @PortalName,
                @PortalID = @PortalID OUTPUT,
                @ProviderID = @ProviderID OUTPUT;
        END

        -- Step 2: Create the User
        EXEC CreateUser
            @UserID = @UserID OUTPUT,
            @UserName = @UserName,
            @Email = @Email,
            @PasswordHash = @PasswordHash;

        -- Step 3: Get Default Role ID and Assign
        EXEC GetDefaultUserRole
            @PortalID = @PortalID,
            @RoleID = @DefaultRoleID OUTPUT;

        IF @DefaultRoleID IS NOT NULL
        BEGIN
            EXEC AssignUserRole
                @UserID = @UserID,
                @RoleID = @DefaultRoleID;
        END

        -- Step 4: Create Blank Mailing Address
        EXEC CreateAddress
            @Address1 = NULL,
            @Address2 = NULL,
            @City = NULL,
            @StateProvinceID = NULL,
            @Zip = NULL,
            @GeoLocation = NULL,
            @IsMailing = 1,
            @AddyID = @AddyID OUTPUT;

        -- Step 5: Create UserProfile
        EXEC CreateUserProfile
            @UserID = @UserID,
            @ProviderID = @ProviderID,
            @PortalID = @PortalID,
            @AddressID = @AddyID;

        -- Step 6: Insert Profile Fields
        IF EXISTS (SELECT 1 FROM @ProfileFields)
        BEGIN
            DECLARE @FieldID UNIQUEIDENTIFIER, @FieldValue NVARCHAR(MAX);
            DECLARE profile_cursor CURSOR FOR
                SELECT FieldID, FieldValue FROM @ProfileFields;

            OPEN profile_cursor;
            FETCH NEXT FROM profile_cursor INTO @FieldID, @FieldValue;

            WHILE @@FETCH_STATUS = 0
            BEGIN
                EXEC CreateUserProviderProfileData
                    @UserID = @UserID,
                    @ProviderID = @ProviderID,
                    @FieldID = @FieldID,
                    @FieldValue = @FieldValue;

                FETCH NEXT FROM profile_cursor INTO @FieldID, @FieldValue;
            END

            CLOSE profile_cursor;
            DEALLOCATE profile_cursor;
        END

        COMMIT TRANSACTION;

        SELECT @UserID AS NewUserID;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        IF OBJECT_ID('dbo.ErrorLog') IS NOT NULL
        BEGIN
            INSERT INTO dbo.ErrorLog (ErrorMessage, ErrorProcedure, ErrorLine, CreatedAt)
            VALUES (
                ERROR_MESSAGE(),
                ERROR_PROCEDURE(),
                ERROR_LINE(),
                GETDATE()
            );
        END

        DECLARE @ErrMsg NVARCHAR(MAX) = ERROR_MESSAGE();
        RAISERROR(@ErrMsg, 16, 1);
    END CATCH
END;
GO


-- ✅ Create a User Token
CREATE PROCEDURE CreateUserToken
    @UserID NVARCHAR(128),
    @LoginProvider NVARCHAR(128),
    @Name NVARCHAR(128),
    @Value NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO AspNetUserTokens (UserId, LoginProvider, Name, Value) VALUES (@UserID, @LoginProvider, @Name, @Value);
END;

GO


CREATE PROCEDURE DeactivateApiKey
    @ApiKeyID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE API_KEYS SET IsActive = 0 WHERE ApiKeyID = @ApiKeyID;
END;

GO

-- ================================================
-- ✅ DeleteAddress
-- Description: Deletes an address record by ID
-- ================================================
CREATE   PROCEDURE DeleteAddress
    @AddyId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM Address
    WHERE addyId = @AddyId;
END;
GO

CREATE PROCEDURE DeleteAllProviderProfileFieldsByProvider
    @ProviderID UNIQUEIDENTIFIER
AS
BEGIN
    DELETE FROM ProviderProfileFields
    WHERE ProviderID = @ProviderID;
END;
GO

-- =============================================
-- ✅ DELETE PROCEDURE: DeleteAPI_Owner
-- Deletes an API_Owner by OwnerUUID
-- =============================================
CREATE PROCEDURE DeleteAPI_Owner
    @OwnerUUID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM skylynxnet_coredb.dbo.API_Owners
    WHERE OwnerUUID = @OwnerUUID;
END;
GO

-- ============================================
-- 🔹 Delete API Key
-- ============================================
CREATE PROCEDURE DeleteApiKey
    @ApiKeyID UNIQUEIDENTIFIER
AS
BEGIN
    DELETE FROM skylynxnet_coredb.dbo.API_KEYS WHERE ApiKeyID = @ApiKeyID;
END;
GO

-- ================================================
-- ✅ Procedure: DeleteAspNetUser
-- Description: Deletes a user by ID
-- ================================================
CREATE PROCEDURE DeleteAspNetUser
(
    @UserID NVARCHAR(128)
)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM AspNetUsers
    WHERE Id = @UserID;
END;
GO


CREATE PROCEDURE DeleteBankAccount
    @BankAccountID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM BankAccounts WHERE BankAccountID = @BankAccountID;
END;

GO


-- ✅ Delete a User Claim
CREATE PROCEDURE DeleteClaim
    @ClaimID INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM AspNetUserClaims WHERE Id = @ClaimID;
END;

GO

-- ================================================
-- ✅ Stored Procedure: DeleteDefaultUserRole
-- Description: Removes a default user role from a portal
-- ================================================
CREATE   PROCEDURE DeleteDefaultUserRole
    @PortalID UNIQUEIDENTIFIER,
    @RoleID NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM DefaultUserRoles
    WHERE PortalID = @PortalID AND RoleID = @RoleID;
END;
GO

CREATE PROCEDURE dbo.DeleteDyForm
(
    @FormID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.DyForm WHERE FormID = @FormID;
END;
GO

-- ================================================
-- ✅ Stored Procedure: DeleteDyFormDataSourceDefinition
-- Description: Delete DyFormDataSourceDefinition by ID
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE dbo.DeleteDyFormDataSourceDefinition
    @DyFormDSDefinitionID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.DyFormDataSourceDefinition
    WHERE DyFormDSDefinitionID = @DyFormDSDefinitionID;
END;
GO

CREATE PROCEDURE dbo.DeleteDyFormDomains
(
    @DomainID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.DyFormDomains WHERE DomainID = @DomainID;
END;
GO

CREATE PROCEDURE dbo.DeleteDyFormDomainType
-- TODO: Copy parameters and logic from `DeleteDyFormDomainType` or redefine clean
AS
BEGIN
    -- Placeholder logic, replace with actual logic
    PRINT 'Procedure DeleteDyFormDomainType created.';
END;
GO

CREATE PROCEDURE dbo.DeleteDyFormDomainValues
(
    @DomainValueID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.DyFormDomainValues WHERE DomainValueID = @DomainValueID;
END;
GO

CREATE PROCEDURE dbo.DeleteDyFormExpression
(
    @DyFormExpressionID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.DyFormExpression
    WHERE DyFormExpressionID = @DyFormExpressionID;
END;
GO

-- ================================================
-- ✅ Procedure: DeleteDyFormField
-- Description: Delete a DyFormField record
-- ================================================
CREATE PROCEDURE DeleteDyFormField
    @DyFormFieldID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM skylynxnet_coredb.dbo.DyFormField
    WHERE DyFormFieldID = @DyFormFieldID;
END;
GO

CREATE PROCEDURE dbo.DeleteDyFormFieldDefinition
    @DyFormFieldDefinitionID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.DyFormFieldDefinition
    WHERE DyFormFieldDefinitionID = @DyFormFieldDefinitionID;
END;
GO

CREATE PROCEDURE dbo.DeleteDyFormFieldRule
(
    @RuleID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.DyFormFieldRule WHERE RuleID = @RuleID;
END;
GO

-- ================================================
-- ✅ Stored Procedure: DeleteDyFormFieldSectionDefinition
-- Description: Delete DyFormFieldSectionDefinition by ID
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE dbo.DeleteDyFormFieldSectionDefinition
    @SectionDefinitionID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.DyFormFieldSectionDefinition
    WHERE SectionDefinitionID = @SectionDefinitionID;
END;
GO

CREATE PROCEDURE dbo.DeleteDyFormFieldType
(
    @FieldTypeID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.DyFormFieldType WHERE FieldTypeID = @FieldTypeID;
END;
GO

-- ================================================
-- ✅ Procedure: DeleteDyFormResolver
-- Description: Delete a specific DyFormResolver row
-- ================================================
CREATE PROCEDURE dbo.DeleteDyFormResolver
    @DyFormID UNIQUEIDENTIFIER,
    @ResolverContext NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.DyFormResolvers
    WHERE DyFormID = @DyFormID AND ResolverContext = @ResolverContext;
END;
GO

CREATE PROCEDURE dbo.DeleteDyFormResolverType
(
    @ResolverTypeID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.DyFormResolverType WHERE ResolverTypeID = @ResolverTypeID;
END;
GO

CREATE PROCEDURE dbo.DeleteDyFormRuleDefinition
    @RuleDefinitionID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.DyFormRuleDefinition
    WHERE RuleDefinitionID = @RuleDefinitionID;
END;
GO

-- ================================================
-- ✅ Stored Procedure: DeleteDyFormRuleSyntax
-- ================================================
CREATE PROCEDURE dbo.DeleteDyFormRuleSyntax
    @RuleSyntaxID UNIQUEIDENTIFIER  -- The ID of the rule syntax to delete
AS
BEGIN
    SET NOCOUNT ON;

    -- Delete rule syntax by ID
    DELETE FROM skylynxnet_coredb.dbo.DyFormRuleSyntax
    WHERE RuleSyntaxID = @RuleSyntaxID;
END;
GO

-- ❌ DELETE
CREATE PROCEDURE dbo.DeleteDyFormRuleTarget
    @RuleTargetID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.DyFormRuleTarget
    WHERE RuleTargetID = @RuleTargetID;
END;
GO

CREATE PROCEDURE dbo.DeleteDyFormRuleType
(
    @RuleTypeID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.DyFormRuleType WHERE RuleTypeID = @RuleTypeID;
END;
GO

CREATE PROCEDURE dbo.DeleteDyFormSection
    @SectionID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.DyFormSection
    WHERE SectionID = @SectionID;
END;
GO

-- ================================================
-- ✅ Delete Procedure: DeleteDyFormSectionResolver
-- ================================================
CREATE PROCEDURE dbo.DeleteDyFormSectionResolver
(
    @DyFormID UNIQUEIDENTIFIER,
    @SectionID UNIQUEIDENTIFIER,
    @ResolverContext NVARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.DyFormSectionResolvers
    WHERE DyFormID = @DyFormID
      AND SectionID = @SectionID
      AND ResolverContext = @ResolverContext;
END;
GO

-- ================================================
-- ✅ Procedure: DeleteDyFormSections
-- Description: Delete DyFormSections record
-- ================================================
CREATE PROCEDURE dbo.DeleteDyFormSections
(
    @FormSectionID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.DyFormSections
    WHERE FormSectionID = @FormSectionID;
END;
GO

-- ================================================
-- ✅ Procedure: DeleteDyFormViewModelDefinition
-- ================================================
CREATE PROCEDURE DeleteDyFormViewModelDefinition
    @ViewModelDefinitionID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM DyFormViewModelDefinition
    WHERE ViewModelDefinitionID = @ViewModelDefinitionID;
END;
GO

-- ================================================
-- 5️⃣ DELETE
-- ================================================
CREATE PROCEDURE dbo.DeleteGlobalModuleSetting
(
    @ModuleID UNIQUEIDENTIFIER,
    @SettingKeyID UNIQUEIDENTIFIER,
    @RoleID NVARCHAR(128)
)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.GlobalModuleSettings
    WHERE ModuleID = @ModuleID
      AND SettingKeyID = @SettingKeyID
      AND RoleID = @RoleID;
END;
GO

-- ================================================
-- ✅ Stored Procedure: DeleteGlobalPortalSetting
-- Description: Deletes a setting by SettingKeyID
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE DeleteGlobalPortalSetting
  @SettingKeyID UNIQUEIDENTIFIER
AS
BEGIN
  SET NOCOUNT ON;

  DELETE FROM GlobalPortalSettings
  WHERE SettingKeyID = @SettingKeyID;
END;
GO

CREATE PROCEDURE DeleteLanguage
    @LanguageCode NVARCHAR(2)
AS
BEGIN
    DELETE FROM ISO6391_Languages WHERE LanguageCode = @LanguageCode;
END;
GO

CREATE PROCEDURE dbo.DeleteLayout
(
    @LayoutID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.Layouts
    WHERE LayoutID = @LayoutID;
END;
GO

CREATE PROCEDURE dbo.DeleteModule
(
    @ModuleID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.Modules
    WHERE ModuleID = @ModuleID;
END;
GO

-- ================================================
-- ✅ Stored Procedure: DeleteModuleSetting
-- Description: Deletes a setting for module/role/key
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE DeleteModuleSetting
  @PortalModuleID UNIQUEIDENTIFIER,
  @SettingKeyID UNIQUEIDENTIFIER,
  @RoleID NVARCHAR(128)
AS
BEGIN
  SET NOCOUNT ON;

  DELETE FROM ModuleSettings
  WHERE PortalModuleID = @PortalModuleID
    AND SettingKeyID = @SettingKeyID
    AND RoleID = @RoleID;
END;
GO


CREATE PROCEDURE DeleteOldLogs
    @Days INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM SystemLogs WHERE CreatedAt < DATEADD(DAY, -@Days, GETDATE());
END;

GO


CREATE PROCEDURE dbo.DeleteOwnerType
    @OwnerTypeID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the OwnerType is being used before deleting
    IF EXISTS (SELECT 1 FROM API_KEYS WHERE OwnerTypeID = @OwnerTypeID)
    BEGIN
        PRINT '❌ Cannot delete OwnerType: It is currently assigned in API_KEYS';
        RETURN;
    END

    DELETE FROM OwnerTypes WHERE OwnerTypeID = @OwnerTypeID;
    PRINT '✅ OwnerType Deleted Successfully';
END;

GO

CREATE PROCEDURE dbo.DeletePageDefinition
(
    @PageID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.PageDefinition
    WHERE PageID = @PageID;
END;
GO


CREATE PROCEDURE DeletePaymentMethod
    @PaymentMethodID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM PaymentMethods WHERE PaymentMethodID = @PaymentMethodID;
END;

GO

-- ================================================
-- ✅ Stored Procedure: DeletePortal
-- Description: Deletes a portal and cascades through PortalOwners
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE DeletePortal
    @PortalID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM skylynxnet_coredb.dbo.Portals
    WHERE PortalID = @PortalID;
END;
GO

CREATE PROCEDURE DeletePortalProfileProvider
    @PortalID UNIQUEIDENTIFIER,
    @ProviderID UNIQUEIDENTIFIER
AS
BEGIN
    DELETE FROM PortalProfileProviders
    WHERE PortalID = @PortalID AND ProviderID = @ProviderID;
END;
GO

-- ================================================
-- ✅ Stored Procedure: DeletePortalRole
-- Description: Removes a role from a portal
-- ================================================
CREATE   PROCEDURE DeletePortalRole
    @PortalID UNIQUEIDENTIFIER,
    @RoleID NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM PortalRoles
    WHERE PortalID = @PortalID AND RoleID = @RoleID;
END;
GO

CREATE PROCEDURE DeleteProfileProvider
    @ProviderID UNIQUEIDENTIFIER
AS
BEGIN
    DELETE FROM ProfileProviders WHERE ProviderID = @ProviderID;
END;
GO

-- ================================================
-- ✅ Stored Procedure: DeleteProtosDataModel
-- Description: Deletes a ProtosDataModelDefinition by DataModelID
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE dbo.DeleteProtosDataModel
(
    @DataModelID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.ProtosDataModelDefinition
    WHERE DataModelID = @DataModelID;
END;
GO

-- Delete ProtosTargetType
CREATE PROCEDURE dbo.DeleteProtosTargetType
    @TargetTypeID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM skylynxnet_coredb.dbo.ProtosTargetType
    WHERE TargetTypeID = @TargetTypeID;
END;
GO

-- Delete ProtosTemplate
CREATE PROCEDURE dbo.DeleteProtosTemplate
    @TemplateID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM skylynxnet_coredb.dbo.ProtosTemplate
    WHERE TemplateID = @TemplateID;
END;
GO

-- Delete ProtosTemplateLineage
CREATE PROCEDURE dbo.DeleteProtosTemplateLineage
    @LineageID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM skylynxnet_coredb.dbo.ProtosTemplateLineage
    WHERE LineageID = @LineageID;
END;
GO

CREATE PROCEDURE dbo.DeleteProtosTemplateLink
(
    @TemplateLinkID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM ProtosTemplateLink
    WHERE TemplateLinkID = @TemplateLinkID;
END;
GO

-- Delete ProtosTemplateStatus
CREATE PROCEDURE dbo.DeleteProtosTemplateStatus
    @TemplateStatusID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM skylynxnet_coredb.dbo.ProtosTemplateStatus
    WHERE TemplateStatusID = @TemplateStatusID;
END;
GO

CREATE PROCEDURE dbo.DeleteProtosTemplateVersion
(
    @TemplateVersionID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.ProtosTemplateVersion
    WHERE TemplateVersionID = @TemplateVersionID;
END;
GO

CREATE PROCEDURE DeleteProviderProfileField
    @FieldID UNIQUEIDENTIFIER
AS
BEGIN
    DELETE FROM ProviderProfileFields WHERE FieldID = @FieldID;
END;
GO

-- ================================================
-- ✅ Delete: Remove FieldType
-- ================================================
CREATE PROCEDURE DeleteProviderProfileFieldType
  @FieldTypeID UNIQUEIDENTIFIER
AS
BEGIN
  DELETE FROM ProviderProfileFieldType
  WHERE FieldTypeID = @FieldTypeID;
END;
GO

CREATE PROCEDURE dbo.DeleteResolver
  @ResolverID UNIQUEIDENTIFIER
AS
BEGIN
  SET NOCOUNT ON;

  DELETE FROM dbo.Resolvers
  WHERE ResolverID = @ResolverID;
END;
GO


CREATE PROCEDURE DeleteRole
    @RoleID NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM AspNetRoles WHERE Id = @RoleID;
END;

GO

-- ================================================
-- ✅ Stored Procedure: DeleteSettingKey
-- Description: Deletes a setting key by ID
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE DeleteSettingKey
  @SettingKeyID UNIQUEIDENTIFIER
AS
BEGIN
  SET NOCOUNT ON;

  DELETE FROM SettingKeys
  WHERE SettingKeyID = @SettingKeyID;
END;
GO


CREATE PROCEDURE dbo.DeleteSubscription
    @SubscriptionID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM SubscriptionPlans WHERE SubscriptionID = @SubscriptionID;
    PRINT '✅ Subscription Deleted Successfully';
END;

GO

-- ================================================
-- ✅ Stored Procedure: DeleteSystemValueType
-- Description: Deletes a system value type by name
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE DeleteSystemValueType
  @ValueType NVARCHAR(50)
AS
BEGIN
  SET NOCOUNT ON;

  DELETE FROM SystemValueTypes
  WHERE ValueType = @ValueType;
END;
GO

-- ================================================
-- ✅ Stored Procedure: DeleteThemeDefinition
-- Description: Deletes a ThemeDefinition by ID
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE dbo.DeleteThemeDefinition
(
    @ThemeDefinitionID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.ThemeDefinitions
    WHERE ThemeDefinitionID = @ThemeDefinitionID;
END;
GO

-- ================================================
-- ✅ Stored Procedure: DeleteThemeById
-- Description: Deletes a ThemeDefinition by ID
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE   PROCEDURE dbo.DeleteThemeDefinitionById
(
  @ThemeDefinitionID UNIQUEIDENTIFIER
)
AS
BEGIN
  SET NOCOUNT ON;

  DELETE FROM dbo.ThemeDefinitions
  WHERE ThemeDefinitionID = @ThemeDefinitionID;
END;
GO


CREATE PROCEDURE DeleteTransaction
    @TransactionID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM Transactions WHERE TransactionID = @TransactionID;
END;

GO


CREATE PROCEDURE DeleteUser
    @UserID NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM AspNetUsers WHERE Id = @UserID;
END;

GO


-- ✅ Delete a User Login Provider
CREATE PROCEDURE DeleteUserLogin
    @UserID NVARCHAR(128),
    @LoginProvider NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM AspNetUserLogins WHERE UserId = @UserID AND LoginProvider = @LoginProvider;
END;

GO

CREATE PROCEDURE DeleteUserProfile
    @UserID NVARCHAR(128),
    @ProviderID UNIQUEIDENTIFIER,
    @PortalID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM UserProfiles
    WHERE UserID = @UserID AND ProviderID = @ProviderID AND PortalID = @PortalID;
END;
GO

CREATE PROCEDURE DeleteUserProviderProfileData
    @UserID NVARCHAR(128),
    @ProviderID UNIQUEIDENTIFIER,
    @FieldID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM UserProviderProfiles
    WHERE UserID = @UserID AND ProviderID = @ProviderID AND FieldID = @FieldID;
END;
GO

CREATE PROCEDURE DeleteUserProviderProfileFieldData
    @UserID NVARCHAR(128),
    @ProviderID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM UserProviderProfiles
    WHERE UserID = @UserID AND ProviderID = @ProviderID;
END;
GO


-- ✅ Delete a User Token
CREATE PROCEDURE DeleteUserToken
    @UserID NVARCHAR(128),
    @LoginProvider NVARCHAR(128),
    @Name NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM AspNetUserTokens WHERE UserId = @UserID AND LoginProvider = @LoginProvider AND Name = @Name;
END;

GO

-- ================================================
-- ✅ Procedure: DyFormViewModelTree
-- Description: Returns full ViewModel lineage tree starting from a root ViewModelName
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE   PROCEDURE dbo.DyFormViewModelTree
    @ViewModelName NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- Step 1: Get the root ViewModelDefinitionID
    DECLARE @RootID UNIQUEIDENTIFIER;

    SELECT @RootID = ViewModelDefinitionID
    FROM DyFormViewModelDefinition
    WHERE ViewModelName = @ViewModelName;

    IF @RootID IS NULL
    BEGIN
        RAISERROR('ViewModel not found: %s', 16, 1, @ViewModelName);
        RETURN;
    END

    -- Step 2: Recursive CTE to get full lineage
    ;WITH ViewModelCTE AS (
        SELECT
            vm.ViewModelDefinitionID,
            vm.ViewModelName,
            vm.DestKey,
            CAST(NULL AS UNIQUEIDENTIFIER) AS ParentViewModelDefinitionID,
            0 AS Depth
        FROM DyFormViewModelDefinition vm
        WHERE vm.ViewModelDefinitionID = @RootID

        UNION ALL

        SELECT
            child.ViewModelDefinitionID,
            child.ViewModelName,
            child.DestKey,
            lineage.ViewModelDefinitionID AS ParentViewModelDefinitionID,
            cte.Depth + 1
        FROM DyFormViewModelLineage lineage
        JOIN DyFormViewModelDefinition child
            ON child.ViewModelDefinitionID = lineage.ChildViewModelDefinitionID
        JOIN ViewModelCTE cte
            ON lineage.ViewModelDefinitionID = cte.ViewModelDefinitionID
    )

    SELECT
        cte.ViewModelDefinitionID,
        cte.ViewModelName,
        cte.DestKey,
        cte.ParentViewModelDefinitionID,
        cte.Depth
    FROM ViewModelCTE cte
    ORDER BY cte.Depth, cte.ViewModelName;
END;
GO


CREATE PROCEDURE GenerateApiKey
    @OwnerID NVARCHAR(128),
    @OwnerTypeID UNIQUEIDENTIFIER,
    @KeyHash NVARCHAR(256),
    @APIKeyID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @APIKeyID = NEWID();
    INSERT INTO API_KEYS (ApiKeyID, OwnerID, OwnerTypeID, KeyHash, CreatedAt, IsActive)
    VALUES (@APIKeyID, @OwnerID, @OwnerTypeID, @KeyHash, GETDATE(), 1);
END;

GO

-- ================================================
-- ✅ Stored Procedure: Get Active Keys by Portal
-- ================================================
CREATE   PROCEDURE GetActiveKeysByPortal
    @PortalID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM vw_ActiveAPIKeys
    WHERE PortalID = @PortalID;
END;
GO

-- ================================================
-- ✅ GetAddressById
-- Description: Retrieves a single address by ID
-- ================================================
CREATE   PROCEDURE GetAddressById
    @AddyId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM Address
    WHERE addyId = @AddyId;
END;
GO

-- ================================================
-- ✅ Stored Procedure: GetAllDyFormDataSourceDefinition
-- Description: Get all DyFormDataSourceDefinition records
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE dbo.GetAllDyFormDataSourceDefinition
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM dbo.DyFormDataSourceDefinition;
END;
GO

-- ✅ Get All DyFormDFormDomainss
CREATE PROCEDURE GetAllDyFormDFormDomainss
AS
BEGIN
  SET NOCOUNT ON;
  SELECT * FROM DyFormDFormDomains;
END

GO

-- ✅ Get All DyFormDFormDomainValuess
CREATE PROCEDURE GetAllDyFormDFormDomainValuess
AS
BEGIN
  SET NOCOUNT ON;
  SELECT * FROM DyFormDFormDomainValues;
END

GO

-- ✅ Get All DyFormDFormFieldRules
CREATE PROCEDURE GetAllDyFormDFormFieldRules
AS
BEGIN
  SET NOCOUNT ON;
  SELECT * FROM DyFormDFormFieldRule;
END

GO

-- ✅ Get All DyFormDFormFields
CREATE PROCEDURE GetAllDyFormDFormFields
AS
BEGIN
  SET NOCOUNT ON;
  SELECT * FROM DyFormDFormField;
END

GO

-- ✅ Get All DyFormDForms
CREATE PROCEDURE GetAllDyFormDForms
AS
BEGIN
  SET NOCOUNT ON;
  SELECT * FROM DyFormDForm;
END

GO

-- ✅ Get All DyFormDFormSections
CREATE PROCEDURE GetAllDyFormDFormSections
AS
BEGIN
  SET NOCOUNT ON;
  SELECT * FROM DyFormDFormSection;
END

GO

CREATE   PROCEDURE GetAllDyFormDomainTypes
AS
BEGIN
  SELECT DomainTypeID, DomainTypeName, Description FROM dbo.DyFormDomainType;
END

GO

CREATE PROCEDURE dbo.GetAllDyFormExpressions
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM dbo.DyFormExpression;
END;
GO

CREATE PROCEDURE dbo.GetAllDyFormField
AS
BEGIN
    SET NOCOUNT ON;

    SELECT * FROM dbo.DyFormField;
END;
GO

-- ================================================
-- ✅ Create: GetAllDyFormFields
-- ================================================
CREATE PROCEDURE dbo.GetAllDyFormFields
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.DyFormField;
END;
GO

-- ================================================
-- ✅ Stored Procedure: GetAllDyFormFieldSectionDefinition
-- Description: Get all DyFormFieldSectionDefinition records
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE dbo.GetAllDyFormFieldSectionDefinition
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM dbo.DyFormFieldSectionDefinition;
END;
GO

-- ✅ Get All DyFormFieldTypes
CREATE PROCEDURE GetAllDyFormFieldTypes
AS
BEGIN
  SET NOCOUNT ON;
  SELECT * FROM DyFormFieldType;
END

GO

-- ================================================
-- ✅ Get All Resolver Contexts
-- ================================================
CREATE PROCEDURE dbo.GetAllDyFormResolverContexts
AS
BEGIN
    SET NOCOUNT ON;

    SELECT * FROM dbo.DyFormResolverContext;
END;
GO

-- ================================================
-- ✅ Procedure: GetAllDyFormResolvers
-- Description: Return all DyFormResolvers
-- ================================================
CREATE PROCEDURE dbo.GetAllDyFormResolvers
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        r.DyFormID,
        f.FormName,
        r.ResolverContext,
        r.ResolverTypeID,
        t.Name AS ResolverTypeName,
        r.ResolverTarget,
        r.Description,
        r.CreatedAt,
        r.UpdatedAt
    FROM dbo.DyFormResolvers r
    JOIN dbo.DyForm f ON r.DyFormID = f.FormID
    JOIN dbo.DyFormResolverType t ON r.ResolverTypeID = t.ResolverTypeID;
END;
GO

-- ✅ Get All DyFormResolverTypes
CREATE PROCEDURE GetAllDyFormResolverTypes
AS
BEGIN
  SET NOCOUNT ON;
  SELECT * FROM DyFormResolverType;
END

GO

-- ================================================
-- ✅ Stored Procedure: GetAllDyFormRuleSyntax
-- ================================================
CREATE PROCEDURE dbo.GetAllDyFormRuleSyntax
AS
BEGIN
    SET NOCOUNT ON;

    -- Retrieve all rule syntax records
    SELECT RuleSyntaxID, SyntaxName, Description, CreatedAt, UpdatedAt
    FROM skylynxnet_coredb.dbo.DyFormRuleSyntax;
END;
GO

-- ✅ Get All DyFormRuleTypes
CREATE PROCEDURE GetAllDyFormRuleTypes
AS
BEGIN
  SET NOCOUNT ON;
  SELECT * FROM DyFormRuleType;
END

GO

CREATE PROCEDURE dbo.GetAllDyFormSection
AS
BEGIN
    SET NOCOUNT ON;

    SELECT SectionID, SectionName, Label, SortOrder
    FROM dbo.DyFormSection
    ORDER BY SortOrder;
END;
GO

-- ================================================
-- ✅ Procedure: GetAllDyFormSections
-- Description: Returns all records from DyFormSections
-- ================================================
CREATE PROCEDURE dbo.GetAllDyFormSections
AS
BEGIN
    SET NOCOUNT ON;
    SELECT *
    FROM dbo.DyFormSections
    ORDER BY SortOrder;
END;
GO

-- ================================================
-- ✅ Procedure: GetAllDyFormViewModelDefinitions
-- ================================================
CREATE PROCEDURE GetAllDyFormViewModelDefinitions
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM DyFormViewModelDefinition
    ORDER BY ViewModelName;
END;
GO

-- ================================================
-- ✅ Stored Procedure: GetAllGlobalPortalSettings
-- Description: Retrieves all global portal settings
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE GetAllGlobalPortalSettings
AS
BEGIN
  SET NOCOUNT ON;

  SELECT SettingKeyID, Value, UpdatedAt
  FROM GlobalPortalSettings
  ORDER BY SettingKeyID;
END;
GO

CREATE PROCEDURE GetAllLanguages
AS
BEGIN
    SELECT * FROM ISO6391_Languages;
END;
GO

CREATE PROCEDURE dbo.GetAllLayouts
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM dbo.Layouts
    ORDER BY CreatedAt DESC;
END;
GO

CREATE PROCEDURE dbo.GetAllModules
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM dbo.Modules
    ORDER BY CreatedOnDate DESC;
END;
GO


CREATE PROCEDURE GetAllOwnerTypes
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM OwnerTypes;
END;

GO

CREATE PROCEDURE dbo.GetAllPageDefinitions
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM dbo.PageDefinition
    ORDER BY CreatedAt DESC;
END;
GO

CREATE PROCEDURE GetAllPortalProfileProviders
AS
BEGIN
    SELECT * FROM PortalProfileProviders;
END;
GO

-- ================================================
-- ✅ Stored Procedure: GetAllPortals
-- Description: Returns all portals in the system
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE GetAllPortals
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        PortalID,
        PortalName,
        Description,
        SplashImage,
        Status,
        CreatedDate,
        LastUpdated
    FROM skylynxnet_coredb.dbo.Portals;
END;
GO

CREATE PROCEDURE GetAllProfileDataByUserProvider
    @UserID NVARCHAR(128),
    @ProviderID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM UserProfiles
    WHERE UserID = @UserID AND ProviderID = @ProviderID;
END;
GO

CREATE PROCEDURE GetAllProfileProviders
AS
BEGIN
    SELECT * FROM ProfileProviders;
END;
GO

-- ================================================
-- ✅ Stored Procedure: GetAllProtosDataModels
-- Description: Returns all ProtosDataModelDefinition records
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE dbo.GetAllProtosDataModels
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        DataModelID,
        DataModelName,
        DataModelJSON,
        Description,
        CreatedAt,
        UpdatedAt
    FROM dbo.ProtosDataModelDefinition
    ORDER BY CreatedAt DESC;
END;
GO

-- Get All ProtosTargetType
CREATE PROCEDURE dbo.GetAllProtosTargetType
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TargetTypeID, TargetTypeName, Description, CreatedAt, UpdatedAt
    FROM skylynxnet_coredb.dbo.ProtosTargetType;
END;
GO

-- Get All ProtosTemplate
CREATE PROCEDURE dbo.GetAllProtosTemplate
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TemplateID, TemplateName, TemplateType, Description, CreatedAt, UpdatedAt
    FROM skylynxnet_coredb.dbo.ProtosTemplate;
END;
GO

-- Get All ProtosTemplateLineage
CREATE PROCEDURE dbo.GetAllProtosTemplateLineage
AS
BEGIN
    SET NOCOUNT ON;
    SELECT LineageID, ParentVersionID, ChildVersionID, CreatedAt, UpdatedAt
    FROM skylynxnet_coredb.dbo.ProtosTemplateLineage;
END;
GO

-- Get All ProtosTemplateLink
CREATE PROCEDURE dbo.GetAllProtosTemplateLink
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TemplateLinkID, TemplateVersionID, PortalID, ModuleID, IsDefault, OverrideJSON, CreatedAt, UpdatedAt
    FROM skylynxnet_coredb.dbo.ProtosTemplateLink;
END;
GO

-- Get All ProtosTemplateStatus
CREATE PROCEDURE dbo.GetAllProtosTemplateStatus
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TemplateStatusID, StatusName, Description, CreatedAt, UpdatedAt
    FROM skylynxnet_coredb.dbo.ProtosTemplateStatus;
END;
GO

-- Get All ProtosTemplateVersion
CREATE PROCEDURE dbo.GetAllProtosTemplateVersion
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TemplateVersionID, TemplateID, VersionNumber, VersionLabel, CreatedAt, UpdatedAt
    FROM skylynxnet_coredb.dbo.ProtosTemplateVersion;
END;
GO

CREATE PROCEDURE dbo.GetAllProtosTemplateVersions
(
    @TemplateID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM dbo.ProtosTemplateVersion
    WHERE TemplateID = @TemplateID
    ORDER BY CreatedAt DESC;
END;
GO

CREATE PROCEDURE GetAllProviderProfileFields
AS
BEGIN
    SELECT * FROM ProviderProfileFields;
END;
GO

-- ================================================
-- ✅ Read: Get All FieldTypes
-- ================================================
CREATE PROCEDURE GetAllProviderProfileFieldTypes
AS
BEGIN
  SELECT FieldTypeID, FieldTypeName, Description, CreatedAt, UpdatedAt
  FROM ProviderProfileFieldType
  ORDER BY FieldTypeName;
END;
GO

CREATE PROCEDURE GetAllProviderProfilesbyUser
    @UserID NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM UserProviderProfiles WHERE UserID = @UserID;
END;
GO


CREATE PROCEDURE GetAllRoles
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM AspNetRoles;
END;

GO

-- ================================================
-- ✅ Stored Procedure: GetAllSettingKeys
-- Description: Returns all setting keys
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE GetAllSettingKeys
AS
BEGIN
  SET NOCOUNT ON;

  SELECT SettingKeyID, KeyName, Label, ValueType, DomainID
  FROM SettingKeys
  ORDER BY KeyName;
END;
GO

-- ================================================
-- ✅ Stored Procedure: GetAllSystemValueTypes
-- Description: Returns all defined system value types
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE GetAllSystemValueTypes
AS
BEGIN
  SET NOCOUNT ON;

  SELECT ValueType, Description, IsStructured, CreatedAt
  FROM SystemValueTypes
  ORDER BY ValueType;
END;
GO

-- ================================================
-- ✅ Stored Procedure: GetAllThemeDefinitions
-- Description: Retrieves all ThemeDefinitions
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE dbo.GetAllThemeDefinitions
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM dbo.ThemeDefinitions
    ORDER BY CreatedAt DESC;
END;
GO

CREATE PROCEDURE GetAllUserProfiles
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM UserProfiles;
END;
GO

CREATE PROCEDURE GetAllUserProfilesByPortalID
    @PortalID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM UserProfiles WHERE PortalID = @PortalID;
END;
GO

CREATE PROCEDURE GetAllUserProfilesByProviderID
    @ProviderID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM UserProfiles WHERE ProviderID = @ProviderID;
END;
GO

CREATE PROCEDURE GetAllUserProfilesByUserID
    @UserID NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM UserProfiles WHERE UserID = @UserID;
END;
GO


CREATE PROCEDURE GetAllUsers
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, UserName, Email FROM AspNetUsers;
END;

GO

-- =============================================
-- ✅ READ PROCEDURE: GetAPI_OwnerById
-- Retrieves an API_Owner by OwnerUUID
-- =============================================
CREATE PROCEDURE GetAPI_OwnerById
    @OwnerUUID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM skylynxnet_coredb.dbo.API_Owners
    WHERE OwnerUUID = @OwnerUUID;
END;
GO

-- ============================================
-- 🔹 Read API Key by ID
-- ============================================
CREATE PROCEDURE GetApiKeyById
    @ApiKeyID UNIQUEIDENTIFIER
AS
BEGIN
    SELECT * FROM skylynxnet_coredb.dbo.API_KEYS WHERE ApiKeyID = @ApiKeyID;
END;
GO

-- ================================================
-- ✅ Procedure: GetAspNetUserById
-- Description: Retrieves a user by UserID
-- ================================================
CREATE PROCEDURE GetAspNetUserById
(
    @UserID NVARCHAR(128)
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM AspNetUsers
    WHERE Id = @UserID;
END;
GO


CREATE PROCEDURE GetBankAccountByUser
    @UserID NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM BankAccounts WHERE UserID = @UserID;
END;

GO


-- ✅ Get Claims By User
CREATE PROCEDURE GetClaimsByUser
    @UserID NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM AspNetUserClaims WHERE UserId = @UserID;
END;

GO

CREATE PROCEDURE GetDefaultProviderByPortalName
    @PortalName NVARCHAR(256),
    @PortalID UNIQUEIDENTIFIER OUTPUT,
    @ProviderID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Resolve PortalID
    SELECT TOP 1 @PortalID = PortalID
    FROM vw_PortalProfileProviders
    WHERE PortalName = @PortalName;

    IF @PortalID IS NULL
    BEGIN
        RAISERROR('PortalID could not be resolved from PortalName.', 16, 1);
        RETURN;
    END

    -- Primary: Portal Default
    SELECT TOP 1 @ProviderID = ProviderID
    FROM vw_PortalProfileProviders
    WHERE PortalID = @PortalID AND IsPortalDefault = 1;

    -- Fallback: System Default
    IF @ProviderID IS NULL
    BEGIN
        SELECT TOP 1 @ProviderID = ProviderID
        FROM vw_PortalProfileProviders
        WHERE PortalID = @PortalID AND IsSystemDefault = 1;
    END

    IF @ProviderID IS NULL
    BEGIN
        RAISERROR('Provider could not be resolved from PortalName.', 16, 1);
    END
END;
GO

-- ================================================
-- ✅ Stored Procedure: GetDefaultUserRole
-- Description: Gets the default RoleID for a portal
-- ================================================
CREATE   PROCEDURE GetDefaultUserRole
    @PortalID UNIQUEIDENTIFIER,
    @RoleID NVARCHAR(128) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 1 @RoleID = dur.RoleID
    FROM DefaultUserRoles dur
    WHERE dur.PortalID = @PortalID;
END;
GO

CREATE PROCEDURE dbo.GetDyFormByID
(
    @FormID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.DyForm WHERE FormID = @FormID;
END;
GO

-- ================================================
-- ✅ Stored Procedure: GetDyFormDataSourceDefinitionById
-- Description: Get DyFormDataSourceDefinition by ID
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE dbo.GetDyFormDataSourceDefinitionById
    @DyFormDSDefinitionID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM dbo.DyFormDataSourceDefinition
    WHERE DyFormDSDefinitionID = @DyFormDSDefinitionID;
END;
GO

CREATE PROCEDURE dbo.GetDyFormDomainsByID
(
    @DomainID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.DyFormDomains WHERE DomainID = @DomainID;
END;
GO

CREATE PROCEDURE dbo.GetDyFormDomainValuesByID
(
    @DomainValueID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.DyFormDomainValues WHERE DomainValueID = @DomainValueID;
END;
GO

CREATE PROCEDURE dbo.GetDyFormExpressionById
(
    @DyFormExpressionID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM dbo.DyFormExpression
    WHERE DyFormExpressionID = @DyFormExpressionID;
END;
GO

CREATE PROCEDURE dbo.GetDyFormFieldByID
    @DyFormFieldID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    SELECT * FROM dbo.DyFormField WHERE DyFormFieldID = @DyFormFieldID;
END;
GO

CREATE PROCEDURE dbo.GetDyFormFieldRuleByID
(
    @RuleID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.DyFormFieldRule WHERE RuleID = @RuleID;
END;
GO

CREATE PROCEDURE dbo.GetDyFormFieldsBySection
    @SectionID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM dbo.DyFormField
    WHERE SectionID = @SectionID
    ORDER BY SortOrder;
END;
GO

-- ================================================
-- ✅ Stored Procedure: GetDyFormFieldSectionDefinitionById
-- Description: Get DyFormFieldSectionDefinition by ID
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE dbo.GetDyFormFieldSectionDefinitionById
    @SectionDefinitionID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM dbo.DyFormFieldSectionDefinition
    WHERE SectionDefinitionID = @SectionDefinitionID;
END;
GO

CREATE PROCEDURE dbo.GetDyFormFieldTypeByID
(
    @FieldTypeID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.DyFormFieldType WHERE FieldTypeID = @FieldTypeID;
END;
GO

-- ================================================
-- ✅ Procedure: GetDyFormResolverByContext
-- Description: Get a single resolver entry for a specific FormID + Context
-- ================================================
CREATE PROCEDURE dbo.GetDyFormResolverByContext
    @DyFormID UNIQUEIDENTIFIER,
    @ResolverContext NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        r.DyFormID,
        r.ResolverContext,
        r.ResolverTypeID,
        t.Name AS ResolverTypeName,
        r.ResolverTarget,
        r.Description,
        r.CreatedAt,
        r.UpdatedAt
    FROM dbo.DyFormResolvers r
    JOIN dbo.DyFormResolverType t ON r.ResolverTypeID = t.ResolverTypeID
    WHERE r.DyFormID = @DyFormID AND r.ResolverContext = @ResolverContext;
END;
GO

CREATE PROCEDURE dbo.GetDyFormResolverTypeByID
(
    @ResolverTypeID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.DyFormResolverType WHERE ResolverTypeID = @ResolverTypeID;
END;
GO

CREATE PROCEDURE dbo.GetDyFormRuleDefinitionById
    @RuleDefinitionID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    SELECT *
    FROM dbo.DyFormRuleDefinition
    WHERE RuleDefinitionID = @RuleDefinitionID;
END;
GO

-- ================================================
-- ✅ Stored Procedure: GetDyFormRuleSyntaxById
-- ================================================
CREATE PROCEDURE dbo.GetDyFormRuleSyntaxById
    @RuleSyntaxID UNIQUEIDENTIFIER  -- The ID of the rule syntax to retrieve
AS
BEGIN
    SET NOCOUNT ON;

    -- Retrieve rule syntax by ID
    SELECT RuleSyntaxID, SyntaxName, Description, CreatedAt, UpdatedAt
    FROM skylynxnet_coredb.dbo.DyFormRuleSyntax
    WHERE RuleSyntaxID = @RuleSyntaxID;
END;
GO

-- 📥 READ
CREATE PROCEDURE dbo.GetDyFormRuleTargetById
    @RuleTargetID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    SELECT *
    FROM dbo.DyFormRuleTarget
    WHERE RuleTargetID = @RuleTargetID;
END;
GO

CREATE PROCEDURE dbo.GetDyFormRuleTypeByID
(
    @RuleTypeID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.DyFormRuleType WHERE RuleTypeID = @RuleTypeID;
END;
GO

CREATE PROCEDURE dbo.GetDyFormSectionById
    @SectionID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM dbo.DyFormSection
    WHERE SectionID = @SectionID;
END;
GO

CREATE PROCEDURE dbo.GetDyFormSectionByName
    @SectionName NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM dbo.DyFormSection
    WHERE SectionName = @SectionName;
END;
GO

-- ================================================
-- ✅ Read Procedure: GetDyFormSectionResolversByFormID
-- ================================================
CREATE PROCEDURE dbo.GetDyFormSectionResolversByFormID
(
    @DyFormID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM dbo.DyFormSectionResolvers
    WHERE DyFormID = @DyFormID;
END;
GO

-- ================================================
-- ✅ Procedure: GetDyFormViewModelDefinitionById
-- ================================================
CREATE PROCEDURE GetDyFormViewModelDefinitionById
    @ViewModelDefinitionID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM DyFormViewModelDefinition
    WHERE ViewModelDefinitionID = @ViewModelDefinitionID;
END;
GO

CREATE PROCEDURE dbo.GetDyFormViewModelDefinitionsByName
    @ViewModelName NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM dbo.DyFormViewModelDefinition
    WHERE ViewModelName = @ViewModelName;
END;
GO

CREATE PROCEDURE GetFieldsByProvider
    @ProviderID UNIQUEIDENTIFIER
AS
BEGIN
    SELECT * FROM ProviderProfileFields WHERE ProviderID = @ProviderID;
END;
GO

-- ================================================
-- 3️⃣ READ - All for Module
-- ================================================
CREATE PROCEDURE dbo.GetGlobalModuleSettingsByModule
(
    @ModuleID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT gms.ModuleID,
           gms.SettingKeyID,
           sk.KeyName,
           gms.RoleID,
           gms.Value,
           gms.UpdatedAt
    FROM dbo.GlobalModuleSettings gms
    INNER JOIN dbo.SettingKeys sk ON gms.SettingKeyID = sk.SettingKeyID
    WHERE gms.ModuleID = @ModuleID;
END;
GO

-- ================================================
-- 2️⃣ READ - By Module & Role
-- ================================================
CREATE PROCEDURE dbo.GetGlobalModuleSettingsByModuleAndRole
(
    @ModuleID UNIQUEIDENTIFIER,
    @RoleID NVARCHAR(128)
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT gms.ModuleID,
           gms.SettingKeyID,
           sk.KeyName,
           gms.RoleID,
           gms.Value,
           gms.UpdatedAt
    FROM dbo.GlobalModuleSettings gms
    INNER JOIN dbo.SettingKeys sk ON gms.SettingKeyID = sk.SettingKeyID
    WHERE gms.ModuleID = @ModuleID
      AND gms.RoleID = @RoleID;
END;
GO

-- ================================================
-- ✅ Stored Procedure: GetGlobalPortalSettingByKey
-- Description: Retrieves setting by SettingKeyID
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE GetGlobalPortalSettingByKey
  @SettingKeyID UNIQUEIDENTIFIER
AS
BEGIN
  SET NOCOUNT ON;

  SELECT SettingKeyID, Value, UpdatedAt
  FROM GlobalPortalSettings
  WHERE SettingKeyID = @SettingKeyID;
END;
GO

CREATE PROCEDURE GetLanguageByCode
    @LanguageCode NVARCHAR(2)
AS
BEGIN
    SELECT * FROM ISO6391_Languages WHERE LanguageCode = @LanguageCode;
END;
GO

CREATE PROCEDURE dbo.GetLayoutById
(
    @LayoutID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM dbo.Layouts
    WHERE LayoutID = @LayoutID;
END;
GO

CREATE PROCEDURE dbo.GetModuleById
(
    @ModuleID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM dbo.Modules
    WHERE ModuleID = @ModuleID;
END;
GO

-- =============================================
-- ✅ GetModuleIDbyKey
-- =============================================
CREATE PROCEDURE GetModuleIDbyKey
    @ApiKey NVARCHAR(64)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT ModuleID FROM skylynxnet_coredb.dbo.APIKeys WHERE ApiKey = @ApiKey;
END;
GO


CREATE PROCEDURE GetModulesByPortal
    @PortalID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    SELECT m.* FROM Modules m
    INNER JOIN PortalModules pm ON m.ModuleID = pm.ModuleID
    WHERE pm.PortalID = @PortalID;
END;

GO

CREATE PROCEDURE dbo.GetModuleSettingByKey
(
  @PortalPageModuleID UNIQUEIDENTIFIER,
  @KeyName            NVARCHAR(100),
  @RoleID             NVARCHAR(128) = NULL
)
AS
BEGIN
  SET NOCOUNT ON;

  ;WITH KeyCTE AS (
    SELECT sk.SettingKeyID
    FROM dbo.SettingKeys sk
    WHERE sk.KeyName = @KeyName
  )
  SELECT TOP 1 ms.Value, sk.KeyName, ms.RoleID, ms.UpdatedAt
  FROM KeyCTE k
  JOIN dbo.ModuleSettings ms ON ms.SettingKeyID = k.SettingKeyID
  JOIN dbo.SettingKeys sk    ON sk.SettingKeyID = ms.SettingKeyID
  WHERE ms.PortalPageModuleID = @PortalPageModuleID
    AND (@RoleID IS NULL OR ms.RoleID = @RoleID)
  ORDER BY ms.UpdatedAt DESC;
END

GO

-- ================================================
-- ✅ Stored Procedure: GetModuleSettingsByModuleAndRole
-- Description: Returns all module settings for a given role
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE GetModuleSettingsByModuleAndRole
  @PortalModuleID UNIQUEIDENTIFIER,
  @RoleID NVARCHAR(128)
AS
BEGIN
  SET NOCOUNT ON;

  SELECT PortalModuleID, SettingKeyID, RoleID, Value, UpdatedAt
  FROM ModuleSettings
  WHERE PortalModuleID = @PortalModuleID
    AND RoleID = @RoleID;
END;
GO

-- ================================================
-- ✅ Stored Procedure: Get Owner Keys (by OwnerUUID)
-- ================================================
CREATE   PROCEDURE GetOwnerKeys
    @OwnerUUID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM vw_AllAPIKeys
    WHERE OwnerUUID = @OwnerUUID;
END;
GO

CREATE PROCEDURE dbo.GetPageDefinitionById
(
    @PageID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM dbo.PageDefinition
    WHERE PageID = @PageID;
END;
GO


CREATE PROCEDURE GetPaymentMethodsByUser
    @UserID NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM PaymentMethods WHERE UserID = @UserID;
END;

GO

-- ================================================
-- ✅ Stored Procedure: GetPortalByAPIKey
-- Description: Resolves PortalName for a given ApiKeyID using vw_ActiveAPIKeys
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE dbo.GetPortalByAPIKey
(
    @ApiKeyID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT KeyHash, PortalName, PortalID
    FROM vw_ActiveAPIKeys
    WHERE ApiKeyID = @ApiKeyID;
END;
GO

-- ================================================
-- ✅ Stored Procedure: GetPortalById
-- Description: Fetches a portal by ID
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE GetPortalById
    @PortalID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        PortalID,
        PortalName,
        Description,
        SplashImage,
        Status,
        CreatedDate,
        LastUpdated
    FROM skylynxnet_coredb.dbo.Portals
    WHERE PortalID = @PortalID;
END;
GO

-- =============================================
-- ✅ GetPortalIDbyKey
-- =============================================
CREATE PROCEDURE GetPortalIDbyKey
    @ApiKey NVARCHAR(64)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT PortalID FROM skylynxnet_coredb.dbo.APIKeys WHERE ApiKey = @ApiKey;
END;
GO

CREATE PROCEDURE GetPortalProfileProviderByKeys
    @PortalID UNIQUEIDENTIFIER,
    @ProviderID UNIQUEIDENTIFIER
AS
BEGIN
    SELECT * FROM PortalProfileProviders
    WHERE PortalID = @PortalID AND ProviderID = @ProviderID;
END;
GO

CREATE PROCEDURE GetPortalProfileProvidersByPortalID
    @PortalID UNIQUEIDENTIFIER
AS
BEGIN
    SELECT * FROM PortalProfileProviders
    WHERE PortalID = @PortalID;
END;
GO

-- ================================================
-- ✅ Stored Procedure: GetPortalRoles
-- Description: Lists all roles available to a portal
-- ================================================
CREATE   PROCEDURE GetPortalRoles
    @PortalID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    SELECT pr.PortalID, pr.RoleID, r.Name AS RoleName, pr.CreatedAt
    FROM PortalRoles pr
    JOIN AspNetRoles r ON pr.RoleID = r.Id
    WHERE pr.PortalID = @PortalID;
END;
GO

-- ================================================
-- ✅ Stored Procedure: GetPortalsByUserID
-- Description: Returns all portals owned by a given user
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE GetPortalsByUserID
    @UserID NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        p.PortalID,
        p.PortalName,
        p.Description,
        p.SplashImage,
        p.Status,
        p.CreatedDate,
        p.LastUpdated
    FROM skylynxnet_coredb.dbo.PortalOwners po
    INNER JOIN skylynxnet_coredb.dbo.Portals p 
        ON po.PortalID = p.PortalID
    WHERE po.UserID = @UserID;
END;
GO

-- ================================================
-- ✅ Stored Procedure: GetProtosDataModelById
-- Description: Returns a single ProtosDataModelDefinition by DataModelID
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE dbo.GetProtosDataModelById
(
    @DataModelID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        DataModelID,
        DataModelName,
        DataModelJSON,
        Description,
        CreatedAt,
        UpdatedAt
    FROM dbo.ProtosDataModelDefinition
    WHERE DataModelID = @DataModelID;
END;
GO

-- Get ProtosTargetType by ID
CREATE PROCEDURE dbo.GetProtosTargetTypeById
    @TargetTypeID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TargetTypeID, TargetTypeName, Description, CreatedAt, UpdatedAt
    FROM skylynxnet_coredb.dbo.ProtosTargetType
    WHERE TargetTypeID = @TargetTypeID;
END;
GO

-- Get ProtosTemplate By ID
CREATE PROCEDURE dbo.GetProtosTemplateById
    @TemplateID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TemplateID, TemplateName, TemplateType, Description, CreatedAt, UpdatedAt
    FROM skylynxnet_coredb.dbo.ProtosTemplate
    WHERE TemplateID = @TemplateID;
END;
GO

-- Get ProtosTemplateLineage By ID
CREATE PROCEDURE dbo.GetProtosTemplateLineageById
    @LineageID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    SELECT LineageID, ParentVersionID, ChildVersionID, CreatedAt, UpdatedAt
    FROM skylynxnet_coredb.dbo.ProtosTemplateLineage
    WHERE LineageID = @LineageID;
END;
GO

CREATE PROCEDURE dbo.GetProtosTemplateLinkByID
(
    @TemplateLinkID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM ProtosTemplateLink
    WHERE TemplateLinkID = @TemplateLinkID;
END;
GO

CREATE PROCEDURE dbo.GetProtosTemplateLinkByTargetObjectID
(
    @TargetObjectID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM ProtosTemplateLink
    WHERE TargetObjectID = @TargetObjectID;
END;
GO

-- Get ProtosTemplateStatus by ID
CREATE PROCEDURE dbo.GetProtosTemplateStatusById
    @TemplateStatusID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TemplateStatusID, StatusName, Description, CreatedAt, UpdatedAt
    FROM skylynxnet_coredb.dbo.ProtosTemplateStatus
    WHERE TemplateStatusID = @TemplateStatusID;
END;
GO

CREATE PROCEDURE dbo.GetProtosTemplateVersionById
(
    @TemplateVersionID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM dbo.ProtosTemplateVersion
    WHERE TemplateVersionID = @TemplateVersionID;
END;
GO

CREATE PROCEDURE GetProviderProfileFieldById
    @FieldID UNIQUEIDENTIFIER
AS
BEGIN
    SELECT * FROM ProviderProfileFields WHERE FieldID = @FieldID;
END;
GO

CREATE PROCEDURE GetProviderProfileFieldsByProviderID
    @ProviderID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        FieldID,
        ProviderID,
        FieldName,
        FieldTypeID,
        IsRequired,
        SortOrder
    FROM ProviderProfileFields
    WHERE ProviderID = @ProviderID
    ORDER BY SortOrder;
END;
GO

CREATE PROCEDURE dbo.GetResolverById
  @ResolverID UNIQUEIDENTIFIER
AS
BEGIN
  SET NOCOUNT ON;

  SELECT ResolverID, ResolverType, Target, Description
  FROM dbo.Resolvers
  WHERE ResolverID = @ResolverID;
END;
GO

CREATE PROCEDURE dbo.GetResolverByTypeAndTarget
  @ResolverType NVARCHAR(100),
  @Target NVARCHAR(MAX)
AS
BEGIN
  SET NOCOUNT ON;

  SELECT ResolverID, ResolverType, Target, Description
  FROM dbo.Resolvers
  WHERE ResolverType = @ResolverType
    AND Target = @Target;
END;
GO


CREATE PROCEDURE GetRoleById
    @RoleID NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM AspNetRoles WHERE Id = @RoleID;
END;

GO

-- ================================================
-- ✅ Stored Procedure: GetSettingKeyById
-- Description: Retrieves a setting key by ID
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE GetSettingKeyById
  @SettingKeyID UNIQUEIDENTIFIER
AS
BEGIN
  SET NOCOUNT ON;

  SELECT SettingKeyID, KeyName, Label, ValueType, DomainID
  FROM SettingKeys
  WHERE SettingKeyID = @SettingKeyID;
END;
GO

-- ================================================
-- ✅ Stored Procedure: GetSettingKeyByKeyName
-- Description: Retrieves a setting key by KeyName
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE GetSettingKeyByKeyName
  @KeyName NVARCHAR(100)
AS
BEGIN
  SET NOCOUNT ON;

  SELECT SettingKeyID, KeyName, Label, ValueType, DomainID
  FROM SettingKeys
  WHERE KeyName = @KeyName;
END;
GO


CREATE PROCEDURE GetSubscriptionsByUser
    @UserID NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM SubscriptionPlans WHERE UserID = @UserID;
END;

GO


CREATE PROCEDURE GetSystemLogs
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM SystemLogs ORDER BY CreatedAt DESC;
END;

GO

-- ================================================
-- ✅ Stored Procedure: GetSystemValueTypeByName
-- Description: Returns a single value type by name
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE GetSystemValueTypeByName
  @ValueType NVARCHAR(50)
AS
BEGIN
  SET NOCOUNT ON;

  SELECT ValueType, Description, IsStructured, CreatedAt
  FROM SystemValueTypes
  WHERE ValueType = @ValueType;
END;
GO

-- ================================================
-- ✅ Stored Procedure: GetThemeDefinitionById
-- Description: Retrieves a ThemeDefinition by ID
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE dbo.GetThemeDefinitionById
(
    @ThemeDefinitionID UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM dbo.ThemeDefinitions
    WHERE ThemeDefinitionID = @ThemeDefinitionID;
END;
GO


CREATE PROCEDURE GetTransactionsByUser
    @UserID NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM Transactions WHERE UserID = @UserID;
END;

GO


CREATE PROCEDURE GetUserById
    @UserID NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM AspNetUsers WHERE Id = @UserID;
END;

GO

-- =============================================
-- ✅ GetUserIDbyKey
-- =============================================
CREATE PROCEDURE GetUserIDbyKey
    @ApiKey NVARCHAR(64)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT UserID FROM skylynxnet_coredb.dbo.API_Owners
    WHERE EXISTS (SELECT 1 FROM skylynxnet_coredb.dbo.APIKeys WHERE ApiKey = @ApiKey);
END;
GO


-- ✅ Get User Logins
CREATE PROCEDURE GetUserLogins
    @UserID NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM AspNetUserLogins WHERE UserId = @UserID;
END;

GO

CREATE PROCEDURE GetUserProfile
    @UserID NVARCHAR(128),
    @ProviderID UNIQUEIDENTIFIER,
    @PortalID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM UserProfiles
    WHERE UserID = @UserID AND ProviderID = @ProviderID AND PortalID = @PortalID;
END;
GO


CREATE PROCEDURE GetUserProfileByID
    @UserID NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT up.*, cp.ProviderName, cp.ExternalProfileID
    FROM UserProfiles up
    LEFT JOIN CustomerProfile_Providers cp ON up.PrimaryProviderID = cp.ProviderID
    WHERE up.UserID = @UserID;
END;

GO

-- ================================================
-- ✅ Stored Procedure: GetUserProfileByUserID
-- Description: Returns full user profile and related metadata for a given user
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE GetUserProfileByUserID
  @UserID NVARCHAR(128),
  @PortalName NVARCHAR(100) = NULL
AS
BEGIN
  SET NOCOUNT ON;

  SELECT TOP 1 *
  FROM vw_FullUserProfileDev  -- your aliased view
  WHERE UserID = @UserID
    AND (@PortalName IS NULL OR PortalName = @PortalName);
END;
GO

CREATE PROCEDURE GetUserProviderProfileFieldData
    @UserID NVARCHAR(128),
    @ProviderID UNIQUEIDENTIFIER,
    @FieldID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM UserProviderProfiles
    WHERE UserID = @UserID AND ProviderID = @ProviderID AND FieldID = @FieldID;
END;
GO

CREATE PROCEDURE GetUserProviderProfiles
    @UserID NVARCHAR(128),
    @ProviderID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM UserProviderProfiles
    WHERE UserID = @UserID AND ProviderID = @ProviderID;
END;
GO

CREATE PROCEDURE GetUserProviderProfilesByPortalProvider
    @ProviderID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM UserProviderProfiles
    WHERE ProviderID = @ProviderID;
END;
GO

CREATE PROCEDURE GetUserProviderProfilesFieldsByUser
    @UserID NVARCHAR(128),
    @ProviderID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    SELECT *
    FROM UserProviderProfiles
    WHERE UserID = @UserID AND ProviderID = @ProviderID;
END;
GO


CREATE PROCEDURE GetUserRoles
    @UserID NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT r.Id, r.Name
    FROM AspNetUserRoles ur
    JOIN AspNetRoles r ON ur.RoleId = r.Id
    WHERE ur.UserId = @UserID;
END;

GO


-- ✅ Get User Tokens
CREATE PROCEDURE GetUserTokens
    @UserID NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM AspNetUserTokens WHERE UserId = @UserID;
END;

GO

CREATE PROCEDURE LoadDyFormViewModelLayout
(
    @ViewModelName NVARCHAR(100)
)
AS
BEGIN
    SET NOCOUNT ON;

    -- 🧩 Get ViewModelDefinitionID from Name
    DECLARE @ViewModelDefinitionID UNIQUEIDENTIFIER;

    SELECT @ViewModelDefinitionID = ViewModelDefinitionID
    FROM DyFormViewModelDefinition
    WHERE ViewModelName = @ViewModelName;

    IF @ViewModelDefinitionID IS NULL
    BEGIN
        RAISERROR('Invalid ViewModelName: %s', 16, 1, @ViewModelName);
        RETURN;
    END

    -- 🔹 Step 1: Sections linked to ViewModel
    SELECT DISTINCT
        s.SectionID,
        s.SectionName,
        s.Label,
        s.SortOrder
    FROM DyFormFieldSectionDefinition fsd
    JOIN DyFormSection s ON fsd.SectionID = s.SectionID
    WHERE fsd.ViewModelDefinitionID = @ViewModelDefinitionID
    ORDER BY s.SortOrder;

    -- 🔹 Step 2: Fields per section for ViewModel
    SELECT
        fsd.SectionID,
        f.DyFormFieldID,
        f.Label,
        f.Tooltip,
        f.FieldTypeID,
        ft.FieldTypeName,
        ft.ComponentName,
        fsd.SortOrder AS FieldSortOrder,
        dsd.SourceKey,
        dsd.SourcePath,
        dsd.IsDirectProperty
    FROM DyFormFieldSectionDefinition fsd
    JOIN DyFormField f ON fsd.DyFormFieldID = f.DyFormFieldID
    JOIN DyFormFieldType ft ON f.FieldTypeID = ft.FieldTypeID
    JOIN DyFormDataSourceDefinition dsd ON fsd.DyFormDSDefinitionID = dsd.DyFormDSDefinitionID
    WHERE fsd.ViewModelDefinitionID = @ViewModelDefinitionID
    ORDER BY fsd.SectionID, fsd.SortOrder;

END;
GO

-- ================================================
-- ✅ Procedure: LoadProtosTemplateTree
-- Description: Loads template hierarchy with proper type and resolver metadata
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE LoadProtosTemplateTree
(
    @TemplateName NVARCHAR(100),
    @PortalName NVARCHAR(100),
    @ModuleName NVARCHAR(100)
)
AS
BEGIN
    SET NOCOUNT ON;

    -- ✅ Step 1: Resolve Root TemplateVersionID
    DECLARE @TemplateVersionID UNIQUEIDENTIFIER;

    SELECT TOP 1 
        @TemplateVersionID = tv.TemplateVersionID
    FROM ProtosTemplate tpl
    JOIN ProtosTemplateVersion tv ON tv.TemplateID = tpl.TemplateID
    WHERE tpl.TemplateName = @TemplateName
    ORDER BY tv.VersionNumber DESC;

    IF @TemplateVersionID IS NULL
    BEGIN
        RAISERROR('Template not found for name: %s', 16, 1, @TemplateName);
        RETURN;
    END

    -- ================================================
    -- 📦 Result Set 1: Root Template + Portal + Module
    -- ================================================
    SELECT 
        tpl.TemplateID,
        tpl.TemplateName,
        tpl.TemplateType,  -- ✅ keep as string
        tv.TemplateVersionID,
        tv.VersionNumber,
        tv.VersionLabel,
        tv.CreatedAt AS VersionCreatedAt,
        link.TemplateLinkID,
        link.TargetTypeID,
        tgtType.TargetTypeName,
        link.TargetObjectID,
        link.IsDefault,
        res.ResolverID,
        res.ResolverType,
        res.Target AS ResolverTarget,
        res.Description AS ResolverDescription,
        p.PortalID,
        p.PortalName,
        p.Description AS PortalDescription,
        m.ModuleID,
        m.ModuleName,
        m.ModuleDescription
    FROM ProtosTemplate tpl
    JOIN ProtosTemplateVersion tv ON tv.TemplateID = tpl.TemplateID
    LEFT JOIN ProtosTemplateLink link ON link.TemplateVersionID = tv.TemplateVersionID
    LEFT JOIN Resolvers res ON link.ResolverID = res.ResolverID
    LEFT JOIN ProtosTargetType tgtType ON link.TargetTypeID = tgtType.TargetTypeID
    LEFT JOIN Portals p ON p.PortalName = @PortalName
    LEFT JOIN Modules m ON m.ModuleName = @ModuleName
    WHERE tv.TemplateVersionID = @TemplateVersionID;

    -- ================================================
    -- 📦 Result Set 2: All Descendants (Flat Tree)
    -- ================================================
    ;WITH TemplateTree AS (
        SELECT 
            pt.ChildVersionID,
            pt.ParentVersionID,
            0 AS Depth
        FROM ProtosTemplateTree pt
        WHERE pt.ParentVersionID = @TemplateVersionID

        UNION ALL

        SELECT 
            pt2.ChildVersionID,
            pt2.ParentVersionID,
            t.Depth + 1
        FROM ProtosTemplateTree pt2
        JOIN TemplateTree t ON pt2.ParentVersionID = t.ChildVersionID
    )
    SELECT 
        tpl.TemplateID,
        tpl.TemplateName,
        tpl.TemplateType,  -- ✅ keep this
        tv.TemplateVersionID,
        tv.VersionNumber,
        tv.VersionLabel,
        tv.CreatedAt AS VersionCreatedAt,
        link.TemplateLinkID,
        link.TargetTypeID,
        tgtType.TargetTypeName,
        link.TargetObjectID,
        link.IsDefault,
        res.ResolverID,
        res.ResolverType,
        res.Target AS ResolverTarget,
        res.Description AS ResolverDescription,
        t.Depth,
        t.ParentVersionID
    FROM TemplateTree t
    JOIN ProtosTemplateVersion tv ON t.ChildVersionID = tv.TemplateVersionID
    JOIN ProtosTemplate tpl ON tpl.TemplateID = tv.TemplateID
    LEFT JOIN ProtosTemplateLink link ON link.TemplateVersionID = tv.TemplateVersionID
    LEFT JOIN Resolvers res ON link.ResolverID = res.ResolverID
    LEFT JOIN ProtosTargetType tgtType ON link.TargetTypeID = tgtType.TargetTypeID
    ORDER BY t.Depth, tv.VersionNumber;

END;
GO

-- ================================================
-- ✅ Procedure: LoadSkylynxPortalTree
-- Description: Loads full template tree for a given Portal using vw_ProtosFullFlatTree
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- Last Updated: 2025-07-09
-- ================================================
CREATE PROCEDURE LoadSkylynxPortalTree
(
    @PortalName NVARCHAR(100)
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @PortalID UNIQUEIDENTIFIER;

    -- 🔹 Resolve PortalID
    SELECT @PortalID = PortalID
    FROM Portals
    WHERE PortalName = @PortalName;

    IF @PortalID IS NULL
    BEGIN
        RAISERROR('Portal not found: %s', 16, 1, @PortalName);
        RETURN;
    END

    -- ================================================
    -- 🔁 Recursive CTE: Build tree from Portal root down
    -- ================================================
    ;WITH TreeCTE AS (
        -- 🟢 Step 1: Start with root nodes (Portal templates)
        SELECT *
        FROM vw_ProtosFullFlatTree
        WHERE ParentTemplateType = 'Portal'
          AND ParentObjectID = @PortalID

        UNION ALL

        -- 🔁 Step 2: Recurse down the template hierarchy
        SELECT child.*
        FROM vw_ProtosFullFlatTree child
        JOIN TreeCTE parent ON child.ParentTemplateID = parent.ChildTemplateID
    )
    SELECT *
    FROM TreeCTE
    ORDER BY CreatedAt;

END;
GO

-- ================================================
-- ✅ Stored Procedure: GetUserFullProfileViewModel
-- Description: Returns full user profile via wrapped atomic SPs (Header, Address, ProfileFields)
-- Author: SkyLynx Pattern
-- Last Updated: 2025-06-20 23:17:00
-- ================================================
CREATE   PROCEDURE GetUserFullProfileViewModel
    @UserID NVARCHAR(128),
    @PortalName NVARCHAR(256),
    @PortalID UNIQUEIDENTIFIER = NULL,
    @ProviderID UNIQUEIDENTIFIER = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Step 1: Validate or resolve PortalID + ProviderID
    IF @PortalID IS NOT NULL AND @ProviderID IS NOT NULL
    BEGIN
        EXEC GetPortalProfileProviderByKeys
            @PortalID = @PortalID,
            @ProviderID = @ProviderID;
    END
    ELSE
    BEGIN
        -- Resolve both via PortalName default
        EXEC GetDefaultProviderByPortalName
            @PortalName = @PortalName,
            @PortalID = @PortalID OUTPUT,
            @ProviderID = @ProviderID OUTPUT;
    END

    -- Step 2: Load Header (AspNetUsers base)
    EXEC GetAspNetUserById @UserID = @UserID;

    -- Step 3: Pull AddressID + BillingAddressID from UserProfiles
    DECLARE @AddressID UNIQUEIDENTIFIER;
    DECLARE @BillingAddressID UNIQUEIDENTIFIER;

    SELECT
        @AddressID = AddressID,
        @BillingAddressID = BillingAddressID
    FROM UserProfiles
    WHERE UserID = @UserID AND PortalID = @PortalID AND ProviderID = @ProviderID;

    -- Step 4: Mailing Address
    EXEC GetAddressById @AddyID = @AddressID;

    -- Step 5: Billing Address
    EXEC GetAddressById @AddyID = @BillingAddressID;

    -- Step 6: Profile Field Definitions (DyForm-like metadata)
    EXEC GetProviderProfileFieldsByProviderID @ProviderID = @ProviderID;

    -- Step 7: Profile Field Values for this user
    EXEC GetAllProviderProfilesByUser @UserID = @UserID;
END;
GO


CREATE PROCEDURE LogSystemEvent
    @LogType NVARCHAR(50),
    @LogMessage NVARCHAR(MAX),
    @LogID UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @LogID = NEWID();
    INSERT INTO SystemLogs (LogID, LogType, LogMessage, CreatedAt)
    VALUES (@LogID, @LogType, @LogMessage, GETDATE());
END;

GO


CREATE PROCEDURE RemoveModuleFromPortal
    @ModuleID UNIQUEIDENTIFIER,
    @PortalID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM PortalModules WHERE ModuleID = @ModuleID AND PortalID = @PortalID;
END;

GO


CREATE PROCEDURE RemoveUserRole
    @UserID NVARCHAR(128),
    @RoleID NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM AspNetUserRoles WHERE UserId = @UserID AND RoleId = @RoleID;
END;

GO

-- ================================================
-- ✅ UpdateAddress
-- Description: Updates fields of an existing address by ID
-- ================================================
CREATE   PROCEDURE UpdateAddress
    @AddyId UNIQUEIDENTIFIER,
    @Address1 NVARCHAR(MAX) = NULL,
    @Address2 NVARCHAR(MAX) = NULL,
    @City NVARCHAR(MAX) = NULL,
    @StateProvinceID UNIQUEIDENTIFIER = NULL,
    @Zip NVARCHAR(10) = NULL,
    @GeoLocation GEOGRAPHY = NULL,
    @IsMailing BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE Address
    SET 
        address_1 = @Address1,
        address_2 = @Address2,
        City = @City,
        StateProvinceID = @StateProvinceID,
        Zip = @Zip,
        geoLocation = @GeoLocation,
        isMailing = @IsMailing,
        ModifiedDate = GETDATE()
    WHERE addyId = @AddyId;
END;
GO

-- =============================================
-- ✅ UPDATE PROCEDURE: UpdateAPI_Owner
-- Updates an API_Owner's fields
-- =============================================
CREATE PROCEDURE UpdateAPI_Owner
    @OwnerUUID UNIQUEIDENTIFIER,
    @UserID NVARCHAR(128),
    @ModuleID UNIQUEIDENTIFIER,
    @PortalID UNIQUEIDENTIFIER,
    @OwnerTypeID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE skylynxnet_coredb.dbo.API_Owners
    SET UserID = @UserID,
        ModuleID = @ModuleID,
        PortalID = @PortalID,
        OwnerTypeID = @OwnerTypeID
    WHERE OwnerUUID = @OwnerUUID;
END;
GO

-- ============================================
-- 🔹 Update API Key
-- ============================================
CREATE PROCEDURE UpdateApiKey
    @ApiKeyID UNIQUEIDENTIFIER,
    @KeyHash NVARCHAR(256),
    @ExpiresAt DATETIME,
    @IsActive BIT
AS
BEGIN
    UPDATE skylynxnet_coredb.dbo.API_KEYS
    SET KeyHash = @KeyHash,
        ExpiresAt = @ExpiresAt,
        IsActive = @IsActive
    WHERE ApiKeyID = @ApiKeyID;
END;
GO

-- ================================================
-- ✅ Procedure: UpdateAspNetUser
-- Description: Updates a user's core identity fields
-- ================================================
CREATE PROCEDURE UpdateAspNetUser
(
    @UserID NVARCHAR(128),
    @UserName NVARCHAR(256),
    @Email NVARCHAR(256),
    @EmailConfirmed BIT,
    @PhoneNumber NVARCHAR(50),
    @PhoneNumberConfirmed BIT,
    @TwoFactorEnabled BIT,
    @AccessFailedCount INT
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE AspNetUsers
    SET
        UserName = @UserName,
        Email = @Email,
        EmailConfirmed = @EmailConfirmed,
        PhoneNumber = @PhoneNumber,
        PhoneNumberConfirmed = @PhoneNumberConfirmed,
        TwoFactorEnabled = @TwoFactorEnabled,
        AccessFailedCount = @AccessFailedCount
    WHERE Id = @UserID;
END;
GO


-- ✅ Update a User Claim
CREATE PROCEDURE UpdateClaim
    @ClaimID INT,
    @ClaimType NVARCHAR(255),
    @ClaimValue NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE AspNetUserClaims SET ClaimType = @ClaimType, ClaimValue = @ClaimValue WHERE Id = @ClaimID;
END;

GO

CREATE PROCEDURE dbo.UpdateDyForm
(
    @FormID UNIQUEIDENTIFIER,
    @FormName NVARCHAR(100),
    @Description NVARCHAR(255)
)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.DyForm
    SET FormName = @FormName,
        Description = @Description
    WHERE FormID = @FormID;
END;
GO

-- ================================================
-- ✅ Stored Procedure: UpdateDyFormDataSourceDefinition
-- Description: Update an existing DyFormDataSourceDefinition
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE dbo.UpdateDyFormDataSourceDefinition
    @DyFormDSDefinitionID UNIQUEIDENTIFIER,
    @SourceKey NVARCHAR(255),
    @IsDirectProperty BIT,
    @SourcePath NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.DyFormDataSourceDefinition
    SET
        SourceKey = @SourceKey,
        IsDirectProperty = @IsDirectProperty,
        SourcePath = @SourcePath
    WHERE DyFormDSDefinitionID = @DyFormDSDefinitionID;
END;
GO

CREATE PROCEDURE dbo.UpdateDyFormDomain
(
    @DomainID UNIQUEIDENTIFIER,
    @Name NVARCHAR(100),
    @DomainTypeID UNIQUEIDENTIFIER,
    @Description NVARCHAR(255)
)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.DyFormDomains
    SET Name = @Name,
        DomainTypeID = @DomainTypeID,
        Description = @Description
    WHERE DomainID = @DomainID;
END;
GO

CREATE PROCEDURE dbo.UpdateDyFormDomainValues
(
    @DomainValueID UNIQUEIDENTIFIER,
    @DomainID UNIQUEIDENTIFIER,
    @Value NVARCHAR(200),
    @Label NVARCHAR(200),
    @SortOrder INT
)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.DyFormDomainValues
    SET DomainValueID = @DomainValueID,
        Value = @Value,
        Label = @Label,
        SortOrder = @SortOrder
    WHERE DomainValueID = @DomainValueID;
END;
GO

CREATE PROCEDURE dbo.UpdateDyFormExpression
(
    @DyFormExpressionID UNIQUEIDENTIFIER,
    @ResolverTypeID UNIQUEIDENTIFIER,
    @Expression NVARCHAR(MAX),
    @Description NVARCHAR(255)
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.DyFormExpression
    SET
        ResolverTypeID = @ResolverTypeID,
        Expression = @Expression,
        Description = @Description
    WHERE DyFormExpressionID = @DyFormExpressionID;
END;
GO

-- ================================================
-- ✅ Procedure: UpdateDyFormField
-- Description: Update an existing DyFormField
-- ================================================
CREATE PROCEDURE UpdateDyFormField
    @DyFormFieldID UNIQUEIDENTIFIER,
    @FieldTypeID UNIQUEIDENTIFIER,
    @Tooltip NVARCHAR(255),
    @Label NVARCHAR(255),
    @DomainID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE skylynxnet_coredb.dbo.DyFormField
    SET FieldTypeID = @FieldTypeID,
        Tooltip = @Tooltip,
        Label = @Label,
        DomainID = @DomainID
    WHERE DyFormFieldID = @DyFormFieldID;
END;
GO

CREATE PROCEDURE dbo.UpdateDyFormFieldRule
(
    @RuleID UNIQUEIDENTIFIER,
    @FieldID UNIQUEIDENTIFIER,
    @RuleTypeID UNIQUEIDENTIFIER,
    @ResolverTypeID UNIQUEIDENTIFIER,
    @RuleExpression NVARCHAR(MAX),
    @IsEnabled BIT,
    @Priority INT,
    @ErrorMessage NVARCHAR(255)
)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.DyFormFieldRule
    SET RuleID = @RuleID,
        RuleExpression = @RuleExpression,
        IsEnabled = @IsEnabled,
        Priority = @Priority,
        ErrorMessage = @ErrorMessage
    WHERE RuleID = @RuleID;
END;
GO

-- ================================================
-- ✅ Stored Procedure: UpdateDyFormFieldSectionDefinition
-- Description: Update existing DyFormFieldSectionDefinition
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE dbo.UpdateDyFormFieldSectionDefinition
    @SectionDefinitionID UNIQUEIDENTIFIER,
    @SectionID UNIQUEIDENTIFIER,
    @DyFormFieldID UNIQUEIDENTIFIER,
    @ViewModelDefinitionID UNIQUEIDENTIFIER,
    @SortOrder INT,
    @DyFormDSDefinitionID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.DyFormFieldSectionDefinition
    SET
        SectionID = @SectionID,
        DyFormFieldID = @DyFormFieldID,
        ViewModelDefinitionID = @ViewModelDefinitionID,
        SortOrder = @SortOrder,
        DyFormDSDefinitionID = @DyFormDSDefinitionID
    WHERE SectionDefinitionID = @SectionDefinitionID;
END;
GO

CREATE PROCEDURE dbo.UpdateDyFormFieldType
(
    @FieldTypeID UNIQUEIDENTIFIER,
    @FieldTypeName NVARCHAR(100),
    @ComponentName NVARCHAR(100)
)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.DyFormFieldType
    SET FieldTypeID = @FieldTypeID,
        FieldTypeName = @FieldTypeName,
        ComponentName = @ComponentName
    WHERE FieldTypeID = @FieldTypeID;
END;
GO

-- ================================================
-- ✅ Procedure: UpdateDyFormResolver
-- Description: Update an existing DyFormResolver row
-- ================================================
CREATE PROCEDURE dbo.UpdateDyFormResolver
    @DyFormID UNIQUEIDENTIFIER,
    @ResolverContext NVARCHAR(50),
    @ResolverTypeID UNIQUEIDENTIFIER,
    @ResolverTarget NVARCHAR(255),
    @Description NVARCHAR(1000) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.DyFormResolvers
    SET
        ResolverTypeID = @ResolverTypeID,
        ResolverTarget = @ResolverTarget,
        Description = @Description,
        UpdatedAt = GETDATE()
    WHERE
        DyFormID = @DyFormID AND
        ResolverContext = @ResolverContext;
END;
GO

CREATE PROCEDURE dbo.UpdateDyFormResolverType
(
    @ResolverTypeID UNIQUEIDENTIFIER,
    @Name NVARCHAR(100),
    @Description NVARCHAR(255)
)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.DyFormResolverType
    SET ResolverTypeID = @ResolverTypeID,
        Name = @Name,
        Description = @Description
    WHERE ResolverTypeID = @ResolverTypeID;
END;
GO

CREATE PROCEDURE dbo.UpdateDyFormRuleDefinition
    @RuleDefinitionID UNIQUEIDENTIFIER,
    @RuleKey NVARCHAR(100),
    @ResolverTypeID UNIQUEIDENTIFIER,
    @DyFormExpressionID UNIQUEIDENTIFIER,
    @Description NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.DyFormRuleDefinition
    SET
        RuleKey = @RuleKey,
        ResolverTypeID = @ResolverTypeID,
        DyFormExpressionID = @DyFormExpressionID,
        Description = @Description
    WHERE RuleDefinitionID = @RuleDefinitionID;
END;
GO

-- ================================================
-- ✅ Stored Procedure: UpdateDyFormRuleSyntax
-- ================================================
CREATE PROCEDURE dbo.UpdateDyFormRuleSyntax
    @RuleSyntaxID UNIQUEIDENTIFIER,    -- The ID of the rule syntax to update
    @SyntaxName NVARCHAR(100),         -- The new name for the rule
    @Description NVARCHAR(255) = NULL  -- The new description for the rule
AS
BEGIN
    SET NOCOUNT ON;

    -- Update rule syntax by ID
    UPDATE skylynxnet_coredb.dbo.DyFormRuleSyntax
    SET SyntaxName = @SyntaxName, Description = @Description, UpdatedAt = GETDATE()
    WHERE RuleSyntaxID = @RuleSyntaxID;
END;
GO

-- ✏️ UPDATE
CREATE PROCEDURE dbo.UpdateDyFormRuleTarget
    @RuleTargetID UNIQUEIDENTIFIER,
    @RuleDefinitionID UNIQUEIDENTIFIER,
    @ViewModelDefinitionID UNIQUEIDENTIFIER,
    @DyFormFieldID UNIQUEIDENTIFIER = NULL,
    @SectionID UNIQUEIDENTIFIER = NULL,
    @SortOrder INT = 0,
    @Notes NVARCHAR(1000) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.DyFormRuleTarget
    SET RuleDefinitionID = @RuleDefinitionID,
        ViewModelDefinitionID = @ViewModelDefinitionID,
        DyFormFieldID = @DyFormFieldID,
        SectionID = @SectionID,
        SortOrder = @SortOrder,
        Notes = @Notes
    WHERE RuleTargetID = @RuleTargetID;
END;
GO

CREATE PROCEDURE dbo.UpdateDyFormRuleType
(
    @RuleTypeID UNIQUEIDENTIFIER,
    @Name NVARCHAR(100),
    @Description NVARCHAR(255)
)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.DyFormRuleType
    SET RuleTypeID = @RuleTypeID,
        Name = @Name,
        Description = @Description
    WHERE RuleTypeID = @RuleTypeID;
END;
GO

CREATE PROCEDURE dbo.UpdateDyFormSection
    @SectionID UNIQUEIDENTIFIER,
    @SectionName NVARCHAR(100),
    @Label NVARCHAR(255) = NULL,
    @SortOrder INT = 0
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.DyFormSection
    SET SectionName = @SectionName,
        Label = @Label,
        SortOrder = @SortOrder
    WHERE SectionID = @SectionID;
END;
GO

-- ================================================
-- ✅ Optional Update Procedure: UpdateDyFormSectionResolver
-- ================================================
CREATE PROCEDURE dbo.UpdateDyFormSectionResolver
(
    @DyFormID UNIQUEIDENTIFIER,
    @SectionID UNIQUEIDENTIFIER,
    @ResolverContext NVARCHAR(50),
    @ResolverTypeID UNIQUEIDENTIFIER,
    @ResolverTarget NVARCHAR(255),
    @IsActive BIT,
    @Notes NVARCHAR(1000)
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.DyFormSectionResolvers
    SET ResolverTypeID = @ResolverTypeID,
        ResolverTarget = @ResolverTarget,
        IsActive = @IsActive,
        Notes = @Notes,
        UpdatedAt = GETDATE()
    WHERE DyFormID = @DyFormID
      AND SectionID = @SectionID
      AND ResolverContext = @ResolverContext;
END;
GO

-- ================================================
-- ✅ Procedure: UpdateDyFormSections
-- Description: Update DyFormSections record
-- ================================================
CREATE PROCEDURE dbo.UpdateDyFormSections
(
    @FormSectionID UNIQUEIDENTIFIER,
    @FormID UNIQUEIDENTIFIER,
    @SectionID UNIQUEIDENTIFIER,
    @ParentFormSectionID UNIQUEIDENTIFIER = NULL,
    @SortOrder INT = 0
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.DyFormSections
    SET
        FormID = @FormID,
        SectionID = @SectionID,
        ParentFormSectionID = @ParentFormSectionID,
        SortOrder = @SortOrder
    WHERE
        FormSectionID = @FormSectionID;
END;
GO

-- ================================================
-- ✅ Procedure: UpdateDyFormViewModelDefinition
-- ================================================
CREATE PROCEDURE UpdateDyFormViewModelDefinition
    @ViewModelDefinitionID UNIQUEIDENTIFIER,
    @ViewModelName NVARCHAR(100),
    @DestKey NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE DyFormViewModelDefinition
    SET
        ViewModelName = @ViewModelName,
        DestKey = @DestKey
    WHERE ViewModelDefinitionID = @ViewModelDefinitionID;
END;
GO

-- ================================================
-- 4️⃣ UPDATE
-- ================================================
CREATE PROCEDURE dbo.UpdateGlobalModuleSetting
(
    @ModuleID UNIQUEIDENTIFIER,
    @SettingKeyID UNIQUEIDENTIFIER,
    @RoleID NVARCHAR(128),
    @Value NVARCHAR(MAX)
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.GlobalModuleSettings
    SET Value = @Value,
        UpdatedAt = GETDATE()
    WHERE ModuleID = @ModuleID
      AND SettingKeyID = @SettingKeyID
      AND RoleID = @RoleID;
END;
GO

-- ================================================
-- ✅ Stored Procedure: UpdateGlobalPortalSetting
-- Description: Updates value for an existing setting key
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE UpdateGlobalPortalSetting
  @SettingKeyID UNIQUEIDENTIFIER,
  @NewValue NVARCHAR(MAX)
AS
BEGIN
  SET NOCOUNT ON;

  UPDATE GlobalPortalSettings
  SET Value = @NewValue,
      UpdatedAt = GETDATE()
  WHERE SettingKeyID = @SettingKeyID;
END;
GO

CREATE PROCEDURE UpdateLanguage
    @LanguageCode NVARCHAR(2),
    @LanguageName NVARCHAR(100)
AS
BEGIN
    UPDATE ISO6391_Languages
    SET LanguageName = @LanguageName
    WHERE LanguageCode = @LanguageCode;
END;
GO

CREATE PROCEDURE dbo.UpdateLayout
(
    @LayoutID UNIQUEIDENTIFIER,
    @DisplayName NVARCHAR(255),
    @LayoutType NVARCHAR(100) = NULL,
    @Description NVARCHAR(255) = NULL,
    @HasSidebar BIT = 1,
    @HasHeader BIT = 1,
    @HasFooter BIT = 1,
    @HasNavigation BIT = 1,
    @HasContentPane BIT = 1,
    @StyledID UNIQUEIDENTIFIER = NULL,
    @componentName NVARCHAR(255) = NULL,
    @componentPath NVARCHAR(255) = NULL,
    @ComponentConfig NVARCHAR(MAX) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Layouts
    SET
        DisplayName = @DisplayName,
        LayoutType = @LayoutType,
        Description = @Description,
        HasSidebar = @HasSidebar,
        HasHeader = @HasHeader,
        HasFooter = @HasFooter,
        HasNavigation = @HasNavigation,
        HasContentPane = @HasContentPane,
        StyledID = @StyledID,
        componentName = @componentName,
        componentPath = @componentPath,
        ComponentConfig = @ComponentConfig
    WHERE LayoutID = @LayoutID;
END;
GO

CREATE PROCEDURE dbo.UpdateModule
(
    @ModuleID UNIQUEIDENTIFIER,
    @ModuleName NVARCHAR(50),
    @ModuleDescription NVARCHAR(100),
    @ImageFilePath NVARCHAR(MAX),
    @ModuleVersion INT,
    @componentPath NVARCHAR(255),
    @componentName NVARCHAR(255) = NULL,
    @ComponentConfig NVARCHAR(MAX) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.Modules
    SET
        ModuleName = @ModuleName,
        ModuleDescription = @ModuleDescription,
        ImageFilePath = @ImageFilePath,
        ModuleVersion = @ModuleVersion,
        componentPath = @componentPath,
        componentName = @componentName,
        ComponentConfig = @ComponentConfig
    WHERE ModuleID = @ModuleID;
END;
GO

-- ================================================
-- ✅ Stored Procedure: UpdateModuleSetting
-- Description: Updates value for a specific module/role/key
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE UpdateModuleSetting
  @PortalModuleID UNIQUEIDENTIFIER,
  @SettingKeyID UNIQUEIDENTIFIER,
  @RoleID NVARCHAR(128),
  @NewValue NVARCHAR(MAX)
AS
BEGIN
  SET NOCOUNT ON;

  UPDATE ModuleSettings
  SET Value = @NewValue,
      UpdatedAt = GETDATE()
  WHERE PortalModuleID = @PortalModuleID
    AND SettingKeyID = @SettingKeyID
    AND RoleID = @RoleID;
END;
GO


CREATE PROCEDURE UpdateOwnerType
    @OwnerTypeID UNIQUEIDENTIFIER,
    @OwnerTypeName NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE OwnerTypes SET OwnerTypeName = @OwnerTypeName WHERE OwnerTypeID = @OwnerTypeID;
END;

GO

CREATE PROCEDURE dbo.UpdatePageDefinition
(
    @PageID UNIQUEIDENTIFIER,
    @RoutePath NVARCHAR(255),
    @PageTitle NVARCHAR(100) = NULL,
    @MenuIcon NVARCHAR(100) = NULL,
    @RequiresAuth BIT = 1,
    @RoleID NVARCHAR(128) = NULL,
    @Notes NVARCHAR(255) = NULL,
    @componentName NVARCHAR(255) = NULL,
    @componentPath NVARCHAR(255) = NULL,
    @ComponentConfig NVARCHAR(MAX) = NULL,
    @StyledID UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.PageDefinition
    SET
        RoutePath = @RoutePath,
        PageTitle = @PageTitle,
        MenuIcon = @MenuIcon,
        RequiresAuth = @RequiresAuth,
        RoleID = @RoleID,
        Notes = @Notes,
        componentName = @componentName,
        componentPath = @componentPath,
        ComponentConfig = @ComponentConfig,
        StyledID = @StyledID
    WHERE PageID = @PageID;
END;
GO

-- ================================================
-- ✅ Stored Procedure: UpdatePortal
-- Description: Updates portal properties
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE UpdatePortal
    @PortalID UNIQUEIDENTIFIER,
    @PortalName NVARCHAR(100),
    @Description NVARCHAR(MAX),
    @SplashImage NVARCHAR(255) = NULL,
    @Status NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE skylynxnet_coredb.dbo.Portals
    SET
        PortalName = @PortalName,
        Description = @Description,
        SplashImage = ISNULL(@SplashImage, SplashImage),
        Status = ISNULL(@Status, Status)
    WHERE PortalID = @PortalID;

    -- No need to set LastUpdated; trigger will handle it.
END;
GO

-- ================================================
-- ✅ Stored Procedure: UpdatePortalProfileProvider
-- Description: Updates IsPortalDefault for a given (PortalID, ProviderID) pair
-- ================================================
CREATE   PROCEDURE UpdatePortalProfileProvider
    @PortalID UNIQUEIDENTIFIER,
    @ProviderID UNIQUEIDENTIFIER,
    @IsPortalDefault BIT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE PortalProfileProviders
    SET IsPortalDefault = @IsPortalDefault
    WHERE PortalID = @PortalID AND ProviderID = @ProviderID;
END;
GO

CREATE PROCEDURE UpdateProfileProvider
    @ProviderID UNIQUEIDENTIFIER,
    @ProviderName NVARCHAR(100),
    @IsSystemDefault BIT,
    @Description NVARCHAR(255)
AS
BEGIN
    UPDATE ProfileProviders
    SET ProviderName = @ProviderName,
        IsSystemDefault = @IsSystemDefault,
        Description = @Description
    WHERE ProviderID = @ProviderID;
END;
GO

-- ================================================
-- ✅ Stored Procedure: UpdateProtosDataModel
-- Description: Updates a ProtosDataModelDefinition record by DataModelID
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE dbo.UpdateProtosDataModel
(
    @DataModelID UNIQUEIDENTIFIER,
    @DataModelName NVARCHAR(100),
    @DataModelJSON NVARCHAR(MAX) = NULL,
    @Description NVARCHAR(255) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.ProtosDataModelDefinition
    SET 
        DataModelName = @DataModelName,
        DataModelJSON = @DataModelJSON,
        Description = @Description,
        UpdatedAt = GETDATE()
    WHERE DataModelID = @DataModelID;
END;
GO

-- Update ProtosTargetType
CREATE PROCEDURE dbo.UpdateProtosTargetType
    @TargetTypeID UNIQUEIDENTIFIER,
    @TargetTypeName NVARCHAR(100),
    @Description NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE skylynxnet_coredb.dbo.ProtosTargetType
    SET TargetTypeName = @TargetTypeName, Description = @Description, UpdatedAt = GETDATE()
    WHERE TargetTypeID = @TargetTypeID;
END;
GO

-- Update ProtosTemplate
CREATE PROCEDURE dbo.UpdateProtosTemplate
    @TemplateID UNIQUEIDENTIFIER,
    @TemplateName NVARCHAR(100),
    @TemplateType NVARCHAR(50),
    @Description NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE skylynxnet_coredb.dbo.ProtosTemplate
    SET TemplateName = @TemplateName, TemplateType = @TemplateType, Description = @Description, UpdatedAt = GETDATE()
    WHERE TemplateID = @TemplateID;
END;
GO

-- Update ProtosTemplateLineage
CREATE PROCEDURE dbo.UpdateProtosTemplateLineage
    @LineageID UNIQUEIDENTIFIER,
    @ParentVersionID UNIQUEIDENTIFIER,
    @ChildVersionID UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE skylynxnet_coredb.dbo.ProtosTemplateLineage
    SET ParentVersionID = @ParentVersionID, ChildVersionID = @ChildVersionID, UpdatedAt = GETDATE()
    WHERE LineageID = @LineageID;
END;
GO

CREATE PROCEDURE dbo.UpdateProtosTemplateLink
(
    @TemplateLinkID UNIQUEIDENTIFIER,
    @TemplateVersionID UNIQUEIDENTIFIER,
    @TargetObjectID UNIQUEIDENTIFIER,
    @TargetTypeID UNIQUEIDENTIFIER,
    @IsDefault BIT = 0,
    @OverrideJSON NVARCHAR(MAX) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE ProtosTemplateLink
    SET
        TemplateVersionID = @TemplateVersionID,
        TargetObjectID = @TargetObjectID,
        TargetTypeID = @TargetTypeID,
        IsDefault = @IsDefault,
        OverrideJSON = @OverrideJSON,
        UpdatedAt = GETDATE()
    WHERE TemplateLinkID = @TemplateLinkID;
END;
GO

-- Update ProtosTemplateStatus
CREATE PROCEDURE dbo.UpdateProtosTemplateStatus
    @TemplateStatusID UNIQUEIDENTIFIER,
    @StatusName NVARCHAR(100),
    @Description NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE skylynxnet_coredb.dbo.ProtosTemplateStatus
    SET StatusName = @StatusName, Description = @Description, UpdatedAt = GETDATE()
    WHERE TemplateStatusID = @TemplateStatusID;
END;
GO

CREATE PROCEDURE dbo.UpdateProtosTemplateVersion
(
    @TemplateVersionID UNIQUEIDENTIFIER,
    @VersionLabel NVARCHAR(50),
    @StatusName NVARCHAR(100)
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.ProtosTemplateVersion
    SET 
        VersionLabel = @VersionLabel,
        StatusName = @StatusName,
        UpdatedAt = GETDATE()
    WHERE TemplateVersionID = @TemplateVersionID;
END;
GO

CREATE PROCEDURE UpdateProviderProfileField
    @FieldID UNIQUEIDENTIFIER,
    @FieldName NVARCHAR(100),
    @FieldTypeID UNIQUEIDENTIFIER,
    @IsRequired BIT
AS
BEGIN
    UPDATE ProviderProfileFields
    SET FieldName = @FieldName,
        FieldTypeID = @FieldTypeID,
        IsRequired = @IsRequired
    WHERE FieldID = @FieldID;
END;
GO

-- ================================================
-- ✅ Update: Edit FieldType
-- ================================================
CREATE PROCEDURE UpdateProviderProfileFieldType
  @FieldTypeID UNIQUEIDENTIFIER,
  @FieldTypeName NVARCHAR(100),
  @Description NVARCHAR(255)
AS
BEGIN
  UPDATE ProviderProfileFieldType
  SET FieldTypeName = @FieldTypeName,
      Description = @Description,
      UpdatedAt = GETDATE()
  WHERE FieldTypeID = @FieldTypeID;
END;
GO

CREATE PROCEDURE dbo.UpdateResolver
  @ResolverID UNIQUEIDENTIFIER,
  @ResolverType NVARCHAR(100),
  @Target NVARCHAR(MAX),
  @Description NVARCHAR(255)
AS
BEGIN
  SET NOCOUNT ON;

  UPDATE dbo.Resolvers
  SET
    ResolverType = @ResolverType,
    Target = @Target,
    Description = @Description,
    UpdatedAt = GETDATE()
  WHERE ResolverID = @ResolverID;
END;
GO


CREATE PROCEDURE UpdateRole
    @RoleID NVARCHAR(128),
    @RoleName NVARCHAR(256)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE AspNetRoles SET Name = @RoleName WHERE Id = @RoleID;
END;

GO

-- ================================================
-- ✅ Stored Procedure: UpdateSettingKey
-- Description: Updates label, type, or domain of a key
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE UpdateSettingKey
  @SettingKeyID UNIQUEIDENTIFIER,
  @Label NVARCHAR(255) = NULL,
  @ValueType NVARCHAR(50),
  @DomainID UNIQUEIDENTIFIER = NULL
AS
BEGIN
  SET NOCOUNT ON;

  UPDATE SettingKeys
  SET Label = @Label,
      ValueType = @ValueType,
      DomainID = @DomainID
  WHERE SettingKeyID = @SettingKeyID;
END;
GO

-- ================================================
-- ✅ Stored Procedure: UpdateSystemValueType
-- Description: Updates description or IsStructured of a type
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE UpdateSystemValueType
  @ValueType NVARCHAR(50),
  @Description NVARCHAR(255) = NULL,
  @IsStructured BIT = 0
AS
BEGIN
  SET NOCOUNT ON;

  UPDATE SystemValueTypes
  SET Description = @Description,
      IsStructured = @IsStructured
  WHERE ValueType = @ValueType;
END;
GO

-- ================================================
-- ✅ Stored Procedure: UpdateThemeDefinition
-- Description: Updates an existing ThemeDefinition
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE PROCEDURE dbo.UpdateThemeDefinition
(
    @ThemeDefinitionID UNIQUEIDENTIFIER,
    @ThemeName NVARCHAR(100),
    @DisplayName NVARCHAR(255) = NULL,
    @ThemeOption NVARCHAR(100) = NULL,
    @IsBase BIT = 0,
    @Description NVARCHAR(255) = NULL,
    @componentName NVARCHAR(255) = NULL,
    @componentPath NVARCHAR(255) = NULL,
    @ComponentConfig NVARCHAR(MAX) = NULL,
    @DefaultMode NVARCHAR(10) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.ThemeDefinitions
    SET
        ThemeName = @ThemeName,
        DisplayName = @DisplayName,
        ThemeOption = @ThemeOption,
        IsBase = @IsBase,
        Description = @Description,
        componentName = @componentName,
        componentPath = @componentPath,
        ComponentConfig = @ComponentConfig,
        DefaultMode = @DefaultMode
    WHERE ThemeDefinitionID = @ThemeDefinitionID;
END;
GO


CREATE PROCEDURE UpdateUser
    @UserID NVARCHAR(128),
    @UserName NVARCHAR(256),
    @Email NVARCHAR(256)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE AspNetUsers
    SET UserName = @UserName, Email = @Email
    WHERE Id = @UserID;
END;

GO

-- ================================================
-- ✅ Stored Procedure: UpdateUserFullProfileViewModel
-- Description: Updates user profile including identity, addresses, and profile fields via composite type
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- Last Updated: 2025-06-20
-- ================================================
CREATE PROCEDURE UpdateUserFullProfileViewModel
    @Profile dbo.UserProfileViewModelType READONLY,
    @ProfileFields dbo.UserProfileField READONLY
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Grab row
        DECLARE @UserID NVARCHAR(128),
                @UserName NVARCHAR(256),
                @Email NVARCHAR(256),
                @PhoneNumber NVARCHAR(50),
                @PortalID UNIQUEIDENTIFIER,
                @ProviderID UNIQUEIDENTIFIER,
                @MailingAddressID UNIQUEIDENTIFIER,
                @MailingAddress1 NVARCHAR(255),
                @MailingAddress2 NVARCHAR(255),
                @MailingCity NVARCHAR(100),
                @MailingStateProvinceID UNIQUEIDENTIFIER,
                @MailingZip NVARCHAR(20),
                @BillingAddressID UNIQUEIDENTIFIER,
                @BillingAddress1 NVARCHAR(255),
                @BillingAddress2 NVARCHAR(255),
                @BillingCity NVARCHAR(100),
                @BillingStateProvinceID UNIQUEIDENTIFIER,
                @BillingZip NVARCHAR(20);

        SELECT 
            @UserID = UserID,
            @UserName = UserName,
            @Email = Email,
            @PhoneNumber = PhoneNumber,
            @PortalID = PortalID,
            @ProviderID = ProviderID,
            @MailingAddressID = MailingAddressID,
            @MailingAddress1 = MailingAddress1,
            @MailingAddress2 = MailingAddress2,
            @MailingCity = MailingCity,
            @MailingStateProvinceID = MailingStateProvinceID,
            @MailingZip = MailingZip,
            @BillingAddressID = BillingAddressID,
            @BillingAddress1 = BillingAddress1,
            @BillingAddress2 = BillingAddress2,
            @BillingCity = BillingCity,
            @BillingStateProvinceID = BillingStateProvinceID,
            @BillingZip = BillingZip
        FROM @Profile;

        -- Step 1: Update AspNetUsers
        UPDATE AspNetUsers
        SET UserName = @UserName, Email = @Email, PhoneNumber = @PhoneNumber
        WHERE Id = @UserID;

        -- Step 2-3: Update addresses
        EXEC UpdateAddress @MailingAddressID, @MailingAddress1, @MailingAddress2, @MailingCity, @MailingStateProvinceID, @MailingZip;
        EXEC UpdateAddress @BillingAddressID, @BillingAddress1, @BillingAddress2, @BillingCity, @BillingStateProvinceID, @BillingZip;

        -- Step 4: Update dynamic fields
        EXEC UpdateUserProviderProfileFields @UserID, @ProviderID, @ProfileFields;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        IF OBJECT_ID('dbo.ErrorLog') IS NOT NULL
        BEGIN
            INSERT INTO dbo.ErrorLog (ErrorMessage, ErrorProcedure, ErrorLine, CreatedAt)
            VALUES (ERROR_MESSAGE(), ERROR_PROCEDURE(), ERROR_LINE(), GETDATE());
        END

        DECLARE @Err NVARCHAR(MAX) = ERROR_MESSAGE();
        RAISERROR(@Err, 16, 1);
    END CATCH
END;
GO


-- ✅ Update User Login Provider
CREATE PROCEDURE UpdateUserLogin
    @UserID NVARCHAR(128),
    @LoginProvider NVARCHAR(128),
    @NewProviderKey NVARCHAR(128)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE AspNetUserLogins SET ProviderKey = @NewProviderKey WHERE UserId = @UserID AND LoginProvider = @LoginProvider;
END;

GO

CREATE PROCEDURE UpdateUserProfile
    @UserID NVARCHAR(128),
    @ProviderID UNIQUEIDENTIFIER,
    @PortalID UNIQUEIDENTIFIER,
    @BillingAddressID UNIQUEIDENTIFIER = NULL,
    @AddressID UNIQUEIDENTIFIER = NULL
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE UserProfiles
    SET BillingAddressID = @BillingAddressID,
        AddressID = @AddressID,
        UpdatedAt = GETDATE()
    WHERE UserID = @UserID AND ProviderID = @ProviderID AND PortalID = @PortalID;
END;
GO

CREATE PROCEDURE UpdateUserProviderProfileData
    @UserID NVARCHAR(128),
    @ProviderID UNIQUEIDENTIFIER,
    @FieldID UNIQUEIDENTIFIER,
    @FieldValue NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE UserProviderProfiles
    SET FieldValue = @FieldValue
    WHERE UserID = @UserID AND ProviderID = @ProviderID AND FieldID = @FieldID;
END;
GO

CREATE PROCEDURE UpdateUserProviderProfileDataField
    @UserProviderProfileID UNIQUEIDENTIFIER,
    @FieldValue NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE UserProviderProfiles
    SET FieldValue = @FieldValue
    WHERE UserProviderProfileID = @UserProviderProfileID;
END;
GO

-- ================================================
-- ✅ Stored Procedure: UpdateUserProviderProfileFields
-- Description: Iterates UserProfileField table and calls UpdateUserProviderProfileData for each
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- Last Updated: 2025-06-20
-- ================================================
CREATE PROCEDURE UpdateUserProviderProfileFields
    @UserID NVARCHAR(128),
    @ProviderID UNIQUEIDENTIFIER,
    @ProfileFields dbo.UserProfileField READONLY
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @FieldID UNIQUEIDENTIFIER;
    DECLARE @FieldValue NVARCHAR(MAX);

    DECLARE field_cursor CURSOR FOR
        SELECT FieldID, FieldValue FROM @ProfileFields;

    OPEN field_cursor;
    FETCH NEXT FROM field_cursor INTO @FieldID, @FieldValue;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        EXEC UpdateUserProviderProfileData
            @UserID = @UserID,
            @ProviderID = @ProviderID,
            @FieldID = @FieldID,
            @FieldValue = @FieldValue;

        FETCH NEXT FROM field_cursor INTO @FieldID, @FieldValue;
    END

    CLOSE field_cursor;
    DEALLOCATE field_cursor;
END;
GO


-- ✅ Update User Token
CREATE PROCEDURE UpdateUserToken
    @UserID NVARCHAR(128),
    @LoginProvider NVARCHAR(128),
    @Name NVARCHAR(128),
    @NewValue NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE AspNetUserTokens SET Value = @NewValue WHERE UserId = @UserID AND LoginProvider = @LoginProvider AND Name = @Name;
END;

GO

CREATE PROCEDURE dbo.UpsertModuleSetting
(
  @PortalPageModuleID UNIQUEIDENTIFIER,
  @KeyName            NVARCHAR(100),
  @RoleID             NVARCHAR(128),
  @Value              NVARCHAR(MAX)
)
AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRY
    DECLARE @SettingKeyID UNIQUEIDENTIFIER =
    (
      SELECT SettingKeyID FROM dbo.SettingKeys WHERE KeyName=@KeyName
    );

    IF @SettingKeyID IS NULL
      THROW 50070, N'Unknown KeyName in SettingKeys.', 1;

    IF EXISTS (SELECT 1 FROM dbo.ModuleSettings WHERE PortalPageModuleID=@PortalPageModuleID AND SettingKeyID=@SettingKeyID AND RoleID=@RoleID)
    BEGIN
      UPDATE dbo.ModuleSettings
         SET Value=@Value, UpdatedAt=GETDATE()
       WHERE PortalPageModuleID=@PortalPageModuleID AND SettingKeyID=@SettingKeyID AND RoleID=@RoleID;
    END
    ELSE
    BEGIN
      INSERT INTO dbo.ModuleSettings (PortalPageModuleID, SettingKeyID, RoleID, Value, UpdatedAt)
      VALUES (@PortalPageModuleID, @SettingKeyID, @RoleID, @Value, GETDATE());
    END
  END TRY
  BEGIN CATCH
    THROW;
  END CATCH
END

GO

--put SQL code below
-- ✅ Renamed for clarity and general use
CREATE PROCEDURE ValidateApiKey
    @ApiKey NVARCHAR(256)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT * 
    FROM API_KEYS 
    WHERE KeyHash = @ApiKey 
      AND IsActive = 1 
      AND (ExpiresAt IS NULL OR ExpiresAt > GETDATE());
END;
GO

-- ================================================
-- ✅ Stored Procedure: Validate API Key for Portal
-- ================================================
CREATE   PROCEDURE ValidateAPIKeyForPortal
    @PortalID UNIQUEIDENTIFIER,
    @KeyHash NVARCHAR(256)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 1 *
    FROM vw_ActiveAPIKeys
    WHERE PortalID = @PortalID
      AND KeyHash = @KeyHash
      AND ExpiresAt > GETDATE();
END;
GO

-- ================================================
-- ✅ Stored Procedure: ValidateOwnerApiKey
-- Description: Validates a plaintext API key against a given PortalName
-- ================================================
CREATE   PROCEDURE ValidateOwnerApiKey
    @PlainApiKey NVARCHAR(MAX),
    @PortalName NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- Step 1: Hash the incoming plain-text API key
    DECLARE @HashedKey NVARCHAR(256) = dbo.fn_HashPlainKey(@PlainApiKey);

    -- Step 2: Resolve PortalID from PortalName using vw_ActiveAPIKeys
    DECLARE @ResolvedPortalID UNIQUEIDENTIFIER;

    SELECT TOP 1 @ResolvedPortalID = PortalID
    FROM vw_ActiveAPIKeys
    WHERE PortalName = @PortalName;

    -- Step 3: Return failure if PortalName not found
    IF @ResolvedPortalID IS NULL
    BEGIN
        SELECT CAST(0 AS BIT) AS IsValid;
        RETURN;
    END

    -- Step 4: Validate using existing logic
    DECLARE @IsValid BIT = dbo.fn_IsValidAPIKey(@ResolvedPortalID, @HashedKey);

    -- Step 5: Return result
    SELECT @IsValid AS IsValid;
END;
GO

-- =============================================
-- ✅ Stored Procedure: ValidateUserByEmail
-- Retrieves user details by email for login
-- =============================================
CREATE PROCEDURE ValidateUserByEmail
    @Email NVARCHAR(256)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        Id,
        UserName,
        Email,
        PasswordHash,
        SecurityStamp,
        EmailConfirmed,
        PhoneNumber,
        LockoutEnabled,
        AccessFailedCount
    FROM AspNetUsers
    WHERE Email = @Email;
END;
GO

CREATE PROCEDURE Payments.AddTargetLink
(
  @PaymentIntentID UNIQUEIDENTIFIER,
  @TargetDomain    NVARCHAR(50),
  @TargetID        UNIQUEIDENTIFIER
)
AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRY
    IF NOT EXISTS (SELECT 1 FROM Payments.Intent WHERE PaymentIntentID=@PaymentIntentID)
      THROW 50040, N'PaymentIntent does not exist.', 1;

    IF NOT EXISTS (SELECT 1 FROM Payments.TargetLink WHERE PaymentIntentID=@PaymentIntentID AND TargetDomain=@TargetDomain AND TargetID=@TargetID)
    BEGIN
      INSERT INTO Payments.TargetLink (PaymentIntentID, TargetDomain, TargetID)
      VALUES (@PaymentIntentID, @TargetDomain, @TargetID);
    END
  END TRY
  BEGIN CATCH
    THROW;
  END CATCH
END

GO

CREATE PROCEDURE Payments.CreateIntent
(
  @PaymentIntentID UNIQUEIDENTIFIER OUTPUT,
  @ProviderID      UNIQUEIDENTIFIER,
  @PortalID        UNIQUEIDENTIFIER,
  @UserID          UNIQUEIDENTIFIER,
  @Amount          DECIMAL(18,2),
  @Currency        CHAR(3),
  @ClientRef       NVARCHAR(100) = NULL,
  @Status          NVARCHAR(20)  = N'Pending'  -- Pending|Authorized|Captured|Failed|Voided|Refunded
)
AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRY
    IF NOT EXISTS (SELECT 1 FROM Payments.Provider WHERE ProviderID=@ProviderID)
      THROW 50030, N'Provider does not exist.', 1;

    IF @PaymentIntentID IS NULL SET @PaymentIntentID = NEWID();

    INSERT INTO Payments.Intent
      (PaymentIntentID, ProviderID, PortalID, UserID, Amount, Currency, Status, ClientRef)
    VALUES
      (@PaymentIntentID, @ProviderID, @PortalID, @UserID, @Amount, @Currency, @Status, @ClientRef);
  END TRY
  BEGIN CATCH
    THROW;
  END CATCH
END

GO

CREATE PROCEDURE Payments.CreateProvider
(
  @ProviderID UNIQUEIDENTIFIER OUTPUT,
  @Name       NVARCHAR(100),
  @Type       NVARCHAR(50),
  @IsActive   BIT        = 1,
  @IsSandbox  BIT        = 1
)
AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRY
    IF @ProviderID IS NULL SET @ProviderID = NEWID();

    INSERT INTO Payments.Provider (ProviderID, Name, [Type], IsActive, IsSandbox)
    VALUES (@ProviderID, @Name, @Type, @IsActive, @IsSandbox);
  END TRY
  BEGIN CATCH
    THROW;
  END CATCH
END

GO

CREATE PROCEDURE Payments.GetAllProviders
(
  @OnlyActive BIT = NULL
)
AS
BEGIN
  SET NOCOUNT ON;
  SELECT p.*
  FROM Payments.Provider p
  WHERE (@OnlyActive IS NULL) OR (p.IsActive=@OnlyActive);
END

GO

CREATE PROCEDURE Payments.GetIntentByClientRef
(
  @ClientRef NVARCHAR(100)
)
AS
BEGIN
  SET NOCOUNT ON;
  SELECT TOP 1 i.*
  FROM Payments.Intent i
  WHERE i.ClientRef = @ClientRef
  ORDER BY i.CreatedAt DESC;
END

GO

CREATE PROCEDURE Payments.GetIntentById
(
  @PaymentIntentID UNIQUEIDENTIFIER
)
AS
BEGIN
  SET NOCOUNT ON;
  SELECT i.*
  FROM Payments.Intent i
  WHERE i.PaymentIntentID=@PaymentIntentID;
END

GO

CREATE PROCEDURE Payments.GetProviderById
(
  @ProviderID UNIQUEIDENTIFIER
)
AS
BEGIN
  SET NOCOUNT ON;
  SELECT p.*
  FROM Payments.Provider p
  WHERE p.ProviderID=@ProviderID;
END

GO

CREATE PROCEDURE Payments.GetProviderSecret
(
  @ProviderID UNIQUEIDENTIFIER
)
AS
BEGIN
  SET NOCOUNT ON;
  SELECT ps.*
  FROM Payments.ProviderSecret ps
  WHERE ps.ProviderID=@ProviderID;
END

GO

CREATE PROCEDURE Payments.GetTargetLinks
(
  @PaymentIntentID UNIQUEIDENTIFIER
)
AS
BEGIN
  SET NOCOUNT ON;
  SELECT tl.*
  FROM Payments.TargetLink tl
  WHERE tl.PaymentIntentID=@PaymentIntentID
  ORDER BY tl.TargetDomain, tl.TargetID;
END

GO

CREATE PROCEDURE Payments.GetTxnById
(
  @PaymentTxnID UNIQUEIDENTIFIER
)
AS
BEGIN
  SET NOCOUNT ON;
  SELECT t.*
  FROM Payments.Txn t
  WHERE t.PaymentTxnID=@PaymentTxnID;
END

GO

CREATE PROCEDURE Payments.GetTxnsByIntent
(
  @PaymentIntentID UNIQUEIDENTIFIER
)
AS
BEGIN
  SET NOCOUNT ON;
  SELECT t.*
  FROM Payments.Txn t
  WHERE t.PaymentIntentID=@PaymentIntentID
  ORDER BY t.CreatedAt DESC;
END

GO

CREATE PROCEDURE Payments.LogWebhook
(
  @WebhookID UNIQUEIDENTIFIER OUTPUT,
  @EventID   NVARCHAR(200),
  @EventType NVARCHAR(100),
  @RawJson   NVARCHAR(MAX)
)
AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRY
    IF @WebhookID IS NULL SET @WebhookID = NEWID();

    INSERT INTO Payments.Webhook (WebhookID, EventID, EventType, RawJson)
    VALUES (@WebhookID, @EventID, @EventType, @RawJson);
  END TRY
  BEGIN CATCH
    THROW;
  END CATCH
END

GO

CREATE PROCEDURE Payments.MarkWebhookProcessed
(
  @WebhookID UNIQUEIDENTIFIER
)
AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRY
    UPDATE Payments.Webhook
       SET ProcessedAt = SYSUTCDATETIME()
     WHERE WebhookID = @WebhookID;

    IF @@ROWCOUNT = 0
      THROW 50060, N'Webhook not found.', 1;
  END TRY
  BEGIN CATCH
    THROW;
  END CATCH
END

GO

CREATE PROCEDURE Payments.RecordTxn
(
  @PaymentTxnID    UNIQUEIDENTIFIER OUTPUT,
  @PaymentIntentID UNIQUEIDENTIFIER,
  @TxnType         NVARCHAR(20),     -- 'AuthOnly','AuthCapture','Void','Refund','TokenIssued'
  @GatewayTxnID    NVARCHAR(100) = NULL,
  @AuthCode        NVARCHAR(50)  = NULL,
  @ResultCode      NVARCHAR(50)  = NULL,
  @RawJson         NVARCHAR(MAX) = NULL
)
AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRY
    IF NOT EXISTS (SELECT 1 FROM Payments.Intent WHERE PaymentIntentID=@PaymentIntentID)
      THROW 50050, N'PaymentIntent does not exist.', 1;

    IF @PaymentTxnID IS NULL SET @PaymentTxnID = NEWID();

    INSERT INTO Payments.Txn
      (PaymentTxnID, PaymentIntentID, TxnType, GatewayTxnID, AuthCode, ResultCode, RawJson)
    VALUES
      (@PaymentTxnID, @PaymentIntentID, @TxnType, @GatewayTxnID, @AuthCode, @ResultCode, @RawJson);
  END TRY
  BEGIN CATCH
    THROW;
  END CATCH
END

GO

CREATE PROCEDURE Payments.ResolveIntentByGatewayTxnID
(
    @GatewayTxnID NVARCHAR(100)
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Return the *latest* intent in case of multiple related rows
    SELECT TOP (1)
           t.PaymentIntentID
    FROM Payments.Txn AS t
    WHERE t.GatewayTxnID = @GatewayTxnID
    ORDER BY t.CreatedAt DESC;
END

GO

CREATE PROCEDURE Payments.SetProviderSecret
(
  @ProviderID          UNIQUEIDENTIFIER,
  @ApiLoginID_enc      NVARCHAR(200),
  @TransactionKey_enc  NVARCHAR(400),
  @SignatureKeyHex_enc NVARCHAR(400),
  @Mode                NVARCHAR(20)  -- 'sandbox' | 'production' (match your CHECK)
)
AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRY
    IF NOT EXISTS (SELECT 1 FROM Payments.Provider WHERE ProviderID=@ProviderID)
      THROW 50020, N'Provider does not exist.', 1;

    IF EXISTS (SELECT 1 FROM Payments.ProviderSecret WHERE ProviderID=@ProviderID)
    BEGIN
      UPDATE Payments.ProviderSecret
         SET ApiLoginID_enc=@ApiLoginID_enc,
             TransactionKey_enc=@TransactionKey_enc,
             SignatureKeyHex_enc=@SignatureKeyHex_enc,
             [Mode]=@Mode,
             UpdatedAt=SYSUTCDATETIME()
       WHERE ProviderID=@ProviderID;
    END
    ELSE
    BEGIN
      INSERT INTO Payments.ProviderSecret
        (ProviderID, ApiLoginID_enc, TransactionKey_enc, SignatureKeyHex_enc, [Mode])
      VALUES
        (@ProviderID, @ApiLoginID_enc, @TransactionKey_enc, @SignatureKeyHex_enc, @Mode);
    END
  END TRY
  BEGIN CATCH
    THROW;
  END CATCH
END

GO

CREATE PROCEDURE Payments.UpdateIntentStatus
(
  @PaymentIntentID UNIQUEIDENTIFIER,
  @Status          NVARCHAR(20)
)
AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRY
    UPDATE Payments.Intent
       SET Status=@Status, UpdatedAt=SYSUTCDATETIME()
     WHERE PaymentIntentID=@PaymentIntentID;

    IF @@ROWCOUNT = 0
      THROW 50031, N'PaymentIntent not found.', 1;
  END TRY
  BEGIN CATCH
    THROW;
  END CATCH
END

GO

CREATE PROCEDURE Payments.UpdateProvider
(
  @ProviderID UNIQUEIDENTIFIER,
  @Name       NVARCHAR(100),
  @Type       NVARCHAR(50),
  @IsActive   BIT,
  @IsSandbox  BIT
)
AS
BEGIN
  SET NOCOUNT ON;
  BEGIN TRY
    UPDATE Payments.Provider
       SET Name=@Name, [Type]=@Type, IsActive=@IsActive, IsSandbox=@IsSandbox,
           UpdatedAt=SYSUTCDATETIME()
     WHERE ProviderID=@ProviderID;

    IF @@ROWCOUNT = 0
      THROW 50010, N'Provider not found.', 1;
  END TRY
  BEGIN CATCH
    THROW;
  END CATCH
END

GO

CREATE PROCEDURE Payments.UpsertWebhook
(
    @EventID   NVARCHAR(200),
    @EventType NVARCHAR(100),
    @RawJson   NVARCHAR(MAX),
    @WebhookID UNIQUEIDENTIFIER OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Existing UNIQUEIDENTIFIER;

    SELECT @Existing = w.WebhookID
    FROM Payments.Webhook w
    WHERE w.EventID = @EventID;

    IF @Existing IS NULL
    BEGIN
        SET @WebhookID = NEWID();

        INSERT INTO Payments.Webhook
        (
            WebhookID, EventID, EventType, RawJson, ProcessedAt
        )
        VALUES
        (
            @WebhookID, @EventID, @EventType, @RawJson, NULL
        );
    END
    ELSE
    BEGIN
        SET @WebhookID = @Existing;

        -- Update payload & type; keep ProcessedAt as-is (idempotent store)
        UPDATE w
           SET w.EventType = @EventType,
               w.RawJson   = @RawJson
        FROM Payments.Webhook w
        WHERE w.WebhookID = @Existing;
    END
END

GO
