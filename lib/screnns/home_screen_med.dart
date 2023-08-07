import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MaterialApp(home: HomeScreenMed()));
}

class HomeScreenMed extends StatefulWidget {
  const HomeScreenMed({Key? key}) : super(key: key);

  @override
  State<HomeScreenMed> createState() => _HomeScreenMedState();
}

class _HomeScreenMedState extends State<HomeScreenMed> {
  int _buttonIndex = 0;
  List<Map<String, dynamic>> disponiveis = [];

  @override
  void initState() {
    super.initState();
    _getDisponiveis();
  }

  Future<void> _getDisponiveis() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('disponibilizar').get();

      disponiveis = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      print('Dados disponíveis: $disponiveis');
    } catch (e) {
      print('Erro ao recuperar dias disponíveis: $e');
    }
  }

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
                    _buildButton(0, "Disponível"),
                    _buildButton(1, "Agendado"),
                    _buildButton(2, "Cancelado"),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Dias disponíveis
              if (_buttonIndex == 0) _buildGroupedDaySlots(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(int index, String label) {
    return InkWell(
      onTap: () {
        setState(() {
          _buttonIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 11, horizontal: 20),
        decoration: BoxDecoration(
          color: _buttonIndex == index
              ? Color.fromARGB(255, 29, 6, 229)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: _buttonIndex == index ? Colors.white : Colors.black38,
          ),
        ),
      ),
    );
  }

  Widget _buildGroupedDaySlots() {
    Column groupedDaySlots = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [],
    );

    if (disponiveis.isEmpty) {
      groupedDaySlots.children.add(
        Center(
          child: Text('Nenhum dia disponível encontrado.'),
        ),
      );
    } else {
      Map<String, List<Map<String, dynamic>>> groupedSlots = {};

      // Agrupar os horários pelo dia, mês e ano
      for (Map<String, dynamic> daySlot in disponiveis) {
        final date = daySlot['data'];
        final key =
            '$date'; // Você pode ajustar esse formato para atender às suas necessidades

        if (!groupedSlots.containsKey(key)) {
          groupedSlots[key] = [];
        }

        groupedSlots[key]!.add(daySlot);
      }

      // Criar os cards para os grupos de horários
      groupedSlots.forEach((key, slots) {
        List<Widget> slotWidgets = slots.map((slot) {
          return GestureDetector(
            onTap: () {
              _editAppointment(slot); // Função para editar o horário
            },
            child: ListTile(
              title: Text('${slot['horaInicio']} - ${slot['horaFim']}'),
              leading: Icon(Icons.calendar_today),
            ),
          );
        }).toList();

        Widget daySlotCard = Card(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Dia: ${slots.first['data']}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...slotWidgets,
            ],
          ),
        );

        groupedDaySlots.children.add(daySlotCard);
      });
    }

    return groupedDaySlots;
  }

  void _editAppointment(Map<String, dynamic> appointmentData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditAppointmentScreen(appointmentData: appointmentData),
      ),
    );
  }
}

class EditAppointmentScreen extends StatelessWidget {
  final Map<String, dynamic> appointmentData;

  const EditAppointmentScreen({required this.appointmentData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Horário'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Data: ${appointmentData['data']}'),
            Text('Hora Início: ${appointmentData['horaInicio']}'),
            Text('Hora Fim: ${appointmentData['horaFim']}'),
            // Adicione campos de edição aqui, se necessário
          ],
        ),
      ),
    );
  }
}
