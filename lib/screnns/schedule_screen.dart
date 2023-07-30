import 'package:flutter/material.dart';
import 'package:project_tcc_agend/screnns/calendar_screen.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

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
              // Campo de pesquisa
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
                                backgroundImage:
                                    AssetImage("images/medico.jpg"),
                                radius: 24,
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Médico Cardiologista",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 29, 6, 229),
                                    ),
                                  ),
                                  Text(
                                    "João Carlos Brito",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 29, 6, 229),
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
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "BEM MAIS SAUDE",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 29, 6, 229),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Localização:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "AV.WALTER ANTONIO 512, ASSIS - SP",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 29, 6, 229),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "CRM:",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "595884",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 29, 6, 229),
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
                                          builder: (context) =>
                                              CalendarScreen(),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 57),
                                      child: Text(
                                        "Ver disponibilidade",
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
              _scheduleWidgets[_buttonIndex],
            ],
          ),
        ),
      ),
    );
  }
}
