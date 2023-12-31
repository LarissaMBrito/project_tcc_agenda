import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreenMed extends StatefulWidget {
  const HomeScreenMed({Key? key}) : super(key: key);

  @override
  State<HomeScreenMed> createState() => _HomeScreenMedState();
}

class _HomeScreenMedState extends State<HomeScreenMed> {
  int _buttonIndex = 0;
  DateTime? _selectedDate;
  String _medicoName = '';
  String _perfilImageUrl = 'images/iconpadrao.jpg';
  String _searchText = '';
  // ignore: unused_field
  List<Agendamento> _agendamentos = [];
  List<Agendamento> _agendamentosAgendados = [];
  List<Agendamento> _agendamentosCancelados = [];
  List<Agendamento> _agendamentosFinalizado = [];

  @override
  void initState() {
    super.initState();
    _fetchMedicoDataFromFirebase();
    _selectedDate = DateTime.now();
    _fetchAgendamentosFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bem - Vindo"),
        backgroundColor: const Color.fromARGB(255, 29, 6, 229),
        automaticallyImplyLeading: false,
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
                    "Olá, $_medicoName",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: _perfilImageUrl.startsWith('http')
                        ? NetworkImage(_perfilImageUrl)
                        : AssetImage(_perfilImageUrl) as ImageProvider<Object>,
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
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
                  setState(() {
                    _searchText = text;
                  });
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Icon(
                    Icons.date_range,
                    color: Color.fromARGB(255, 29, 6, 229),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
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
                      primary: Color.fromARGB(255, 29, 6, 229),
                    ),
                    child: Text(
                      "Filtrar por Data",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _filteredAgendamentos.length,
                    itemBuilder: (context, index) {
                      final agendamento = _filteredAgendamentos[index];
                      return Card(
                        elevation: 4,
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                agendamento.usuarioAgendou,
                                style: TextStyle(
                                  fontSize: 20,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          color:
                                              Color.fromARGB(255, 29, 6, 229),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Horário:",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        "Início: ${agendamento.horaInicio}",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromARGB(255, 29, 6, 229),
                                        ),
                                      ),
                                      Text(
                                        "Término: ${agendamento.horaTermino}",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromARGB(255, 29, 6, 229),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: agendamento.status == 'Agendado'
                                        ? () {
                                            _finalizeAppointment(
                                                agendamento); // Chame a função de finalização
                                          }
                                        : null, // Desabilite o botão se estiver em outro status
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.green,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                    ),
                                    child: Text(
                                      "Finalizar",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: agendamento.status == 'Agendado'
                                        ? () {
                                            _cancelAppointment(
                                                agendamento); // Chame a função de cancelamento
                                          }
                                        : null, // Desabilite o botão se estiver em outro status
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                    ),
                                    child: Text(
                                      "Cancelar",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchAgendamentosFromFirebase() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userId = user.uid;

        final userDocRef =
            FirebaseFirestore.instance.collection('medico').doc(userId);
        final userDataSnapshot = await userDocRef.get();

        if (userDataSnapshot.exists) {
          final querySnapshot = await FirebaseFirestore.instance
              .collection('agendar')
              .where('user_id', isEqualTo: userId)
              .get();

          final agendamentos = querySnapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Agendamento(
              id: doc.id,
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
          _agendamentosFinalizado = agendamentos
              .where((agendamento) => agendamento.status == "Cancelado")
              .toList();

          setState(() {
            _agendamentos = agendamentos;
          });
        }
      }
    } catch (e) {
      print('Erro ao buscar agendamentos: $e');
    }
  }

  Future<void> _cancelAppointment(Agendamento agendamento) async {
    try {
      final agendamentoDocRef =
          FirebaseFirestore.instance.collection('agendar').doc(agendamento.id);

      await agendamentoDocRef.update({
        'status': 'Cancelado',
      });

      final updatedAgendamento = Agendamento(
        id: agendamento.id,
        data: agendamento.data,
        usuarioAgendou: agendamento.usuarioAgendou,
        horaInicio: agendamento.horaInicio,
        horaTermino: agendamento.horaTermino,
        status: 'Cancelado',
      );

      final index =
          _agendamentos.indexWhere((element) => element.id == agendamento.id);
      if (index != -1) {
        setState(() {
          _agendamentos[index] = updatedAgendamento;
          _agendamentosAgendados
              .removeWhere((element) => element.id == agendamento.id);
          _agendamentosCancelados.add(updatedAgendamento);
          _buttonIndex = 1;
        });
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Agendamento Cancelado'),
            content: Text('O agendamento foi cancelado com sucesso.'),
            actions: <Widget>[
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
    } catch (e) {
      print('Erro ao cancelar agendamento: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao cancelar o agendamento.'),
        ),
      );
    }
  }

  Future<void> _finalizeAppointment(Agendamento agendamento) async {
    try {
      final agendamentoDocRef =
          FirebaseFirestore.instance.collection('agendar').doc(agendamento.id);

      await agendamentoDocRef.update({
        'status': 'Finalizado', // Atualize o status para "Finalizado"
      });

      final updatedAgendamento = Agendamento(
        id: agendamento.id,
        data: agendamento.data,
        usuarioAgendou: agendamento.usuarioAgendou,
        horaInicio: agendamento.horaInicio,
        horaTermino: agendamento.horaTermino,
        status: 'Finalizado', // Atualize o status localmente
      );

      // Remova o agendamento da lista de agendamentos agendados
      setState(() {
        _agendamentosAgendados
            .removeWhere((element) => element.id == agendamento.id);
        _agendamentosFinalizado.add(
            updatedAgendamento); // Adicione-o à lista de agendamentos finalizados
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Agendamento Finalizado'),
            content: Text('O agendamento foi finalizado com sucesso.'),
            actions: <Widget>[
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
    } catch (e) {
      print('Erro ao finalizar agendamento: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao finalizar o agendamento.'),
        ),
      );
    }
  }

  Future<void> _fetchMedicoDataFromFirebase() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userId = user.uid;

        final userDocRef =
            FirebaseFirestore.instance.collection('medico').doc(userId);
        final userDataSnapshot = await userDocRef.get();

        final nomeMedico = userDataSnapshot.get('nome');

        setState(() {
          _medicoName = nomeMedico ?? '';
          _perfilImageUrl =
              userDataSnapshot.get('perfilImageUrl') ?? 'images/iconpadrao.jpg';
        });
      }
    } catch (e) {
      print('Error fetching doctor data: $e');
    }
  }

