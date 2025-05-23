import 'package:flutter/material.dart';

class Box extends StatelessWidget {
  const Box({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    // Proporções — ajuste como quiser
    final double boxWidth = screenSize.width * 0.9;   // 90% da largura
    final double boxHeight = screenSize.height * 0.7; // 50% da altura

    return Center(
      child: Container(
        width: boxWidth,
        height: boxHeight,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 10),
          ],
        ),
        child: child,
      ),
    );
  }
}
