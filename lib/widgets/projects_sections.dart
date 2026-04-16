import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

// Make sure this points to your actual data file
import '../project_data.dart';

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

// IDE Theme Constants
class IdeTheme {
  static const Color kBg = Color(0xFF0D1117);
  static const Color kIdePanel = Color(0xFF161B22);
  static const Color kIdeDark = Color(0xFF0A0D12);
  static const Color kBorder = Color(0xFF30363D);
  static const Color kAccentBlue = Color(0xFF58A6FF);
  static const Color kAccentPurple = Color(0xFFBC8DFF);
  static const Color kTextLight = Color(0xFFC9D1D9);
  static const Color kMuted = Color(0xFF8B949E);
  static const Color kSuccess = Color(0xFF238636);

  // Syntax Highlighting
  static const Color kSyntaxKeyword = Color(0xFFFF7B72);
  static const Color kSyntaxString = Color(0xFFA5D6FF);
  static const Color kSyntaxClass = Color(0xFFD2A8FF);
  static const Color kSyntaxType = Color(0xFF79C0FF);
  static const Color kSyntaxComment = Color(0xFF8B949E);
}

// =========================================================
// 🖥️ WEB LAYOUT (Split Screen IDE)
// =========================================================
class _WebSplitLayout extends StatefulWidget {
  const _WebSplitLayout();

  @override
  State<_WebSplitLayout> createState() => _WebSplitLayoutState();
}

class _WebSplitLayoutState extends State<_WebSplitLayout> {
  ProjectModel _selectedProject = portfolioData.first;

