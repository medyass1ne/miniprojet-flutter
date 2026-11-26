import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'globals.dart';
import 'modifier_livre.dart';

class ListeLivres extends StatefulWidget {
  const ListeLivres({super.key});

  @override
  State<ListeLivres> createState() => _ListeLivresState();
}

class _ListeLivresState extends State<ListeLivres> {
  List<dynamic> livres = [];
  String recherche = '';
  String filtre = 'Titre';
  String erreur = '';
  bool chargement = true;

  @override
  void initState() {
    super.initState();
    chargerLivres();
  }

  Future<void> chargerLivres() async {
    setState(() {
      chargement = true;
      erreur = '';
    });

    try {
      final url = Uri.parse('${baseUrl}liste.php');
      final reponse = await http.get(url);
      final donnees = jsonDecode(reponse.body);

      if (reponse.statusCode != 200 || donnees is! List) {
        throw Exception('Impossible de charger les livres.');
      }

      if (!mounted) return;
      setState(() {
        livres = donnees;
        chargement = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        erreur = e.toString().replaceFirst('Exception: ', '');
        chargement = false;
      });
    }
  }

  Future<void> ajouterLivre() async {
    final resultat = await Navigator.pushNamed(context, '/formulaire');
    if (resultat == true && mounted) {
      chargerLivres();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Livre ajouté.')));
    }
  }

  void modifierLivre(Map<String, dynamic> livre) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier un livre'),
        content: ModifierLivre(livre: livre, onLivreModifie: chargerLivres),
      ),
    );
  }

  Future<void> supprimerLivre(Map<String, dynamic> livre) async {
    final confirmation = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Suppression'),
        content: Text('Supprimer « ${livre['titre']} » ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmation != true || !mounted) return;

    try {
      final url = Uri.parse('${baseUrl}supprimer.php');
      final reponse = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': '${livre['id']}'}),
      );
      final donnees = jsonDecode(reponse.body);

      if (reponse.statusCode != 200 || donnees['success'] != true) {
        throw Exception(donnees['message'] ?? 'Erreur de suppression.');
      }

      if (!mounted) return;
      chargerLivres();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Livre supprimé.')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final livresAffiches = livres.where((livre) {
      final texte = '${livre['titre']} ${livre['auteur']}'.toLowerCase();
      return texte.contains(recherche.toLowerCase());
    }).toList();

    if (filtre == 'Titre') {
      livresAffiches.sort((a, b) => '${a['titre']}'.compareTo('${b['titre']}'));
    } else if (filtre == 'Auteur') {
      livresAffiches.sort(
        (a, b) => '${a['auteur']}'.compareTo('${b['auteur']}'),
      );
    } else if (filtre == 'Année récente') {
      livresAffiches.sort((a, b) => '${b['annee']}'.compareTo('${a['annee']}'));
    } else {
      livresAffiches.sort((a, b) => '${a['annee']}'.compareTo('${b['annee']}'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Maktabti'),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Déconnexion',
          ),
          IconButton(
            onPressed: chargerLivres,
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Rechercher un livre',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (texte) => setState(() => recherche = texte),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 175,
                  child: DropdownButtonFormField<String>(
                    initialValue: filtre,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Trier par',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Titre',
                        child: Text(
                          'Titre',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Auteur',
                        child: Text(
                          'Auteur',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Année récente',
                        child: Text(
                          'Année récente',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Année ancienne',
                        child: Text(
                          'Année ancienne',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    onChanged: (valeur) {
                      if (valeur != null) setState(() => filtre = valeur);
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: chargement
                ? const Center(child: CircularProgressIndicator())
                : erreur.isNotEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(erreur, textAlign: TextAlign.center),
                        ),
                        ElevatedButton(
                          onPressed: chargerLivres,
                          child: const Text('Réessayer'),
                        ),
                      ],
                    ),
                  )
                : livresAffiches.isEmpty
                ? Center(
                    child: Text(
                      recherche.isEmpty
                          ? 'Aucun livre. Ajoutez votre premier livre.'
                          : 'Aucun résultat.',
                    ),
                  )
                : ListView.builder(
                    itemCount: livresAffiches.length,
                    itemBuilder: (context, index) {
                      final livre =
                          livresAffiches[index] as Map<String, dynamic>;
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.book),
                          title: Text('${livre['titre']}'),
                          subtitle: Text('${livre['auteur']} - ${livre['annee']}'),
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/details',
                            arguments: livre,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => modifierLivre(livre),
                                icon: const Icon(Icons.edit),
                                tooltip: 'Modifier',
                              ),
                              IconButton(
                                onPressed: () => supprimerLivre(livre),
                                icon: const Icon(Icons.delete),
                                tooltip: 'Supprimer',
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ajouterLivre,
        child: const Icon(Icons.add),
      ),
    );
  }
}
