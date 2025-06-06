import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/viagem.dart';

class ControleViagens extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<Viagem> _viagens = [];

  List<Viagem> get viagens => _viagens;

  Future<void> carregarDadosComId() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception('Usuário não autenticado');

    final snapshot = await _firestore
        .collection('usuarios')
        .doc(uid)
        .collection('viagens')
        .get();

    _viagens
      ..clear()
      ..addAll(snapshot.docs.map((doc) => Viagem.fromJson(doc.data(), doc.id)));

    notifyListeners();
  }

  Future<void> adicionarViagem(Viagem viagem) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception('Usuário não autenticado');

    final docRef = await _firestore
        .collection('usuarios')
        .doc(uid)
        .collection('viagens')
        .add(viagem.toJson());

    viagem.id = docRef.id;

    await carregarDadosComId();
  }

  Future<void> removerViagem(int index) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception('Usuário não autenticado');

    if (index < 0 || index >= _viagens.length) return;

    final viagem = _viagens[index];
    if (viagem.id == null) return;

    await _firestore
        .collection('usuarios')
        .doc(uid)
        .collection('viagens')
        .doc(viagem.id)
        .delete();

    await carregarDadosComId();
  }
}
