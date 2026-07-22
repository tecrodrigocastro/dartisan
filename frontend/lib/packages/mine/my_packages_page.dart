import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../shared/widgets/app_top_bar.dart';
import '../data/package_models.dart';
import 'my_packages_controller.dart';
import 'my_packages_state.dart';

class MyPackagesPage extends StatefulWidget {
  const MyPackagesPage({super.key});

  @override
  State<MyPackagesPage> createState() => _MyPackagesPageState();
}

class _MyPackagesPageState extends State<MyPackagesPage> {
  late final MyPackagesController _controller;

  @override
  void initState() {
    super.initState();
    _controller = context.read<MyPackagesController>();
    _controller.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(),
      body: ValueListenableBuilder<MyPackagesState>(
        valueListenable: _controller,
        builder: (context, state, _) {
          return switch (state) {
            MyPackagesLoading() => const Center(child: CircularProgressIndicator()),
            MyPackagesFailure(:final message) => Center(child: Text(message)),
            MyPackagesLoaded(:final packages) => ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text('Meus pacotes', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                if (packages.isEmpty)
                  const Text(
                    'Você ainda não publicou nenhum pacote. '
                    'Use "dart pub publish" com um publish token criado no painel de Tokens.',
                  ),
                for (final package in packages) _MyPackageTile(package: package),
              ],
            ),
          };
        },
      ),
    );
  }
}

class _MyPackageTile extends StatelessWidget {
  final MyPackage package;
  const _MyPackageTile({required this.package});

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
