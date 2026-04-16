import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // Added for Ticker support
import 'package:google_fonts/google_fonts.dart';
import 'package:web_portfolio/widgets/projects_sections.dart';

import 'contact_section.dart';

class IntroSection extends StatefulWidget {
  const IntroSection({super.key});

  @override
  State<IntroSection> createState() => _IntroSectionState();
}

class _IntroSectionState extends State<IntroSection> {
  // --- Constants & Theme ---
  static const Color kBg = Color(0xFF0D1117);
  static const Color kPanel = Color(0xFF161B22);
  static const Color kBorder = Color(0xFF30363D);
  static const Color kAccentBlue = Color(0xFF58A6FF);
  static const Color kTextLight = Color(0xFFC9D1D9);
  static const Color kMuted = Color(0xFF8B949E);
  static const Color kSuccess = Color(0xFF238636);

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 900;

    return Scaffold(
      backgroundColor: kBg,
      body: Stack(
        children: [
          // Background Glow Effects
          Positioned(
            top: -150,
            left: -150,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kAccentBlue.withOpacity(0.05),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: const SizedBox(),
              ),
            ),
          ),

          // Main Scrollable Content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                SizedBox(height: isMobile ? 100 : 120),

                // 2. Hero / Company Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  child: AnimatedCompanyHeader(isMobile: isMobile),
                ),

                // 3. Stats Section
                _FadeIn(delay: 200, child: _buildStatsSection(isMobile, width)),

                // 4. Services & Tech Grid
                _FadeIn(
                  delay: 400,
                  child: _buildSectionContainer(
                    context,
                    color: kPanel.withOpacity(0.4),
                    child: _middleGrids(isMobile),
                  ),
                ),

                // 5. FAQ
                _FadeIn(
                  delay: 500,
                  child: _buildSectionContainer(
                    context,
                    child: _buildFAQ(isMobile),
                  ),
                ),

                // 6. Who We Are
                _FadeIn(
                  delay: 600,
                  child: _buildSectionContainer(
                    context,
                    color: kPanel.withOpacity(0.4),
                    child: _buildWhoWeAre(isMobile),
                  ),
                ),

                // 7. Our Process
                _FadeIn(
                  delay: 700,
                  child: _buildSectionContainer(
                    context,
                    child: _buildProcessSection(isMobile),
                  ),
                ),

                // 8. Testimonials
                _FadeIn(
                  delay: 800,
                  child: _buildSectionContainer(
                    context,
                    color: kPanel.withOpacity(0.4),
                    child: _buildTestimonials(isMobile),
                  ),
                ),

                // 9. Call to Action
                const SizedBox(height: 60),
                _FadeIn(delay: 900, child: _buildCTA(context)),
                const SizedBox(height: 80),

