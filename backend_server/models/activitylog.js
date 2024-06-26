'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class ActivityLog extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  }
  ActivityLog.init({
    user_id: DataTypes.INTEGER,
    workout_id: DataTypes.INTEGER,
    exercise_id: DataTypes.INTEGER,
    weight: DataTypes.FLOAT,
    reps: DataTypes.INTEGER,
    sets: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'ActivityLog',
  });
  return ActivityLog;
};