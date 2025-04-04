import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_portfolio/widgets/contact_section.dart';
import 'package:web_portfolio/widgets/projects_sections.dart';
import 'package:web_portfolio/widgets/skill_section.dart';
import 'package:web_portfolio/widgets/slider.dart';

class IntroSection extends StatelessWidget {
  // Create a scroll controller to manage scrolling between sections
  final ScrollController _scrollController = ScrollController();

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
                  // Sidebar links
                  _buildSidebarLink("Home", () {
                    _scrollToSection(0); // Scroll to top (Home)
                  }),
                  _buildSidebarLink("Projects", () {
                    _scrollToSection(1); // Scroll to Projects section
                  }),
                  _buildSidebarLink("Skills", () {
                    _scrollToSection(2); // Scroll to Skills section
                  }),
                  _buildSidebarLink("Contact Us", () {
                    _scrollToSection(4); // Scroll to Contact Us section
                  }),
                ],
              ),
            ),
          // Main Content Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: ListView(
                controller: _scrollController, // Set controller for smooth scrolling
                children: [
                  // Profile Image and Intro Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Image
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: isMobile ? 120 : 150,
                              height: isMobile ? 120 : 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white38,
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 2),
                                  ),
                                  BoxShadow(
                                    color: Colors.white38
                                    ,
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                    offset: const Offset(2, 0),
                                  ),
                                ],
                                image: const DecorationImage(
                                  image: AssetImage('assets/brandLogo.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          isMobile ? SizedBox() : TechSkillsWidget()
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Name & Title
                      Text(
                        "NavTec Solutions",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color:Color(0xFF7B8AFD),
                        ),
                      ),
                      !isMobile ? SizedBox() : const SizedBox(height: 20),
                      !isMobile ? SizedBox() : TechSkillsWidget(),
                      const SizedBox(height: 5),
                      Text(
                        "Turning bugs into features || WEB | ANDROID | IOS | DESKTOP",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isMobile ? 14 : 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white38, // Text color
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  ImageSliderWidget(),
                  const SizedBox(height: 80),
                  _buildSectionTitle("About NavTec"),
                  _buildAboutUsSection(), // About Us Section
                  const SizedBox(height: 80),
                  _buildSectionTitle("Projects"),
                  ProjectsSection(), // Projects Section
                  const SizedBox(height: 80),
                  // Skills Section
                  _buildSectionTitle("Experties"),
                  const SizedBox(height: 80),
                  const SkillSection(), // Tech skills section
                  const SizedBox(height: 80), // Contact Us Section
                  _buildSectionTitle("We would love to hear from you!"),
                  ContactSection(), // Contact Us Section
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to create sidebar links
  Widget _buildSidebarLink(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: GestureDetector(
        onTap: onTap,
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

  // Scroll to a specific section based on index
  void _scrollToSection(int index) {
    double offset = 0.0;
    switch (index) {
      case 0: // Home (scroll to top)
        offset = 0;
        break;
      case 1: // Projects
        offset = 1000;
        break;
      case 2: // Skills
        offset = 1600;
        break;
      case 3: // About Us
        offset = 1800;
        break;
      case 4: // Contact Us
        offset = 2200;
        break;
    }
    _scrollController.animateTo(offset,
        duration: Duration(seconds: 1), curve: Curves.easeInOut);
  }

  // Section title style
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  // About Us Section with enhanced design
  Widget _buildAboutUsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          const SizedBox(height: 15),
          Text(
            "NavTec Solutions – Innovating the future with stand-alone and cross-platform applications, delivering scalable and efficient software solutions. We specialize in crafting seamless user experiences, providing custom software that adapts to your business needs. From mobile apps to complex web solutions, our team is committed to turning your vision into reality with precision, creativity, and cutting-edge technology.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white38,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class TechSkillsWidget extends StatelessWidget {
  const TechSkillsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> techImages = [
      'assets/logo.png',
      'assets/dart.png',
      'assets/py.png',
      'assets/firebase.png',
      'assets/sql.png',
      'assets/rest.png',
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        int itemsPerRow = screenWidth > 600 ? 3 : 2; // Adjust grid based on width
        double iconSize = screenWidth > 600 ? 70 : 55; // Scale icons for different screens

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 15,
            runSpacing: 15,
            children: techImages
                .map((image) => _buildSkillIcon(image, iconSize))
                .toList(),
          ),
        );
      },
    );
  }

  Widget _buildSkillIcon(String image, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(8),
      child: Image.asset(image, fit: BoxFit.contain),
    );
  }
}
