import 'package:ensala_mais/utils/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TurmaModal extends StatefulWidget {
  const TurmaModal({super.key});
  @override
  State<TurmaModal> createState() => _TurmaModalState();
}

class _TurmaModalState extends State<TurmaModal> {
  bool isFormVisible = false;
  bool isLoading = false;
  bool emptySelect = false;
  bool isEditMode = false;
  bool isInsertMode = false;
  TextEditingController cursoController = TextEditingController();
  TextEditingController semestreController = TextEditingController();
  TextEditingController turmaController = TextEditingController();
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
      return 'Edição de Turma';
    }
    if (isInsertMode) {
      return 'Cadastro de Turma';
    }
    return 'Visualização de Turma';
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredItems = allItems;
      });
      return;
    }
    for (var row in allItems) {
      print(row['curso']);
      print(query);
      print(row['curso'].contains(query));
      if (row['curso'].contains(query)) {
        filteredItems.add(row);
      }
    }
    print(filteredItems);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Supabase.instance.client.from('professor').select(),
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
            // Inicialize allItems e filteredItems com os dados completos
            allItems = List<Map<String, dynamic>>.from(snapshot.data!);
            filteredItems = List.from(
                allItems); // Inicializa filteredItems com todos os itens
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
                        icon: Icon(Icons.arrow_back_outlined),
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
                                style: TextStyle(
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
                                          onChanged: (value) {
                                            _onSearchChanged(value);
                                          },
                                          decoration: InputDecoration(
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
                                                        ProjectColors()
                                                            .mainGreen)),
                                            onPressed: () {
                                              setState(() {
                                                resetControllerValue([
                                                  cursoController,
                                                  semestreController,
                                                  turmaController,
                                                ]);
                                                isFormVisible = true;
                                                isInsertMode = true;
                                                isEditMode = false;
                                              });
                                            },
                                            icon: Icon(Icons.add)),
                                    ],
                                  ),
                                  if (isLoading)
                                    Center(child: CircularProgressIndicator()),
                                  if (emptySelect && !isLoading)
                                    Text('Não há dados cadastrados'),
                                  if (!emptySelect && !isLoading)
                                    SizedBox(
                                      height: 250,
                                      child: ListView.builder(
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedRowId =
                                                    filteredItems[index]['id'];
                                                cursoController.text =
                                                    filteredItems[index]
                                                        ['curso'];
                                                semestreController.text =
                                                    filteredItems[index]
                                                        ['semestre'];
                                                turmaController.text =
                                                    filteredItems[index]
                                                        ['turma'];
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
                                              padding: EdgeInsets.symmetric(
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
                                                        filteredItems[index]
                                                            ['curso'],
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                8, 0, 0, 0),
                                                        child: Text(
                                                          filteredItems[index]
                                                              ['turma'],
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xFF6F6F6F)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Icon(
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
                              )),
                          ],
                        ),
                        if (isFormVisible)
                          TextField(
                            enabled: isInsertMode || isEditMode,
                            controller: cursoController,
                            decoration: InputDecoration(label: Text('Nome')),
                          ),
                        if (isFormVisible)
                          TextField(
                            enabled: isInsertMode || isEditMode,
                            controller: semestreController,
                            decoration: InputDecoration(label: Text('semestre')),
                          ),
                        if (isFormVisible)
                          TextField(
                            enabled: isInsertMode || isEditMode,
                            controller: turmaController,
                            decoration: InputDecoration(label: Text('Área')),
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
                                        ? CircularProgressIndicator()
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
                                            .from('professor')
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
                                    icon: Icon(Icons.edit_outlined),
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
                                      ? CircularProgressIndicator()
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
                                                  .from('professor')
                                                  .update({
                                                'curso': cursoController.text,
                                                'semestre': semestreController.text,
                                                'turma': turmaController.text
                                              }).eq('id', selectedRowId);
                                              setState(() {
                                                isFormVisible = false;
                                              });
                                            } else {
                                              await Supabase.instance.client
                                                  .from('professor')
                                                  .insert({
                                                'curso': cursoController.text,
                                                'semestre': semestreController.text,
                                                'turma': turmaController.text
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
                                      : Icon(Icons.save_outlined),
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
        });
  }

}
