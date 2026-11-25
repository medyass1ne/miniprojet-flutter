import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'globals.dart';

class FormulaireLivre extends StatefulWidget {
  const FormulaireLivre({super.key});

  @override
  State<FormulaireLivre> createState() => _FormulaireLivreState();
}

class _FormulaireLivreState extends State<FormulaireLivre> {
  final formKey = GlobalKey<FormState>();
  final titreController = TextEditingController();
  final auteurController = TextEditingController();
  final anneeController = TextEditingController();
  bool enCours = false;

  Future<void> ajouterLivre() async {
    if (!formKey.currentState!.validate()) return;

    final confirmation = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Ajouter ce livre ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );

    if (confirmation != true || !mounted) return;
    setState(() => enCours = true);

    try {
      final url = Uri.parse('${baseUrl}ajouter.php');
      final reponse = await http.post(
        url,
        body: {
          'titre': titreController.text.trim(),
          'auteur': auteurController.text.trim(),
          'annee': anneeController.text.trim(),
        },
      );
      final donnees = jsonDecode(reponse.body);

      if (reponse.statusCode != 200 || donnees['success'] != true) {
        throw Exception(donnees['message'] ?? 'Erreur lors de l’ajout.');
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
      setState(() => enCours = false);
    }
  }

  @override
  void dispose() {
    titreController.dispose();
    auteurController.dispose();
    anneeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un livre'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: titreController,
                decoration: const InputDecoration(
                  labelText: 'Titre',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Veuillez saisir un titre.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: auteurController,
                decoration: const InputDecoration(
                  labelText: 'Auteur',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Veuillez saisir un auteur.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: anneeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Année de publication',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final annee = int.tryParse(value?.trim() ?? '');
                  if (annee == null || annee < 1000 || annee > 2100) {
                    return 'Saisissez une année entre 1000 et 2100.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: enCours ? null : ajouterLivre,
                child: Text(enCours ? 'Enregistrement...' : 'Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
