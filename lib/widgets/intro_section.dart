import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroSection extends StatefulWidget {
  const IntroSection({super.key});

  @override
  State<IntroSection> createState() => _IntroSectionState();
}

class _IntroSectionState extends State<IntroSection> {
  // Theme constraints locally for the intro section
  static const Color kIdeDark = Color(0xFF0A0D12);
  static const Color kIdePanel = Color(0xFF161B22);
  static const Color kBorder = Color(0xFF30363D);
  static const Color kAccentBlue = Color(0xFF58A6FF);
  static const Color kAccentPurple = Color(0xFFBC8DFF);
  static const Color kTextLight = Color(0xFFC9D1D9);
  static const Color kMuted = Color(0xFF8B949E);
  static const Color kSuccess = Color(0xFF238636);

  static const Color kSyntaxKeyword = Color(0xFFFF7B72);
  static const Color kSyntaxString = Color(0xFFA5D6FF);
  static const Color kSyntaxClass = Color(0xFFD2A8FF);

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 1000;

    return Stack(
      children: [
        // Ambient Glows
        Positioned(top: -150, left: -150, child: _buildAmbientGlow(kAccentBlue.withOpacity(0.08), 500)),
        Positioned(top: 600, right: -200, child: _buildAmbientGlow(kAccentPurple.withOpacity(0.05), 600)),
        Positioned(bottom: -100, left: width * 0.2, child: _buildAmbientGlow(kAccentBlue.withOpacity(0.06), 700)),

        // Main Scrollable Content
        SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              SizedBox(height: isMobile ? 60 : 80),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                child: AnimatedCompanyHeader(isMobile: isMobile),
              ),
              _FadeIn(delay: 200, child: _buildStatsSection(isMobile, width)),
              _FadeIn(delay: 400, child: _buildSectionContainer(context, color: kIdePanel.withOpacity(0.4), child: _middleGrids(isMobile))),
              _FadeIn(delay: 500, child: _buildSectionContainer(context, child: _buildFAQ(isMobile))),
              _FadeIn(delay: 600, child: _buildSectionContainer(context, color: kIdePanel.withOpacity(0.4), child: _buildWhoWeAre(isMobile))),
              _FadeIn(delay: 700, child: _buildSectionContainer(context, child: _buildProcessSection(isMobile))),
              _FadeIn(delay: 800, child: _buildSectionContainer(context, color: kIdePanel.withOpacity(0.4), child: _buildTestimonials(isMobile))),
              const SizedBox(height: 60),
              _FadeIn(delay: 900, child: _buildCTA(context)),
              const SizedBox(height: 80),
              _buildFooter(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAmbientGlow(Color color, double size) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120), child: const SizedBox()),
    );
  }

  Widget _buildStatsSection(bool isMobile, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Wrap(
        spacing: 24, runSpacing: 24, alignment: WrapAlignment.center,
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
      backgroundColor: kIdeDark,
      child: Container(
        width: safeWidth,
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Column(
          children: [
            _GradientText(
              text: "$target$suffix",
              style: GoogleFonts.robotoMono(fontSize: 48, fontWeight: FontWeight.w800),
              gradient: const LinearGradient(colors: [kAccentBlue, kAccentPurple]),
            ),
            const SizedBox(height: 12),
            Text("//$label", textAlign: TextAlign.center, style: GoogleFonts.robotoMono(fontSize: 13, color: kSyntaxString, letterSpacing: 1)),
          ],
        ),
      ),
    );
  }

  Widget _middleGrids(bool isMobile) {
    final double cardWidth = isMobile ? 320 : 340;
    final services = [
      _ServiceItem(Icons.phone_iphone_rounded, "Mobile App Mastery", "Our primary focus. Dominating iOS & Android with high-performance Flutter and Native applications.", isCore: true),
      _ServiceItem(Icons.web_rounded, "Web Ecosystems", "From light WordPress sites to Flutter Web command centers and scalable React/Next.js business apps."),
      _ServiceItem(Icons.dns_rounded, "Scalable Backends", "Robust architectures powered by Node.js, Firebase, and Supabase for real-time data handling."),
      _ServiceItem(Icons.trending_up_rounded, "ASO, SEO & Marketing", "Data-driven strategies and marketing campaigns to skyrocket your app's visibility and user acquisition."),
      _ServiceItem(Icons.psychology_rounded, "AI & ML Pipelines", "Integrating LLMs (like Gemini) and custom predictive models directly into your existing infrastructure."),
      _ServiceItem(Icons.hub_rounded, "API Engineering", "Seamless connectivity with third-party gateways, payment processors, and complex external data sources."),
    ];

    return Column(
      children: [
        _buildCodeHeader("class", "OurExpertise", "extends", "AgencyCapabilities"),
        const SizedBox(height: 50),
        Wrap(
          spacing: 24, runSpacing: 24, alignment: WrapAlignment.center,
          children: services.map((s) => _serviceCard(s, cardWidth)).toList(),
        ),
      ],
    );
  }

  Widget _serviceCard(_ServiceItem s, double width) {
    return _HoverCard(
      backgroundColor: s.isCore ? const Color(0xFF131A24) : kIdeDark,
      glowColor: s.isCore ? kAccentBlue : null,
      borderless: !s.isCore,
      child: Container(
        width: width, height: 260, padding: const EdgeInsets.all(28),
        decoration: s.isCore ? BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: kAccentBlue.withOpacity(0.5), width: 1.5)) : null,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ContinuousFloat(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: s.isCore ? kAccentBlue.withOpacity(0.15) : kIdePanel, shape: BoxShape.circle),
                    child: Icon(s.icon, color: s.isCore ? kAccentBlue : kTextLight, size: 32),
                  ),
                ),
                const SizedBox(height: 24),
                Text("\"${s.title}\"", textAlign: TextAlign.center, style: GoogleFonts.robotoMono(fontSize: 16, fontWeight: FontWeight.w700, color: kSyntaxString)),
                const SizedBox(height: 12),
                Text(s.desc, textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 13, color: kMuted, height: 1.6)),
              ],
            ),
            if (s.isCore)
              Positioned(
                top: -10, right: -10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(gradient: const LinearGradient(colors: [kAccentBlue, kAccentPurple]), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: kAccentBlue.withOpacity(0.4), blurRadius: 10)]),
                  child: Text("@PrimaryFocus()", style: GoogleFonts.robotoMono(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQ(bool isMobile) {
    final faqs = [
      {"q": "Do you only develop Mobile Apps?", "a": "While Native and Flutter Mobile Apps are our flagship expertise, we are a full-stack agency. We build lightweight WordPress sites, complex React/Next.js platforms, and Flutter Web Dashboards."},
      {"q": "Can you help market my app after launch?", "a": "Yes. Building the app is only half the battle. We provide comprehensive App Store Optimization (ASO), SEO, and targeted marketing campaigns to get your product in front of real users."},
    ];

    return Column(
      children: [
        _buildCodeHeader("Future<List<FAQ>>", "getCommonQueries", "async", ""),
        const SizedBox(height: 50),
        SizedBox(
          width: 800,
          child: Column(children: faqs.map((f) => _ModernFAQItem(question: f['q']!, answer: f['a']!)).toList()),
        )
      ],
    );
  }

  Widget _buildWhoWeAre(bool isMobile) {
    return Column(
      children: [
        Text("/* AGENCY OVERVIEW */", style: GoogleFonts.robotoMono(color: kSyntaxString, letterSpacing: 1.5, fontSize: 14)),
        const SizedBox(height: 16),
        _GradientText(
          text: "We Build Digital Empires.",
          style: GoogleFonts.poppins(fontSize: isMobile ? 28 : 40, fontWeight: FontWeight.w800),
          gradient: const LinearGradient(colors: [Colors.white, kTextLight]),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: 700,
          child: Text("ScaleAxis is an elite software & growth agency. We bridge the gap between premium Mobile engineering, intuitive Web design, and aggressive Marketing strategies to deliver products that dominate the market.", textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: 16, color: kMuted, height: 1.6)),
        ),
      ],
    );
  }

  Widget _buildProcessSection(bool isMobile) {
    final double cardWidth = isMobile ? 320 : 250;
    return Column(
      children: [
        _buildCodeHeader("void", "executeWorkflow", "()", ""),
        const SizedBox(height: 50),
        Wrap(
          spacing: 20, runSpacing: 20, alignment: WrapAlignment.center,
          children: [
            _processCard("01", "Discovery & SEO", "Analyzing requirements, tech stack feasibility, and market placement.", Icons.search, cardWidth),
            _processCard("02", "UI/UX Design", "Creating high-fidelity wireframes and engaging user journeys.", Icons.brush, cardWidth),
            _processCard("03", "Development", "Agile sprints across Mobile, Web, and scalable backends.", Icons.code, cardWidth),
            _processCard("04", "Launch & Market", "Deployment, ASO optimization, and active user acquisition.", Icons.rocket_launch_rounded, cardWidth),
          ],
        ),
      ],
    );
  }

  Widget _processCard(String num, String title, String desc, IconData icon, double width) {
    return _HoverCard(
      backgroundColor: kIdeDark,
      child: Container(
        width: width, height: 260, padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("step$num;", style: GoogleFonts.robotoMono(fontSize: 20, fontWeight: FontWeight.bold, color: kSyntaxKeyword)),
                _ContinuousFloat(duration: const Duration(seconds: 3), child: Icon(icon, color: kAccentBlue, size: 24)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: kTextLight)),
                const SizedBox(height: 10),
                Text(desc, style: GoogleFonts.inter(fontSize: 13, color: kMuted, height: 1.5)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestimonials(bool isMobile) {
    return Column(
      children: [
        Text("// WHAT CLIENTS SAY", style: GoogleFonts.robotoMono(color: kSyntaxString, letterSpacing: 1.5, fontSize: 14)),
        const SizedBox(height: 16),
        _GradientText(text: "Testimonials", style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold), gradient: const LinearGradient(colors: [Colors.white, kTextLight])),
        const SizedBox(height: 40),
        Wrap(
          spacing: 24, runSpacing: 24, alignment: WrapAlignment.center,
          children: [
            _testimonialCard("ScaleAxis built our Flutter Web command center and it is flawless.", "Ijaz Mohaiuddin", "CEO, Dayyan", isMobile),
            _testimonialCard("Their ASO strategies helped us secure our first 10k users within a month.", "Najeef Gillani", "Director, Gillani", isMobile),
          ],
        ),
      ],
    );
  }

  Widget _testimonialCard(String text, String author, String role, bool isMobile) {
    return _HoverCard(
      backgroundColor: kIdeDark,
      child: Container(
        width: isMobile ? 320 : 320, height: 240, padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.format_quote_rounded, color: kAccentPurple, size: 28),
                const SizedBox(height: 12),
                Text(text, style: GoogleFonts.inter(color: kTextLight, height: 1.5, fontSize: 13), maxLines: 4, overflow: TextOverflow.ellipsis),
              ],
            ),
            Row(
              children: [
                CircleAvatar(backgroundColor: kIdePanel, radius: 18, child: Text(author[0], style: const TextStyle(color: kAccentBlue, fontSize: 14, fontWeight: FontWeight.bold))),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(author, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: kTextLight, fontSize: 13)),
                      Text(role, style: GoogleFonts.robotoMono(fontSize: 11, color: kMuted)),
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

  Widget _buildCTA(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text("if (readyToScale) {", style: GoogleFonts.robotoMono(fontSize: 20, color: kSyntaxKeyword)),
          const SizedBox(height: 10),
          _GradientText(text: "letsConnect();", style: GoogleFonts.robotoMono(fontSize: 36, fontWeight: FontWeight.w800), gradient: const LinearGradient(colors: [Colors.white, kTextLight])),
          const SizedBox(height: 10),
          Text("}", style: GoogleFonts.robotoMono(fontSize: 20, color: kSyntaxKeyword)),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.code, color: kMuted, size: 20),
              const SizedBox(width: 8),
              Text("// EOF", style: GoogleFonts.robotoMono(color: kMuted, fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCodeHeader(String keyword1, String name, String keyword2, String parameter) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: GoogleFonts.robotoMono(fontSize: 28, fontWeight: FontWeight.bold),
        children: [
          TextSpan(text: "$keyword1 ", style: const TextStyle(color: kSyntaxKeyword)),
          TextSpan(text: "$name ", style: const TextStyle(color: kSyntaxClass)),
          if (keyword2.isNotEmpty) TextSpan(text: "$keyword2 ", style: const TextStyle(color: kSyntaxKeyword)),
          if (parameter.isNotEmpty) TextSpan(text: parameter, style: const TextStyle(color: kSyntaxClass)),
          const TextSpan(text: " {", style: TextStyle(color: kTextLight)),
        ],
      ),
    );
  }

  Widget _buildSectionContainer(BuildContext context, {required Widget child, Color? color}) {
    return Container(width: double.infinity, color: color ?? Colors.transparent, padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20), alignment: Alignment.center, child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1100), child: child));
  }
}

