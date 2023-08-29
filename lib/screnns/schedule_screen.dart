import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_tcc_agend/screnns/calendar_screen.dart';
import 'package:intl/intl.dart';

class DoctorInfo {
  final String name;
  final String specialty;
  final String address;
  final String city;
  final String numb;
  final String phone;

  DoctorInfo({
    required this.name,
    required this.specialty,
    required this.address,
    required this.city,
    required this.numb,
    required this.phone,
  });
}

class ScheduleScreen extends StatefulWidget {
  final String especialidade;

  const ScheduleScreen({Key? key, required this.especialidade})
      : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _buttonIndex = 0;
  //bool _isDoctorDetailsExpanded = false;
  late String doctorName = "No doctors found";
  late String doctorSpecialty = "";
  late String doctorTel = "";

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
                    // Implement your search logic here
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
                          "Disponivel",
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
              _buildDoctorHeader(), // Mostrar nome e especialidade do médico
              _buildDoctorBody(), // Mostrar lista de médicos
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorHeader() {
    final especialidade = widget.especialidade;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('medico')
          .where('especialidades', isEqualTo: especialidade)
          .where('status',
              isEqualTo: 'Agendado') // Filtre por status "Agendado"
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          final doctor = snapshot.data!.docs[0];
          final doctorData = doctor.data() as Map<String, dynamic>;
          doctorName = doctorData['nome'];
          doctorSpecialty = doctorData['especialidades'];
          doctorTel = doctorData['telefone'];

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name: $doctorName',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 29, 6, 229),
                  ),
                ),
                Text(
                  'Specialty: $doctorSpecialty',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 29, 6, 229),
                  ),
                ),
                Text(
                  'Phone: $doctorTel', // Exibe o telefone do médico aqui
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 29, 6, 229),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CalendarScreen(
                                doctorName: doctorName,
                                doctorSpecialty: doctorSpecialty,
                                doctorId: '',
                              )),
                    );
                  },
                  child: Text("Ver Disponibilidade"),
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildDoctorBody() {
    final especialidade = widget.especialidade;
    String? userUID = FirebaseAuth.instance.currentUser?.uid;
    if (_buttonIndex == 0) {
      // Verifica se o botão "Disponível" está selecionado
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('disponibilizar')
            .where('especialidades', isEqualTo: especialidade)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            final doctorDocs = snapshot.data!.docs;

            // Group doctors by name
            Map<String, List<DocumentSnapshot>> doctorsByName = {};
            for (var doctor in doctorDocs) {
              final doctorData = doctor.data() as Map<String, dynamic>;
              String doctorName = doctorData['nome'] ?? "Nome desconhecido";
              if (!doctorsByName.containsKey(doctorName)) {
                doctorsByName[doctorName] = [];
              }
              doctorsByName[doctorName]!.add(doctor);
            }

            // Create DoctorInfo objects
            List<DoctorInfo> doctorInfos = [];
            for (var doctorName in doctorsByName.keys) {
              final doctorData =
                  doctorsByName[doctorName]![0].data() as Map<String, dynamic>;
              String doctorSpecialty = especialidade;

              String doctorAddress =
                  doctorData['endereco'] ?? "Endereço desconhecido";
              String doctorCity = doctorData['cidade'] ?? "Cidade desconhecida";
              String doctorNumb = doctorData['numero'] ?? "Cidade desconhecida";
              String doctorPhone =
                  doctorData['telefone'] ?? "Telefone desconhecida";

              doctorInfos.add(DoctorInfo(
                name: doctorName,
                specialty: doctorSpecialty,
                address: doctorAddress,
                city: doctorCity,
                numb: doctorNumb,
                phone: doctorPhone, // Fornecer o argumento 'phone' aqui
              ));
            }

            return Column(
              children: doctorInfos.map((doctorInfo) {
                return Card(
                  elevation:
                      4, // Ajuste o valor da elevação conforme necessário
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          doctorInfo.name,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 29, 6, 229),
                          ),
                        ),
                        subtitle: Text(
                          doctorInfo.specialty,
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 29, 6, 229),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0), // Add left padding
                        child: Text(
                          'Telefone: ${doctorInfo.phone}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0), // Add left padding
                        child: Text(
                          'Endereço: ${doctorInfo.address}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0), // Add left padding
                        child: Text(
                          'Cidade: ${doctorInfo.city}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8,
                          bottom: 16, // Adicione espaço extra abaixo do botão
                        ),
                        child: Container(
                          height: 50, // Ajuste a altura conforme necessário
                          alignment:
                              Alignment.topCenter, // Alinhe o botão ao centro
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CalendarScreen(
                                    doctorName: doctorInfo.name,
                                    doctorSpecialty: doctorInfo.specialty,
                                    doctorId: '',
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 29, 6, 229),
                            ),
                            child: Text("Agendar"),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          } else {
            return Container();
          }
        },
      );
    } else if (_buttonIndex == 1) {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('agendar')
            .where('userUID', isEqualTo: userUID)
            .where('status', isEqualTo: 'Agendado')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return Column(
              children: snapshot.data!.docs.map((appointment) {
                final appointmentData =
                    appointment.data() as Map<String, dynamic>;
                String horaInicio = appointmentData['horaInicio'];
                String horaTermino = appointmentData['horaTermino'];
                String endereco = appointmentData['endereco'];
                String cidade = appointmentData['cidade'] ?? 'S';
                String telefone = appointmentData['telefone'] ?? 'n';
                String doctorName = appointmentData['doctorName'];

                Timestamp timestamp = appointmentData['data'];
                String formattedDate =
                    DateFormat('dd/MM/yyyy').format(timestamp.toDate());

                return Card(
                  elevation:
                      4, // Ajuste o valor da elevação conforme necessário
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          doctorName,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 29, 6, 229),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Agendado',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 29, 6, 229),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Telefone: $telefone',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            Text(
                              'Endereço: $endereco',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            Text(
                              'Cidade: $cidade',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          onPressed: () async {
                            bool userConfirmed = await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Cancelar Agendamento'),
                                  content: Text(
                                      'Tem certeza de que deseja cancelar este agendamento?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(
                                            false); // Usuário não confirmou
                                      },
                                      child: Text('Não'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(true); // Usuário confirmou
                                      },
                                      child: Text('Sim'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (userConfirmed == true) {
                              // Realizar a atualização do status na coleção "agendar" para "Cancelado"
                              String docId = appointment
                                  .id; // Substituir pelo ID real do documento
                              await FirebaseFirestore.instance
                                  .collection('agendar')
                                  .doc(docId)
                                  .update({'status': 'Cancelado'});

                              // Implementar qualquer outra ação necessária após o cancelamento
                            }
                          },
                          icon: Icon(Icons.cancel),
                          color: Colors.red,
                        ),
                      ),
                      ListTile(
                        //leading: Icon(Icons.access_time),
                        title: Text(
                          'Data: $formattedDate  - Início: $horaInicio - Término: $horaTermino',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 29, 6, 229),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                );
              }).toList(),
            );
          } else {
            return Center(child: Text('Nenhum agendamento encontrado.'));
          }
        },
      );
    } else if (_buttonIndex == 2) {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('agendar')
            .where('userUID', isEqualTo: userUID)
            .where('status', isEqualTo: 'Cancelado')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return Column(
              children: snapshot.data!.docs.map((appointment) {
                final appointmentData =
                    appointment.data() as Map<String, dynamic>;
                String horaInicio = appointmentData['horaInicio'];
                String horaTermino = appointmentData['horaTermino'];
                String endereco = appointmentData['endereco'];
                String cidade = appointmentData['cidade'] ?? 'XX';
                String telefone = appointmentData['telefone'] ?? 'X';
                String doctorName = appointmentData['doctorName'];

                Timestamp timestamp = appointmentData['data'];
                String formattedDate =
                    DateFormat('dd/MM/yyyy').format(timestamp.toDate());

                return Card(
                  elevation:
                      4, // Ajuste o valor da elevação conforme necessário
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(
                          doctorName,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 29, 6, 229),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cancelado',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 29, 6, 229),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Telefone: $telefone',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            Text(
                              'Endereço: $endereco',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            Text(
                              'Cidade: $cidade',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        //leading: Icon(Icons.access_time),
                        title: Text(
                          'Data: $formattedDate - Início: $horaInicio - Término: $horaTermino',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 29, 6, 229),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                );
              }).toList(),
            );
          } else {
            return Center(
                child: Text('Nenhum agendamento cancelado encontrado.'));
          }
        },
      );
    }

    return SizedBox();
  }
}
