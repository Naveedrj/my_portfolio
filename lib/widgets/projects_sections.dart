import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../project_data.dart';
// Ensure these imports match your actual file names!
import 'contact_section.dart';
import 'intro_section.dart';

// =========================================================
// 🚀 MAIN SCREEN (Responsive Wrapper)
// =========================================================
class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1000) {
          return const _WebSplitLayout();
        } else {
          return const _MobileLayout();
        }
      },
    );
  }
}

// =========================================================
// 🖥️ WEB LAYOUT (Split Screen)
// =========================================================
class _WebSplitLayout extends StatefulWidget {
  const _WebSplitLayout();

  @override
  State<_WebSplitLayout> createState() => _WebSplitLayoutState();
}

class _WebSplitLayoutState extends State<_WebSplitLayout> {
  ProjectModel _selectedProject = portfolioData.first;

  static const Color kBg = Color(0xFF0D1117);
  static const Color kBorder = Color(0xFF30363D);
  static const Color kAccentBlue = Color(0xFF58A6FF);
  static const Color kTextLight = Color(0xFFC9D1D9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Stack(
        children: [
          // --- MAIN SPLIT CONTENT ---
          Row(
            children: [
              // --- LEFT PANEL: List ---
              Expanded(
                flex: 3,
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(right: BorderSide(color: kBorder)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 90), // Push content below the NavBar
                      _buildHeader(),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          itemCount: portfolioData.length,
                          itemBuilder: (context, index) {
                            final project = portfolioData[index];
                            final isSelected = project.title == _selectedProject.title;

                            // Entrance animation for list items
                            return TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: Duration(milliseconds: 400 + (index * 100)),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, child) {
                                return Transform.translate(
                                  offset: Offset(-20 * (1 - value), 0),
                                  child: Opacity(
                                    opacity: value,
                                    child: child,
                                  ),
                                );
                              },
                              child: _WebProjectListItem(
                                project: project,
                                isSelected: isSelected,
                                onTap: () {
                                  setState(() {
                                    _selectedProject = project;
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // --- RIGHT PANEL: Gallery & Details ---
              Expanded(
                flex: 7,
                child: Container(
                  padding: const EdgeInsets.only(top: 80), // Push content below the NavBar
                  // Smooth fade transition when selecting a new project
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child: _GalleryDetailView(
                      key: ValueKey(_selectedProject.title),
                      project: _selectedProject,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // --- FLOATING GLASSMORPHISM NAVBAR ---
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: kBg.withOpacity(0.8),
                  child: _buildNavBar(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- NAVBAR WIDGET ---
  Widget _buildNavBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
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
          Row(
            children: [
              _navLink("Home", () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const IntroSection()), (route) => false);
              }, isActive: false),
              const SizedBox(width: 40),
              // ACTIVE HIGHLIGHT FOR PORTFOLIO
              _navLink("Portfolio", () {}, isActive: true),
              const SizedBox(width: 40),
              _navLink("Contact Us", () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactUsScreen()));
              }, isActive: false),
            ],
          )
        ],
      ),
    );
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

  // --- UPDATED HEADER (Name removed since it's in the navbar) ---
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Our Projects",
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24)),
          const SizedBox(height: 6),
          Text("Select a project to view details",
              style: GoogleFonts.robotoMono(color: const Color(0xFF8B949E), fontSize: 12)),
        ],
      ),
    );
  }
}

class _WebProjectListItem extends StatefulWidget {
  final ProjectModel project;
  final bool isSelected;
  final VoidCallback onTap;

