import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BloomTheme {
  // Strict Grayscale Palette
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color textMuted = Colors.white54;
  static const Color borderLight = Colors.white12;
  static const Color borderStrong = Colors.white30;

  static TextStyle get display => GoogleFonts.poppins(fontWeight: FontWeight.w500, color: textPrimary);
  static TextStyle get body => GoogleFonts.poppins(fontWeight: FontWeight.w400, color: textSecondary);
  static TextStyle get serifItalic => GoogleFonts.sourceSerif4(fontStyle: FontStyle.italic, color: textSecondary);
}

class LiquidGlass extends StatelessWidget {
  final Widget child;
  final bool isStrong;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  const LiquidGlass({
    super.key,
    required this.child,
    this.isStrong = false,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(16);

    // Tighter blur for mobile/native, fails safely on CanvasKit web
    final blur = isStrong ? 20.0 : 10.0;

    // INCREASED OPACITY: Since we can't rely on the blur to separate the text from the video
    // on the web, we use a stronger acrylic white wash to catch the light.
    final baseOpacity = isStrong ? 0.20 : 0.08;
    final borderOpacity = isStrong ? 0.40 : 0.15;

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: radius,
            // A darker contrast underlay to make white text pop against the bright green planet
            color: Colors.black.withOpacity(isStrong ? 0.25 : 0.15),

            // Uniform thin edge lighting
            border: Border.all(
              color: Colors.white.withOpacity(borderOpacity),
              width: 1.0,
            ),

            // The frosted acrylic gradient
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(baseOpacity + 0.1), // Shines on the top-left
                Colors.white.withOpacity(baseOpacity),       // Fades out bottom-right
              ],
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}