"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getDyFormViewModel = getDyFormViewModel;
const dyformFactory_1 = require("../services/dyform/factories/dyformFactory");
const types_1 = require("../entities/dyform/types");
async function getDyFormViewModel(req, res) {
    const { viewModelName } = req.params;
    const { userId, providerId } = req.body;
    if (!userId) {
        return res.status(400).json({ error: "Missing required field: userId" });
    }
    const enumKey = Object.values(types_1.ViewModelName).find((v) => v === viewModelName);
    if (!enumKey) {
        return res
            .status(400)
            .json({ error: `Unsupported ViewModelName: ${viewModelName}` });
    }
    try {
        const portalName = req.portalName;
        const portalId = req.portalId;
        const result = await (0, dyformFactory_1.buildDyFormViewModel)(enumKey, userId, portalName, portalId, providerId);
        res.json(result);
    }
    catch (err) {
        console.error("❌ DyForm load error:", err);
        res.status(500).json({ error: err.message });
    }
}
