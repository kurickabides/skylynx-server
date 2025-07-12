// ================================================
// ✅ Class: ResultMapper
// Description: Converts raw resultsets from SP into DyForm ViewModel objects
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
  SkylynxDataModelRecords,
} from "../../entities/skylynx/types";

import { DyFormField, DyFormSection } from "../../entities/dyform/types";

export class ResultMapper {
  /**
   * ✅ Generic DyForm mapping using SkylynxDataModelRecords model as the base interface
   */
  static mapFormData(
    recordsets: any[],
    dataModelDefinition: Record<keyof SkylynxDataModelRecords, string>
  ): SkylynxDataModelRecords {
    const model = {} as SkylynxDataModelRecords;
    const keys = Object.keys(dataModelDefinition) as Array<
      keyof SkylynxDataModelRecords
    >;

    keys.forEach((key, index) => {
      model[key] = recordsets[index] as SkylynxDataModelRecords[typeof key];
    });

    return model;
  }

  /**
   * (Optional legacy) Map user profile resolver recordsets to known structure
   */
  static mapUserProfileResults(recordsets: unknown[]): {
    aspNetUserModel: vmAspNetUserModel[];
    mailingAddressModel: vmAddressModel[];
    billingAddressModel: vmAddressModel[];
    providerProfileFieldModel: vmProviderProfileFieldModel[];
    providerProfileValueModel: vmProviderProfileValueModel[];
  } {
    return {
      aspNetUserModel: recordsets[0] as vmAspNetUserModel[],
      mailingAddressModel: recordsets[1] as vmAddressModel[],
      billingAddressModel: recordsets[2] as vmAddressModel[],
      providerProfileFieldModel: recordsets[3] as vmProviderProfileFieldModel[],
      providerProfileValueModel: recordsets[4] as vmProviderProfileValueModel[],
    };
  }
}
