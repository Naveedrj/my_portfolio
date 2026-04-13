import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_portfolio/widgets/projects_sections.dart';

import 'contact_section.dart';

// Shared theme constants (same as IntroSection)
const Color kBg = Color(0xFF0D1117);
const Color kPanel = Color(0xFF161B22);
const Color kBorder = Color(0xFF30363D);
const Color kAccentBlue = Color(0xFF58A6FF);
const Color kTextLight = Color(0xFFC9D1D9);
const Color kMuted = Color(0xFF8B949E);
const Color kSuccess = Color(0xFF238636);

class CompanyHeader extends StatelessWidget {
  final bool isMobile;
  const CompanyHeader({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1200),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 40,
          vertical: isMobile ? 24 : 40,
        ),
        decoration: BoxDecoration(
          color: kPanel, // same panel color
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35), // same shadow
              blurRadius: 18,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo (keeps visual weight similar to service cards)
            Container(
              width: isMobile ? 60 : 80,
              height: isMobile ? 60 : 80,
              decoration: BoxDecoration(
                color: kBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kBorder),
                boxShadow: [
                  BoxShadow(
                    color: kAccentBlue.withOpacity(0.25),
                    blurRadius: 12,
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Center(
                child: Image.asset(
                  'assets/sa_logo.png',
                  width: isMobile ? 40 : 60,
                  height: isMobile ? 40 : 60,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 20),
            // Name + Slogan (column)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: kAccentBlue.withOpacity(0.1),
                        blurRadius: 16,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Text(
                    "SCALEAXIS",
                    style: GoogleFonts.poppins(
                      fontSize: isMobile ? 22 : 28,
                      fontWeight: FontWeight.w700,
                      color: kAccentBlue, // matches other header styles
                    ),
                  ),
                ),
                Text(
                  "Where Ideas Reach the Summit",
                  style:GoogleFonts.robotoMono(
                    fontSize: isMobile ? 10 : 12,
                    color: kTextLight,
                    height: 1.6,
                  ),
                ),
              ],
            ),
            Spacer(),
            isMobile ? SizedBox() : Center(
              child: Wrap(
                spacing: 14,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ContactUsScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kSuccess,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 8,
                    ),
                    child: Text(
                      "Get in Touch",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PortfolioScreen()));
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: kAccentBlue, width: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      "View Portfolio",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: kAccentBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CompanyDescription extends StatelessWidget {
  final bool isMobile;
  const CompanyDescription({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Text(
      "We provide cutting-edge digital solutions to real-world problems, helping businesses thrive in today’s fast-paced digital landscape. "
          "From custom mobile apps to high-performance web platforms, we design, develop, and deliver technology that not only works but scales with your vision. "
          "Our creative team also specializes in building unique brand identities, designing impactful logos, and crafting engaging user experiences that connect with your audience. "
          "Whether you’re a startup looking to make your mark or an established business aiming to grow, ScaleAxis is your partner in innovation — where ideas reach the summit.",
      textAlign: TextAlign.left,
      style: GoogleFonts.robotoMono(
        fontSize: isMobile ? 12 : 13,
        color: kMuted,
        height: 1.5,
      ),
    );
  }
}
