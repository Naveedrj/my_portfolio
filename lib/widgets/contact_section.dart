import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // REQUIRED FOR WHATSAPP ICON

// Make sure these match your actual project structure
import 'package:web_portfolio/widgets/projects_sections.dart';
import 'intro_section.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  // 🎨 Theme Colors
  static const Color kBg = Color(0xFF0D1117);
  static const Color kPanel = Color(0xFF161B22);
  static const Color kPanelLight = Color(0xFF1C2128);
  static const Color kBorder = Color(0xFF30363D);
  static const Color kAccentBlue = Color(0xFF58A6FF);
  static const Color kTextLight = Color(0xFFC9D1D9);
  static const Color kMuted = Color(0xFF8B949E);
  static const Color kGreen = Color(0xFF2EA043);
  static const Color kPurple = Color(0xFFBC8CFF);

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> with TickerProviderStateMixin {
  late AnimationController _entranceController;

  // --- TEAM DATA ---
  final List<Map<String, String>> teamMembers = [
    {"name": "Naveed Ur Rehman", "role": "Founder & Developer", "image": "assets/naveed.jpeg", "email": "rananveed123@gmail.com"},
    {"name": "M. Hammad", "role": "Co-Founder & Developer", "image": "assets/hammad.jpeg", "email": "hammadsohail888@gmail.com"},
    {"name": "Taha Yousaf", "role": "Amazon consultant & Business", "image": "assets/taha.jpeg", "email": ""},
    {"name": "Usman Ahmad", "role": "Full Stack Flutter Developer", "image": "assets/usman.jpeg", "email": ""},
    {"name": "Zain Naseer", "role": "Business Developer", "image": "assets/zain.jpeg", "email": ""},
  ];

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
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

    return Scaffold(
      backgroundColor: ContactUsScreen.kBg,
      appBar: isMobile
          ? AppBar(
        backgroundColor: ContactUsScreen.kBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      )
          : null,
      body: Stack(
        children: [
          // Background Glows
          const Positioned(top: -100, right: -100, child: _PulsingGlow(color: ContactUsScreen.kAccentBlue, size: 500, duration: Duration(seconds: 5))),
          const Positioned(bottom: -150, left: -150, child: _PulsingGlow(color: ContactUsScreen.kPurple, size: 600, duration: Duration(seconds: 6), delay: Duration(seconds: 2))),

          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  children: [
                    SizedBox(height: isMobile ? 40 : 120),

                    // --- HEADER ---
                    _FadeIn(
                      controller: _entranceController,
                      delay: 0,
                      child: Column(
                        children: [
                          Text("OUR PEOPLE", style: GoogleFonts.robotoMono(fontSize: 14, fontWeight: FontWeight.bold, color: ContactUsScreen.kAccentBlue, letterSpacing: 2)),
                          const SizedBox(height: 16),
                          Text("Meet The ScaleAxis Team.", textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: isMobile ? 36 : 56, fontWeight: FontWeight.w800, color: Colors.white, height: 1.1)),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 600,
                            child: Text("We are a collective of developers, designers, and strategists turning complex problems into elegant digital solutions.", textAlign: TextAlign.center, style: GoogleFonts.inter(fontSize: isMobile ? 16 : 18, color: ContactUsScreen.kMuted, height: 1.5)),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 80),

                    // --- TEAM LAYOUT ---
                    if (isMobile)
                      Column(
                        children: teamMembers.asMap().entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: _FadeIn(
                              controller: _entranceController,
                              delay: 200 + (entry.key * 100),
                              child: SizedBox(
                                width: screenWidth - 48,
                                child: _HoverCard(
                                  builder: (context, isHovered) => _ProfileContent(member: entry.value, isHovered: isHovered),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      )
                    else
                      Column(
                        children: [
                          // Top Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildDesktopTeamCard(teamMembers[0], 200),
                              const SizedBox(width: 24),
                              _buildDesktopTeamCard(teamMembers[1], 300),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Bottom Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildDesktopTeamCard(teamMembers[2], 400),
                              const SizedBox(width: 24),
                              _buildDesktopTeamCard(teamMembers[3], 500),
                              const SizedBox(width: 24),
                              _buildDesktopTeamCard(teamMembers[4], 600),
                            ],
                          ),
                        ],
                      ),

                    const SizedBox(height: 120),

                    // --- CONTACT SECTION ---
                    _FadeIn(
                      controller: _entranceController,
                      delay: 700,
                      child: Column(
                        children: [
                          Text("GET IN TOUCH", style: GoogleFonts.robotoMono(color: ContactUsScreen.kAccentBlue, letterSpacing: 2, fontSize: 14, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          Text("Let's Start a Conversation", textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: isMobile ? 28 : 40, fontWeight: FontWeight.bold, color: Colors.white, height: 1.1)),
                          const SizedBox(height: 40),
                          _UnifiedContactSection(isMobile: isMobile),
                        ],
                      ),
                    ),

                    const SizedBox(height: 100),
                    _FadeIn(controller: _entranceController, delay: 900, child: Text("© 2024 ScaleAxis. Made in Pakistan.", style: GoogleFonts.robotoMono(color: ContactUsScreen.kMuted, fontSize: 12))),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),

          // --- NAVBAR ---
          if (!isMobile)
            Positioned(
              top: 0, left: 0, right: 0,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: ContactUsScreen.kBg.withOpacity(0.8),
                    child: _buildNavBar(isMobile, context),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDesktopTeamCard(Map<String, String> member, int delay) {
    return SizedBox(
      width: 320,
      child: _FadeIn(
        controller: _entranceController,
        delay: delay,
        child: _HoverCard(
          builder: (context, isHovered) => _ProfileContent(member: member, isHovered: isHovered),
        ),
      ),
    );
  }

  Widget _buildNavBar(bool isMobile, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40, vertical: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: ContactUsScreen.kBorder)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset("assets/sa_logo.png", width: 32, height: 32, fit: BoxFit.cover, errorBuilder: (c, o, s) => const Icon(Icons.code, color: ContactUsScreen.kAccentBlue)),
              ),
              const SizedBox(width: 12),
              Text("ScaleAxis", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: ContactUsScreen.kTextLight)),
            ],
          ),
          if (!isMobile)
            Row(
              children: [
                _navLink("Home", () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const IntroSection()), (route) => false);
                }, isActive: false),
                const SizedBox(width: 40),
                _navLink("Portfolio", () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const PortfolioScreen()), (route) => false);
                }, isActive: false),
                const SizedBox(width: 40),
                _navLink("Contact Us", () {}, isActive: true),
              ],
            )
        ],
      ),
    );
  }

  Widget _navLink(String text, VoidCallback onTap, {bool isActive = false}) {
    return InkWell(
      onTap: onTap, hoverColor: Colors.transparent, splashColor: Colors.transparent, highlightColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: GoogleFonts.poppins(
              color: isActive ? ContactUsScreen.kAccentBlue : ContactUsScreen.kTextLight,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              shadows: isActive ? [Shadow(color: ContactUsScreen.kAccentBlue.withOpacity(0.5), blurRadius: 10)] : [],
            ),
          ),
          if (isActive)
            Container(margin: const EdgeInsets.only(top: 4), width: 4, height: 4, decoration: const BoxDecoration(color: ContactUsScreen.kAccentBlue, shape: BoxShape.circle))
        ],
      ),
    );
  }
}

