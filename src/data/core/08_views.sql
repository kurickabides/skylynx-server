/*
  SkyLynx SQL Export
  Database: skylynxnet_coredb
  Section: Views
  Generated: 2026-07-22T22:38:02.881Z
*/
GO

-- dbo.vw_ActiveAPIKeys source

--put SQL code below
-- ================================================
-- ✅ Unified SQL Script: API Key Views + Procedures
-- ================================================

-- ================================================
-- ✅ View: vw_ActiveAPIKeys
-- ================================================
CREATE   VIEW vw_ActiveAPIKeys AS
SELECT 
    ak.ApiKeyID,
    ak.KeyHash,
    ak.CreatedAt,
    ak.ExpiresAt,
    ak.IsActive,
    ak.OwnerUUID,
    ow.UserID,
    ow.PortalID,
    ow.OwnerTypeID,
    ot.OwnerTypeName,
    p.PortalName,
    p.Description AS PortalDescription
FROM API_KEYS ak
JOIN API_Owners ow ON ak.OwnerUUID = ow.OwnerUUID
JOIN OwnerTypes ot ON ow.OwnerTypeID = ot.OwnerTypeID
JOIN Portals p ON ow.PortalID = p.PortalID
WHERE ak.IsActive = 1;
GO


-- ✅ Active Subscriptions View
CREATE VIEW vw_ActiveSubscriptions AS
SELECT 
    sp.SubscriptionID, sp.UserID, u.UserName, sp.PlanName, sp.Price, sp.BillingCycle, sp.Status, sp.StartDate, sp.EndDate
FROM SubscriptionPlans sp
JOIN AspNetUsers u ON sp.UserID = u.Id
WHERE sp.Status = 'Active';

GO

-- dbo.vw_AllAPIKeys source

-- ================================================
-- ✅ View: vw_AllAPIKeys (no IsActive filter)
-- ================================================
CREATE   VIEW vw_AllAPIKeys AS
SELECT 
    ak.ApiKeyID,
    ak.KeyHash,
    ak.CreatedAt,
    ak.ExpiresAt,
    ak.IsActive,
    ak.OwnerUUID,
    ow.UserID,
    ow.PortalID,
    ow.OwnerTypeID,
    ot.OwnerTypeName,
    p.PortalName,
    p.Description AS PortalDescription
FROM API_KEYS ak
JOIN API_Owners ow ON ak.OwnerUUID = ow.OwnerUUID
JOIN OwnerTypes ot ON ow.OwnerTypeID = ot.OwnerTypeID
JOIN Portals p ON ow.PortalID = p.PortalID;
GO

CREATE VIEW vw_DyForm_ActiveDomainsUsed AS
SELECT DISTINCT 
  d.DomainID,
  d.Name AS DomainName,
  d.DomainTypeID,
  f.FieldName,
  frm.FormName
FROM DyFormDomains d
JOIN DyFormField f ON f.DomainID = d.DomainID
JOIN DyFormSection s ON f.SectionID = s.SectionID
JOIN DyForm frm ON s.FormID = frm.FormID
GO

CREATE VIEW vw_DyForm_CompleteFieldMap AS
SELECT 
  f.FieldID,
  f.FieldName,
  f.Tooltip,
  f.SortOrder,
  ft.FieldTypeName,
  ft.ComponentName,
  d.Name AS DomainName,
  s.SectionName,
  frm.FormName,
  rt.Name AS ResolverType,
  e.FieldExpression,
  rtype.Name AS RuleType,
  fr.RuleExpression,
  fr.IsEnabled,
  fr.Priority,
  fr.ErrorMessage
