import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'theme.dart'; // Make sure this points to your file with BloomTheme and LiquidGlass

class TeamPage extends StatefulWidget {
  const TeamPage({super.key});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> with TickerProviderStateMixin {
  late AnimationController _entranceController;

  // Added image paths and fixed spelling for ML Engineer
  final List<Map<String, String>> teamMembers = [
    {"name": "Naveed Ur Rehman", "role": "Founder & Full-Stack Developer", "image": "assets/naveed.jpeg", "email": "rananveed123@gmail.com"},
    {"name": "M. Hammad", "role": "Co-Founder & Developer", "image": "assets/hammad.jpeg", "email": "hammadsohail888@gmail.com"},
    {"name": "Usman Ahmad", "role": "Artificial Intelligence Engineer", "image": "assets/usman.jpeg", "email": ""},
    {"name": "Abubakar Sagheer Mughal", "role": "Amazon Business Manager", "image": "assets/abubakar.jpeg", "email": ""},
    {"name": "Harmain Mughal", "role": "ML Engineer", "image": "assets/harmain.png", "email": ""},
  ];

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 850;

    // Split the team to guarantee Founders are always on top
    final founders = teamMembers.sublist(0, 2);
    final restOfTeam = teamMembers.sublist(2);

    return Scaffold(
      backgroundColor: Colors.transparent, // Ensures the background video is visible
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            _FadeIn(
              controller: _entranceController,
              delay: 0,
              child: _buildTopNavigationBar(isMobile, context),
            ),

            // Scrollable Content Area
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40, vertical: 40),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Column(
                      children: [
                        SizedBox(height: isMobile ? 20 : 60),

                        // --- HEADER SECTION ---
                        _FadeIn(
                          controller: _entranceController,
                          delay: 100,
                          child: Column(
                            children: [
                              const _BadgeContainer(text: "The Collective"),
                              const SizedBox(height: 24),
                              Text(
                                "Architects of Innovation.",
                                textAlign: TextAlign.center,
                                style: BloomTheme.display.copyWith(fontSize: isMobile ? 40 : 64, fontWeight: FontWeight.w700, height: 1.1, letterSpacing: -2.0),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: 650,
                                child: Text(
                                  "We are a collective of visionary developers, designers, and strategists turning complex problems into elegant digital solutions.",
                                  textAlign: TextAlign.center,
                                  style: BloomTheme.body.copyWith(fontSize: isMobile ? 15 : 18, color: BloomTheme.textSecondary, height: 1.6),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 80),

                        // --- FOUNDERS GRID (Always top row) ---
                        Wrap(
                          spacing: 24,
                          runSpacing: 32,
                          alignment: WrapAlignment.center,
                          children: founders.asMap().entries.map((entry) {
                            return _FadeIn(
                              controller: _entranceController,
                              delay: 200 + (entry.key * 100),
                              child: _PremiumTeamCard(
                                member: entry.value,
                                isMobile: isMobile,
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 32),

                        // --- REST OF TEAM GRID (Always below founders) ---
                        Wrap(
                          spacing: 24,
                          runSpacing: 32,
                          alignment: WrapAlignment.center,
                          children: restOfTeam.asMap().entries.map((entry) {
                            return _FadeIn(
                              controller: _entranceController,
                              delay: 400 + (entry.key * 100), // Slightly delayed after founders
                              child: _PremiumTeamCard(
                                member: entry.value,
                                isMobile: isMobile,
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 120),

                        // --- FOOTER ---
                        _FadeIn(
                          controller: _entranceController,
                          delay: 800,
                          child: Text(
                            "© 2024 ScaleAxis. Made in Pakistan.",
                            style: BloomTheme.body.copyWith(color: BloomTheme.textMuted, fontSize: 12, letterSpacing: 1.0),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNavigationBar(bool isMobile, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 24.0 : 40.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.code, color: Colors.white, size: 24),
              const SizedBox(width: 10),
              Text("ScaleAxis", style: BloomTheme.display.copyWith(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: -0.5)),
            ],
          ),
          Row(
            children: [
              _NavButton(title: "Return Home", onTap: () => Navigator.pop(context), isAction: false),
            ],
          ),
        ],
      ),
    );
  }
}

// ==========================================
// ULTRA-PREMIUM BENTO CARD WITH GRAYSCALE HOVER
// ==========================================
class _PremiumTeamCard extends StatefulWidget {
  final Map<String, String> member;
  final bool isMobile;

  const _PremiumTeamCard({required this.member, required this.isMobile});

  @override
  State<_PremiumTeamCard> createState() => _PremiumTeamCardState();
}

class _PremiumTeamCardState extends State<_PremiumTeamCard> {
  bool _isHovered = false;

  // Standard Grayscale Matrix
  static const ColorFilter _grayscaleFilter = ColorFilter.matrix(<double>[
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0,      0,      0,      1, 0,
  ]);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -8.0 : 0.0),
        width: widget.isMobile ? double.infinity : 340,
        child: LiquidGlass(
          isStrong: _isHovered, // Blur intensifies on hover
          borderRadius: BorderRadius.circular(32),
          padding: const EdgeInsets.all(12), // Inner padding for the "Bento" look
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. TOP HALF: ANIMATED IMAGE HEADER
              SizedBox(
                height: 260,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Smooth Zoom Effect
                      AnimatedScale(
                        scale: _isHovered ? 1.05 : 1.0,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOutCubic,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Base Layer: Grayscale Image
                            ColorFiltered(
                              colorFilter: _grayscaleFilter,
                              child: _buildImage(),
                            ),
                            // Overlay Layer: Color Image (Fades in on hover)
                            AnimatedOpacity(
                              opacity: _isHovered ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 400),
                              child: _buildImage(),
                            ),
                          ],
                        ),
                      ),
                      // Inner Shadow to blend image into the glass
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.4),
                            ],
                            stops: const [0.6, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. BOTTOM HALF: DETAILS & ACTIONS
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.member["name"]!,
                      style: BloomTheme.display.copyWith(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.5),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.member["role"]!.toUpperCase(),
                      style: BloomTheme.body.copyWith(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: BloomTheme.textMuted),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    if (widget.member["email"]!.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _EmailInteractionButton(email: widget.member["email"]!),
                    ]
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Image.asset(
      widget.member["image"]!,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.white.withOpacity(0.05),
        child: const Icon(Icons.person_outline, size: 40, color: Colors.white54),
      ),
    );
  }
}

// ==========================================
// SLEEK EMAIL BUTTON
// ==========================================
class _EmailInteractionButton extends StatefulWidget {
  final String email;
  const _EmailInteractionButton({required this.email});

  @override
  State<_EmailInteractionButton> createState() => _EmailInteractionButtonState();
}

class _EmailInteractionButtonState extends State<_EmailInteractionButton> {
  bool _copied = false;

  void _handleTap() async {
    // Copy to clipboard
    Clipboard.setData(ClipboardData(text: widget.email));
    setState(() => _copied = true);

    // Launch Mail client
    final Uri url = Uri(scheme: 'mailto', path: widget.email);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }

    // Reset copy state
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _handleTap,
      borderRadius: BorderRadius.circular(12),
      child: LiquidGlass(
        borderRadius: BorderRadius.circular(12),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                _copied ? Icons.check_circle_outline : Icons.mail_outline,
                size: 16,
                color: Colors.white
            ),
            const SizedBox(width: 8),
            Text(
              _copied ? "Email Copied" : "Get in Touch",
              style: BloomTheme.display.copyWith(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// REUSABLE UI COMPONENTS
// ==========================================
class _NavButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isAction;

  const _NavButton({required this.title, required this.onTap, required this.isAction});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: LiquidGlass(
        isStrong: isAction,
        borderRadius: BorderRadius.circular(50),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Text(
          title,
          style: BloomTheme.display.copyWith(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class _BadgeContainer extends StatelessWidget {
  final String text;
  const _BadgeContainer({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Text(
        text.toUpperCase(),
        style: BloomTheme.body.copyWith(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.white),
      ),
    );
  }
}

class _FadeIn extends StatelessWidget {
  final AnimationController controller;
  final int delay;
  final Widget child;

  const _FadeIn({required this.controller, required this.delay, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final double start = (delay / 1000).clamp(0.0, 1.0);
        final double end = ((delay + 500) / 1000).clamp(0.0, 1.0);
        final curve = CurvedAnimation(parent: controller, curve: Interval(start, end, curve: Curves.easeOutQuad));
        return Opacity(
          opacity: curve.value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - curve.value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}