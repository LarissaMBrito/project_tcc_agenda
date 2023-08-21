import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  File? _image;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();

    _phoneController = TextEditingController();

    _initializeControllerValues();
  }

  Future<void> _initializeControllerValues() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.reload();
      await user.getIdToken();

      final pacienteData =
          await _firestore.collection('paciente').doc(user.uid).get();

      final userData =
          await _firestore.collection('medico').doc(user.uid).get();

      if (pacienteData.exists) {
        setState(() {
          _nameController =
              TextEditingController(text: pacienteData.get('nome') ?? '');
          _phoneController =
              TextEditingController(text: pacienteData.get('telefone') ?? '');
        });
      } else if (userData.exists) {
        setState(() {
          _nameController =
              TextEditingController(text: userData.get('nome') ?? '');
          _phoneController =
              TextEditingController(text: userData.get('telefone') ?? '');
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      // Verificar se o usuário é médico ou paciente
      final pacienteData =
          await _firestore.collection('paciente').doc(user.uid).get();
      final userData =
          await _firestore.collection('medico').doc(user.uid).get();

      if (pacienteData.exists) {
        await _updatePacienteProfile(user, pacienteData);
      } else if (userData.exists) {
        await _updateMedicoProfile(user, userData);
      }
    }
  }

  Future<void> _updatePacienteProfile(
      User user, DocumentSnapshot pacienteData) async {
    // Atualizar os campos específicos do perfil de paciente
    final Map<String, dynamic> updatedFields = {};

    if (pacienteData.get('nome') != _nameController.text) {
      updatedFields['nome'] = _nameController.text;
    }
    if (pacienteData.get('telefone') != _phoneController.text) {
      updatedFields['telefone'] = _phoneController.text;
    }

    if (updatedFields.isNotEmpty) {
      await _firestore
          .collection('paciente')
          .doc(user.uid)
          .update(updatedFields);
    }

    // Salvar a imagem no Firebase Storage (se necessário)
    if (_image != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('perfil_images')
          .child('${user.uid}.jpg');
      final uploadTask = storageRef.putFile(_image!);
      await uploadTask.whenComplete(() {});

      final downloadUrl = await storageRef.getDownloadURL();
      await _firestore.collection('paciente').doc(user.uid).update({
        'perfilImageUrl': downloadUrl,
      });
    }

    // Exibir o diálogo de sucesso
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sucesso!'),
          content: Text('O perfil foi atualizado com sucesso.'),
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

  Future<void> _updateMedicoProfile(
      User user, DocumentSnapshot userData) async {
    // Atualizar os campos específicos do perfil de médico
    final Map<String, dynamic> updatedFields = {};

    if (userData.get('nome') != _nameController.text) {
      updatedFields['nome'] = _nameController.text;
    }
    if (userData.get('telefone') != _phoneController.text) {
      updatedFields['telefone'] = _phoneController.text;
    }

    if (updatedFields.isNotEmpty) {
      await _firestore.collection('medico').doc(user.uid).update(updatedFields);
    }

    // Salvar a imagem no Firebase Storage (se necessário)
    if (_image != null) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('perfil_images')
          .child('${user.uid}.jpg');
      final uploadTask = storageRef.putFile(_image!);
      await uploadTask.whenComplete(() {});

      final downloadUrl = await storageRef.getDownloadURL();
      await _firestore.collection('medico').doc(user.uid).update({
        'perfilImageUrl': downloadUrl,
      });
    }

    // Exibir o diálogo de sucesso
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sucesso!'),
          content: Text('O perfil foi atualizado com sucesso.'),
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
        title: Text('Perfil'),
        backgroundColor: const Color.fromARGB(255, 29, 6, 229),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: () {
                  _pickImage();
                },
                child: CircleAvatar(
                  radius: 130,
                  backgroundColor: Colors.grey[300], // Cor de fundo padrão
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null
                      ? Icon(
                          Icons.camera_alt,
                          size: 60,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira seu nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Telefone'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            await _updateProfile();
          }
        },
        child: Icon(Icons.save),
        backgroundColor: Color.fromARGB(255, 29, 6, 229),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
