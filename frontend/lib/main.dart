import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app_module.dart';
import 'core/session/app_session.dart';

void main() {
  usePathUrlStrategy();
  runApp(ModularApp(module: appModule, child: const AppRoot()));
}

/// Espera [AppSession.restore] terminar antes de montar o router — sem isso,
/// um deep-link pra uma rota guardada (`/tokens`) avaliaria o guard contra
/// `SessionUnknown` e redirecionaria pro login mesmo com uma sessão válida
/// persistida (a leitura do storage é assíncrona por natureza).
class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  late final Future<void> _restoring = inject<AppSession>().restore();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _restoring,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }
        return MaterialApp.router(
          title: 'Dartisan',
          theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
          routerConfig: ModularApp.routerConfigOf(context),
        );
      },
    );
  }
}
