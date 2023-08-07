import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(EventApp());
}

class EventApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicativo de Eventos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EventScreen(),
    );
  }
}

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  String getFormattedDate(DateTime? date) {
    return date != null
        ? DateFormat('dd/MM/yyyy').format(date)
        : 'Selecionar Data';
  }

  String? getFormattedTime(TimeOfDay? time) {
    return time != null ? time.format(context) : null;
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sucesso'),
          content: Text('Dados cadastrados com sucesso'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar o AlertDialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _saveEventData() async {
    if (selectedDate != null && startTime != null && endTime != null) {
      try {
        final firestore = FirebaseFirestore.instance;
        final formattedDate = DateFormat('dd/MM/yyyy')
            .format(selectedDate!); // Formata a data como 'dd/MM/yyyy'
        await firestore.collection('disponibilizar').add({
          'data': formattedDate,
          'horaInicio': getFormattedTime(startTime),
          'horaFim': getFormattedTime(endTime),
        });

        print(
            'Dados salvos: Data: $formattedDate, Hora de Início: ${getFormattedTime(startTime)}, Hora de Término: ${getFormattedTime(endTime)}');

        // Exibir o AlertDialog de sucesso
        _showSuccessDialog();
      } catch (error) {
        print('Erro ao salvar os dados: $error');
      }
    } else {
      print('Preencha todos os campos antes de salvar.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Evento'),
        backgroundColor: Color.fromARGB(255, 29, 6, 229),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 8),
                    Text(
                      getFormattedDate(selectedDate),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTimeColumn(
                  'Hora de Início',
                  startTime,
                  (TimeOfDay time) => setState(() {
                    startTime = time;
                  }),
                ),
                _buildTimeColumn(
                  'Hora de Término',
                  endTime,
                  (TimeOfDay time) => setState(() {
                    endTime = time;
                  }),
                ),
              ],
            ),
            SizedBox(height: 30),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Data Selecionada:',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    getFormattedDate(selectedDate),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time, size: 20),
                      SizedBox(width: 5),
                      Text(
                        'Hora de Início:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        getFormattedTime(startTime) ?? 'Selecione hora',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.access_time, size: 20),
                      SizedBox(width: 5),
                      Text(
                        'Hora de Término:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        getFormattedTime(endTime) ?? 'Selecione hora',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 16),
                child: FloatingActionButton(
                  onPressed: _saveEventData,
                  backgroundColor: Color.fromARGB(255, 29, 6, 229),
                  child: Icon(Icons.save),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ... Restante do código ...

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Column _buildTimeColumn(
    String label,
    TimeOfDay? time,
    void Function(TimeOfDay) onTimeSelected,
  ) {
    return Column(
      children: [
        Text(label),
        GestureDetector(
          onTap: () =>
              _selectTime(context, time ?? TimeOfDay.now(), onTimeSelected),
          child: Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Row(
              children: [
                Icon(Icons.access_time),
                SizedBox(width: 8),
                Text(
                  getFormattedTime(time) ?? 'Selecione hora',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectTime(
    BuildContext context,
    TimeOfDay initialTime,
    Function(TimeOfDay) onTimeSelected,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null) {
      setState(() {
        onTimeSelected(picked);
      });
    }
  }
}
