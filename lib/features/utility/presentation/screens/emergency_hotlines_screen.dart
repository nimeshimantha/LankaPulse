import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/custom_card.dart';

class EmergencyHotlinesScreen extends StatelessWidget {
  const EmergencyHotlinesScreen({super.key});

  Future<void> _callHotline(BuildContext context, String number, String name) async {
    final Uri uri = Uri.parse('tel:$number');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Calling $name ($number)...'),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Calling $name ($number)...'),
          backgroundColor: AppColors.accentRed,
        ),
      );
    }
  }

  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'security':
        return Icons.local_police_rounded;
      case 'medical':
        return Icons.medical_services_rounded;
      case 'fire':
        return Icons.local_fire_department_rounded;
      case 'tourism':
        return Icons.support_agent_rounded;
      case 'social':
        return Icons.child_care_rounded;
      default:
        return Icons.warning_amber_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    const hotlines = AppConstants.emergencyHotlines;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.phone_in_talk_rounded, color: AppColors.accentRed),
            SizedBox(width: 8),
            Text('Emergency Hotlines (24/7)'),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: hotlines.length,
        itemBuilder: (context, index) {
          final h = hotlines[index];
          final icon = _getIconForCategory(h.category);

          return CustomCard(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.accentRed.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: AppColors.accentRed, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        h.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        h.description,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentRed,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => _callHotline(context, h.number, h.name),
                  icon: const Icon(Icons.phone, size: 16),
                  label: Text(
                    h.number,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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
