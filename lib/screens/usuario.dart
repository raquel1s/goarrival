import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goarrival/components/titulo_com_voltar.dart';
import 'package:image_picker/image_picker.dart';

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
                child: GestureDetector(
                  onTap: _adicionarFoto,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 135,
                        height: 140,
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child:
                            fotos.isEmpty
                                ? const Icon(
                                  Icons.account_circle,
                                  size: 150,
                                  color: Colors.grey,
                                )
                                : ClipOval(
                                  child: Image.memory(
                                    base64Decode(fotos.first),
                                    fit: BoxFit.cover,
                                    width: 150,
                                    height: 150,
                                  ),
                                ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.blueGrey,
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(Icons.add, size: 24, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 5),
                  Center(
                    child: const Text(
                      'NOME_USUARIO',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF12455C),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