// ================== Shared Components ==================

class _ProfileContent extends StatelessWidget {
  final Map<String, String> member;
  final bool isHovered;

  const _ProfileContent({required this.member, required this.isHovered});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Top Banner & Overlapping Avatar Stack
        SizedBox(
          height: 120,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  gradient: LinearGradient(
                    colors: isHovered
                        ? [ContactUsScreen.kAccentBlue.withOpacity(0.3), ContactUsScreen.kPurple.withOpacity(0.3)]
                        : [ContactUsScreen.kBorder, ContactUsScreen.kPanelLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              Positioned(
                top: 30,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: ContactUsScreen.kPanel,
                    shape: BoxShape.circle,
                    border: Border.all(color: isHovered ? ContactUsScreen.kAccentBlue : ContactUsScreen.kBorder, width: 2),
                  ),
                  child: ClipOval(
                    child: Container(
                      width: 80,
                      height: 80,
                      color: ContactUsScreen.kBg,
                      child: Image.asset(
                        member["image"]!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 40, color: ContactUsScreen.kAccentBlue),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Text Content below Avatar
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Column(
            children: [
              Text(
                member["name"]!,
                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: ContactUsScreen.kAccentBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  member["role"]!,
                  style: GoogleFonts.robotoMono(color: ContactUsScreen.kAccentBlue, fontSize: 11, fontWeight: FontWeight.w600),
                  maxLines: 1,
                ),
              ),

              if (member["email"]!.isNotEmpty) ...[
                const SizedBox(height: 24),
                const Divider(color: ContactUsScreen.kBorder, height: 1),
                const SizedBox(height: 16),

                // Use the new custom TeamEmailRow here
                _TeamEmailRow(email: member["email"]!),
              ]
            ],
          ),
        )
      ],
    );
  }
}

