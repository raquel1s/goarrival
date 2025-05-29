import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(60),
          margin: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Image(image: AssetImage('assets/logo.png')),
              SizedBox(height: 30),
              Text(
                "Bem-vindo",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 38,
                  color: Color(0xFF12455C),
                ),
              ),
              Text(
                "Viajante",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 38,
                  color: Color(0xFF2C6B85),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  // Funçao login google/ vou por ainda
                },
                icon: FaIcon(
                  FontAwesomeIcons.google,
                  color: Colors.white,
                  size: 24,
                ),
                label: Text(
                  'Entrar com Google',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Color(0xFF12455C),
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
