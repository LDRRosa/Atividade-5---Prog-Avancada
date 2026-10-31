import 'package:flutter/material.dart';

import '../modelos/categoria.dart';
import '../modelos/produto.dart';
import '../util/preco.dart';

class PaginaCadastro extends StatefulWidget {
  const PaginaCadastro({super.key});

  static const rota = '/cadastro';

  @override
  State<PaginaCadastro> createState() => _PaginaCadastroState();
}

class _PaginaCadastroState extends State<PaginaCadastro> {
  final _formulario = GlobalKey<FormState>();

  late String _nome;
  late double _preco;
  late Categoria _categoria;

  void _confirmar() {
    final formulario = _formulario.currentState!;
    if (!formulario.validate()) return;

    formulario.save();
    Navigator.pop(context, Produto(_nome, _preco, _categoria));
  }

  String? _validarPreco(String? texto) {
    final preco = converterPreco(texto ?? '');
    if (preco == null || preco <= 0) {
      return 'Informe um preço válido (ex.: 49,90)';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Produto')),
      body: Form(
        key: _formulario,
        autovalidateMode: AutovalidateMode.onUserInteractionIfError,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Nome do produto',
                filled: true,
              ),
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              validator: (texto) => (texto ?? '').trim().isEmpty
                  ? 'Informe o nome do produto'
                  : null,
              onSaved: (texto) => _nome = texto!.trim(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Preço (R\$)',
                filled: true,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: _validarPreco,
              onSaved: (texto) => _preco = converterPreco(texto!)!,
            ),
            const SizedBox(height: 16),
            FormField<Categoria>(
              validator: (valor) =>
                  valor == null ? 'Escolha uma categoria' : null,
              onSaved: (valor) => _categoria = valor!,
              builder: (campo) => InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Categoria',
                  filled: true,
                  errorText: campo.errorText,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Categoria>(
                    value: campo.value,
                    hint: const Text('Selecione'),
                    isDense: true,
                    isExpanded: true,
                    items: [
                      for (final categoria in Categoria.values)
                        DropdownMenuItem(
                          value: categoria,
                          child: Row(
                            children: [
                              Icon(categoria.icone, color: categoria.cor),
                              const SizedBox(width: 12),
                              Text(categoria.rotulo),
                            ],
                          ),
                        ),
                    ],
                    onChanged: campo.didChange,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _confirmar,
              icon: const Icon(Icons.check),
              label: const Text('Confirmar cadastro'),
            ),
          ],
        ),
      ),
    );
  }
}