  @override
  Widget build(BuildContext context) {
    // Note: No Scaffold or Navbar here. Handled by IdeBaseScreen.
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // --- LEFT PANEL: File Explorer ---
        Container(
          width: 300,
          decoration: const BoxDecoration(
            color: IdeTheme.kIdePanel,
            border: Border(right: BorderSide(color: IdeTheme.kBorder)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildExplorerHeader(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: portfolioData.length,
                  itemBuilder: (context, index) {
                    final project = portfolioData[index];
                    final isSelected = project.title == _selectedProject.title;

                    return _IdeFileListItem(
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

        // --- RIGHT PANEL: Editor & Preview ---
        Expanded(
          child: Container(
            color: IdeTheme.kBg,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
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
    );
  }

  Widget _buildExplorerHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: IdeTheme.kBorder)),
      ),
      child: Row(
        children: [
          const Icon(Icons.keyboard_arrow_down, color: IdeTheme.kMuted, size: 16),
          const SizedBox(width: 8),
          Text(
            "PORTFOLIO_PROJECTS",
            style: GoogleFonts.robotoMono(
              color: IdeTheme.kTextLight,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _IdeFileListItem extends StatefulWidget {
  final ProjectModel project;
  final bool isSelected;
  final VoidCallback onTap;

  const _IdeFileListItem({required this.project, required this.isSelected, required this.onTap});

  @override
  State<_IdeFileListItem> createState() => _IdeFileListItemState();
}

class _IdeFileListItemState extends State<_IdeFileListItem> {
  bool _isHovered = false;

  // Converts "UE Customer App" -> "ue_customer_app.dart"
  String _toFileName(String title) {
    return "${title.toLowerCase().replaceAll(' ', '_')}.dart";
  }

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
        child: Container(
          color: active ? IdeTheme.kAccentBlue.withOpacity(0.1) : (highlight ? IdeTheme.kBg : Colors.transparent),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            children: [
              Icon(
                widget.project.isWeb ? Icons.html : Icons.flutter_dash,
                color: widget.project.isWeb ? Colors.orangeAccent : IdeTheme.kAccentBlue,
                size: 16,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _toFileName(widget.project.title),
                  style: GoogleFonts.robotoMono(
                    color: active ? IdeTheme.kAccentBlue : (highlight ? IdeTheme.kTextLight : IdeTheme.kMuted),
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// Component: The Right Side Editor/Gallery (Web)
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

  String _toClassName(String title) {
    return title.replaceAll(' ', '');
  }

  @override
  Widget build(BuildContext context) {
    final hasImages = widget.project.images.isNotEmpty;

    return Row(
      children: [
        // 1. CODE EDITOR SECTION (Details)
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge as Annotation
                if (widget.project.badge != null)
                  Text(
                    "@ProjectBadge('${widget.project.badge}')",
                    style: GoogleFonts.robotoMono(color: IdeTheme.kAccentPurple, fontSize: 14, fontWeight: FontWeight.bold),
                  ),

                // Class Declaration
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.robotoMono(fontSize: 24, fontWeight: FontWeight.bold, height: 1.5),
                    children: [
                      const TextSpan(text: "class ", style: TextStyle(color: IdeTheme.kSyntaxKeyword)),
                      TextSpan(text: "${_toClassName(widget.project.title)} ", style: const TextStyle(color: IdeTheme.kSyntaxClass)),
                      const TextSpan(text: "extends ", style: TextStyle(color: IdeTheme.kSyntaxKeyword)),
                      TextSpan(text: widget.project.isWeb ? "WebPlatform" : "MobileApp", style: const TextStyle(color: IdeTheme.kSyntaxClass)),
                      const TextSpan(text: " {", style: TextStyle(color: IdeTheme.kTextLight)),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Description as a Block Comment
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    "/**\n * ${widget.project.description.replaceAll('\n', '\n * ')}\n */",
                    style: GoogleFonts.robotoMono(color: IdeTheme.kSyntaxComment, fontSize: 14, height: 1.6),
                  ),
                ),

                const SizedBox(height: 24),

                // Tech Stack as a List
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.robotoMono(fontSize: 14),
                          children: const [
                            TextSpan(text: "List", style: TextStyle(color: IdeTheme.kSyntaxClass)),
                            TextSpan(text: "<", style: TextStyle(color: IdeTheme.kTextLight)),
                            TextSpan(text: "String", style: TextStyle(color: IdeTheme.kSyntaxClass)),
                            TextSpan(text: "> ", style: TextStyle(color: IdeTheme.kTextLight)),
                            TextSpan(text: "techStack ", style: TextStyle(color: IdeTheme.kSyntaxType)),
                            TextSpan(text: "= [", style: TextStyle(color: IdeTheme.kTextLight)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8, runSpacing: 8,
                        children: widget.project.techStack.map((t) => _TechChip(text: t)).toList(),
                      ),
                      const SizedBox(height: 8),
                      const Text("];", style: TextStyle(color: IdeTheme.kTextLight, fontFamily: 'Roboto Mono', fontSize: 14)),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Action Buttons
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Wrap(
                    spacing: 12, runSpacing: 12,
                    children: [
                      if (widget.project.playStoreLink != null)
                        _IdeRunButton(icon: Icons.android, label: "Run PlayStore", color: IdeTheme.kSuccess, onTap: () => launchUrl(Uri.parse(widget.project.playStoreLink!))),
                      if (widget.project.appStoreLink != null)
                        _IdeRunButton(icon: Icons.apple, label: "Run AppStore", color: IdeTheme.kAccentBlue, onTap: () => launchUrl(Uri.parse(widget.project.appStoreLink!))),
                      if (widget.project.webLink != null)
                        _IdeRunButton(icon: Icons.language, label: "Launch Web", color: IdeTheme.kAccentPurple, onTap: () => launchUrl(Uri.parse(widget.project.webLink!))),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                const Text("}", style: TextStyle(color: IdeTheme.kTextLight, fontFamily: 'Roboto Mono', fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),

        // 2. MOCKUP/PREVIEW SECTION
        Expanded(
          flex: 6,
          child: Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: IdeTheme.kIdeDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: IdeTheme.kBorder),
            ),
            child: Column(
              children: [
                // Preview Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: const BoxDecoration(
                    color: IdeTheme.kIdePanel,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    border: Border(bottom: BorderSide(color: IdeTheme.kBorder)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.preview, color: IdeTheme.kMuted, size: 16),
                      const SizedBox(width: 8),
                      Text("Previewer", style: GoogleFonts.robotoMono(color: IdeTheme.kTextLight, fontSize: 12)),
                      const Spacer(),
                      Row(
                        children: [
                          Container(width: 10, height: 10, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.redAccent)),
                          const SizedBox(width: 6),
                          Container(width: 10, height: 10, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.orangeAccent)),
                          const SizedBox(width: 6),
                          Container(width: 10, height: 10, decoration: const BoxDecoration(shape: BoxShape.circle, color: IdeTheme.kSuccess)),
                        ],
                      )
                    ],
                  ),
                ),
                // Mockup
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: widget.project.isWeb ? _buildLaptopMockup(hasImages) : _buildPhoneMockup(hasImages),
                        ),
                        if (hasImages && widget.project.images.length > 1) ...[
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(widget.project.images.length, (index) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: _currentIndex == index ? 24 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: _currentIndex == index ? IdeTheme.kAccentBlue : IdeTheme.kBorder,
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
            ),
          ),
        ),
      ],
    );
  }

  // --- Web Mockups ---
  Widget _buildLaptopMockup(bool hasImages) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 850),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF161B22),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                border: Border.all(color: IdeTheme.kBorder, width: 2),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(color: Colors.black, child: hasImages ? _buildImageSlider() : _buildNoPreview()),
                ),
              ),
            ),
            Container(
              height: 12,
              decoration: const BoxDecoration(color: IdeTheme.kBorder, borderRadius: BorderRadius.vertical(bottom: Radius.circular(8))),
              alignment: Alignment.topCenter,
              child: Container(width: 80, height: 3, decoration: const BoxDecoration(color: Color(0xFF21262D), borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneMockup(bool hasImages) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: AspectRatio(
          aspectRatio: 9 / 19.5,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: const Color(0xFF21262D),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: IdeTheme.kBorder, width: 2)
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(color: Colors.black, child: hasImages ? _buildImageSlider() : _buildNoPreview()),
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
          errorBuilder: (ctx, _, __) => Container(color: IdeTheme.kIdePanel, child: const Icon(Icons.broken_image, color: IdeTheme.kMuted)),
        );
      },
    );
  }

  Widget _buildNoPreview() => Center(child: Text("// No Preview Data", style: GoogleFonts.robotoMono(color: IdeTheme.kMuted)));
}

// =========================================================
// 📱 MOBILE LAYOUT (List of IDE Snippet Cards)
// =========================================================
class _MobileLayout extends StatelessWidget {
  const _MobileLayout();

  String _toFileName(String title) => "${title.toLowerCase().replaceAll(' ', '_')}.dart";

  @override
  Widget build(BuildContext context) {
    // Scaffold without Appbar, matches IdeBaseScreen perfectly
    return Scaffold(
      backgroundColor: IdeTheme.kBg,
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: portfolioData.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final project = portfolioData[index];

          return InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MobileDetailScreen(project: project)),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: IdeTheme.kIdePanel,
                borderRadius: BorderRadius.circular(8), // Square IDE look
                border: Border.all(color: IdeTheme.kBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(project.isWeb ? Icons.html : Icons.flutter_dash, color: project.isWeb ? Colors.orangeAccent : IdeTheme.kAccentBlue, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            _toFileName(project.title),
                            style: GoogleFonts.robotoMono(color: IdeTheme.kAccentBlue, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                      if (project.badge != null)
                        Text("@${project.badge!.replaceAll(' ', '')}", style: GoogleFonts.robotoMono(color: IdeTheme.kAccentPurple, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                      "// ${project.description}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.robotoMono(color: IdeTheme.kSyntaxComment, fontSize: 12, height: 1.4)
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.play_arrow, color: IdeTheme.kSuccess, size: 16),
                      const SizedBox(width: 6),
                      Text("Run Preview", style: GoogleFonts.robotoMono(color: IdeTheme.kSuccess, fontSize: 12)),
                      const Spacer(),
                      Text("View Source →", style: GoogleFonts.robotoMono(color: IdeTheme.kMuted, fontSize: 12))
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
// 📱 MOBILE DETAIL SCREEN (Full Screen Editor View)
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
  String _toFileName(String title) => "${title.toLowerCase().replaceAll(' ', '_')}.dart";
  String _toClassName(String title) => title.replaceAll(' ', '');

  @override
  Widget build(BuildContext context) {
    final hasImages = widget.project.images.isNotEmpty;

    return Scaffold(
      backgroundColor: IdeTheme.kBg,
      appBar: AppBar(
        backgroundColor: IdeTheme.kIdePanel,
        elevation: 0,
        iconTheme: const IconThemeData(color: IdeTheme.kTextLight),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.project.isWeb ? Icons.html : Icons.flutter_dash, color: widget.project.isWeb ? Colors.orangeAccent : IdeTheme.kAccentBlue, size: 16),
            const SizedBox(width: 8),
            Text(_toFileName(widget.project.title), style: GoogleFonts.robotoMono(color: IdeTheme.kTextLight, fontSize: 14)),
          ],
        ),
        bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(color: IdeTheme.kBorder, height: 1)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- CODE SECTION ---
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.project.badge != null)
                    Text("@ProjectBadge('${widget.project.badge}')", style: GoogleFonts.robotoMono(color: IdeTheme.kAccentPurple, fontSize: 12, fontWeight: FontWeight.bold)),

                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.robotoMono(fontSize: 20, fontWeight: FontWeight.bold, height: 1.5),
                      children: [
                        const TextSpan(text: "class ", style: TextStyle(color: IdeTheme.kSyntaxKeyword)),
                        TextSpan(text: "${_toClassName(widget.project.title)} ", style: const TextStyle(color: IdeTheme.kSyntaxClass)),
                        const TextSpan(text: "extends ", style: TextStyle(color: IdeTheme.kSyntaxKeyword)),
                        TextSpan(text: widget.project.isWeb ? "Web" : "App", style: const TextStyle(color: IdeTheme.kSyntaxClass)),
                        const TextSpan(text: " {", style: TextStyle(color: IdeTheme.kTextLight)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      "/**\n * ${widget.project.description.replaceAll('\n', '\n * ')}\n */",
                      style: GoogleFonts.robotoMono(color: IdeTheme.kSyntaxComment, fontSize: 12, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Wrap(
                      spacing: 8, runSpacing: 8,
                      children: widget.project.techStack.map((t) => _TechChip(text: t)).toList(),
                    ),
                  ),

                  if (widget.project.playStoreLink != null || widget.project.appStoreLink != null || widget.project.webLink != null) ...[
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            if (widget.project.playStoreLink != null)
                              _IdeRunButton(icon: Icons.android, label: "Google Play", color: IdeTheme.kSuccess, onTap: () => launchUrl(Uri.parse(widget.project.playStoreLink!))),
                            if (widget.project.playStoreLink != null && (widget.project.appStoreLink != null || widget.project.webLink != null))
                              const SizedBox(width: 8),
                            if (widget.project.appStoreLink != null)
                              _IdeRunButton(icon: Icons.apple, label: "App Store", color: IdeTheme.kAccentBlue, onTap: () => launchUrl(Uri.parse(widget.project.appStoreLink!))),
                            if (widget.project.appStoreLink != null && widget.project.webLink != null)
                              const SizedBox(width: 8),
                            if (widget.project.webLink != null)
                              _IdeRunButton(icon: Icons.language, label: "Website", color: IdeTheme.kAccentPurple, onTap: () => launchUrl(Uri.parse(widget.project.webLink!))),
                          ],
                        ),
                      ),
                    )
                  ],
                  const SizedBox(height: 16),
                  const Text("}", style: TextStyle(color: IdeTheme.kTextLight, fontFamily: 'Roboto Mono', fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            // --- GALLERY SECTION ---
            if (hasImages)
              Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: IdeTheme.kIdeDark,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: IdeTheme.kBorder)
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: const BoxDecoration(
                        color: IdeTheme.kIdePanel,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                        border: Border(bottom: BorderSide(color: IdeTheme.kBorder)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.preview, color: IdeTheme.kMuted, size: 14),
                          const SizedBox(width: 8),
                          Text("Previewer", style: GoogleFonts.robotoMono(color: IdeTheme.kTextLight, fontSize: 12)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                      child: widget.project.isWeb ? _buildMobileViewLaptopMockup(hasImages) : _buildMobileViewPhoneMockup(hasImages),
                    ),
                    if (hasImages && widget.project.images.length > 1) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(widget.project.images.length, (index) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentIndex == index ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentIndex == index ? IdeTheme.kAccentBlue : IdeTheme.kBorder,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  // --- Mobile Specific Mockups ---
  Widget _buildMobileViewLaptopMockup(bool hasImages) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFF161B22),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            border: Border.all(color: IdeTheme.kBorder),
          ),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Container(color: Colors.black, child: hasImages ? _buildImageSlider() : _buildNoPreview()),
            ),
          ),
        ),
        Container(
          height: 8,
          decoration: const BoxDecoration(color: IdeTheme.kBorder, borderRadius: BorderRadius.vertical(bottom: Radius.circular(8))),
        ),
      ],
    );
  }

  Widget _buildMobileViewPhoneMockup(bool hasImages) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 450),
        child: AspectRatio(
          aspectRatio: 9 / 19.5,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: const Color(0xFF21262D),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: IdeTheme.kBorder)
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(color: Colors.black, child: hasImages ? _buildImageSlider() : _buildNoPreview()),
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
        return Image.asset(widget.project.images[index], fit: BoxFit.cover, alignment: Alignment.topCenter);
      },
    );
  }

  Widget _buildNoPreview() => Center(child: Text("// No Preview", style: GoogleFonts.robotoMono(color: IdeTheme.kMuted)));
}

// =========================================================
// 🧰 HELPERS / BUTTONS (IDE Styled)
// =========================================================

// Tech Stack Chip
class _TechChip extends StatelessWidget {
  final String text;
  const _TechChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: IdeTheme.kSyntaxString.withOpacity(0.1),
        border: Border.all(color: IdeTheme.kSyntaxString.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        "\"$text\"",
        style: GoogleFonts.robotoMono(color: IdeTheme.kSyntaxString, fontSize: 12),
      ),
    );
  }
}

// Run Button
class _IdeRunButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _IdeRunButton({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          border: Border.all(color: color.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.play_arrow, color: color, size: 14),
            const SizedBox(width: 4),
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 8),
            Text(label, style: GoogleFonts.robotoMono(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}