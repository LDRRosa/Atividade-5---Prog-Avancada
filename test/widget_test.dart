import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:atividade5_leandro/componentes/card_produto.dart';
import 'package:atividade5_leandro/main.dart';
import 'package:atividade5_leandro/modelos/categoria.dart';
import 'package:atividade5_leandro/modelos/produto.dart';
import 'package:atividade5_leandro/util/preco.dart';

Future<void> abrirCadastro(WidgetTester tester) async {
  await tester.tap(find.byType(FloatingActionButton));
  await tester.pumpAndSettle();
}

Future<void> preencherProduto(
  WidgetTester tester, {
  required String nome,
  required String preco,
  required Categoria categoria,
}) async {
  await tester.enterText(find.byType(TextFormField).at(0), nome);
  await tester.enterText(find.byType(TextFormField).at(1), preco);
  await tester.tap(find.byType(DropdownButton<Categoria>));
  await tester.pumpAndSettle();
  await tester.tap(find.text(categoria.rotulo).last);
  await tester.pumpAndSettle();
}

void main() {
  group('Catálogo', () {
    testWidgets('mostra cada produto com ícone, preço e botão Comprar', (
      tester,
    ) async {
      await tester.pumpWidget(const CatalogoApp());

      final card = find.ancestor(
        of: find.text('Teclado Mecânico'),
        matching: find.byType(Card),
      );

      Finder dentroDoCard(Finder alvo) =>
          find.descendant(of: card, matching: alvo);

      expect(dentroDoCard(find.byIcon(Icons.computer)), findsOneWidget);
      expect(dentroDoCard(find.text('R\$ 349,90')), findsOneWidget);
      expect(dentroDoCard(find.text('Comprar')), findsOneWidget);
    });

    testWidgets('botão Comprar mostra SnackBar', (tester) async {
      await tester.pumpWidget(const CatalogoApp());

      await tester.tap(find.text('Comprar').first);
      await tester.pump();

      expect(
        find.text('Produto "Teclado Mecânico" adicionado ao carrinho'),
        findsOneWidget,
      );
    });

    testWidgets('clique no produto mostra SnackBar', (tester) async {
      await tester.pumpWidget(const CatalogoApp());

      await tester.tap(find.text('Controle Sem Fio'));
      await tester.pump();

      expect(
        find.text('Produto "Controle Sem Fio" adicionado ao carrinho'),
        findsOneWidget,
      );
    });
  });

  group('Cadastro', () {
    testWidgets('novo produto entra no topo sem substituir os existentes', (
      tester,
    ) async {
      await tester.pumpWidget(const CatalogoApp());

      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();

      await abrirCadastro(tester);
      expect(find.text('Cadastrar Produto'), findsOneWidget);

      await preencherProduto(
        tester,
        nome: 'Coleira',
        preco: '49,90',
        categoria: Categoria.pet,
      );
      await tester.tap(find.text('Confirmar cadastro'));
      await tester.pumpAndSettle();

      expect(find.text('Cadastrar Produto'), findsNothing);
      expect(find.text('Coleira'), findsOneWidget);
      expect(find.text('R\$ 49,90'), findsOneWidget);
      expect(find.text('Teclado Mecânico'), findsOneWidget);

      final primeiroCard = tester.widget<CardProduto>(
        find.byType(CardProduto).first,
      );
      expect(primeiroCard.produto.nome, 'Coleira');
      expect(
        find.descendant(
          of: find.byType(CardProduto).first,
          matching: find.byIcon(Icons.pets),
        ),
        findsOneWidget,
      );
    });

    testWidgets('formulário vazio não confirma e aponta os três campos', (
      tester,
    ) async {
      await tester.pumpWidget(const CatalogoApp());
      await abrirCadastro(tester);

      await tester.tap(find.text('Confirmar cadastro'));
      await tester.pump();

      expect(find.text('Cadastrar Produto'), findsOneWidget);
      expect(find.text('Informe o nome do produto'), findsOneWidget);
      expect(find.text('Informe um preço válido (ex.: 49,90)'), findsOneWidget);
      expect(find.text('Escolha uma categoria'), findsOneWidget);
    });

    testWidgets('erro da categoria some ao escolher uma opção', (tester) async {
      await tester.pumpWidget(const CatalogoApp());
      await abrirCadastro(tester);

      await tester.tap(find.text('Confirmar cadastro'));
      await tester.pump();

      await tester.tap(find.byType(DropdownButton<Categoria>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Games').last);
      await tester.pumpAndSettle();

      expect(find.text('Escolha uma categoria'), findsNothing);
    });

    testWidgets('voltar sem confirmar mantém o catálogo', (tester) async {
      await tester.pumpWidget(const CatalogoApp());
      await abrirCadastro(tester);

      await tester.pageBack();
      await tester.pumpAndSettle();

      expect(find.byType(CardProduto), findsWidgets);
      expect(find.text('Teclado Mecânico'), findsOneWidget);
    });
  });

  testWidgets('card não estoura em tela estreita', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CardProduto(
            produto: const Produto(
              'Produto com um nome bastante longo para testar o limite do card',
              999999999.99,
              Categoria.ferramentas,
            ),
            aoComprar: () {},
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  group('Preço', () {
    test('formata no padrão brasileiro', () {
      expect(formatarPreco(5), 'R\$ 5,00');
      expect(formatarPreco(32.5), 'R\$ 32,50');
      expect(formatarPreco(999.9), 'R\$ 999,90');
      expect(formatarPreco(1999.9), 'R\$ 1.999,90');
      expect(formatarPreco(1234567.89), 'R\$ 1.234.567,89');
    });

    test('aceita vírgula ou ponto como separador decimal', () {
      expect(converterPreco('49,90'), 49.90);
      expect(converterPreco('49.9'), 49.9);
      expect(converterPreco(' 120 '), 120);
    });

    test('rejeita textos que não são preço', () {
      for (final texto in [
        '',
        'abc',
        '-5',
        '1.999,90',
        '1.999',
        'NaN',
        '1e5',
      ]) {
        expect(converterPreco(texto), isNull, reason: texto);
      }
      expect(converterPreco('9999999999'), isNull);
    });
  });
}
