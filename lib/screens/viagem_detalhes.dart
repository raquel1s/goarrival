import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:goarrival/components/Box.dart';
import 'package:goarrival/controller/viagem_controller.dart';
import 'package:goarrival/models/viagem.dart';
import 'package:goarrival/provider/theme_provider.dart';
import 'package:goarrival/screens/tela_viagens.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class ViagemDetalhes extends StatefulWidget {
  final Viagem viagem;

  const ViagemDetalhes({Key? key, required this.viagem}) : super(key: key);

  @override
  _ViagemDetalhesState createState() => _ViagemDetalhesState();
}

class _ViagemDetalhesState extends State<ViagemDetalhes> {
  int _paginaAtual = 0;
  late final PageController _pageController;
  final MapController _mapController = MapController();
  LatLng? _coordenadas;
  bool _carregandoMapa = true;

  void _carregarCoordenadas() {
    if (widget.viagem.latitude != null && widget.viagem.longitude != null) {
      setState(() {
        _coordenadas = LatLng(
          widget.viagem.latitude!,
          widget.viagem.longitude!,
        );
        _carregandoMapa = false;
      });
    } else {
      setState(() {
        _coordenadas = null;
        _carregandoMapa = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _carregarCoordenadas();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _formatarData(String data) {
    final DateTime date = DateTime.parse(data);
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final viagem = widget.viagem;

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
                    : Icons.nightlight_round
              ),
              onPressed: () {
                context.read<ThemeProvider>().toggleTheme();
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => TelaViagens(
                                controleViagens: ControleViagens(),
                              ),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.chevron_left,
                      color: Theme.of(context).colorScheme.primary,
                      size: 30,
                    ),
                  ),
                  Text(
                    "DETALHES VIAGEM",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Box(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      viagem.local,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${_formatarData(viagem.dataInicio)} - ${_formatarData(viagem.dataFim)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      viagem.descricao,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (viagem.fotos.isNotEmpty)
                      Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: viagem.fotos.length,
                              physics: const BouncingScrollPhysics(),
                              onPageChanged: (index) {
                                setState(() {
                                  _paginaAtual = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                Uint8List imagemBytes = base64Decode(
                                  viagem.fotos[index],
                                );
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.memory(
                                      imagemBytes,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              viagem.fotos.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                width: _paginaAtual == index ? 12 : 8,
                                height: _paginaAtual == index ? 12 : 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      _paginaAtual == index
                                          ? Theme.of(context).colorScheme.secondary
                                          : Theme.of(context).colorScheme.secondary.withAlpha(
                                            (0.4 * 255).toInt(),
                                          ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      SizedBox.shrink(),
                    const SizedBox(height: 16),
                    _carregandoMapa
                        ? Text(
                          'Localização no mapa:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        )
                        : SizedBox.shrink(),
                    const SizedBox(height: 8),
                    _carregandoMapa
                        ? const Center(child: CircularProgressIndicator())
                        : _coordenadas == null
                        ? Builder(
                          builder: (context) {
                            Future.delayed(Duration.zero, () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Não foi possível carregar o mapa.',
                                  ),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            });
                            return const SizedBox.shrink();
                          },
                        )
                        : SizedBox(
                          height: 200,
                          child: FlutterMap(
                            mapController: _mapController,
                            options: MapOptions(
                              initialCenter: _coordenadas!,
                              initialZoom: 13.0,
                              interactionOptions: const InteractionOptions(
                                flags: InteractiveFlag.all,
                              ),
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                subdomains: const ['a', 'b', 'c'],
                                userAgentPackageName: 'com.example.goarrival',
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    width: 40,
                                    height: 40,
                                    point: _coordenadas!,
                                    child: const Icon(
                                      Icons.location_on,
                                      size: 40,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
