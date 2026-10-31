import 'package:flutter/material.dart';

import '../componentes/card_produto.dart';
import '../modelos/categoria.dart';
import '../modelos/produto.dart';
import 'pagina_cadastro.dart';

class PaginaCatalogo extends StatefulWidget {
  const PaginaCatalogo({super.key});

  @override
  State<PaginaCatalogo> createState() => _PaginaCatalogoState();
}

class _PaginaCatalogoState extends State<PaginaCatalogo> {
  final _rolagem = ScrollController();

  final List<Produto> _produtos = [
    const Produto('Teclado Mecânico', 349.90, Categoria.informatica),
    const Produto('Controle Sem Fio', 279.90, Categoria.games),
    const Produto('Caderno Universitário', 32.50, Categoria.papelaria),
    const Produto('Hidratante Facial', 45.90, Categoria.beleza),
    const Produto('Ração Premium 3 kg', 89.90, Categoria.pet),
    const Produto('Furadeira de Impacto', 219.00, Categoria.ferramentas),
  ];

  @override
  void dispose() {
    _rolagem.dispose();
    super.dispose();
  }

  void _adicionarAoCarrinho(Produto produto) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Produto "${produto.nome}" adicionado ao carrinho'),
        ),
      );
  }

  Future<void> _cadastrarProduto() async {
    // Sem <Produto> no pushNamed: as rotas de `routes` são MaterialPageRoute
    // <dynamic> e o cast interno do Navigator falharia com o tipo informado.
    final resultado = await Navigator.pushNamed(context, PaginaCadastro.rota);
    if (resultado is! Produto) return;

    setState(() => _produtos.insert(0, resultado));
    if (_rolagem.hasClients) _rolagem.jumpTo(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo de Produtos')),
      body: ListView.builder(
        controller: _rolagem,
        // Folga inferior para o FAB não cobrir o último botão Comprar.
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
        itemCount: _produtos.length,
        itemBuilder: (context, indice) {
          final produto = _produtos[indice];
          return CardProduto(
            produto: produto,
            aoComprar: () => _adicionarAoCarrinho(produto),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _cadastrarProduto,
        icon: const Icon(Icons.add),
        label: const Text('Novo produto'),
      ),
    );
  }
}
