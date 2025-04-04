import 'package:flutter/material.dart';
import 'package:web_portfolio/widgets/contact_section.dart';
import 'package:web_portfolio/widgets/intro_section.dart';
import 'package:web_portfolio/widgets/projects_sections.dart';
import 'package:web_portfolio/widgets/skill_section.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 800; // Mobile breakpoint

    return Scaffold(
      backgroundColor: Color(0xFF052139), // Background color
      body: Row(
        children: [
          // Left Sidebar (visible only on larger screens)
          if (!isMobile)
            Container(
              width: 250,
              color: Color(0xFF052139), // Sidebar background color
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50),
                  _buildSidebarLink("Projects"),
                  _buildSidebarLink("Skills"),
                  _buildSidebarLink("About Us"),
                  _buildSidebarLink("Contact"),
                ],
              ),
            ),
          // Main Content Area
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Intro Section
                    IntroSection(),
                    const SizedBox(height: 20),
                    // Skills Section
                    SkillSection(),
                    const SizedBox(height: 20),
                    // Projects Section
                    ProjectsSection(),
                    const SizedBox(height: 20),
                    // Contact Section
                    ContactSection(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to create sidebar links
  Widget _buildSidebarLink(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: GestureDetector(
        onTap: () {
          // Handle navigation on tap
          print('Navigating to $title');
        },
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
