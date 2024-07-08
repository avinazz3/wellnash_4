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
      BodyPart.belongsToMany(models.Exercise, { through: 'ExerciseBodyPart' });
      BodyPart.belongsToMany(models.Injury, { through: 'InjuryBodyPart' });
    }
  }
  BodyPart.init({
    name: DataTypes.STRING,
    type: DataTypes.ENUM('muscle', 'joint', 'bone'),
  }, {
    sequelize,
    modelName: 'BodyPart',
  });
  return BodyPart;
};



