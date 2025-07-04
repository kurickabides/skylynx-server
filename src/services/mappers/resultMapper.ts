// ================================================
// ✅ Mapper: resultMapper
// Description: Converts raw resultsets from SP into DyForm sections
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename:resultMapper.ts
// ================================================

import {
  vmAspNetUserModel,
  vmAddressModel,
  vmProviderProfileFieldModel,
  vmProviderProfileValueModel,
} from "../../entities/skylynx/types";
import {
  DyFormField, DyFormSection,
} from "../../entities/dyform/types";

export function mapUserProfileResults(recordsets: any[]): DyFormSection[] {
  const sections: DyFormSection[] = [];

  const userInfo: vmAspNetUserModel = recordsets[0]?.[0] || {};
  const mailing: vmAddressModel = recordsets[1]?.[0] || {};
  const billing: vmAddressModel = recordsets[2]?.[0] || {};
  const profileFields: vmProviderProfileFieldModel[] = recordsets[3] || [];
  const profileValues: vmProviderProfileValueModel[] = recordsets[4] || [];

  // Section 1: User Info
  const userFields: DyFormField[] = Object.entries(userInfo).map(
    ([key, value]) => ({
      fieldId: key,
      label: key,
      value,
      type: "TextInput",
    })
  );

  sections.push({
    name: "User Info",
    fields: userFields,
  });

  // Section 2: Mailing Address
  const mailingFields: DyFormField[] = Object.entries(mailing).map(
    ([key, value]) => ({
      fieldId: key,
      label: key,
      value,
      type: "TextInput",
    })
  );

  sections.push({
    name: "Mailing Address",
    fields: mailingFields,
  });

  // Section 3: Billing Address
  const billingFields: DyFormField[] = Object.entries(billing).map(
    ([key, value]) => ({
      fieldId: key,
      label: key,
      value,
      type: "TextInput",
    })
  );

  sections.push({
    name: "Billing Address",
    fields: billingFields,
  });

  // Section 4: Dynamic Profile Fields
  const dynamicFields: DyFormField[] = profileFields.map((def) => {
    const valueObj = profileValues.find((v) => v.FieldID === def.FieldID);
    return {
      fieldId: def.FieldID,
      label: def.FieldName,
      value: valueObj?.FieldValue || "",
      type: "TextInput",
      required: def.IsRequired,
    };
  });

  sections.push({
    name: "Dynamic Profile Fields",
    fields: dynamicFields,
  });

  return sections;
}
