const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { Sequelize } = require('sequelize');
const dbConfig = require('../config/config.json').development;
const authRoutes = require('./routes/auth'); // Import the auth routes

const app = express();
const port = process.env.port || 3000;


app.use(bodyParser.json());
app.use(cors());
app.use(authRoutes); // Use the auth routes

// Connect to the database
const sequelize = new Sequelize(dbConfig.database, dbConfig.username, dbConfig.password, {
  host: dbConfig.host,
  dialect: dbConfig.dialect
});

// Test the database connection
sequelize.authenticate()
  .then(() => {
    console.log('Connection has been established successfully.');
  })
  .catch(err => {
    console.error('Unable to connect to the database:', err);
  });

// Define API endpoints
app.get('/', (req, res) => {
  res.send('Hello from Node.js!');
});

// Use auth routes
app.use('/api/auth', authRoutes);

// Example endpoint to get users
app.get('/api/users', async (req, res) => {
  const users = await sequelize.models.User.findAll();
  res.json(users);
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
