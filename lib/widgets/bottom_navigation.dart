import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_text_styles.dart';

enum NavigationTab { home, tickets, profile }

class AppBottomNavigation extends StatelessWidget {
  final NavigationTab currentTab;
  final VoidCallback onArrowTap;
  final VoidCallback onHomeTap;
  final VoidCallback onProfileTap;
  final bool arrowEnabled;

  const AppBottomNavigation({
    super.key,
    required this.currentTab,
    required this.onArrowTap,
    required this.onHomeTap,
    required this.onProfileTap,
    this.arrowEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset > 0 ? 8 : 16),
      child: SizedBox(
        height: 105,
        child: Stack(
          children: [
            Positioned(
              left: 24,
              right: 24,
              bottom: 0,
              child: Container(
                height: 70,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.94),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: AppColors.secondaryGreen.withValues(alpha: 0.28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _BottomNavIcon(
                      icon: Icons.home_filled,
                      label: 'Home',
                      active: currentTab == NavigationTab.home,
                      onTap: onHomeTap,
                    ),
                    const Spacer(),
                    const SizedBox(width: 60),
                    const Spacer(),
                    _BottomNavIcon(
                      icon: Icons.confirmation_number_outlined,
                      label: 'Tickets',
                      active:
                          currentTab == NavigationTab.tickets ||
                          currentTab == NavigationTab.profile,
                      onTap: onProfileTap,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 35,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.center,
                child: _BottomArrowButton(
                  enabled: arrowEnabled,
                  onTap: onArrowTap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomArrowButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onTap;

  const _BottomArrowButton({required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: enabled ? 1 : 0.45,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primaryGreen, AppColors.secondaryGreen],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryGreen.withValues(
                  alpha: enabled ? 0.35 : 0.15,
                ),
                blurRadius: 18,
                spreadRadius: 1,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.arrow_forward_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }
}

class _BottomNavIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _BottomNavIcon({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primaryGreen : AppColors.textSecondary;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: SizedBox(
          width: 64,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 2),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