FROM DyFormField f
JOIN DyFormFieldType ft ON f.FieldTypeID = ft.FieldTypeID
JOIN DyFormSection s ON f.SectionID = s.SectionID
JOIN DyForm frm ON s.FormID = frm.FormID
LEFT JOIN DyFormDomains d ON f.DomainID = d.DomainID
LEFT JOIN DyFormExpression e ON f.FieldID = e.FieldID
LEFT JOIN DyFormResolverType rt ON e.ResolverTypeID = rt.ResolverTypeID
LEFT JOIN DyFormFieldRule fr ON f.FieldID = fr.FieldID
LEFT JOIN DyFormRuleType rtype ON fr.RuleTypeID = rtype.RuleTypeID
GO

CREATE VIEW vw_DyForm_DomainOptions AS
SELECT 
  d.DomainID,
  d.Name AS DomainName,
  d.DomainTypeID,
  v.Label,
  v.Value,
  v.SortOrder
FROM DyFormDomains d
JOIN DyFormDomainValues v ON d.DomainID = v.DomainID
GO

CREATE VIEW vw_DyForm_FieldExpressions AS
SELECT 
  f.FieldID,
  f.FieldName,
  frm.FormName,
  rt.Name AS ResolverType,
  e.FieldExpression
FROM DyFormField f
JOIN DyFormSection s ON f.SectionID = s.SectionID
JOIN DyForm frm ON s.FormID = frm.FormID
JOIN DyFormExpression e ON f.FieldID = e.FieldID
JOIN DyFormResolverType rt ON e.ResolverTypeID = rt.ResolverTypeID
GO

CREATE VIEW vw_DyForm_FieldRules AS
SELECT 
  f.FieldName,
  frm.FormName,
  rtype.Name AS RuleType,
  rt.Name AS ResolverType,
  fr.RuleExpression,
  fr.IsEnabled,
  fr.Priority,
  fr.ErrorMessage
FROM DyFormField f
JOIN DyFormSection s ON f.SectionID = s.SectionID
JOIN DyForm frm ON s.FormID = frm.FormID
JOIN DyFormFieldRule fr ON f.FieldID = fr.FieldID
JOIN DyFormRuleType rtype ON fr.RuleTypeID = rtype.RuleTypeID
JOIN DyFormResolverType rt ON fr.ResolverTypeID = rt.ResolverTypeID
GO

-- dbo.vw_DyForm_FieldsWithTypes source

CREATE VIEW vw_DyForm_FieldsWithTypes AS
SELECT 
  f.DyFormFieldID,
  f.Label AS FieldName,
  f.Tooltip,
  fsd.SortOrder,
  ft.FieldTypeName,
  ft.ComponentName,
  d.Name AS DomainName,
  sec.SectionName,
  frm.FormName
FROM DyFormField f
JOIN DyFormFieldType ft ON f.FieldTypeID = ft.FieldTypeID
LEFT JOIN DyFormDomains d ON f.DomainID = d.DomainID

-- Join via section definition (mapping field to section)
JOIN DyFormFieldSectionDefinition fsd ON f.DyFormFieldID = fsd.DyFormFieldID
JOIN DyFormSection sec ON fsd.SectionID = sec.SectionID

-- Link section to form via DyFormSections
JOIN DyFormSections fs ON fs.SectionID = sec.SectionID
JOIN DyForm frm ON fs.FormID = frm.FormID;
GO

-- dbo.vw_DyForm_FormSummary source

-- ================================================
-- ✅ View: vw_DyForm_FormSummary
-- Description: Summarizes form metadata counts (sections, fields, rules)
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================
CREATE VIEW vw_DyForm_FormSummary AS
SELECT 
  f.FormID,
  f.FormName,
  f.Description,
  COUNT(DISTINCT fs.SectionID) AS SectionCount,
  COUNT(DISTINCT fsd.DyFormFieldID) AS FieldCount,
  COUNT(DISTINCT r.RuleID) AS RuleCount
FROM DyForm f

-- Form → Section mapping
LEFT JOIN DyFormSections fs ON f.FormID = fs.FormID
LEFT JOIN DyFormSection s ON fs.SectionID = s.SectionID

