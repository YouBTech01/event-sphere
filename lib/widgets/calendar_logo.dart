import 'package:flutter/material.dart';

/// A custom calendar icon logo drawn purely using Flutter widgets.
/// Does not use any image assets.
class CalendarLogo extends StatelessWidget {
  final double size;
  final bool showShadow;

  const CalendarLogo({
    super.key,
    this.size = 80,
    this.showShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryColor = theme.colorScheme.primary;
    final cardBg = isDark ? const Color(0xFF1E2230) : Colors.white;
    final borderColor = isDark ? Colors.white24 : Colors.grey.shade300;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(size * 0.24),
        border: Border.all(color: borderColor, width: size * 0.02),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.25),
                  blurRadius: size * 0.25,
                  offset: Offset(0, size * 0.08),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.22),
        child: Column(
          children: [
            // Top Binder Header Bar
            Container(
              height: size * 0.28,
              width: double.infinity,
              color: primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildRing(size),
                  _buildRing(size),
                ],
              ),
            ),
            // Calendar Body with Date Display
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '24',
                      style: TextStyle(
                        fontSize: size * 0.34,
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface,
                        letterSpacing: -1,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      width: size * 0.45,
                      height: size * 0.04,
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(size * 0.02),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRing(double parentSize) {
    return Container(
      width: parentSize * 0.09,
      height: parentSize * 0.16,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(parentSize * 0.05),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
    );
  }
}
