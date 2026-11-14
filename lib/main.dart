import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/router/app_router.dart';
import 'core/services/hive_service.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'features/dictionary/presentation/cubit/dictionary_cubit.dart';
import 'features/hospitals/presentation/cubit/hospital_cubit.dart';
import 'features/jobs/presentation/cubit/job_cubit.dart';
import 'features/news/presentation/cubit/news_cubit.dart';
import 'features/productivity/presentation/cubit/productivity_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase safely
  try {
    await Firebase.initializeApp();
  } catch (_) {
    // Gracefully fallback when Firebase credentials are not attached yet
  }

  // Initialize Hive local offline-first database
  await HiveService.init();

  // Initialize Local Notifications
  await NotificationService.init();

  runApp(const LankaPulseApp());
}

class LankaPulseApp extends StatelessWidget {
  const LankaPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        BlocProvider<NewsCubit>(create: (_) => NewsCubit()),
        BlocProvider<HospitalCubit>(create: (_) => HospitalCubit()),
        BlocProvider<JobCubit>(create: (_) => JobCubit()),
        BlocProvider<DictionaryCubit>(create: (_) => DictionaryCubit()),
        BlocProvider<ProductivityCubit>(create: (_) => ProductivityCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'LankaPulse',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
