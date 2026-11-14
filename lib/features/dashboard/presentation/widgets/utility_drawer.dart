import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/theme_cubit.dart';

class UtilityDrawer extends StatelessWidget {
  const UtilityDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header with LankaPulse Branding
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1C2541), const Color(0xFF0B132B)]
                    : [AppColors.lightPrimary, const Color(0xFF0284C7)],
              ),
            ),
            accountName: const Text(
              'LankaPulse Super-App',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: const Text(
              'v1.0.0 • Connected to Sri Lanka Core',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: isDark ? AppColors.darkPrimary : Colors.white,
              child: const Icon(
                Icons.bolt_rounded,
                size: 36,
                color: AppColors.lightPrimary,
              ),
            ),
          ),

          // Theme Toggle Switch
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              final isCurrentDark = themeMode == ThemeMode.dark ||
                  (themeMode == ThemeMode.system && isDark);

              return SwitchListTile(
                title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(
                  isCurrentDark ? 'Dark theme active (#0B132B)' : 'Light theme active (#F8FAFC)',
                  style: const TextStyle(fontSize: 12),
                ),
                secondary: Icon(
                  isCurrentDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  color: isCurrentDark ? AppColors.darkSecondary : AppColors.accentOrange,
                ),
                value: isCurrentDark,
                onChanged: (_) {
                  context.read<ThemeCubit>().toggleTheme();
                },
              );
            },
          ),
          const Divider(),

          // Utility Navigation Options
          ListTile(
            leading: const Icon(Icons.lock_outline_rounded, color: AppColors.accentOrange),
            title: const Text('Offline Document Locker'),
            subtitle: const Text('NIC, License & Encrypted Vault', style: TextStyle(fontSize: 11)),
            onTap: () {
              Navigator.pop(context);
              context.push('/document-locker');
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month_rounded, color: AppColors.lightSecondary),
            title: const Text('Poya & Bank Holiday Calendar'),
            subtitle: const Text('2026 Official Sri Lankan Holidays', style: TextStyle(fontSize: 11)),
            onTap: () {
              Navigator.pop(context);
              context.push('/holiday-calendar');
            },
          ),
          ListTile(
            leading: const Icon(Icons.phone_in_talk_rounded, color: AppColors.accentRed),
            title: const Text('Emergency Hotlines (24/7)'),
            subtitle: const Text('119 Police, 1990 Suwa Seriya, Fire', style: TextStyle(fontSize: 11)),
            onTap: () {
              Navigator.pop(context);
              context.push('/emergency-hotlines');
            },
          ),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.info_outline_rounded, color: Colors.grey),
            title: const Text('About LankaPulse'),
            subtitle: const Text('Modular Clean Architecture Super-App', style: TextStyle(fontSize: 11)),
            onTap: () {
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: 'LankaPulse',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(Icons.bolt_rounded, size: 40, color: AppColors.lightPrimary),
                children: const [
                  Text(
                    'Built with Flutter, Material 3 Light/Dark Themes, Clean Architecture, BLoC/Cubit, Hive, and Firebase.',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
