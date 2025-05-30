import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goarrival/components/titulo_com_voltar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Usuario extends StatefulWidget {
  const Usuario({super.key});

  @override
  State<Usuario> createState() => _UsuarioState();
}

class _UsuarioState extends State<Usuario> {
  List<String> fotos = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _adicionarFoto() async {
    final XFile? imagem = await _picker.pickImage(source: ImageSource.gallery);
    if (imagem != null) {
      final bytes = await imagem.readAsBytes();
      final base64String = base64Encode(bytes);
      setState(() {
        fotos.add(base64String);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('GOARRIVAL'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TituloComVoltar(titulo: 'PERFIL'),
              const SizedBox(height: 20),

              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 135,
                      height: 140,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      child: ClipOval(
                        child:
                            user?.photoURL != null
                                ? Image.network(
                                  user!.photoURL!,
                                  fit: BoxFit.cover,
                                  width: 150,
                                  height: 150,
                                )
                                : const Icon(
                                  Icons.account_circle,
                                  size: 150,
                                  color: Colors.grey,
                                ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _adicionarFoto,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.blueGrey,
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(Icons.add, size: 24, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Center(
                child: Text(
                  user?.displayName ?? 'NOME_USUARIO',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF12455C),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
