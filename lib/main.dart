import 'package:flutter/material.dart';

import 'paginas/pagina_cadastro.dart';
import 'paginas/pagina_catalogo.dart';

void main() {
  runApp(const CatalogoApp());
}

class CatalogoApp extends StatelessWidget {
  const CatalogoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo de Produtos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
      ),
      routes: {
        '/': (_) => const PaginaCatalogo(),
        PaginaCadastro.rota: (_) => const PaginaCadastro(),
      },
    );
  }
}
