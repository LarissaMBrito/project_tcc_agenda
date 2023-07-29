import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class SignUpMedScreen extends StatefulWidget {
  @override
  State<SignUpMedScreen> createState() => _SignUpMedScreenState();
}

class _SignUpMedScreenState extends State<SignUpMedScreen> {
  bool passToggle = true;

  final _nomeControoler = TextEditingController();
  final _emailControler = TextEditingController();
  final _telefoneControoler = TextEditingController();
  final _crmControoler = TextEditingController();
  final _EspecialidadeControoler = TextEditingController();
  final _senhaControoler = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    var textField = TextField(
      controller: _nomeControoler,
      decoration: InputDecoration(
        labelText: "Nome Completo",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
    );
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 29, 6, 229),
        ),
        body: Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                      child: textField,
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                      child: TextField(
                        controller: _emailControler,
                        decoration: InputDecoration(
                          labelText: "E-Mail",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                      child: TextField(
                        controller: _telefoneControoler,
                        decoration: InputDecoration(
                          labelText: "Telefone",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                      child: TextField(
                        controller: _crmControoler,
                        decoration: InputDecoration(
                            labelText: "CRM",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person)),
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                      child: TextField(
                        controller: _EspecialidadeControoler,
                        decoration: InputDecoration(
                          labelText: "Especialidade",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
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
                          cadastrar();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 57),
                          child: Text(
                            "Cadastrar",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }

  cadastrar() async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: _emailControler.text, password: _senhaControoler.text);
      userCredential.user!.updateDisplayName(_nomeControoler.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'week-passaword') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Crie uma senha mais forte'),
          backgroundColor: Colors.redAccent,
        ));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Este e-mail ja foi cadastrado'),
          backgroundColor: Colors.redAccent,
        ));
      }
    }
  }
}
