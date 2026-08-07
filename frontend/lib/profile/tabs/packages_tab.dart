import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../core/theme/app_theme.dart';
import '../../packages/data/package_models.dart';
import '../../packages/mine/my_packages_controller.dart';
import '../../packages/mine/my_packages_state.dart';

class PackagesTab extends StatefulWidget {
  const PackagesTab({super.key});

  @override
  State<PackagesTab> createState() => _PackagesTabState();
}

class _PackagesTabState extends State<PackagesTab> {
  late final MyPackagesController _controller;

  @override
  void initState() {
    super.initState();
    _controller = context.read<MyPackagesController>();
    _controller.load();
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
            padding: const EdgeInsets.all(24),
            children: [
              if (packages.isEmpty)
                Text(
                  'Você ainda não publicou nenhum pacote. '
                  'Use "dart pub publish" com um publish token criado na aba Tokens.',
                  style: TextStyle(color: AppTheme.textMuted),
                ),
              for (final package in packages) _PackageTile(package: package),
            ],
          ),
        };
      },
    );
  }
}

class _PackageTile extends StatelessWidget {
  final PackageSummary package;
  const _PackageTile({required this.package});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.inventory_2_outlined),
        title: Text(package.name),
        subtitle: Text(
          'última versão ${package.latestVersion} · publicado em ${package.createdAt}',
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.navigate('/packages/${package.name}'),
      ),
    );
  }
}
