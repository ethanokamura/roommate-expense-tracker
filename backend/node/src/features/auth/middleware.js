const admin = require('firebase-admin');

// Middleware to verify ID token
async function authenticateJWT(req, res, next) {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'Unauthorized' });
  }

  const idToken = authHeader.split('Bearer ')[1];

  try {
    const decoded = await admin.auth().verifyIdToken(idToken);
    req.user = decoded; // uid is here
    next();
  } catch (err) {
    res.status(401).json({ error: 'Invalid or expired token' });
  }
}

module.exports = { authenticateJWT };