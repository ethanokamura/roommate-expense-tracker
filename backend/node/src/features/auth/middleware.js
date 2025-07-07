function validateUser (req, res, next) {
  if (!req.user || !req.user_id) {
    return res.status(401).json({ error: "Unauthorized" });
  }
  next();
}

module.exports = { validateUser };
