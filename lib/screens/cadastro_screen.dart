import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/pessoa.dart';
import '../services/viacep_service.dart';
import '../services/storage_service.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _cepController = TextEditingController();
  final _numeroController = TextEditingController();
  final _complementoController = TextEditingController();
  final _ruaController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();

  bool _buscandoCep = false;
  bool _cepEncontrado = false;

  Future<void> _buscarCep(String cep) async {
    final cepLimpo = cep.replaceAll(RegExp(r'[^0-9]'), '');
    if (cepLimpo.length != 8) return;

    setState(() => _buscandoCep = true);

    final endereco = await ViaCepService.buscarCep(cepLimpo);

    if (!mounted) return;

    setState(() {
      _buscandoCep = false;
      if (endereco != null && !endereco.erro) {
        _ruaController.text = endereco.logradouro;
        _bairroController.text = endereco.bairro;
        _cidadeController.text = endereco.localidade;
        _estadoController.text = endereco.uf;
        _cepEncontrado = true;
      } else {
        _ruaController.clear();
        _bairroController.clear();
        _cidadeController.clear();
        _estadoController.clear();
        _cepEncontrado = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('CEP não encontrado. Verifique e tente novamente.')),
        );
      }
    });
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_cepEncontrado) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe um CEP válido antes de salvar.')),
      );
      return;
    }

    final pessoa = Pessoa(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nome: _nomeController.text.trim(),
      cep: _cepController.text.trim(),
      numero: _numeroController.text.trim(),
      complemento: _complementoController.text.trim(),
      rua: _ruaController.text.trim(),
      bairro: _bairroController.text.trim(),
      cidade: _cidadeController.text.trim(),
      estado: _estadoController.text.trim(),
    );

    await StorageService.salvarPessoa(pessoa);

    if (mounted) Navigator.pop(context, true);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cepController.dispose();
    _numeroController.dispose();
    _complementoController.dispose();
    _ruaController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Cadastro'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome:',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _cepController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(8),
                ],
                decoration: InputDecoration(
                  labelText: 'CEP:',
                  hintText: 'Somente números',
                  border: const OutlineInputBorder(),
                  suffixIcon: _buscandoCep
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : const Icon(Icons.search),
                ),
                validator: (v) =>
                    (v == null || v.length != 8) ? 'CEP inválido' : null,
                onChanged: (value) {
                  _cepEncontrado = false;
                  if (value.length == 8) {
                    _buscarCep(value);
                  }
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _ruaController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Rua:',
                  border: OutlineInputBorder(),
                  filled: true,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _bairroController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Bairro:',
                  border: OutlineInputBorder(),
                  filled: true,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _cidadeController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Cidade:',
                  border: OutlineInputBorder(),
                  filled: true,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _estadoController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Estado:',
                  border: OutlineInputBorder(),
                  filled: true,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _numeroController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Número:',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe o número' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _complementoController,
                decoration: const InputDecoration(
                  labelText: 'Complemento:',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _salvar,
                  label: const Text(
                    'Salvar Cadastro',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
