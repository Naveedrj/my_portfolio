class ProjectModel {
  final String title;
  final String description;
  final List<String> techStack;
  final List<String> images;
  final String? playStoreLink;
  final String? appStoreLink;
  final String? webLink; // NEW: Added web link field
  final String? badge;
  final bool isWeb;

  const ProjectModel({
    required this.title,
    required this.description,
    required this.techStack,
    required this.images,
    this.playStoreLink,
    this.appStoreLink,
    this.webLink, // Initialize the new field
    this.badge,
    this.isWeb = false,
  });
}

const List<ProjectModel> portfolioData = [
  ProjectModel(
    title: "Gloria Jean’s KSA",
    description: "Bilingual coffee ordering app with loyalty rewards for the Saudi market.",
    techStack: ["Flutter", "Dart", "Node.js", "Rest API", "Google Maps"],
    images: [
      "assets/gloria/g1.png",
      "assets/gloria/g2.png",
      "assets/gloria/g3.png",
      "assets/gloria/g4.png",
      "assets/gloria/g5.png",
      "assets/gloria/g6.png",
      "assets/gloria/g7.png",
    ],
    playStoreLink: "https://play.google.com/store/apps/details?id=com.gloriajeansksa.app&hl=en",
    appStoreLink: "https://apps.apple.com/pk/app/gloria-jeans-ksa/id6744279411",
    badge: "Live on stores",
  ),
  ProjectModel(
    title: "Fvture",
    description:
    "Book exclusive tables at Asia’s largest club in Bangkok. Skip the wait and own the night with seamless reservations.",
    techStack: ["Flutter", "Node.js" , "Firebase"],
    images: [
      "assets/fvture/f4.png",
      "assets/fvture/f5.png",
      "assets/fvture/f3.png",
      "assets/fvture/f2.png",
      "assets/fvture/f1.png",
      "assets/fvture/f6.png",
      "assets/fvture/f7.png",
    ],
    playStoreLink: "https://play.google.com/store/apps/details?id=com.icode.fvture&hl=en",
    appStoreLink: "https://apps.apple.com/pk/app/fvture/id6755243613",
    badge: "Live on stores",
  ),
  ProjectModel(
      title: "Pozemek",
      description:
      "A Flutter web application for efficiently managing and listing rental properties, connecting landlords and tenants.",
      techStack: ["Flutter", "Firebase"],
      images: [
        "assets/poz/poz1.jpeg",
        "assets/poz/poz2.jpeg",
        "assets/poz/poz3.jpeg",
        "assets/poz/poz4.jpeg",
        "assets/poz/poz5.jpeg",
        "assets/poz/poz6.jpeg",
      ],
      playStoreLink: null,
      appStoreLink: null,
      webLink: "https://domovka.com/home", // Example web link added
      isWeb: true
  ),
  ProjectModel(
    title: "Darkpino",
    description:
    "A Web3 crypto fitness application that rewards your movement. Track your daily steps, stay active, and walk to earn Dpino tokens.",
    techStack: ["Flutter", "Firebase", "Health SDKs", "Web3"],
    images: [
      "assets/dp/dp1.jpeg",
      "assets/dp/dp2.jpeg",
      "assets/dp/dp3.jpeg",
      "assets/dp/dp4.jpeg",
      "assets/dp/dp5.jpeg",
      "assets/dp/dp6.jpeg",
    ],
    playStoreLink: null,
    appStoreLink: null,
    badge: "Walk-to-Earn",
  ),

  // ProjectModel(
  //   title: "Service Provider",
  //   description:
  //   "Platform to hire experts for your tasks, and track their progress.",
  //   techStack: ["Flutter", "Supabase", "Stripe"],
  //   images: [
  //     "assets/sp/sp1.png",
  //     "assets/sp/sp2.png",
  //     "assets/sp/sp3.png",
  //     "assets/sp/sp4.png",
  //     "assets/sp/sp5.png",
  //     "assets/sp/sp6.png",
  //     "assets/sp/sp7.png",
  //   ],
  //   playStoreLink: null,
  //   appStoreLink: null,
  // ),

  ProjectModel(
    title: "Music Plugg",
    description:
    "Upload, manage, and stream your music all in one place. Music Plugg is your personal hub for sharing your sound with the world.",
    techStack: ["Flutter", "Python", "TensorFlow", "Firebase"],
    images: [
      "assets/music/m1.png",
      "assets/music/m2.png",
      "assets/music/m3.png",
      "assets/music/m4.png",
      "assets/music/m5.png",
      "assets/music/m6.png",
      "assets/music/m7.png",
      "assets/music/m8.png",
      "assets/music/m9.png",
    ],
    playStoreLink: null,
    appStoreLink: null,
    badge: "Music platform",
  ),

  ProjectModel(
    title: "ChatBox AI",
    description:
    "Multi-persona AI chat app integrating various LLMs for specialized assistance.",
    techStack: ["Flutter", "OpenAI API", "Firebase"],
    images: [
      "assets/chatboxai/c1.png",
      "assets/chatboxai/c2.png",
      "assets/chatboxai/c3.png",
      "assets/chatboxai/c4.png",
      "assets/chatboxai/c5.png",
    ],
    playStoreLink: null,
    appStoreLink: null,
  ),
  ProjectModel(
    title: "Pilatix",
    description:
    "Workout app to track daily workouts and calories burned. "
        "Exercises and routines are managed via an admin dashboard for seamless updates.",
    techStack: ["Flutter", "Firebase"],
    images: [
      "assets/pilatix/pl1.png",
      "assets/pilatix/pl2.png",
      "assets/pilatix/pl3.png",
      "assets/pilatix/pl4.png",
      "assets/pilatix/pl5.png",
      "assets/pilatix/pl6.png",
      "assets/pilatix/pl7.png",
    ],
    playStoreLink: null,
    appStoreLink: null,
  ),
  ProjectModel(
    title: "Task Runner",
    description:
    "Two-sided marketplace for hiring verified taskers with real-time tracking.",
    techStack: ["Flutter", "Node.js", "MongoDB", "Stripe"],
    images: [
      "assets/taskrunner/t1.jpeg",
      "assets/taskrunner/t2.jpeg",
      "assets/taskrunner/t3.jpeg",
      "assets/taskrunner/t4.jpeg",
      "assets/taskrunner/t5.jpeg",
      "assets/taskrunner/t6.jpeg",
      "assets/taskrunner/t7.jpeg",
    ],
    playStoreLink: "https://play.google.com/store/apps/details?id=com.taskrunner.app&hl=en",
    appStoreLink: null,
    badge: "Live on Playstore"
  ),
];