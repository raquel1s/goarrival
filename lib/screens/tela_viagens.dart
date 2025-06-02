import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:goarrival/controller/viagem_controller.dart';
import 'package:goarrival/screens/cadastrar_viagem.dart';
import 'package:goarrival/screens/viagem_detalhes.dart';
import 'package:goarrival/screens/mapa_viagens.dart';
import 'package:goarrival/screens/usuario.dart';

class TelaViagens extends StatefulWidget {
  final ControleViagens controleViagens;

  const TelaViagens({super.key, required this.controleViagens});

  @override
  State<TelaViagens> createState() => _TelaViagensState();
}

class _TelaViagensState extends State<TelaViagens> {
  int _paginaAtual = 0;

  @override
  void initState() {
    super.initState();
    widget.controleViagens.carregarDadosComId().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final viagens = widget.controleViagens.viagens;

    viagens.sort((a, b) {
      DateTime dataA = DateTime.parse(a.dataFim);
      DateTime dataB = DateTime.parse(b.dataFim);
      return dataB.compareTo(dataA);
    });

    final List<Widget> paginas = [
      _buildTelaViagens(viagens),
      const MapaViagens(),
      const Usuario(),
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('GOARRIVAL'),
      ),
      body: paginas[_paginaAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _paginaAtual,
        onTap: (index) {
          setState(() {
            _paginaAtual = index;
          });
        },
        selectedItemColor: const Color(0xFF12455C),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.travel_explore),
            label: 'Viagens',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Usuário',
          ),
        ],
      ),
    );
  }

  Widget _buildTelaViagens(List viagens) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(30.0),
            child: Center(
              child: Text(
                "Guarde suas melhores memórias no GOARRIVAL",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF12455C), fontSize: 20),
              ),
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CadastrarViagem(
                    controleViagens: widget.controleViagens,
                  ),
                ),
              );

              if (result == true) {
                await widget.controleViagens.carregarDadosComId();
                setState(() {});
              }
            },
            child: Row(
              children: const [
                Text(
                  "CADASTRAR VIAGEM",
                  style: TextStyle(
                    color: Color(0xFF12455C),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.add_circle_outline,
                    color: Color(0xFF12455C),
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 45),
          const Text(
            'ÚLTIMAS VIAGENS',
            style: TextStyle(
              fontSize: 17,
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
                      icon: const Icon(Icons.delete, color: Color(0xFF12455C)),
                      onPressed: () async {
                        await widget.controleViagens.removerViagem(index);
                        setState(() {});
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViagemDetalhes(viagem: viagem),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatarData(String data) {
    final DateTime date = DateTime.parse(data);
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