-- Section → Field mapping
LEFT JOIN DyFormFieldSectionDefinition fsd ON s.SectionID = fsd.SectionID
LEFT JOIN DyFormField fld ON fsd.DyFormFieldID = fld.DyFormFieldID

-- Field → Rules
LEFT JOIN DyFormFieldRule r ON fld.DyFormFieldID = r.FieldID

GROUP BY f.FormID, f.FormName, f.Description;
GO

CREATE VIEW vw_DyForm_UnusedTypesOrDomains AS
SELECT 
  'FieldType' AS TypeCategory,
  ft.FieldTypeID AS RefID,
  ft.FieldTypeName AS Name
FROM DyFormFieldType ft
LEFT JOIN DyFormField f ON ft.FieldTypeID = f.FieldTypeID
WHERE f.FieldID IS NULL

UNION

SELECT 
  'Domain' AS TypeCategory,
  d.DomainID AS RefID,
  d.Name AS Name
FROM DyFormDomains d
LEFT JOIN DyFormField f ON d.DomainID = f.DomainID
WHERE f.FieldID IS NULL
GO

CREATE VIEW vw_DyForm_UserProfileConfig AS

-- ✅ A. Fields directly mapped to the vmUserProfile_View
SELECT
    vmd.ViewModelName,
    s.SectionID,
    s.SectionName,
    fs.FormID,
    f.DyFormFieldID,
    f.Label,
    f.FieldTypeID,
    ft.FieldTypeName AS FieldType,
    ds.SourcePath,
    ds.SourceKey,
    dom.Name AS DomainName,
    tgt.RuleTargetID,
    rd.RuleKey,
    ex.Expression AS RuleExpression,
    rt.Name AS ResolverType,
    sdef.SortOrder
FROM DyFormFieldSectionDefinition sdef
JOIN DyFormViewModelDefinition vmd ON sdef.ViewModelDefinitionID = vmd.ViewModelDefinitionID
JOIN DyFormField f ON sdef.DyFormFieldID = f.DyFormFieldID
JOIN DyFormDataSourceDefinition ds ON sdef.DyFormDSDefinitionID = ds.DyFormDSDefinitionID
JOIN DyFormSection s ON sdef.SectionID = s.SectionID
JOIN DyFormSections fs ON s.SectionID = fs.SectionID
LEFT JOIN DyFormFieldType ft ON f.FieldTypeID = ft.FieldTypeID
LEFT JOIN DyFormDomains dom ON f.DomainID = dom.DomainID
LEFT JOIN DyFormRuleTarget tgt ON tgt.DyFormFieldID = f.DyFormFieldID AND tgt.ViewModelDefinitionID = vmd.ViewModelDefinitionID
LEFT JOIN DyFormRuleDefinition rd ON tgt.RuleDefinitionID = rd.RuleDefinitionID
LEFT JOIN DyFormExpression ex ON rd.DyFormExpressionID = ex.DyFormExpressionID
LEFT JOIN DyFormResolverType rt ON rd.ResolverTypeID = rt.ResolverTypeID
WHERE vmd.ViewModelName = 'vmUserProfile_View'

UNION ALL

-- ✅ B. Fields from child ViewModels of vmUserProfile_View
SELECT
    child.ViewModelName,
    s.SectionID,
    s.SectionName,
    fs.FormID,
    f.DyFormFieldID,
    f.Label,
    f.FieldTypeID,
    ft.FieldTypeName AS FieldType,
    ds.SourcePath,
    ds.SourceKey,
    dom.Name AS DomainName,
    tgt.RuleTargetID,
    rd.RuleKey,
    ex.Expression AS RuleExpression,
    rt.Name AS ResolverType,
    sdef.SortOrder
FROM DyFormFieldSectionDefinition sdef
JOIN DyFormViewModelDefinition child ON sdef.ViewModelDefinitionID = child.ViewModelDefinitionID
JOIN DyFormViewModelLineage lineage ON lineage.ViewModelDefinitionID = '261704A2-F737-4066-9475-B7CA7005FAD3' -- vmUserProfile_View
                                     AND lineage.ChildViewModelDefinitionID = child.ViewModelDefinitionID
