import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'data/app_database.dart';
import 'services/inventario_remote_service.dart';
import 'services/inventario_repository.dart';
import 'pages/inventario_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runZonedGuarded(
    () async {
      final database = AppDatabase();
      final remoteService = InventarioRemoteService();
      final repository = InventarioRepository(
        localDb: database,
        remoteService: remoteService,
      );
      runApp(MyApp(repository: repository));
    },
    (error, stack) {},
  );
}

class MyApp extends StatelessWidget {
  final InventarioRepository repository;
  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventario App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: InventarioPage(repository: repository),
    );
  }
}
