const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const { sequelize } = require('../../models');
const auth = require('../../middleware/auth');
const jwt = require('jsonwebtoken');
const injuryMap = require('../../config/injuryMap'); 

const validateEmail = (email) => {
  return email.match(
    /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
  );
};

// SIGNUP
router.post('/signup', async (req, res) => {
  try {
    const {email, name, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ message: 'Email and password are required' });
    }

    const existingUser = await sequelize.models.User.findOne({ where: { email } });
    if (existingUser) {
      return res.status(400).json({ message: 'User already exists' });
    }

    if (!validateEmail(email)) {
      return res.status(400).json({ error: 'Invalid email format' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    console.log('Plain Password:', password); // Log the plain password
    console.log('Hashed Password:', hashedPassword); // Log the hashed password
    const user = await sequelize.models.User.create({ email, name, password: hashedPassword });

    res.status(201).json({ message: 'User registered successfully', user });
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: e.message });
  }
});

// LOGIN
router.post('/signin', async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ message: 'Email and password are required' });
    }

    const user = await sequelize.models.User.findOne({ where: { email } });
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    console.log('Stored Hashed Password:', user.password); // Log the stored hashed password
    console.log('Input Password:', password); // Log the input password

    const isPasswordValid = await bcrypt.compare(password, user.password);
    console.log('Is Password Valid:', isPasswordValid); // Log the result of password comparison
    if (!isPasswordValid) {
      return res.status(401).json({ message: 'Invalid password' });
    }

    const token = jwt.sign({ id: user.id }, "passwordKey");

    res.json({ token, user });
  } catch (e) {
    console.error(e);
    res.status(500).json({ message: e.message + ' Error 500'});
  }
});

// Token validation
router.post("/tokenIsValid", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) return res.json(false);

    const verified = jwt.verify(token, "passwordKey");
    if (!verified) return res.json(false);

    const user = await sequelize.models.User.findByPk(verified.id);
    if (!user) return res.json(false);

    return res.json(true);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message });
  }
});

// Get the user data
router.get('/', auth, async (req, res) => {
  try {
    const user = await sequelize.models.User.findByPk(req.user.id);
    res.json({
      id: user.id,
      email: user.email,
      name: user.name,
      token: req.token,
    });
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: e.message });
  }
});

// Update User Details (Height and Weight)
router.put('/user/details', auth, async (req, res) => {
  try {
    const { userId, height, weight, injuries } = req.body;

    if (!userId || !height || !weight) {
      return res.status(400).json({ message: 'User ID, height, and weight are required' });
    }

    const user = await sequelize.models.User.findByPk(userId);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    const injuriesMapped = getAffectedAreas(injuries);

    user.body_details = { height, weight };
    user.injuries = injuriesMapped;
    await user.save();

    res.json({ message: 'User details updated successfully', user });
  } catch (e) {
    console.error('Error updating user details:', e);
    res.status(500).json({ error: e.message });
  }
});

// Update User Workout Preferences
router.put('/user/workout', async (req, res) => {
  try {
    const { userId, workoutDays, workoutRegime } = req.body;

    if (!userId || !workoutDays || !workoutRegime) {
      return res.status(400).json({ message: 'User ID, workout days, and workout regime are required' });
    }

    const user = await sequelize.models.User.findByPk(userId);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    user.workoutDays = workoutDays;
    user.workoutRegimeId = workoutRegime;
    await user.save();

    res.json({ message: 'User workout preferences updated successfully', user });
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: e.message });
  }
});

const getAffectedAreas = (injuries) => {
  let affectedAreas = [];
  injuries.forEach(injury => {
    if (injuryMap[injury]) {
      affectedAreas = [...affectedAreas, ...injuryMap[injury]];
    }
  });
  return affectedAreas;
};

module.exports = router;

