import 'package:ensala_mais/utils/project_colors.dart';
import 'package:ensala_mais/widgets/disciplina_modal.dart';
import 'package:ensala_mais/widgets/navbar_link.dart';
import 'package:ensala_mais/widgets/professor_modal.dart';
import 'package:ensala_mais/widgets/sala_modal.dart';
import 'package:ensala_mais/widgets/turma_modal.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:ensala_mais/pages/ensalamento_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<DateTime, List> _events = {};
  DateTime _focusedDay = DateTime.now();
  late DateTime _selectedDay = _focusedDay;
  final supabase = Supabase.instance.client;

  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
  ];
  String? selectedValue;

  List<Map<String, dynamic>> _ensalamentosHorario1 = [];
  List<Map<String, dynamic>> _ensalamentosHorario2 = [];
  bool _isLoading = false;

  @override
  void initState() {
    // This is where your problem is. The event loader is passed DateTimes with
    // the time component set to zero (midnight). d is set to noon. Just delete
    // the argument of "12" for hours.
    super.initState();
    DateTime d = DateTime.utc(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day + 1,
    );
    // Just add "Event A" to the list on this line
    _events[d] = ["Event A"];
    _selectedDay = _focusedDay;
    _carregarEnsalamentos();
  }

  Future<void> _carregarEnsalamentos() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final dataSelecionada = _selectedDay;
      final diaSemana = _getDiaSemana(dataSelecionada.weekday);
      final diaMes =
          "${dataSelecionada.day.toString().padLeft(2, '0')}/${dataSelecionada.month.toString().padLeft(2, '0')}/${dataSelecionada.year}";

      // Buscar ensalamentos com joins das tabelas relacionadas
      final response = await supabase.from('ensalamento').select('''
            *,
            horario:horario_id(id, horario_inicio),
            turma:turma_id(id, curso, semestre, turma),
            disciplina:disciplina_id(id, name),
            professore:professor_id(id, name),
            sala:sala_id(id, nome, bloco, predio)
          ''').eq('dia_semana', diaSemana).eq('dia_mes', diaMes);

      // ignore: unnecessary_null_comparison
      if (response != null) {
        final ensalamentos = response as List<dynamic>;

        // Separar por horário
        _ensalamentosHorario1 = ensalamentos
            .where((e) => e['horario']?['id'] == 1)
            .map((e) => e as Map<String, dynamic>)
            .toList();

        _ensalamentosHorario2 = ensalamentos
            .where((e) => e['horario']?['id'] == 2)
            .map((e) => e as Map<String, dynamic>)
            .toList();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getDiaSemana(int weekday) {
    switch (weekday) {
      case 1:
        return 'Segunda-feira';
      case 2:
        return 'Terça-feira';
      case 3:
        return 'Quarta-feira';
      case 4:
        return 'Quinta-feira';
      case 5:
        return 'Sexta-feira';
      default:
        return 'Segunda-feira';
    }
  }

  Widget _buildEnsalamentoCard(Map<String, dynamic> ensalamento) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Turma
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TURMA',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade800,
                    ),
                  ),
                  Text(
                    '${ensalamento['turma']?['curso'] ?? 'N/A'}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${ensalamento['turma']?['semestre'] ?? 'N/A'}º sem - Turma ${ensalamento['turma']?['turma'] ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Disciplina
            Row(
              children: [
                Icon(Icons.book, size: 16, color: Colors.green.shade600),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    ensalamento['disciplina']?['name'] ?? 'N/A',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Professor
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.purple.shade600),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    ensalamento['professore']?['name'] ?? 'N/A',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.purple.shade700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Sala
            Row(
              children: [
                Icon(Icons.room, size: 16, color: Colors.orange.shade600),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Sala ${ensalamento['sala']?['nome'] ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange.shade700,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              'Bloco ${ensalamento['sala']?['bloco'] ?? 'N/A'} - Prédio ${ensalamento['sala']?['predio'] ?? 'N/A'}',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHorarioColumn(
      String titulo, List<Map<String, dynamic>> ensalamentos) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ensalamentos.isEmpty
                ? Center(
                    child: Text(
                      'Nenhum ensalamento\npara este horário',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: ensalamentos.length,
                    itemBuilder: (context, index) {
                      return _buildEnsalamentoCard(ensalamentos[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 40,
            color: ProjectColors().mainGreen,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                NavbarLink(
                  text: 'Professor',
                  modal: ProfessorModal(),
                ),
                NavbarLink(
                  text: 'Sala',
                  modal:
                      SalaModal(), // Suponha que você tenha criado esse modal
                ),
                NavbarLink(
                  text: 'Turma',
                  modal:
                      TurmaModal(), // Suponha que você tenha criado esse modal
                ),
                NavbarLink(
                  text: 'Disciplina',
                  modal: DisciplinaModal(), // Suponha que você tenha criado esse modal
                ),
                NavbarLink(
                  text: 'Ensalamento',
                  modal: null, // Não abre modal diretamente
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const EnsalamentoPage()),
                    );
                  },
                ),
              ],
            ),
          ),
          TableCalendar(
            availableGestures: AvailableGestures.all,
            calendarFormat: CalendarFormat.week,
            firstDay: DateTime(1970),
            lastDay: DateTime(2040),
            focusedDay: _focusedDay,
            eventLoader: (day) {
              // Use a null aware operator "??" to make this line simpler. If
              // _events[day] is null, return the empty list instead.
              return _events[day] ?? [];
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                print('passei aqui');
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
          ),
          Divider(),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, color: Colors.blue.shade600),
                const SizedBox(width: 8),
                Text(
                  'Ensalamentos para ${_selectedDay.day.toString().padLeft(2, '0')}/${_selectedDay.month.toString().padLeft(2, '0')}/${_selectedDay.year}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
              ],
            ),
          ),

          // Grade de horários
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHorarioColumn(
                            '1º HORÁRIO - 19:00', _ensalamentosHorario1),
                        const SizedBox(width: 16),
                        _buildHorarioColumn(
                            '2º HORÁRIO - 20:55', _ensalamentosHorario2),
                      ],
                    ),
                  ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}