final validPackageNamePattern = RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$');

/// Normaliza (trim) e valida um nome de pacote digitado pelo usuário.
/// Retorna o nome válido, ou `null` — nesse caso [onInvalid] recebe a
/// mensagem de erro apropriada.
String? validatePackageName(String rawInput, void Function(String message) onInvalid) {
  final name = rawInput.trim();
  if (name.isEmpty) {
    onInvalid('Digite o nome de um pacote');
    return null;
  }
  if (!validPackageNamePattern.hasMatch(name)) {
    onInvalid('Nome inválido — use apenas letras, números e underscore');
    return null;
  }
  return name;
}
