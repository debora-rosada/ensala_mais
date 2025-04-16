import 'package:ensala_mais/utils/project_colors.dart';
import 'package:flutter/material.dart';

class Modal extends StatefulWidget {
  const Modal({super.key});

  @override
  State<Modal> createState() => _ModalState();
}

class _ModalState extends State<Modal> {
  bool isFormVisible = false;
// TODO: mudar a cor dos inputs e começar a salvar no supabase
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 400,
        height: isFormVisible ? 300 : 100,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                spacing: 12,
                children: [
                  if (isFormVisible)
                    Text(
                      'Cadastro de professor',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  if (!isFormVisible)
                    Expanded(
                        child: TextField(
                      decoration: InputDecoration(
                        label: Text('Pesquisar'),
                        enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.search),
                      ),
                    )),
                  if (!isFormVisible)
                    IconButton(
                        color: Colors.white,
                        style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                                ProjectColors().mainGreen)),
                        onPressed: () {
                          setState(() {
                            isFormVisible = true;
                          });
                        },
                        icon: Icon(Icons.add)),
                ],
              ),
              if (isFormVisible)
                TextField(
                  decoration: InputDecoration(label: Text('Nome')),
                ),
              if (isFormVisible)
                TextField(
                  decoration: InputDecoration(label: Text('Email')),
                ),
              if (isFormVisible)
                TextField(
                  decoration: InputDecoration(label: Text('Área')),
                ),
              if (isFormVisible)
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Row(
                    spacing: 8,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        label: Text(
                          'Editar',
                          style:
                              TextStyle(color: ProjectColors().navbarTextColor),
                        ),
                        onPressed: () {},
                        icon: Icon(Icons.edit_outlined),
                        style: ButtonStyle(
                          iconColor: WidgetStatePropertyAll(
                              ProjectColors().navbarTextColor),
                          backgroundColor:
                              WidgetStatePropertyAll(ProjectColors().mainGreen),
                        ),
                      ),
                      TextButton.icon(
                        label: Text(
                          'Salvar',
                          style:
                              TextStyle(color: ProjectColors().navbarTextColor),
                        ),
                        onPressed: () {},
                        icon: Icon(Icons.save_outlined),
                        style: ButtonStyle(
                          iconColor: WidgetStatePropertyAll(
                              ProjectColors().navbarTextColor),
                          backgroundColor:
                              WidgetStatePropertyAll(ProjectColors().mainGreen),
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}