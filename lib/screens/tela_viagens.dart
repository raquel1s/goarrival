import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:goarrival/controller/viagem_controller.dart';
import 'package:goarrival/provider/theme_provider.dart';
import 'package:goarrival/screens/cadastrar_viagem.dart';
import 'package:goarrival/screens/viagem_detalhes.dart';
import 'package:goarrival/screens/mapa_viagens.dart';
import 'package:goarrival/screens/tela_usuario.dart';
import 'package:provider/provider.dart';

class TelaViagens extends StatefulWidget {
  const TelaViagens({super.key, required ControleViagens controleViagens});

  @override
  State<TelaViagens> createState() => _TelaViagensState();
}

class _TelaViagensState extends State<TelaViagens> {
  int _paginaAtual = 0;
  bool _dadosCarregados = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_dadosCarregados) {
      final controleViagens = Provider.of<ControleViagens>(context, listen: false);
      controleViagens.carregarDadosComId().then((_) {
        setState(() {
          _dadosCarregados = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controleViagens = Provider.of<ControleViagens>(context);
    final viagens = controleViagens.viagens;

    // Ordena as viagens por dataFim (mais recentes primeiro)
    viagens.sort((a, b) {
      DateTime dataA = DateTime.parse(a.dataFim);
      DateTime dataB = DateTime.parse(b.dataFim);
      return dataB.compareTo(dataA);
    });

    final List<Widget> paginas = [
      _buildTelaViagens(viagens, controleViagens),
      const MapaViagens(),
      const Usuario(),
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('GOARRIVAL'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: IconButton(
              icon: Icon(
                context.watch<ThemeProvider>().themeMode == ThemeMode.dark
                    ? Icons.wb_sunny
                    : Icons.nightlight_round,
              ),
              onPressed: () {
                context.read<ThemeProvider>().toggleTheme();
              },
            ),
          ),
        ],
      ),
      body: paginas[_paginaAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _paginaAtual,
        onTap: (index) {
          setState(() {
            _paginaAtual = index;
          });
        },
        selectedItemColor: Theme.of(context).colorScheme.primary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.travel_explore),
            label: 'Viagens',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mapa'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Usuário'),
        ],
      ),
    );
  }

  Widget _buildTelaViagens(List viagens, ControleViagens controleViagens) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Center(
            child: Text(
              "Guarde suas melhores memórias no GOARRIVAL",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
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
                    controleViagens: controleViagens,
                  ),
                ),
              );

              if (result == true) {
                await controleViagens.carregarDadosComId();
                setState(() {});
              }
            },
            child: Row(
              children: [
                Text(
                  "CADASTRAR VIAGEM",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.add_circle_outline,
                    color: Theme.of(context).colorScheme.primary,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 45),
          Text(
            'ÚLTIMAS VIAGENS',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    subtitle: Text(
                      '${_formatarData(viagem.dataInicio)} - ${_formatarData(viagem.dataFim)}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: () async {
                        await controleViagens.removerViagem(index);
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
