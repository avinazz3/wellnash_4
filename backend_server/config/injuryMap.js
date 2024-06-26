const injuryMap = {
    "Knee Injury": ["knee", "quadriceps", "hamstrings"],
    "Shoulder Injury": ["shoulder", "deltoids", "pectorals"],
    // Add more injuries and affected joints/muscles as needed
  };
  
  const getAffectedAreas = (injuries) => {
    let affectedAreas = [];
    injuries.forEach(injury => {
      if (injuryMap[injury]) {
        affectedAreas = [...affectedAreas, ...injuryMap[injury]];
      }
    });
    return affectedAreas;
  };
  
  module.exports = injuryMap;
  