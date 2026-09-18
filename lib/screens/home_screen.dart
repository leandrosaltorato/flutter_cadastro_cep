import 'package:flutter/material.dart';
import '../models/pessoa.dart';
import '../services/storage_service.dart';
import '../widgets/app_drawer.dart';
import 'cadastro_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Pessoa> _pessoas = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarPessoas();
  }

  Future<void> _carregarPessoas() async {
    setState(() => _carregando = true);
    final lista = await StorageService.listarPessoas();
    setState(() {
      _pessoas = lista;
      _carregando = false;
    });
  }

  Future<void> _abrirCadastro() async {
    final resultado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const CadastroScreen()),
    );
    if (resultado == true) {
      _carregarPessoas();
    }
  }

  Future<void> _remover(Pessoa pessoa) async {
    await StorageService.removerPessoa(pessoa.id);
    _carregarPessoas();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${pessoa.nome} removido')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pessoas cadastradas'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: _carregarPessoas,
        child: _carregando
            ? const Center(child: CircularProgressIndicator())
            : _pessoas.isEmpty
                ? ListView(
                    children: const [
                      SizedBox(height: 120),
                      Center(
                        child: Text(
                          'Nenhuma pessoa cadastradaa',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _pessoas.length,
                    itemBuilder: (context, index) {
                      final pessoa = _pessoas[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFF2E7D32),
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(
                            pessoa.nome,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${pessoa.rua}, ${pessoa.numero}'
                            '${pessoa.complemento.isNotEmpty ? ' - ${pessoa.complemento}' : ''}\n'
                            '${pessoa.bairro} - ${pessoa.cidade}/${pessoa.estado}\n'
                            'CEP: ${pessoa.cep}',
                          ),
                          isThreeLine: true,
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red),
                            onPressed: () => _remover(pessoa),
                          ),
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2E7D32),
        onPressed: _abrirCadastro,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
