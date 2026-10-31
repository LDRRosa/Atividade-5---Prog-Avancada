import 'package:flutter/material.dart';

import '../modelos/produto.dart';
import '../util/preco.dart';

class CardProduto extends StatelessWidget {
  const CardProduto({
    super.key,
    required this.produto,
    required this.aoComprar,
  });

  final Produto produto;
  final VoidCallback aoComprar;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final categoria = produto.categoria;

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: aoComprar,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: categoria.cor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(categoria.icone, color: categoria.cor, size: 30),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      produto.nome,
                      style: tema.textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(categoria.rotulo, style: tema.textTheme.bodySmall),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              formatarPreco(produto.preco),
                              style: tema.textTheme.titleMedium?.copyWith(
                                color: tema.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilledButton.icon(
                          onPressed: aoComprar,
                          icon: const Icon(Icons.shopping_cart_outlined),
                          label: const Text('Comprar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
