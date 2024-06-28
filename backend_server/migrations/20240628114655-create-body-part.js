'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    console.log("Starting migration to create BodyParts table");

    await queryInterface.createTable('BodyParts', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      name: {
        type: Sequelize.STRING
      },
      intensity: {
        type: Sequelize.INTEGER
      },
      type: {
        type: Sequelize.ENUM('muscle', 'joint', 'bone')
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE,
        defaultValue: Sequelize.fn('now')  // Use the now() function for the default value
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE,
        defaultValue: Sequelize.fn('now')  // Use the now() function for the default value
      }      
    });

    console.log("BodyParts table created successfully");

    // Any additional operations such as adding indexes can also be logged
    // console.log("Creating index on the name column of the BodyParts table");
    // await queryInterface.addIndex('BodyParts', ['name']);
  },
  down: async (queryInterface, Sequelize) => {
    console.log("Starting migration to drop BodyParts table");

    await queryInterface.dropTable('BodyParts');

    console.log("BodyParts table dropped successfully");
  }
};

