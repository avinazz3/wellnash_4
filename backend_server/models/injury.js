'use strict';
const {
  Model
} = require('sequelize');
const BodyPart = require('./models/bodyparts');
module.exports = (sequelize, DataTypes) => {
  class Injury extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
        this.hasMany(models.BodyPart, { foreignKey: 'injuryId', as: 'bodypartsUsed' });
    }
  }
  Injury.init({
    name: DataTypes.STRING,
    description: DataTypes.STRING,
    intensity: DataTypes.INTEGER
  }, {
    sequelize,
    modelName: 'Injury',
  });
  return Injury;
};
