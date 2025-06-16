import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EnsalamentoPage extends StatefulWidget {
  const EnsalamentoPage({super.key});

  @override
  State<EnsalamentoPage> createState() => _EnsalamentoPageState();
}

class _EnsalamentoPageState extends State<EnsalamentoPage> {
  final supabase = Supabase.instance.client;
  final TextEditingController _diaMensalController = TextEditingController();

  String? _selectedDiaSemana;
  String? _selectedHorario;
  String? _selectedTurma;
  String? _selectedProfessor;
  String? _selectedDisciplina;
  String? _selectedSala;

  List<Map<String, dynamic>> _horario = [];
  List<Map<String, dynamic>> _turma = [];
  List<Map<String, dynamic>> _disciplina = [];
  List<Map<String, dynamic>> _professor = [];
  List<Map<String, dynamic>> _sala = [];

  final List<String> _diasSemana = [
    'Segunda-feira',
    'Terça-feira',
    'Quarta-feira',
    'Quinta-feira',
    'Sexta-feira'
  ];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    try {
      final horario =
          await supabase.from('horario').select('id, horario_inicio');
      final turma =
          await supabase.from('turma').select('id, curso, semestre, turma');
      final disciplina = await supabase.from('disciplina').select('id, name');
      final professor = await supabase.from('professor').select('id, name');
      final sala =
          await supabase.from('sala').select('id, name, bloco, predio');

      setState(() {
        _horario = List<Map<String, dynamic>>.from(horario);
        _turma = List<Map<String, dynamic>>.from(turma);
        _disciplina = List<Map<String, dynamic>>.from(disciplina);
        _professor = List<Map<String, dynamic>>.from(professor);
        _sala = List<Map<String, dynamic>>.from(sala);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados: $e')),
      );
    }
  }

  Future<void> _salvarEnsalamento() async {
    if (_selectedDiaSemana == null ||
        _diaMensalController.text.isEmpty ||
        _selectedHorario == null ||
        _selectedTurma == null ||
        _selectedDisciplina == null ||
        _selectedProfessor == null ||
        _selectedSala == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos')),
      );
      return;
    }

    try {
      await supabase.from('ensalamento').insert({
        'dia_semana': _selectedDiaSemana,
        'dia_mensal': _diaMensalController.text,
        'ID_horario': int.tryParse(_selectedHorario ?? ''),
        'ID_turma': int.tryParse(_selectedTurma ?? ''),
        'ID_disciplina': int.tryParse(_selectedDisciplina ?? ''),
        'ID_professor': int.tryParse(_selectedProfessor ?? ''),
        'ID_sala': int.tryParse(_selectedSala ?? ''),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ensalamento salvo com sucesso!')),
      );

      setState(() {
        _selectedDiaSemana = null;
        _diaMensalController.clear();
        _selectedHorario = null;
        _selectedTurma = null;
        _selectedDisciplina = null;
        _selectedProfessor = null;
        _selectedSala = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ensalamento'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Primeira linha: Dia da semana, dia do mês e horário
            const Text(
              'Informações básicas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // Dropdown Dia da Semana
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Dia da Semana'),
                      const SizedBox(height: 8),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: const Text(
                            'Selecione o dia',
                            style: TextStyle(fontSize: 14),
                          ),
                          items: _diasSemana
                              .map((String item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ))
                              .toList(),
                          value: _selectedDiaSemana,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedDiaSemana = value;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 40,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Campo Dia do Mês
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Dia do Mês'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _diaMensalController,
                        decoration: const InputDecoration(
                          hintText: 'AAAA/DD/MM',
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        ),
                        keyboardType: TextInputType.datetime,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Dropdown Horário
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Horário'),
                      const SizedBox(height: 8),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: const Text(
                            'Selecione o horário',
                            style: TextStyle(fontSize: 14),
                          ),
                          items: _horario
                              .map((item) => DropdownMenuItem<String>(
                                    value: item['id'].toString(),
                                    child: Text(
                                      item['horario_inicio'],
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ))
                              .toList(),
                          value: _selectedHorario,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedHorario = value;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 40,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Seção de Informações Acadêmicas
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '1. Informações Acadêmicas',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Dropdown Turma com informações adicionais
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Turma'),
                      const SizedBox(height: 8),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: const Text(
                            'Selecione a turma',
                            style: TextStyle(fontSize: 14),
                          ),
                          items: _turma
                              .map((item) => DropdownMenuItem<String>(
                                    value: item['id'].toString(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          item['curso'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${item['semestre']}º semestre - ${item['turma']}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                          value: _selectedTurma,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedTurma = value;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 50,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 60,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      // Dropdown Disciplina
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Disciplina'),
                            const SizedBox(height: 8),
                            DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                hint: const Text(
                                  'Selecione a disciplina',
                                  style: TextStyle(fontSize: 14),
                                ),
                                items: _disciplina
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item['id'].toString(),
                                          child: Text(
                                            item['name'],
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                        ))
                                    .toList(),
                                value: _selectedDisciplina,
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedDisciplina = value;
                                  });
                                },
                                buttonStyleData: const ButtonStyleData(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  height: 40,
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Dropdown Professor
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Professor'),
                            const SizedBox(height: 8),
                            DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                isExpanded: true,
                                hint: const Text(
                                  'Selecione o professor',
                                  style: TextStyle(fontSize: 14),
                                ),
                                items: _professor
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item['id'].toString(),
                                          child: Text(
                                            item['name'],
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                        ))
                                    .toList(),
                                value: _selectedProfessor,
                                onChanged: (String? value) {
                                  setState(() {
                                    _selectedProfessor = value;
                                  });
                                },
                                buttonStyleData: const ButtonStyleData(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  height: 40,
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  height: 40,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Seção de Informações do Local
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '2. Informações do Local',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Dropdown Sala com informações adicionais
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Sala'),
                      const SizedBox(height: 8),
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: const Text(
                            'Selecione a sala',
                            style: TextStyle(fontSize: 14),
                          ),
                          items: _sala
                              .map((item) => DropdownMenuItem<String>(
                                    value: item['id'].toString(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          item['name'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Bloco ${item['bloco']} - Prédio ${item['predio']}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList(),
                          value: _selectedSala,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedSala = value;
                            });
                          },
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 50,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 60,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Botão Salvar
            Center(
              child: ElevatedButton(
                onPressed: _salvarEnsalamento,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('Salvar Ensalamento'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _diaMensalController.dispose();
    super.dispose();
  }
}
