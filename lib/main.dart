import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:web_portfolio/project_page.dart';
import 'home_page.dart';
// Important: Make sure your team and contact pages are imported here if you added them to routes
import 'team_page.dart';
import 'contact_page.dart';

void main() => runApp(const ScaleAxisApp());

class ScaleAxisApp extends StatelessWidget {
  const ScaleAxisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ScaleAxis | AI & Flutter',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        brightness: Brightness.dark,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const BackgroundVideoWrapper(child: HomePage()),
        '/projects': (context) => const BackgroundVideoWrapper(child: ProjectPage()),
        '/team': (context) => const BackgroundVideoWrapper(child: TeamPage()),
        '/contact': (context) => const BackgroundVideoWrapper(child: ContactPage()),
      },
    );
  }
}

class BackgroundVideoWrapper extends StatefulWidget {
  final Widget child;
  const BackgroundVideoWrapper({super.key, required this.child});

  @override
  State<BackgroundVideoWrapper> createState() => _BackgroundVideoWrapperState();
}

class _BackgroundVideoWrapperState extends State<BackgroundVideoWrapper> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse('https://d8j0ntlcm91z4.cloudfront.net/user_38xzZboKViGWJOttwIXH07lWA1P/hf_20260315_073750_51473149-4350-4920-ae24-c8214286f323.mp4'),
    )..initialize().then((_) {
      _controller.setVolume(0.0);
      _controller.setLooping(true);
      _controller.play();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. The Background Video (Bottom Layer)
          if (_controller.value.isInitialized)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            )
          else
            Container(color: Colors.black),

          // 2. The Dark Tint Overlay (Middle Layer)
          // Tweak the 0.4 opacity value to make it darker or lighter
          Container(
            color: Colors.black.withOpacity(0.2),
          ),

          // 3. The Content Overlay (Top Layer)
          widget.child,
        ],
      ),
    );
  }
}