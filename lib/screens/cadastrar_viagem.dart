import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goarrival/components/Box.dart';
import 'package:goarrival/controller/viagem_controller.dart';
import 'package:goarrival/models/viagem.dart';
import 'package:goarrival/provider/theme_provider.dart';
import 'package:goarrival/screens/tela_viagens.dart';
import 'package:goarrival/services/geocoding_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CadastrarViagem extends StatefulWidget {
  final ControleViagens controleViagens;

  const CadastrarViagem({super.key, required this.controleViagens});

  @override
  State<CadastrarViagem> createState() => _CadastrarViagemState();
}

class _CadastrarViagemState extends State<CadastrarViagem> {
  final _formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser;

  String local = '';
  String descricao = '';
  DateTime? dataInicio;
  DateTime? dataFim;
  List<String> fotos = [];

  String? erroDataInicio;
  String? erroDataFim;

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

  String? _validarDataInicio() {
    if (dataInicio == null) return "Selecione a data de início";
    return null;
  }

  String? _validarDataFim() {
    if (dataFim == null) return "Selecione a data de fim";
    if (dataInicio != null && dataFim!.isBefore(dataInicio!)) {
      return "A data de fim deve ser posterior à data de início";
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
                    icon: Icon(
                      Icons.chevron_left,
                      color: Theme.of(context).colorScheme.primary,
                      size: 30,
                    ),
                  ),
                  Text(
                    "CADASTRAR VIAGEM",
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
                      _exibirErro(erroDataInicio),
                      const SizedBox(height: 16),
                      dateTileField(
                        label: 'Data fim',
                        selectedDate: dataFim,
                        onTap: () => _selecionarData(context, false),
                      ),
                      _exibirErro(erroDataFim),
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
                            color: Theme.of(context).inputDecorationTheme.fillColor,
                          ),
                          child:
                              fotos.isEmpty
                                  ? Center(
                                    child: Icon(
                                      Icons.add,
                                      size: 50,
                                      color: Theme.of(context).colorScheme.primary,
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
                            onPressed: () async {
                              setState(() {
                                erroDataInicio = _validarDataInicio();
                                erroDataFim = _validarDataFim();
                              });

                              if (_formKey.currentState!.validate() &&
                                  erroDataInicio == null &&
                                  erroDataFim == null) {
                                _formKey.currentState!.save();
                                final coordenadas =
                                    await GeocodingService.getCoordinates(
                                      local,
                                    );
                                final novaViagem = Viagem(
                                  local: local,
                                  descricao: descricao,
                                  dataInicio: dataInicio.toString(),
                                  dataFim: dataFim.toString(),
                                  fotos: fotos,
                                  usuarioEmail: user?.email ?? '',
                                  latitude: coordenadas?.latitude,
                                  longitude: coordenadas?.longitude,
                                );

                                await widget.controleViagens.adicionarViagem(
                                  novaViagem,
                                );
                                Navigator.pop(context, true);
                              }
                            },
                            child: Text(
                              'Cadastrar',
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

  Widget _exibirErro(String? erro) {
    if (erro != null) {
      return Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Text(
          erro,
          style: Theme.of(context).inputDecorationTheme.errorStyle,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildTextField(
    String label,
    Function(String?) onSaved, {
    int maxLines = 1,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
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
        color: Theme.of(context).inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(label),
        subtitle: Text(
          selectedDate == null
              ? 'Selecione a data'
              : '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        trailing: Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.primary),
        onTap: onTap,
      ),
    );
  }
}
