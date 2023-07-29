import 'package:flutter/material.dart';
import 'package:project_tcc_agend/screnns/calendar_screen.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _buttonIndex = 0;
  bool _isDoctorDetailsExpanded = false;

  final _sheduleWidgets = [
    Container(),
    Container(),
    Container(),
    Container(),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Calendário",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                ),
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
                            ? Color(0xFF7165D6)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Disponível",
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
                            ? Color(0xFF7165D6)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Agendado",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color:
                              _buttonIndex == 1 ? Colors.white : Colors.black38,
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
                            ? Color(0xFF7165D6)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Cancelado",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color:
                              _buttonIndex == 2 ? Colors.white : Colors.black38,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            // Updated section to display doctor's information with ExpansionPanelList
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
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage(
                                  "images/medico.jpg"), // Adicione a imagem do médico aqui
                              radius: 24,
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Médico Cardiologista",
                                  style: TextStyle(
                                    fontSize: 18, // Texto em negrito
                                    color: Color.fromARGB(255, 29, 6,
                                        229), // Altera a cor do texto para azul
                                  ),
                                ),
                                Text(
                                  "João Carlos Brito",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight:
                                        FontWeight.bold, // Texto em negrito
                                    color: Color.fromARGB(255, 29, 6,
                                        229), // Altera a cor do texto para azul
                                  ),
                                ),
                                Text(
                                  "Endereço: Av. Walter Antonio, Assis, SP",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 29, 6,
                                        229), // Altera a cor do texto para azul
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        body: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              Text(
                                "Nome da Clínica:",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors
                                      .black, // Altera a cor do texto para preto
                                ),
                              ),
                              Text(
                                "BEM MAIS SAUDE",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 29, 6, 229),
                                  // Altera a cor do texto para preto
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Localização:",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors
                                      .black, // Altera a cor do texto para preto
                                ),
                              ),
                              Text(
                                "AV.WALTER ANTONIO 512, ASSIS - SP",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 29, 6,
                                      229), // Altera a cor do texto para preto
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "CRM:",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors
                                      .black, // Altera a cor do texto para preto
                                ),
                              ),
                              Text(
                                "595884",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 29, 6,
                                      229), // Altera a cor do texto para preto
                                ),
                              ),
                              SizedBox(height: 20),
                              Material(
                                color: Color.fromARGB(255, 29, 6, 229),
                                borderRadius: BorderRadius.circular(10),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CalendarScreen(),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 57),
                                    child: Text(
                                      "Entrar",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            _sheduleWidgets[_buttonIndex],
          ],
        ),
      ),
    );
  }
}
