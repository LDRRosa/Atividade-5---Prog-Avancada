// Limita a 9 dígitos inteiros porque valores muito grandes fariam o
// toStringAsFixed devolver notação científica.
final _precoValido = RegExp(r'^\d{1,9}([.,]\d{1,2})?$');

final _milhares = RegExp(r'\B(?=(\d{3})+$)');

String formatarPreco(double valor) {
  final partes = valor.toStringAsFixed(2).split('.');
  final inteiro = partes[0].replaceAll(_milhares, '.');
  return 'R\$ $inteiro,${partes[1]}';
}

double? converterPreco(String texto) {
  final valor = texto.trim();
  if (!_precoValido.hasMatch(valor)) return null;
  return double.parse(valor.replaceAll(',', '.'));
}
