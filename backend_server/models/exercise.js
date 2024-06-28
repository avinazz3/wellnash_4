'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Exercise extends Model {
    static associate(models) {
      Exercise.belongsToMany(models.DailyWorkout, { through: models.WorkoutLog });
    }
  }
  Exercise.init({
    name: DataTypes.STRING,
    description: DataTypes.STRING,
    bodyparts_used: DataTypes.JSON,
    intensity: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'Exercise',
  });
  return Exercise;
};

