import 'package:project_tcc_agend/screnns/login_screen.dart';
import 'package:project_tcc_agend/screnns/signupmed_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 29, 6, 229),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(5),
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(10),
              child: Image.asset("images/doutor.jpeg"),
            ),
            SizedBox(height: 25),
            Text(
              "AMS",
              style: TextStyle(
                color: Color.fromARGB(255, 29, 6, 229),
                fontSize: 35,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                wordSpacing: 2,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Atendimento Médico Social",
              style: TextStyle(
                color: Color.fromARGB(253, 0, 0, 0),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 27),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  color: Color.fromARGB(255, 29, 6, 229),
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ));
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 57),
                      child: Text(
                        "Acessar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Material(
                  color: Color.fromARGB(255, 29, 6, 229),
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpMedScreen(),
                          ));
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                      child: Text(
                        "Cadastre-se",
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
            )
          ],
        ),
      ),
    );
  }
}
