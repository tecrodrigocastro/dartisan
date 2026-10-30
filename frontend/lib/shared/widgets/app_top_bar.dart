import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../core/session/app_session.dart';
import '../../core/session/session_state.dart';
import '../../core/theme/theme_controller.dart';
import '../../core/validation/package_name.dart';
import '../../core/theme/tokens.dart';
import 'status_pill.dart';

/// Barra de navegação comum às páginas. Reage à sessão e ao tema manualmente
/// via `ValueListenableBuilder` sobre `inject<T>()` — não via `context.watch`,
/// ver decisão #3 do plano de arquitetura original.
class AppTopBar extends StatefulWidget implements PreferredSizeWidget {
  const AppTopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

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

    final colors = context.colors;
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final path = context.routeState().uri.path;

    return AppBar(
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, thickness: 1, color: Theme.of(context).dividerColor),
      ),
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
          if (wide) ...[
            const SizedBox(width: 8),
            const StatusPill(label: 'self-hosted', variant: StatusPillVariant.selfHosted),
            const SizedBox(width: 16),
            _NavLink(label: 'Pacotes', active: path == '/', onTap: () => context.navigate('/')),
            _NavLink(
              label: 'Publicar',
              active: path.startsWith('/publish'),
              onTap: () => context.navigate('/publish/github'),
            ),
          ],
          if (!onHome && wide) ...[
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
            style: IconButton.styleFrom(
              side: BorderSide(color: colors.borderStrong),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DartisanRadii.m - 2)),
            ),
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

class _NavLink extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavLink({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: active ? Theme.of(context).colorScheme.onSurface : colors.textFaint,
        backgroundColor: active ? Theme.of(context).colorScheme.surface : null,
        textStyle: TextStyle(fontSize: 14, fontWeight: active ? FontWeight.w600 : FontWeight.w500),
      ),
      child: Text(label),
    );
  }
}
