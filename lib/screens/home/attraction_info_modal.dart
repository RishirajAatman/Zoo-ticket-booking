import 'package:flutter/material.dart';

import '../../app_colors.dart';
import '../../app_text_styles.dart';

class AttractionInfo {
  final String title;
  final String description;
  final String recommendedTime;
  final List<String> highlights;

  const AttractionInfo({
    required this.title,
    required this.description,
    required this.recommendedTime,
    required this.highlights,
  });
}

Future<void> showAttractionInfoModal(
  BuildContext context,
  AttractionInfo info,
) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
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
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.secondaryGreen.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              info.title,
              style: AppTextStyles.heading.copyWith(
                fontSize: 22,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 8),
            Text(info.description, style: AppTextStyles.body),
            const SizedBox(height: 16),
            ...info.highlights.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Icon(
                        Icons.circle,
                        size: 8,
                        color: AppColors.secondaryGreen,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(item, style: AppTextStyles.body)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                'Recommended time: ${info.recommendedTime}',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryGreen,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
