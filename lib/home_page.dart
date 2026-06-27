import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main.dart';
import 'theme.dart'; // Contains BloomTheme and LiquidGlass

// Important: Import your other screens for Navigator.push
import 'project_page.dart';
import 'team_page.dart';
import 'contact_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 1024;

    return isMobile ? _buildMobileLayout(context) : _buildDesktopLayout(context);
  }

  // =========================================================
  // 🖥️ DESKTOP LAYOUT
  // =========================================================
  Widget _buildDesktopLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left Panel (52%)
          Expanded(
            flex: 52,
            child: LiquidGlass(
              isStrong: true,
              borderRadius: BorderRadius.circular(24),
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLogo(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeroText(isMobile: false),
                      const SizedBox(height: 40),
                      _buildCTA(context),
                    ],
                  ),
                  _buildBottomQuote(),
                ],
              ),
            ),
          ),
          const SizedBox(width: 24),
          // Right Panel (48%)
          Expanded(
            flex: 48,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildTopRightBar(context),
                SizedBox(
                  width: double.infinity,
                  child: _buildExpertiseGrid(isMobile: false),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // 📱 MOBILE LAYOUT (Professional & Breathable)
  // =========================================================
  Widget _buildMobileLayout(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Navigation Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildLogo(),
                Row(
                  children: const [
                    _NavButton(title: "Team", targetPage: TeamPage()),
                    SizedBox(width: 8),
                    _NavButton(title: "Contact", targetPage: ContactPage()),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 60),

            // Hero Section
            _buildHeroText(isMobile: true),
            const SizedBox(height: 32),
            _buildCTA(context),

            const SizedBox(height: 80),

            // Expertise Section
            Text("Core Operations", style: BloomTheme.display.copyWith(fontSize: 20)),
            const SizedBox(height: 16),
            _buildExpertiseGrid(isMobile: true),

            const SizedBox(height: 40),

            // Contact Section
            Text("Let's Talk", style: BloomTheme.display.copyWith(fontSize: 20)),
            const SizedBox(height: 16),
            _buildContactSection(),

            const SizedBox(height: 40),
            _buildBottomQuote(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // 🧩 REUSABLE COMPONENTS
  // =========================================================
  Widget _buildLogo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.code, color: Colors.white, size: 24),
        const SizedBox(width: 10),
        Text(
          "ScaleAxis",
          style: BloomTheme.display.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildHeroText({required bool isMobile}) {
    final double fontSize = isMobile ? 40 : 64; // Tighter scaling for mobile

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Left aligned looks much more professional
      children: [
        // Eyebrow Tags
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: const [
            _Pill("Flutter Ecosystem"),
            _Pill("AI Integrations"),
          ],
        ),
        const SizedBox(height: 24),

        // Massive Typography
        Text(
          "Architecting the",
          style: BloomTheme.display.copyWith(fontSize: fontSize, height: 1.1, letterSpacing: -2),
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "spirit of ",
                style: BloomTheme.serifItalic.copyWith(fontSize: fontSize, height: 1.1),
              ),
              TextSpan(
                text: "innovation",
                style: BloomTheme.display.copyWith(fontSize: fontSize, height: 1.1, letterSpacing: -2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Subtitle
        Text(
          "We bridge the gap between intuitive Flutter front-ends and production-ready AI capabilities to deliver software that dominates the market.",
          style: BloomTheme.body.copyWith(fontSize: isMobile ? 15 : 16, color: BloomTheme.textMuted, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildCTA(BuildContext context) {
    return InkWell(
      // FIX: Wrap the target page in the BackgroundVideoWrapper
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BackgroundVideoWrapper(child: ProjectPage()),
        ),
      ),
      borderRadius: BorderRadius.circular(50),
      child: LiquidGlass(
        isStrong: true,
        borderRadius: BorderRadius.circular(50),
        padding: const EdgeInsets.fromLTRB(24, 12, 12, 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Explore Projects", style: BloomTheme.display.copyWith(fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: Colors.white12, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomQuote() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("VISIONARY DESIGN", style: BloomTheme.body.copyWith(fontSize: 10, letterSpacing: 3, color: BloomTheme.textMuted)),
        const SizedBox(height: 8),
        Text("We imagined a realm with no ending.", style: BloomTheme.serifItalic.copyWith(fontSize: 16)),
      ],
    );
  }

  Widget _buildTopRightBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: const [
        _NavButton(title: "Meet the Team", targetPage: TeamPage()),
        SizedBox(width: 16),
        _NavButton(title: "Contact Us", targetPage: ContactPage()),
      ],
    );
  }

  Widget _buildExpertiseGrid({required bool isMobile}) {
    final cards = [
      const _ExpertiseCard(icon: Icons.smartphone, title: "Cross-Platform", desc: "High-performance iOS, Android, and Web architectures."),
      const _ExpertiseCard(icon: Icons.auto_awesome, title: "AI Deployment", desc: "Integrating powerful LLMs directly into your applications."),
    ];

    if (isMobile) {
      return Column(
        children: [
          cards[0],
          const SizedBox(height: 16),
          cards[1],
        ],
      );
    }

    return LiquidGlass(
      borderRadius: BorderRadius.circular(40),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Core Operations", style: BloomTheme.display.copyWith(fontSize: 24)),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: cards[0]),
              const SizedBox(width: 16),
              Expanded(child: cards[1]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection() {
    return InkWell(
      onTap: () async {
        final Uri emailLaunchUri = Uri(
          scheme: 'mailto',
          path: 'scaleaxisofficials@gmail.com',
        );
        if (await canLaunchUrl(emailLaunchUri)) {
          await launchUrl(emailLaunchUri);
        }
      },
      borderRadius: BorderRadius.circular(24),
      child: LiquidGlass(
        borderRadius: BorderRadius.circular(24),
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            const Icon(Icons.mail_outline, color: Colors.white, size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                "scaleaxisofficials@gmail.com",
                style: BloomTheme.display.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_outward_rounded, color: Colors.white54, size: 16),
          ],
        ),
      ),
    );
  }
}

// =========================================================
// 🧰 UI TOKENS
// =========================================================
class _NavButton extends StatelessWidget {
  final String title;
  final Widget targetPage;

  const _NavButton({required this.title, required this.targetPage});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // FIX: Wrap the target page in the BackgroundVideoWrapper
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BackgroundVideoWrapper(child: targetPage),
        ),
      ),
      borderRadius: BorderRadius.circular(50),
      child: LiquidGlass(
        borderRadius: BorderRadius.circular(50),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Text(title, style: BloomTheme.display.copyWith(fontSize: 13, fontWeight: FontWeight.w500)),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  const _Pill(this.text);

  @override
  Widget build(BuildContext context) {
    return LiquidGlass(
      borderRadius: BorderRadius.circular(50),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Text(text, style: BloomTheme.body.copyWith(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w500)),
    );
  }
}

class _ExpertiseCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _ExpertiseCard({required this.icon, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return LiquidGlass(
      isStrong: false,
      borderRadius: BorderRadius.circular(24),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(color: Colors.white12, shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 20),
          Text(title, style: BloomTheme.display.copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(desc, style: BloomTheme.body.copyWith(fontSize: 13, color: BloomTheme.textMuted, height: 1.5)),
        ],
      ),
    );
  }
}