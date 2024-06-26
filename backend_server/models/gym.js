
'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Gym extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  }
  Gym.init({
    name: DataTypes.STRING,
    location: DataTypes.STRING,
    equipment: DataTypes.JSON,
    admin_id: DataTypes.INTEGER,
    is_public: DataTypes.BOOLEAN
  }, {
    sequelize,
    modelName: 'Gym',
  });
  return Gym;
};