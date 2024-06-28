'use strict';

const { Injury } = require('./models/injury');

const injuryData = [
  {
    name: "Tennis Elbow",
    description: "A condition that causes pain around the outside of the elbow.",
    bodyparts_used: [
      { name: "Elbow", intensity: 4, type: "joint" },
      { name: "Forearm", intensity: 3, type: "muscle" }
    ],
    intensity: 4
  },
  {
    name: "Hip Flexor Strain",
    description: "An injury to the muscles in the hip flexor group.",
    bodyparts_used: [
      { name: "Hip Flexors", intensity: 3, type: "muscle" },
      { name: "Hip", intensity: 3, type: "joint" }
    ],
    intensity: 3
  },
  {
    name: "Wrist Sprain",
    description: "An injury to the ligaments in the wrist.",
    bodyparts_used: [
      { name: "Wrist", intensity: 4, type: "joint" },
      { name: "Forearm", intensity: 2, type: "muscle" }
    ],
    intensity: 3
  },
  {
    name: "Ankle Sprain",
    description: "An injury to the ligaments in the ankle.",
    bodyparts_used: [
      { name: "Ankle", intensity: 4, type: "joint" },
      { name: "Calves", intensity: 2, type: "muscle" }
    ],
    intensity: 4
  },
  {
    name: "Shin Splints",
    description: "Pain along the shin bone (tibia).",
    bodyparts_used: [
      { name: "Shin", intensity: 3, type: "bone" },
      { name: "Calves", intensity: 2, type: "muscle" }
    ],
    intensity: 2
  },
  {
    name: "Back Pain",
    description: "Pain felt in the back.",
    bodyparts_used: [
      { name: "Lower Back", intensity: 5, type: "joint" },
      { name: "Erector Spinae", intensity: 3, type: "muscle" }
    ],
    intensity: 5
  },
  {
    name: "Groin Pull",
    description: "A tear or rupture of one or more of the adductor muscles.",
    bodyparts_used: [
      { name: "Groin", intensity: 4, type: "muscle" },
      { name: "Hip Flexors", intensity: 2, type: "muscle" }
    ],
    intensity: 3
  },
  {
    name: "Dislocated Shoulder",
    description: "When the upper arm bone pops out of the shoulder blade socket.",
    bodyparts_used: [
      { name: "Shoulder", intensity: 5, type: "joint" },
      { name: "Deltoids", intensity: 3, type: "muscle" }
    ],
    intensity: 5
  },
  {
    name: "Achilles Sprain",
    description: "An injury to the Achilles tendon.",
    bodyparts_used: [
      { name: "Achilles Tendon", intensity: 4, type: "muscle" },
      { name: "Calves", intensity: 3, type: "muscle" }
    ],
    intensity: 4
  },
  {
    name: "Neck Sprain",
    description: "An injury to the ligaments in the neck.",
    bodyparts_used: [
      { name: "Neck", intensity: 4, type: "joint" },
      { name: "Trapezius", intensity: 3, type: "muscle" }
    ],
    intensity: 3
  },
  {
    name: "Hamstring Sprain",
    description: "A strain or tear to the tendons or large muscles at the back of the thigh.",
    bodyparts_used: [
      { name: "Hamstrings", intensity: 4, type: "muscle" },
      { name: "Gluteus Maximus", intensity: 2, type: "muscle" }
    ],
    intensity: 3
  },
  {
    name: "Broken Leg",
    description: "A break or crack in one of the bones in the leg.",
    bodyparts_used: [
      { name: "Leg", intensity: 5, type: "bone" },
      { name: "Knee", intensity: 2, type: "joint" }
    ],
    intensity: 5
  },
  {
    name: "Broken Arm",
    description: "A break or crack in one of the bones in the arm.",
    bodyparts_used: [
      { name: "Arm", intensity: 5, type: "bone" },
      { name: "Elbow", intensity: 2, type: "joint" }
    ],
    intensity: 5
  },
  {
    name: "ACL Tear",
    description: "A tear or sprain of the anterior cruciate ligament in the knee.",
    bodyparts_used: [
      { name: "Knee", intensity: 5, type: "joint" },
      { name: "Quadriceps", intensity: 3, type: "muscle" }
    ],
    intensity: 5
  },
  {
    name: "Slip Disc",
    description: "A condition where the outer portion of the vertebral disc is torn.",
    bodyparts_used: [
      { name: "Spine", intensity: 5, type: "bone" },
      { name: "Lower Back", intensity: 4, type: "joint" }
    ],
    intensity: 5
  }
];

/**
 * Finds an injury object by its name.
 * @param {string} injuryName - The name of the injury to find.
 * @returns {Object|null} The injury object if found, or null if not found.
 */
function getInjury(injuryName) {
    const injury = injuryData.find(inj => inj.name === injuryName);
    return injury || null;
}
module.exports = injuryData;

  