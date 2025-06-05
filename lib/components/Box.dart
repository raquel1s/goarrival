import 'package:flutter/material.dart';

class Box extends StatelessWidget {
  const Box({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    // Proporções — ajuste como quiser
    final double boxWidth = screenSize.width * 0.9;   // 90% da largura // 50% da altura

    return Center(
      child: Container(
        width: boxWidth,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 10),
          ],
        ),
        child: child,
      ),
    );
  }
}
