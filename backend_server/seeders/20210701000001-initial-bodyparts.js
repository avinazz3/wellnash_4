'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.bulkInsert('BodyParts', [
      { name: 'Biceps', type: 'muscle', createdAt: new Date(), updatedAt: new Date() },
      { name: 'Triceps', type: 'muscle', createdAt: new Date(), updatedAt: new Date() },
      { name: 'Deltoids', type: 'muscle', createdAt: new Date(), updatedAt: new Date() },
      { name: 'Quadriceps', type: 'muscle', createdAt: new Date(), updatedAt: new Date() },
      { name: 'Hamstrings', type: 'muscle', createdAt: new Date(), updatedAt: new Date() },
      { name: 'Glutes', type: 'muscle', createdAt: new Date(), updatedAt: new Date() },
      { name: 'Calves', type: 'muscle', createdAt: new Date(), updatedAt: new Date() },
      { name: 'Lower Back', type: 'muscle', createdAt: new Date(), updatedAt: new Date() },
      { name: 'Upper Back', type: 'muscle', createdAt: new Date(), updatedAt: new Date() },
      { name: 'Abdominals', type: 'muscle', createdAt: new Date(), updatedAt: new Date() },
      { name: 'Chest', type: 'muscle', createdAt: new Date(), updatedAt: new Date() },
      { name: 'Shoulders', type: 'muscle', createdAt: new Date(), updatedAt: new Date() },
      { name: 'Neck', type: 'muscle', createdAt: new Date(), updatedAt: new Date() },
      { name: 'Elbows', type: 'joint', createdAt: new Date(), updatedAt: new Date() },
      { name: 'Knees', type: 'joint', createdAt: new Date(), updatedAt: new Date() },
      { name: 'Ankles', type: 'joint', createdAt: new Date(), updatedAt: new Date() },
      { name: 'Wrists', type: 'joint', createdAt: new Date(), updatedAt: new Date() },
      { name: 'Hip', type: 'joint', createdAt: new Date(), updatedAt: new Date() },
      { name: 'Spine', type: 'bone', createdAt: new Date(), updatedAt: new Date() },
      { name: 'Pelvis', type: 'bone', createdAt: new Date(), updatedAt: new Date() },
    ], {});
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.bulkDelete('BodyParts', null, {});
  }
};
