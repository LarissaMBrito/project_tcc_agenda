import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  Map<DateTime, List<Event>> _events = {
    DateTime(2023, 7, 29): [Event('Evento 1')],
    DateTime(2023, 7, 30): [Event('Evento 2')],
    DateTime(2023, 7, 31): [Event('Evento 3')],
  };

  DateTime _focusedDay =
      DateTime.now(); // Definir a data focada inicialmente como hoje

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendário'),
        backgroundColor:
            Color.fromARGB(255, 29, 6, 229), // Define a cor da AppBar
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime(2023, 1, 1),
              lastDay: DateTime(2023, 12, 31),
              eventLoader: (date) => _events[date] ?? [],
              calendarFormat: CalendarFormat.month,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _focusedDay =
                      focusedDay; // Atualiza a data focada sempre que uma data for selecionada
                });
                print('Selected date: $selectedDay');
                print('Events: ${_events[selectedDay]}');
              },
            ),
            // Outros widgets ou funcionalidades podem ser adicionados aqui
          ],
        ),
      ),
    );
  }
}

class Event {
  final String title;

  Event(this.title);

  @override
  String toString() => title;
}

void main() => runApp(MaterialApp(
      home: CalendarScreen(),
    ));
