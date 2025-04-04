import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  _ProjectsSectionState createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  int? selectedIndex; // Track which project is selected

  final List<Map<String, String>> projects = [
    {
      "name": "TaskRunner",
      "description": "A Canadian app for hiring Taskers for house chores.",
      "details": "Built with Flutter, APIs, and Stripe for payments. Managed state using Provider. A dedicated Tasker model exists for the Tasker-side app."
    },
    {
      "name": "Tasker Side",
      "description": "Task management system for Taskers.",
      "details": "Same tech stack as TaskRunner, except without Stripe integration. Taskers manage and complete tasks efficiently."
    },
    {
      "name": "Gloria Jeans",
      "description": "A Riyadh-based app managing coffee stores.",
      "details": "Flutter app for store management, order handling, loyalty points, and special combo offers."
    },
    {
      "name": "ChatBox AI",
      "description": "An AI-powered chatbot application.",
      "details": "Uses Firebase and APIs to provide multiple AI personalities for engaging and dynamic conversations."
    },
    {
      "name": "Peacock Groups",
      "description": "A complete industrial management system.",
      "details": "Manages industries, distributors, shops, order takers, and riders with real-time reporting and tracking."
    },
    {
      "name": "Powernity",
      "description": "An IoT-based smart energy app.",
      "details": "Integrates with Tuya SDK to control registered electrical appliances. Provides remote monitoring and automation."
    },
    {
      "name": "E-Architect",
      "description": "An AI deep learning-based app used to create floor plans by taking measurements from the user in text format.",
      "details": "Utilizes deep learning algorithms to generate accurate floor plans based on user-inputted measurements, aiding architects and designers in planning layouts."
    },
    {
      "name": "Digital Galla Mandi",
      "description": "Flutter apps for farmers, guiding them with best practices, precautionary measures, and managing the buying and selling of crops and agricultural tools.",
      "details": "Offers a platform for farmers to track crop sales, get advice on agricultural practices, and access the market for buying and selling tools and resources."
    },
    {
      "name": "FitTrack",
      "description": "A fitness tracking app that helps users track their workouts, diet, and health metrics.",
      "details": "Built with Flutter, it integrates with wearable devices to track workout progress, set fitness goals, and maintain a balanced diet."
    },
    {
      "name": "CityExplorer",
      "description": "A travel app that helps users explore local attractions and hidden gems in different cities.",
      "details": "Uses geolocation and API services to recommend nearby tourist spots, restaurants, and events, enhancing travel experiences."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800; // Mobile breakpoint

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              runSpacing: 20,
              children: projects.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, String> project = entry.value;
                return _buildProjectCard(
                    index,
                    project["name"]!,
                    project["description"]!,
                    project["details"]!,
                    isMobile
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProjectCard(int index, String title, String description, String details, bool isMobile) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = isSelected ? null : index; // Toggle selection
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: isMobile ? double.infinity : 300,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF052139),
          border: Border.all(color: Colors.white12, width: 1),
          gradient: isSelected
              ? const LinearGradient(
            colors: [Color(0xFF7B8AFD), Color(0xFF7B8AFD)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
            ),
            if (isSelected) ...[
              const SizedBox(height: 12),
              AnimatedOpacity(
                opacity: isSelected ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Text(
                  details,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final String driveUrl = "https://drive.google.com/drive/folders/110DhW6fFCfIxX6hKuBjiLKxVHTJKIgLx?usp=drive_link";
                      final Uri url = Uri.parse(driveUrl);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      } else {
                        throw 'Could not launch $driveUrl';
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "See UI",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Code to handle accessing project code
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Access Code",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
