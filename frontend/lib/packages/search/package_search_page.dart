import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_top_bar.dart';
import '../../shared/widgets/dotted_grid_background.dart';
import '../data/package_models.dart';
import 'package_search_controller.dart';
import 'package_search_state.dart';
import 'recent_packages_controller.dart';
import 'recent_packages_state.dart';

class PackageSearchPage extends StatefulWidget {
  const PackageSearchPage({super.key});

  @override
  State<PackageSearchPage> createState() => _PackageSearchPageState();
}

class _PackageSearchPageState extends State<PackageSearchPage> {
  final _inputController = TextEditingController();
  late final PackageSearchController _searchController;
  late final RecentPackagesController _recentController;

  @override
  void initState() {
    super.initState();
    _searchController = context.read<PackageSearchController>();
    _recentController = context.read<RecentPackagesController>();
    _recentController.load();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _searchController.validate(_inputController.text);
    if (name != null) {
      // navigate (não pushNamed) porque a página de detalhe precisa de uma
      // URL de verdade — compartilhável e sobrevivendo a um refresh — e
      // pushNamed deliberadamente fica fora da URL (ver navigation.md).
      context.navigate('/packages/$name');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(),
      body: ListView(
        children: [
          DottedGridBackground(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Column(
                    children: [
                      Icon(Icons.inventory_2_outlined, size: 48, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(height: 16),
                      Text(
                        'Dartisan',
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'O registro de pacotes self-hosted pra Dart e Flutter.',
                        style: TextStyle(color: AppTheme.textMuted),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      ValueListenableBuilder<PackageSearchState>(
                        valueListenable: _searchController,
                        builder: (context, state, _) {
                          return TextField(
                            controller: _inputController,
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: 'nome_do_pacote',
                              prefixIcon: const Icon(Icons.search),
                              errorText: state is PackageSearchInvalid ? state.message : null,
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.arrow_forward),
                                onPressed: _submit,
                              ),
                            ),
                            onSubmitted: (_) => _submit(),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      ValueListenableBuilder<RecentPackagesState>(
                        valueListenable: _recentController,
                        builder: (context, state, _) {
                          final total = state is RecentPackagesLoaded ? state.list.total : null;
                          return Text(
                            total == null ? '' : '$total pacote${total == 1 ? '' : 's'} publicado${total == 1 ? '' : 's'}',
                            style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Center(
                child: ValueListenableBuilder<RecentPackagesState>(
                  valueListenable: _recentController,
                  builder: (context, state, _) {
                    return switch (state) {
                      RecentPackagesLoading() => const Padding(
                        padding: EdgeInsets.all(32),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      RecentPackagesFailure() => const SizedBox.shrink(),
                      RecentPackagesLoaded(:final list) when list.packages.isEmpty =>
                        const SizedBox.shrink(),
                      RecentPackagesLoaded(:final list) => _RecentPackagesGrid(packages: list.packages),
                    };
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentPackagesGrid extends StatelessWidget {
  final List<PackageSummary> packages;
  const _RecentPackagesGrid({required this.packages});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pacotes recentes', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: packages
              .map((p) => SizedBox(width: 320, child: _PackageCard(package: p)))
              .toList(),
        ),
      ],
    );
  }
}

class _PackageCard extends StatelessWidget {
  final PackageSummary package;
  const _PackageCard({required this.package});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.navigate('/packages/${package.name}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.archive_outlined, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      package.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('v${package.latestVersion}', style: TextStyle(color: AppTheme.textMuted, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}
