"use strict";
// ================================================
// ✅ Class: ResultMapper
// Description: Converts raw resultsets from SP into DyForm ViewModel objects
// Author: NimbusCore.OpenAI
// Architect: Chad Martin
// Company: CryoRio
// Filename:resultMapper.ts
// ================================================
Object.defineProperty(exports, "__esModule", { value: true });
exports.mapUserProfileResults = exports.ResultMapper = void 0;
class ResultMapper {
    /**
     * ✅ Generic DyForm mapping using SkylynxDataModelRecords model as the base interface
     */
    static mapFormData(recordsets, dataModelDefinition) {
        const model = {};
        const keys = Object.keys(dataModelDefinition);
        keys.forEach((key, index) => {
            model[key] = recordsets[index];
        });
        return model;
    }
    /**
     * (Optional legacy) Map user profile resolver recordsets to known structure
     */
    static mapUserProfileResults(recordsets) {
        return {
            aspNetUserModel: recordsets[0],
            mailingAddressModel: recordsets[1],
            billingAddressModel: recordsets[2],
            providerProfileFieldModel: recordsets[3],
            providerProfileValueModel: recordsets[4],
        };
    }
}
exports.ResultMapper = ResultMapper;
exports.mapUserProfileResults = ResultMapper.mapUserProfileResults;
