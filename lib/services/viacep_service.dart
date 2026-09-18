import 'dart:convert';
import 'package:http/http.dart' as http;

class EnderecoViaCep {
  final String logradouro;
  final String bairro;
  final String localidade;
  final String uf;
  final bool erro;

  EnderecoViaCep({
    required this.logradouro,
    required this.bairro,
    required this.localidade,
    required this.uf,
    this.erro = false,
  });

  factory EnderecoViaCep.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('erro') && json['erro'] == true) {
      return EnderecoViaCep(
        logradouro: '',
        bairro: '',
        localidade: '',
        uf: '',
        erro: true,
      );
    }
    return EnderecoViaCep(
      logradouro: json['logradouro'] ?? '',
      bairro: json['bairro'] ?? '',
      localidade: json['localidade'] ?? '',
      uf: json['uf'] ?? '',
    );
  }
}

class ViaCepService {
  static Future<EnderecoViaCep?> buscarCep(String cep) async {
    final cepLimpo = cep.replaceAll(RegExp(r'[^0-9]'), '');
    if (cepLimpo.length != 8) return null;

    final url = Uri.parse('https://viacep.com.br/ws/$cepLimpo/json/');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return EnderecoViaCep.fromJson(data);
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