// ---- Reusable Components specific to Intro ---- //
class _ServiceItem {
  final IconData icon; final String title; final String desc; final bool isCore;
  _ServiceItem(this.icon, this.title, this.desc, {this.isCore = false});
}

class _GradientText extends StatelessWidget {
  const _GradientText({required this.text, required this.style, required this.gradient});
  final String text; final TextStyle style; final Gradient gradient;
  @override Widget build(BuildContext context) {
    return ShaderMask(blendMode: BlendMode.srcIn, shaderCallback: (bounds) => gradient.createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)), child: Text(text, style: style, textAlign: TextAlign.center));
  }
}

class _ContinuousFloat extends StatefulWidget {
  final Widget child; final Duration duration;
  const _ContinuousFloat({required this.child, this.duration = const Duration(seconds: 2)});
  @override State<_ContinuousFloat> createState() => _ContinuousFloatState();
}

class _ContinuousFloatState extends State<_ContinuousFloat> with SingleTickerProviderStateMixin {
  late AnimationController _c; late Animation<Offset> _a;
  @override void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration)..repeat(reverse: true);
    _a = Tween<Offset>(begin: const Offset(0, -0.05), end: const Offset(0, 0.05)).animate(CurvedAnimation(parent: _c, curve: Curves.easeInOutSine));
  }
  @override void dispose() { _c.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => SlideTransition(position: _a, child: widget.child);
}

