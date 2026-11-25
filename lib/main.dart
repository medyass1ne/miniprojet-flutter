import 'package:flutter/material.dart';

import 'details_livre.dart';
import 'formulaire_livre.dart';
import 'liste_livres.dart';
import 'login_form.dart';
import 'register_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maktabti',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginForm(),
        '/register': (context) => const RegisterForm(),
        '/home': (context) => const ListeLivres(),
        '/formulaire': (context) => const FormulaireLivre(),
        '/details': (context) => const DetailsLivre(),
      },
    );
  }
}
