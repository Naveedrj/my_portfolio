import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../project_data.dart'; // Ensure your data model framework matches this path
import 'theme.dart'; // Contains BloomTheme and LiquidGlass

// =========================================================
// 🚀 MAIN SCREEN (Responsive Wrapper)
// =========================================================
class ProjectPage extends StatelessWidget {
  const ProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1000) {
          return const _WebThreePanelLayout();
        } else {
          return const _MobileLayout();
        }
      },
    );
  }
}

// =========================================================
// 🖥️ WEB LAYOUT (True Three-Panel Architectural Split)
// =========================================================
class _WebThreePanelLayout extends StatefulWidget {
  const _WebThreePanelLayout();

  @override
  State<_WebThreePanelLayout> createState() => _WebThreePanelLayoutState();
}

class _WebThreePanelLayoutState extends State<_WebThreePanelLayout> {
  ProjectModel _selectedProject = portfolioData.first;
  bool _showMediaPanel = true; // State managing the visual reveal of Panel 3

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Main Horizon Structure Grid Row
          Padding(
            padding: const EdgeInsets.only(top: 100, bottom: 24, left: 24, right: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- PANEL 1: NAV ARCHIVE LIST (Flex 3) ---
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildArchiveHeader(),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(right: 16, left: 16),
                          physics: const BouncingScrollPhysics(),
                          itemCount: portfolioData.length,
                          itemBuilder: (context, index) {
                            final project = portfolioData[index];
                            final isSelected = project.title == _selectedProject.title;

                            return _WebProjectListItem(
                              project: project,
                              isSelected: isSelected,
                              onTap: () => setState(() => _selectedProject = project),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // --- PANEL 2: COMPONENT SPEC DETAILS (Flex 4) ---
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: LiquidGlass(
                      isStrong: true,
                      borderRadius: BorderRadius.circular(24),
                      padding: const EdgeInsets.all(48),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _CenterDetailView(
                          key: ValueKey('detail-${_selectedProject.title}'),
                          project: _selectedProject,
                        ),
                      ),
                    ),
                  ),
                ),

                // --- PANEL 3: HARDWARE MOCKUP REVEAL LAYER (Flex 3.5) ---
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOutCubic,
                  width: _showMediaPanel ? MediaQuery.of(context).size.width * 0.28 : 0.0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: _showMediaPanel ? 1.0 : 0.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: LiquidGlass(
                        isStrong: false,
                        borderRadius: BorderRadius.circular(24),
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          child: _RightMediaView(
                            key: ValueKey('media-${_selectedProject.title}'),
                            project: _selectedProject,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- UNIVERSAL CONTROLS NAVIGATION APP BAR ---
          Positioned(
            top: 0, left: 0, right: 0,
            child: _buildControlHeader(context),
          ),
        ],
      ),
    );
  }

  Widget _buildControlHeader(BuildContext context) {
    return LiquidGlass(
      borderRadius: BorderRadius.zero,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.blur_circular, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Text(
                "scaleaxis",
                style: BloomTheme.display.copyWith(fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: -0.5),
              ),
            ],
          ),
          Row(
            children: [
              // Media Eye Toggle Button Action Control
              InkWell(
                onTap: () => setState(() => _showMediaPanel = !_showMediaPanel),
                borderRadius: BorderRadius.circular(50),
                child: LiquidGlass(
                  borderRadius: BorderRadius.circular(50),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      Icon(_showMediaPanel ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 16, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(_showMediaPanel ? "Hide Media" : "Show Media", style: BloomTheme.display.copyWith(fontSize: 13)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Return Home Control Action Button
              InkWell(
                onTap: () => Navigator.pushReplacementNamed(context, '/'),
                borderRadius: BorderRadius.circular(50),
                child: LiquidGlass(
                  borderRadius: BorderRadius.circular(50),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back_ios_new_rounded, size: 12, color: Colors.white),
                      const SizedBox(width: 8),
                      Text("Return Home", style: BloomTheme.display.copyWith(fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildArchiveHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Growth Archive", style: BloomTheme.display.copyWith(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -1)),
          const SizedBox(height: 4),
          Text("Select an infrastructure to layout details", style: BloomTheme.body.copyWith(fontSize: 13, color: BloomTheme.textMuted)),
        ],
      ),
    );
  }
}

class _WebProjectListItem extends StatefulWidget {
  final ProjectModel project;
  final bool isSelected;
  final VoidCallback onTap;

  const _WebProjectListItem({required this.project, required this.isSelected, required this.onTap});

  @override
  State<_WebProjectListItem> createState() => _WebProjectListItemState();
}

class _WebProjectListItemState extends State<_WebProjectListItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool active = widget.isSelected;
    final bool highlight = _isHovered || active;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 12),
          transform: Matrix4.identity()..translate(highlight ? 4.0 : 0.0, 0.0),
          child: LiquidGlass(
            isStrong: active,
            borderRadius: BorderRadius.circular(16),
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 6, height: 6,
                  decoration: BoxDecoration(color: active ? Colors.white : Colors.white24, shape: BoxShape.circle),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.project.title,
                        style: BloomTheme.display.copyWith(color: highlight ? Colors.white : BloomTheme.textSecondary, fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.project.description,
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: BloomTheme.body.copyWith(color: BloomTheme.textMuted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                if (active) const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// CENTER PANEL: METRIC TEXT DETAILS
// ==========================================
class _CenterDetailView extends StatelessWidget {
  final ProjectModel project;
  const _CenterDetailView({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (project.badge != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: Text(
              project.badge!.toUpperCase(),
              style: BloomTheme.body.copyWith(fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.0),
            ),
          ),
          const SizedBox(height: 20),
        ],
        Text(
          project.title,
          style: BloomTheme.display.copyWith(fontSize: 48, fontWeight: FontWeight.bold, letterSpacing: -1.5),
        ),
        const SizedBox(height: 20),
        Text(
          project.description,
          style: BloomTheme.body.copyWith(fontSize: 16, height: 1.6, color: BloomTheme.textSecondary),
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: project.techStack.map((t) => LiquidGlass(
            borderRadius: BorderRadius.circular(8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Text(t, style: BloomTheme.body.copyWith(fontSize: 12, fontWeight: FontWeight.w500)),
          )).toList(),
        ),
        const SizedBox(height: 40),
        Wrap(
          spacing: 12, runSpacing: 12,
          children: [
            if (project.playStoreLink != null) _StoreButton(icon: Icons.android_rounded, label: "Play Store", url: project.playStoreLink!),
            if (project.appStoreLink != null) _StoreButton(icon: Icons.apple_rounded, label: "App Store", url: project.appStoreLink!),
            if (project.webLink != null) _StoreButton(icon: Icons.language_rounded, label: "Visit Platform", url: project.webLink!),
          ],
        ),
      ],
    );
  }
}

// ==========================================
// RIGHT PANEL: ISOLATED HARDWARE FRAME
// ==========================================
class _RightMediaView extends StatefulWidget {
  final ProjectModel project;
  const _RightMediaView({super.key, required this.project});

  @override
  State<_RightMediaView> createState() => _RightMediaViewState();
}

class _RightMediaViewState extends State<_RightMediaView> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasImages = widget.project.images.isNotEmpty;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: widget.project.isWeb ? _buildLaptopFrame(hasImages) : _buildPhoneFrame(hasImages),
          ),
        ),
        if (hasImages && widget.project.images.length > 1) ...[
          const SizedBox(height: 24),
          _SliderIndicatorDots(count: widget.project.images.length, currentIndex: _currentIndex),
        ],
      ],
    );
  }

  Widget _buildPhoneFrame(bool hasImages) {
    return Center(
      child: AspectRatio(
        aspectRatio: 9 / 19.5,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.02),
            borderRadius: BorderRadius.circular(36),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: Container(
              color: Colors.black,
              child: hasImages ? _buildImageSlider() : _buildBlankState(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLaptopFrame(bool hasImages) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border.all(color: Colors.white.withOpacity(0.15)),
            ),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  color: Colors.black,
                  child: hasImages ? _buildImageSlider() : _buildBlankState(),
                ),
              ),
            ),
          ),
          Container(
            height: 10,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
          ),
        ],
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
            color: Colors.black,
            child: const Icon(Icons.broken_image_outlined, color: Colors.white24, size: 32),
          ),
        );
      },
    );
  }

  Widget _buildBlankState() => const Center(child: Icon(Icons.remove_red_eye_outlined, color: Colors.white24));
}

