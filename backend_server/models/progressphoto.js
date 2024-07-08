'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class ProgressPhoto extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      ProgressPhoto.belongsTo(models.User, { foreignKey: 'user_id' });
    }
  }
  ProgressPhoto.init({
    user_id: DataTypes.INTEGER,
    photo_url: DataTypes.STRING,
    date: DataTypes.DATE
  }, {
    sequelize,
    modelName: 'ProgressPhoto',
  });
  return ProgressPhoto;
};