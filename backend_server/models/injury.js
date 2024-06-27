'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Injury extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  }
  Injury.init({
    name: DataTypes.STRING,
    description: DataTypes.STRING,
    bodyparts_used: DataTypes.JSON,
    intensity: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'Exercise',
  });
  return Injury;
};
