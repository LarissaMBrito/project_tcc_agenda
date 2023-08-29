import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class Agendamento {
  final DateTime data;
  final String horaInicio;
  final String horaTermino;
  final String usuarioAgendou;

  Agendamento({
    required this.data,
    required this.horaInicio,
    required this.horaTermino,
    required this.usuarioAgendou,
  });
}

class _ReportScreenState extends State<ReportScreen> {
  late Stream<QuerySnapshot> _stream;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Agendamento> agendamentos = [];
  List<Agendamento> agendamentosFiltrados = [];
  TextEditingController dataInicioController = TextEditingController();
  TextEditingController dataFimController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final currentUser = _auth.currentUser;
    final userId = currentUser?.uid;

    _stream = FirebaseFirestore.instance
        .collection('agendar')
        .where('user_id', isEqualTo: userId)
        .where('status', isEqualTo: 'Finalizado')
        .snapshots();
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;

    // ignore: unnecessary_null_comparison
    if (picked != null && picked != controller.text) {
      setState(() {
        controller.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  void filtrarAgendamentos() {
    final dataInicio = dataInicioController.text.trim();
    final dataFim = dataFimController.text.trim();

    if (dataInicio.isNotEmpty && dataFim.isNotEmpty) {
      final filteredList = agendamentos.where((agendamento) {
        final dataAgendamento = agendamento.data;
        final formatter = DateFormat('dd-MM-yyyy'); // Use o mesmo formato aqui
        final dataInicioDateTime = formatter.parse(dataInicio);
        final dataFimDateTime = formatter.parse(dataFim);
        return dataAgendamento.isAfter(dataInicioDateTime) &&
            dataAgendamento.isBefore(dataFimDateTime.add(Duration(days: 1)));
      }).toList();

      setState(() {
        agendamentosFiltrados = filteredList;
      });
    } else {
      setState(() {
        agendamentosFiltrados = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relatório de Consultas Realizadas'),
        backgroundColor: const Color.fromARGB(255, 29, 6, 229),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (context, snapshot) {
          Map<int, int> atendimentosPorMes = {};
          int numAgendamentos = 0;

          if (snapshot.hasData) {
            final agendamentoDocs = snapshot.data!.docs;
            numAgendamentos = agendamentoDocs.length;

            agendamentos = [];

            agendamentoDocs.forEach((agendamento) {
              final data = agendamento['data'].toDate();
              final horaInicio = agendamento['horaInicio'];
              final horaTermino = agendamento['horaTermino'];
              final usuarioAgendou = agendamento['usuarioAgendou'];
              agendamentos.add(Agendamento(
                  data: data,
                  horaInicio: horaInicio,
                  horaTermino: horaTermino,
                  usuarioAgendou: usuarioAgendou));

              final mes = data.month;
              atendimentosPorMes[mes] = (atendimentosPorMes[mes] ?? 0) + 1;
            });

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Espaço entre o topo e o gráfico
                SizedBox(height: 20),

                SizedBox(
                  height: 300,
                  child: LineChart(
                    mainData(atendimentosPorMes),
                  ),
                ),

                SizedBox(height: 30),
                Text(
                  'Agendamentos realizados: $numAgendamentos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            _selectDate(context, dataInicioController);
                          },
                          child: AbsorbPointer(
                            child: TextField(
                              controller: dataInicioController,
                              decoration: InputDecoration(
                                labelText: 'Data de Início',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16), // Espaço entre os campos
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            _selectDate(context, dataFimController);
                          },
                          child: AbsorbPointer(
                            child: TextField(
                              controller: dataFimController,
                              decoration: InputDecoration(
                                labelText: 'Data de Término',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: filtrarAgendamentos,
                  child: Text('Filtrar'),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(
                        255, 29, 6, 229), // Define a cor de fundo
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: agendamentosFiltrados.length,
                    itemBuilder: (context, index) {
                      final agendamento = agendamentosFiltrados[index];
                      final dataAgendamento = agendamento.data;
                      final formattedData =
                          DateFormat('dd/MM/yyyy').format(dataAgendamento);

                      return ListTile(
                        title: Text('Data: $formattedData'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hora de Início: ${agendamento.horaInicio}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              'Hora de Término: ${agendamento.horaTermino}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              'Paciente: ${agendamento.usuarioAgendou}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar os dados'),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  LineChartData mainData(Map<int, int> atendimentosPorMes) {
    final List<FlSpot> spots = List.generate(12, (index) {
      final valor = atendimentosPorMes[index + 1]?.toDouble() ?? 0.0;
      return FlSpot(index.toDouble(), valor);
    });

    final List<String> monthLabels = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Color.fromARGB(255, 17, 122, 122),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Color.fromARGB(255, 17, 122, 122),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(
          showTitles: false,
        ),
        topTitles: SideTitles(
          showTitles: false,
        ),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          interval: 1,
          getTitles: (value) {
            if (value.toInt() >= 0 && value.toInt() < 12) {
              return monthLabels[value.toInt()];
            }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTitles: (value) {
            return value.toInt().toString();
          },
          reservedSize: 18,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Color.fromARGB(255, 17, 122, 122)),
      ),
      minX: 0,
      maxX: 12,
      minY: 0,
      maxY: spots.reduce((a, b) => a.y > b.y ? a : b).y + 5,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
        ),
      ],
    );
  }
}

void main() => runApp(MaterialApp(home: ReportScreen()));
