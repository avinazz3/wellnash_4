'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class WorkoutLog extends Model {
    static associate(models) {
      WorkoutLog.hasMany(models.DailyWorkout, { foreignKey: 'dailyWorkoutId' });
      WorkoutLog.belongsToMany(models.User, { foreignKey: 'userId' });
    }
  }
  WorkoutLog.init({
    dailyWorkoutId: DataTypes.INTEGER,
    exerciseId: DataTypes.INTEGER,
    sets: DataTypes.JSON, // [{ setNumber: 1, kg: 32.5, reps: 6 }, ...]
  }, {
    sequelize,
    modelName: 'WorkoutLog',
  });
  return WorkoutLog;
};
