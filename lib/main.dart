import 'dart:ui';
import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService().initialize();
  runApp(const RamafWebsite());
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

class RamafWebsite extends StatelessWidget {
  const RamafWebsite({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RAMA Foundation - Rural Agricultural & Vocational Empowerment',
      debugShowCheckedModeBanner: false,
      scrollBehavior: AppScrollBehavior(),
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}