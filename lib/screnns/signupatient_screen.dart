import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_tcc_agend/screnns/terms_use_screen.dart';
import 'login_screen.dart';

class SignUpMedScreen extends StatefulWidget {
  @override
  State<SignUpMedScreen> createState() => _SignUpMedScreenState();
}

class _SignUpMedScreenState extends State<SignUpMedScreen> {
  bool passToggle = true;
  bool _isConsentGiven = false;
  String? _selectedUserType;

  final _nomeControoler = TextEditingController();
  final _emailControler = TextEditingController();
  final _telefoneControoler = TextEditingController();
  final _cpfControoler = TextEditingController();
  final _crmControoler = TextEditingController();
  final _enderecoControoler = TextEditingController();
  final _especialidadeControoler = TextEditingController();
  final _senhaControoler = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;

  cadastrar() async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: _emailControler.text,
        password: _senhaControoler.text,
      );

      String tipoUsuario =
          _selectedUserType == "Médico" ? "medico" : "paciente";

      Map<String, dynamic> userData = {
        'nome': _nomeControoler.text,
        'email': _emailControler.text,
        'telefone': _telefoneControoler.text,
        'cpf': _cpfControoler.text,
        'senha': _senhaControoler.text,
      };

      if (_selectedUserType == "Médico") {
        userData['crm'] = _crmControoler.text;
        userData['endereco'] = _enderecoControoler.text;
        userData['especialidade'] = _especialidadeControoler.text;
      }

      CollectionReference userTypeCollection =
          FirebaseFirestore.instance.collection(tipoUsuario);
      await userTypeCollection.doc(userCredential.user!.uid).set(userData);

      String nomeExibicao = _nomeControoler.text.trim();
      List<String> nomePartes = nomeExibicao.split(' ');
      if (nomePartes.isNotEmpty) {
        nomeExibicao = nomePartes[0];
      }

      await userCredential.user!.updateDisplayName(nomeExibicao);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Usuário cadastrado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    } catch (e) {
      print('Erro ao cadastrar usuário: $e');
    }
  }

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
        title: Text('Criar meu cadastro'),
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
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: DropdownButtonFormField<String>(
                    value: _selectedUserType,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedUserType = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Tipo de Usuário",
                      prefixIcon: Icon(Icons.person),
                    ),
                    items: ['Médico', 'Paciente'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 20),
                _selectedUserType == "Médico"
                    ? Column(
                        children: [
                          textField,
                          SizedBox(height: 15),
                          TextField(
                            controller: _emailControler,
                            decoration: InputDecoration(
                              labelText: "E-Mail",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.email),
                            ),
                          ),
                          SizedBox(height: 15),
                          TextField(
                            controller: _senhaControoler,
                            obscureText: passToggle,
                            decoration: InputDecoration(
                              labelText: "Senha",
                              border: OutlineInputBorder(),
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
                          SizedBox(height: 15),
                          TextField(
                            controller: _cpfControoler,
                            decoration: InputDecoration(
                              labelText: "CPF",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                          SizedBox(height: 15),
                          TextField(
                            controller: _crmControoler,
                            decoration: InputDecoration(
                              labelText: "CRM",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                          SizedBox(height: 15),
                          TextField(
                            controller: _enderecoControoler,
                            decoration: InputDecoration(
                              labelText: "Endereço de Atendimento",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.location_on),
                            ),
                          ),
                          SizedBox(height: 15),
                          TextField(
                            controller: _especialidadeControoler,
                            decoration: InputDecoration(
                              labelText: "Especialidade",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.category),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          textField,
                          SizedBox(height: 15),
                          TextField(
                            controller: _emailControler,
                            decoration: InputDecoration(
                              labelText: "E-Mail",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.email),
                            ),
                          ),
                          SizedBox(height: 15),
                          TextField(
                            controller: _telefoneControoler,
                            decoration: InputDecoration(
                              labelText: "Telefone",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.phone),
                            ),
                          ),
                          SizedBox(height: 15),
                          TextField(
                            controller: _cpfControoler,
                            decoration: InputDecoration(
                              labelText: "CPF",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person),
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
                        ],
                      ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: _isConsentGiven,
                        onChanged: (value) {
                          setState(() {
                            _isConsentGiven = value ?? false;
                          });
                        },
                      ),
                      Text(
                        'Li e aceito a',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TermsOfUseScreen(),
                            ),
                          ).then((isConsentGiven) {
                            if (isConsentGiven == true) {
                              setState(() {
                                _isConsentGiven = true;
                              });
                            }
                          });
                        },
                        child: Text(
                          'Política de Privacidade',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Material(
                  color: Color.fromARGB(255, 29, 6, 229),
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {
                      if (_isConsentGiven && _selectedUserType != null) {
                        cadastrar();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Por favor, preencha todos os campos e aceite os termos de uso e política de privacidade.'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 57),
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
        ),
      ),
    );
  }
}
