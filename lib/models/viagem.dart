class Viagem {
  final String local;
  final String descricao;
  final String dataInicio;
  final String dataFim;
  final List<String> fotos;
  final String usuarioEmail;
  double? latitude;
  double? longitude;

  Viagem({
    required this.local,
    required this.descricao,
    required this.dataInicio,
    required this.dataFim,
    required this.fotos,
    required this.usuarioEmail,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'local': local,
      'descricao': descricao,
      'dataInicio': dataInicio,
      'dataFim': dataFim,
      'fotos': fotos,
      'usuarioEmail': usuarioEmail,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Viagem.fromJson(Map<String, dynamic> json) {
    return Viagem(
      local: json['local'],
      descricao: json['descricao'],
      dataInicio: json['dataInicio'],
      dataFim: json['dataFim'],
      fotos: List<String>.from(json['fotos'] ?? []),
      usuarioEmail: json['usuarioEmail'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }
}