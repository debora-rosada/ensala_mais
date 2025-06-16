import 'package:ensala_mais/utils/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EnsalamentoPage extends StatefulWidget {
  const EnsalamentoPage({super.key});

  @override
  State<EnsalamentoPage> createState() => _EnsalamentoPageState();
}

class _EnsalamentoPageState extends State<EnsalamentoPage> {
  bool isFormVisible = false;
  bool isLoading = false;
  bool emptySelect = false;
  bool isEditMode = false;
  bool isInsertMode = false;
  TextEditingController diasemanaController = TextEditingController();
  TextEditingController diamensalController = TextEditingController();
  TextEditingController horarioController = TextEditingController();
  int idsalaController = 0;
  int idprofessorController = 0;
  int idturmaController = 0;

  int selectedRowId = 0;
  List<Map<String, dynamic>> filteredItems = [];
  List<Map<String, dynamic>> allItems = [];

  void resetControllerValue(List<TextEditingController> controllersList) {
    for (var controller in controllersList) {
      controller.text = '';
    }
  }

  String returnTitle() {
    if (isEditMode) {
      return 'Edição de ensalamento';
    }
    if (isInsertMode) {
      return 'Cadastro de ensalamento';
    }
    return 'Visualização de ensalamento';
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = List.from(allItems);
      } else {
        filteredItems = allItems
            .where((row) =>
                (row['dia_da_semana'] ?? '')
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                (row['diamensal'] ?? '')
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                (row['horario'] ?? '')
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ensalamento'),
        titleTextStyle: TextStyle(
          fontSize: 20,
          color: ProjectColors().ensalamento,
        ),
        backgroundColor: ProjectColors().mainGreen,
      ),
      body: FutureBuilder(
        future: Supabase.instance.client.from('ensalamento').select(),
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
            if (filteredItems.isEmpty ||
                filteredItems.length != allItems.length) {
              filteredItems = List.from(allItems);
            }
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ...existing code...
                  if (isFormVisible)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 8, 0, 0),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            isFormVisible = false;
                          });
                        },
                        icon: Icon(
                          Icons.arrow_back_outlined,
                        ),
                      ),
                    ),
                  // ...existing code...
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
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
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          onChanged: (value) {
                                            _onSearchChanged(value);
                                          },
                                          decoration: const InputDecoration(
                                            label: Text('Pesquisar'),
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
                                                diasemanaController,
                                                diamensalController,
                                                horarioController,
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
                                    const Text('Não há dados cadastrados'),
                                  if (!emptySelect && !isLoading)
                                    SizedBox(
                                      height: 400,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedRowId =
                                                    filteredItems[index]['id'];
                                                diasemanaController
                                                    .text = filteredItems[index]
                                                            ['dia_da_semana']
                                                        ?.toString() ??
                                                    '';
                                                diamensalController.text =
                                                    filteredItems[index]
                                                                ['diamensal']
                                                            ?.toString() ??
                                                        '';
                                                horarioController.text =
                                                    filteredItems[index]
                                                                ['horario']
                                                            ?.toString() ??
                                                        '';
                                                isFormVisible = true;
                                                isEditMode = false;
                                                isInsertMode = false;
                                              });
                                            },
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.0,
                                                  ),
                                                ),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4,
                                                      horizontal: 12),
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
                                                        filteredItems[index][
                                                                    'dia_da_semana']
                                                                ?.toString() ??
                                                            '',
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
                                                          filteredItems[index][
                                                                      'horario']
                                                                  ?.toString() ??
                                                              '',
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xFF6F6F6F)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Icon(
                                                    Icons
                                                        .remove_red_eye_outlined,
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
                          controller: diasemanaController,
                          decoration: const InputDecoration(
                              label: Text('Dia da Semana')),
                        ),
                      if (isFormVisible)
                        TextField(
                          enabled: isInsertMode || isEditMode,
                          controller: diamensalController,
                          decoration:
                              const InputDecoration(label: Text('Dia Mensal')),
                        ),
                      if (isFormVisible)
                        TextField(
                          enabled: isInsertMode || isEditMode,
                          controller: horarioController,
                          decoration:
                              const InputDecoration(label: Text('Horário')),
                        ),
                      if (isFormVisible)
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Row(
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
                                        color: ProjectColors().navbarTextColor),
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
                                          .from('ensalamento')
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
                                        color: ProjectColors().navbarTextColor),
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
                                                .from('ensalamento')
                                                .update({
                                              'dia_da_semana':
                                                  diasemanaController.text,
                                              'diamensal':
                                                  diamensalController.text,
                                              'horario': horarioController.text,
                                            }).eq('id', selectedRowId);
                                            setState(() {
                                              isFormVisible = false;
                                            });
                                          } else {
                                            await Supabase.instance.client
                                                .from('ensalamento')
                                                .insert({
                                              'dia_da_semana':
                                                  diasemanaController.text,
                                              'diamensal':
                                                  diamensalController.text,
                                              'horario': horarioController.text,
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
