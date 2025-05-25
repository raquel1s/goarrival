import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:goarrival/controller/viagem_controller.dart';
import 'package:goarrival/screens/cadastrar_viagem.dart';
import 'package:goarrival/screens/usuario.dart';

class TelaViagens extends StatefulWidget {
  final ControleViagens controleViagens;

  const TelaViagens({super.key, required this.controleViagens});

  @override
  State<TelaViagens> createState() => _TelaViagensState();
}

class _TelaViagensState extends State<TelaViagens> {
  @override
  void initState() {
    super.initState();
    widget.controleViagens.carregarDados().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final viagens = widget.controleViagens.viagens;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('GOARRIVAL'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Usuario()),
                );
              },
              icon: const Icon(Icons.account_circle),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Guarde suas melhores memórias no GOARRIVAL"),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => CadastrarViagem(
                          controleViagens: widget.controleViagens,
                        ),
                  ),
                );

                if (result == true) {
                  await widget.controleViagens.carregarDados();
                  setState(() {});
                }
              },
              child: Row(
                children: [
                  const Text("CADASTRAR VIAGEM"),
                  Icon(
                    Icons.add_circle_outline,
                    color: Color(0xFF12455C),
                    size: 30,
                  ),
                ],
              ),
            ),
            const Text(
              'ÚLTIMAS VIAGENS',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF12455C),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: viagens.length,
                itemBuilder: (context, index) {
                  final viagem = viagens[index];

                  Uint8List? imagem;

                  if (viagem.fotos.isNotEmpty) {
                    imagem = base64Decode(viagem.fotos.first);
                  }

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    child: ListTile(
                      leading: imagem != null
                              ? Image.memory(
                                imagem,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                              : Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.image,
                                  color: Colors.grey,
                                ),
                              ),
                      title: Text(
                        viagem.local,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF12455C),
                        ),
                      ),
                      subtitle: Text(
                        '${_formatarData(viagem.dataInicio)} - ${_formatarData(viagem.dataFim)}',
                        style: const TextStyle(color: Color(0xFF12455C)),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await widget.controleViagens.removerViagem(index);
                          setState(() {});
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatarData(String data) {
    final DateTime date = DateTime.parse(data);
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
