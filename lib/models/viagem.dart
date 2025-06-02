class Viagem {
  String? id;
  final String local;
  final String descricao;
  final String dataInicio;
  final String dataFim;
  final List<String> fotos;
  double? latitude;
  double? longitude;

  Viagem({
    this.id,
    required this.local,
    required this.descricao,
    required this.dataInicio,
    required this.dataFim,
    required this.fotos,
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
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Viagem.fromJson(Map<String, dynamic> json, String id) {
    return Viagem(
      id: id,
      local: json['local'],
      descricao: json['descricao'],
      dataInicio: json['dataInicio'],
      dataFim: json['dataFim'],
      fotos: List<String>.from(json['fotos'] ?? []),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }
}