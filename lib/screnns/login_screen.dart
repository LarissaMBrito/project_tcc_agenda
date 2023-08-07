import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_tcc_agend/screnns/signupatient_screen.dart';

import '../widgets/navbar_roots.dart';
import '../widgets/navbar_roots_med.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool passToggle = true;
  bool loginSuccess = false;

  final _emailController = TextEditingController();
  final _senhaControoler = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;

  Future<String?> _determineTipoUsuario(String uid) async {
    String? tipoUsuario;
    try {
      DocumentSnapshot docSnapshotMedico =
          await FirebaseFirestore.instance.collection('medico').doc(uid).get();
      if (docSnapshotMedico.exists) {
        tipoUsuario = "medico";
      } else {
        DocumentSnapshot docSnapshotPaciente = await FirebaseFirestore.instance
            .collection('paciente')
            .doc(uid)
            .get();
        if (docSnapshotPaciente.exists) {
          tipoUsuario = "paciente";
        }
      }
    } catch (e) {
      print('Erro ao recuperar o tipo de usuário: $e');
    }
    return tipoUsuario;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: const Color.fromARGB(255, 29, 6, 229),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 15),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Image.asset("images/doutor.jpeg"),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: TextField(
                    controller: _emailController,
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "E-mail",
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: TextField(
                    controller: _senhaControoler,
                    obscureText: passToggle,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Senha",
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            passToggle = !passToggle;
                          });
                        },
                        child: Icon(
                          passToggle
                              ? CupertinoIcons.eye_slash_fill
                              : CupertinoIcons.eye_fill,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Material(
                  color: Color.fromARGB(255, 29, 6, 229),
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {
                      login();
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                      child: Text(
                        "Entrar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Não possui conta?",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpMedScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Crie uma agora",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  login() async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _senhaControoler.text,
      );

      if (userCredential.user == null) {
        _showAlertDialog(
            'Usuário ou senha incorretos. Verifique suas credenciais.');
      } else {
        await userCredential.user!.updateDisplayName(_emailController.text);

        String? tipoUsuario =
            await _determineTipoUsuario(userCredential.user!.uid);

        if (tipoUsuario == "medico") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NavBarRoots_Med()),
          );
        } else if (tipoUsuario == "paciente") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NavBarRoots()),
          );
        } else {
          _showAlertDialog('Tipo de usuário desconhecido.');
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        _showAlertDialog(
            'Usuário ou senha incorretos. Verifique suas credenciais.');
      } else {
        _showAlertDialog('Erro ao fazer login: $e');
      }
    } catch (e) {
      _showAlertDialog('Erro ao fazer login: $e');
      print('Erro ao fazer login: $e');
    }
  }

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alerta'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
