import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'globals.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final controllerusername = TextEditingController();
  final controllerpassword = TextEditingController();
  bool enCours = false;

  Future<void> register() async {
    final nom = controllerusername.text.trim();
    final motDePasse = controllerpassword.text;

    if (!RegExp(r'^[A-Za-z0-9_.-]{3,50}$').hasMatch(nom)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nom d’utilisateur invalide (3 à 50 caractères).'),
        ),
      );
      return;
    }

    if (motDePasse.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Le mot de passe doit avoir au moins 6 caractères.'),
        ),
      );
      return;
    }

    setState(() => enCours = true);

    try {
      final url = Uri.parse('${baseUrl}register.php');
      final reponse = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': nom, 'password': motDePasse}),
      );
      final donnees = jsonDecode(reponse.body);
      if (!mounted) return;
      if (reponse.statusCode == 200 && donnees['success'] == true) {
        final messager = ScaffoldMessenger.of(context);
        Navigator.pop(context);
        messager.showSnackBar(
          const SnackBar(content: Text('Compte créé avec succès.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(donnees['message'] ?? 'Erreur d’inscription.'),
          ),
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
      appBar: AppBar(
        title: const Text('Inscription'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 50),
            const Icon(Icons.person_add, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              'Créer un compte',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
              onPressed: enCours ? null : register,
              child: Text(enCours ? 'Inscription...' : 'S’inscrire'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Déjà un compte ? Se connecter'),
            ),
          ],
        ),
      ),
    );
  }
}
