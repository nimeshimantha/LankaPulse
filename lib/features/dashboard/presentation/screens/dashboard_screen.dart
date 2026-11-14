import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/sos_banner.dart';
import '../../../dictionary/presentation/cubit/dictionary_cubit.dart';
import '../../../hospitals/presentation/cubit/hospital_cubit.dart';
import '../../../jobs/presentation/cubit/job_cubit.dart';
import '../../../news/presentation/cubit/news_cubit.dart';
import '../../../productivity/presentation/cubit/productivity_cubit.dart';
import '../widgets/utility_drawer.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      drawer: const UtilityDrawer(),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'LankaPulse',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.accentOrange,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'SUPER-APP',
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
            const Row(
              children: [
                Icon(Icons.location_on, size: 11, color: Colors.grey),
                SizedBox(width: 2),
                Text(
                  'Colombo, Western Province',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Toggle Theme',
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: isDark ? AppColors.accentOrange : AppColors.darkScaffoldBackground,
            ),
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          ),
          IconButton(
            tooltip: 'Quick SOS Call',
            icon: const Icon(Icons.phone_in_talk_rounded, color: AppColors.accentRed),
            onPressed: () => context.push('/emergency-hotlines'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<NewsCubit>().loadNews();
          context.read<HospitalCubit>().loadHospitals();
          context.read<JobCubit>().loadJobs();
          context.read<DictionaryCubit>().loadWords();
          context.read<ProductivityCubit>().loadTasks();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Emergency SOS Quick Call Banner
              const SosBanner(),
              const SizedBox(height: 18),

              // Daily Highlights Header & Cards Carousel
              const Text(
                'Daily Highlights',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildHighlightCard(
                      context: context,
                      title: 'Colombo Weather',
                      subtitle: '29°C • Partly Cloudy',
                      icon: Icons.wb_sunny_rounded,
                      color: AppColors.accentOrange,
                    ),
                    const SizedBox(width: 12),
                    _buildHighlightCard(
                      context: context,
                      title: 'Fuel Price Update',
                      subtitle: 'Auto Diesel LKR 325/L',
                      icon: Icons.local_gas_station_rounded,
                      color: AppColors.lightPrimary,
                    ),
                    const SizedBox(width: 12),
                    _buildHighlightCard(
                      context: context,
                      title: 'USD to LKR Rate',
                      subtitle: '1 USD = 302.50 LKR',
                      icon: Icons.currency_exchange_rounded,
                      color: AppColors.accentGreen,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),

              // Quick Utilities Grid
              const Text(
                'Quick Utilities Grid',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
                children: [
                  _buildUtilityGridItem(
                    context: context,
                    label: 'News Feed',
                    icon: Icons.newspaper_rounded,
                    color: AppColors.lightPrimary,
                    onTap: () => context.go('/news'),
                  ),
                  _buildUtilityGridItem(
                    context: context,
                    label: 'Hospitals',
                    icon: Icons.local_hospital_rounded,
                    color: AppColors.accentRed,
                    onTap: () => context.go('/hospitals'),
                  ),
                  _buildUtilityGridItem(
                    context: context,
                    label: 'Job Board',
                    icon: Icons.work_rounded,
                    color: AppColors.lightSecondary,
                    onTap: () => context.go('/jobs'),
                  ),
                  _buildUtilityGridItem(
                    context: context,
                    label: 'Dictionary',
                    icon: Icons.translate_rounded,
                    color: AppColors.accentPurple,
                    onTap: () => context.go('/dictionary'),
                  ),
                  _buildUtilityGridItem(
                    context: context,
                    label: 'Tasks',
                    icon: Icons.check_circle_outline_rounded,
                    color: AppColors.accentGreen,
                    onTap: () => context.go('/productivity'),
                  ),
                  _buildUtilityGridItem(
                    context: context,
                    label: 'Doc Vault',
                    icon: Icons.lock_outline_rounded,
                    color: AppColors.accentOrange,
                    onTap: () => context.push('/document-locker'),
                  ),
                  _buildUtilityGridItem(
                    context: context,
                    label: 'Holidays',
                    icon: Icons.calendar_month_rounded,
                    color: Colors.teal,
                    onTap: () => context.push('/holiday-calendar'),
                  ),
                  _buildUtilityGridItem(
                    context: context,
                    label: 'SOS Lines',
                    icon: Icons.phone_in_talk_rounded,
                    color: AppColors.accentRed,
                    onTap: () => context.push('/emergency-hotlines'),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // Latest News Preview Carousel
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Latest Sri Lanka News',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () => context.go('/news'),
                    child: const Text('View All →'),
                  ),
                ],
              ),
              BlocBuilder<NewsCubit, NewsState>(
                builder: (context, state) {
                  if (state is NewsLoaded && state.articles.isNotEmpty) {
                    final article = state.articles.first;
                    return CustomCard(
                      onTap: () => context.go('/news'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: article.isBreaking ? AppColors.accentRed : theme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  article.isBreaking ? 'BREAKING' : article.category,
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                              const Spacer(),
                              Text(article.publishedAt, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            article.title,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            article.summary,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 20),

              // Quick Productivity Checklist Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Priority Tasks',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () => context.go('/productivity'),
                    child: const Text('Go to Hub →'),
                  ),
                ],
              ),
              BlocBuilder<ProductivityCubit, ProductivityState>(
                builder: (context, state) {
                  if (state is ProductivityLoaded && state.tasks.isNotEmpty) {
                    final pendingTasks = state.tasks.where((t) => !t.isCompleted).take(3).toList();

                    return Column(
                      children: pendingTasks.map((t) {
                        return CustomCard(
                          onTap: () => context.read<ProductivityCubit>().toggleTaskStatus(t.id),
                          margin: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Icon(
                                t.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                                color: t.isCompleted ? AppColors.accentGreen : theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  t.title,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    decoration: t.isCompleted ? TextDecoration.lineThrough : null,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.accentRed.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  t.priority,
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.accentRed),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 180,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUtilityGridItem({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(isDark ? 0.2 : 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
