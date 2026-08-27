import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../core/session/app_session.dart';
import '../../core/session/session_state.dart';
import '../../core/theme/tokens.dart';
import '../../packages/mine/my_packages_controller.dart';
import '../../packages/mine/my_packages_state.dart';
import '../../shared/widgets/package_card.dart';

class PackagesTab extends StatefulWidget {
  const PackagesTab({super.key});

  @override
  State<PackagesTab> createState() => _PackagesTabState();
}

class _PackagesTabState extends State<PackagesTab> {
  late final MyPackagesController _controller;
  late final bool _canPublish;

  @override
  void initState() {
    super.initState();
    _controller = context.read<MyPackagesController>();
    _controller.load();

    final session = inject<AppSession>().value;
    _canPublish = session is SessionAuthenticated &&
        (session.hasRole('publisher') || session.hasRole('admin'));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<MyPackagesState>(
      valueListenable: _controller,
      builder: (context, state, _) {
        return switch (state) {
          MyPackagesLoading() => const Center(child: CircularProgressIndicator()),
          MyPackagesFailure(:final message) => Center(child: Text(message)),
          MyPackagesLoaded(:final packages) => ListView(
            padding: const EdgeInsets.all(DartisanSpacing.s5),
            children: [
              if (_canPublish) ...[
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton.icon(
                    onPressed: () => context.navigate('/publish/github'),
                    icon: const Icon(Icons.hub_outlined, size: 18),
                    label: const Text('Importar do GitHub'),
                  ),
                ),
                const SizedBox(height: DartisanSpacing.s4),
              ],
              if (packages.isEmpty)
                Text(
                  'Você ainda não publicou nenhum pacote. '
                  'Use "dart pub publish" com um publish token criado na aba Tokens.',
                  style: TextStyle(color: context.colors.textFaint),
                )
              else
                Wrap(
                  spacing: DartisanSpacing.s4,
                  runSpacing: DartisanSpacing.s4,
                  children: packages
                      .map(
                        (p) => SizedBox(
                          width: 300,
                          child: PackageCard(
                            package: p,
                            onTap: () => context.navigate('/packages/${p.name}'),
                          ),
                        ),
                      )
                      .toList(),
                ),
            ],
          ),
        };
      },
    );
  }
}
