# Mes livres

Mini-projet Flutter : enregistrer des livres avec un titre, un auteur et une année de publication.

## Installation

1. Démarrer **Apache** et **MySQL** dans XAMPP.
2. Ouvrir phpMyAdmin et importer [backend/base.sql](backend/base.sql) une seule fois. Cela crée la base `mini_projet_flutter`, les tables `livres` et `users`, et sept livres d'exemple.
3. Copier les fichiers PHP du dossier `backend` dans `C:\xampp\htdocs\projet_flutter`.
4. Vérifier que `http://localhost/projet_flutter/liste.php` affiche les sept livres d'exemple dans le navigateur.
5. Exécuter `flutter run -d chrome` depuis ce dossier.

L'adresse `http://localhost/projet_flutter/` dans [lib/globals.dart](lib/globals.dart) fonctionne pour Chrome sur le même PC que XAMPP. Si le dossier est renommé dans `htdocs`, modifier aussi la fin de cette adresse.

La connexion MySQL dans [backend/config.php](backend/config.php) utilise le port `3307` configuré dans ce XAMPP, avec l'utilisateur `root` et un mot de passe vide. Si ces paramètres changent, modifier ce fichier et le recopier dans `htdocs`.

## Fonctionnement

- Page connexion : se connecter avec un compte enregistré.
- Page inscription : créer un compte avec un nom d'utilisateur et un mot de passe.
- Page liste : voir les livres, rechercher par titre ou auteur, actualiser, modifier ou supprimer.
- Page formulaire : ajouter un livre après validation et confirmation.
- Page détails : voir les informations d'un livre.

La modification se fait dans une fenêtre pop-up depuis la liste.

Les données restent dans MySQL après la fermeture de l'application. Les routes nommées sont `/`, `/register`, `/home`, `/formulaire` et `/details`.
