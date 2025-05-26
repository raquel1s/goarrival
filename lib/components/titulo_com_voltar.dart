import 'package:flutter/material.dart';

// Exibe título centralizado com botão de voltar alinhado à esquerda
class TituloComVoltar extends StatelessWidget {
  const TituloComVoltar({super.key, required this.titulo});

  final String titulo;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.chevron_left,
                color: Color(0xFF12455C),
                size: 30,
              ),
            ),
          ),

          Center(
            child: const Text(
              'PERFIL',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF12455C),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
