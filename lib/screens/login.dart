import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:goarrival/screens/tela_viagens.dart';
import 'package:goarrival/controller/viagem_controller.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    try {
      final redirectResult = await FirebaseAuth.instance.getRedirectResult();

      if (redirectResult.user != null) {
        _navigateToHome();
        return;
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _navigateToHome();
        return;
      }

      setState(() => _loading = false);
    } catch (e) {
      print("Erro ao recuperar login: $e");
      setState(() => _loading = false);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider.setCustomParameters({'prompt': 'select_account'});

      if (kIsWeb) {
        await FirebaseAuth.instance.signInWithPopup(googleProvider);
        _navigateToHome();
      } else {
        await FirebaseAuth.instance.signInWithRedirect(googleProvider);
      }
    } catch (e) {
      print("Erro ao fazer login com Google: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao iniciar login.')),
      );
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TelaViagens(controleViagens: ControleViagens()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(60),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              const BoxShadow(color: Colors.black26, blurRadius: 10)
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Image(image: AssetImage('assets/logo.png')),
              const SizedBox(height: 30),
              const Text(
                "Bem-vindo",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 38,
                  color: Color(0xFF12455C),
                ),
              ),
              const Text(
                "Viajante",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 38,
                  color: Color(0xFF2C6B85),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: signInWithGoogle,
                icon: const FaIcon(
                  FontAwesomeIcons.google,
                  color: Colors.white,
                  size: 24,
                ),
                label: const Text(
                  'Entrar com Google',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  backgroundColor: const Color(0xFF12455C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
