import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_tcc_agend/screnns/income_screen.dart'; // Usando um apelido para diferenciar
import 'package:project_tcc_agend/screnns/login_screen.dart';

import 'package:project_tcc_agend/screnns/terms_use_screen.dart';
// Usando um apelido para diferenciar

class SignUpMedScreen extends StatefulWidget {
  @override
  State<SignUpMedScreen> createState() => _SignUpMedScreenState();
}

class _SignUpMedScreenState extends State<SignUpMedScreen> {
  bool passToggle = true;
  bool _isConsentGiven = false;
  String? _selectedUserType;
  String? _selectedSpecialty; // Add this variable

  final _nomeControoler = TextEditingController();
  final _emailControler = TextEditingController();
  final _telefoneControoler = TextEditingController();
  final _cpfControoler = TextEditingController();
  final _crmControoler = TextEditingController();
  final _enderecoControoler = TextEditingController();
  final _numenderecoControoler = TextEditingController();
  final _cidadeControoler = TextEditingController();
  //final _especialidadeControoler = TextEditingController();
  final _senhaControoler = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;

  final _nomeCompletoAdminControoler = TextEditingController();
  final _cpfAdminController = TextEditingController();
  final _telefoneAdminController = TextEditingController();

  List<String> _specialties = [];

  @override
  void initState() {
    super.initState();
    _loadSpecialties(); // Load specialties when the screen initializes
  }

  Future<void> _loadSpecialties() async {
    try {
      QuerySnapshot specialtiesSnapshot =
          await FirebaseFirestore.instance.collection('especialidades').get();

      List<String> specialtiesList =
          specialtiesSnapshot.docs.map((doc) => doc['nome'] as String).toList();

      setState(() {
        _specialties = specialtiesList;
      });
    } catch (e) {
      print('Error loading specialties: $e');
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
                    items: ['Médico', 'Paciente', 'Administrador']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 20),
                if (_selectedUserType == "Médico")
                  Column(
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
                        controller: _telefoneControoler,
                        decoration: InputDecoration(
                          labelText: "Telefone",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
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
                        controller: _numenderecoControoler,
                        decoration: InputDecoration(
                          labelText: "Numero do Endereço",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_on),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: _cidadeControoler,
                        decoration: InputDecoration(
                          labelText: "Cidade de Atendimento",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_on),
                        ),
                      ),
                      SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        value: _selectedSpecialty,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedSpecialty = newValue;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Especialidades",
                          prefixIcon: Icon(Icons.category),
                        ),
                        items: _specialties.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
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
                    ],
                  )
                else if (_selectedUserType == "Paciente")
                  Column(
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
                        padding: EdgeInsets.all(1),
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
                  )
                else if (_selectedUserType == "Administrador")
                  Column(
                    children: [
                      TextField(
                        controller:
                            _nomeCompletoAdminControoler, // Campo Nome Completo do Administrador
                        decoration: InputDecoration(
                          labelText: "Nome Completo",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: _cpfAdminController, // Campo CPF
                        decoration: InputDecoration(
                          labelText: "CPF",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: _telefoneAdminController, // Campo Telefone
                        decoration: InputDecoration(
                          labelText: "Telefone",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: _emailControler, // Campo E-mail
                        decoration: InputDecoration(
                          labelText: "E-Mail",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: _senhaControoler, // Campo Senha
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
                    ],
                  ),
                SizedBox(height: 3),
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
                SizedBox(height: 6),
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
                          EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                      child: Text(
                        "Cadastrar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
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

  cadastrar() async {
    String tipoUsuario = ""; // Inicialização padrão
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: _emailControler.text,
        password: _senhaControoler.text,
      );

      String userId = userCredential.user!.uid; // Obtenha o ID do usuário

      Map<String, dynamic> userData = {
        'email': _emailControler.text,
        'senha': _senhaControoler.text,
        'userId': userId,
      };

      if (_selectedUserType == "Médico") {
        tipoUsuario = "medico";
        userData['nome'] = _nomeControoler.text;
        userData['telefone'] = _telefoneControoler.text;
        userData['cpf'] = _cpfControoler.text;
        userData['crm'] = _crmControoler.text;
        userData['endereco'] = _enderecoControoler.text;
        userData['numero'] = _numenderecoControoler.text;
        userData['cidade'] = _cidadeControoler.text;
        userData['especialidade'] = _selectedSpecialty;
      } else if (_selectedUserType == "Paciente") {
        tipoUsuario = "paciente";
        userData['nome'] = _nomeControoler.text;
        userData['telefone'] = _telefoneControoler.text;
        userData['cpf'] = _cpfControoler.text;
      } else if (_selectedUserType == "Administrador") {
        tipoUsuario = "administrador";
        userData['nome'] = _nomeCompletoAdminControoler.text;
        userData['telefone'] = _telefoneAdminController.text;
        userData['cpf'] = _cpfAdminController.text;
      }

      CollectionReference userTypeCollection =
          FirebaseFirestore.instance.collection(tipoUsuario);

      // Adicione o ID do usuário ao documento do usuário
      await userTypeCollection.doc(userId).set(userData);

      String nomeExibicao = _nomeControoler.text.trim();
      List<String> nomePartes = nomeExibicao.split(' ');
      if (nomePartes.isNotEmpty) {
        nomeExibicao = nomePartes[0];
      }

      // Dentro da função cadastrar()
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          if (_selectedUserType == "Paciente") {
            return IncomeScreen(); // Tela do paciente
          } else if (_selectedUserType == "Médico" ||
              _selectedUserType == "Administrador") {
            return LoginScreen(); // Tela do médico e administrador
          } else {
            return LoginScreen(); // Tela de login
          }
        }),
      );

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Cadastro Concluído'),
            content: Text('Seu cadastro foi realizado com sucesso!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fechar o diálogo
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Erro ao cadastrar usuário: $e');
    }
  }
}
