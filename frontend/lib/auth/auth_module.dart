import 'package:flutter_modular/flutter_modular.dart';

import 'login/github_callback_page.dart';
import 'login/login_controller.dart';
import 'login/login_page.dart';

final authModule = createModule(
  path: '/login',
  register: (c) {
    c
      ..route(
        '/',
        provide: (s) => s.addChangeNotifier<LoginController>(LoginController.new),
        child: (ctx, state) => LoginPage(
          githubError: state.uri.queryParameters['error'] == 'github_oauth_failed',
        ),
      )
      ..route(
        '/github/callback',
        child: (ctx, state) =>
            GithubCallbackPage(code: state.uri.queryParameters['code']),
      );
  },
);
