class Viagem {
  final String local;
  final String descricao;
  final String dataInicio;
  final String dataFim;
  final List<String> fotos;

  Viagem({
    required this.local,
    required this.descricao,
    required this.dataInicio,
    required this.dataFim,
    required this.fotos,
  });

  Map<String, dynamic> toJson() {
    return {
      'local': local,
      'descricao': descricao,
      'dataInicio': dataInicio,
      'dataFim': dataFim,
      'fotos': fotos,
    };
  }

  factory Viagem.fromJson(Map<String, dynamic> json) {
    return Viagem(
      local: json['local'],
      descricao: json['descricao'],
      dataInicio: json['dataInicio'],
      dataFim: json['dataFim'],
      fotos: List<String>.from(json['fotos'] ?? []),
    );
  }
}
