import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre Nós'),
        backgroundColor: const Color.fromARGB(255, 29, 6, 229),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Container(
                  width: 220.0,
                  height: 220.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(
                        'images/logo.jpeg', // Substitua pelo caminho da imagem do seu logotipo
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'História',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: Text(
                  'O aplicativo nasceu com o propósito de tornar o acesso a cuidados médicos de qualidade mais acessível para pessoas de baixa renda. Acreditamos que a saúde é um direito fundamental e estamos comprometidos em fazer a diferença nas vidas das pessoas.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Missão',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: Text(
                  'Nossa missão é oferecer agendamentos médicos gratuitos, conectando pacientes que precisam de cuidados médicos com médicos que generosamente oferecem atendimento gratuito como parte de sua responsabilidade social. Acreditamos que juntos podemos construir um sistema de saúde mais inclusivo e igualitário.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Valores',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: Text(
                  'Nossos valores fundamentais incluem comprometimento com a comunidade, integridade em todas as nossas ações, empatia em nosso atendimento e a busca constante pela excelência no cuidado ao paciente.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Propósito',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                child: Text(
                  'Nosso propósito é dedicado a tornar a saúde acessível a todos, proporcionando cuidados médicos de qualidade e melhorando a qualidade de vida das pessoas que atendemos. Acreditamos que a saúde é um direito humano fundamental e estamos determinados a fazer a nossa parte para torná-la uma realidade para todos.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              // ... Adicione mais informações sobre sua organização aqui ...
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AboutUsScreen(),
  ));
}
