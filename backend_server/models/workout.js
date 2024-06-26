'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Workout extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  }
  Workout.init({
    user_id: DataTypes.INTEGER,
    duration: DataTypes.INTEGER,
    date: DataTypes.DATE,
    exercises: DataTypes.JSON
  }, {
    sequelize,
    modelName: 'Workout',
  });
  return Workout;
};