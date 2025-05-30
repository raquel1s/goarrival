import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:goarrival/controller/viagem_controller.dart';
import 'package:goarrival/screens/login.dart';
import 'package:goarrival/screens/tela_viagens.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
    
  runApp(const GoArrival());
}

class GoArrival extends StatelessWidget {
  const GoArrival({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GOARRIVAL',
      theme: ThemeData(
        primaryColor: const Color(0xFF12455C),
        scaffoldBackgroundColor: const Color(0xFFF8F9F8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF12455C),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF12455C),
          secondary: const Color(0xFFF8F9F8),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
          titleLarge: TextStyle(
            color: Color(0xFF12455C),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: Login(),
    );
  }
}