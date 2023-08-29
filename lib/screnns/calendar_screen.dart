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
  int? selectedIndex;

  TimeOfDay convertStringToTimeOfDay(String timeString) {
    final List<String> parts = timeString.split(':');
    final int hour = int.parse(parts[0]);
    final int minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

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
      String telefone = disponibilidadeSnapshot['telefone'];

      // Restante do código para salvar o agendamento
      await FirebaseFirestore.instance.collection('agendar').add({
        'doctorName': widget.doctorName,
        // 'doctorId': widget.doctorId,
        'user_id': user_id,
        'data': startDateTime,
        'horaInicio': startTime.format(context),
        'horaTermino': endTime.format(context),
        'usuarioAgendou': userName, // Inserir o endereço do médico
        'cidade': cidade,
        'telefone': telefone,
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
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: disponibilidadesFiltradas.length,
                      itemBuilder: (context, index) {
                        final disponibilidade =
                            disponibilidadesFiltradas[index];
                        final data =
                            disponibilidade.data() as Map<String, dynamic>;
                        final startTime = data['start_time'];
                        final endTime = data['end_time'];
                        final date = data['date'].toDate();

                        bool isSelected = selectedIndex == index;

                        return ListTile(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                              selectedDate = date;
                              selectedTime =
                                  convertStringToTimeOfDay(startTime);
                              selectedEndTime =
                                  convertStringToTimeOfDay(endTime);
                            });
                          },
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: Color.fromARGB(
                                                    255, 98, 141, 179)
                                                .withOpacity(0.5),
                                            blurRadius: 5.0,
                                            spreadRadius: 2.0,
                                            offset: Offset(0, 2),
                                          ),
                                        ]
                                      : [],
                                  color: isSelected
                                      ? const Color.fromARGB(255, 147, 193, 230)
                                          .withOpacity(0.3)
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Data: ${date.day}/${date.month}/${date.year}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? const Color.fromARGB(255, 6, 6, 6)
                                            : Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Horário: $startTime - $endTime",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? Colors.black
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
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
              selectedIndex = null; // Reset the selected index
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
