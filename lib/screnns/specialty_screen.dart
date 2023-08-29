import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:project_tcc_agend/screnns/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class Specialty {
  final String nome;
  final File image;

  Specialty({required this.nome, required this.image});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Especialidade',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SpecialtyScreen(),
    );
  }
}

class SpecialtyScreen extends StatefulWidget {
  @override
  _SpecialtyScreenState createState() => _SpecialtyScreenState();
}

class _SpecialtyScreenState extends State<SpecialtyScreen> {
  final TextEditingController _nomeController = TextEditingController();
  File? _selectedImage;

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _submitForm() async {
    final specialty = Specialty(
      nome: _nomeController.text,
      image: _selectedImage!,
    );

    // Fazer upload da imagem para o Firebase Storage
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('imagens_especialidades/${specialty.nome}.jpg');
    final uploadTask = storageRef.putFile(_selectedImage!);
    final storageSnapshot = await uploadTask.whenComplete(() {});
    final imageUrl = await storageSnapshot.ref.getDownloadURL();

    // Salvar detalhes da especialidade, incluindo URL da imagem, no Firestore do Firebase
    await FirebaseFirestore.instance.collection('especialidades').add({
      'nome': specialty.nome,
      'imageUrl': imageUrl, // Adicionar a URL da imagem no Firestore
    });

    _nomeController.clear();
    setState(() {
      _selectedImage = null;
    });

    _showConfirmationDialog();
  }

  Future<void> _showConfirmationDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Especialidade Adicionada'),
          content: Text('A especialidade foi adicionada com sucesso.'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Especialidade'),
        backgroundColor: Color.fromARGB(255, 29, 6, 229),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nomeController,
                  decoration:
                      InputDecoration(labelText: 'Nome da Especialidade'),
                ),
                SizedBox(height: 16),
                if (_selectedImage != null)
                  Image.file(
                    _selectedImage!,
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                SizedBox(height: 8),
                Row(
                  children: [
                    SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 29, 6, 229),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      onPressed: () => _pickImage(ImageSource.gallery),
                      child: Text('Ver Galeria'),
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: () {
                _submitForm();
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 29, 6, 229),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.save,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: GestureDetector(
              onTap: () {
                // Navegue para a tela de login
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LoginScreen()), // Substitua LoginScreen() pelo nome da sua tela de login
                );
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.red, // Cor de fundo do botão
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.exit_to_app, // Ícone do botão (sair)
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Aqui você deve adicionar a definição da sua tela de login (LoginScreen) ou importá-la


