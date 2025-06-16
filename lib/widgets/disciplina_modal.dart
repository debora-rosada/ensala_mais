import 'package:ensala_mais/utils/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DisciplinaModal extends StatefulWidget {
  const DisciplinaModal({super.key});

  @override
  State<DisciplinaModal> createState() => _DisciplinaModalState();
}

class _DisciplinaModalState extends State<DisciplinaModal> {
  bool isFormVisible = false;
  bool isLoading = false;
  bool emptySelect = false;
  bool isEditMode = false;
  bool isInsertMode = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController turmaController = TextEditingController();
  int selectedRowId = 0;
  List<Map<String, dynamic>> filteredItems = [];
  List<Map<String, dynamic>> allItems = [];
  List<Map<String, dynamic>> turmas = [];

  @override
  void initState() {
    super.initState();
    _carregarTurmas();
  }

  Future<void> _carregarTurmas() async {
    try {
      final response = await Supabase.instance.client.from('turma').select('''
        id, curso, semestre, turma
      ''');
      setState(() {
        turmas = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Erro ao carregar turmas: $e');
    }
  }

  String _getNomeTurma(int? turmaId) {
    if (turmaId == null) return 'Nenhuma turma';
    final turma = turmas.firstWhere(
      (t) => t['id'] == turmaId,
      orElse: () => {'curso': 'Turma não encontrada', 'semestre': ''},
    );
    return '${turma['curso']} - ${turma['semestre']}º sem';
  }

  void resetControllerValue(List<TextEditingController> controllersList) {
    for (var controller in controllersList) {
      controller.text = '';
    }
  }

  String returnTitle() {
    if (isEditMode) {
      return 'Edição de disciplina';
    }
    if (isInsertMode) {
      return 'Cadastro de disciplina';
    }
    return 'Visualização de disciplina';
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = List.from(allItems);
      } else {
        filteredItems = allItems
            .where((item) =>
                item['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Supabase.instance.client.from('disciplina').select('''
        *, 
        turma:ID_turma(id, curso, semestre, turma)
      '''),
      builder: (context, snapshot) {
        isLoading = false;
        emptySelect = false;

        if (snapshot.connectionState == ConnectionState.waiting) {
          isLoading = true;
        }

        if (snapshot.data == null) {
          emptySelect = true;
        }

        if (snapshot.data != null) {
          allItems = List<Map<String, dynamic>>.from(snapshot.data!);
          filteredItems = List.from(allItems);
        }

        return Dialog(
          child: SizedBox(
            width: 400,
            height: (isFormVisible || !emptySelect) ? 360 : 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isFormVisible)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 8, 0, 0),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          isFormVisible = false;
                        });
                      },
                      icon: const Icon(Icons.arrow_back_outlined),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        spacing: 12,
                        children: [
                          if (isFormVisible)
                            Text(
                              returnTitle(),
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          if (!isFormVisible)
                            Expanded(
                              child: Column(
                                spacing: 12,
                                children: [
                                  Row(
                                    spacing: 12,
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          onChanged: _onSearchChanged,
                                          decoration: const InputDecoration(
                                            label: Text('Pesquisar disciplina'),
                                            enabledBorder: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(),
                                            suffixIcon: Icon(Icons.search),
                                          ),
                                        ),
                                      ),
                                      if (!isFormVisible)
                                        IconButton(
                                          color: Colors.white,
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                                    ProjectColors().mainGreen),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              resetControllerValue([
                                                nameController,
                                                turmaController,
                                              ]);
                                              isFormVisible = true;
                                              isInsertMode = true;
                                              isEditMode = false;
                                            });
                                          },
                                          icon: const Icon(Icons.add),
                                        ),
                                    ],
                                  ),
                                  if (isLoading)
                                    const Center(
                                        child: CircularProgressIndicator()),
                                  if (emptySelect && !isLoading)
                                    const Text('Não há disciplinas cadastradas'),
                                  if (!emptySelect && !isLoading)
                                    SizedBox(
                                      height: 250,
                                      child: ListView.builder(
                                        itemBuilder: (context, index) {
                                          final disciplina = filteredItems[index];
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedRowId = disciplina['id'];
                                                nameController.text =
                                                    disciplina['name'];
                                                turmaController.text =
                                                    disciplina['ID_turma']
                                                            ?.toString() ??
                                                        '';
                                                isFormVisible = true;
                                                isEditMode = false;
                                                isInsertMode = false;
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.0,
                                                  ),
                                                ),
                                              ),
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 4, horizontal: 12),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        disciplina['name'],
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                8, 0, 0, 0),
                                                        child: Text(
                                                          _getNomeTurma(
                                                              disciplina[
                                                                  'ID_turma']),
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xFF6F6F6F)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Icon(
                                                    Icons.remove_red_eye_outlined,
                                                    size: 20,
                                                    color: Color(0xFF6F6F6F),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        itemCount: filteredItems.length,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      if (isFormVisible)
                        TextField(
                          enabled: isInsertMode || isEditMode,
                          controller: nameController,
                          decoration:
                              const InputDecoration(label: Text('Nome da disciplina')),
                        ),
                      if (isFormVisible)
                        DropdownButtonFormField<int>(
                          value: turmaController.text.isNotEmpty
                              ? int.tryParse(turmaController.text)
                              : null,
                          decoration:
                              const InputDecoration(label: Text('Turma associada')),
                          items: turmas.map((turma) {
                            return DropdownMenuItem<int>(
                              value: turma['id'],
                              child: Text(
                                  '${turma['curso']} - ${turma['semestre']}º sem (Turma ${turma['turma']})'),
                            );
                          }).toList(),
                          onChanged: (isInsertMode || isEditMode)
                              ? (value) {
                                  setState(() {
                                    turmaController.text = value.toString();
                                  });
                                }
                              : null,
                        ),
                      if (isFormVisible)
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Row(
                            spacing: 8,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (isEditMode)
                                TextButton.icon(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          WidgetStatePropertyAll(Colors.red)),
                                  label: Text(
                                    'Excluir',
                                    style: TextStyle(
                                        color:
                                            ProjectColors().navbarTextColor),
                                  ),
                                  icon: isLoading
                                      ? const CircularProgressIndicator()
                                      : Icon(
                                          Icons.delete_outlined,
                                          color:
                                              ProjectColors().navbarTextColor,
                                        ),
                                  onPressed: () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    try {
                                      await Supabase.instance.client
                                          .from('disciplina')
                                          .delete()
                                          .eq('id', selectedRowId);
                                      setState(() {
                                        isFormVisible = false;
                                      });
                                    } catch (e) {
                                      print('Supabase error: $e');
                                    }
                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                                ),
                              if (!isEditMode && !isInsertMode)
                                TextButton.icon(
                                  label: Text(
                                    'Editar',
                                    style: TextStyle(
                                        color:
                                            ProjectColors().navbarTextColor),
                                  ),
                                  onPressed: isEditMode
                                      ? null
                                      : () {
                                          setState(() {
                                            isEditMode = true;
                                            isInsertMode = false;
                                          });
                                        },
                                  icon: const Icon(Icons.edit_outlined),
                                  style: ButtonStyle(
                                    iconColor: WidgetStatePropertyAll(
                                        ProjectColors().navbarTextColor),
                                    backgroundColor: WidgetStatePropertyAll(
                                        isEditMode
                                            ? ProjectColors()
                                                .disableButtonBackground
                                            : ProjectColors().mainGreen),
                                  ),
                                ),
                              TextButton.icon(
                                label: isLoading
                                    ? const CircularProgressIndicator()
                                    : Text(
                                        'Salvar',
                                        style: TextStyle(
                                            color: ProjectColors()
                                                .navbarTextColor),
                                      ),
                                onPressed: (!isEditMode && !isInsertMode)
                                    ? null
                                    : () async {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        try {
                                          if (isEditMode) {
                                            await Supabase.instance.client
                                                .from('disciplina')
                                                .update({
                                              'name': nameController.text,
                                              'ID_turma': int.tryParse(
                                                  turmaController.text),
                                            }).eq('id', selectedRowId);
                                            setState(() {
                                              isFormVisible = false;
                                            });
                                          } else {
                                            await Supabase.instance.client
                                                .from('disciplina')
                                                .insert({
                                              'name': nameController.text,
                                              'ID_turma': int.tryParse(
                                                  turmaController.text),
                                            });
                                            setState(() {
                                              isFormVisible = false;
                                            });
                                          }
                                        } catch (e) {
                                          print('Supabase error: $e');
                                        }
                                        setState(() {
                                          isLoading = false;
                                        });
                                      },
                                icon: isLoading
                                    ? null
                                    : const Icon(Icons.save_outlined),
                                style: ButtonStyle(
                                  iconColor: WidgetStatePropertyAll(
                                      ProjectColors().navbarTextColor),
                                  backgroundColor: WidgetStatePropertyAll(
                                      (!isEditMode && !isInsertMode)
                                          ? ProjectColors()
                                              .disableButtonBackground
                                          : ProjectColors().mainGreen),
                                ),
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}