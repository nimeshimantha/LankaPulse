import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/services/hive_service.dart';
import '../../../../core/services/notification_service.dart';
import '../../data/models/task_model.dart';

abstract class ProductivityState extends Equatable {
  const ProductivityState();
  @override
  List<Object?> get props => [];
}

class ProductivityInitial extends ProductivityState {}
class ProductivityLoading extends ProductivityState {}
class ProductivityLoaded extends ProductivityState {
  final List<TaskItem> tasks;
  final String activeFilter; // 'All', 'Pending', 'Completed'

  const ProductivityLoaded({
    required this.tasks,
    this.activeFilter = 'All',
  });

  List<TaskItem> get filteredTasks {
    return tasks.where((t) {
      if (activeFilter == 'Pending') return !t.isCompleted;
      if (activeFilter == 'Completed') return t.isCompleted;
      return true;
    }).toList();
  }

  int get pendingCount => tasks.where((t) => !t.isCompleted).length;
  int get completedCount => tasks.where((t) => t.isCompleted).length;

  @override
  List<Object?> get props => [tasks, activeFilter];
}

class ProductivityCubit extends Cubit<ProductivityState> {
  ProductivityCubit() : super(ProductivityInitial()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    emit(ProductivityLoading());
    try {
      if (Hive.isBoxOpen(HiveService.tasksBoxName)) {
        final box = Hive.box(HiveService.tasksBoxName);
        final tasks = box.values
            .map((e) => TaskItem.fromMap(Map<dynamic, dynamic>.from(e as Map)))
            .toList();
        emit(ProductivityLoaded(tasks: tasks));
      } else {
        _loadFallback();
      }
    } catch (_) {
      _loadFallback();
    }
  }

  void _loadFallback() {
    const fallback = [
      TaskItem(
        id: 'task_1',
        title: 'Renew Driving License at DMT Werahera',
        description: 'Gather NIC, medical certificate, and current license copy.',
        priority: 'High',
        isCompleted: false,
        dueDate: '2026-09-20',
      ),
      TaskItem(
        id: 'task_2',
        title: 'Pay Utility Electricity Bill (CEB)',
        description: 'Use online portal or nearest bank branch.',
        priority: 'Medium',
        isCompleted: true,
        dueDate: '2026-09-18',
      ),
    ];
    emit(const ProductivityLoaded(tasks: fallback));
  }

  void setFilter(String filter) {
    if (state is ProductivityLoaded) {
      final current = state as ProductivityLoaded;
      emit(ProductivityLoaded(tasks: current.tasks, activeFilter: filter));
    }
  }

  Future<void> toggleTaskStatus(String id) async {
    if (state is ProductivityLoaded) {
      final current = state as ProductivityLoaded;
      final updatedTasks = current.tasks.map((t) {
        if (t.id == id) {
          final updated = t.copyWith(isCompleted: !t.isCompleted);
          if (Hive.isBoxOpen(HiveService.tasksBoxName)) {
            Hive.box(HiveService.tasksBoxName).put(id, updated.toMap());
          }
          return updated;
        }
        return t;
      }).toList();

      emit(ProductivityLoaded(tasks: updatedTasks, activeFilter: current.activeFilter));
    }
  }

  Future<void> addTask(TaskItem task) async {
    if (state is ProductivityLoaded) {
      final current = state as ProductivityLoaded;
      final updatedTasks = [task, ...current.tasks];

      if (Hive.isBoxOpen(HiveService.tasksBoxName)) {
        await Hive.box(HiveService.tasksBoxName).put(task.id, task.toMap());
      }

      // Trigger local notification reminder
      await NotificationService.showNotification(
        id: task.id.hashCode,
        title: 'Reminder Created: ${task.title}',
        body: 'Priority: ${task.priority} | Due: ${task.dueDate}',
      );

      emit(ProductivityLoaded(tasks: updatedTasks, activeFilter: current.activeFilter));
    }
  }

  Future<void> deleteTask(String id) async {
    if (state is ProductivityLoaded) {
      final current = state as ProductivityLoaded;
      final updatedTasks = current.tasks.where((t) => t.id != id).toList();

      if (Hive.isBoxOpen(HiveService.tasksBoxName)) {
        await Hive.box(HiveService.tasksBoxName).delete(id);
      }

      emit(ProductivityLoaded(tasks: updatedTasks, activeFilter: current.activeFilter));
    }
  }
}
