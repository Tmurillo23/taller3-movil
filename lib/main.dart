import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'data/app_database.dart';
import 'services/mood_remote_service.dart';
import 'services/mood_repository.dart';
import 'pages/mood_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runZonedGuarded(
    () async {
      final database = AppDatabase();
      final remoteService = MoodRemoteService();
      final repository = MoodRepository(
        localDb: database,
        remoteService: remoteService,
      );
      runApp(MyApp(repository: repository));
    },
    (error, stack) {},
  );
}

class MyApp extends StatelessWidget {
  final MoodRepository repository;
  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MoodsPage(repository: repository),
    );
  }
}
