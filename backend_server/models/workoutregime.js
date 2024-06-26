'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class WorkoutRegime extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  }
  WorkoutRegime.init({
    name: DataTypes.STRING,
    description: DataTypes.STRING,
    weekly_volume: DataTypes.JSON,
    rules: DataTypes.JSON
  }, {
    sequelize,
    modelName: 'WorkoutRegime',
  });
  return WorkoutRegime;
};