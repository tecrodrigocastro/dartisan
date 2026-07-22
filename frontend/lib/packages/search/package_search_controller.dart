import 'package:flutter/foundation.dart';

import 'package_search_state.dart';

final _validPackageName = RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$');

class PackageSearchController extends ValueNotifier<PackageSearchState> {
  PackageSearchController() : super(const PackageSearchIdle());

  /// Retorna o nome normalizado se válido (pra navegação), ou `null` e
  /// transiciona pra [PackageSearchInvalid] com a mensagem de erro.
  String? validate(String rawInput) {
    final name = rawInput.trim();
    if (name.isEmpty) {
      value = const PackageSearchInvalid('Digite o nome de um pacote');
      return null;
    }
    if (!_validPackageName.hasMatch(name)) {
      value = const PackageSearchInvalid(
        'Nome inválido — use apenas letras, números e underscore',
      );
      return null;
    }
    value = const PackageSearchIdle();
    return name;
  }
}
