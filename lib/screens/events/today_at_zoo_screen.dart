import 'package:flutter/material.dart';

import '../../app_colors.dart';
import '../../app_text_styles.dart';
import '../../widgets/booking_compact_header.dart';

class TodayAtZooScreen extends StatelessWidget {
  const TodayAtZooScreen({super.key});

  static const List<_ZooEvent> _events = [
    _ZooEvent(
      title: 'Lion Feeding Show',
      time: '3:30 PM',
      icon: Icons.pets_rounded,
    ),
    _ZooEvent(
      title: 'Elephant Bath',
      time: '5:00 PM',
      icon: Icons.water_drop_outlined,
    ),
    _ZooEvent(
      title: 'Bird Show',
      time: '4:15 PM',
      icon: Icons.flutter_dash_rounded,
    ),
    _ZooEvent(
      title: 'Reptile Talk',
      time: '2:00 PM',
      icon: Icons.info_outline_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: Stack(
        fit: StackFit.expand,
        children: [
          BookingCompactHeader(
            dayText: 'Today at the Zoo',
            dateText: 'Don\'t miss today\'s exciting events',
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
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                itemCount: _events.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final event = _events[index];

                  return _EventCard(event: event);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final _ZooEvent event;

  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF6EB),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(event.icon, color: AppColors.primaryGreen),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  event.title,
                  style: AppTextStyles.title.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Time: ${event.time}',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ZooEvent {
  final String title;
  final String time;
  final IconData icon;

  const _ZooEvent({
    required this.title,
    required this.time,
    required this.icon,
  });
}
