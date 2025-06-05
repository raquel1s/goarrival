import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:goarrival/controller/viagem_controller.dart';
import 'package:goarrival/provider/theme_provider.dart';
import 'package:goarrival/screens/login.dart';
import 'package:goarrival/screens/tela_usuario.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
        MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ControleViagens()), // <-- Novo provider
      ],
      child: const GoArrival(),
    ),
  );

}

class GoArrival extends StatelessWidget {
  const GoArrival({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

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
          secondary: const Color(0xFF2C6B85),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
          titleLarge: TextStyle(
            color: Color(0xFF12455C),
            fontWeight: FontWeight.bold,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          errorStyle: TextStyle(color: Colors.red, fontSize: 12),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.white,
        scaffoldBackgroundColor: const Color(0x6D6D6D6D),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0x00000000),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.dark,
        ).copyWith(
          primary: Colors.white,
          secondary: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[800],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide.none,
          ),
          errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
        ),
      ),
      themeMode: themeProvider.themeMode,
      initialRoute: '/home',
      routes: {
        '/login': (context) => const Login(),
        '/usuario': (context) => const Usuario(),
        '/home': (context) => const Login(),
      },
    );
  }
}