// --- NEW WIDGET: Dedicated Email Row for Profile Cards ---
// --- NEW WIDGET: Dedicated Email Row for Profile Cards ---
class _TeamEmailRow extends StatefulWidget {
  final String email;

  const _TeamEmailRow({required this.email});

  @override
  State<_TeamEmailRow> createState() => _TeamEmailRowState();
}

class _TeamEmailRowState extends State<_TeamEmailRow> {
  bool _copied = false;

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.email));
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  Future<void> _launchEmail() async {
    final Uri url = Uri(scheme: 'mailto', path: widget.email);
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02), // Very subtle background
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ContactUsScreen.kBorder.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          // Email Text (Scales down if too long)
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                _copied ? "Copied!" : widget.email,
                style: GoogleFonts.robotoMono(
                  color: _copied ? ContactUsScreen.kGreen : ContactUsScreen.kTextLight,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Copy Icon Button
          _ActionButton(
            icon: _copied ? Icons.check : Icons.copy_rounded,
            color: _copied ? ContactUsScreen.kGreen : ContactUsScreen.kMuted,
            onTap: _copyToClipboard,
          ),
          const SizedBox(width: 4),

          // Launch (Mail) Icon Button
          _ActionButton(
            icon: Icons.open_in_new_rounded,
            color: ContactUsScreen.kAccentBlue,
            onTap: _launchEmail,
          ),
        ],
      ),
    );
  }
}

// --- PREMIUM UNIFIED CONTACT SECTION ---
class _UnifiedContactSection extends StatelessWidget {
  final bool isMobile;
  const _UnifiedContactSection({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ContactUsScreen.kPanel,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: ContactUsScreen.kBorder.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 30, offset: const Offset(0, 15)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: isMobile
            ? Column(
          children: [
            _HoverableContactColumn(
                icon: Icons.business,
                title: "ScaleAxis HQ",
                subtitle: "Specializing in cross-platform digital solutions.",
                isMobile: isMobile
            ),
            _buildHorizontalGradientDivider(),
            _HoverableContactColumn(
                icon: Icons.email_outlined,
                title: "Email Us",
                subtitle: "Drop us a line anytime.",
                type: _InteractionType.email,
                interactDataList: const ["scaleaxisofficials@gmail.com"],
                isMobile: isMobile
            ),
            _buildHorizontalGradientDivider(),
            _HoverableContactColumn(
                icon: Icons.phone_android,
                title: "Call / WhatsApp",
                subtitle: "Reach out to us directly.",
                type: _InteractionType.phone,
                interactDataList: const ["+92 312 7632386", "+92 313 0778785"],
                isMobile: isMobile
            ),
          ],
        )
            : IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: _HoverableContactColumn(
                      icon: Icons.business,
                      title: "ScaleAxis HQ",
                      subtitle: "Specializing in cross-platform digital solutions.",
                      isMobile: isMobile
                  )
              ),
              _buildVerticalGradientDivider(),
              Expanded(
                  child: _HoverableContactColumn(
                      icon: Icons.email_outlined,
                      title: "Email Us",
                      subtitle: "Drop us a line anytime.",
                      type: _InteractionType.email,
                      interactDataList: const ["scaleaxisofficials@gmail.com"],
                      isMobile: isMobile
                  )
              ),
              _buildVerticalGradientDivider(),
              Expanded(
                  child: _HoverableContactColumn(
                      icon: Icons.phone_android,
                      title: "Call / WhatsApp",
                      subtitle: "Reach out to us directly.",
                      type: _InteractionType.phone,
                      interactDataList: const ["+92 312 7632386", "+92 313 0778785"],
                      isMobile: isMobile
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalGradientDivider() {
    return Container(
      width: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            ContactUsScreen.kBorder.withOpacity(0.8),
            ContactUsScreen.kBorder.withOpacity(0.8),
            Colors.transparent,
          ],
          stops: const [0.0, 0.2, 0.8, 1.0],
        ),
      ),
    );
  }

