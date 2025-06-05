class Usuario {
  final String nome;
  final String email;

  Usuario({
    required this.nome,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'email': email,
    };
  }

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      nome: json['nome'],
      email: json['email'],
    );
  }
}