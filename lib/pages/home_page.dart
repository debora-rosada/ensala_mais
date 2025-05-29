import 'package:ensala_mais/utils/project_colors.dart';
import 'package:ensala_mais/widgets/navbar_link.dart';
import 'package:ensala_mais/widgets/professor_modal.dart';
import 'package:ensala_mais/widgets/sala_modal.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<DateTime, List> _events = {};
  DateTime _focusedDay = DateTime.now();

  // Instead of initializing in initState, just add the "late" modifier.
  late DateTime _selectedDay = _focusedDay;

  @override
  void initState() {
    // This is where your problem is. The event loader is passed DateTimes with
    // the time component set to zero (midnight). d is set to noon. Just delete
    // the argument of "12" for hours.
    DateTime d = DateTime.utc(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day + 1,
    );
    // Just add "Event A" to the list on this line
    _events[d] = ["Event A"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: Row(
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     children: [
      //       NavbarLink(text: 'Professores'),
      //       NavbarLink(text: 'Salas'),
      //       NavbarLink(text: 'Turmas'),
      //     ],
      //   ),
      //   backgroundColor: ProjectColors().mainGreen,
      // ),
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
                  modal: SalaModal(), // Suponha que você tenha criado esse modal
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
        ],
      ),
    );
  }
}
