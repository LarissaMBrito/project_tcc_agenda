import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_tcc_agend/screnns/schedule_screen.dart';

class HomeScreenPatient extends StatefulWidget {
  @override
  _HomeScreenPatientState createState() => _HomeScreenPatientState();
}

class _HomeScreenPatientState extends State<HomeScreenPatient> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> especialidades = [];
  List<Map<String, dynamic>> filteredEspecialidades = [];
  String userName = '';
  String userProfileImageUrl = '';
  String _perfilImageUrl = 'images/iconpadrão.jpg'; // Imagem padrão.

  @override
  void initState() {
    super.initState();
    _loadEspecialidades();
    _loadUserName();
  }

  void _loadEspecialidades() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('especialidades').get();
    if (snapshot.docs.isNotEmpty) {
      especialidades = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final nomeEspecialidade = data["nome"];
        final imageUrl = data["imageUrl"] as String?;
        return {
          "nome": nomeEspecialidade,
          "imagem": imageUrl ?? "",
        };
      }).toList();
      setState(() {
        filteredEspecialidades = especialidades;
      });
    }
  }

  void _loadUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('paciente')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        final nomeUsuario = data["nome"];
        final perfilImageUrl = data["perfilImageUrl"];
        setState(() {
          userName = nomeUsuario;
          userProfileImageUrl = perfilImageUrl ??
              _perfilImageUrl; // Use a URL da imagem de perfil se estiver disponível; caso contrário, use a imagem padrão.
        });
      } else {
        // Se o documento do usuário não existir, use a imagem padrão.
        setState(() {
          userProfileImageUrl = _perfilImageUrl;
        });
      }
    }
  }

  void searchEspecialidades(String query) {
    final lowerCaseQuery = query.toLowerCase();
    setState(() {
      filteredEspecialidades = especialidades.where((especialidade) {
        final nomeEspecialidade = especialidade["nome"].toLowerCase();
        return nomeEspecialidade.contains(lowerCaseQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bem - Vindo"),
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 29, 6, 229),
      ),
      body: SingleChildScrollView(
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
                    "Olá, $userName",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors
                        .transparent, //  Define o fundo como transparente.
                    // ignore: unnecessary_null_comparison
                    backgroundImage: userProfileImageUrl != null &&
                            userProfileImageUrl.isNotEmpty
                        ? NetworkImage(
                            userProfileImageUrl) // Use a URL da imagem de perfil se estiver disponível.
                        : AssetImage("images/iconpadrao.jpg")
                            as ImageProvider, // Use uma imagem padrão se o campo não estiver definido.
                  )
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Pesquisar',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (text) {
                  searchEspecialidades(text);
                },
              ),
            ),
            SizedBox(height: 20),
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: filteredEspecialidades.length,
              itemBuilder: (context, index) {
                final especialidade = filteredEspecialidades[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScheduleScreen(
                          especialidade: especialidade["nome"],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    color: Color.fromARGB(255, 201, 200, 207),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
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
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
