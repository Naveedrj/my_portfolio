import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import your actual screen files
import 'package:web_portfolio/widgets/intro_section.dart';
import 'package:web_portfolio/widgets/contact_section.dart';
import 'package:web_portfolio/widgets/projects_sections.dart'; // Ensure correct import

class IdeBaseScreen extends StatefulWidget {
  const IdeBaseScreen({super.key});

  @override
  State<IdeBaseScreen> createState() => _IdeBaseScreenState();
}

class _IdeBaseScreenState extends State<IdeBaseScreen> {
  // IDE Theme Colors
  static const Color kBg = Color(0xFF0D1117);
  static const Color kIdePanel = Color(0xFF161B22);
  static const Color kIdeDark = Color(0xFF0A0D12);
  static const Color kBorder = Color(0xFF30363D);
  static const Color kAccentBlue = Color(0xFF58A6FF);
  static const Color kAccentPurple = Color(0xFFBC8DFF);
  static const Color kTextLight = Color(0xFFC9D1D9);
  static const Color kMuted = Color(0xFF8B949E);
  static const Color kSuccess = Color(0xFF238636);

  // State Management for active file
  String _activeFile = "intro_section.dart";

  // List of open tabs
  final List<String> _openTabs = [
    "intro_section.dart",
    "portfolio_screen.dart",
    "contact_section.dart",
  ];

  void _openFile(String fileName) {
    setState(() {
      _activeFile = fileName;
      if (!_openTabs.contains(fileName)) {
        _openTabs.add(fileName);
      }
    });
  }

