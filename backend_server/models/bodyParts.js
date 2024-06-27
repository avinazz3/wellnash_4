const { DataTypes, Model } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
class BodyPart extends Model {}

BodyPart.init({
  name: DataTypes.STRING,
  intensity: DataTypes.INTEGER,
  type: DataTypes.ENUM('muscle', 'joint', 'bone'),
}, {
  sequelize,
  modelName: 'bodypart',
});erc

module.exports = BodyPart;
};