JOIN DyFormField f ON sdef.DyFormFieldID = f.DyFormFieldID
JOIN DyFormDataSourceDefinition ds ON sdef.DyFormDSDefinitionID = ds.DyFormDSDefinitionID
JOIN DyFormSection s ON sdef.SectionID = s.SectionID
JOIN DyFormSections fs ON s.SectionID = fs.SectionID
LEFT JOIN DyFormFieldType ft ON f.FieldTypeID = ft.FieldTypeID
LEFT JOIN DyFormDomains dom ON f.DomainID = dom.DomainID
LEFT JOIN DyFormRuleTarget tgt ON tgt.DyFormFieldID = f.DyFormFieldID AND tgt.ViewModelDefinitionID = child.ViewModelDefinitionID
LEFT JOIN DyFormRuleDefinition rd ON tgt.RuleDefinitionID = rd.RuleDefinitionID
LEFT JOIN DyFormExpression ex ON rd.DyFormExpressionID = ex.DyFormExpressionID
LEFT JOIN DyFormResolverType rt ON rd.ResolverTypeID = rt.ResolverTypeID;

GO

CREATE VIEW vw_DyForm_UserProfilePivot AS
SELECT
    up.UserID,
    MAX(CASE WHEN f.FieldName = 'FirstName' THEN upp.FieldValue END) AS FirstName,
    MAX(CASE WHEN f.FieldName = 'LastName' THEN upp.FieldValue END) AS LastName,
    MAX(CASE WHEN f.FieldName = 'DateOfBirth' THEN upp.FieldValue END) AS DateOfBirth,
    MAX(CASE WHEN f.FieldName = 'PreferredLanguage' THEN upp.FieldValue END) AS PreferredLanguage
FROM DyFormDForm frm
JOIN DyFormDFormSection s ON frm.FormID = s.FormID
JOIN DyFormDFormField f ON s.SectionID = f.SectionID
JOIN UserProviderProfiles upp ON f.FieldID = upp.FieldID
JOIN UserProfiles up ON upp.UserID = up.UserID AND upp.ProviderID = up.ProviderID
WHERE frm.FormName = 'UserProfile'
GROUP BY up.UserID
GO

--put SQL code below
CREATE VIEW vw_FullUserProfile AS
SELECT
    p.PortalName,
    p.Description AS PortalDescription,
    p.CreatedDate AS PortalCreatedDate,
    up.UserID,
    u.UserName,
    u.Email,
    u.EmailConfirmed,
    u.PhoneNumber AS [Primary Phone],
    u.PhoneNumberConfirmed,
    u.TwoFactorEnabled,
    u.AccessFailedCount,
    up.ProviderID,
    up.PortalID,
    upf.FirstName,
    upf.LastName,
    upf.Photo,
    upf.Phone AS [Mobile Phone],
    upf.DateOfBirth,
    upf.PreferredLanguage,
    a.address_1 AS [Mailing Address1],
    a.address_2 AS [Mailing Address2],
    a.City AS City,
    a.Zip AS Zip,
    a.StateProvinceID AS StateProvinceID,
    ba.address_1 AS [Billing Address1],
    ba.address_2 AS [Billing Address2],
    ba.City AS BillingCity,
    ba.Zip AS BillingZip,
    ba.StateProvinceID AS BillingStateProvinceID,
    up.CreatedAt,
    up.UpdatedAt    
FROM skylynxnet_coredb.dbo.UserProfiles up
LEFT JOIN skylynxnet_coredb.dbo.Address ba ON up.BillingAddressID = ba.addyId
LEFT JOIN skylynxnet_coredb.dbo.Address a ON up.AddressID = a.addyId
LEFT JOIN skylynxnet_coredb.dbo.Portals p ON up.PortalID = p.PortalID
LEFT JOIN vw_UserProfileFieldPivot upf ON up.UserID = upf.UserID AND up.ProviderID = upf.ProviderID
LEFT JOIN skylynxnet_coredb.dbo.AspNetUsers u ON up.UserID = u.Id
GO

