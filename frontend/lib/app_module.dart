import 'package:flutter_modular/flutter_modular.dart';

import 'auth/auth_module.dart';
import 'core/core_module.dart';
import 'packages/packages_module.dart';
import 'tokens/tokens_module.dart';

/// Módulo raiz — só composição, o mapa de acoplamento do app.
final appModule = createModule(
  register: (c) {
    c
      ..module(coreModule)
      ..module(packagesModule)
      ..module(authModule)
      ..module(tokensModule);
  },
);
