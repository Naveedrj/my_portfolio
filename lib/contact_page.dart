import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'theme.dart'; // Ensure this points to your file with BloomTheme and LiquidGlass

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 1024;

    return Scaffold(
      backgroundColor: Colors.transparent, // Let the background video shine through
      body: SafeArea(
        child: Column(
          children: [
            // Shared Top Navigation
            _buildTopNavigationBar(isMobile, context),

            // Main Content Area
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40, vertical: isMobile ? 20 : 40),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 🖥️ DESKTOP SPLIT LAYOUT
  // ==========================================
  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left Column: Massive Typography
        Expanded(
          flex: 10,
          child: Padding(
            padding: const EdgeInsets.only(right: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const _AnimatedEntrance(
                  delay: 0,
                  child: _BadgeContainer(text: "Get In Touch"),
                ),
                const SizedBox(height: 24),
                _AnimatedEntrance(
                  delay: 100,
                  child: Text(
                    "Let's shape the",
                    style: BloomTheme.display.copyWith(fontSize: 64, height: 1.1, letterSpacing: -2),
                  ),
                ),
                _AnimatedEntrance(
                  delay: 200,
                  child: Text(
                    "future together.",
                    style: BloomTheme.serifItalic.copyWith(fontSize: 64, height: 1.1),
                  ),
                ),
                const SizedBox(height: 24),
                _AnimatedEntrance(
                  delay: 300,
                  child: Text(
                    "Whether you're looking to integrate AI into your existing workflow or build a cross-platform architecture from the ground up, our engineers are ready.",
                    style: BloomTheme.body.copyWith(fontSize: 18, color: BloomTheme.textSecondary, height: 1.6),
                  ),
                ),
                const SizedBox(height: 60),
                _AnimatedEntrance(
                  delay: 400,
                  child: Text(
                    "© 2024 ScaleAxis. Made in Pakistan.",
                    style: BloomTheme.body.copyWith(color: BloomTheme.textMuted, fontSize: 12, letterSpacing: 1.0),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Right Column: Staggered Glass Contact Cards
        Expanded(
          flex: 8,
          child: Column(
            children: const [
              _AnimatedEntrance(
                delay: 200,
                child: _ContactCard(
                  icon: Icons.business,
                  title: "ScaleAxis HQ",
                  subtitle: "Specializing in cross-platform digital solutions.",
                ),
              ),
              SizedBox(height: 24),
              _AnimatedEntrance(
                delay: 350,
                child: _ContactCard(
                  icon: Icons.mail_outline,
                  title: "Email Us",
                  subtitle: "Drop us a line anytime.",
                  email: "scaleaxisofficials@gmail.com",
                ),
              ),
              SizedBox(height: 24),
              _AnimatedEntrance(
                delay: 500,
                child: _ContactCard(
                  icon: Icons.phone_android,
                  title: "Call / WhatsApp",
                  subtitle: "Reach out to us directly.",
                  phoneList: ["+92 312 7632386", "+92 313 0778785"],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 📱 MOBILE LAYOUT
  // ==========================================
  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _AnimatedEntrance(delay: 0, child: _BadgeContainer(text: "Get In Touch")),
        const SizedBox(height: 24),
        _AnimatedEntrance(
          delay: 100,
          child: Text("Let's shape the", style: BloomTheme.display.copyWith(fontSize: 44, height: 1.1, letterSpacing: -1.5)),
        ),
        _AnimatedEntrance(
          delay: 200,
          child: Text("future.", style: BloomTheme.serifItalic.copyWith(fontSize: 44, height: 1.1)),
        ),
        const SizedBox(height: 20),
        _AnimatedEntrance(
          delay: 300,
          child: Text(
            "Whether you're looking to integrate AI into your workflow or build cross-platform apps, our team is ready.",
            style: BloomTheme.body.copyWith(fontSize: 15, color: BloomTheme.textSecondary, height: 1.6),
          ),
        ),
        const SizedBox(height: 60),

        // Cards
        const _AnimatedEntrance(
          delay: 400,
          child: _ContactCard(
            icon: Icons.business,
            title: "ScaleAxis HQ",
            subtitle: "Specializing in cross-platform solutions.",
          ),
        ),
        const SizedBox(height: 16),
        const _AnimatedEntrance(
          delay: 500,
          child: _ContactCard(
            icon: Icons.mail_outline,
            title: "Email Us",
            subtitle: "Drop us a line anytime.",
            email: "scaleaxisofficials@gmail.com",
          ),
        ),
        const SizedBox(height: 16),
        const _AnimatedEntrance(
          delay: 600,
          child: _ContactCard(
            icon: Icons.phone_android,
            title: "Call / WhatsApp",
            subtitle: "Reach out to us directly.",
            phoneList: ["+92 312 7632386", "+92 313 0778785"],
          ),
        ),

        const SizedBox(height: 60),
        _AnimatedEntrance(
          delay: 700,
          child: Center(
            child: Text("© 2024 ScaleAxis. Made in Pakistan.", style: BloomTheme.body.copyWith(color: BloomTheme.textMuted, fontSize: 12)),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // ==========================================
  // TOP NAVIGATION BAR
  // ==========================================
  Widget _buildTopNavigationBar(bool isMobile, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20.0 : 40.0, vertical: 24.0),
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
              _NavButton(title: "Return Home", route: '/', isAction: false),
              if (!isMobile) ...[
                const SizedBox(width: 12),
                _NavButton(title: "Meet the Team", route: '/team', isAction: true),
              ]
            ],
          ),
        ],
      ),
    );
  }
}

// ==========================================
// INTERACTIVE GLASS CONTACT CARD
// ==========================================
class _ContactCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? email;
  final List<String>? phoneList;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.email,
    this.phoneList,
  });

  @override
  State<_ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<_ContactCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          ..translate(0.0, _isHovered ? -6.0 : 0.0)
          ..scale(_isHovered ? 1.01 : 1.0),
        child: LiquidGlass(
          isStrong: _isHovered, // Blur intensifies on hover
          borderRadius: BorderRadius.circular(24),
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(_isHovered ? 0.1 : 0.03),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(_isHovered ? 0.3 : 0.05)),
                    ),
                    child: Icon(widget.icon, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.title, style: BloomTheme.display.copyWith(fontSize: 20, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(widget.subtitle, style: BloomTheme.body.copyWith(color: BloomTheme.textSecondary, fontSize: 13, height: 1.4)),
                      ],
                    ),
                  ),
                ],
              ),

              // Interaction Rows
              if (widget.email != null) ...[
                const SizedBox(height: 24),
                _InteractiveRow(icon: Icons.email_outlined, text: widget.email!, isEmail: true),
              ],
              if (widget.phoneList != null) ...[
                const SizedBox(height: 24),
                ...widget.phoneList!.map((phone) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _InteractiveRow(icon: Icons.phone_outlined, text: phone, isEmail: false),
                )),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// INTERACTIVE ACTION ROW (COPY / MAIL / WHATSAPP)
// ==========================================
class _InteractiveRow extends StatefulWidget {
  final IconData icon;
  final String text;
  final bool isEmail;

  const _InteractiveRow({required this.icon, required this.text, required this.isEmail});

  @override
  State<_InteractiveRow> createState() => _InteractiveRowState();
}

class _InteractiveRowState extends State<_InteractiveRow> {
  bool _copied = false;

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.text));
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  Future<void> _launchAction() async {
    if (widget.isEmail) {
      final Uri url = Uri(scheme: 'mailto', path: widget.text);
      if (await canLaunchUrl(url)) await launchUrl(url);
    } else {
      final Uri url = Uri(scheme: 'tel', path: widget.text.replaceAll(' ', ''));
      if (await canLaunchUrl(url)) await launchUrl(url);
    }
  }

  Future<void> _launchWhatsApp() async {
    String cleanNumber = widget.text.replaceAll(RegExp(r'[^\d]'), '');
    final Uri url = Uri.parse("https://wa.me/$cleanNumber");
    if (await canLaunchUrl(url)) await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _copyToClipboard,
              child: Row(
                children: [
                  Icon(_copied ? Icons.check_circle_outline : widget.icon, size: 16, color: _copied ? Colors.white : BloomTheme.textMuted),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      _copied ? "Copied to clipboard!" : widget.text,
                      style: BloomTheme.body.copyWith(color: _copied ? Colors.white : BloomTheme.textSecondary, fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (!widget.isEmail) ...[
            _ActionButton(icon: Icons.call_outlined, onTap: _launchAction),
            const SizedBox(width: 8),
            _ActionButton(customIcon: const FaIcon(FontAwesomeIcons.whatsapp, size: 14, color: Colors.white), onTap: _launchWhatsApp),
          ] else ...[
            _ActionButton(icon: Icons.arrow_outward_rounded, onTap: _launchAction),
          ],
        ],
      ),
    );
  }
}

