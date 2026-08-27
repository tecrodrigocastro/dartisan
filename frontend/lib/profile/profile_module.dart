import 'package:flutter_modular/flutter_modular.dart';

import '../core/session/guards.dart';
import '../packages/liked/liked_packages_controller.dart';
import '../packages/mine/my_packages_controller.dart';
import '../tokens/tokens_controller.dart';
import 'profile_controller.dart';
import 'profile_page.dart';

/// Consolida "meus pacotes" e "tokens" numa página só, com abas — ver
/// decisão do plano de redesign. A aba Tokens só é populada/mostrada se o
/// usuário tiver role publisher/admin (checado dentro de ProfilePage).
final profileModule = createModule(
  path: '/profile',
  register: (c) {
    c.route(
      '/',
      guards: [authGuard],
      provide: (s) => s
        ..addChangeNotifier<ProfileController>(ProfileController.new)
        ..addChangeNotifier<MyPackagesController>(MyPackagesController.new)
        ..addChangeNotifier<LikedPackagesController>(LikedPackagesController.new)
        ..addChangeNotifier<TokensController>(TokensController.new),
      child: (ctx, state) => const ProfilePage(),
    );
  },
);
