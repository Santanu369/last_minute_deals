import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        // Same 512px PNG and 170dp size as the native launch screen
        // (android drawable-xxhdpi/splash.png, iOS LaunchImage), so the
        // handover from native to Flutter shows an identical logo.
        child: Image.asset(
          'assets/comingSoon/lmdLogo512.png',
          width: 170,
          height: 170,
          filterQuality: FilterQuality.high,
        ),
      ),
    );
  }
}
