'use strict';
const { Model } = require('sequelize');
const bcrypt = require('bcrypt');

module.exports = (sequelize, DataTypes) => {
  class User extends Model {
    static associate(models) {
      // define association here
    }
  }

  User.init({
    email: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
      validate: {
        isEmail: true
      }
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false
    },
    password: {
      type: DataTypes.STRING,
      allowNull: false
    },
    profile_picture_url: DataTypes.STRING,
    oauth_provider: DataTypes.STRING,
    body_details: DataTypes.JSON,
    injuries: DataTypes.JSON,
    goals: DataTypes.STRING,
    workout_days: DataTypes.INTEGER,
    workout_regime_id: DataTypes.INTEGER,
    current_workout_plan_id: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'User',
  });

  return User;
};