// =========================================================
// 📱 MOBILE LAYOUT (Responsive Alternate Card View)
// =========================================================
class _MobileLayout extends StatelessWidget {
  const _MobileLayout();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacementNamed(context, '/'),
        ),
        title: Text("Our Portfolio", style: BloomTheme.display.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        itemCount: portfolioData.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final project = portfolioData[index];
          return InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MobileDetailScreen(project: project))),
            child: LiquidGlass(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(project.title, style: BloomTheme.display.copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                      if (project.badge != null) ...[
                        const SizedBox(width: 8),
                        _BadgeContainer(text: project.badge!),
                      ]
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(project.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: BloomTheme.body.copyWith(color: BloomTheme.textMuted, height: 1.4)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(project.isWeb ? Icons.laptop_mac : Icons.phone_iphone, color: BloomTheme.textMuted, size: 14),
                      const SizedBox(width: 6),
                      Text(project.isWeb ? "Web App" : "Mobile App", style: BloomTheme.body.copyWith(color: BloomTheme.textMuted, fontSize: 12)),
                      const Spacer(),
                      Text("Details →", style: BloomTheme.display.copyWith(fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// =========================================================
// 📱 MOBILE DETAIL SYSTEM (Stateful Framework Window)
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
  bool _showMedia = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasImages = widget.project.images.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Portion 1: Context details panel card container
            LiquidGlass(
              isStrong: true,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.project.badge != null) ...[
                    _BadgeContainer(text: widget.project.badge!),
                    const SizedBox(height: 12),
                  ],
                  Text(widget.project.title, style: BloomTheme.display.copyWith(fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.5)),
                  const SizedBox(height: 12),
                  Text(widget.project.description, style: BloomTheme.body.copyWith(fontSize: 15, height: 1.5, color: BloomTheme.textSecondary)),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 6, runSpacing: 8,
                    children: widget.project.techStack.map((t) => _GlassTechPill(text: t)).toList(),
                  ),
                  if (widget.project.playStoreLink != null || widget.project.appStoreLink != null || widget.project.webLink != null) ...[
                    const SizedBox(height: 24),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          if (widget.project.playStoreLink != null) _MobileStoreLink(icon: Icons.android, label: "Play Store", url: widget.project.playStoreLink!),
                          if (widget.project.appStoreLink != null) ...[
                            const SizedBox(width: 8),
                            _MobileStoreLink(icon: Icons.apple, label: "App Store", url: widget.project.appStoreLink!),
                          ],
                          if (widget.project.webLink != null) ...[
                            const SizedBox(width: 8),
                            _MobileStoreLink(icon: Icons.language, label: "Website", url: widget.project.webLink!),
                          ],
                        ],
                      ),
                    )
                  ]
                ],
              ),
            ),

            // Portion 2: Action control visual slider reveal switch
            if (hasImages) ...[
              const SizedBox(height: 24),
              Center(
                child: InkWell(
                  onTap: () => setState(() => _showMedia = !_showMedia),
                  borderRadius: BorderRadius.circular(50),
                  child: LiquidGlass(
                    borderRadius: BorderRadius.circular(50),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_showMedia ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(_showMedia ? "Hide Media" : "View Gallery", style: BloomTheme.display.copyWith(fontSize: 14)),
                        const SizedBox(width: 8),
                        Icon(_showMedia ? Icons.expand_less : Icons.expand_more, color: Colors.white, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Portion 3: Structural container context grid
              AnimatedSize(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOutCubic,
                alignment: Alignment.topCenter,
                child: !_showMedia
                    ? const SizedBox(width: double.infinity)
                    : LiquidGlass(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  child: Column(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: widget.project.isWeb ? 200 : 400),
                        child: widget.project.isWeb ? _buildMobileLaptopMockup() : _buildMobilePhoneMockup(),
                      ),
                      if (widget.project.images.length > 1) ...[
                        const SizedBox(height: 16),
                        _SliderIndicatorDots(count: widget.project.images.length, currentIndex: _currentIndex),
                      ]
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMobilePhoneMockup() {
    return AspectRatio(
      aspectRatio: 9 / 19.5,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.02),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(color: Colors.black, child: _buildImageSlider()),
        ),
      ),
    );
  }

  Widget _buildMobileLaptopMockup() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.02),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            border: Border.all(color: Colors.white.withOpacity(0.12)),
          ),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Container(color: Colors.black, child: _buildImageSlider()),
            ),
          ),
        ),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
          ),
        ),
      ],
    );
  }

  Widget _buildImageSlider() {
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.project.images.length,
      onPageChanged: (index) => setState(() => _currentIndex = index),
      itemBuilder: (context, index) {
        return Image.asset(widget.project.images[index], fit: BoxFit.cover, alignment: Alignment.topCenter);
      },
    );
  }
}

