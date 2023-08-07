import 'package:flutter/material.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  Map<DateTime, List<Event>> _events = {
    DateTime(2023, 7, 29): [
      Event('Evento 1', 'Segunda-feira', '14:00'),
      Event('Evento 4', 'Segunda-feira', '17:00'),
    ],
    DateTime(2023, 7, 30): [
      Event('Evento 2', 'Terça-feira', '15:30'),
    ],
    DateTime(2023, 7, 31): [
      Event('Evento 3', 'Quarta-feira', '09:45'),
    ],
  };

  DateTime _selectedDate = DateTime.now();
  TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _dateController.text = _formattedDate(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendário'),
        backgroundColor: Color.fromARGB(255, 29, 6, 229),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Datas disponíveis',
                hintText: 'DD/MM/AAAA',
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
              onTap: _openCalendar,
              readOnly: true,
            ),
            SizedBox(height: 16),
            _buildEventList(),
          ],
        ),
      ),
    );
  }

  void _openCalendar() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023, 1, 1),
      lastDate: DateTime(2023, 12, 31),
    );

    if (selectedDate != null && selectedDate != _selectedDate) {
      setState(() {
        _selectedDate = selectedDate;
        _dateController.text = _formattedDate(selectedDate);
      });
    }
  }

  Widget _buildEventList() {
    if (_events.containsKey(_selectedDate)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Eventos em ${_formattedDateWithDayOfWeek(_selectedDate)}:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          ..._events[_selectedDate]!
              .map((event) => _buildEventCard(event))
              .toList(),
        ],
      );
    } else {
      return Text(
        'Nenhum evento agendado para ${_formattedDateWithDayOfWeek(_selectedDate)}.',
        style: TextStyle(fontSize: 18),
      );
    }
  }

  Widget _buildEventCard(Event event) {
    bool isToday = _selectedDate.year == DateTime.now().year &&
        _selectedDate.month == DateTime.now().month &&
        _selectedDate.day == DateTime.now().day;

    return Card(
      color: isToday ? Colors.blue : Colors.white,
      child: ListTile(
        title: Text(event.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dia da semana: ${event.dayOfWeek}'),
            Text('Hora: ${event.time}'),
          ],
        ),
      ),
    );
  }

  String _formattedDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  String _formattedDateWithDayOfWeek(DateTime date) {
    List<String> weekdays = [
      'Domingo',
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira',
      'Sábado'
    ];
    return "${weekdays[date.weekday]}, ${_formattedDate(date)}";
  }
}

class Event {
  final String title;
  final String dayOfWeek;
  final String time;

  Event(this.title, this.dayOfWeek, this.time);

  @override
  String toString() => title;
}

void main() => runApp(MaterialApp(
      home: CalendarScreen(),
    ));