  Widget _buildHorizontalGradientDivider() {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.transparent,
            ContactUsScreen.kBorder.withOpacity(0.8),
            ContactUsScreen.kBorder.withOpacity(0.8),
            Colors.transparent,
          ],
          stops: const [0.0, 0.2, 0.8, 1.0],
        ),
      ),
    );
  }
}

// --- STATEFUL COLUMN FOR INDIVIDUAL HOVER EFFECTS ---
class _HoverableContactColumn extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final _InteractionType? type;
  final List<String>? interactDataList;
  final bool isMobile;

  const _HoverableContactColumn({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.type,
    this.interactDataList,
    required this.isMobile,
  });

  @override
  State<_HoverableContactColumn> createState() => _HoverableContactColumnState();
}

class _HoverableContactColumnState extends State<_HoverableContactColumn> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        color: _isHovered ? Colors.white.withOpacity(0.02) : Colors.transparent,
        padding: EdgeInsets.all(widget.isMobile ? 32 : 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _isHovered
                    ? ContactUsScreen.kAccentBlue.withOpacity(0.15)
                    : ContactUsScreen.kAccentBlue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: _isHovered
                        ? ContactUsScreen.kAccentBlue.withOpacity(0.3)
                        : Colors.transparent
                ),
                boxShadow: _isHovered ? [
                  BoxShadow(color: ContactUsScreen.kAccentBlue.withOpacity(0.2), blurRadius: 20, spreadRadius: -5)
                ] : [],
              ),
              child: Icon(
                  widget.icon,
                  color: _isHovered ? Colors.white : ContactUsScreen.kAccentBlue,
                  size: 28
              ),
            ),
            const SizedBox(height: 24),

            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: GoogleFonts.poppins(
                  color: _isHovered ? ContactUsScreen.kAccentBlue : Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
              child: Text(widget.title),
            ),
            const SizedBox(height: 8),
            Text(
                widget.subtitle,
                style: GoogleFonts.inter(color: ContactUsScreen.kMuted, height: 1.5, fontSize: 14)
            ),

            if (widget.type != null && widget.interactDataList != null) ...[
              const SizedBox(height: 24),
              ...widget.interactDataList!.map((data) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: _InteractiveRow(
                  icon: widget.type == _InteractionType.phone ? Icons.phone : Icons.email,
                  text: data,
                  type: widget.type!,
                ),
              )).toList(),
            ]
          ],
        ),
      ),
    );
  }
}

enum _InteractionType { email, phone }

// --- INTERACTIVE ROW ---
class _InteractiveRow extends StatefulWidget {
  final IconData icon;
  final String text;
  final _InteractionType type;
  final bool isCompact;

  const _InteractiveRow({
    required this.icon,
    required this.text,
    required this.type,
    this.isCompact = false,
  });

  @override
  State<_InteractiveRow> createState() => _InteractiveRowState();
}

