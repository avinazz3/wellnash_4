'use strict';
const { Model } = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class WorkoutRegime extends Model {
    static associate(models) {
      WorkoutRegime.hasMany(models.User, { foreignKey: 'workoutRegimeId' });
    }
  }
  WorkoutRegime.init({
    name: DataTypes.STRING,
    description: DataTypes.STRING,
    rules: DataTypes.JSON
  }, {
    sequelize,
    modelName: 'WorkoutRegime',
  });
  return WorkoutRegime;
};
