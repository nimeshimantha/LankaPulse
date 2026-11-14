import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/custom_card.dart';

class HolidayCalendarScreen extends StatelessWidget {
  const HolidayCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const holidays = AppConstants.upcomingHolidays;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.calendar_month_rounded, color: AppColors.lightSecondary),
            SizedBox(width: 8),
            Text('Poya & Bank Holidays Calendar'),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: holidays.length,
        itemBuilder: (context, index) {
          final h = holidays[index];
          final isPoya = h.name.toLowerCase().contains('poya');

          return CustomCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isPoya
                        ? AppColors.accentOrange.withOpacity(0.15)
                        : theme.colorScheme.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isPoya ? Icons.brightness_7_rounded : Icons.event_rounded,
                    color: isPoya ? AppColors.accentOrange : theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        h.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            h.date,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        h.description,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isPoya
                              ? AppColors.accentOrange.withOpacity(0.1)
                              : AppColors.accentGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          h.type,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isPoya ? AppColors.accentOrange : AppColors.accentGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
