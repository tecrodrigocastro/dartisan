import 'package:flutter_modular/flutter_modular.dart';

import 'login/login_controller.dart';
import 'login/login_page.dart';

final authModule = createModule(
  path: '/login',
  register: (c) {
    c.route(
      '/',
      provide: (s) => s.addChangeNotifier<LoginController>(LoginController.new),
      child: (ctx, state) => const LoginPage(),
    );
  },
);