// ... [SpeedLinesPainter, _FadeIn, _HoverCard, _ModernFAQItem, AnimatedCompanyHeader] remain identical to previous versions.

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
  late AnimationController _accelerationController;
  late Animation<double> _speedAnimation;
  late Ticker _ticker;
  Duration _lastElapsed = Duration.zero;
  final ValueNotifier<double> _lineProgress = ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _entranceController, curve: Curves.easeOutCubic));
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: _entranceController, curve: Curves.easeOutCubic));
    _hoverController = AnimationController(vsync: this, duration: const Duration(seconds: 4));
    _hoverAnimation = Tween<Offset>(begin: const Offset(0, -0.05), end: const Offset(0, 0.05)).animate(CurvedAnimation(parent: _hoverController, curve: Curves.easeInOutSine));
    _accelerationController = AnimationController(vsync: this, duration: const Duration(seconds: 10));
    _speedAnimation = Tween<double>(begin: 1.0, end: 7.0).animate(CurvedAnimation(parent: _accelerationController, curve: Curves.easeInQuad));

    _ticker = createTicker((elapsed) {
      final double deltaSeconds = (elapsed - _lastElapsed).inMilliseconds / 1000.0;
      _lastElapsed = elapsed;
      _lineProgress.value += deltaSeconds * _speedAnimation.value;
    });

    _entranceController.forward().then((_) {
      _hoverController.repeat(reverse: true);
      _accelerationController.forward();
      _ticker.start();
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
              FadeTransition(
                opacity: _fadeAnimation,
                child: ValueListenableBuilder<double>(
                  valueListenable: _lineProgress,
                  builder: (context, value, child) {
                    return CustomPaint(size: const Size(300, 160), painter: SpeedLinesPainter(progress: value));
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
                        boxShadow: [BoxShadow(color: const Color(0xFF58A6FF).withOpacity(0.3), blurRadius: 60, spreadRadius: 15)],
                      ),
                      child: ClipOval(
                        child: Image.asset("assets/sa_logo.png", fit: BoxFit.cover, errorBuilder: (c, o, s) => const Icon(Icons.rocket_launch, size: 70, color: Color(0xFF58A6FF))),
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
              _GradientText(
                text: "Architecting Digital Empires",
                style: GoogleFonts.poppins(fontSize: widget.isMobile ? 36 : 64, fontWeight: FontWeight.w800, height: 1.1),
                gradient: const LinearGradient(colors: [Colors.white, Color(0xFFC9D1D9)]),
              ),
              const SizedBox(height: 20),
              Text(
                "Mobile Native • Robust Web • ASO & SEO Marketing",
                textAlign: TextAlign.center,
                style: GoogleFonts.robotoMono(fontSize: widget.isMobile ? 12 : 16, color: const Color(0xFF58A6FF), letterSpacing: 1.2),
              ),
              const SizedBox(height: 20),
              Text(
                "We design, build, market, and scale full-stack software solutions.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: widget.isMobile ? 14 : 16, color: const Color(0xFF8B949E)),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }
}

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
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _isHovered || _isExpanded ? const Color(0xFF161B22) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isExpanded ? const Color(0xFF58A6FF).withOpacity(0.4) : (_isHovered ? const Color(0xFF30363D) : Colors.transparent),
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
                      style: GoogleFonts.robotoMono(fontWeight: FontWeight.w600, color: _isExpanded ? Colors.white : const Color(0xFFC9D1D9), fontSize: 14),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(Icons.keyboard_arrow_down, color: _isExpanded ? const Color(0xFF58A6FF) : const Color(0xFF8B949E), size: 28),
                  ),
                ],
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox(width: double.infinity, height: 0),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(widget.answer, style: GoogleFonts.inter(color: const Color(0xFF8B949E), height: 1.6, fontSize: 14)),
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
    final paint = Paint()..color = const Color(0xFF58A6FF)..strokeWidth = 1.0..strokeCap = StrokeCap.round;
    _drawLine(canvas, size, paint, yOffset: size.height * 0.2, length: 120, speedMultiplier: 1.5, startXOffset: 0.1);
    _drawLine(canvas, size, paint, yOffset: size.height * 0.4, length: 200, speedMultiplier: 1.0, startXOffset: 0.5);
    _drawLine(canvas, size, paint, yOffset: size.height * 0.65, length: 90, speedMultiplier: 1.8, startXOffset: 0.8);
    _drawLine(canvas, size, paint, yOffset: size.height * 0.85, length: 150, speedMultiplier: 1.2, startXOffset: 0.3);
  }
  void _drawLine(Canvas canvas, Size size, Paint paint, {required double yOffset, required double length, required double speedMultiplier, required double startXOffset}) {
    double rawProgress = ((progress * speedMultiplier) + startXOffset) % 1.0;
    double easedProgress = rawProgress * rawProgress * rawProgress;
    double totalWidth = size.width + length * 2;
    double currentX = totalWidth - (easedProgress * totalWidth);
    double startX = currentX - length;
    double endX = startX + length;
    double opacity = 1.0;
    if (endX < size.width * 0.3) opacity = (endX / (size.width * 0.3)).clamp(0.0, 1.0);
    if (startX > size.width * 0.7) opacity = opacity * ((size.width - startX) / (size.width * 0.3)).clamp(0.0, 1.0);
    paint.color = paint.color.withOpacity(opacity * 0.25);
    canvas.drawLine(Offset(startX, yOffset), Offset(endX, yOffset), paint);
  }
  @override
  bool shouldRepaint(covariant SpeedLinesPainter oldDelegate) => oldDelegate.progress != progress;
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
        return Opacity(opacity: opacity.clamp(0.0, 1.0), child: Transform.translate(offset: Offset(0, 30 * (1 - opacity)), child: child));
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
  final Color? glowColor;

  const _HoverCard({required this.child, this.disableScale = false, this.borderless = false, this.backgroundColor, this.glowColor});
  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    final activeGlow = widget.glowColor ?? const Color(0xFF58A6FF);
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
          borderRadius: BorderRadius.circular(8),
          border: widget.borderless ? null : Border.all(color: _isHovered ? activeGlow.withOpacity(0.5) : const Color(0xFF30363D), width: 1),
          boxShadow: _isHovered ? [BoxShadow(color: activeGlow.withOpacity(0.15), blurRadius: 30, offset: const Offset(0, 10))] : [],
        ),
        child: widget.child,
      ),
    );
  }
}