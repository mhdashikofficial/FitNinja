enum TutorialLevel { basic, intermediate, mastery }

class TrainingModule {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String imageUrl;
  final String masterArt; // Discipline background
  final TutorialLevel level;
  final List<String> tips;
  final String masterLore; // Modern realist context
  final int rankPoints;
  bool isMastered;

  TrainingModule({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imageUrl,
    required this.masterArt,
    required this.level,
    required this.tips,
    this.masterLore = "",
    this.rankPoints = 10,
    this.isMastered = false,
  });
}

class TrainingDiscipline {
  final String name;
  final String description;
  final String masterArt;
  final List<TrainingModule> modules;
  final bool isLocked;

  TrainingDiscipline({
    required this.name,
    required this.description,
    required this.masterArt,
    required this.modules,
    this.isLocked = false,
  });
}

// BOXING HEMISPHERE
final List<TrainingDiscipline> boxingDisciplines = [
  TrainingDiscipline(
    name: "IRON STRIKE",
    description: "Pro-Standard Attack Arsenal",
    masterArt: "assets/tutorials/masters/boxing_strike.png",
    modules: [
      TrainingModule(id: "bx1", title: "THE JAB", subtitle: "Basic Strike", level: TutorialLevel.basic, description: "The most vital tool in a fighter's arsenal. Measure distance and disrupt rhythm.", imageUrl: "box_strike", masterArt: "assets/tutorials/masters/boxing_strike.png", tips: ["Snap with the shoulder", "Rotate fist 90 degrees", "Elbows in"], rankPoints: 10),
      TrainingModule(id: "bx2", title: "POWER CROSS", subtitle: "Core Punch", level: TutorialLevel.basic, description: "The rear hand strike. Maximum power through full hip rotation.", imageUrl: "box_strike", masterArt: "assets/tutorials/masters/boxing_strike.png", tips: ["Squash the bug with rear foot", "Exhale on impact", "Keep lead hand up"], rankPoints: 15),
      TrainingModule(id: "bx3", title: "LEAD HOOK", subtitle: "Intermediate Strike", level: TutorialLevel.intermediate, description: "A lateral strike aiming for the chin or liver.", imageUrl: "box_strike", masterArt: "assets/tutorials/masters/boxing_strike.png", tips: ["Pivot lead foot 90 deg", "Horizontal arm angle", "High elbow"], rankPoints: 20),
      TrainingModule(id: "bx4", title: "THE UPPERCUT", subtitle: "Intermediate Strike", level: TutorialLevel.intermediate, description: "Vertical strike to bypass guards.", imageUrl: "box_strike", masterArt: "assets/tutorials/masters/boxing_strike.png", tips: ["Drive from the legs", "Compact motion", "Exhale sharp"], rankPoints: 20),
      TrainingModule(id: "bx5", title: "SHOVEL HOOK", subtitle: "Mastery Strike", level: TutorialLevel.mastery, description: "A hybrid 45-degree angle punch to the body.", imageUrl: "box_strike", masterArt: "assets/tutorials/masters/boxing_strike.png", tips: ["Aim for the ribs", "Explosive torque", "Tight guard"], rankPoints: 40),
      TrainingModule(id: "bx6", title: "OVERHAND RIGHT", subtitle: "Mastery Strike", level: TutorialLevel.mastery, description: "A looping power shot to bypass high guards.", imageUrl: "box_strike", masterArt: "assets/tutorials/masters/boxing_strike.png", tips: ["Loop over the top", "Dodge head to lead side", "Heal weight shift"], rankPoints: 40),
      TrainingModule(id: "bx13", title: "LIVER SHOT", subtitle: "Precision Kill", level: TutorialLevel.mastery, description: "Aiming for the floating ribs to shut down the nervous system.", imageUrl: "box_strike", masterArt: "assets/tutorials/masters/boxing_strike.png", tips: ["Step 45 degrees", "Tight upward hook", "Total exhale"], rankPoints: 50),
      TrainingModule(id: "bx14", title: "THE CHECK HOOK", subtitle: "Defensive Counter", level: TutorialLevel.mastery, description: "Pivoting while punching to stop an aggressive charge.", imageUrl: "box_strike", masterArt: "assets/tutorials/masters/boxing_strike.png", tips: ["Pivot during impact", "Use opponent's momentum", "Step off-line"], rankPoints: 45),
    ],
  ),
  TrainingDiscipline(
    name: "THE SHIELD",
    description: "Multi-layered Defense Systems",
    masterArt: "assets/tutorials/masters/boxing_shield.png",
    modules: [
      TrainingModule(id: "def1", title: "THE SLIP", subtitle: "Basic Defense", level: TutorialLevel.basic, description: "Moving head off-center to let punches pass.", imageUrl: "box_shield", masterArt: "assets/tutorials/masters/boxing_shield.png", tips: ["Micro-movements", "Keep eyes on chest", "Stay balanced"], rankPoints: 15),
      TrainingModule(id: "def2", title: "SHOULDER ROLL", subtitle: "Mastery Defense", level: TutorialLevel.mastery, description: "The hallmark of the Philly Shell. Deflect with the lead shoulder.", imageUrl: "box_shield", masterArt: "assets/tutorials/masters/boxing_shield.png", tips: ["Tuck chin deep", "Rotate core back", "Right hand high guard"], rankPoints: 50),
      TrainingModule(id: "def3", title: "PARRY SYSTEM", subtitle: "Intermediate Defense", level: TutorialLevel.intermediate, description: "Deflecting straight shots with the palm.", imageUrl: "box_shield", masterArt: "assets/tutorials/masters/boxing_shield.png", tips: ["Small push down/in", "Don't reach forward", "Prepare counter"], rankPoints: 25),
      TrainingModule(id: "def4", title: "HIGH GUARD", subtitle: "Basic Defense", level: TutorialLevel.basic, description: "Traditional shell protection.", imageUrl: "box_shield", masterArt: "assets/tutorials/masters/boxing_shield.png", tips: ["Gloves to forehead", "Elbows protect liver", "Peek through gloves"], rankPoints: 10),
      TrainingModule(id: "def15", title: "THE LONG GUARD", subtitle: "Distance Defense", level: TutorialLevel.intermediate, description: "Stiff lead arm to keep opponent at bay.", imageUrl: "box_shield", masterArt: "assets/tutorials/masters/boxing_shield.png", tips: ["Maintain rigid arm", "Measure range constantly", "Ready to cross"], rankPoints: 30),
      TrainingModule(id: "def16", title: "BOB AND WEAVE", subtitle: "Evasive Defense", level: TutorialLevel.intermediate, description: "Ducking under hooks to create inside openings.", imageUrl: "box_shield", masterArt: "assets/tutorials/masters/boxing_shield.png", tips: ["Draw 'U' with head", "Leg drive", "Guard high"], rankPoints: 35),
      TrainingModule(id: "def17", title: "CATCHING", subtitle: "Timing Defense", level: TutorialLevel.basic, description: "Stopping a punch like catching a baseball.", imageUrl: "box_shield", masterArt: "assets/tutorials/masters/boxing_shield.png", tips: ["Palm open", "Brace for impact", "Immediate return"], rankPoints: 15),
    ],
  ),
  TrainingDiscipline(
    name: "GHOST STEP",
    description: "Advanced Angle Management",
    masterArt: "assets/tutorials/masters/footwork.png",
    modules: [
      TrainingModule(id: "ft1", title: "THE PIVOT", subtitle: "Basic Footwork", level: TutorialLevel.basic, description: "Changing angle while staying in pocket.", imageUrl: "box_foot", masterArt: "assets/tutorials/masters/footwork.png", tips: ["Pivot on ball of foot", "Keep weight centered", "Face opponent immediately"], rankPoints: 15),
      TrainingModule(id: "ft2", title: "LATERAL SHIFT", subtitle: "Mastery Footwork", level: TutorialLevel.mastery, description: "Moving the whole body to a new line of fire.", imageUrl: "box_foot", masterArt: "assets/tutorials/masters/footwork.png", tips: ["Step offline abruptly", "Set feet for counter", "Ghostly fluidity"], rankPoints: 45),
      TrainingModule(id: "ft18", title: "SHUFFLING", subtitle: "Speed Footwork", level: TutorialLevel.intermediate, description: "High-speed positional adjustments.", imageUrl: "box_foot", masterArt: "assets/tutorials/masters/footwork.png", tips: ["Balls of feet", "Short bursts", "Stay light"], rankPoints: 20),
      TrainingModule(id: "ft19", title: "CUTTING ANGLES", subtitle: "Tactical Footwork", level: TutorialLevel.mastery, description: "Forcing opponent into corners using geometry.", imageUrl: "box_foot", masterArt: "assets/tutorials/masters/footwork.png", tips: ["Herding motion", "Stay on offensive", "Watch exit roots"], rankPoints: 50),
    ],
  ),
];