-- dbo.vw_FullUserProfileDev source

--put SQL code below
CREATE VIEW vw_FullUserProfileDev AS
SELECT
    p.PortalName,
    p.Description AS PortalDescription,
    p.CreatedDate AS PortalCreatedDate,
    up.UserID,
    u.UserName,
    u.Email,
    u.EmailConfirmed,
    u.PhoneNumber AS [phoneNumber],
    u.PhoneNumberConfirmed,
    u.TwoFactorEnabled,
    u.AccessFailedCount,
    up.ProviderID,
    up.PortalID,
    upf.FirstName,
    upf.LastName,
    upf.Photo,
    upf.Phone AS [mobilePhone],
    upf.DateOfBirth,
    upf.PreferredLanguage,
     up.AddressID,
    a.address_1 AS [mailingAddress1],
    a.address_2 AS [mailingAddress2],
    a.City AS City,
    a.Zip AS Zip,
    a.StateProvinceID AS StateProvinceID,
    up.BillingAddressID,
    ba.address_1 AS [billingAddress1],
    ba.address_2 AS [billingAddress2],
    ba.City AS BillingCity,
    ba.Zip AS BillingZip,
    ba.StateProvinceID AS BillingStateProvinceID,
    up.CreatedAt,
    up.UpdatedAt    
FROM skylynxnet_coredb.dbo.UserProfiles up
LEFT JOIN skylynxnet_coredb.dbo.Address ba ON up.BillingAddressID = ba.addyId
LEFT JOIN skylynxnet_coredb.dbo.Address a ON up.AddressID = a.addyId
LEFT JOIN skylynxnet_coredb.dbo.Portals p ON up.PortalID = p.PortalID
LEFT JOIN vw_UserProfileFieldPivot upf ON up.UserID = upf.UserID AND up.ProviderID = upf.ProviderID
LEFT JOIN skylynxnet_coredb.dbo.AspNetUsers u ON up.UserID = u.Id;
GO


CREATE VIEW vw_PortalModules AS
SELECT pm.PortalID, p.PortalName, m.ModuleID, m.ModuleName
FROM PortalModules pm
JOIN Portals p ON pm.PortalID = p.PortalID
JOIN Modules m ON pm.ModuleID = m.ModuleID;

GO

--put SQL code beloww
-- ================================================
-- ✅ View: vw_PortalProfileProviders
-- Description: Combines portal and provider info with default flags
-- ================================================
CREATE   VIEW vw_PortalProfileProviders AS
SELECT 
    ppp.PortalID,
    pt.PortalName,
    pt.Description AS PortalDescription,
    ppp.ProviderID,
    pp.ProviderName,
    pp.Description AS ProviderDescription,
    pp.IsSystemDefault,
    ppp.IsPortalDefault,
    ppp.IsEnabled,
    ppp.CreatedAt
FROM PortalProfileProviders ppp
JOIN Portals pt ON pt.PortalID = ppp.PortalID
JOIN ProfileProviders pp ON pp.ProviderID = ppp.ProviderID
GO

CREATE VIEW vw_PortalUserLogins AS
SELECT
    pt.PortalID,
    pt.PortalName,
    u.Id AS UserID,
    u.UserName,
    u.Email,
    u.EmailConfirmed,
    up.CreatedAt,
    pp.ProviderName,
    ppp.IsPortalDefault,
    pp.IsSystemDefault
FROM UserProfiles up
JOIN AspNetUsers u ON u.Id = up.UserID
JOIN PortalProfileProviders ppp 
    ON up.ProviderID = ppp.ProviderID 
   AND up.PortalID = ppp.PortalID   -- ✅ this line ensures accuracy
