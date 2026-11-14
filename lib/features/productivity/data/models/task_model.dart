import 'package:equatable/equatable.dart';

class TaskItem extends Equatable {
  final String id;
  final String title;
  final String description;
  final String priority; // 'High', 'Medium', 'Low'
  final bool isCompleted;
  final String dueDate;

  const TaskItem({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.isCompleted,
    required this.dueDate,
  });

  factory TaskItem.fromMap(Map<dynamic, dynamic> map) {
    return TaskItem(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      priority: map['priority'] ?? 'Medium',
      isCompleted: map['isCompleted'] ?? false,
      dueDate: map['dueDate'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'isCompleted': isCompleted,
      'dueDate': dueDate,
    };
  }

  TaskItem copyWith({
    bool? isCompleted,
  }) {
    return TaskItem(
      id: id,
      title: title,
      description: description,
      priority: priority,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate,
    );
  }

  @override
  List<Object?> get props => [id, title, isCompleted, priority, dueDate];
}
