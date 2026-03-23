import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../app_colors.dart';
import '../../app_text_styles.dart';
import '../../widgets/booking_compact_header.dart';

class ZooMapScreen extends StatelessWidget {
  const ZooMapScreen({super.key});

  static const List<_MapPoint> _points = [
    _MapPoint(
      title: 'Lion Safari',
      subtitle: 'Open jeep experience and feeding zone overview.',
      alignment: Alignment(-0.62, -0.45),
      icon: Icons.pets,
    ),
    _MapPoint(
      title: 'Snake Tunnel',
      subtitle: 'Indoor exhibit with 20+ snake species.',
      alignment: Alignment(0.52, -0.2),
      icon: Icons.water,
    ),
    _MapPoint(
      title: 'Birds Cage',
      subtitle: 'Walk-through aviary with shaded seating nearby.',
      alignment: Alignment(-0.08, 0.1),
      icon: Icons.flutter_dash,
    ),
    _MapPoint(
      title: 'Food Court',
      subtitle: 'Snacks, water refill station, and rest area.',
      alignment: Alignment(0.1, 0.55),
      icon: Icons.restaurant_rounded,
    ),
    _MapPoint(
      title: 'Washrooms',
      subtitle: 'Family washrooms and baby-care room.',
      alignment: Alignment(-0.5, 0.58),
      icon: Icons.wc_rounded,
    ),
  ];

  void _showInfo(BuildContext context, _MapPoint point) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
          decoration: const BoxDecoration(
            color: Color(0xFFF7FAF7),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                point.title,
                style: AppTextStyles.heading.copyWith(
                  fontSize: 22,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 8),
              Text(point.subtitle, style: AppTextStyles.body),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayText = DateFormat('EEEE').format(now);
    final dateText = DateFormat('d MMMM y').format(now);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: Stack(
        fit: StackFit.expand,
        children: [
          BookingCompactHeader(
            dayText: dayText,
            dateText: dateText,
            trailingIcon: Icons.arrow_back_rounded,
            onTrailingTap: () => Navigator.pop(context),
          ),
          Positioned(
            top: 124,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF3F3F3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                children: [
                  Text(
                    'Zoo Map',
                    style: AppTextStyles.heading.copyWith(
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap any marker for quick visitor guidance.',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  AspectRatio(
                    aspectRatio: 0.86,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        color: const Color(0xFFE8F5E9),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 14,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: SvgPicture.asset(
                                'assets/images/zoo_map.svg',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned.fill(
                              child: CustomPaint(painter: _PathPainter()),
                            ),
                            ..._points.map(
                              (point) => Align(
                                alignment: point.alignment,
                                child: _MapMarker(
                                  point: point,
                                  onTap: () => _showInfo(context, point),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _points
                          .map(
                            (point) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  Icon(
                                    point.icon,
                                    color: AppColors.primaryGreen,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      point.title,
                                      style: AppTextStyles.body.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(growable: false),
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

class _MapPoint {
  final String title;
  final String subtitle;
  final Alignment alignment;
  final IconData icon;

  const _MapPoint({
    required this.title,
    required this.subtitle,
    required this.alignment,
    required this.icon,
  });
}

class _MapMarker extends StatelessWidget {
  final _MapPoint point;
  final VoidCallback onTap;

  const _MapMarker({required this.point, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGreen.withValues(alpha: 0.28),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(point.icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              point.title,
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primaryGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final trailPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.75)
      ..strokeWidth = 18
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * 0.18, size.height * 0.15)
      ..quadraticBezierTo(
        size.width * 0.45,
        size.height * 0.25,
        size.width * 0.7,
        size.height * 0.18,
      )
      ..quadraticBezierTo(
        size.width * 0.82,
        size.height * 0.38,
        size.width * 0.54,
        size.height * 0.48,
      )
      ..quadraticBezierTo(
        size.width * 0.28,
        size.height * 0.58,
        size.width * 0.4,
        size.height * 0.82,
      );

    canvas.drawPath(path, trailPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
