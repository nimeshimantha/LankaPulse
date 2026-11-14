import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';

/// Prominent Emergency SOS banner providing quick-dial buttons for 119 and 1990.
class SosBanner extends StatelessWidget {
  const SosBanner({super.key});

  Future<void> _makeCall(BuildContext context, String number, String serviceName) async {
    final Uri uri = Uri.parse('tel:$number');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        _showDialDialog(context, number, serviceName);
      }
    } catch (_) {
      _showDialDialog(context, number, serviceName);
    }
  }

  void _showDialDialog(BuildContext context, String number, String serviceName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Dial $serviceName'),
        content: Text('Directly call $serviceName at hotline number $number?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentRed,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Initiating emergency call to $number ($serviceName)...'),
                  backgroundColor: AppColors.accentRed,
                ),
              );
            },
            icon: const Icon(Icons.phone),
            label: Text('Call $number'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF991B1B), const Color(0xFF7F1D1D)]
              : [const Color(0xFFFEF2F2), const Color(0xFFFEE2E2)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFFDC2626) : const Color(0xFFFCA5A5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.accentRed,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.sos_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Emergency Hotlines',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF991B1B),
                      ),
                    ),
                    Text(
                      'Tap to instantly dial 24/7 national response lines',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? const Color(0xFFFCA5A5) : const Color(0xFFB91C1C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.accentRed,
                    foregroundColor: Colors.white,
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => _makeCall(context, '119', 'Police Emergency'),
                  icon: const Icon(Icons.local_police, size: 18),
                  label: const Text(
                    '119 Police',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: isDark ? const Color(0xFF1C2541) : Colors.white,
                    foregroundColor: isDark ? Colors.white : AppColors.accentRed,
                    side: BorderSide(
                      color: isDark ? const Color(0xFFDC2626) : AppColors.accentRed,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => _makeCall(context, '1990', 'Suwa Seriya Ambulance'),
                  icon: const Icon(Icons.medical_services, size: 18),
                  label: const Text(
                    '1990 Suwa Seriya',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
