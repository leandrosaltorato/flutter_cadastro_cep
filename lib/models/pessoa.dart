class Pessoa {
  final String id;
  final String nome;
  final String cep;
  final String numero;
  final String complemento;
  final String rua;
  final String bairro;
  final String cidade;
  final String estado;

  Pessoa({
    required this.id,
    required this.nome,
    required this.cep,
    required this.numero,
    required this.complemento,
    required this.rua,
    required this.bairro,
    required this.cidade,
    required this.estado,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'cep': cep,
        'numero': numero,
        'complemento': complemento,
        'rua': rua,
        'bairro': bairro,
        'cidade': cidade,
        'estado': estado,
      };

  factory Pessoa.fromJson(Map<String, dynamic> json) => Pessoa(
        id: json['id'] as String,
        nome: json['nome'] as String,
        cep: json['cep'] as String,
        numero: json['numero'] as String,
        complemento: (json['complemento'] ?? '') as String,
        rua: json['rua'] as String,
        bairro: json['bairro'] as String,
        cidade: json['cidade'] as String,
        estado: json['estado'] as String,
      );
}
