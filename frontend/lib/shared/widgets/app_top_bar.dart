import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../core/session/app_session.dart';
import '../../core/session/session_state.dart';

/// Barra de navegação comum às páginas. Reage à sessão manualmente via
/// `ValueListenableBuilder` sobre `inject<AppSession>()` — não via
/// `context.watch`, ver decisão #3 do plano de arquitetura.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final session = inject<AppSession>();

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Colors.white,
      title: TextButton(
        onPressed: () => context.navigate('/'),
        child: const Text(
          'Dartisan',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      actions: [
        ValueListenableBuilder<SessionState>(
          valueListenable: session,
          builder: (context, state, _) {
            return switch (state) {
              SessionAuthenticated(:final username, :final roles) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () => context.navigate('/my-packages'),
                    child: const Text('Meus pacotes', style: TextStyle(color: Colors.white)),
                  ),
                  if (roles.contains('publisher') || roles.contains('admin'))
                    TextButton(
                      onPressed: () => context.navigate('/tokens'),
                      child: const Text('Tokens', style: TextStyle(color: Colors.white)),
                    ),
                  const SizedBox(width: 8),
                  Text(username, style: const TextStyle(color: Colors.white70)),
                  IconButton(
                    tooltip: 'Sair',
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: () async {
                      await session.logout();
                      if (context.mounted) context.navigate('/');
                    },
                  ),
                ],
              ),
              SessionUnauthenticated() || SessionUnknown() => TextButton(
                onPressed: () => context.navigate('/login'),
                child: const Text('Login', style: TextStyle(color: Colors.white)),
              ),
            };
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
