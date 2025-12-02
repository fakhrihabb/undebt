import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:undebt/core/router/app_router.dart';
import 'package:undebt/core/theme/app_theme.dart';
import 'package:undebt/core/services/supabase_service.dart';
import 'package:undebt/core/services/local_storage_service.dart';
import 'package:undebt/core/providers/navigation_provider.dart';
import 'package:undebt/core/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await _initializeServices();
  
  runApp(const UndebApp());
}

Future<void> _initializeServices() async {
  try {
    // Initialize local storage (Hive)
    await LocalStorageService.instance.initialize();
    
    // Initialize Supabase
    await SupabaseService.instance.initialize();
  } catch (e) {
    debugPrint('Error initializing services: $e');
  }
}

class UndebApp extends StatelessWidget {
  const UndebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()..initializeMockUser()),
      ],
      child: MaterialApp.router(
        title: 'Undebt',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark, // Force dark mode for now
        routerConfig: AppRouter.router,
      ),
    );
  }
}
