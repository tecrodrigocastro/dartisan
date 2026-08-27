import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../core/session/app_session.dart';
import '../../core/session/session_state.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/validation/package_name.dart';
import 'status_pill.dart';

/// Barra de navegação comum às páginas. Reage à sessão e ao tema manualmente
/// via `ValueListenableBuilder` sobre `inject<T>()` — não via `context.watch`,
/// ver decisão #3 do plano de arquitetura original.
class AppTopBar extends StatefulWidget implements PreferredSizeWidget {
  const AppTopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<AppTopBar> createState() => _AppTopBarState();
}

class _AppTopBarState extends State<AppTopBar> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _submitSearch() {
    final name = validatePackageName(_searchController.text, (_) {});
    if (name != null) {
      context.navigate('/packages/$name');
      _searchController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = inject<AppSession>();
    final theme = inject<ThemeController>();
    final onHome = context.routeState().uri.path == '/';

    return AppBar(
      titleSpacing: 16,
      title: Row(
        children: [
          TextButton.icon(
            onPressed: () => context.navigate('/'),
            icon: Image.asset('assets/logo.png', height: 22, fit: BoxFit.contain),
            label: const Text(
              'Dartisan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(width: 8),
          const StatusPill(label: 'self-hosted', variant: StatusPillVariant.selfHosted),
          if (!onHome) ...[
            const SizedBox(width: 24),
            SizedBox(
              width: 320,
              height: 40,
              child: TextField(
                controller: _searchController,
                onSubmitted: (_) => _submitSearch(),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Buscar pacote…',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.arrow_forward, size: 18),
                    onPressed: _submitSearch,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
      actions: [
        ValueListenableBuilder<ThemeMode>(
          valueListenable: theme,
          builder: (context, mode, _) => IconButton(
            tooltip: 'Alternar tema',
            icon: Icon(mode == ThemeMode.dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
            onPressed: theme.toggle,
          ),
        ),
        ValueListenableBuilder<SessionState>(
          valueListenable: session,
          builder: (context, state, _) {
            return switch (state) {
              SessionAuthenticated(:final username) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () => context.navigate('/profile'),
                    child: Text(username),
                  ),
                  IconButton(
                    tooltip: 'Sair',
                    icon: const Icon(Icons.logout),
                    onPressed: () async {
                      await session.logout();
                      if (context.mounted) context.navigate('/');
                    },
                  ),
                ],
              ),
              SessionUnauthenticated() || SessionUnknown() => FilledButton(
                onPressed: () => context.navigate('/login'),
                child: const Text('Login'),
              ),
            };
          },
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
