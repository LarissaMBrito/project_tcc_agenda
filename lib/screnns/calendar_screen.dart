import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarScreen extends StatefulWidget {
  final String doctorName;
  final String doctorSpecialty;
  final String doctorId; // Adicione esta linha

  CalendarScreen(
      {required this.doctorName,
      required this.doctorSpecialty,
      required this.doctorId});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Color appbarColor = Color.fromARGB(255, 29, 6, 229);

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  TimeOfDay? selectedEndTime;

  List<Map<String, dynamic>> disponibilidades = []; // Adicione esta linha

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
    // ignore: unused_local_variable
    String? userUID = FirebaseAuth.instance.currentUser?.uid;
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

      // Retrieve the "cidade" and "endereço" fields from the "disponibilizar" collection
      DocumentSnapshot disponibilidadeSnapshot = await FirebaseFirestore
          .instance
          .collection('disponibilizar')
          .where('date', isEqualTo: date)
          .where('start_time', isEqualTo: startTime.format(context))
          .where('end_time', isEqualTo: endTime.format(context))
          .get()
          .then((snapshot) => snapshot.docs.first);

      String user_id = disponibilidadeSnapshot[
          'user_id']; // Obtém o valor do campo "user_id"

      // ignore: unused_local_variable
      String cidade = disponibilidadeSnapshot['cidade'];
      // ignore: unused_local_variable
      String endereco = disponibilidadeSnapshot['endereco'];

      // Restante do código para salvar o agendamento
      await FirebaseFirestore.instance.collection('agendar').add({
        'doctorName': widget.doctorName,
        // 'doctorId': widget.doctorId,
        'user_id': user_id,
        'data': startDateTime,
        'horaInicio': startTime.format(context),
        'horaTermino': endTime.format(context),
        'usuarioAgendou': userName, // Inserir o endereço do médico
        'cidade': cidade, // Add cidade field
        'endereco': endereco,
        'userUID': userUID,
        'status':
            'Agendado', // Definir o status como "Agendado" // Add endereço field
      });

      await _firestore
          .collection('disponibilizar')
          .where('date', isEqualTo: date)
          .where('start_time', isEqualTo: startTime.format(context))
          .where('end_time', isEqualTo: endTime.format(context))
          .get()
          .then((snapshot) {
        snapshot.docs.forEach((doc) {
          _firestore.collection('disponibilizar').doc(doc.id).update({
            'status': false,
          });
        });
      });

      // Limpar as variáveis após o agendamento ser salvo
      setState(() {
        selectedDate = null;
        selectedTime = null;
        selectedEndTime = null;
      });

      // Forçar a atualização da interface do usuário
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });

      await Future.delayed(Duration(seconds: 2));
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
      body: Padding(
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
              return Center(child: Text('Nenhuma disponibilidade encontrada.'));
            } else {
              final disponibilidades = snapshot.data!.docs;
              final disponibilidadesFiltradas = disponibilidades
                  .where((disponibilidade) => disponibilidade['status'] == true)
                  .toList(); // Filtrar disponibilidades com status true
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
                      children:
                          disponibilidadesFiltradas.map((disponibilidade) {
                        final data =
                            disponibilidade.data() as Map<String, dynamic>;
                        final startTime = data['start_time'];
                        final endTime = data['end_time'];

                        bool isSelected =
                            selectedDate == data['date'].toDate() &&
                                selectedTime == startTime &&
                                selectedEndTime == endTime;

                        return ListTile(
                          title: Text(
                              "Data: ${data['date'].toDate().day}/${data['date'].toDate().month}/${data['date'].toDate().year}"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors
                                          .transparent, // Cor de fundo em destaque quando selecionado
                                  border:
                                      Border.all(color: Colors.blue, width: 2),
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
                              if (isSelected) {
                                selectedDate = null;
                                selectedTime = null;
                                selectedEndTime = null;
                              } else {
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
                                selectedEndTime =
                                    TimeOfDay(hour: endHour, minute: endMinute);
                              }
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
                    if (selectedTime != null && selectedEndTime != null) ...[
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
                  ],
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (selectedDate != null &&
              selectedTime != null &&
              selectedEndTime != null) {
            _saveAppointment(
              selectedDate!,
              selectedTime!,
              selectedEndTime!,
            );

            setState(() {
              selectedDate = null;
              selectedTime = null;
              selectedEndTime = null;
            });

            // Exibir o diálogo após o agendamento ser salvo
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Sucesso'),
                  content: Text('Agendamento realizado com sucesso!'),
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
        },
        child: Icon(Icons.save),
        backgroundColor: Color.fromARGB(255, 29, 6, 229),
      ),
    );
  }
}
