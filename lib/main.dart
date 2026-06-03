import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/post_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';
import 'services/favorites_storage_service.dart';
import 'services/post_api_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storageService = FavoritesStorageService();
  final themeProvider = ThemeProvider()..loadTheme();

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => PostApiService()),
        Provider.value(value: storageService),
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider(
          create: (context) => PostProvider(
            apiService: context.read<PostApiService>(),
            storageService: context.read<FavoritesStorageService>(),
          )..initialize(),
        ),
      ],
      child: const MiniNewsReaderApp(),
    ),
  );
}

class MiniNewsReaderApp extends StatelessWidget {
  const MiniNewsReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini News Reader',
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
