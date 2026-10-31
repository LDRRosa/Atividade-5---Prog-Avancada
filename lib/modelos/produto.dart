import 'categoria.dart';

class Produto {
  const Produto(this.nome, this.preco, this.categoria);

  final String nome;
  final double preco;
  final Categoria categoria;
}
