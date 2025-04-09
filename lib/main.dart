import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workout_tracker/config/constants/app_constants.dart';
import 'package:workout_tracker/features/dashboard/providers/dashboard_provider.dart';
import 'config/routes/app_routes.dart';
import 'config/themes/app_theme.dart';
import 'core/models/exercise.dart';
import 'core/models/workout.dart';
import 'core/models/workout_set.dart';
import 'core/models/user_settings.dart';
import 'core/providers/workout_provider.dart';
import 'core/providers/exercise_provider.dart';
import 'core/providers/analytics_provider.dart';
import 'core/providers/settings_provider.dart';
import 'core/services/notification_service.dart';
import 'features/dashboard/screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDir.path);
  
  // Register adapters
  Hive.registerAdapter(ExerciseAdapter());
  Hive.registerAdapter(WorkoutSetAdapter());
  Hive.registerAdapter(WorkoutAdapter());
  Hive.registerAdapter(WorkoutExerciseAdapter());
  Hive.registerAdapter(UserSettingsAdapter());
  
  // Open Hive boxes
  await Hive.openBox<Exercise>('exercises');
  await Hive.openBox<Workout>('workouts');
  await Hive.openBox<UserSettings>('settings');
  
  // Initialize notification services
  await NotificationService().initNotification();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => ExerciseProvider()),
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
        ChangeNotifierProvider(
          create: (context) => AnalyticsProvider(
            Provider.of<WorkoutProvider>(context, listen: false),
          ),
        ),
        // Add DashboardProvider here
        ChangeNotifierProvider(
          create: (context) => DashboardProvider(
            Provider.of<WorkoutProvider>(context, listen: false),
            Provider.of<ExerciseProvider>(context, listen: false),
          ),
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, _) {
          return MaterialApp(
            title: 'Workout Tracker',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            routes: AppRoutes.routes,
          );
        },
      ),
    );
  }
}