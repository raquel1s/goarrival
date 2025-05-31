import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:goarrival/components/Box.dart';
import 'package:goarrival/controller/viagem_controller.dart';
import 'package:goarrival/models/viagem.dart';
import 'package:goarrival/screens/tela_viagens.dart';
import 'package:goarrival/screens/usuario.dart';
import 'package:goarrival/services/geocoding_service.dart';
import 'package:latlong2/latlong.dart';

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
                    icon: const Icon(
                      Icons.chevron_left,
                      color: Color(0xFF12455C),
                      size: 30,
                    ),
                  ),
                  const Text(
                    "DETALHES VIAGEM",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF12455C),
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
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${_formatarData(viagem.dataInicio)} - ${_formatarData(viagem.dataFim)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      viagem.descricao,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blueGrey,
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
                                          ? Colors.blueGrey
                                          : Colors.blueGrey.withAlpha(
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
                        ? const Text(
                          'Localização no mapa:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
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
