import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarScreen extends StatefulWidget {
  final String doctorName;
  final String doctorSpecialty;

  CalendarScreen({required this.doctorName, required this.doctorSpecialty});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Color appbarColor = Color.fromARGB(255, 29, 6, 229);

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  TimeOfDay? selectedEndTime;

  Future<List<Map<String, dynamic>>> getAvailableSlots() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('disponibilizar')
        .where('especialidades', isEqualTo: widget.doctorSpecialty)
        .snapshots()
        .first;

    List<Map<String, dynamic>> slots = [];

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      // Extract data from Firestore document
      Timestamp startTimeStamp = data['start_time'];
      DateTime startTime = startTimeStamp.toDate();

      Timestamp dateTimestamp = data['date'];
      DateTime date = dateTimestamp.toDate();

      // Add data to slots list
      slots.add({
        'start': startTime,
        'date': date,
      });
    }

    return slots;
  }

  void _saveAppointment(
      DateTime date, TimeOfDay startTime, TimeOfDay endTime) async {
    final startDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      startTime.hour,
      startTime.minute,
    );

    // ignore: unused_local_variable
    final endDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      endTime.hour,
      endTime.minute,
    );

    try {
      // Obter o nome do usuário logado da coleção "paciente"
      String? userUID = FirebaseAuth.instance.currentUser?.uid;

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('paciente')
          .doc(userUID)
          .get();

      String userName = userSnapshot['nome'];

      // Restante do código para salvar o agendamento
      await FirebaseFirestore.instance.collection('agendar').add({
        'doctorName': widget.doctorName,
        'data': startDateTime,
        'horaInicio': startTime.format(context),
        'horaTermino': endTime.format(context),
        'usuarioAgendou': userName, // Adicionar o nome do usuário que agendou
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Agendamento realizado com sucesso!')),
      );

      setState(() {
        selectedDate = null;
        selectedTime = null;
        selectedEndTime = null;
      });
    } catch (e) {
      // Tratamento de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao agendar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agendamento de Consultas'),
        backgroundColor: appbarColor,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('disponibilizar')
                  .where('especialidades', isEqualTo: widget.doctorSpecialty)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                      child: Text('Nenhuma disponibilidade encontrada.'));
                } else {
                  final disponibilidades = snapshot.data!.docs;
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          'Médico: ${widget.doctorName}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Especialidade: ${widget.doctorSpecialty}',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 20),
                        Column(
                          children: disponibilidades.map((disponibilidade) {
                            final data =
                                disponibilidade.data() as Map<String, dynamic>;
                            final startTime = data['start_time'];
                            final endTime = data['end_time'];

                            return ListTile(
                              title: Text(
                                  "Data: ${data['date'].toDate().day}/${data['date'].toDate().month}/${data['date'].toDate().year}"),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.blue, width: 2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      "Horário: $startTime - $endTime",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  selectedDate = data['date'].toDate();
                                  final startTimeComponents =
                                      startTime.split(':');
                                  final endTimeComponents = endTime.split(':');
                                  final int startHour =
                                      int.parse(startTimeComponents[0]);
                                  final int startMinute =
                                      int.parse(startTimeComponents[1]);
                                  final int endHour =
                                      int.parse(endTimeComponents[0]);
                                  final int endMinute =
                                      int.parse(endTimeComponents[1]);

                                  selectedTime = TimeOfDay(
                                      hour: startHour, minute: startMinute);
                                  selectedEndTime = TimeOfDay(
                                      hour: endHour, minute: endMinute);
                                });
                              },
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 20),
                        if (selectedDate != null) ...[
                          Text(
                            'Horário Selecionado:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Data: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                        if (selectedTime != null &&
                            selectedEndTime != null) ...[
                          Text(
                            'Início: ${selectedTime!.hour}:${selectedTime!.minute}',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Término: ${selectedEndTime!.hour}:${selectedEndTime!.minute}',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                        SizedBox(height: 20),
                        Positioned(
                          bottom: 100,
                          right: 100,
                          child: FloatingActionButton(
                            onPressed: () {
                              if (selectedDate != null &&
                                  selectedTime != null &&
                                  selectedEndTime != null) {
                                _saveAppointment(selectedDate!, selectedTime!,
                                    selectedEndTime!);
                              }
                            },
                            child: Icon(Icons.save),
                            backgroundColor: Color.fromARGB(255, 29, 6, 229),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