  void _closeTab(String fileName) {
    setState(() {
      _openTabs.remove(fileName);
      if (_openTabs.isNotEmpty) {
        _activeFile = _openTabs.last;
      } else {
        _activeFile = "";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 1000;

    return Scaffold(
      backgroundColor: kIdePanel,
      body: Column(
        children: [
          if (!isMobile) _buildIdeMenuBar(),
          _buildIdeToolbar(isMobile),
          Expanded(
            child: Row(
              children: [
                if (!isMobile) _buildIdeSidebar(),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: kBg,
                      border: Border(
                        left: BorderSide(color: kBorder, width: 1),
                        top: BorderSide(color: kBorder, width: 1),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tabs wrapped in SingleChildScrollView for mobile overflow protection
                        SizedBox(
                          height: 40,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: _buildIdeTabs(),
                          ),
                        ),
                        if (!isMobile) _buildBreadcrumbs(),

                        // --- ACTUAL SCREEN RENDERER ---
                        Expanded(
                          child: _buildActiveContent(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!isMobile) _buildIdeBottomBar(),
        ],
      ),
    );
  }

  // --- Dynamic Content Switcher ---
  Widget _buildActiveContent() {
    switch (_activeFile) {
      case "intro_section.dart":
        return const IntroSection();
      case "portfolio_screen.dart":
        return const PortfolioScreen();
      case "contact_section.dart":
        return const ContactUsScreen();
      default:
        return Center(
          child: Text(
            "// No editor is active. Open a file from the Project explorer.",
            style: GoogleFonts.robotoMono(color: kMuted),
          ),
        );
    }
  }

  // --- IDE Components ---
  Widget _buildIdeMenuBar() {
    final items = ["File", "Edit", "View", "Navigate", "Code", "Analyze", "Refactor", "Build", "Run", "Help"];
    return Container(
      height: 30, width: double.infinity, color: kIdePanel,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.android, color: kSuccess, size: 16),
          const SizedBox(width: 16),
          // Wrapped in Expanded & SingleChildScrollView to prevent text overflow on smaller desktop screens
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(item, style: GoogleFonts.robotoMono(color: kTextLight, fontSize: 12)),
                )).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdeToolbar(bool isMobile) {
    return Container(
      height: 40, width: double.infinity, color: kIdePanel,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.folder_open, color: kMuted, size: 18),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: kIdeDark, borderRadius: BorderRadius.circular(4), border: Border.all(color: kBorder)),
            child: Row(
              mainAxisSize: MainAxisSize.min, // Keep container tight
              children: [
                const Icon(Icons.phone_android, color: kAccentBlue, size: 14),
                const SizedBox(width: 8),
                Text("app", style: GoogleFonts.robotoMono(color: kTextLight, fontSize: 12)),
                const Icon(Icons.arrow_drop_down, color: kMuted, size: 16),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (!isMobile)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(color: kIdeDark, borderRadius: BorderRadius.circular(4), border: Border.all(color: kBorder)),
              child: Row(
                mainAxisSize: MainAxisSize.min, // Keep container tight
                children: [
                  const Icon(Icons.devices, color: kAccentPurple, size: 14),
                  const SizedBox(width: 8),
                  Text("Pixel 7 Pro API 33", style: GoogleFonts.robotoMono(color: kTextLight, fontSize: 12)),
                  const Icon(Icons.arrow_drop_down, color: kMuted, size: 16),
                ],
              ),
            ),
          const SizedBox(width: 16),
          const Icon(Icons.play_arrow_rounded, color: kSuccess, size: 24),
          const SizedBox(width: 12),
          const Icon(Icons.stop_rounded, color: Colors.redAccent, size: 20),
        ],
      ),
    );
  }

  Widget _buildIdeSidebar() {
    return Container(
      width: 250, color: kIdePanel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: kBorder))),
            child: Row(
              children: [
                Text("Project", style: GoogleFonts.robotoMono(color: kTextLight, fontSize: 13, fontWeight: FontWeight.bold)),
                const Spacer(),
                const Icon(Icons.settings, color: kMuted, size: 16),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  _sidebarItem("scaleaxis", isFolder: true, isExpanded: true),
                  _sidebarItem("android", isFolder: true, indent: 1),
                  _sidebarItem("lib", isFolder: true, isExpanded: true, indent: 1),
                  _sidebarItem("screens", isFolder: true, isExpanded: true, indent: 2),
                  _sidebarItem("intro_section.dart", icon: Icons.flutter_dash, color: kAccentBlue, indent: 3, isActive: _activeFile == "intro_section.dart", onTap: () => _openFile("intro_section.dart")),
                  _sidebarItem("portfolio_screen.dart", icon: Icons.flutter_dash, color: kAccentBlue, indent: 3, isActive: _activeFile == "portfolio_screen.dart", onTap: () => _openFile("portfolio_screen.dart")),
                  _sidebarItem("contact_section.dart", icon: Icons.flutter_dash, color: kAccentBlue, indent: 3, isActive: _activeFile == "contact_section.dart", onTap: () => _openFile("contact_section.dart")),
                  _sidebarItem("main.dart", icon: Icons.flutter_dash, color: kAccentBlue, indent: 2),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _sidebarItem(String name, {bool isFolder = false, bool isExpanded = false, int indent = 0, IconData? icon, Color? color, bool isActive = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: isActive ? kAccentBlue.withOpacity(0.1) : Colors.transparent,
        padding: EdgeInsets.only(left: 16.0 + (indent * 12), top: 6, bottom: 6, right: 8),
        child: Row(
          children: [
            if (isFolder)
              Icon(isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right, color: kMuted, size: 16)
            else
              const SizedBox(width: 16),
            Icon(isFolder ? (isExpanded ? Icons.folder_open : Icons.folder) : (icon ?? Icons.insert_drive_file), color: color ?? kMuted, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                name,
                style: GoogleFonts.robotoMono(color: isActive ? kAccentBlue : kTextLight, fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdeTabs() {
    return Container(
      color: kIdePanel,
      child: Row(
        // Use min to prevent the row from forcing expansion beyond its children when scrolled
        mainAxisSize: MainAxisSize.min,
        children: [
          ..._openTabs.map((tabName) => _ideTab(
            tabName,
            isActive: _activeFile == tabName,
            onTap: () => _openFile(tabName),
            onClose: () => _closeTab(tabName),
          )),
          // We don't use Expanded here because it's inside a SingleChildScrollView
          Container(
              width: 1000, // Provides the bottom border line extending to the right
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: kBorder, width: 1)))
          )
        ],
      ),
    );
  }

  Widget _ideTab(String name, {required bool isActive, required VoidCallback onTap, required VoidCallback onClose}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isActive ? kBg : kIdePanel,
          border: Border(
            right: const BorderSide(color: kBorder, width: 1),
            bottom: BorderSide(color: isActive ? Colors.transparent : kBorder, width: 1),
            top: BorderSide(color: isActive ? kAccentBlue : Colors.transparent, width: 2),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.flutter_dash, color: kAccentBlue, size: 14),
            const SizedBox(width: 8),
            Text(name, style: GoogleFonts.robotoMono(color: isActive ? kTextLight : kMuted, fontSize: 13)),
            const SizedBox(width: 12),
            InkWell(
              onTap: onClose,
              child: Icon(Icons.close, color: isActive ? kMuted : Colors.transparent, size: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreadcrumbs() {
    return Container(
      height: 28, width: double.infinity, color: kBg,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text("scaleaxis", style: GoogleFonts.robotoMono(color: kMuted, fontSize: 12)),
          const Icon(Icons.chevron_right, color: kMuted, size: 16),
          Text("lib", style: GoogleFonts.robotoMono(color: kMuted, fontSize: 12)),
          const Icon(Icons.chevron_right, color: kMuted, size: 16),
          Text("screens", style: GoogleFonts.robotoMono(color: kMuted, fontSize: 12)),
          const Icon(Icons.chevron_right, color: kMuted, size: 16),
          Text(_activeFile, style: GoogleFonts.robotoMono(color: kTextLight, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildIdeBottomBar() {
    return Container(
      height: 30, width: double.infinity,
      decoration: const BoxDecoration(
        color: kIdePanel,
        border: Border(top: BorderSide(color: kBorder)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.terminal, color: kMuted, size: 16),
          const SizedBox(width: 8),
          Text("Terminal", style: GoogleFonts.robotoMono(color: kTextLight, fontSize: 12)),
          const Spacer(),
          Text("Build successful in 12s", style: GoogleFonts.robotoMono(color: kSuccess, fontSize: 12)),
        ],
      ),
    );
  }
}