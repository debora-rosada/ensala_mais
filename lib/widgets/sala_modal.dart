import 'package:ensala_mais/utils/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SalaModal extends StatefulWidget {
  const SalaModal({super.key});

  @override
  State<SalaModal> createState() => _SalaModalState();
}

class _SalaModalState extends State<SalaModal> {
  bool isFormVisible = false;
  bool isLoading = false;
  bool emptySelect = false;
  bool isEditMode = false;
  bool isInsertMode = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController blocoController = TextEditingController();
  TextEditingController predioController = TextEditingController();
  int selectedRowId = 0;
  List<Map<String, dynamic>> filteredItems = [];
  List<Map<String, dynamic>> allItems = [];

// TODO: mudar a cor dos inputs
// TODO: validar campos
// TODO: na listview o mouse tem que ficar com onHover de click
// TODO: Componentizar essa tela pois está muito bagunçado!!
// TODO: Terminar pesquisa pelo input

  void resetControllerValue(List<TextEditingController> controllersList) {
    for (var controller in controllersList) {
      controller.text = '';
    }
  }

  String returnTitle() {
    if (isEditMode) {
      return 'Edição de sala';
    }
    if (isInsertMode) {
      return 'Cadastro de sala';
    }
    return 'Visualização de salas';
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredItems = allItems;
      });
      return;
    }
    for (var row in allItems) {
      print(row['name']);
      print(query);
      print(row['name'].contains(query));
      if (row['name'].contains(query)) {
        filteredItems.add(row);
      }
    }
    print(filteredItems);
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        
        future: Supabase.instance.client.from('sala').select(),
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
                                                  nameController,
                                                  blocoController,
                                                  predioController,
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
                                                nameController.text =
                                                    filteredItems[index]
                                                        ['name'];
                                                blocoController.text =
                                                    filteredItems[index]
                                                        ['bloco'];
                                                predioController.text =
                                                    filteredItems[index]
                                                        ['predio'];
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
                                                            ['name'],
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
                                                              ['predio'],
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
                            controller: nameController,
                            decoration: InputDecoration(label: Text('Nome')),
                          ),
                        if (isFormVisible)
                          TextField(
                            enabled: isInsertMode || isEditMode,
                            controller: blocoController,
                            decoration: InputDecoration(label: Text('Bloco')),
                          ),
                        if (isFormVisible)
                          TextField(
                            enabled: isInsertMode || isEditMode,
                            controller: predioController,
                            decoration: InputDecoration(label: Text('Prédio')),
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
                                            .from('sala')
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
                                                  .from('sala')
                                                  .update({
                                                'name': nameController.text,
                                                'bloco': blocoController.text,
                                                'predio': predioController.text
                                              }).eq('id', selectedRowId);
                                              setState(() {
                                                isFormVisible = false;
                                              });
                                            } else {
                                              await Supabase.instance.client
                                                  .from('sala')
                                                  .insert({
                                                'name': nameController.text,
                                                'bloco': blocoController.text,
                                                'predio': predioController.text
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