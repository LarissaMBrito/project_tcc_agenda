import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _especialidades = [
    {"nome": "Oftalmologista", "imagem": "images/oftalmologista.jpg"},
    {"nome": "Cardiologista", "imagem": "images/cardiologista.jpg"},
    {"nome": "Psicologo", "imagem": "images/Psicologo.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Olá, Larissa",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage("images/medico.jpg"),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Text(
              "Qual especialidade você procura?",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: _especialidades.length,
            itemBuilder: (context, index) {
              final especialidade = _especialidades[index];
              return Card(
                color: Color.fromARGB(255, 201, 200, 207),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      especialidade["imagem"],
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    ),
                    SizedBox(height: 5),
                    Text(
                      especialidade["nome"],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
