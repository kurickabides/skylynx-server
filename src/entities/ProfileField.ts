// ProfileField.ts
export interface UserProfileField {
  FieldID: string;
  FieldValue: string;
  FieldName?: string;
}

export interface SkylynxUserProfile {
  UserID?: string;
  Username: string;
  Email: string;
  EmailConfirmed?: boolean;
  PhoneNumber?: string;
  PhoneNumberConfirmed?: boolean;
  TwoFactorEnabled?: boolean;
  AccessFailedCount?: number;
  ProviderID?: string;
  PortalID?: string;
  FirstName?: string;
  LastName?: string;
  Photo?: string;
  MobilePhone?: string;
  DateOfBirth?: string;
  PreferredLanguage?: string;
  AddressID?: string;
  MailingAddress1?: string;
  MailingAddress2?: string;
  City?: string;
  Zip?: string;
  StateProvinceID?: string;
  BillingAddressID?: string;
  BillingAddress1?: string;
  BillingAddress2?: string;
  BillingCity?: string;
  BillingZip?: string;
  BillingStateProvinceID?: string;
  CreatedAt?: string;
  UpdatedAt?: string;
}
