import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:goarrival/components/Box.dart';
import 'package:goarrival/controller/viagem_controller.dart';
import 'package:goarrival/models/viagem.dart';
import 'package:goarrival/screens/tela_viagens.dart';
import 'package:goarrival/screens/usuario.dart';
import 'package:image_picker/image_picker.dart';

class CadastrarViagem extends StatefulWidget {
  final ControleViagens controleViagens;

  const CadastrarViagem({super.key, required this.controleViagens});

  @override
  State<CadastrarViagem> createState() => _CadastrarViagemState();
}

class _CadastrarViagemState extends State<CadastrarViagem> {
  final _formKey = GlobalKey<FormState>();

  String local = '';
  String descricao = '';
  DateTime? dataInicio;
  DateTime? dataFim;
  List<String> fotos = [];

  final ImagePicker _picker = ImagePicker();

  Future<void> _selecionarData(BuildContext context, bool isInicio) async {
    final DateTime? escolhida = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );

    if (escolhida != null) {
      setState(() {
        if (isInicio) {
          dataInicio = escolhida;
        } else {
          dataFim = escolhida;
        }
      });
    }
  }

  String? _validarDatas() {
    if (dataInicio == null || dataFim == null) {
      return "Preencha ambas as datas";
    } else if (dataInicio!.isAfter(dataFim!)) {
      return "A data de início deve ser anterior à data de fim";
    }
    return null;
  }

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
          padding: const EdgeInsets.all(16.0),
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
                    "CADASTRAR VIAGEM",
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTextField(
                        'Local da viagem',
                        (value) => local = value!,
                      ),
                      const SizedBox(height: 16),
                      dateTileField(
                        label: 'Data início',
                        selectedDate: dataInicio,
                        onTap: () => _selecionarData(context, true),
                      ),
                      const SizedBox(height: 16),
                      dateTileField(
                        label: 'Data fim',
                        selectedDate: dataFim,
                        onTap: () => _selecionarData(context, false),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        'Descrição',
                        (value) => descricao = value!,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _adicionarFoto,
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[200],
                          ),
                          child:
                              fotos.isEmpty
                                  ? const Center(
                                    child: Icon(
                                      Icons.add,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  )
                                  : GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 4,
                                          mainAxisSpacing: 4,
                                        ),
                                    itemCount: fotos.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Image.memory(
                                        base64Decode(fotos[index]),
                                      );
                                    },
                                  ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF12455C),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate() &&
                                  _validarDatas() == null) {
                                _formKey.currentState!.save();
                                final novaViagem = Viagem(
                                  local: local,
                                  descricao: descricao,
                                  dataInicio: dataInicio.toString(),
                                  dataFim: dataFim.toString(),
                                  fotos: fotos,
                                );

                                await widget.controleViagens.adicionarViagem(
                                  novaViagem,
                                );
                                Navigator.pop(
                                  context,
                                  true,
                                ); // <== retorna true para indicar que cadastrou
                              } else {
                                final erroDatas = _validarDatas();
                                if (erroDatas != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(erroDatas),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            child: const Text(
                              'Cadastrar',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    Function(String?) onSaved, {
    int maxLines = 1,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      maxLines: maxLines,
      validator:
          (value) => value == null || value.isEmpty ? 'Informe $label' : null,
      onSaved: onSaved,
    );
  }

  Widget dateTileField({
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(label),
        subtitle: Text(
          selectedDate == null
              ? 'Selecione a data'
              : '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}',
          style: TextStyle(
            color: selectedDate == null ? Colors.grey : Colors.black,
          ),
        ),
        trailing: const Icon(Icons.calendar_today, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
