import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(EventApp());
}

class EventApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AppointmentScheduler(),
    );
  }
}

class AppointmentScheduler extends StatefulWidget {
  @override
  _AppointmentSchedulerState createState() => _AppointmentSchedulerState();
}

class _AppointmentSchedulerState extends State<AppointmentScheduler> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  late User _user;
  String _selectedDoctorName = '';
  String _selectedSpecialty = '';
  String _selectedCity = '';
  String _selectedEnd = '';

  List<Map<String, dynamic>> _availableDoctors = [];

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _fetchDoctorInfo();
  }

  Future<void> _fetchDoctorInfo() async {
    try {
      DocumentSnapshot doctorSnapshot = await FirebaseFirestore.instance
          .collection('medico')
          .doc(_user.uid)
          .get();
      if (doctorSnapshot.exists) {
        setState(() {
          _selectedDoctorName = doctorSnapshot['nome'];
          _selectedSpecialty = doctorSnapshot['especialidade'];
          _selectedCity = doctorSnapshot['cidade'];
          _selectedEnd = doctorSnapshot['endereco'];
        });
        _fetchAvailableDoctors(); // Adicione esta linha para buscar médicos disponíveis após obter as informações do médico
      }
    } catch (e) {
      print('Erro ao buscar informações do médico: $e');
    }
  }

  Future<void> _fetchAvailableDoctors() async {
    try {
      QuerySnapshot disponibilizarSnapshot = await FirebaseFirestore.instance
          .collection('disponibilizar')
          .where('especialidades', isEqualTo: _selectedSpecialty)
          .get();

      setState(() {
        _availableDoctors = disponibilizarSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      print('Erro ao buscar médicos disponíveis: $e');
    }
  }

  Widget _buildTimePicker(String label, TimeOfDay? time) {
    String formattedTime = time != null ? time.format(context) : "Selecionar";

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(255, 29, 6, 229),
            padding: EdgeInsets.symmetric(horizontal: 10),
          ),
          onPressed: () async {
            TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: time ?? TimeOfDay.now(),
              builder: (BuildContext context, Widget? child) {
                return MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(alwaysUse24HourFormat: true),
                  child: child!,
                );
              },
            );

            if (pickedTime != null) {
              setState(() {
                if (label == "Hora de Início") {
                  _startTime = pickedTime;
                } else {
                  _endTime = pickedTime;
                }
              });
            }
          },
          child: Text(formattedTime),
        ),
      ],
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agendamento Salvo'),
          content: Text('O agendamento foi salvo com sucesso.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disponibilizar Data/Hora Atendimento'),
        backgroundColor: Color.fromARGB(255, 29, 6, 229),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2023, 1, 1),
                lastDay: DateTime.utc(2023, 12, 31),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                ),
              ),
              SizedBox(height: 20),
              _buildTimePicker("Hora de Início", _startTime),
              SizedBox(height: 20),
              _buildTimePicker("Hora de Término", _endTime),
              SizedBox(height: 20),

              // Exibir os médicos disponíveis
              Text('Médicos Disponíveis:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Column(
                children: _availableDoctors.map((doctor) {
                  return ListTile(
                    title: Text(doctor['nome']),
                    subtitle: Text(doctor['especialidades']),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (_startTime != null &&
                _endTime != null &&
                _selectedDoctorName.isNotEmpty &&
                _selectedSpecialty.isNotEmpty)
            ? () async {
                CollectionReference disponibilizarCollection =
                    FirebaseFirestore.instance.collection('disponibilizar');
                await disponibilizarCollection.add({
                  'start_time': _startTime!.format(context),
                  'end_time': _endTime!.format(context),
                  'date': _selectedDay,
                  'timestamp': FieldValue.serverTimestamp(),
                  'nome': _selectedDoctorName,
                  'especialidades': _selectedSpecialty,
                  'cidade': _selectedCity,
                  'endereco': _selectedEnd,
                  'user_id': _user.uid,
                });

                _showConfirmationDialog();
              }
            : null,
        child: Icon(Icons.save),
        backgroundColor: Color.fromARGB(255, 29, 6, 229),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
