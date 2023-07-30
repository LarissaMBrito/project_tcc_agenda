import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Configurações'), // Defina o título desejado para a tela
          backgroundColor: const Color.fromARGB(
              255, 29, 6, 229), // Defina a cor de fundo da AppBar
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(height: 10),
                ListTile(
                  onTap: () {},
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
                  onTap: () {},
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
                Divider(height: 40),
                ListTile(
                  onTap: () {},
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.info_outline_rounded,
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
        ));
  }
}
