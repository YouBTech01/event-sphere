import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/theme_service.dart';
import '../utils/responsive.dart';
import '../widgets/calendar_logo.dart';
import 'main_nav_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _authService = AuthService();
  final _firestoreService = FirestoreService();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final credential = await _authService.signInWithGoogle();

      if (credential == null) {
        // User cancelled the prompt
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }

      final user = credential.user;
      if (user != null) {
        try {
          final userDoc =
              await _firestoreService.getUserStream(user.uid).first;
          if (userDoc != null) {
            ThemeService().setThemeFromString(userDoc.themeMode);
          }
        } catch (_) {}
      }

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            'Authentication failed: ${e.toString().replaceAll('Exception: ', '')}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isMobile = ResponsiveBreakpoints.isMobile(context);

    final authForm = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isMobile) ...[
          const Center(child: CalendarLogo(size: 80)),
          const SizedBox(height: 24),
        ],

        Text(
          'Welcome to EventSphere',
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 10),

        Text(
          'Join top tech meetups, masterclasses, and conferences with a single tap.',
          textAlign: isMobile ? TextAlign.center : TextAlign.start,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),

        if (_errorMessage != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline,
                    color: Colors.red.shade700, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Colors.red.shade900,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

        // Google Sign-In Button
        OutlinedButton(
          onPressed: _isLoading ? null : _handleGoogleSignIn,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: BorderSide(
              color: isDark ? Colors.white24 : Colors.grey.shade300,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            backgroundColor:
                isDark ? const Color(0xFF1E2230) : Colors.white,
          ),
          child: _isLoading
              ? SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.colorScheme.primary,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildGoogleIcon(),
                    const SizedBox(width: 14),
                    Text(
                      'Continue with Google',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
        ),

        const SizedBox(height: 20),

        Text(
          'By signing in, you agree to our Terms of Service & Privacy Policy.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5),
            fontSize: 11,
          ),
        ),
      ],
    );

    if (isMobile) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: authForm,
              ),
            ),
          ),
        ),
      );
    }

    // Desktop & Web: Split-Screen Hero Showcase
    return Scaffold(
      body: Row(
        children: [
          // Left Hero Showcase Banner
          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.all(48),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                          const Color(0xFF0F172A),
                          const Color(0xFF1E1B4B),
                        ]
                      : [
                          const Color(0xFF4F46E5),
                          const Color(0xFF6366F1),
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CalendarLogo(size: 88, showShadow: true),
                  const SizedBox(height: 28),
                  const Text(
                    'EventSphere',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Your modern hub for discovering, networking, and attending tech community events.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 36),
                  _buildHeroFeatureItem(
                    icon: Icons.flash_on,
                    title: 'One-Tap RSVP',
                    subtitle: 'Quickly register with your attendee profile',
                  ),
                  const SizedBox(height: 16),
                  _buildHeroFeatureItem(
                    icon: Icons.sync,
                    title: 'Live Firestore Streams',
                    subtitle: 'Real-time updates as events are announced',
                  ),
                  const SizedBox(height: 16),
                  _buildHeroFeatureItem(
                    icon: Icons.devices,
                    title: 'Cross-Device Ready',
                    subtitle: 'Tailored UX for Web, Desktop, Tablet, and Mobile',
                  ),
                ],
              ),
            ),
          ),

          // Right Auth Pane
          Expanded(
            flex: 5,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: authForm,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroFeatureItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleIcon() {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: const Text(
        'G',
        style: TextStyle(
          color: Color(0xFF4285F4),
          fontWeight: FontWeight.w900,
          fontSize: 20,
          fontFamily: 'sans-serif',
          height: 1.0,
        ),
      ),
    );
  }
}
