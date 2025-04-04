import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 800;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF052139), Color(0xFF0A3054)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Get in Touch",
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),

          /// Contact Cards with Same Size
          LayoutBuilder(
            builder: (context, constraints) {
              double cardWidth = isMobile ? double.infinity : 250;
              double cardHeight = 150;

              return Wrap(
                spacing: 30,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  _buildContactCard(Icons.email, "Email", "rananveed123@gmail.com", "mailto:rananveed123@gmail.com", cardWidth, cardHeight),
                  _buildContactCard(Icons.phone, "Phone", "0312 7632386", "tel:03127632386", cardWidth, cardHeight),
                  _buildContactCard(Icons.location_on, "Location", "Gujranwala, Pakistan", null, cardWidth, cardHeight),
                ],
              );
            },
          ),

          const SizedBox(height: 40),
          Text(
            "Follow Us",
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 30,
            alignment: WrapAlignment.center,
            children: [
              _buildSocialIcon("https://img.icons8.com/ios-filled/50/ffffff/linkedin.png", "LinkedIn", "https://linkedin.com/in/navtec"),
              _buildSocialIcon("https://img.icons8.com/ios-filled/50/ffffff/github.png", "GitHub", "https://github.com/navtec"),
              _buildSocialIcon("https://img.icons8.com/ios-filled/50/ffffff/twitter.png", "Twitter", "https://twitter.com/navtec"),
            ],
          ),
          const SizedBox(height: 30),
          Text(
            "© 2025 NavTec | All Rights Reserved",
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white70,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(IconData icon, String title, String info, String? url, double width, double height) {
    return InkWell(
      onTap: url != null ? () => _launchURL(url) : null,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF7B8AFD), size: 30),
            const SizedBox(height: 10),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              info,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(String imageUrl, String platform, String link) {
    return InkWell(
      onTap: () => _launchURL(link),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Image.network(imageUrl, width: 50, height: 50),
          ),
          const SizedBox(height: 10),
          Text(
            platform,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF7B8AFD),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}