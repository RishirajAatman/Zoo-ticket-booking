import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const ProviderScope(child: ZooBookingApp()));
}

class ZooBookingApp extends StatelessWidget {
  const ZooBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zoo Booking',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