                // 10. Footer
                _buildFooter(),
              ],
            ),
          ),

          // 1. Floating Glassmorphism Navigation Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: kBg.withOpacity(0.85),
                  child: _buildNavBar(isMobile),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================== Navigation Bar ==================
  Widget _buildNavBar(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40, vertical: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: kBorder)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  "assets/sa_logo.png",
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                  errorBuilder: (c, o, s) => const Icon(Icons.code, color: kAccentBlue),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "ScaleAxis",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: kTextLight,
                ),
              ),
            ],
          ),
          if (!isMobile)
            Row(
              children: [
                _navLink("Home", () => _scrollToTop(), isActive: true),
                const SizedBox(width: 40),
                _navLink("Portfolio", () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const PortfolioScreen()));
                }),
                const SizedBox(width: 40),
                _navLink("Contact Us", () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactUsScreen()));
                }),
              ],
            )
          else
            Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 28),
                color: kPanel,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: kBorder),
                ),
                offset: const Offset(0, 50),
                onSelected: (value) {
                  if (value == 'Home') _scrollToTop();
                  if (value == 'Portfolio') Navigator.push(context, MaterialPageRoute(builder: (_) => const PortfolioScreen()));
                  if (value == 'Contact') Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactUsScreen()));
                },
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                      value: 'Home',
                      child: Row(
                        children: [
                          const Icon(Icons.home_rounded, color: kAccentBlue, size: 20),
                          const SizedBox(width: 12),
                          Text("Home", style: GoogleFonts.poppins(color: kTextLight)),
                        ],
                      )
                  ),
                  PopupMenuItem(
                      value: 'Portfolio',
                      child: Row(
                        children: [
                          const Icon(Icons.work_rounded, color: kAccentBlue, size: 20),
                          const SizedBox(width: 12),
                          Text("Portfolio", style: GoogleFonts.poppins(color: kTextLight)),
                        ],
                      )
                  ),
                  PopupMenuItem(
                      value: 'Contact',
                      child: Row(
                        children: [
                          const Icon(Icons.email_rounded, color: kAccentBlue, size: 20),
                          const SizedBox(width: 12),
                          Text("Contact Us", style: GoogleFonts.poppins(color: kTextLight)),
                        ],
                      )
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  Widget _navLink(String text, VoidCallback onTap, {bool isActive = false}) {
    return InkWell(
      onTap: onTap,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: GoogleFonts.poppins(
              color: isActive ? kAccentBlue : kTextLight,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              shadows: isActive ? [Shadow(color: kAccentBlue.withOpacity(0.5), blurRadius: 10)] : [],
            ),
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 4,
              height: 4,
              decoration: const BoxDecoration(color: kAccentBlue, shape: BoxShape.circle),
            )
        ],
      ),
    );
  }

  // ================== STATS SECTION ==================
  Widget _buildStatsSection(bool isMobile, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Wrap(
        spacing: 24,
        runSpacing: 24,
        alignment: WrapAlignment.center,
        children: [
          _statCard("50", "+", "Projects Delivered", isMobile, screenWidth),
          _statCard("5", "+", "Years Experience", isMobile, screenWidth),
          _statCard("100", "%", "Job Success", isMobile, screenWidth),
          _statCard("24", "/7", "Active Support", isMobile, screenWidth),
        ],
      ),
    );
  }

  Widget _statCard(String target, String suffix, String label, bool isMobile, double screenWidth) {
    double safeWidth = isMobile ? (screenWidth - 48) : 230;

    return _HoverCard(
      backgroundColor: kPanel,
      child: Container(
        width: safeWidth,
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          children: [
            Text(
              "$target$suffix",
              style: GoogleFonts.poppins(
                fontSize: 48,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF58A6FF),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.robotoMono(
                fontSize: 13,
                color: kMuted,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================== Services ==================
  Widget _middleGrids(bool isMobile) {
    final double cardWidth = isMobile ? 320 : 230;

    final services = [
      _ServiceItem(Icons.phone_iphone, "Flutter Ecosystem", "High-performance iOS & Android apps, plus robust Flutter Web dashboards and command centers."),
      _ServiceItem(Icons.psychology, "AI & ML Apps", "Integrating LLMs, predictive models, and custom Machine Learning pipelines into your products."),
      _ServiceItem(Icons.api, "API Integration", "Seamless connection with third-party services, payment gateways, and external data sources."),
      _ServiceItem(Icons.dns, "Modern Backends", "Scalable architectures powered by Node.js, Firebase, and Supabase for real-time data handling."),
    ];

    return Column(
      children: [
        Text("CORE EXPERTISE", style: GoogleFonts.robotoMono(color: kAccentBlue, letterSpacing: 1.5, fontSize: 12)),
        const SizedBox(height: 16),
        Text("What We Build", style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: kTextLight)),
        const SizedBox(height: 40),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: services.map((s) => _HoverCard(
              backgroundColor: kBg,
              child: _serviceCard(s, cardWidth)
          )).toList(),
        ),
      ],
    );
  }

  Widget _serviceCard(_ServiceItem s, double width) {
    return Container(
      width: width,
      height: 250,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: kAccentBlue.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(s.icon, color: kAccentBlue, size: 28),
          ),
          const SizedBox(height: 20),
          Text(s.title, textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: kTextLight)),
          const SizedBox(height: 12),
          Text(s.desc, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 12, color: kMuted, height: 1.5)),
        ],
      ),
    );
  }

  // ================== FAQ ==================
  Widget _buildFAQ(bool isMobile) {
    final faqs = [
      {
        "q": "What is your main technology stack?",
        "a": "We are experts in Flutter for iOS, Android, and Web Dashboards. For backend infrastructure, we utilize Node.js, Firebase, and Supabase. We also build and integrate custom AI/ML pipelines."
      },
      {
        "q": "Can you build AI into my existing app?",
        "a": "Absolutely. We specialize in API integrations, including integrating LLMs (like OpenAI/Gemini) or deploying custom Machine Learning models into existing ecosystems."
      },
      {
        "q": "Do you provide post-launch support?",
        "a": "Yes! All our projects come with a 3-month free support period to ensure everything runs smoothly. After that, we offer flexible maintenance packages to scale with you."
      },
      {
        "q": "How long does it take to build an MVP?",
        "a": "A typical MVP usually takes between 4 to 8 weeks, depending on the complexity of features like real-time syncing or ML processing."
      },
    ];

    return Column(
      children: [
        Text("COMMON QUERIES", style: GoogleFonts.robotoMono(color: kAccentBlue, letterSpacing: 1.5, fontSize: 12)),
        const SizedBox(height: 16),
        Text("Frequently Asked Questions", style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: kTextLight)),
        const SizedBox(height: 50),
        SizedBox(
          width: 800,
          child: Column(
            children: faqs.map((f) => _ModernFAQItem(question: f['q']!, answer: f['a']!)).toList(),
          ),
        )
      ],
    );
  }

  // ================== Who We Are ==================
  Widget _buildWhoWeAre(bool isMobile) {
    return Column(
      children: [
        Text("AGENCY OVERVIEW", style: GoogleFonts.robotoMono(color: kAccentBlue, letterSpacing: 1.5, fontSize: 12)),
        const SizedBox(height: 16),
        Text(
          "We Build Digital Empires.",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: isMobile ? 28 : 36,
            fontWeight: FontWeight.w700,
            color: kTextLight,
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: 700,
          child: Text(
            "ScaleAxis is an elite software development agency. We bridge the gap between complex engineering—like Machine Learning and scalable backends—and intuitive front-end design to deliver products that dominate the market.",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 16, color: kMuted, height: 1.6),
          ),
        ),
      ],
    );
  }

  // ================== Our Process ==================
  Widget _buildProcessSection(bool isMobile) {
    final double cardWidth = isMobile ? 320 : 230;

    return Column(
      children: [
        Text("WORKFLOW", style: GoogleFonts.robotoMono(color: kAccentBlue, letterSpacing: 1.5, fontSize: 12)),
        const SizedBox(height: 16),
        Text("How We Deliver Excellence", style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: kTextLight)),
        const SizedBox(height: 50),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: [
            _processCard("01", "Discovery", "We analyze your requirements, API needs, and AI feasibility.", Icons.search, cardWidth),
            _processCard("02", "Design", "Creating wireframes and high-fidelity UI/UX prototypes.", Icons.brush, cardWidth),
            _processCard("03", "Develop", "Agile sprints using Flutter, Node.js, Firebase, or Supabase.", Icons.code, cardWidth),
            _processCard("04", "Launch", "Deployment, ML pipeline optimization, and post-launch support.", Icons.rocket, cardWidth),
          ],
        ),
      ],
    );
  }

  Widget _processCard(String num, String title, String desc, IconData icon, double width) {
    return _HoverCard(
      child: Container(
        width: width,
        height: 260,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(num, style: GoogleFonts.robotoMono(fontSize: 24, fontWeight: FontWeight.bold, color: kBorder)),
                Icon(icon, color: kAccentBlue, size: 20),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: kTextLight)),
                const SizedBox(height: 8),
                Text(desc, style: GoogleFonts.inter(fontSize: 12, color: kMuted, height: 1.5)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================== Testimonials ==================
  Widget _buildTestimonials(bool isMobile) {
    return Column(
      children: [
        Text("TESTIMONIALS", style: GoogleFonts.robotoMono(color: kAccentBlue, letterSpacing: 1.5, fontSize: 12)),
        const SizedBox(height: 16),
        Text("What Clients Say", style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold, color: kTextLight)),
        const SizedBox(height: 40),
        Wrap(
          spacing: 24,
          runSpacing: 24,
          alignment: WrapAlignment.center,
          children: [
            _testimonialCard(
                "ScaleAxis built our Flutter Web command center and it is flawless. Managing our real-time data via Supabase has never been easier.",
                "Ijaz Mohaiuddin",
                "CEO, Dayyan Carbonated",
                isMobile
            ),
            _testimonialCard(
                "They integrated a complex Machine Learning pipeline into our mobile app. The AI features are fast and completely stable.",
                "Najeef Gillani",
                "Director, Gillani Enterprises",
                isMobile
            ),
            _testimonialCard(
                "Exceptional delivery on our e-commerce app. The UI is silky smooth and the Node.js backend handles our traffic spikes perfectly.",
                "Sarah Jenkins",
                "Founder, StyleHive",
                isMobile
            ),
          ],
        ),
      ],
    );
  }

  Widget _testimonialCard(String text, String author, String role, bool isMobile) {
    return _HoverCard(
      backgroundColor: kBg,
      child: Container(
        width: isMobile ? 320 : 320,
        height: 240,
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.format_quote, color: kAccentBlue, size: 24),
                const SizedBox(height: 12),
                Text(text, style: GoogleFonts.inter(color: kTextLight, height: 1.5, fontSize: 13), maxLines: 4, overflow: TextOverflow.ellipsis),
              ],
            ),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: kPanel,
                  radius: 16,
                  child: Text(author[0], style: const TextStyle(color: kAccentBlue, fontSize: 12)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(author, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: kTextLight, fontSize: 13)),
                      Text(role, style: GoogleFonts.robotoMono(fontSize: 10, color: kMuted)),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  // ================== CTA Buttons ==================
  Widget _buildCTA(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text("Ready to Scale?", style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 10),
          Text("Let's turn your idea into a reality.", style: GoogleFonts.inter(color: kMuted)),
          const SizedBox(height: 30),
          Wrap(
            spacing: 20,
            runSpacing: 15,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactUsScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kSuccess,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 22),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  elevation: 10,
                  shadowColor: kSuccess.withOpacity(0.4),
                ),
                child: Text(
                  "Start Your Project",
                  style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const PortfolioScreen()));
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: kBorder, width: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 22),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                  foregroundColor: kTextLight,
                ),
                child: Text(
                  "View Portfolio",
                  style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================== Footer ==================
  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: kBorder)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.code, color: kMuted, size: 20),
              const SizedBox(width: 8),
              Text("ScaleAxis", style: GoogleFonts.poppins(color: kMuted, fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "© 2024 ScaleAxis. Made in Pakistan.",
            style: GoogleFonts.robotoMono(color: kMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ================== Helpers ==================
  Widget _buildSectionContainer(BuildContext context, {required Widget child, Color? color}) {
    return Container(
      width: double.infinity,
      color: color ?? Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: child,
      ),
    );
  }
}

// ================== REUSABLE COMPONENTS ==================

class _ServiceItem {
  final IconData icon;
  final String title;
  final String desc;
  _ServiceItem(this.icon, this.title, this.desc);
}

// --- UPDATED: SMART ANIMATED HEADER ---
class AnimatedCompanyHeader extends StatefulWidget {
  final bool isMobile;
  const AnimatedCompanyHeader({super.key, required this.isMobile});

  @override
  State<AnimatedCompanyHeader> createState() => _AnimatedCompanyHeaderState();
}

class _AnimatedCompanyHeaderState extends State<AnimatedCompanyHeader> with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  late AnimationController _hoverController;
  late Animation<Offset> _hoverAnimation;

  // Components for the custom 10-second Cannon Acceleration
  late AnimationController _accelerationController;
  late Animation<double> _speedAnimation;
  late Ticker _ticker;
  Duration _lastElapsed = Duration.zero;
  final ValueNotifier<double> _lineProgress = ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();

    // 1. Entrance Animations
    _entranceController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _entranceController, curve: Curves.easeOutCubic)
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(parent: _entranceController, curve: Curves.easeOutCubic)
    );

    // 2. Smooth Floating Animation
    _hoverController = AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _hoverAnimation = Tween<Offset>(begin: const Offset(0, -0.05), end: const Offset(0, 0.05)).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOutSine),
    );

    // 3. 10-Second Cannon Fire Acceleration Setup
    _accelerationController = AnimationController(vsync: this, duration: const Duration(seconds: 10));

    // UPDATED: Raised starting speed to 1.0 to eliminate the "frozen/too slow" period
    // and used easeInQuad for a smoother, constant acceleration curve
    _speedAnimation = Tween<double>(begin: 1.0, end: 7.0).animate(
        CurvedAnimation(parent: _accelerationController, curve: Curves.easeInQuad)
    );

    // Ticker manually drives the line progress independent of frame rate
    _ticker = createTicker((elapsed) {
      final double deltaSeconds = (elapsed - _lastElapsed).inMilliseconds / 1000.0;
      _lastElapsed = elapsed;
      _lineProgress.value += deltaSeconds * _speedAnimation.value;
    });

    // Start everything
    _entranceController.forward().then((_) {
      _hoverController.repeat(reverse: true);
      _accelerationController.forward(); // Start building speed
      _ticker.start(); // Start drawing lines
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _hoverController.dispose();
    _accelerationController.dispose();
    _ticker.dispose();
    _lineProgress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 160,
          width: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // ValueListenableBuilder updates ONLY the painter when _lineProgress changes
              FadeTransition(
                opacity: _fadeAnimation,
                child: ValueListenableBuilder<double>(
                  valueListenable: _lineProgress,
                  builder: (context, value, child) {
                    return CustomPaint(
                      size: const Size(300, 160),
                      painter: SpeedLinesPainter(progress: value),
                    );
                  },
                ),
              ),

              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: SlideTransition(
                    position: _hoverAnimation,
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0xFF58A6FF).withOpacity(0.3),
                              blurRadius: 60,
                              spreadRadius: 15
                          )
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          "assets/sa_logo.png",
                          fit: BoxFit.cover,
                          errorBuilder: (c, o, s) => const Icon(Icons.rocket_launch, size: 70, color: Color(0xFF58A6FF)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),

        _FadeIn(
          delay: 400,
          child: Column(
            children: [
              Text(
                "Architecting Digital Empires",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: widget.isMobile ? 36 : 64,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Flutter • AI Integrations • Scalable Backends",
                textAlign: TextAlign.center,
                style: GoogleFonts.robotoMono(
                    fontSize: widget.isMobile ? 13 : 16,
                    color: const Color(0xFF58A6FF),
                    letterSpacing: 1.2
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "We design, build, and scale software solutions.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    fontSize: widget.isMobile ? 14 : 16,
                    color: const Color(0xFF8B949E)
                ),
              ),
              const SizedBox(height: 40),

              // NEW: CTA Buttons injected into Header
              Wrap(
                spacing: 20,
                runSpacing: 15,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactUsScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF238636), // Green Fill
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 22),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      elevation: 10,
                      shadowColor: const Color(0xFF238636).withOpacity(0.4),
                    ),
                    child: Text(
                      "Start Your Project",
                      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const PortfolioScreen()));
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF30363D), width: 2), // Dark Outline
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 22),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      foregroundColor: const Color(0xFFC9D1D9), // Text Light Color
                    ),
                    child: Text(
                      "View Portfolio",
                      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// --- MODERN FAQ ACCORDION WITH CHEVRON ---
class _ModernFAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const _ModernFAQItem({required this.question, required this.answer});

  @override
  State<_ModernFAQItem> createState() => _ModernFAQItemState();
}

