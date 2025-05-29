import 'package:flutter/material.dart';
import 'package:goarrival/screens/login.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [const Image(image: AssetImage('assets/logo.png'))],
          ),
          SizedBox(height: 80),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70.0),
            child: Text(
              "Guarde memórias, escreva emoções e deixe suas viagens eternizadas em cada página.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF12455C), fontSize: 17),
            ),
          ),
          SizedBox(height: 100),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF12455C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 85, vertical: 10),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
            child: Text(
              "Entrar",
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
        ],
      ),
    );
  }
}
