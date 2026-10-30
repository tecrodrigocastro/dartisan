import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../core/theme/tokens.dart';
import '../../shared/widgets/app_top_bar.dart';
import '../../core/http/api_base_url.dart';
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
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: DartisanSpacing.s7,
                  horizontal: DartisanSpacing.s5,
                ),
                child: LayoutBuilder(
                  builder: (context, box) {
                    final twoCols = box.maxWidth >= 860;
                    final left = _HeroText(
                      inputController: _inputController,
                      searchController: _searchController,
                      recentController: _recentController,
                      onSubmit: _submit,
                    );
                    if (!twoCols) return left;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(flex: 6, child: left),
                        const SizedBox(width: DartisanSpacing.s7),
                        const Expanded(flex: 5, child: _PubspecCard()),
                      ],
                    );
                  },
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
              constraints: const BoxConstraints(maxWidth: 1200),
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
            Text('Pacotes recentes', style: Theme.of(context).textTheme.headlineSmall),
            Text(
              '${packages.length} de ${state.list.total}',
              style: TextStyle(color: context.colors.textFaint, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: DartisanSpacing.s4),
        LayoutBuilder(
          builder: (context, box) {
            const gap = DartisanSpacing.s4;
            final cols = box.maxWidth >= 900 ? 3 : (box.maxWidth >= 600 ? 2 : 1);
            final width = (box.maxWidth - gap * (cols - 1)) / cols;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: packages
                  .map(
                    (p) => SizedBox(
                      width: width,
                      child: PackageCard(
                        package: p,
                        onTap: () => context.navigate('/packages/${p.name}'),
                      ),
                    ),
                  )
                  .toList(),
            );
          },
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

class _HeroText extends StatelessWidget {
  final TextEditingController inputController;
  final PackageSearchController searchController;
  final RecentPackagesController recentController;
  final VoidCallback onSubmit;

  const _HeroText({
    required this.inputController,
    required this.searchController,
    required this.recentController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final primary = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'REGISTRO DE PACOTES · DART E FLUTTER',
          style: DartisanFonts.mono(fontSize: 12, fontWeight: FontWeight.w500, color: colors.brass),
        ),
        const SizedBox(height: DartisanSpacing.s4),
        Text(
          'Seu registro de pacotes Dart, hospedado por você.',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(height: 1.08),
        ),
        const SizedBox(height: DartisanSpacing.s5),
        ValueListenableBuilder<PackageSearchState>(
          valueListenable: searchController,
          builder: (context, state, _) {
            return TextField(
              controller: inputController,
              style: DartisanFonts.mono(fontSize: 15),
              decoration: InputDecoration(
                hintText: 'nome_do_pacote',
                prefixIcon: const Icon(Icons.search),
                errorText: state is PackageSearchInvalid ? state.message : null,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: onSubmit,
                ),
              ),
              onSubmitted: (_) => onSubmit(),
            );
          },
        ),
        const SizedBox(height: DartisanSpacing.s3),
        ValueListenableBuilder<RecentPackagesState>(
          valueListenable: recentController,
          builder: (context, state, _) {
            final total = state is RecentPackagesLoaded ? state.list.total : null;
            if (total == null) return const SizedBox(height: 18);
            return Row(
              children: [
                Icon(Icons.circle, size: 8, color: primary),
                const SizedBox(width: DartisanSpacing.s2),
                Text(
                  '$total pacote${total == 1 ? '' : 's'} publicado${total == 1 ? '' : 's'}',
                  style: DartisanFonts.mono(fontSize: 12.5, color: colors.textFaint),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _PubspecCard extends StatelessWidget {
  const _PubspecCard();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final primary = Theme.of(context).colorScheme.primary;
    final base = DartisanFonts.mono(fontSize: 13, height: 1.8);

    return Container(
      padding: const EdgeInsets.all(DartisanSpacing.s5),
      decoration: BoxDecoration(
        color: colors.codeBackground,
        borderRadius: BorderRadius.circular(DartisanRadii.l),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('pubspec.yaml', style: DartisanFonts.mono(fontSize: 12, color: colors.textFaint)),
          const SizedBox(height: DartisanSpacing.s3),
          SelectableText.rich(
            TextSpan(
              style: base,
              children: [
                TextSpan(text: 'dependencies:\n', style: TextStyle(color: colors.textFaint)),
                const TextSpan(text: '  meu_pacote:\n'),
                const TextSpan(text: '    hosted: '),
                TextSpan(text: apiBaseUrl, style: TextStyle(color: primary)),
                const TextSpan(text: '\n    version: '),
                TextSpan(text: '^1.0.0', style: TextStyle(color: colors.brass)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
