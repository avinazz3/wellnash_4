'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    await queryInterface.bulkInsert('Injuries', [
      { name: 'Rotator Cuff Tear', description: 'Injury to the shoulder muscles', bodyparts_used: JSON.stringify(['Shoulders']), intensity: 3, createdAt: new Date(), updatedAt: new Date() },
      { name: 'ACL Tear', description: 'Injury to the knee ligament', bodyparts_used: JSON.stringify(['Knees']), intensity: 3, createdAt: new Date(), updatedAt: new Date() },
      { name: 'Tennis Elbow', description: 'Pain in the elbow', bodyparts_used: JSON.stringify(['Elbows']), intensity: 2, createdAt: new Date(), updatedAt: new Date() },
      { name: 'Lower Back Pain', description: 'Pain in the lower back', bodyparts_used: JSON.stringify(['Lower Back']), intensity: 2, createdAt: new Date(), updatedAt: new Date() },
      { name: 'Hamstring Strain', description: 'Injury to the hamstring muscles', bodyparts_used: JSON.stringify(['Hamstrings']), intensity: 2, createdAt: new Date(), updatedAt: new Date() },
      { name: 'Achilles Tendonitis', description: 'Pain in the Achilles tendon', bodyparts_used: JSON.stringify(['Ankles']), intensity: 2, createdAt: new Date(), updatedAt: new Date() },
      { name: 'Shoulder Impingement', description: 'Pain in the shoulder due to impingement', bodyparts_used: JSON.stringify(['Shoulders']), intensity: 2, createdAt: new Date(), updatedAt: new Date() },
      { name: 'Groin Strain', description: 'Injury to the groin muscles', bodyparts_used: JSON.stringify(['Hip']), intensity: 2, createdAt: new Date(), updatedAt: new Date() },
      { name: 'Wrist Sprain', description: 'Injury to the wrist', bodyparts_used: JSON.stringify(['Wrists']), intensity: 2, createdAt: new Date(), updatedAt: new Date() },
      { name: 'Neck Strain', description: 'Pain in the neck muscles', bodyparts_used: JSON.stringify(['Neck']), intensity: 2, createdAt: new Date(), updatedAt: new Date() },
    ], {});
  },

  down: async (queryInterface, Sequelize) => {
    await queryInterface.bulkDelete('Injuries', null, {});
  }
};