// ==========================================
// REUSABLE UI TOKENS
// ==========================================
class _ActionButton extends StatefulWidget {
  final IconData? icon;
  final Widget? customIcon;
  final VoidCallback onTap;

  const _ActionButton({this.icon, this.customIcon, required this.onTap});

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
            color: Colors.white.withOpacity(_btnHovered ? 0.15 : 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(_btnHovered ? 0.3 : 0.0)),
          ),
          child: widget.customIcon ?? Icon(widget.icon, size: 16, color: Colors.white),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String title;
  final String route;
  final bool isAction;

  const _NavButton({required this.title, required this.route, required this.isAction});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushReplacementNamed(context, route),
      borderRadius: BorderRadius.circular(50),
      child: LiquidGlass(
        isStrong: isAction,
        borderRadius: BorderRadius.circular(50),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Text(title, style: BloomTheme.display.copyWith(fontSize: 13, fontWeight: FontWeight.w500)),
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
        style: BloomTheme.body.copyWith(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.white),
      ),
    );
  }
}

// Beautiful Staggered Entrance Animation
class _AnimatedEntrance extends StatelessWidget {
  final int delay;
  final Widget child;

  const _AnimatedEntrance({required this.delay, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        // Calculate a delayed value so elements slide in one after the other
        final double adjustedValue = (value - (delay / 2000)).clamp(0.0, 1.0);
        final double opacity = (adjustedValue * 2).clamp(0.0, 1.0); // Fade in faster

        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, 40 * (1 - adjustedValue)), // Slide up
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}