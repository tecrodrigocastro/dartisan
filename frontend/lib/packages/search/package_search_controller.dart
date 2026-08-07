import 'package:flutter/foundation.dart';

import '../../core/validation/package_name.dart';
import 'package_search_state.dart';

class PackageSearchController extends ValueNotifier<PackageSearchState> {
  PackageSearchController() : super(const PackageSearchIdle());

  /// Retorna o nome normalizado se válido (pra navegação), ou `null` e
  /// transiciona pra [PackageSearchInvalid] com a mensagem de erro.
  String? validate(String rawInput) {
    final name = validatePackageName(
      rawInput,
      (message) => value = PackageSearchInvalid(message),
    );
    if (name != null) value = const PackageSearchIdle();
    return name;
  }
}
