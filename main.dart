import 'package:flutter/material.dart';
//TESTE
void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatefulWidget {
  const MeuApp({super.key});

  @override
  State<MeuApp> createState() => _MeuAppState();
}

class _MeuAppState extends State<MeuApp> {
  final List<Tarefa> _tarefas = [];
  final TextEditingController controlador = TextEditingController();
  int? _indiceEdicao;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.blue,
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Mensagem( Nome do Grupo )'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _tarefas.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.blue[100],
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: ListTile(
                      title: Text(_tarefas[index].descricao),
                      leading: Checkbox(
                        value: _tarefas[index].status,
                        onChanged: (novoValor) {
                          setState(() {
                            _tarefas[index].status = novoValor ?? false;
                          });
                        },
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _editarTarefa(index);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _tarefas.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: controlador,
                      decoration: const InputDecoration(
                        hintText: 'Descrição',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.blue,
                      fixedSize: const Size(200, 60),
                    ),
                    child: const Text('Enviar'),
                    onPressed: () {
                      if (controlador.text.isEmpty) {
                        return;
                      }
                      setState(() {
                        if (_indiceEdicao == null) {
                          _tarefas.add(
                            Tarefa(
                              descricao: controlador.text,
                              status: false,
                            ),
                          );
                        } else {
                          _tarefas[_indiceEdicao!].descricao = controlador.text;
                          _indiceEdicao = null;
                        }
                        controlador.clear();
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _editarTarefa(int index) {
    controlador.text = _tarefas[index].descricao;
    _indiceEdicao = index;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Tarefa'),
          content: TextField(
            controller: controlador,
            decoration: const InputDecoration(
              hintText: 'Descrição',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _tarefas[index].descricao = controlador.text;
                });
                controlador.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Salvar'),
            ),
            TextButton(
              onPressed: () {
                controlador.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}

class Tarefa {
  String descricao;
  bool status;

  Tarefa({required this.descricao, required this.status});
}
