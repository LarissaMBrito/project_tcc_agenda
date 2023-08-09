import 'package:flutter/material.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  Map<DateTime, List<Map<String, DateTime>>> availableSlotsByDate = {
    DateTime(2023, 08, 10): [
      {
        'start': DateTime(2023, 08, 10, 9, 0),
        'end': DateTime(2023, 08, 10, 10, 0),
      },
      {
        'start': DateTime(2023, 08, 10, 11, 0),
        'end': DateTime(2023, 08, 10, 12, 0),
      },
    ],
    DateTime(2023, 08, 11): [
      {
        'start': DateTime(2023, 08, 11, 14, 30),
        'end': DateTime(2023, 08, 11, 15, 30),
      },
    ],
    // ... adicione mais datas e horários aqui
  };

  DateTime? selectedSlot;

  @override
  Widget build(BuildContext context) {
    Color appbarColor = Color.fromARGB(255, 29, 6, 229);

    return Scaffold(
      appBar: AppBar(
        title: Text('Agendamento de Consultas'),
        backgroundColor: appbarColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Text(
              '10/08/2023',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            if (selectedSlot != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var slot in availableSlotsByDate[selectedSlot]!)
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: appbarColor, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      padding: EdgeInsets.all(8),
                      child: Text(
                        '${slot['start']?.hour}:${slot['start']?.minute.toString().padLeft(2, '0')} - ${slot['end']?.hour}:${slot['end']?.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: appbarColor,
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Lógica para salvar
        },
        backgroundColor: appbarColor,
        child: Icon(Icons.save),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CalendarScreen(),
  ));
}
