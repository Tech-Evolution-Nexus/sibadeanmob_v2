import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sibadeanmob_v2/providers/auth_provider.dart';
import 'package:sibadeanmob_v2/views/auth/register.dart';
import 'package:sibadeanmob_v2/views/auth/splash.dart';
import 'package:sibadeanmob_v2/views/dashboard_comunity/dashboard/dashboard_warga.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sibadean',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: DashboardPage(),
    );
  }
}
