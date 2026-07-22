import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../shared/widgets/app_top_bar.dart';
import 'package_search_controller.dart';
import 'package_search_state.dart';

class PackageSearchPage extends StatefulWidget {
  const PackageSearchPage({super.key});

  @override
  State<PackageSearchPage> createState() => _PackageSearchPageState();
}

class _PackageSearchPageState extends State<PackageSearchPage> {
  final _inputController = TextEditingController();
  late final PackageSearchController _controller;

  @override
  void initState() {
    super.initState();
    _controller = context.read<PackageSearchController>();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.validate(_inputController.text);
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
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.inventory_2_outlined, size: 64),
                const SizedBox(height: 16),
                Text('Buscar pacote', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 24),
                ValueListenableBuilder<PackageSearchState>(
                  valueListenable: _controller,
                  builder: (context, state, _) {
                    return TextField(
                      controller: _inputController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'nome_do_pacote',
                        border: const OutlineInputBorder(),
                        errorText: state is PackageSearchInvalid ? state.message : null,
                      ),
                      onSubmitted: (_) => _submit(),
                    );
                  },
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.search),
                  label: const Text('Buscar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