class _InteractiveRowState extends State<_InteractiveRow> {
  bool _copied = false;
  bool _hovering = false;

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.text));
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () { if (mounted) setState(() => _copied = false); });
  }

  Future<void> _launchCall() async {
    final Uri url = Uri(scheme: 'tel', path: widget.text.replaceAll(' ', '').replaceAll('\n', ''));
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  Future<void> _launchWhatsApp() async {
    String cleanNumber = widget.text.replaceAll(RegExp(r'[^\d]'), '');
    final Uri url = Uri.parse("https://wa.me/$cleanNumber");
    if (await canLaunchUrl(url)) await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> _launchEmail() async {
    final Uri url = Uri(scheme: 'mailto', path: widget.text);
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: _hovering ? Colors.white.withOpacity(0.05) : ContactUsScreen.kBg.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8)
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _copyToClipboard,
                child: Row(
                  children: [
                    Icon(_copied ? Icons.check_circle : widget.icon, size: 14, color: _copied ? ContactUsScreen.kGreen : (_hovering ? ContactUsScreen.kAccentBlue : ContactUsScreen.kMuted)),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                          _copied ? "Copied!" : widget.text,
                          style: GoogleFonts.robotoMono(color: _copied ? ContactUsScreen.kGreen : (_hovering ? Colors.white : ContactUsScreen.kTextLight), fontSize: 13),
                          overflow: TextOverflow.ellipsis
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (widget.isCompact) const Spacer(),

            if (widget.type == _InteractionType.phone) ...[
              _ActionButton(
                  icon: Icons.call,
                  color: ContactUsScreen.kAccentBlue,
                  onTap: _launchCall
              ),
              const SizedBox(width: 8),
              _ActionButton(
                  customIcon: const FaIcon(FontAwesomeIcons.whatsapp, size: 16, color: ContactUsScreen.kGreen),
                  color: ContactUsScreen.kGreen,
                  onTap: _launchWhatsApp
              ),
            ] else ...[
              _ActionButton(
                  icon: Icons.send_rounded,
                  color: ContactUsScreen.kAccentBlue,
                  onTap: _launchEmail
              ),
            ],

            if (widget.isCompact) const Spacer(),
          ],
        ),
      ),
    );
  }
}

// --- ACTION BUTTON ---
class _ActionButton extends StatefulWidget {
  final IconData? icon;
  final Widget? customIcon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({this.icon, this.customIcon, required this.color, required this.onTap});

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _btnHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _btnHovered = true),
      onExit: (_) => setState(() => _btnHovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: _btnHovered ? widget.color.withOpacity(0.2) : widget.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8)
          ),
          child: widget.customIcon ?? Icon(widget.icon, size: 16, color: widget.color),
        ),
      ),
    );
  }
}

class _HoverCard extends StatefulWidget {
  final Widget Function(BuildContext context, bool isHovered) builder;
  const _HoverCard({required this.builder});
  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -8.0 : 0.0),
        decoration: BoxDecoration(
            color: ContactUsScreen.kPanel,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _isHovered ? ContactUsScreen.kAccentBlue.withOpacity(0.5) : ContactUsScreen.kBorder),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5)),
              if (_isHovered) BoxShadow(color: ContactUsScreen.kAccentBlue.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 10)),
            ]
        ),
        child: widget.builder(context, _isHovered),
      ),
    );
  }
}

class _PulsingGlow extends StatefulWidget {
  final Color color;
  final double size;
  final Duration duration;
  final Duration? delay;
  const _PulsingGlow({required this.color, required this.size, required this.duration, this.delay});
  @override
  State<_PulsingGlow> createState() => _PulsingGlowState();
}

class _PulsingGlowState extends State<_PulsingGlow> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine));
    _opacityAnimation = Tween<double>(begin: 0.01, end: 0.04).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine));
    if (widget.delay != null) { Future.delayed(widget.delay!, () { if (mounted) _controller.repeat(reverse: true); }); } else { _controller.repeat(reverse: true); }
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: Container(width: widget.size, height: widget.size, decoration: BoxDecoration(shape: BoxShape.circle, color: widget.color.withOpacity(_opacityAnimation.value), boxShadow: [BoxShadow(color: widget.color.withOpacity(_opacityAnimation.value), blurRadius: 100, spreadRadius: 30)])),
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
        return Opacity(opacity: curve.value, child: Transform.translate(offset: Offset(0, 30 * (1 - curve.value)), child: child));
      },
      child: child,
    );
  }
}