JOIN Portals pt ON pt.PortalID = ppp.PortalID
JOIN ProfileProviders pp ON pp.ProviderID = ppp.ProviderID
GO

-- dbo.vw_ProtosViewModel_Hierarchy source

-- dbo.vw_ProtosViewModel_Hierarchy source

-- ================================================
-- ✅ View: vw_ProtosViewModel_Hierarchy
-- Description: Displays Protos ViewModel parent-child tree structure
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================

CREATE VIEW vw_ProtosViewModel_Hierarchy AS
SELECT 
    tempP.TemplateName  AS Parent,
    tempP.TemplateType  AS ParentType,
    tempC.TemplateName  AS Child,
    tempC.TemplateType  AS ChildType,
    tree.CreatedAt
FROM ProtosTemplateTree tree

JOIN ProtosTemplateVersion parent 
    ON tree.ParentVersionID = parent.TemplateVersionID 

JOIN ProtosTemplateVersion child 
    ON tree.ChildVersionID = child.TemplateVersionID

JOIN ProtosTemplate tempP 
    ON tempP.TemplateID = parent.TemplateID

JOIN ProtosTemplate tempC 
    ON tempC.TemplateID = child.TemplateID;

GO

-- dbo.vw_ProtosFullFlatTree source

-- dbo.vw_ProtosFullFlatTree source

CREATE VIEW vw_ProtosFullFlatTree AS
SELECT 
  -- Parent Info
  parentTmpl.TemplateID        AS ParentTemplateID,
  parentTmpl.TemplateName      AS ParentTemplateName,
  parentTmpl.TemplateType      AS ParentTemplateType,

  -- Target Info
  plink.TargetObjectID AS ParentObjectID,
  plink.TargetTypeID   AS ParentTargetTypeID,
  parentVer.VersionLabel   AS  ParentVersionLabel,
  parentVer.VersionNumber   AS  ParentVersionNumber,
  parentVer.TemplateVersionID AS ParentVersionID, 
  -- Child Info
  childTmpl.TemplateID         AS ChildTemplateID,
  childTmpl.TemplateName       AS ChildTemplateName,
  childTmpl.TemplateType       AS ChildTemplateType,
  childVer.VersionLabel   AS ChildVersionLabel,
  childVer.VersionNumber   AS  ChildVersionNumber,
  childVer.TemplateVersionID   AS ChildVersionID,
  
  tree.SortOrder               AS ChildSortOrder,

  -- Resolver Info
  res.ResolverID,
  res.ResolverType,
  res.Target AS ResolverTarget,
  res.Description AS ResolverDescription,

  -- Target Info
  link.TargetObjectID AS ChildObjectID,
  link.TargetTypeID   AS ChildTargetTypeID,

  -- Audit
  tree.CreatedAt
FROM ProtosTemplateTree tree
JOIN ProtosTemplateVersion parentVer ON tree.ParentVersionID = parentVer.TemplateVersionID
JOIN ProtosTemplate parentTmpl ON parentVer.TemplateID = parentTmpl.TemplateID
LEFT JOIN ProtosTemplateLink plink ON plink.TemplateVersionID = parentVer.TemplateVersionID
JOIN ProtosTemplateVersion childVer ON tree.ChildVersionID = childVer.TemplateVersionID
JOIN ProtosTemplate childTmpl ON childVer.TemplateID = childTmpl.TemplateID
LEFT JOIN ProtosTemplateLink link ON link.TemplateVersionID = childVer.TemplateVersionID
LEFT JOIN Resolvers res ON res.ResolverID = link.ResolverID;
GO


-- ✅ Fix vw_SystemLogs (Uses Correct Columns 'LogType', 'LogMessage')
CREATE VIEW vw_SystemLogs AS
SELECT 
    sl.LogID, sl.LogType, sl.LogMessage, sl.CreatedAt
FROM SystemLogs sl;

GO


