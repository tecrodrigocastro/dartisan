import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../shared/widgets/app_top_bar.dart';
import '../data/package_models.dart';
import 'package_detail_controller.dart';
import 'package_detail_state.dart';

class PackageDetailPage extends StatefulWidget {
  final String name;

  const PackageDetailPage({super.key, required this.name});

  @override
  State<PackageDetailPage> createState() => _PackageDetailPageState();
}

class _PackageDetailPageState extends State<PackageDetailPage> {
  late final PackageDetailController _controller;

  @override
  void initState() {
    super.initState();
    _controller = context.read<PackageDetailController>();
    _controller.load(widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(),
      body: ValueListenableBuilder<PackageDetailState>(
        valueListenable: _controller,
        builder: (context, state, _) {
          return switch (state) {
            PackageDetailLoading() => const Center(child: CircularProgressIndicator()),
            PackageDetailNotFound(:final name) => _NotFoundView(name: name),
            PackageDetailFailure(:final message) => _ErrorView(
              message: message,
              onRetry: () => _controller.load(widget.name),
            ),
            PackageDetailLoaded(:final metadata) => _LoadedView(metadata: metadata),
          };
        },
      ),
    );
  }
}

class _NotFoundView extends StatelessWidget {
  final String name;
  const _NotFoundView({required this.name});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off, size: 64),
          const SizedBox(height: 16),
          Text('Pacote "$name" não encontrado'),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => context.navigate('/'),
            child: const Text('Voltar pra busca'),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
          const SizedBox(height: 16),
          Text(message),
          const SizedBox(height: 16),
          FilledButton(onPressed: onRetry, child: const Text('Tentar de novo')),
        ],
      ),
    );
  }
}

class _LoadedView extends StatelessWidget {
  final PackageMetadata metadata;
  const _LoadedView({required this.metadata});

  static const _jsonEncoder = JsonEncoder.withIndent('  ');

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(metadata.name, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 4),
        Chip(label: Text('última versão: ${metadata.latest.version}')),
        const SizedBox(height: 24),
        Text('Versões', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: metadata.versions
                .map((v) => _VersionTile(version: v, isLatest: v.version == metadata.latest.version))
                .toList(),
          ),
        ),
        const SizedBox(height: 24),
        Text('pubspec.yaml (última versão)', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SelectableText(
              _jsonEncoder.convert(metadata.latest.pubspec),
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ),
        ),
      ],
    );
  }
}

class _VersionTile extends StatelessWidget {
  final PackageVersion version;
  final bool isLatest;
  const _VersionTile({required this.version, required this.isLatest});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: isLatest ? const Icon(Icons.star, color: Colors.amber) : const Icon(Icons.archive_outlined),
      title: Text(version.version),
      subtitle: Text('sha256: ${version.archiveSha256.substring(0, 12)}…'),
      trailing: IconButton(
        tooltip: 'Baixar tarball',
        icon: const Icon(Icons.download),
        onPressed: () => launchUrl(
          Uri.parse(version.archiveUrl),
          webOnlyWindowName: '_blank',
        ),
      ),
    );
  }
}
