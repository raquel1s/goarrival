import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:goarrival/controller/viagem_controller.dart';
import 'package:latlong2/latlong.dart';
import 'package:goarrival/models/viagem.dart';

class MapaViagens extends StatefulWidget {
  const MapaViagens({Key? key}) : super(key: key);

  @override
  State<MapaViagens> createState() => _MapaViagensState();
}

class _MapaViagensState extends State<MapaViagens> {
  final ControleViagens _controleViagens = ControleViagens();
  List<Marker> _marcadores = [];
  final MapController _mapController = MapController();
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarMarcadores();
  }

  Future<void> _carregarMarcadores() async {
    setState(() {
      _carregando = true;
    });

    await _controleViagens.carregarDados();

    List<Marker> novosMarcadores = [];

    for (Viagem viagem in _controleViagens.viagens) {
      if (viagem.latitude != null && viagem.longitude != null) {
        novosMarcadores.add(
          Marker(
            width: 40,
            height: 40,
            point: LatLng(viagem.latitude!, viagem.longitude!),
            child: Tooltip(
              message:
                  '${viagem.local}\n${_formatarData(viagem.dataInicio)} - ${_formatarData(viagem.dataFim)}',
              child: const Icon(Icons.location_on, color: Colors.red, size: 40),
            ),
          ),
        );
      }
    }

    setState(() {
      _marcadores = novosMarcadores;
      _carregando = false;
    });

    if (novosMarcadores.isNotEmpty) {
      _mapController.move(novosMarcadores.first.point, 5.0);
    } else {
      _mapController.move(LatLng(0, 0), 2.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _carregando
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: LatLng(0, 0),
                  initialZoom: 2.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.goarrival',
                  ),
                  MarkerLayer(markers: _marcadores),
                ],
              ),
    );
  }

  String _formatarData(String data) {
    final DateTime date = DateTime.parse(data);
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
