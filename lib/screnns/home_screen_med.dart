import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

// Import Firebase e Firestore

import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreenMed extends StatefulWidget {
  const HomeScreenMed({Key? key}) : super(key: key);

  @override
  State<HomeScreenMed> createState() => _HomeScreenMedState();
}

class _HomeScreenMedState extends State<HomeScreenMed> {
  int _buttonIndex = 0;
  DateTime? _selectedDate;

  // Lista de agendamentos
  // ignore: unused_field
  List<Agendamento> _agendamentos = [];
  List<Agendamento> _agendamentosAgendados = [];
  List<Agendamento> _agendamentosCancelados = [];

  @override
  void initState() {
    super.initState();
    _fetchAgendamentosFromFirebase(); // Chame a função aqui para buscar os dados.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bem - Vindo"),
        backgroundColor: const Color.fromARGB(255, 29, 6, 229),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Olá, Manuela",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage("images/medico.jpg"),
                  ),
                ],
              ),
            ),
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
                onChanged: (text) {},
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
                        "Agendado",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color:
                              _buttonIndex == 0 ? Colors.white : Colors.black38,
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
                        "Cancelado",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color:
                              _buttonIndex == 1 ? Colors.white : Colors.black38,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            // Date Picker for Filtering
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: ElevatedButton(
                onPressed: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2025),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _selectedDate = selectedDate;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary:
                      Color.fromARGB(255, 29, 6, 229), // Set button color here
                ),
                child: Text(
                  "Filtrar por Data",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Updated section to display doctor's information without ExpansionPanel
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _filteredAgendamentos.map((agendamento) {
                  return Card(
                    elevation: 4,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage("images/image.jpg"),
                        radius: 24,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            agendamento.usuarioAgendou,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 29, 6, 229),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromARGB(255, 29, 6, 229),
                                ),
                                padding: EdgeInsets.all(6),
                                child: Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Data:",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "${agendamento.data.day} de ${_getMonthName(agendamento.data.month)}, ${agendamento.data.year}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 29, 6, 229),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromARGB(255, 29, 6, 229),
                                ),
                                padding: EdgeInsets.all(6),
                                child: Icon(
                                  Icons.access_time,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Horário:",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    agendamento.horaInicio,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 29, 6, 229),
                                    ),
                                  ),
                                  Text(
                                    agendamento.horaTermino,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 29, 6, 229),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ... O restante do código permanece o mesmo ...

  // Função para buscar agendamentos do Firebase
  Future<void> _fetchAgendamentosFromFirebase() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('agendar').get();

      final agendamentos = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Agendamento(
          data: (data['data'] as Timestamp).toDate(),
          usuarioAgendou: data['usuarioAgendou'] as String,
          horaInicio: data['horaInicio'] as String,
          horaTermino: data['horaTermino'] as String,
          status: data['status'] as String,
        );
      }).toList();
      _agendamentosAgendados = agendamentos
          .where((agendamento) => agendamento.status == "Agendado")
          .toList();
      _agendamentosCancelados = agendamentos
          .where((agendamento) => agendamento.status == "Cancelado")
          .toList();

      print('Agendamentos Agendados: $_agendamentosAgendados');
      print('Agendamentos Cancelados: $_agendamentosCancelados');

      print(
          'Agendamentos buscados: $agendamentos'); // Adicione este log para depuração.

      setState(() {
        _agendamentos = agendamentos;
      });
    } catch (e) {
      print('Erro ao buscar agendamentos: $e');
    }
  }

  List<Agendamento> get _filteredAgendamentos {
    if (_selectedDate != null) {
      final selectedDateLocal = _selectedDate!.toLocal();
      if (_buttonIndex == 0) {
        return _agendamentosAgendados.where((agendamento) {
          final agendamentoDateLocal = agendamento.data.toLocal();
          return agendamentoDateLocal.year == selectedDateLocal.year &&
              agendamentoDateLocal.month == selectedDateLocal.month &&
              agendamentoDateLocal.day == selectedDateLocal.day;
        }).toList();
      } else if (_buttonIndex == 1) {
        return _agendamentosCancelados.where((agendamento) {
          final agendamentoDateLocal = agendamento.data.toLocal();
          return agendamentoDateLocal.year == selectedDateLocal.year &&
              agendamentoDateLocal.month == selectedDateLocal.month &&
              agendamentoDateLocal.day == selectedDateLocal.day;
        }).toList();
      }
    }

    // Adicione esta linha para retornar uma lista vazia por padrão
    return [];
  }
}

String _getMonthName(int month) {
  final ptBrLocale = Locale('pt', 'BR');
  initializeDateFormatting(ptBrLocale.toString());
  return DateFormat.MMMM(ptBrLocale.toString())
      .format(DateTime(DateTime.now().year, month));
}

class Agendamento {
  final DateTime data;
  final String usuarioAgendou;
  final String horaInicio;
  final String horaTermino;
  final String status;

  Agendamento({
    required this.data,
    required this.usuarioAgendou,
    required this.horaInicio,
    required this.horaTermino,
    required this.status,
  });
}
