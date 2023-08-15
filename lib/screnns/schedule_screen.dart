import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleScreen extends StatefulWidget {
  final String especialidade;

  const ScheduleScreen({Key? key, required this.especialidade})
      : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _buttonIndex = 0;
  bool _isDoctorDetailsExpanded = false;

  final _scheduleWidgets = [
    Container(),
    Container(),
    Container(),
    Container(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agenda"),
        backgroundColor: const Color.fromARGB(255, 29, 6, 229),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Pesquisar',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onChanged: (text) {
                    // Implemente sua lógica de pesquisa aqui
                    // Você pode atualizar os dados exibidos com base no texto de pesquisa
                  },
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F6FA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _buttonIndex = 0;
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 11, horizontal: 20),
                        decoration: BoxDecoration(
                          color: _buttonIndex == 0
                              ? Color.fromARGB(255, 29, 6, 229)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Disponível",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _buttonIndex == 0
                                ? Colors.white
                                : Colors.black38,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _buttonIndex = 1;
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 11, horizontal: 20),
                        decoration: BoxDecoration(
                          color: _buttonIndex == 1
                              ? Color.fromARGB(255, 29, 6, 229)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Agendado",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _buttonIndex == 1
                                ? Colors.white
                                : Colors.black38,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _buttonIndex = 2;
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 11, horizontal: 20),
                        decoration: BoxDecoration(
                          color: _buttonIndex == 2
                              ? Color.fromARGB(255, 29, 6, 229)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Cancelado",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _buttonIndex == 2
                                ? Colors.white
                                : Colors.black38,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExpansionPanelList(
                      expandedHeaderPadding: EdgeInsets.zero,
                      expansionCallback: (panelIndex, isExpanded) {
                        setState(() {
                          _isDoctorDetailsExpanded = !isExpanded;
                        });
                      },
                      children: [
                        ExpansionPanel(
                          isExpanded: _isDoctorDetailsExpanded,
                          headerBuilder: (context, isExpanded) {
                            return StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('medico')
                                  .where('especialidades',
                                      isEqualTo: widget.especialidade)
                                  .limit(
                                      1) // Limitando a um médico para essa especialidade
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Erro: ${snapshot.error}');
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.docs.isEmpty) {
                                  return Text('Nenhum médico encontrado.');
                                } else {
                                  final doctor = snapshot.data!.docs[0];
                                  final doctorData =
                                      doctor.data() as Map<String, dynamic>;
                                  return ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.especialidade,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 29, 6, 229),
                                          ),
                                        ),
                                        Text(
                                          doctorData[
                                              'nome'], // Nome do médico do Firestore
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromARGB(255, 29, 6, 229),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            );
                          },
                          body: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('disponibilizar')
                                  .where('especialidades',
                                      isEqualTo: widget.especialidade)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Erro: ${snapshot.error}');
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.docs.isEmpty) {
                                  return Text(
                                      'Nenhuma disponibilidade encontrada.');
                                } else {
                                  final disponibilidades = snapshot.data!.docs;
                                  return Column(
                                    children:
                                        disponibilidades.map((disponibilidade) {
                                      final data = disponibilidade.data()
                                          as Map<String, dynamic>;
                                      final startTime = data['start_time'];
                                      final endTime = data['end_time'];
                                      final date = data['date'].toDate();
                                      final doctorName =
                                          data['nome']; // Nome do médico
                                      final doctorSpecialty = data[
                                          'especialidades']; // Especialidades do médico

                                      return ListTile(
                                        title: Text(
                                            "Data: ${date.day}/${date.month}/${date.year}"),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                "Horário: $startTime - $endTime"),
                                            Text("Médico: $doctorName"),
                                            Text(
                                                "Especialidades: $doctorSpecialty"), // Note o plural "Especialidades"
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _scheduleWidgets[_buttonIndex],
            ],
          ),
        ),
      ),
    );
  }
}
