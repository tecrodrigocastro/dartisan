import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../core/theme/tokens.dart';
import '../../shared/widgets/app_top_bar.dart';
import '../../shared/widgets/dotted_grid_background.dart';
import '../../shared/widgets/package_card.dart';
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
              padding: const EdgeInsets.symmetric(vertical: DartisanSpacing.s8, horizontal: DartisanSpacing.s5),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        padding: const EdgeInsets.all(DartisanSpacing.s2),
                        decoration: BoxDecoration(
                          color: context.colors.accentSoft,
                          borderRadius: BorderRadius.circular(DartisanRadii.m),
                        ),
                        child: Image.asset('assets/logo.png', fit: BoxFit.contain),
                      ),
                      const SizedBox(height: DartisanSpacing.s4),
                      Text(
                        'Dartisan',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: DartisanSpacing.s2),
                      Text(
                        'O registro de pacotes self-hosted pra Dart e Flutter.',
                        style: TextStyle(color: context.colors.textFaint),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: DartisanSpacing.s6),
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
                      const SizedBox(height: DartisanSpacing.s4),
                      ValueListenableBuilder<RecentPackagesState>(
                        valueListenable: _recentController,
                        builder: (context, state, _) {
                          final total = state is RecentPackagesLoaded ? state.list.total : null;
                          return Text(
                            total == null ? '' : '$total pacote${total == 1 ? '' : 's'} publicado${total == 1 ? '' : 's'}',
                            style: TextStyle(color: context.colors.textFaint, fontSize: 13),
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
            padding: const EdgeInsets.fromLTRB(
              DartisanSpacing.s5,
              0,
              DartisanSpacing.s5,
              DartisanSpacing.s7,
            ),
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
                      RecentPackagesLoaded() => _RecentPackagesGrid(
                        state: state,
                        onLoadMore: _recentController.loadMore,
                      ),
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
  final RecentPackagesLoaded state;
  final VoidCallback onLoadMore;

  const _RecentPackagesGrid({required this.state, required this.onLoadMore});

  @override
  Widget build(BuildContext context) {
    final packages = state.list.packages;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Pacotes recentes', style: Theme.of(context).textTheme.titleLarge),
            Text(
              '${packages.length} de ${state.list.total}',
              style: TextStyle(color: context.colors.textFaint, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: DartisanSpacing.s4),
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
        if (state.hasMore) ...[
          const SizedBox(height: DartisanSpacing.s5),
          Center(
            child: OutlinedButton(
              onPressed: state.loadingMore ? null : onLoadMore,
              child: state.loadingMore
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Carregar mais'),
            ),
          ),
        ],
      ],
    );
  }
}
