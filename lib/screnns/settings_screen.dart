import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_tcc_agend/screnns/login_screen.dart';
import 'package:project_tcc_agend/screnns/profile_screen.dart';
import 'package:project_tcc_agend/screnns/terms_use_screen.dart';

class SettingScreen extends StatelessWidget {
  // Função para efetuar o logout
  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Após o logout, navegue para a tela de login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      print('Erro ao fazer logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
        backgroundColor: const Color.fromARGB(255, 29, 6, 229),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(height: 10),
              ListTile(
                onTap: () {
                  // Navegue para a tela de ProfileScreen quando o usuário clicar em "Perfil"
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(),
                    ),
                  );
                },
                leading: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    CupertinoIcons.person,
                    color: Colors.blue,
                    size: 35,
                  ),
                ),
                title: Text(
                  "Perfil",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
              SizedBox(height: 20),
              ListTile(
                onTap: () {},
                leading: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.notifications_none_outlined,
                    color: Colors.deepPurple,
                    size: 35,
                  ),
                ),
                title: Text(
                  "Notificações",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
              SizedBox(height: 20),
              ListTile(
                onTap: () {
                  // Navegue para a tela TermsOfUseScreen quando o usuário clicar em "Privacidade"
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          TermsOfUseScreen(), // Substitua pelo nome correto da sua tela
                    ),
                  );
                },
                leading: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.privacy_tip_outlined,
                    color: Colors.indigo,
                    size: 35,
                  ),
                ),
                title: Text(
                  "Privacidade",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
              SizedBox(height: 20),
              ListTile(
                onTap: () {},
                leading: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.settings_suggest_outlined,
                    color: Colors.green,
                    size: 35,
                  ),
                ),
                title: Text(
                  "Geral",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
              SizedBox(height: 20),
              ListTile(
                onTap: () {},
                leading: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: Colors.orange,
                    size: 35,
                  ),
                ),
                title: Text(
                  "Sobre nós",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),

              SizedBox(height: 20),
              // ... (outras opções de configurações)
              Divider(height: 40),
              ListTile(
                onTap: () {
                  // Chame a função de logout quando o botão "Sair" for pressionado
                  _signOut(context);
                },
                leading: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.exit_to_app,
                    color: Colors.redAccent,
                    size: 35,
                  ),
                ),
                title: Text(
                  "Sair",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
