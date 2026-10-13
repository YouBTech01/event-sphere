import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/theme_service.dart';
import '../widgets/calendar_logo.dart';
import 'auth_screen.dart';
import 'main_nav_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _authService = AuthService();
  final _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Artificial minimum delay for smooth visual transition
    await Future.delayed(const Duration(milliseconds: 1400));

    if (!mounted) return;

    final currentUser = _authService.currentUser;

    if (currentUser != null) {
      // Load user theme preference if saved in Firestore
      try {
        final userDoc = await _firestoreService.getUserStream(currentUser.uid).first;
        if (userDoc != null) {
          ThemeService().setThemeFromString(userDoc.themeMode);
        }
      } catch (_) {
        // Fallback to existing or system theme
      }

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavScreen()),
      );
    } else {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AuthScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Calendar Icon Logo drawn with Flutter widgets
              const CalendarLogo(size: 96),
              const SizedBox(height: 28),

              // App Name
              Text(
                'EventSphere',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Discover & Join Community Events',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                ),
              ),

              const Spacer(flex: 2),

              // Loading Indicator
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Checking session...',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.textTheme.labelMedium?.color?.withValues(alpha: 0.5),
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