// NINJA HEMISPHERE
final List<TrainingDiscipline> ninjaDisciplines = [
  TrainingDiscipline(
    name: "URBAN STEALTH",
    description: "Modern Infiltration & Ghosting",
    masterArt: "assets/tutorials/masters/ninja_stealth.png",
    isLocked: true,
    modules: [
      TrainingModule(id: "st1", title: "ZERO-NOISE STRIDE", subtitle: "Modern Nuki-Ashi", level: TutorialLevel.basic, description: "Silent movement in sneakers on concrete.", masterLore: "In the modern age, sounds bounce off glass and steel. Nuki-Ashi focus on rubber-sole suppression.", imageUrl: "ninja_st", masterArt: "assets/tutorials/masters/ninja_stealth.png", tips: ["Touch toes first on hard ground", "Sink hips to absorb shock", "Weight shift in silence"], rankPoints: 30),
      TrainingModule(id: "st2", title: "REFLECTIVE GEOMETRY", subtitle: "Mastery Stealth", level: TutorialLevel.mastery, description: "Navigating urban glass and reflective surfaces.", masterLore: "Mirrored buildings are a modern ninja's enemy. Positioning determines visibility.", imageUrl: "ninja_st", masterArt: "assets/tutorials/masters/ninja_stealth.png", tips: ["Calculate reflection angles", "Move in sync with light shifts", "Deep corner management"], rankPoints: 60),
      TrainingModule(id: "st20", title: "LIGHT DYNAMICS", subtitle: "Shadow Tech", level: TutorialLevel.intermediate, description: "Using modern LED environment to vanish.", masterLore: "Flickering streetlights and neon create 'blind spots' in human peripheral vision.", imageUrl: "ninja_st", masterArt: "assets/tutorials/masters/ninja_stealth.png", tips: ["Sync movement with light cycles", "Stay in high-contrast zones", "Watch back-lighting"], rankPoints: 40),
      TrainingModule(id: "st21", title: "GEAR SUPPRESSION", subtitle: "Tactical Stealth", level: TutorialLevel.basic, description: "Silencing zippers, keys, and phone noise.", masterLore: "A 21st-century shinobi must eliminate the jingle of technology.", imageUrl: "ninja_st", masterArt: "assets/tutorials/masters/ninja_stealth.png", tips: ["Taped zippers", "Silent mode logic", "No-rub fabric choice"], rankPoints: 25),
    ],
  ),
  TrainingDiscipline(
    name: "TACTICAL FLOW",
    description: "Extreme Agility & Escape Physics",
    masterArt: "assets/tutorials/masters/ninja_agility.png",
    isLocked: true,
    modules: [
      TrainingModule(id: "ag1", title: "KINETIC ROLL", subtitle: "Adaptable Kaiten", level: TutorialLevel.basic, description: "Redirecting downward momentum into forward motion on concrete.", imageUrl: "ninja_ag", masterArt: "assets/tutorials/masters/ninja_agility.png", tips: ["Roll over the meaty shoulder", "Chin to chest", "Spring out to sprint"], rankPoints: 20),
      TrainingModule(id: "ag2", title: "RAPID ASCENT", subtitle: "Wall Navigation", level: TutorialLevel.intermediate, description: "Practical vertical movement to bypass ground-level threats.", imageUrl: "ninja_ag", masterArt: "assets/tutorials/masters/ninja_agility.png", tips: ["Run the wall, don't jump it", "Grip strength essentials", "Exhale on reach"], rankPoints: 35),
      TrainingModule(id: "ag22", title: "GHOST LANDING", subtitle: "Impact Physics", level: TutorialLevel.mastery, description: "Silent landings from 10ft+ without injury.", masterLore: "Using the entire leg structure as a biological piston to dissipate sound 100%.", imageUrl: "ninja_ag", masterArt: "assets/tutorials/masters/ninja_agility.png", tips: ["Toes to heels transition", "Sink into deep squat", "Absorb with breath"], rankPoints: 55),
      TrainingModule(id: "ag23", title: "VAULTING", subtitle: "Urban Agility", level: TutorialLevel.basic, description: "Crossing barriers without losing momentum.", imageUrl: "ninja_ag", masterArt: "assets/tutorials/masters/ninja_agility.png", tips: ["One hand plant", "Foot-through motion", "Eyes on landing"], rankPoints: 15),
    ],
  ),
  TrainingDiscipline(
    name: "INNER FLAME",
    description: "Operator-Standard Neural Management",
    masterArt: "assets/tutorials/masters/ninja_spirit.png",
    isLocked: true,
    modules: [
      TrainingModule(id: "sp1", title: "NEURAL OVERCLOCK", subtitle: "Kuji-Kiri Focus", level: TutorialLevel.mastery, description: "Using hand mudras to trigger specific neural pathways.", masterLore: "Traditional symbols are mapped to modern adrenal control for zero-hesitation action.", imageUrl: "ninja_sp", masterArt: "assets/tutorials/masters/ninja_spirit.png", tips: ["Apply pressure to nerve points", "Complete mental clarity", "Command the heartbeat"], rankPoints: 70),
      TrainingModule(id: "sp2", title: "STRESS BOX BREATHING", subtitle: "Operator Breath", level: TutorialLevel.basic, description: "The elite method for lowering heart rate in 12 seconds.", imageUrl: "ninja_sp", masterArt: "assets/tutorials/masters/ninja_spirit.png", tips: ["4sec In, 4sec Hold, 4sec Out, 4sec Hold", "Focus on the counting", "Stay perfectly still"], rankPoints: 20),
      TrainingModule(id: "sp24", title: "COLD RESILIENCE", subtitle: "Body Heat Mastery", level: TutorialLevel.intermediate, description: "Maintaining core temp through focused circulation.", masterLore: "Thermal management is vital for long-term stealth in modern urban winters.", imageUrl: "ninja_sp", masterArt: "assets/tutorials/masters/ninja_spirit.png", tips: ["Focus on solar plexus", "Vaso-dilation visualization", "Controlled shivering"], rankPoints: 45),
    ],
  ),
  TrainingDiscipline(
    name: "MIND HACK",
    description: "Modern Genjutsu & Social PsyOps",
    masterArt: "assets/tutorials/masters/ninja_tactics.png",
    isLocked: true,
    modules: [
      TrainingModule(id: "gen1", title: "PATTERN INTERRUPT", subtitle: "Psychological Genjutsu", level: TutorialLevel.mastery, description: "Breaking an aggressor's neural loop.", masterLore: "A 'glitch' in expectation provides the ultimate tactical advantage.", imageUrl: "ninja_tx", masterArt: "assets/tutorials/masters/ninja_tactics.png", tips: ["Do the unimaginable", "Maintain total composure", "Exploit the 3sec delay"], rankPoints: 100),
      TrainingModule(id: "gen2", title: "NEURAL DAZZLING", subtitle: "Tactical Misdirection", level: TutorialLevel.intermediate, description: "Using high-intensity light pulses to disorient.", imageUrl: "ninja_tx", masterArt: "assets/tutorials/masters/ninja_tactics.png", tips: ["Pulse, don't constant beam", "Move immediately after flash", "Strobe for disorientation"], rankPoints: 50),
      TrainingModule(id: "gen25", title: "CONFIDENCE MIMICRY", subtitle: "Social Engineering", level: TutorialLevel.mastery, description: "Passing through unauthorized zones via pure body language.", masterLore: "If you look like you belong, 90% of security won't even notice you.", imageUrl: "ninja_tx", masterArt: "assets/tutorials/masters/ninja_tactics.png", tips: ["Zero hesitation", "Visual anchoring", "Matching the vibe"], rankPoints: 80),
    ],
  ),
];
