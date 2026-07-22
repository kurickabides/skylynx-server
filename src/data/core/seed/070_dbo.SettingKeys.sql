/*
  SkyLynx SQL Seed Export
  Database: skylynxnet_coredb
  Section: Seed dbo.SettingKeys
  Generated: 2026-07-22T22:36:46.908Z
  Intended use: fresh database seeding after core schema install.
*/
GO

SET NOCOUNT ON;
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'E93ED921-AFD0-499E-AE38-0308D39795BB', N'captchaType', N'Captcha Type', N'string', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'E658FA7B-61B8-43E0-A9E6-04E9F282475B', N'imagePath', N'Image Path', N'string', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'57C74BE7-7439-43FD-958C-09F6758151E7', N'highlightOnHover', N'Highlight on Hover', N'boolean', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'D1D4BA7A-5A4E-42F4-9100-0A1F6BC528BB', N'enableSignup', N'Enable Signup', N'boolean', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'98DD38E4-0353-4A8A-894F-0EF18509D3C2', N'enableZoom', N'Enable Zoom', N'boolean', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'749B1FA2-AE9C-409F-A4E7-10959B04C563', N'drawingScale', N'Drawing Scale', N'string', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'A5B1E184-4E7E-4F3E-A2E9-1D6F6F02862C', N'getUserProfilePersonalInfo', N'Include Personal Info Profile', N'boolean', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'BA504075-26B1-49F8-9F8C-1F2DC3713566', N'getPhoneNumber', N'Phone Number Field', N'boolean', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'BD723255-4E2F-478A-9FD0-30EE27639421', N'layoutVariant', N'Layout Variant', N'string', N'59A0FD0A-AC48-4CD9-883D-2EABF3C415B2');
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'6A935638-D245-4EE4-9F45-343CDD686C30', N'showRulerOverlay', N'Show Ruler Overlay', N'boolean', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'22466A22-8750-49C7-B06C-3C066E718493', N'showToolbar', N'Show Toolbar', N'boolean', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'C51CB0BC-C99A-4ADC-B66F-3E11619CB538', N'getEmail', N'Get Email Field', N'boolean', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'848A4797-3919-4FC3-8DEA-417252946ABA', N'requireEmailVerification', N'Require Email Verification', N'boolean', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'A3CAAA19-F7E6-40FD-8930-4EED2C86D9C0', N'confirmEmail', N'Confirm Email Field', N'boolean', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'CE705B9D-14FE-44C9-B40C-4FA0AE9D2701', N'enableCaptcha', N'Enable Captcha', N'boolean', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'9D001C30-DB98-4BDC-99F9-541A76A69E0D', N'autoSaveInterval', N'Auto Save Interval (seconds)', N'integer', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'EF089233-2D09-464E-8BEF-5777C37C77B5', N'getUsername', N'Get Username Field', N'boolean', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'394E6B47-1DBE-4277-AFB8-57F285D9342D', N'enableFormAnnotations', N'Enable Form Annotations', N'boolean', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'AD6BC3D3-0C1D-42AC-9F8F-5AD421F97205', N'showTitle', N'Show Title', N'boolean', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'E40657BB-842A-40C7-8242-5E51C5192B19', N'galleryLayoutVariant', N'Changes the Layout of the module', N'string', N'59A0FD0A-AC48-4CD9-883D-2EABF3C415B2');
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'4B24C867-63AC-44F7-9E36-69CBF0BEF0D8', N'confirmPhoneNumber', N'Confirm Phone Number Field', N'boolean', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'EBDD962A-74A6-40B7-8C27-6CB788749953', N'snapToGrid', N'Snap to Grid', N'boolean', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'4604A9B2-B959-4A3B-818C-6D15F015E160', N'markupDataSourceID', N'Markup Data Source ID', N'string', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'F95C0BD8-1DC4-4951-9AB2-6F843FCDE955', N'maxHeight', N'Max Height (px)', N'integer', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'36C73EA8-BD83-472E-A0EB-742F47EBA07E', N'enablePan', N'Enable Pan', N'boolean', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'28013DC3-0708-4C39-9AE2-76EE09D839A5', N'showScaleIndicator', N'Show Scale Indicator', N'boolean', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'5A0B7C17-25C3-4591-B5E6-78BCEC80CB97', N'enablePhotoOverlay', N'Enable Photo Overlay', N'boolean', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'B65B258A-1B32-4563-A8C4-7B36480D58C3', N'payments.iframeCommunicatorUrl', N'ANet IFrame Communicator URL', N'String', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'ADC666A4-B9AB-4CA9-B977-7F96EB4DBF71', N'filePath', N'File Path', N'string', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'B166336B-7DE0-4A99-A3A5-7FD50CFFC4EA', N'payments.cancelUrl', N'Payment Cancel URL', N'String', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'2447530B-E8FA-4D4E-ACEE-8282EDF0FB2F', N'requirePhoneVerification', N'Require Phone Verification', N'boolean', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'E7CD3FF3-3CDD-4EAB-B5B3-8DB1C64E1090', N'pdfPath', N'PDF File Path', N'string', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'BE11A93C-6BE9-4451-9EE9-96B04264EA2B', N'showDescription', N'Show Description', N'boolean', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'5B238950-3778-4827-BBBD-98382068486D', N'esriMapZoom', N'Map Zoom Level', N'integer', N'656ADB7A-11FB-4074-9651-EF45B996D25D');
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'76C0AA0A-8257-4330-BB8D-A5854E86D2C3', N'layerVisibility', N'Visibility map for named layers in ESRIMapModule', N'json', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'F93A4E7C-9C07-49AB-8201-A60A7C6C3049', N'enableTwoFactor', N'Enable Two-Factor Authentication', N'boolean', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'85310E14-8A8E-4289-A903-A92195E3D3DE', N'payments.defaultProviderId', N'Default Payments Provider ID (GUID)', N'String', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'45CED1B7-62DC-49AF-895F-B94B6234F638', N'center', N'Map Center Coordinates', N'json', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'F181B434-2FA5-420A-9D0B-C099CF63978D', N'enableDynamicScale', N'Enable Dynamic Scale', N'boolean', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'34E529CD-49D0-4F88-A8F6-C3D6A174150A', N'getUserProfileAdressVMInfo', N'Include Address Info Profile', N'boolean', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'9461641A-B8B9-45C8-BC42-C6221AC879C3', N'autoLoginAfterSignup', N'Auto Login After Signup', N'boolean', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'2AC2B1AA-D73D-4BCA-B98B-C8F0E0EF8D85', N'payments.showSandboxBanner', N'Show Sandbox Banner', N'Boolean', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'89B5C841-7CAF-47B4-9C05-CDAC3BE06313', N'markupColor', N'Markup Color (Hex)', N'string', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'16B14973-3253-4411-845C-D0CFA4B78E0A', N'height', N'Module Height (px)', N'integer', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'447B5AA9-8FD4-4488-945D-D1F6F7A02A69', N'defaultRedirect', N'Default Redirect Path', N'string', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'ADE35439-F87B-470D-B193-DA1E039A83BC', N'persistViewport', N'Persist Viewport', N'boolean', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'0B9CAB78-F3DD-425F-A4BF-DE934BF7B412', N'defaultZoomLevel', N'Default Zoom Level', N'decimal', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'0E373320-110E-473F-A3F0-EA0F31C43825', N'title', N'Module Title', N'string', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'50368235-5581-4B20-B867-ED3449735911', N'edPDFDefaultShapeTool', N'Sets the Default shape Tool', N'string', N'F930E0C4-9A0F-4464-B2BD-4AD664EBD382');
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'B302278F-7382-41DB-9ED8-ED8DC8C4D4DD', N'enablePageNav', N'Enable Page Navigation', N'boolean', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'4568817D-9FB3-4FC0-B48C-F2295825C405', N'signupFormTemplate', N'Signup Form Template', N'string', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'6D0917B8-A7A8-46B3-9979-FAE5EF62D862', N'payments.returnUrl', N'Payment Return URL', N'String', NULL);
INSERT INTO [dbo].[SettingKeys] ([SettingKeyID], [KeyName], [Label], [ValueType], [DomainID]) VALUES (N'A055171E-96A1-4812-B4D2-FAF7DE18C275', N'getUserProfileBillingVMInfo', N'Include Billing Info Profile', N'boolean', NULL);
GO
