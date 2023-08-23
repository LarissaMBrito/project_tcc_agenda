import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

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
  // ignore: unused_field
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

  // ignore: unused_field
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
        _fetchAvailableDoctors();
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
          .where('status', isEqualTo: true)
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

  Future<void> _updateAppointment(
    String docId,
    DateTime editedDate,
    TimeOfDay editedStartTime,
    TimeOfDay editedEndTime,
  ) async {
    await FirebaseFirestore.instance
        .collection('disponibilizar')
        .doc(docId)
        .update({
      'start_time': editedStartTime.format(context),
      'end_time': editedEndTime.format(context),
      'date': editedDate.toUtc(),
      'timestamp': FieldValue.serverTimestamp(),
    });
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
                      .copyWith(alwaysUse24HourFormat: false),
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

  void _showEditAppointmentDialog(
      Map<String, dynamic> appointmentData, String docId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditAppointmentDialog(
          selectedDate: appointmentData['date'].toDate(),
          selectedStartTime: TimeOfDay(
            hour: int.parse(appointmentData['start_time'].split(':')[0]),
            minute: int.parse(appointmentData['start_time'].split(':')[1]),
          ),
          selectedEndTime: TimeOfDay(
            hour: int.parse(appointmentData['end_time'].split(':')[0]),
            minute: int.parse(appointmentData['end_time'].split(':')[1]),
          ),
          docId: docId, // Passar o ID do documento
        );
      },
    );
  }

  void _deleteAppointment(String docId) async {
    await FirebaseFirestore.instance
        .collection('disponibilizar')
        .doc(docId)
        .delete();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exclusão Concluída'),
          content: Text('O agendamento foi excluído com sucesso.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar o diálogo
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
                calendarFormat: CalendarFormat.week,
                daysOfWeekHeight: 40,
                rowHeight: 60,
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
              Text(
                'Horários Disponibilizados:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Container(
                height: 300,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('disponibilizar')
                      .where('user_id', isEqualTo: _user.uid)
                      .where('status', isEqualTo: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Column(
                        children: [
                          Text('Nenhum horário disponibilizado.'),
                        ],
                      );
                    }

                    List<QueryDocumentSnapshot> disponibilizarDocs =
                        snapshot.data!.docs;

                    return Expanded(
                      child: ListView.builder(
                        itemCount: disponibilizarDocs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> disponibilizarData =
                              disponibilizarDocs[index].data()
                                  as Map<String, dynamic>;

                          DateTime date = disponibilizarData['date'].toDate();
                          String formattedDate =
                              DateFormat('dd/MM/yyyy').format(date);

                          return Card(
                            child: ListTile(
                              title: Text('Data: $formattedDate'),
                              subtitle: Text(
                                  'Horário: ${disponibilizarData['start_time']} - ${disponibilizarData['end_time']}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    color: Colors.black,
                                    onPressed: () {
                                      _showEditAppointmentDialog(
                                          disponibilizarData,
                                          disponibilizarDocs[index].id);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () {
                                      _deleteAppointment(
                                          disponibilizarDocs[index].id);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
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
                  'date': DateTime(_selectedDay.year, _selectedDay.month,
                          _selectedDay.day)
                      .toUtc(),
                  'timestamp': FieldValue.serverTimestamp(),
                  'nome': _selectedDoctorName,
                  'especialidades': _selectedSpecialty,
                  'cidade': _selectedCity,
                  'endereco': _selectedEnd,
                  'user_id': _user.uid,
                  'status': true,
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

class EditAppointmentDialog extends StatefulWidget {
  final DateTime selectedDate;
  final TimeOfDay selectedStartTime;
  final TimeOfDay selectedEndTime;
  final String docId; // Adicionar esta linha

  EditAppointmentDialog({
    required this.selectedDate,
    required this.selectedStartTime,
    required this.selectedEndTime,
    required this.docId,
  });

  @override
  _EditAppointmentDialogState createState() => _EditAppointmentDialogState();
}

class _EditAppointmentDialogState extends State<EditAppointmentDialog> {
  late DateTime _editedDate;
  late TimeOfDay _editedStartTime;
  late TimeOfDay _editedEndTime;

  @override
  void initState() {
    super.initState();
    _editedDate = widget.selectedDate;
    _editedStartTime = widget.selectedStartTime;
    _editedEndTime = widget.selectedEndTime;
  }

  Future<void> _updateAppointment() async {
    // Atualize os dados no Firebase
    await FirebaseFirestore.instance
        .collection('disponibilizar')
        .doc(widget.docId)
        .update({
      'start_time': _editedStartTime.format(context),
      'end_time': _editedEndTime.format(context),
      'date': _editedDate.toUtc(),
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Feche o diálogo de edição
    Navigator.of(context).pop();

    // Aguarde um pequeno período para garantir que o diálogo anterior seja fechado
    await Future.delayed(Duration(milliseconds: 100));

    // Exiba um diálogo de confirmação da atualização
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Atualização Concluída'),
          content: Text('As alterações foram salvas com sucesso.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar o diálogo
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
    return AlertDialog(
      title: Text('Editar Agendamento'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
              'Data: ${_editedDate.day}/${_editedDate.month}/${_editedDate.year}'),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              DateTime? editedDate = await showDatePicker(
                context: context,
                initialDate: _editedDate,
                firstDate: DateTime(2023, 1, 1),
                lastDate: DateTime(2023, 12, 31),
              );

              if (editedDate != null) {
                setState(() {
                  _editedDate = editedDate;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(255, 29, 6, 229), // Cor de fundo
              onPrimary: Colors.white, // Cor do texto
            ),
            child: Text('Alterar Data'),
          ),
          SizedBox(height: 10),
          Text('Hora de Início: ${_editedStartTime.format(context)}'),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              TimeOfDay? editedStartTime = await showTimePicker(
                context: context,
                initialTime: _editedStartTime,
              );

              if (editedStartTime != null) {
                setState(() {
                  _editedStartTime = editedStartTime;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(255, 29, 6, 229), // Cor de fundo
              onPrimary: Colors.white, // Cor do texto
            ),
            child: Text('Alterar Hora de Início'),
          ),
          SizedBox(height: 10),
          Text('Hora de Término: ${_editedEndTime.format(context)}'),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              TimeOfDay? editedEndTime = await showTimePicker(
                context: context,
                initialTime: _editedEndTime,
              );

              if (editedEndTime != null) {
                setState(() {
                  _editedEndTime = editedEndTime;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(255, 29, 6, 229), // Cor de fundo
              onPrimary: Colors.white, // Cor do texto
            ),
            child: Text('Alterar Hora de Término'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: _updateAppointment,
          child: Text('Salvar'),
        ),
      ],
    );
  }
}
