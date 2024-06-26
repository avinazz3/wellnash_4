const jwt = require('jsonwebtoken');
const auth = async (req, res, next) => {
  try {
    const token = req.header('x-auth-token');
    if (!token) return res.status(401).send({ error: 'Not authorized! No Auth Token' });

    const verified = jwt.verify(token, "passwordKey");
    if (!verified) return res.status(401).json({ message: 'Token verification failed, authorization denied.' });

    req.user = verified.id;
    req.token = token;
    next();
  } catch (error) {
    res.status(500).json({ message: 'Token verfication failed, authorization denied' });
  }
};

module.exports = auth;