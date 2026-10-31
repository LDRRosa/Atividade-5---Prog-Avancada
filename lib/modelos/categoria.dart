import 'package:flutter/material.dart';

enum Categoria {
  informatica('Informática', Icons.computer, Colors.blue),
  games('Games', Icons.sports_esports, Colors.deepPurple),
  papelaria('Papelaria', Icons.edit_note, Colors.orange),
  beleza('Beleza', Icons.spa, Colors.pink),
  pet('Pet', Icons.pets, Colors.brown),
  ferramentas('Ferramentas', Icons.handyman, Colors.blueGrey);

  const Categoria(this.rotulo, this.icone, this.cor);

  final String rotulo;
  final IconData icone;
  final Color cor;
}