  const _WebProjectListItem({
    required this.project,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_WebProjectListItem> createState() => _WebProjectListItemState();
}

class _WebProjectListItemState extends State<_WebProjectListItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool active = widget.isSelected;
    final bool highlight = _isHovered || active;
    const Color kAccent = Color(0xFF58A6FF);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF1F242C) : (highlight ? const Color(0xFF161B22) : Colors.transparent),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: active ? kAccent.withOpacity(0.5) : (highlight ? const Color(0xFF30363D) : Colors.transparent),
            ),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                    color: active ? kAccent : const Color(0xFF30363D),
                    shape: BoxShape.circle,
                    boxShadow: active ? [BoxShadow(color: kAccent.withOpacity(0.4), blurRadius: 8)] : []
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.project.title,
                      style: GoogleFonts.poppins(
                        color: highlight ? Colors.white : const Color(0xFFC9D1D9),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.project.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                        color: const Color(0xFF8B949E),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (active)
                const Icon(Icons.arrow_forward_ios, color: kAccent, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// Component: The Right Side Gallery (Web)
// ---------------------------------------------------------
class _GalleryDetailView extends StatefulWidget {
  final ProjectModel project;

  const _GalleryDetailView({super.key, required this.project});

  @override
  State<_GalleryDetailView> createState() => _GalleryDetailViewState();
}

class _GalleryDetailViewState extends State<_GalleryDetailView> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final hasImages = widget.project.images.isNotEmpty;
    const kAccent = Color(0xFF58A6FF);

    return Row(
      children: [
        // 1. DETAILS SECTION
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.project.badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                        color: kAccent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: kAccent.withOpacity(0.3))),
                    child: Text(
                      widget.project.badge!.toUpperCase(),
                      style: GoogleFonts.robotoMono(
                          color: kAccent,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                Hero(
                  tag: 'title-${widget.project.title}',
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      widget.project.title,
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          height: 1.1),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.project.description,
                  style: GoogleFonts.roboto(
                      color: const Color(0xFFC9D1D9),
                      fontSize: 16,
                      height: 1.6),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.project.techStack
                      .map((t) => Chip(
                    label: Text(t),
                    backgroundColor: const Color(0xFF161B22),
                    labelStyle: GoogleFonts.robotoMono(color: const Color(0xFF8B949E), fontSize: 12),
                    side: const BorderSide(color: Color(0xFF30363D)),
                  ))
                      .toList(),
                ),
                const SizedBox(height: 32),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    if (widget.project.playStoreLink != null)
                      _StoreButton(
                        icon: Icons.android,
                        label: "Google Play",
                        onTap: () => launchUrl(Uri.parse(widget.project.playStoreLink!)),
                      ),
                    if (widget.project.appStoreLink != null)
                      _StoreButton(
                        icon: Icons.apple,
                        label: "App Store",
                        onTap: () => launchUrl(Uri.parse(widget.project.appStoreLink!)),
                      ),
                    // NEW: Handles launching the web URL
                    if (widget.project.webLink != null)
                      _StoreButton(
                        icon: Icons.language,
                        label: "Visit Website",
                        onTap: () => launchUrl(Uri.parse(widget.project.webLink!)),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // 2. MOCKUP SECTION
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: widget.project.isWeb ? 16.0 : 40.0),
                    child: widget.project.isWeb
                        ? _buildLaptopMockup(hasImages)
                        : _buildPhoneMockup(hasImages),
                  ),
                ),
                if (hasImages && widget.project.images.length > 1) ...[
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(widget.project.images.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentIndex == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == index ? kAccent : Colors.white24,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLaptopMockup(bool hasImages) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 850),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: const Color(0xFF161B22),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  border: Border.all(color: const Color(0xFF30363D), width: 2),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 40, offset: const Offset(0, 10))
                  ]
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    color: Colors.black,
                    child: hasImages ? _buildImageSlider() : _buildNoPreview(),
                  ),
                ),
              ),
            ),
            Container(
              height: 16,
              decoration: const BoxDecoration(
                color: Color(0xFF30363D),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              alignment: Alignment.topCenter,
              child: Container(
                width: 80,
                height: 4,
                decoration: const BoxDecoration(
                  color: Color(0xFF21262D),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneMockup(bool hasImages) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: AspectRatio(
          aspectRatio: 9 / 19.5,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: const Color(0xFF21262D),
                borderRadius: BorderRadius.circular(36),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 40, spreadRadius: 5, offset: const Offset(0, 10))
                ]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
                color: Colors.black,
                child: hasImages ? _buildImageSlider() : _buildNoPreview(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSlider() {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.project.images.length,
      onPageChanged: (index) => setState(() => _currentIndex = index),
      itemBuilder: (context, index) {
        return Image.asset(
          widget.project.images[index],
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          errorBuilder: (ctx, _, __) => Container(
            color: const Color(0xFF161B22),
            child: const Icon(Icons.broken_image, color: Colors.grey),
          ),
        );
      },
    );
  }

  Widget _buildNoPreview() {
    return Center(
      child: Text("No Preview", style: GoogleFonts.poppins(color: Colors.grey)),
    );
  }
}

// =========================================================
// 📱 MOBILE LAYOUT (List of Cards)
// =========================================================
class _MobileLayout extends StatelessWidget {
  const _MobileLayout();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1117), // Match background color seamlessly
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Our Portfolio",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0xFF30363D), height: 1.0), // Subtle border
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: portfolioData.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final project = portfolioData[index];

          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 400 + (index * 100)),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MobileDetailScreen(project: project)),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF161B22),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF30363D)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Hero(
                            tag: 'title-${project.title}',
                            child: Material(
                              color: Colors.transparent,
                              child: Text(project.title,
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                            ),
                          ),
                        ),
                        if (project.badge != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF58A6FF).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(project.badge!,
                                style: GoogleFonts.robotoMono(color: const Color(0xFF58A6FF), fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(project.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(color: const Color(0xFF8B949E), height: 1.4)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(project.isWeb ? Icons.laptop_mac : Icons.phone_iphone, color: Colors.grey, size: 14),
                        const SizedBox(width: 6),
                        Text(project.isWeb ? "Web Platform" : "Mobile App", style: GoogleFonts.roboto(color: Colors.grey, fontSize: 12)),
                        const Spacer(),
                        const Text("Tap to view details →", style: TextStyle(color: Color(0xFF58A6FF), fontSize: 12, fontWeight: FontWeight.bold))
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// =========================================================
// 📱 MOBILE DETAIL SCREEN (Navigated from List)
// =========================================================
class MobileDetailScreen extends StatefulWidget {
  final ProjectModel project;

  const MobileDetailScreen({super.key, required this.project});

  @override
  State<MobileDetailScreen> createState() => _MobileDetailScreenState();
}

class _MobileDetailScreenState extends State<MobileDetailScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    const kAccent = Color(0xFF58A6FF);
    final hasImages = widget.project.images.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- INFO SECTION ---
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'title-${widget.project.title}',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        widget.project.title,
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.project.description,
                    style: GoogleFonts.roboto(color: const Color(0xFFC9D1D9), fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: widget.project.techStack.map((t) => Chip(
                      label: Text(t),
                      backgroundColor: const Color(0xFF161B22),
                      labelStyle: GoogleFonts.robotoMono(color: const Color(0xFF8B949E), fontSize: 12),
                      side: const BorderSide(color: Color(0xFF30363D)),
                    )).toList(),
                  ),

                  // Store Links
                  if (widget.project.playStoreLink != null || widget.project.appStoreLink != null || widget.project.webLink != null) ...[
                    const SizedBox(height: 24),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          if (widget.project.playStoreLink != null)
                            _MobileStoreLink(icon: Icons.android, label: "Google Play", onTap: () => launchUrl(Uri.parse(widget.project.playStoreLink!))),

                          if (widget.project.playStoreLink != null && (widget.project.appStoreLink != null || widget.project.webLink != null))
                            const SizedBox(width: 12),

                          if (widget.project.appStoreLink != null)
                            _MobileStoreLink(icon: Icons.apple, label: "App Store", onTap: () => launchUrl(Uri.parse(widget.project.appStoreLink!))),

                          if (widget.project.appStoreLink != null && widget.project.webLink != null)
                            const SizedBox(width: 12),

                          // NEW: Handles launching the web URL on Mobile
                          if (widget.project.webLink != null)
                            _MobileStoreLink(icon: Icons.language, label: "Visit Website", onTap: () => launchUrl(Uri.parse(widget.project.webLink!))),
                        ],
                      ),
                    )
                  ]
                ],
              ),
            ),

            if (hasImages)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: widget.project.isWeb
                          ? _buildMobileViewLaptopMockup(hasImages)
                          : _buildMobileViewPhoneMockup(hasImages),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(widget.project.images.length, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentIndex == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentIndex == index ? kAccent : const Color(0xFF30363D),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildMobileViewLaptopMockup(bool hasImages) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: const Color(0xFF161B22),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border.all(color: const Color(0xFF30363D), width: 1.5),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))
              ]
          ),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Container(
                color: Colors.black,
                child: hasImages ? _buildImageSlider() : _buildNoPreview(),
              ),
            ),
          ),
        ),
        Container(
          height: 12,
          decoration: const BoxDecoration(
            color: Color(0xFF30363D),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
          ),
          alignment: Alignment.topCenter,
          child: Container(
            width: 50,
            height: 3,
            decoration: const BoxDecoration(
              color: Color(0xFF21262D),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(2)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileViewPhoneMockup(bool hasImages) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 550),
        child: AspectRatio(
          aspectRatio: 9 / 19.5,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: const Color(0xFF21262D),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))
                ]
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Container(
                color: Colors.black,
                child: hasImages ? _buildImageSlider() : _buildNoPreview(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSlider() {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.project.images.length,
      onPageChanged: (index) => setState(() => _currentIndex = index),
      itemBuilder: (context, index) {
        return Image.asset(
          widget.project.images[index],
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          errorBuilder: (ctx, _, __) => Container(
            color: const Color(0xFF161B22),
            child: const Icon(Icons.broken_image, color: Colors.grey),
          ),
        );
      },
    );
  }

  Widget _buildNoPreview() {
    return Center(
      child: Text("No Preview", style: GoogleFonts.poppins(color: Colors.grey)),
    );
  }
}

// =========================================================
// 🧰 HELPERS / BUTTONS
// =========================================================

class _StoreButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _StoreButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF21262D),
          foregroundColor: Colors.white,
          side: const BorderSide(color: Color(0xFF30363D)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
      ),
    );
  }
}

class _MobileStoreLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MobileStoreLink({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF58A6FF).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF58A6FF), size: 18),
            const SizedBox(width: 8),
            Text(label, style: GoogleFonts.roboto(color: const Color(0xFF58A6FF), fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}