-- ✅ User Claims View
CREATE VIEW vw_UserClaims AS
SELECT 
    uc.UserId, u.UserName, u.Email, uc.ClaimType, uc.ClaimValue
FROM AspNetUserClaims uc
JOIN AspNetUsers u ON uc.UserId = u.Id;

GO


-- ✅ User Logins View
CREATE VIEW vw_UserLogins AS
SELECT 
    ul.UserId, u.UserName, u.Email, ul.LoginProvider, ul.ProviderKey
FROM AspNetUserLogins ul
JOIN AspNetUsers u ON ul.UserId = u.Id;

GO


-- =============================================
-- 🚀 Step 3: Create Payment & Subscription Views
-- =============================================

-- ✅ User Payment Methods View
CREATE VIEW vw_UserPaymentMethods AS
SELECT 
    pm.PaymentMethodID, pm.UserID, u.UserName, pm.Type, pm.Last4Digits, pm.ExpirationDate, pm.CreatedAt
FROM PaymentMethods pm
JOIN AspNetUsers u ON pm.UserID = u.Id;

GO

-- dbo.vw_UserPortalView source

CREATE VIEW vw_UserPortalView AS
SELECT 
    u.Id AS UserID,
    u.UserName,
    p.PortalID,
    p.PortalName
FROM skylynxnet_coredb.dbo.Users_Portals up
JOIN skylynxnet_coredb.dbo.AspNetUsers u ON up.UserID = u.Id
JOIN skylynxnet_coredb.dbo.Portals p ON up.PortalID = p.PortalID;
GO

-- ================================================
-- ✅ View: vw_UserProfile_AccountInfo
-- Description: Portal and security related user data
-- ================================================
CREATE   VIEW vw_UserProfile_AccountInfo AS
SELECT
    u.Id AS UserID,
    u.UserName,
    u.TwoFactorEnabled,
    u.AccessFailedCount,
    p.PortalName,
    p.Description AS PortalDescription,
    p.CreatedDate AS PortalCreatedDate
FROM UserProfiles up
LEFT JOIN AspNetUsers u ON up.UserID = u.Id
LEFT JOIN Portals p ON up.PortalID = p.PortalID
GO

-- ================================================
-- ✅ View: vw_UserProfile_Billing
-- Description: Billing address data
-- ================================================
CREATE   VIEW vw_UserProfile_Billing AS
SELECT
    up.UserID,
    ba.address_1 AS BillingAddress1,
    ba.address_2 AS BillingAddress2,
    ba.City AS BillingCity,
    ba.Zip AS BillingZip,
    ba.StateProvinceID AS BillingStateProvinceID
FROM UserProfiles up
LEFT JOIN Address ba ON up.BillingAddressID = ba.addyId
GO

-- ================================================
-- ✅ View: vw_UserProfile_ContactInfo
-- Description: Core contact details including name, email, phones, and mailing address
-- ================================================
CREATE   VIEW vw_UserProfile_ContactInfo AS
SELECT
    u.Id AS UserID,
    u.Email,
    u.EmailConfirmed,
    u.PhoneNumber AS PrimaryPhone,
    upf.FirstName,
    upf.LastName,
    upf.Phone AS MobilePhone,
    upf.DateOfBirth,
    a.address_1 AS MailingAddress1,
    a.address_2 AS MailingAddress2,
    a.City,
    a.Zip,
    a.StateProvinceID
FROM UserProfiles up
LEFT JOIN AspNetUsers u ON up.UserID = u.Id
LEFT JOIN Address a ON up.AddressID = a.addyId
LEFT JOIN vw_UserProfileFieldPivot upf ON up.UserID = upf.UserID AND up.ProviderID = upf.ProviderID
GO

-- ================================================
-- ✅ View: vw_UserProfile_Preferences
-- Description: Personalization settings
-- ================================================
CREATE   VIEW vw_UserProfile_Preferences AS
SELECT
    up.UserID,
    upf.PreferredLanguage,
    upf.Photo
