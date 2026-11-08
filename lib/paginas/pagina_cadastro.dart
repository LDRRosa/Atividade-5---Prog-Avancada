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

const _tamanhoMaximoNome = 50;
const _precoMaximo = 100000.0;

final _temLetra = RegExp(r'[A-Za-zÀ-ÿ]');

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

  String? _validarNome(String? texto) {
    final nome = (texto ?? '').trim();
    if (nome.isEmpty) return 'Informe o nome do produto';
    if (nome.length < 3) return 'O nome deve ter pelo menos 3 caracteres';
    if (nome.length > _tamanhoMaximoNome) {
      return 'O nome deve ter no máximo $_tamanhoMaximoNome caracteres';
    }
    if (!_temLetra.hasMatch(nome)) return 'O nome deve conter letras';
    return null;
  }

  String? _validarPreco(String? texto) {
    if ((texto ?? '').trim().isEmpty) return 'Informe o preço';
    final preco = converterPreco(texto!);
    if (preco == null) return 'Informe um preço válido (ex.: 49,90)';
    if (preco <= 0) return 'O preço deve ser maior que zero';
    if (preco > _precoMaximo) {
      return 'O preço deve ser no máximo ${formatarPreco(_precoMaximo)}';
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
              maxLength: _tamanhoMaximoNome,
              validator: _validarNome,
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
