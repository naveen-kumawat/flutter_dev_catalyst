import 'package:flutter/material.dart';
import 'package:flutter_dev_catalyst/flutter_dev_catalyst.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize DevCatalyst
  await DevCatalyst.initialize(
    apiBaseUrl: 'https://jsonplaceholder.typicode.com',
    enableLogging: true,
    logLevel: LogLevel.debug,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevCatalyst Example',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
