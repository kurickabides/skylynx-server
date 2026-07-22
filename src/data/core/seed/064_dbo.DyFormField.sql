/*
  SkyLynx SQL Seed Export
  Database: skylynxnet_coredb
  Section: Seed dbo.DyFormField
  Generated: 2026-07-22T22:36:46.870Z
  Intended use: fresh database seeding after core schema install.
*/
GO

SET NOCOUNT ON;
INSERT INTO [dbo].[DyFormField] ([DyFormFieldID], [FieldTypeID], [Tooltip], [Label], [DomainID]) VALUES (N'3B084BF3-6450-4CE2-871C-081047E5091A', N'4C741F7F-003F-4BB3-946C-2887BB051AD0', N'Date when the account was created', N'Account Created Date', NULL);
INSERT INTO [dbo].[DyFormField] ([DyFormFieldID], [FieldTypeID], [Tooltip], [Label], [DomainID]) VALUES (N'7C7D31D8-65CB-498E-88EF-09FCF6F15EDF', N'6888442E-18D2-4C82-BA1E-4D76FA48B26A', N'Optional portal description', N'Portal Description', NULL);
INSERT INTO [dbo].[DyFormField] ([DyFormFieldID], [FieldTypeID], [Tooltip], [Label], [DomainID]) VALUES (N'6E6192A5-F8A9-4D74-883D-2409A8E0288C', N'6888442E-18D2-4C82-BA1E-4D76FA48B26A', N'City of the address', N'City', NULL);
INSERT INTO [dbo].[DyFormField] ([DyFormFieldID], [FieldTypeID], [Tooltip], [Label], [DomainID]) VALUES (N'45DC9A84-4F95-4F99-A347-259CEF7CCA00', N'4C741F7F-003F-4BB3-946C-2887BB051AD0', N'Primary key for the user', N'User ID', NULL);
INSERT INTO [dbo].[DyFormField] ([DyFormFieldID], [FieldTypeID], [Tooltip], [Label], [DomainID]) VALUES (N'7253B9C3-D631-4E69-9B69-2B493662DB0F', N'553C123C-6AE6-4622-9F7B-0B04CAE1B2FC', N'Indicates if phone was verified', N'Phone Confirmed', NULL);
INSERT INTO [dbo].[DyFormField] ([DyFormFieldID], [FieldTypeID], [Tooltip], [Label], [DomainID]) VALUES (N'6BE086EC-DF8D-4953-8919-2E18CFAF2BE3', N'CFC10F7A-4699-48B6-B1D2-CA308ED95B7B', N'Indicates if this portal is default', N'IsPortalDefault', N'5BCB2674-C13C-4A9D-841C-90A3F4BC1AFF');
INSERT INTO [dbo].[DyFormField] ([DyFormFieldID], [FieldTypeID], [Tooltip], [Label], [DomainID]) VALUES (N'00684C07-6C5E-4966-B39A-517CD8B56535', N'6888442E-18D2-4C82-BA1E-4D76FA48B26A', N'Zip or postal code', N'Zip', NULL);
INSERT INTO [dbo].[DyFormField] ([DyFormFieldID], [FieldTypeID], [Tooltip], [Label], [DomainID]) VALUES (N'6ACECB5B-EA12-473E-8E1B-5E7934B274BB', N'290FAA6F-0516-42FF-9B0B-15D6F9C96C27', N'Admin use only', N'Address ID', NULL);
INSERT INTO [dbo].[DyFormField] ([DyFormFieldID], [FieldTypeID], [Tooltip], [Label], [DomainID]) VALUES (N'B565B6C3-546B-497F-8DF6-6AB24992CD1C', N'6888442E-18D2-4C82-BA1E-4D76FA48B26A', N'Service provider name', N'Provider Name', NULL);
INSERT INTO [dbo].[DyFormField] ([DyFormFieldID], [FieldTypeID], [Tooltip], [Label], [DomainID]) VALUES (N'2CCDA726-F0D0-4E86-8FE6-775A0E5790A7', N'CFC10F7A-4699-48B6-B1D2-CA308ED95B7B', N'Indicates if this provider is system-wide default', N'IsSystemDefault', N'5BCB2674-C13C-4A9D-841C-90A3F4BC1AFF');
INSERT INTO [dbo].[DyFormField] ([DyFormFieldID], [FieldTypeID], [Tooltip], [Label], [DomainID]) VALUES (N'03E1F04A-2AD4-4A01-8FDA-77D02D51282D', N'6888442E-18D2-4C82-BA1E-4D76FA48B26A', N'Name of the portal you are assigned to', N'Portal Name', NULL);
INSERT INTO [dbo].[DyFormField] ([DyFormFieldID], [FieldTypeID], [Tooltip], [Label], [DomainID]) VALUES (N'8C420A4A-F3AB-4931-AD9C-7887FD3599D8', N'312BD32E-9EFF-4565-A53F-A3392E5F82DE', N'Optional contact phone number', N'Phone', NULL);
INSERT INTO [dbo].[DyFormField] ([DyFormFieldID], [FieldTypeID], [Tooltip], [Label], [DomainID]) VALUES (N'824F04F9-B1CD-4071-9E2E-8400CDBC9A9A', N'6888442E-18D2-4C82-BA1E-4D76FA48B26A', N'Enter your first name', N'First Name', NULL);
INSERT INTO [dbo].[DyFormField] ([DyFormFieldID], [FieldTypeID], [Tooltip], [Label], [DomainID]) VALUES (N'D73B501D-2F16-43E2-AB71-89BD514C729A', N'6888442E-18D2-4C82-BA1E-4D76FA48B26A', N'Enter your Street Address', N'Street Address', NULL);
INSERT INTO [dbo].[DyFormField] ([DyFormFieldID], [FieldTypeID], [Tooltip], [Label], [DomainID]) VALUES (N'ABF9E2D2-71F4-439D-BE18-9284BFD347C2', N'6888442E-18D2-4C82-BA1E-4D76FA48B26A', N'User Name tooltip', N'User Name', NULL);
INSERT INTO [dbo].[DyFormField] ([DyFormFieldID], [FieldTypeID], [Tooltip], [Label], [DomainID]) VALUES (N'5FEBBDBD-24C0-41CD-BEE4-B712714A4908', N'290FAA6F-0516-42FF-9B0B-15D6F9C96C27', N'Admin use only', N'StateProvinceID', NULL);
INSERT INTO [dbo].[DyFormField] ([DyFormFieldID], [FieldTypeID], [Tooltip], [Label], [DomainID]) VALUES (N'9B7A62E1-1BCE-47AC-BB0C-C3720DEB9289', N'8C44C180-1BA0-4D38-839A-491E8D251AC2', N'Email address used for login', N'Email', NULL);
INSERT INTO [dbo].[DyFormField] ([DyFormFieldID], [FieldTypeID], [Tooltip], [Label], [DomainID]) VALUES (N'4715D550-6789-4BC0-99C8-C4467833EA58', N'45356CFB-AAFA-4B2F-8C95-FC56CAE9D940', N'Preferred Language tooltip', N'Preferred Language', NULL);
INSERT INTO [dbo].[DyFormField] ([DyFormFieldID], [FieldTypeID], [Tooltip], [Label], [DomainID]) VALUES (N'0835BDF1-0464-4CA4-8AC0-C5FD0B803503', N'6888442E-18D2-4C82-BA1E-4D76FA48B26A', N'Enter your last name', N'Last Name', NULL);
INSERT INTO [dbo].[DyFormField] ([DyFormFieldID], [FieldTypeID], [Tooltip], [Label], [DomainID]) VALUES (N'B3503B72-D911-4AB6-A5F9-C62DBFEB31B8', N'1A2B410F-4EED-4D35-9CC2-316EAFB41125', N'Date the portal was created', N'Portal Created Date', NULL);
INSERT INTO [dbo].[DyFormField] ([DyFormFieldID], [FieldTypeID], [Tooltip], [Label], [DomainID]) VALUES (N'185DC9C5-9560-4A68-B3F2-C736A78514A1', N'4C741F7F-003F-4BB3-946C-2887BB051AD0', N'Internal security hash/token', N'Security Stamp', NULL);
INSERT INTO [dbo].[DyFormField] ([DyFormFieldID], [FieldTypeID], [Tooltip], [Label], [DomainID]) VALUES (N'35ECA553-EAB8-49A5-9318-C97CB6764563', N'4C741F7F-003F-4BB3-946C-2887BB051AD0', N'Number of failed login attempts', N'Access Failed Count', NULL);
INSERT INTO [dbo].[DyFormField] ([DyFormFieldID], [FieldTypeID], [Tooltip], [Label], [DomainID]) VALUES (N'CCBB35C8-AA1C-4D17-92C3-CA219BEAB0B4', N'553C123C-6AE6-4622-9F7B-0B04CAE1B2FC', N'Whether account can be locked out', N'Lockout Enabled', N'5BCB2674-C13C-4A9D-841C-90A3F4BC1AFF');
INSERT INTO [dbo].[DyFormField] ([DyFormFieldID], [FieldTypeID], [Tooltip], [Label], [DomainID]) VALUES (N'5B7AC37E-87C4-41B1-B91B-CC5FE2486C44', N'6888442E-18D2-4C82-BA1E-4D76FA48B26A', N'Enter Apt or Unit Number', N'APT Address', NULL);
INSERT INTO [dbo].[DyFormField] ([DyFormFieldID], [FieldTypeID], [Tooltip], [Label], [DomainID]) VALUES (N'CB53A861-B7F6-43E0-A504-D958159FB70C', N'1A2B410F-4EED-4D35-9CC2-316EAFB41125', N'Your birth date', N'Date of Birth', NULL);
INSERT INTO [dbo].[DyFormField] ([DyFormFieldID], [FieldTypeID], [Tooltip], [Label], [DomainID]) VALUES (N'552F169A-7F77-4EF0-990E-D9FEC3867D07', N'553C123C-6AE6-4622-9F7B-0B04CAE1B2FC', N'Two-Factor Enabled tooltip', N'Two-Factor Enabled', NULL);
INSERT INTO [dbo].[DyFormField] ([DyFormFieldID], [FieldTypeID], [Tooltip], [Label], [DomainID]) VALUES (N'D2462C27-34A2-4CA3-83AA-DD0858FD7DCA', N'312BD32E-9EFF-4565-A53F-A3392E5F82DE', N'Phone number linked to your account', N'PhoneNumber', NULL);
INSERT INTO [dbo].[DyFormField] ([DyFormFieldID], [FieldTypeID], [Tooltip], [Label], [DomainID]) VALUES (N'D0479A3D-75E2-4B49-9717-EB0B7B5E60CE', N'45356CFB-AAFA-4B2F-8C95-FC56CAE9D940', N'Enter State value here', N'State, Province', NULL);
INSERT INTO [dbo].[DyFormField] ([DyFormFieldID], [FieldTypeID], [Tooltip], [Label], [DomainID]) VALUES (N'1A156D85-30F3-4DDD-BF7D-F117BA4AACF8', N'4C741F7F-003F-4BB3-946C-2887BB051AD0', N'End date of account lockout', N'Lockout End Date', NULL);
INSERT INTO [dbo].[DyFormField] ([DyFormFieldID], [FieldTypeID], [Tooltip], [Label], [DomainID]) VALUES (N'86435237-9F68-4E1C-A0B8-F60405E1208B', N'553C123C-6AE6-4622-9F7B-0B04CAE1B2FC', N'Indicates if email was verified', N'Email Confirmed', N'5BCB2674-C13C-4A9D-841C-90A3F4BC1AFF');
INSERT INTO [dbo].[DyFormField] ([DyFormFieldID], [FieldTypeID], [Tooltip], [Label], [DomainID]) VALUES (N'A9496C77-B407-47F6-8DFD-FCD1B387AB9D', N'22D21BE9-4D07-400B-8A67-A73572380A0F', N'Profile Photo tooltip', N'Profile Photo', NULL);
GO
