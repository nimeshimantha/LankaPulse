import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/job_model.dart';

abstract class JobState extends Equatable {
  const JobState();
  @override
  List<Object?> get props => [];
}

class JobInitial extends JobState {}
class JobLoading extends JobState {}
class JobLoaded extends JobState {
  final List<Job> jobs;
  final String activeFilter; // 'All', 'Full-time', 'Part-time', 'Internship', 'Remote'
  final String searchQuery;

  const JobLoaded({
    required this.jobs,
    this.activeFilter = 'All',
    this.searchQuery = '',
  });

  List<Job> get filteredJobs {
    return jobs.where((job) {
      final matchesFilter = activeFilter == 'All' ||
          job.type.toLowerCase() == activeFilter.toLowerCase();
      final matchesSearch = searchQuery.isEmpty ||
          job.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          job.company.toLowerCase().contains(searchQuery.toLowerCase()) ||
          job.location.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  List<Object?> get props => [jobs, activeFilter, searchQuery];
}

class JobCubit extends Cubit<JobState> {
  JobCubit() : super(JobInitial()) {
    loadJobs();
  }

  void loadJobs() {
    emit(JobLoading());

    final mockJobs = [
      const Job(
        id: 'job_1',
        title: 'Senior Flutter Mobile Engineer',
        company: 'Virtusa Sri Lanka',
        location: 'Colombo 03 (Hybrid)',
        type: 'Full-time',
        salaryRange: 'LKR 350,000 - 500,000 / month',
        description: 'Build enterprise Flutter applications with Clean Architecture, BLoC, and Firebase for international clients.',
        postedAgo: '1 day ago',
        requirements: ['3+ years Flutter experience', 'Clean Architecture', 'State Management (BLoC/Riverpod)', 'REST & Firebase'],
        isFeatured: true,
      ),
      const Job(
        id: 'job_2',
        title: 'Full Stack Node.js & React Developer',
        company: '99x',
        location: 'Colombo 02',
        type: 'Full-time',
        salaryRange: 'LKR 280,000 - 420,000 / month',
        description: 'Design and deploy scalable cloud microservices for European fintech clients.',
        postedAgo: '2 days ago',
        requirements: ['React', 'Node.js', 'PostgreSQL', 'Docker/AWS'],
        isFeatured: true,
      ),
      const Job(
        id: 'job_3',
        title: 'Associate UI/UX Product Designer',
        company: 'Sysco LABS Sri Lanka',
        location: 'Colombo 07',
        type: 'Part-time',
        salaryRange: 'LKR 150,000 - 220,000 / month',
        description: 'Create user journeys, mobile component libraries, and Figma prototypes for global food supply platform.',
        postedAgo: '3 days ago',
        requirements: ['Figma expertise', 'User research', 'Wireframing', 'Design Systems'],
        isFeatured: false,
      ),
      const Job(
        id: 'job_4',
        title: 'Mobile App QA & Test Automation Intern',
        company: 'WSO2',
        location: 'Trace Expert City, Maradana',
        type: 'Internship',
        salaryRange: 'LKR 65,000 / month',
        description: 'Learn automated mobile UI testing using Flutter Driver, Appium, and CI/CD pipelines.',
        postedAgo: 'Just now',
        requirements: ['BSc in CS/IT or final year student', 'Basic Dart/Python', 'Analytical mindset'],
        isFeatured: false,
      ),
      const Job(
        id: 'job_5',
        title: 'Remote DevOps & Cloud Architect',
        company: 'Zone24x7',
        location: 'Remote (Sri Lanka)',
        type: 'Remote',
        salaryRange: 'LKR 450,000 - 650,000 / month',
        description: 'Manage Kubernetes clusters, Terraform infrastructure, and GitHub Actions for AI edge platforms.',
        postedAgo: '4 days ago',
        requirements: ['Kubernetes', 'AWS/GCP', 'Terraform', 'CI/CD'],
        isFeatured: true,
      ),
    ];

    emit(JobLoaded(jobs: mockJobs));
  }

  void setFilter(String filter) {
    if (state is JobLoaded) {
      final current = state as JobLoaded;
      emit(JobLoaded(
        jobs: current.jobs,
        activeFilter: filter,
        searchQuery: current.searchQuery,
      ));
    }
  }

  void setSearchQuery(String query) {
    if (state is JobLoaded) {
      final current = state as JobLoaded;
      emit(JobLoaded(
        jobs: current.jobs,
        activeFilter: current.activeFilter,
        searchQuery: query,
      ));
    }
  }

  void addJob(Job newJob) {
    if (state is JobLoaded) {
      final current = state as JobLoaded;
      final updatedList = [newJob, ...current.jobs];
      emit(JobLoaded(
        jobs: updatedList,
        activeFilter: current.activeFilter,
        searchQuery: current.searchQuery,
      ));
    }
  }
}
