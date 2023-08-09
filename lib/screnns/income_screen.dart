import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comprovante de Renda',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: IncomeScreen(),
    );
  }
}

class IncomeScreen extends StatefulWidget {
  @override
  _IncomeScreenState createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  double _income = 0.0;
  int _numDependents = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comprovante de Renda Mensal'),
        backgroundColor: Color.fromARGB(255, 29, 6, 229), // Cor da AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _income = double.tryParse(value) ?? 0.0;
                });
              },
              decoration: InputDecoration(
                labelText: 'Informe sua Renda Mensal',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _numDependents = int.tryParse(value) ?? 0;
                });
              },
              decoration: InputDecoration(
                labelText: 'Número de Dependentes',
                border: OutlineInputBorder(),
              ),
            ),
            Spacer(), // Adiciona espaço flexível
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  _showConfirmationDialog(
                      context); // Passa o contexto para a função
                },
                backgroundColor:
                    Color.fromARGB(255, 29, 6, 229), // Cor do botão flutuante
                child: Icon(Icons.save, size: 32.0), // Ícone circular
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Comprovante de Renda Mensal'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Renda Mensal: R\$ $_income'),
              Text('Número de Dependentes: $_numDependents'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Fecha o diálogo
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        LoginScreen(), // Navega para a tela LoginScreen
                  ),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tela de Login'),
        backgroundColor: Color.fromARGB(255, 29, 6, 229), // Cor da AppBar
      ),
      body: Center(
        child: Text('Tela de Login'), // Conteúdo da tela de login
      ),
    );
  }
}
