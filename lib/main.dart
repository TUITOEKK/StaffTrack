import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:staff_performance_mapping/providers/auth_provider.dart';
import 'package:staff_performance_mapping/screens/auth/login_screen.dart';
import 'package:staff_performance_mapping/screens/user/user_home_screen.dart';
import 'package:staff_performance_mapping/screens/admin/admin_dashboard.dart';
import 'package:staff_performance_mapping/screens/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Initialize Hive and open a box for pending reports
  await Hive.initFlutter();
  await Hive.openBox('reportQueue');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Staff Performance Mapping',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);
    return StreamBuilder(
      stream: authProvider.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return LoginScreen();
          }
          return FutureBuilder<bool>(
            future: authProvider.isAdmin(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == true) {
                  return AdminDashboard();
                } else {
                  return UserHomeScreen();
                }
              }
              return const SplashScreen();
            },
          );
        }
        return const SplashScreen();
      },
    );
  }
}
