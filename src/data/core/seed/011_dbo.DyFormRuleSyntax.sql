/*
  SkyLynx SQL Seed Export
  Database: skylynxnet_coredb
  Section: Seed dbo.DyFormRuleSyntax
  Generated: 2026-07-22T22:36:46.586Z
  Intended use: fresh database seeding after core schema install.
*/
GO

SET NOCOUNT ON;
INSERT INTO [dbo].[DyFormRuleSyntax] ([RuleSyntaxID], [SyntaxName], [Description], [CreatedAt], [UpdatedAt]) VALUES (N'8EB3A991-DF94-408D-AB70-0726FE943EE0', N'readOnly', N'This rule makes the field read-only, preventing the user from modifying its value.', N'2025-06-19 00:36:13.707', N'2025-06-19 00:36:13.707');
INSERT INTO [dbo].[DyFormRuleSyntax] ([RuleSyntaxID], [SyntaxName], [Description], [CreatedAt], [UpdatedAt]) VALUES (N'4ED08B86-E6CC-4518-A5C5-46205AC19D7B', N'visibility', N'This rule controls the visibility of the field based on conditions or other fields.', N'2025-06-19 00:36:13.707', N'2025-06-19 00:36:13.707');
INSERT INTO [dbo].[DyFormRuleSyntax] ([RuleSyntaxID], [SyntaxName], [Description], [CreatedAt], [UpdatedAt]) VALUES (N'E5E0B382-69FD-4D1C-9F41-5D8A3D5C6C9F', N'validation', N'This rule applies custom validation logic, such as regex checks or other conditions.', N'2025-06-19 00:36:13.700', N'2025-06-19 00:36:13.700');
INSERT INTO [dbo].[DyFormRuleSyntax] ([RuleSyntaxID], [SyntaxName], [Description], [CreatedAt], [UpdatedAt]) VALUES (N'7902F114-66A0-41EE-A9F7-918507229533', N'default', N'This rule sets a default value for the field if no value is provided by the user.', N'2025-06-19 00:36:13.710', N'2025-06-19 00:36:13.710');
INSERT INTO [dbo].[DyFormRuleSyntax] ([RuleSyntaxID], [SyntaxName], [Description], [CreatedAt], [UpdatedAt]) VALUES (N'C7A18864-0BE0-4C1A-A336-A2E951504C61', N'computed', N'This rule calculates the field value dynamically based on other fields or logic.', N'2025-06-19 00:36:13.703', N'2025-06-19 00:36:13.703');
INSERT INTO [dbo].[DyFormRuleSyntax] ([RuleSyntaxID], [SyntaxName], [Description], [CreatedAt], [UpdatedAt]) VALUES (N'6DC7DCBF-7D9B-49F2-B515-BAE719075B54', N'isRequired', N'This rule ensures that the field is mandatory and cannot be left empty.', N'2025-06-19 00:36:13.697', N'2025-06-19 00:36:13.697');
GO
