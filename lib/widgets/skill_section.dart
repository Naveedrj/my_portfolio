import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SkillSection extends StatelessWidget {
  const SkillSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: [
              _buildCategoryCard("Flutter Development", [
                "Flutter",
                "Dart",
                "Android",
                "iOS",
                "Flutter Web",
                "Flames",
                "Riverpod",
                "Provider",
                "GetX",
              ], Icons.developer_mode),
              _buildCategoryCard("Backend Development", [
                "FastAPI",
                "Python",
                "REST APIs",
                "API Integration",
                "Deployment",
              ], Icons.api),
              _buildCategoryCard("Databases & Storage", [
                "Firebase",
                "SQL",
                "Sqflite",
              ], Icons.storage),
              _buildCategoryCard("Tools & Technologies", [
                "Google Maps",
                "Payment Gateways",
                "Machine Learning",
              ], Icons.build),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, List<String> skills, IconData icon) {
    return Container(
      width: 300,
      height: 500,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Color(0xFF7B8AFD)),
          const SizedBox(height: 15),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: skills.map((skill) => _buildSkillChip(skill)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Color(0xFF7B8AFD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        skill,
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
      ),
    );
  }
}
