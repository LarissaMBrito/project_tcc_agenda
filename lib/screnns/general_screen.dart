import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GeneralScreen extends StatefulWidget {
  @override
  _GeneralScreenState createState() => _GeneralScreenState();
}

class _GeneralScreenState extends State<GeneralScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool isMedico = false;

  @override
  void initState() {
    super.initState();
    checkUserRole();
  }

  void checkUserRole() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userId = user.uid;
      final medicoDoc = await _firestore.collection('medico').doc(userId).get();
      final pacienteDoc =
          await _firestore.collection('paciente').doc(userId).get();

      if (medicoDoc.exists) {
        setState(() {
          isMedico = true;
        });
      } else if (pacienteDoc.exists) {
        setState(() {
          isMedico = false;
        });
      }
    }
  }

  Future<void> updateUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        // Atualize o email apenas se o campo não estiver vazio
        if (emailController.text.isNotEmpty) {
          await user.updateEmail(emailController.text);
        }

        // Reautentique o usuário com a senha atual
        final currentPassword = currentPasswordController.text;
        final newPassword = newPasswordController.text;

        if (currentPassword.isNotEmpty && newPassword.isNotEmpty) {
          final credential = EmailAuthProvider.credential(
            email: user.email!,
            password: currentPassword,
          );

          await user.reauthenticateWithCredential(credential);

          // Agora que o usuário foi reautenticado com sucesso, atualize a senha
          await user.updatePassword(newPassword);
        }

        // Atualize os outros campos
        final userId = user.uid;
        final dataToUpdate = {
          'endereco': addressController.text,
        };

        if (isMedico) {
          await _firestore
              .collection('medico')
              .doc(userId)
              .update(dataToUpdate);
        } else {
          await _firestore
              .collection('paciente')
              .doc(userId)
              .update(dataToUpdate);
        }

        // Exiba um diálogo de sucesso
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Alterações Salvas'),
              content: Text('As alterações foram salvas com sucesso.'),
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
        // Lidar com erros durante a atualização
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Erro'),
              content: Text('Ocorreu um erro ao salvar as alterações: $e'),
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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações Gerais'),
        backgroundColor: const Color.fromARGB(255, 29, 6, 229),
      ),
      body: SingleChildScrollView(
        // Adicione o SingleChildScrollView ao redor do Column
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Alterar E-mail',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Novo E-mail'),
              ),
              SizedBox(height: 20),
              Text(
                'Alterar Senha',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: currentPasswordController,
                decoration: InputDecoration(labelText: 'Senha Atual'),
                obscureText: true,
              ),
              TextFormField(
                controller: newPasswordController,
                decoration: InputDecoration(labelText: 'Nova Senha'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              Text(
                'Alterar Endereço',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Novo Endereço'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          updateUserData();
        },
        child: Icon(Icons.save),
        backgroundColor: const Color.fromARGB(255, 29, 6, 229), // Cor do botão
      ),
    );
  }
}
