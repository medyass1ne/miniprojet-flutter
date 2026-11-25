import 'package:flutter/material.dart';

class DetailsLivre extends StatelessWidget {
  const DetailsLivre({super.key});

  @override
  Widget build(BuildContext context) {
    final livre =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du livre'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.menu_book, size: 90, color: Colors.blue),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: const Icon(Icons.book),
                title: const Text('Titre'),
                subtitle: Text('${livre['titre']}'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Auteur'),
                subtitle: Text('${livre['auteur']}'),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Année de publication'),
                subtitle: Text('${livre['annee']}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
