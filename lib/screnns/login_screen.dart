import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_tcc_agend/screnns/signupmed_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/navbar_roots.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                          EdgeInsets.symmetric(vertical: 15, horizontal: 57),
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
                            ));
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

      // O login foi bem-sucedido. Você pode fazer alguma ação aqui, se necessário.
      // Por exemplo, atualizar o nome de exibição do usuário.
      await userCredential.user!.updateDisplayName(_emailController.text);

      // Navegar para a próxima tela somente após o login bem-sucedido.
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NavBarRoots()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuário não encontrado'),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sua senha está errada'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      // Caso ocorra algum erro não relacionado à autenticação.
      // Por exemplo, problemas de conexão ou outros erros.
      print('Erro inesperado durante o login: $e');
    }
  }
}
