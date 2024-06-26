'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('Users', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      email: {
        type: Sequelize.STRING
      },
      name: {
        type: Sequelize.STRING
      },
      profile_picture_url: {
        type: Sequelize.STRING
      },
      oauth_provider: {
        type: Sequelize.STRING
      },
      body_details: {
        type: Sequelize.JSON
      },
      goals: {
        type: Sequelize.STRING
      },
      workout_days: {
        type: Sequelize.JSON
      },
      workout_regime_id: {
        type: Sequelize.INTEGER
      },
      current_workout_plan_id: {
        type: Sequelize.INTEGER
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE
      }
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('Users');
  }
};