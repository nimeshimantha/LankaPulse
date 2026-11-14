import 'package:equatable/equatable.dart';

class Job extends Equatable {
  final String id;
  final String title;
  final String company;
  final String location;
  final String type; // 'Full-time', 'Part-time', 'Internship', 'Remote'
  final String salaryRange;
  final String description;
  final String postedAgo;
  final List<String> requirements;
  final bool isFeatured;

  const Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.type,
    required this.salaryRange,
    required this.description,
    required this.postedAgo,
    required this.requirements,
    this.isFeatured = false,
  });

  @override
  List<Object?> get props => [id, title, company, type, postedAgo];
}
