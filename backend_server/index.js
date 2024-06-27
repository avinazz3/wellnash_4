const Exercise = require('./models/exercise');
const BodyPart = require('./models/bodyParts');

(async () => {
  await sequelize.sync({ force: true }); // Recreate tables for demonstration purposes

  const exercise = await Exercise.create({
    name: 'Squat',
    description: 'A lower body exercise.',
    bodyparts_used: {
      muscles: [
        { name: 'Quadriceps', intensity: 4, type: 'muscle' },
        { name: 'Hamstrings', intensity: 3, type: 'muscle' },
        { name: 'Gluteus Maximus', intensity: 5, type: 'muscle' },
      ],
      joints: [
        { name: 'Knee', intensity: 4, type: 'joint' },
        { name: 'Hip', intensity: 3, type: 'joint' },
      ],
      bones: [
        { name: 'Femur', intensity: 2, type: 'bone' },
        { name: 'Patella', intensity: 2, type: 'bone' },
      ],
    },
    intensity: 5,
  });

  console.log(exercise.toJSON());
})();