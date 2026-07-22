/*
  SkyLynx SQL Seed Export
  Database: skylynxnet_coredb
  Section: Seed dbo.DyFormRuleType
  Generated: 2026-07-22T22:36:46.591Z
  Intended use: fresh database seeding after core schema install.
*/
GO

SET NOCOUNT ON;
INSERT INTO [dbo].[DyFormRuleType] ([RuleTypeID], [Name], [Description]) VALUES (N'D430479A-073A-4AD2-807E-018863DA82A3', N'WarningOnly', N'Triggers warning messages without blocking input');
INSERT INTO [dbo].[DyFormRuleType] ([RuleTypeID], [Name], [Description]) VALUES (N'05B4B44B-C721-4B70-8581-031BA32E5576', N'AutoFill', N'Automatically fills values based on conditions');
INSERT INTO [dbo].[DyFormRuleType] ([RuleTypeID], [Name], [Description]) VALUES (N'B6510AD6-C844-474D-891D-127F1042E3F3', N'disabled', N'field is shown not editable');
INSERT INTO [dbo].[DyFormRuleType] ([RuleTypeID], [Name], [Description]) VALUES (N'3A4232E8-FC3F-4B71-B57E-20FF0EE14BD5', N'showIf', N'show if a condtion is met');
INSERT INTO [dbo].[DyFormRuleType] ([RuleTypeID], [Name], [Description]) VALUES (N'2CD3A3F8-9EED-43FC-86FE-449ADCE8F997', N'ComputedValue', N'Calculates and assigns a value to a field dynamically');
INSERT INTO [dbo].[DyFormRuleType] ([RuleTypeID], [Name], [Description]) VALUES (N'80CE1F94-E906-43AF-B116-4A8F7E942BFF', N'hidden', N'hide this field');
INSERT INTO [dbo].[DyFormRuleType] ([RuleTypeID], [Name], [Description]) VALUES (N'A1E0B177-BE0F-48CB-92CD-55DC6E5AA51A', N'validation', N'validate against DyForm rules');
INSERT INTO [dbo].[DyFormRuleType] ([RuleTypeID], [Name], [Description]) VALUES (N'291F7216-81EF-4F17-B623-84F6EF29547F', N'DefaultValue', N'Sets a field''s default based on context or input');
INSERT INTO [dbo].[DyFormRuleType] ([RuleTypeID], [Name], [Description]) VALUES (N'793A3A63-7F3B-470F-A78A-890C19795C41', N'isRequired', N'field is reuired');
GO
