import 'dart:convert';
import 'package:goarrival/models/viagem.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ControleViagens {
  static const String _keyViagens = 'lista_viagens';
  final List<Viagem> _viagens = [];

  List<Viagem> get viagens => _viagens;

  Future<void> carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dadosSalvos = prefs.getString(_keyViagens);

    if (dadosSalvos != null) {
      final List<dynamic> jsonList = jsonDecode(dadosSalvos);
      _viagens.clear();
      _viagens.addAll(jsonList.map((json) => Viagem.fromJson(json)).toList());
    }
  }

  Future<void> adicionarViagem(Viagem viagem) async {
    _viagens.add(viagem);
    await _salvarDados();
  }

  Future<void> removerViagem(int index) async {
    _viagens.removeAt(index);
    await _salvarDados();
  }

  Future<void> _salvarDados() async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonList = jsonEncode(_viagens.map((v) => v.toJson()).toList());
    await prefs.setString(_keyViagens, jsonList);
  }
}