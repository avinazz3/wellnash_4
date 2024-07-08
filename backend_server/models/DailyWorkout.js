'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class DailyWorkout extends Model {
    static associate(models) {
      DailyWorkout.belongsToMany(models.Exercise, { through: models.WorkoutLog });
      DailyWorkout.belongsTo(models.WorkoutLog, { foreignKey: 'dailyWorkoutId' });
    }
  }
  DailyWorkout.init({
    userId: DataTypes.INTEGER,
    date: DataTypes.DATEONLY,
  }, {
    sequelize,
    modelName: 'DailyWorkout',
  });
  return DailyWorkout;
};

