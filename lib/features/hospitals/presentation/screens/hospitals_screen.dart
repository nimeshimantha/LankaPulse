import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../data/models/hospital_model.dart';
import '../cubit/hospital_cubit.dart';

class HospitalsScreen extends StatelessWidget {
  const HospitalsScreen({super.key});

  Future<void> _makeCall(BuildContext context, String number, String hospitalName) async {
    final Uri uri = Uri.parse('tel:$number');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        _showCallSnackBar(context, number, hospitalName);
      }
    } catch (_) {
      _showCallSnackBar(context, number, hospitalName);
    }
  }

  void _showCallSnackBar(BuildContext context, String number, String hospitalName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dialing $hospitalName at $number...'),
        backgroundColor: AppColors.lightPrimary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.local_hospital_rounded, color: AppColors.accentRed),
            SizedBox(width: 8),
            Text('Nearby Hospitals Locator'),
          ],
        ),
      ),
      body: BlocBuilder<HospitalCubit, HospitalState>(
        builder: (context, state) {
          if (state is HospitalLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HospitalLoaded) {
            final hospitals = state.filteredHospitals;
            final filters = ['All', 'Government', 'Private'];

            return Column(
              children: [
                // Interactive Map Placeholder Container
                Container(
                  width: double.infinity,
                  height: 140,
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.map_rounded,
                              size: 40,
                              color: theme.colorScheme.primary.withOpacity(0.7),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Interactive Map View (Colombo Region)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: theme.textTheme.bodyLarge?.color,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Showing ${hospitals.length} nearest medical facilities',
                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 12,
                        bottom: 12,
                        child: Chip(
                          avatar: const Icon(Icons.my_location, size: 14, color: Colors.white),
                          label: const Text('GPS Active', style: TextStyle(fontSize: 10, color: Colors.white)),
                          backgroundColor: AppColors.accentGreen,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
                // Search Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    onChanged: (val) => context.read<HospitalCubit>().setSearchQuery(val),
                    decoration: const InputDecoration(
                      hintText: 'Search hospital name, area, or service...',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                // Filter Chips
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: filters.map((f) {
                      final isSelected = state.activeFilter == f;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(f),
                          selected: isSelected,
                          onSelected: (_) => context.read<HospitalCubit>().setFilter(f),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                // Hospital List
                Expanded(
                  child: hospitals.isEmpty
                      ? const Center(child: Text('No hospitals matched your filter.'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: hospitals.length,
                          itemBuilder: (context, index) {
                            final h = hospitals[index];
                            final isGov = h.type.toLowerCase() == 'government';

                            return CustomCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          h.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: isGov
                                              ? AppColors.accentGreen.withOpacity(0.15)
                                              : AppColors.accentOrange.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: isGov
                                                ? AppColors.accentGreen
                                                : AppColors.accentOrange,
                                          ),
                                        ),
                                        child: Text(
                                          h.type,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: isGov
                                                ? AppColors.accentGreen
                                                : AppColors.accentOrange,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          h.address,
                                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                                        ),
                                      ),
                                      Text(
                                        h.distance,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      if (h.hasIcu)
                                        Container(
                                          margin: const EdgeInsets.only(right: 6),
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.primary.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Text('ICU Available', style: TextStyle(fontSize: 10)),
                                        ),
                                      if (h.hasAmbulance)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.accentRed.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Text('24/7 Ambulance', style: TextStyle(fontSize: 10, color: AppColors.accentRed)),
                                        ),
                                    ],
                                  ),
                                  const Divider(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () => _makeCall(context, h.phone, h.name),
                                          icon: const Icon(Icons.phone, size: 16),
                                          label: const Text('General Line', style: TextStyle(fontSize: 12)),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.accentRed,
                                            foregroundColor: Colors.white,
                                          ),
                                          onPressed: () => _makeCall(context, h.emergencyPhone, '${h.name} Emergency'),
                                          icon: const Icon(Icons.medical_services, size: 16),
                                          label: const Text('Emergency', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
