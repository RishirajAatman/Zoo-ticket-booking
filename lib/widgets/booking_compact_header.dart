import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_text_styles.dart';

class BookingCompactHeader extends StatelessWidget {
  final String dayText;
  final String dateText;
  final IconData trailingIcon;
  final Widget? trailingContent;
  final VoidCallback? onTrailingTap;

  const BookingCompactHeader({
    super.key,
    required this.dayText,
    required this.dateText,
    required this.trailingIcon,
    this.trailingContent,
    this.onTrailingTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isSmallScreen = screenWidth <= 360;
    final horizontalPadding = isSmallScreen ? 16.0 : 24.0;
    final weekdayFontSize = isSmallScreen ? 22.0 : 24.0;
    final dateFontSize = isSmallScreen ? 12.0 : 13.0;
    final trailingButtonSize = isSmallScreen ? 40.0 : 42.0;
    final topPadding = isSmallScreen ? 6.0 : 8.0;
    final bottomPadding = isSmallScreen ? 12.0 : 14.0;
    final gapBetweenTexts = isSmallScreen ? 2.0 : 4.0;

    return SizedBox(
      height: isSmallScreen ? 188 : 196,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1B5E20), Color(0xFF43A047)],
                ),
              ),
            ),
          ),
          Positioned(
            left: isSmallScreen ? -44 : -52,
            right: isSmallScreen ? 148 : 130,
            bottom: isSmallScreen ? -72 : -78,
            child: Container(
              height: isSmallScreen ? 124 : 138,
              decoration: BoxDecoration(
                color: const Color(0xFF0F4F1A).withValues(alpha: 0.20),
                borderRadius: BorderRadius.circular(120),
              ),
            ),
          ),
          Positioned(
            left: isSmallScreen ? 134 : 110,
            right: isSmallScreen ? -58 : -66,
            bottom: isSmallScreen ? -82 : -88,
            child: Container(
              height: isSmallScreen ? 136 : 148,
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(120),
              ),
            ),
          ),
          Positioned(
            top: isSmallScreen ? 18 : 14,
            right: isSmallScreen ? -24 : -18,
            child: Opacity(
              opacity: isSmallScreen ? 0.05 : 0.08,
              child: Transform.rotate(
                angle: 0.42,
                child: SizedBox(
                  width: isSmallScreen ? 72 : 92,
                  height: isSmallScreen ? 72 : 92,
                  child: Image.asset(
                    'assets/images/main_zoo.png',
                    fit: BoxFit.cover,
                    color: const Color(0xFFDFF7E1),
                    colorBlendMode: BlendMode.modulate,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: isSmallScreen ? -12 : -18,
            bottom: isSmallScreen ? 18 : 24,
            child: Opacity(
              opacity: isSmallScreen ? 0.05 : 0.07,
              child: Transform.rotate(
                angle: -0.34,
                child: SizedBox(
                  width: isSmallScreen ? 60 : 76,
                  height: isSmallScreen ? 60 : 76,
                  child: Image.asset(
                    'assets/images/snake_tunnel.png',
                    fit: BoxFit.cover,
                    color: const Color(0xFFE8F7EA),
                    colorBlendMode: BlendMode.modulate,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                topPadding,
                horizontalPadding,
                bottomPadding,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          dayText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.heading.copyWith(
                            color: Colors.white,
                            fontSize: weekdayFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: gapBetweenTexts),
                        Text(
                          dateText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(
                            color: Colors.white.withValues(alpha: 0.74),
                            fontSize: dateFontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onTrailingTap,
                      borderRadius: BorderRadius.circular(trailingButtonSize),
                      child: Container(
                        width: trailingButtonSize,
                        height: trailingButtonSize,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.20),
                              blurRadius: 14,
                              spreadRadius: 1,
                              offset: const Offset(0, 6),
                            ),
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.40),
                              blurRadius: 8,
                              offset: const Offset(0, -2),
                            ),
                          ],
                        ),
                        child:
                            trailingContent ??
                            Icon(
                              trailingIcon,
                              color: AppColors.primaryGreen,
                              size: 20,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
