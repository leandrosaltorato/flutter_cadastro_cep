import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pessoa.dart';

class StorageService {
  static const _key = 'pessoas_cadastradas';

  static Future<List<Pessoa>> listarPessoas() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    return jsonList
        .map((e) => Pessoa.fromJson(json.decode(e) as Map<String, dynamic>))
        .toList();
  }

  static Future<void> salvarPessoa(Pessoa pessoa) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    jsonList.add(json.encode(pessoa.toJson()));
    await prefs.setStringList(_key, jsonList);
  }

  static Future<void> removerPessoa(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    final pessoas = jsonList
        .map((e) => Pessoa.fromJson(json.decode(e) as Map<String, dynamic>))
        .where((p) => p.id != id)
        .map((p) => json.encode(p.toJson()))
        .toList();
    await prefs.setStringList(_key, pessoas);
  }
}
