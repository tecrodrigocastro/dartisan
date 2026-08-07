import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/theme/app_theme.dart';
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
          Icon(Icons.search_off, size: 64, color: AppTheme.textMuted),
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
    final latest = metadata.latest;
    final pubspec = latest.pubspec;
    final description = pubspec['description'] as String?;
    final homepage = pubspec['homepage'] as String?;
    final repository = pubspec['repository'] as String?;
    final sdkConstraint = (pubspec['environment'] as Map?)?['sdk'] as String?;
    final isWide = MediaQuery.sizeOf(context).width > 900;

    final mainColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(metadata.name, style: Theme.of(context).textTheme.headlineMedium),
            ),
            IconButton(
              tooltip: 'Copiar versão',
              icon: const Icon(Icons.copy_outlined, size: 20),
              onPressed: () => Clipboard.setData(ClipboardData(text: latest.version)),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Chip(label: Text('v${latest.version}')),
            Text(
              'publicado por ${latest.uploadedBy ?? 'desconhecido'}',
              style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
            ),
          ],
        ),
        if (description != null) ...[
          const SizedBox(height: 16),
          Text(description),
        ],
        const SizedBox(height: 24),
        Text('Versões', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: metadata.versions
                .map((v) => _VersionTile(version: v, isLatest: v.version == latest.version))
                .toList(),
          ),
        ),
        const SizedBox(height: 24),
        Text('Metadados (pubspec.yaml)', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SelectableText(
              _jsonEncoder.convert(pubspec),
              style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
            ),
          ),
        ),
      ],
    );

    final detailsCard = _DetailsCard(homepage: homepage, repository: repository, sdkConstraint: sdkConstraint);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Center(
            child: isWide
                ? IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: mainColumn),
                        const SizedBox(width: 24),
                        SizedBox(width: 280, child: detailsCard),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [mainColumn, const SizedBox(height: 24), detailsCard],
                  ),
          ),
        ),
      ],
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final String? homepage;
  final String? repository;
  final String? sdkConstraint;

  const _DetailsCard({required this.homepage, required this.repository, required this.sdkConstraint});

  @override
  Widget build(BuildContext context) {
    if (homepage == null && repository == null && sdkConstraint == null) {
      return const SizedBox.shrink();
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detalhes', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            if (sdkConstraint != null) ...[
              Text('SDK', style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
              Text(sdkConstraint!),
              const SizedBox(height: 12),
            ],
            if (homepage != null) _LinkRow(icon: Icons.home_outlined, label: 'Homepage', url: homepage!),
            if (repository != null)
              _LinkRow(icon: Icons.code, label: 'Repositório', url: repository!),
          ],
        ),
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;
  const _LinkRow({required this.icon, required this.label, required this.url});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => launchUrl(Uri.parse(url), webOnlyWindowName: '_blank'),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          ],
        ),
      ),
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
      leading: isLatest ? const Icon(Icons.star, color: Colors.amber) : Icon(Icons.archive_outlined, color: AppTheme.textMuted),
      title: Text(version.version),
      subtitle: Text('sha256: ${_truncatedSha256(version.archiveSha256)}'),
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

String _truncatedSha256(String sha256) {
  const previewLength = 12;
  return sha256.length <= previewLength
      ? sha256
      : '${sha256.substring(0, previewLength)}…';
}
