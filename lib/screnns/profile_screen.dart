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
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _phoneController;
  File? _image; // Adicione esta linha para armazenar a imagem selecionada

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _phoneController = TextEditingController();

    _initializeControllerValues();
  }

  Future<void> _initializeControllerValues() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.reload();
      await user.getIdToken();

      if (user.displayName != null && user.displayName!.isNotEmpty) {
        setState(() {
          _nameController.text = user.displayName ?? '';
        });
      } else {
        final userData =
            await _firestore.collection('medico').doc(user.uid).get();
        final nome = userData.get('nome') as String?;
        if (nome != null && nome.isNotEmpty) {
          setState(() {
            _nameController.text = nome;
          });
        } else {
          setState(() {
            _nameController.text = '';
          });
        }
      }

      setState(() {
        _emailController.text = user.email ?? '';
        _phoneController.text = user.phoneNumber ?? '';
      });
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
      await user.updateProfile(displayName: _nameController.text);
      await user.updateEmail(_emailController.text);
      if (_passwordController.text.isNotEmpty) {
        await user.updatePassword(_passwordController.text);
      }
      await _firestore.collection('medico').doc(user.uid).set({
        'nome': _nameController.text,
        'email': _emailController.text,
        'telefone': _phoneController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Perfil atualizado com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        backgroundColor: const Color.fromARGB(255, 29, 6, 229),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await _updateProfile();
              }
            },
          ),
        ],
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
                  radius: 60,
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
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira seu email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Telefone'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: ProfileScreen()));
