import 'package:depi_fianl/HomePage.dart';
import 'package:depi_fianl/chart_page.dart';
import 'package:depi_fianl/service_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await Hive.openBox('meter_box');
  await Supabase.initialize(
    url: 'https://vgyadognmrouggawxguz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZneWFkb2dubXJvdWdnYXd4Z3V6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE2ODA1NTYsImV4cCI6MjA3NzI1NjU1Nn0.Pa2ewm1jv0QuRQd0l0EfyJyoPgqv5Hz8HAyywyhVuAs',
  );
  runApp(const MyApp());
}

final cloud = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        fontFamily: 'Poppins',
      ),
      home: ServicePage(),
    );
  }
}
