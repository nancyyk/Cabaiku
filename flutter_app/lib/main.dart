import 'package:flutter/material.dart';
import 'utils/colors.dart';

// screens
import 'screens/home_screen.dart';

// auth
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cabaiku',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryGreen,
        useMaterial3: true,
        fontFamily: 'Inter',
      ),

      initialRoute: '/login',

      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(initialIndex: 0),
        '/scan': (context) => const HomeScreen(initialIndex: 1),
        '/tips': (context) => const HomeScreen(initialIndex: 2),
        '/history': (context) => const HomeScreen(initialIndex: 3),
        '/profile': (context) => const HomeScreen(initialIndex: 4),
      },
    );
  }
}
