const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { Sequelize } = require('sequelize');
const dbConfig = require('../config/config.json').development;
const authRoutes = require('./routes/auth'); // Import the auth routes

const app = express();
const port = process.env.PORT || 3000; // Ensure the correct environment variable name

app.use(bodyParser.json());
app.use(cors());

// Connect to the database
const sequelize = new Sequelize(dbConfig.database, dbConfig.username, dbConfig.password, {
  host: dbConfig.host,
  dialect: dbConfig.dialect,
  dialectOptions: {
    ssl: {
      require: true,
      rejectUnauthorized: false
    }
  }
});

// Test the database connection
sequelize.authenticate()
  .then(() => {
    console.log('Connection has been established successfully.');
  })
  .catch(err => {
    console.error('Unable to connect to the database:', err);
  });

// Use auth routes
app.use('/api/auth', authRoutes);

// Define API endpoints
app.get('/', (req, res) => {
  res.send('Hello from Node.js!');
});

// Example endpoint to get users
app.get('/api/users', async (req, res) => {
  try {
    const users = await sequelize.models.User.findAll();
    res.json(users);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Start the server
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
