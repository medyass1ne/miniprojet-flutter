import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'globals.dart';

class ModifierLivre extends StatefulWidget {
  final Map<String, dynamic> livre;
  final VoidCallback onLivreModifie;

  const ModifierLivre({
    super.key,
    required this.livre,
    required this.onLivreModifie,
  });

  @override
  State<ModifierLivre> createState() => _ModifierLivreState();
}

class _ModifierLivreState extends State<ModifierLivre> {
  final formKey = GlobalKey<FormState>();
  final titreController = TextEditingController();
  final auteurController = TextEditingController();
  final anneeController = TextEditingController();
  bool enCours = false;

  @override
  void initState() {
    super.initState();
    titreController.text = '${widget.livre['titre']}';
    auteurController.text = '${widget.livre['auteur']}';
    anneeController.text = '${widget.livre['annee']}';
  }

  Future<void> modifierLivre() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => enCours = true);

    try {
      final url = Uri.parse('${baseUrl}modifier.php');
      final reponse = await http.post(
        url,
        body: {
          'id': '${widget.livre['id']}',
          'titre': titreController.text.trim(),
          'auteur': auteurController.text.trim(),
          'annee': anneeController.text.trim(),
        },
      );
      final donnees = jsonDecode(reponse.body);

      if (reponse.statusCode != 200 || donnees['success'] != true) {
        throw Exception(donnees['message'] ?? 'Erreur de modification.');
      }

      if (!mounted) return;
      final messager = ScaffoldMessenger.of(context);
      widget.onLivreModifie();
      Navigator.pop(context);
      messager.showSnackBar(const SnackBar(content: Text('Livre modifié.')));
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
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: titreController,
              decoration: const InputDecoration(labelText: 'Titre'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Veuillez saisir un titre.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: auteurController,
              decoration: const InputDecoration(labelText: 'Auteur'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Veuillez saisir un auteur.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: anneeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Année'),
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
              onPressed: enCours ? null : modifierLivre,
              child: Text(enCours ? 'Enregistrement...' : 'Modifier'),
            ),
          ],
        ),
      ),
    );
  }
}
