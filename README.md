# Catálogo de Produtos

Aplicativo Flutter para visualizar um catálogo de produtos e cadastrar novos itens.

## Funcionalidades

- Lista de produtos com `ListView.builder`, exibidos em `Card` com ícone da categoria, nome, preço e botão **Comprar**.
- `SnackBar` avisando que o produto foi adicionado ao carrinho, ao tocar no produto ou no botão **Comprar**.
- Tela **Cadastrar Produto**, aberta pelo `FloatingActionButton`, com nome, preço e categoria (`DropdownButton`).
- Novos produtos entram no topo da lista, sem substituir os existentes.
- Ícone e cor definidos pela categoria escolhida.

## Estrutura

```
lib/
├── main.dart                  # MaterialApp, tema e rotas
├── componentes/card_produto.dart
├── modelos/                   # Produto e enum Categoria
├── paginas/                   # Catálogo e cadastro
└── util/preco.dart            # Formatação e validação do preço
```

## Como executar

```
flutter pub get
flutter run
```

Para rodar os testes: `flutter test`.
