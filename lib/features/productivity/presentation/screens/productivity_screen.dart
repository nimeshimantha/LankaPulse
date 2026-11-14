import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../data/models/task_model.dart';
import '../cubit/productivity_cubit.dart';

class ProductivityScreen extends StatelessWidget {
  const ProductivityScreen({super.key});

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppColors.priorityHigh;
      case 'medium':
        return AppColors.priorityMedium;
      default:
        return AppColors.priorityLow;
    }
  }

  void _showAddTaskModal(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    String selectedPriority = 'High';
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalCtx) => StatefulBuilder(
        builder: (ctx, setModalState) => Container(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          decoration: BoxDecoration(
            color: Theme.of(ctx).cardTheme.color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              const Text(
                'Create New Task / Note',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                  hintText: 'e.g., Pay CEB Electricity Bill',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Description / Notes',
                  hintText: 'Additional details or steps...',
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Priority:', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(width: 12),
                  DropdownButton<String>(
                    value: selectedPriority,
                    items: ['High', 'Medium', 'Low']
                        .map((p) => DropdownMenuItem(
                              value: p,
                              child: Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: _getPriorityColor(p),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(p),
                                ],
                              ),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setModalState(() => selectedPriority = val);
                    },
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) setModalState(() => selectedDate = picked);
                    },
                    icon: const Icon(Icons.calendar_today, size: 16),
                    label: Text(
                      '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  backgroundColor: Theme.of(ctx).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  if (titleController.text.trim().isNotEmpty) {
                    final newTask = TaskItem(
                      id: 'task_${DateTime.now().millisecondsSinceEpoch}',
                      title: titleController.text.trim(),
                      description: descController.text.trim(),
                      priority: selectedPriority,
                      isCompleted: false,
                      dueDate:
                          '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
                    );
                    context.read<ProductivityCubit>().addTask(newTask);
                    Navigator.pop(modalCtx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Task added & reminder set for ${newTask.title}!'),
                        backgroundColor: AppColors.accentGreen,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.notifications_active_rounded),
                label: const Text('Save & Schedule Reminder', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
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
            Icon(Icons.check_circle_outline_rounded, color: AppColors.accentGreen),
            SizedBox(width: 8),
            Text('Productivity Hub'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTaskModal(context),
        icon: const Icon(Icons.add_task_rounded),
        label: const Text('New Task', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: BlocBuilder<ProductivityCubit, ProductivityState>(
        builder: (context, state) {
          if (state is ProductivityLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductivityLoaded) {
            final tasks = state.filteredTasks;
            final filters = ['All', 'Pending', 'Completed'];

            return Column(
              children: [
                // Quick Summary Header Card
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary.withOpacity(0.85),
                        theme.colorScheme.secondary.withOpacity(0.85),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            '${state.pendingCount}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Text('Pending Tasks', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                      Container(height: 30, width: 1, color: Colors.white38),
                      Column(
                        children: [
                          Text(
                            '${state.completedCount}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Text('Completed', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                // Filter Tabs
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: filters.map((f) {
                      final isSelected = state.activeFilter == f;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(f),
                          selected: isSelected,
                          onSelected: (_) => context.read<ProductivityCubit>().setFilter(f),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 8),
                // Task List
                Expanded(
                  child: tasks.isEmpty
                      ? const Center(
                          child: Text('No tasks found in this section.'),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            final priorityColor = _getPriorityColor(task.priority);

                            return CustomCard(
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: task.isCompleted,
                                    activeColor: theme.colorScheme.primary,
                                    onChanged: (_) => context
                                        .read<ProductivityCubit>()
                                        .toggleTaskStatus(task.id),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          task.title,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            decoration: task.isCompleted
                                                ? TextDecoration.lineThrough
                                                : null,
                                            color: task.isCompleted ? Colors.grey : null,
                                          ),
                                        ),
                                        if (task.description.isNotEmpty) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            task.description,
                                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                                          ),
                                        ],
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: priorityColor.withOpacity(0.15),
                                                borderRadius: BorderRadius.circular(4),
                                                border: Border.all(color: priorityColor),
                                              ),
                                              child: Text(
                                                '${task.priority} Priority',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: priorityColor,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                                            const SizedBox(width: 4),
                                            Text(
                                              task.dueDate,
                                              style: const TextStyle(fontSize: 11, color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.grey, size: 20),
                                    onPressed: () => context.read<ProductivityCubit>().deleteTask(task.id),
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
