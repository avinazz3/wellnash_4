'use strict';
const {
  Model
} = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  class BodyPart extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  }
  BodyPart.init({
    name: DataTypes.STRING,
    intensity: DataTypes.INTEGER,
    type: DataTypes.ENUM('muscle', 'joint', 'bone'),
  }, {
    sequelize,
    modelName: 'BodyPart',
  });
  return BodyPart;
};



