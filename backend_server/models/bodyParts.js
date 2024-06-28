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
      this.belongsTo(models.Injury, { foreignKey: 'injuryId', as: 'injury' });
    }
  }
  BodyPart.init({
    name: DataTypes.STRING,
    intensity: DataTypes.INTEGER,
    type: DataTypes.ENUM('muscle', 'joint', 'bone'),
    injuryId: DataTypes.INTEGER  // This is the foreign key for the association
  }, {
    sequelize,
    modelName: 'BodyPart',
  });
  return BodyPart;
};