// ==========================================
// REUSABLE GLASS OBJECT COMPONENTS
// ==========================================
class _GlassTechPill extends StatelessWidget {
  final String text;
  const _GlassTechPill({required this.text});

  @override
  Widget build(BuildContext context) {
    return LiquidGlass(
      borderRadius: BorderRadius.circular(8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Text(text, style: BloomTheme.body.copyWith(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white)),
    );
  }
}

class _StoreButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;
  const _StoreButton({required this.icon, required this.label, required this.url});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => launchUrl(Uri.parse(url)),
      borderRadius: BorderRadius.circular(12),
      child: LiquidGlass(
        borderRadius: BorderRadius.circular(12),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(label, style: BloomTheme.display.copyWith(fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _MobileStoreLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;
  const _MobileStoreLink({required this.icon, required this.label, required this.url});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => launchUrl(Uri.parse(url)),
      borderRadius: BorderRadius.circular(8),
      child: LiquidGlass(
        borderRadius: BorderRadius.circular(8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 14),
            const SizedBox(width: 8),
            Text(label, style: BloomTheme.display.copyWith(fontSize: 12, fontWeight: FontWeight.w600)),
          ],
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Text(
        text.toUpperCase(),
        style: BloomTheme.body.copyWith(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5, color: Colors.white),
      ),
    );
  }
}

class _SliderIndicatorDots extends StatelessWidget {
  final int count;
  final int currentIndex;
  const _SliderIndicatorDots({required this.count, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: currentIndex == index ? 18 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: currentIndex == index ? Colors.white : Colors.white24,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}