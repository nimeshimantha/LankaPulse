import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../data/models/job_model.dart';
import '../cubit/job_cubit.dart';

class JobsScreen extends StatelessWidget {
  const JobsScreen({super.key});

  static const filterOptions = ['All', 'Full-time', 'Part-time', 'Internship', 'Remote'];

  void _showJobDetailSheet(BuildContext context, Job job) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        job.company,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.lightSecondary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    job.type,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(job.location, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                const Spacer(),
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(job.postedAgo, style: const TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.payments_outlined, color: AppColors.accentGreen),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      job.salaryRange,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 24),
            const Text('Job Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(job.description, style: const TextStyle(fontSize: 14, height: 1.5)),
            const SizedBox(height: 16),
            const Text('Key Requirements', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: job.requirements.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_rounded, size: 16, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(job.requirements[index], style: const TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Application submitted successfully to ${job.company}!'),
                    backgroundColor: AppColors.accentGreen,
                  ),
                );
              },
              icon: const Icon(Icons.send_rounded),
              label: const Text('Apply Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showPostJobDialog(BuildContext context) {
    final titleController = TextEditingController();
    final companyController = TextEditingController();
    final locationController = TextEditingController();
    final salaryController = TextEditingController();
    final descController = TextEditingController();
    String selectedType = 'Full-time';

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Post a New Job'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Job Title', hintText: 'e.g., Flutter Engineer'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: companyController,
                  decoration: const InputDecoration(labelText: 'Company Name', hintText: 'e.g., Tech Solutions LK'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: 'Location', hintText: 'e.g., Colombo / Remote'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(labelText: 'Job Type'),
                  items: ['Full-time', 'Part-time', 'Internship', 'Remote']
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setDialogState(() => selectedType = val);
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: salaryController,
                  decoration: const InputDecoration(labelText: 'Salary Range', hintText: 'e.g., LKR 200,000 / month'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Description', hintText: 'Brief job details...'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty && companyController.text.isNotEmpty) {
                  final newJob = Job(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: titleController.text,
                    company: companyController.text,
                    location: locationController.text.isEmpty ? 'Colombo' : locationController.text,
                    type: selectedType,
                    salaryRange: salaryController.text.isEmpty ? 'Negotiable' : salaryController.text,
                    description: descController.text.isEmpty ? 'No description provided.' : descController.text,
                    postedAgo: 'Just now',
                    requirements: const ['Strong problem solving', 'Good communication'],
                    isFeatured: false,
                  );
                  context.read<JobCubit>().addJob(newJob);
                  Navigator.pop(dialogCtx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Job posted successfully!'),
                      backgroundColor: AppColors.accentGreen,
                    ),
                  );
                }
              },
              child: const Text('Post Job'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.work_rounded, color: AppColors.lightSecondary),
            SizedBox(width: 8),
            Text('Daily Job Board'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showPostJobDialog(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Post Job', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: BlocBuilder<JobCubit, JobState>(
        builder: (context, state) {
          if (state is JobLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is JobLoaded) {
            final jobs = state.filteredJobs;

            return Column(
              children: [
                // Search Input
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: TextField(
                    onChanged: (val) => context.read<JobCubit>().setSearchQuery(val),
                    decoration: const InputDecoration(
                      hintText: 'Search title, company, or tech stack...',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Row(
                    children: filterOptions.map((f) {
                      final isSelected = state.activeFilter == f;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(f),
                          selected: isSelected,
                          onSelected: (_) => context.read<JobCubit>().setFilter(f),
                          selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                          checkmarkColor: theme.colorScheme.primary,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 8),
                // Job List
                Expanded(
                  child: jobs.isEmpty
                      ? const Center(child: Text('No job openings found matching filter.'))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: jobs.length,
                          itemBuilder: (context, index) {
                            final job = jobs[index];

                            return CustomCard(
                              onTap: () => _showJobDetailSheet(context, job),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              job.title,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              job.company,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: theme.colorScheme.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (job.isFeatured)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: AppColors.accentOrange.withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(color: AppColors.accentOrange),
                                          ),
                                          child: const Text(
                                            'FEATURED',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.accentOrange,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(job.location, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.primary.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          job.type,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: theme.colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.payments_outlined, size: 14, color: AppColors.accentGreen),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          job.salaryRange,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.accentGreen,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        job.postedAgo,
                                        style: const TextStyle(fontSize: 11, color: Colors.grey),
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