FROM UserProfiles up
LEFT JOIN vw_UserProfileFieldPivot upf ON up.UserID = upf.UserID AND up.ProviderID = upf.ProviderID
GO

-- ================================================
-- ✅ View: vw_UserProfile_SystemInfo
-- Description: Admin-only view for system metadata
-- ================================================
CREATE   VIEW vw_UserProfile_SystemInfo AS
SELECT
    up.UserID,
    up.CreatedAt,
    up.UpdatedAt
FROM UserProfiles up
GO

CREATE VIEW vw_UserProfileFieldPivot AS
SELECT 
    up.UserID,
    up.ProviderID,
    up.PortalID,
    pt.PortalName,
    pp.ProviderName,
    MAX(CASE WHEN f.FieldName = 'FirstName' THEN upp.FieldValue END) AS FirstName,
    MAX(CASE WHEN f.FieldName = 'LastName' THEN upp.FieldValue END) AS LastName,
    MAX(CASE WHEN f.FieldName = 'Photo' THEN upp.FieldValue END) AS Photo,
    MAX(CASE WHEN f.FieldName = 'Phone' THEN upp.FieldValue END) AS Phone,
    MAX(CASE WHEN f.FieldName = 'DateOfBirth' THEN upp.FieldValue END) AS DateOfBirth,
    MAX(CASE WHEN f.FieldName = 'PreferredLanguage' THEN upp.FieldValue END) AS PreferredLanguage
FROM skylynxnet_coredb.dbo.UserProviderProfiles upp
JOIN skylynxnet_coredb.dbo.ProviderProfileFields f 
    ON upp.FieldID = f.FieldID
JOIN skylynxnet_coredb.dbo.UserProfiles up 
    ON upp.UserID = up.UserID AND upp.ProviderID = up.ProviderID
JOIN skylynxnet_coredb.dbo.Portals pt 
    ON up.PortalID = pt.PortalID
JOIN skylynxnet_coredb.dbo.ProfileProviders pp 
    ON up.ProviderID = pp.ProviderID
GROUP BY 
    up.UserID, 
    up.ProviderID, 
    up.PortalID, 
    pt.PortalName, 
    pp.ProviderName
GO

-- ================================================
-- ✅ View: vw_DyFormViewModel_Hierarchy
-- Description: Displays DyForm ViewModel parent-child relationships
-- Author: NimbusCore.OpenAI
-- Architect: Chad Martin
-- Company: CryoRio
-- ================================================

CREATE   VIEW vw_DyFormViewModel_Hierarchy AS
SELECT 
    parent.ViewModelName AS ParentViewModel,
    child.ViewModelName AS ChildViewModel,
    lin.CreatedAt
FROM DyFormViewModelLineage lin
JOIN DyFormViewModelDefinition parent
    ON lin.ViewModelDefinitionID = parent.ViewModelDefinitionID
JOIN DyFormViewModelDefinition child
    ON lin.ChildViewModelDefinitionID = child.ViewModelDefinitionID
GO



-- =============================================
-- 🚀 Views for Optimized API Queries
-- =============================================
CREATE VIEW vw_UserRoles AS
SELECT u.Id AS UserID, u.UserName, r.Name AS RoleName
FROM AspNetUserRoles ur
JOIN AspNetUsers u ON ur.UserId = u.Id
JOIN AspNetRoles r ON ur.RoleId = r.Id;

GO


-- ✅ Fix vw_UserTransactions (Uses Correct Column 'TransactionReference')
CREATE VIEW vw_UserTransactions AS
SELECT 
    t.TransactionID, t.UserID, u.UserName, t.PaymentMethodID, pm.Type AS PaymentType, 
    t.Amount, t.TransactionDate, t.Status, t.TransactionReference
FROM Transactions t
JOIN AspNetUsers u ON t.UserID = u.Id
JOIN PaymentMethods pm ON t.PaymentMethodID = pm.PaymentMethodID;

GO
