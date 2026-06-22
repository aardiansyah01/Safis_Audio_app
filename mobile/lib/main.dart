import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view/pages/main_navigation_page.dart';
import 'view/pages/home_page.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'viewmodel/upload_viewmodel.dart';
import 'package:provider/provider.dart';

import 'viewmodel/upload_viewmodel.dart';
import 'viewmodel/history_viewmodel.dart';

void main() {
  sqfliteFfiInit();

  databaseFactory = databaseFactoryFfi;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UploadViewModel()),

        ChangeNotifierProvider(create: (_) => HistoryViewModel()),
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
      home: MainNavigationPage(),
    );
  }
}
