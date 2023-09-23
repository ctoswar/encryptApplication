import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterencryption/firebase_options.dart';
import 'package:flutterencryption/services/auth/auth_gate.dart';
import 'package:flutterencryption/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Load the JSON file directly without a context
  final String keysFile = await loadKeysFile('assets/keys.json');
  final Map<String, dynamic> keysData = jsonDecode(keysFile);

  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(keysData),
      child: const MyApp(),
    ),
  );
}

Future<String> loadKeysFile(String assetPath) async {
  // Load the JSON file directly
  final ByteData data = await rootBundle.load(assetPath);
  return utf8.decode(data.buffer.asUint8List());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
