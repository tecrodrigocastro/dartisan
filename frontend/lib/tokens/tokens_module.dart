import 'package:flutter_modular/flutter_modular.dart';

import '../core/session/guards.dart';
import 'tokens_controller.dart';
import 'tokens_page.dart';

final tokensModule = createModule(
  path: '/tokens',
  register: (c) {
    c.route(
      '/',
      guards: [authGuard, requireAnyRole(['publisher', 'admin'])],
      provide: (s) => s.addChangeNotifier<TokensController>(TokensController.new),
      child: (ctx, state) => const TokensPage(),
    );
  },
);
