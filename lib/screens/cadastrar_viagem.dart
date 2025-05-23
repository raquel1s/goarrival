import 'package:flutter/material.dart';
import 'package:goarrival/components/Box.dart';
import 'package:goarrival/screens/usuario.dart';

class CadastrarViagem extends StatefulWidget {
  const CadastrarViagem({super.key});

  @override
  State<CadastrarViagem> createState() => _CadastrarViagemState();
}

class _CadastrarViagemState extends State<CadastrarViagem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GOARRIVAL'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: (){
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Usuario())
                );
              }, 
              icon: const Icon(Icons.account_circle),
            ),
          )
        ],
      ),
      body: Box(
        child: SizedBox.shrink()
      )
    );
  }
}