class _ModernFAQItemState extends State<_ModernFAQItem> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _isHovered || _isExpanded ? const Color(0xFF161B22) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isExpanded
                  ? const Color(0xFF58A6FF).withOpacity(0.4)
                  : (_isHovered ? const Color(0xFF30363D) : Colors.transparent),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: _isExpanded ? Colors.white : const Color(0xFFC9D1D9),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: _isExpanded ? const Color(0xFF58A6FF) : const Color(0xFF8B949E),
                      size: 28,
                    ),
                  ),
                ],
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox(width: double.infinity, height: 0),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    widget.answer,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF8B949E),
                      height: 1.6,
                      fontSize: 14,
                    ),
                  ),
                ),
                crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
                sizeCurve: Curves.easeOutCubic,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SpeedLinesPainter extends CustomPainter {
  final double progress;

  SpeedLinesPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF58A6FF) // Base color
      ..strokeWidth = 1.0 // REDUCED WIDTH: Was 3.0
      ..strokeCap = StrokeCap.round;

    // Different lengths and offsets for varied firing
    _drawLine(canvas, size, paint, yOffset: size.height * 0.2, length: 120, speedMultiplier: 1.5, startXOffset: 0.1);
    _drawLine(canvas, size, paint, yOffset: size.height * 0.4, length: 200, speedMultiplier: 1.0, startXOffset: 0.5);
    _drawLine(canvas, size, paint, yOffset: size.height * 0.65, length: 90, speedMultiplier: 1.8, startXOffset: 0.8);
    _drawLine(canvas, size, paint, yOffset: size.height * 0.85, length: 150, speedMultiplier: 1.2, startXOffset: 0.3);
  }

  void _drawLine(Canvas canvas, Size size, Paint paint, {
    required double yOffset,
    required double length,
    required double speedMultiplier,
    required double startXOffset
  }) {
    // 1. Calculate raw linear progress (using modulo to loop continuously)
    double rawProgress = ((progress * speedMultiplier) + startXOffset) % 1.0;

    // 2. Apply Cubic Ease-In for "Cannon Fire" acceleration on individual beams
    double easedProgress = rawProgress * rawProgress * rawProgress;

    double totalWidth = size.width + length * 2;
    double currentX = totalWidth - (easedProgress * totalWidth);

    double startX = currentX - length;
    double endX = startX + length;

    double opacity = 1.0;

    // Fade out as it exits the left side
    if (endX < size.width * 0.3) {
      opacity = (endX / (size.width * 0.3)).clamp(0.0, 1.0);
    }
    // Fade in smoothly as it spawns on the right side
    if (startX > size.width * 0.7) {
      opacity = opacity * ((size.width - startX) / (size.width * 0.3)).clamp(0.0, 1.0);
    }

    // REDUCED OPACITY: Changed multiplier from 0.7 to 0.25
    paint.color = paint.color.withOpacity(opacity * 0.25);

    canvas.drawLine(Offset(startX, yOffset), Offset(endX, yOffset), paint);
  }

  @override
  bool shouldRepaint(covariant SpeedLinesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _FadeIn extends StatelessWidget {
  final Widget child;
  final int delay;
  const _FadeIn({required this.child, required this.delay});
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 600 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, double value, child) {
        double adjustedValue = (value - (delay / 2000)).clamp(0.0, 1.0);
        double opacity = adjustedValue * (1 / (1 - (delay / 2000).clamp(0.0, 0.9)));
        opacity = opacity.clamp(0.0, 1.0);

        return Opacity(
          opacity: opacity,
          child: Transform.translate(offset: Offset(0, 30 * (1 - opacity)), child: child),
        );
      },
      child: child,
    );
  }
}

class _HoverCard extends StatefulWidget {
  final Widget child;
  final bool disableScale;
  final bool borderless;
  final Color? backgroundColor;

  const _HoverCard({
    required this.child,
    this.disableScale = false,
    this.borderless = false,
    this.backgroundColor,
  });

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()..scale((_isHovered && !widget.disableScale) ? 1.02 : 1.0),
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? const Color(0xFF161B22),
          borderRadius: BorderRadius.circular(16),
          border: widget.borderless
              ? null
              : Border.all(
              color: _isHovered
                  ? const Color(0xFF58A6FF).withOpacity(0.5)
                  : const Color(0xFF30363D),
              width: 1
          ),
          boxShadow: _isHovered
              ? [
            BoxShadow(
              color: const Color(0xFF58A6FF).withOpacity(0.15),
              blurRadius: 30,
              offset: const Offset(0, 10),
            )
          ]
              : [],
        ),
        child: widget.child,
      ),
    );
  }
}