import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vehicele/home/HomeScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAK-qz4Sr2BC0Npec_GPUQxYlGCX6mrUT8",
          appId: "vehilemanage",
          messagingSenderId: '',
          projectId: "vehilemanage"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
