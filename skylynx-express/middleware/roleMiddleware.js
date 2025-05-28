module.exports = (requiredRoles) => {
  return async (req, res, next) => {
    try {
      console.log("🔍 Role Middleware Executed for User:", req.user?.id);

      if (!req.user) {
        return res
          .status(403)
          .json({ error: "Access denied. No user found in request." });
      }

      const userId = req.user.id;
      const pool = await poolPromise;

      console.log("🔍 Fetching roles for User:", userId);
      const result = await pool.request().input("UserId", sql.NVarChar, userId)
        .query(`
          SELECT r.Name FROM AspNetUserRoles ur 
          JOIN AspNetRoles r ON ur.RoleId = r.Id 
          WHERE ur.UserId = @UserId
        `);

      console.log(
        "✅ Roles Retrieved:",
        result.recordset.map((r) => r.Name)
      );

      const userRoles = result.recordset.map((row) => row.Name);
      if (!Array.isArray(requiredRoles)) {
        requiredRoles = [requiredRoles]; // Convert single string to array
      }

      const hasRole = userRoles.some((role) =>
        requiredRoles.includes(role)
      );
      if (!hasRole) {
        return res
          .status(403)
          .json({ error: "Access denied. You do not have the required role." });
      }

      next(); // Move to next middleware
    } catch (error) {
      console.error("❌ Role Middleware Error:", error.message, error.stack);
      res.status(500).json({ error: "Internal server error." });
    }
  };
};
