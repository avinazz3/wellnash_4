'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class WorkoutLog extends Model {
    static associate(models) {
      WorkoutLog.belongsTo(models.DailyWorkout, { foreignKey: 'dailyWorkoutId' });
      WorkoutLog.belongsTo(models.Exercise, { foreignKey: 'exerciseId' });
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