  List<Agendamento> get _filteredAgendamentos {
    final selectedDateLocal =
        _selectedDate?.toLocal() ?? DateTime.now().toLocal();
    final searchText = _searchText.toLowerCase();
    if (_buttonIndex == 0) {
      return _agendamentosAgendados.where((agendamento) {
        final agendamentoDateLocal = agendamento.data.toLocal();
        return ((agendamentoDateLocal.year == selectedDateLocal.year &&
                    agendamentoDateLocal.month == selectedDateLocal.month &&
                    agendamentoDateLocal.day == selectedDateLocal.day) ||
                (selectedDateLocal == DateTime.now().toLocal() &&
                    agendamentoDateLocal.isBefore(selectedDateLocal))) &&
            agendamento.usuarioAgendou.toLowerCase().contains(searchText);
      }).toList();
    } else if (_buttonIndex == 1) {
      return _agendamentosCancelados.where((agendamento) {
        final agendamentoDateLocal = agendamento.data.toLocal();
        return (agendamentoDateLocal.year == selectedDateLocal.year &&
                agendamentoDateLocal.month == selectedDateLocal.month &&
                agendamentoDateLocal.day == selectedDateLocal.day) &&
            agendamento.usuarioAgendou.toLowerCase().contains(searchText);
      }).toList();
    }

    return [];
  }

  String _getMonthName(int month) {
    final ptBrLocale = Locale('pt', 'BR');
    initializeDateFormatting(ptBrLocale.toString());
    return DateFormat.MMMM(ptBrLocale.toString())
        .format(DateTime(DateTime.now().year, month));
  }
}

class Agendamento {
  final String id;
  final DateTime data;
  final String usuarioAgendou;
  final String horaInicio;
  final String horaTermino;
  final String status;

  Agendamento({
    required this.id,
    required this.data,
    required this.usuarioAgendou,
    required this.horaInicio,
    required this.horaTermino,
    required this.status,
  });
}

void main() {
  runApp(MaterialApp(home: HomeScreenMed()));
}
