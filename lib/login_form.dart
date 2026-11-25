import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'globals.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final controllerusername = TextEditingController();
  final controllerpassword = TextEditingController();
  bool enCours = false;

  Future<void> login() async {
    if (controllerusername.text.trim().isEmpty ||
        controllerpassword.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs.')),
      );
      return;
    }

    setState(() => enCours = true);

    try {
      final url = Uri.parse('${baseUrl}login.php');
      final reponse = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': controllerusername.text.trim(),
          'password': controllerpassword.text,
        }),
      );
      final donnees = jsonDecode(reponse.body);

      if (!mounted) return;
      if (reponse.statusCode == 200 && donnees['success'] == true) {
        controllerpassword.clear();
        Navigator.pushNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(donnees['message'] ?? 'Erreur de connexion.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Serveur non disponible.')));
    }

    if (mounted) setState(() => enCours = false);
  }

  @override
  void dispose() {
    controllerusername.dispose();
    controllerpassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 80),
            const Icon(Icons.menu_book, size: 90, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              'Connexion',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: controllerusername,
              decoration: const InputDecoration(
                labelText: 'Nom d’utilisateur',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controllerpassword,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Mot de passe',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: enCours ? null : login,
              child: Text(enCours ? 'Connexion...' : 'Se connecter'),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Text('Créer un compte'),
            ),
          ],
        ),
      ),
    );
  }
}
