import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/http/api_base_url.dart';
import '../../core/session/app_session.dart';
import '../../core/session/session_state.dart';
import '../../core/theme/tokens.dart';
import '../../shared/widgets/app_top_bar.dart';
import '../../shared/widgets/status_pill.dart';
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

  void _onToggleLike() {
    final session = inject<AppSession>();
    if (session.value is! SessionAuthenticated) {
      context.navigate('/login');
      return;
    }
    _controller.toggleLike();
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
            PackageDetailLoaded() => _LoadedView(state: state, onToggleLike: _onToggleLike),
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
          Icon(Icons.search_off, size: 64, color: context.colors.textFaint),
          const SizedBox(height: DartisanSpacing.s4),
          Text('Pacote "$name" não encontrado'),
          const SizedBox(height: DartisanSpacing.s4),
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
          Icon(Icons.error_outline, size: 64, color: context.colors.danger),
          const SizedBox(height: DartisanSpacing.s4),
          Text(message),
          const SizedBox(height: DartisanSpacing.s4),
          FilledButton(onPressed: onRetry, child: const Text('Tentar de novo')),
        ],
      ),
    );
  }
}

class _LoadedView extends StatelessWidget {
  final PackageDetailLoaded state;
  final VoidCallback onToggleLike;
  const _LoadedView({required this.state, required this.onToggleLike});

  static const _jsonEncoder = JsonEncoder.withIndent('  ');

  /// Mostra só a parte local do e-mail ("ana" em vez de "ana@empresa.com") —
  /// esse endpoint é público e sem autenticação, então o e-mail completo do
  /// publicador não deveria vazar aqui. Correção de exposição encontrada na
  /// auditoria; o ideal a médio prazo é um campo de display name no backend.
  String? _displayHandle(String? uploadedBy) {
    if (uploadedBy == null) return null;
    final at = uploadedBy.indexOf('@');
    return at > 0 ? uploadedBy.substring(0, at) : uploadedBy;
  }

  @override
  Widget build(BuildContext context) {
    final metadata = state.metadata;
    final latest = metadata.latest;
    final pubspec = latest.pubspec;
    final description = pubspec['description'] as String?;
    final homepage = pubspec['homepage'] as String?;
    final repository = pubspec['repository'] as String?;
    final sdkConstraint = (pubspec['environment'] as Map?)?['sdk'] as String?;
    final isWide = MediaQuery.sizeOf(context).width > 900;
    final handle = _displayHandle(latest.uploadedBy);
    final colors = context.colors;

    final mainColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            style: DartisanFonts.mono(fontSize: 13, color: colors.textFaint),
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: InkWell(
                  onTap: () => context.navigate('/'),
                  child: Text('pacotes', style: DartisanFonts.mono(fontSize: 13, color: colors.textFaint)),
                ),
              ),
              const TextSpan(text: ' / '),
              TextSpan(text: metadata.name, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
            ],
          ),
        ),
        const SizedBox(height: DartisanSpacing.s4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.accentSoft,
                borderRadius: BorderRadius.circular(DartisanRadii.m),
              ),
              child: Text(
                metadata.name.isEmpty ? '?' : metadata.name[0].toUpperCase(),
                style: DartisanFonts.mono(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: DartisanSpacing.s4),
            Expanded(
              child: Text(
                metadata.name,
                style: DartisanFonts.mono(fontSize: 30, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _LikeButton(
              liked: state.likedByMe,
              count: metadata.likeCount,
              onTap: onToggleLike,
            ),
          ],
        ),
        const SizedBox(height: DartisanSpacing.s2),
        Wrap(
          spacing: DartisanSpacing.s2,
          runSpacing: DartisanSpacing.s2,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            StatusPill(label: 'v${latest.version} · mais recente', variant: StatusPillVariant.latest),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 9,
                  backgroundColor: colors.brassSoft,
                  child: Text(
                    (handle ?? '?').substring(0, 1).toUpperCase(),
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: colors.brass),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'publicado por ${handle ?? 'desconhecido'}',
                  style: TextStyle(color: colors.textFaint, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
        if (description != null) ...[
          const SizedBox(height: DartisanSpacing.s4),
          Text(description),
        ],
        const SizedBox(height: DartisanSpacing.s6),
        _InstallCard(name: metadata.name, version: latest.version),
        const SizedBox(height: DartisanSpacing.s6),
        Text('Versões', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: DartisanSpacing.s2),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: metadata.versions
                .map((v) => _VersionTile(version: v, isLatest: v.version == latest.version))
                .toList(),
          ),
        ),
        const SizedBox(height: DartisanSpacing.s6),
        Text('Metadados (pubspec.yaml)', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: DartisanSpacing.s2),
        Card(
          color: colors.codeBackground,
          child: Padding(
            padding: const EdgeInsets.all(DartisanSpacing.s4),
            child: SelectableText(
              _jsonEncoder.convert(pubspec),
              style: DartisanFonts.mono(fontSize: 12.5, color: colors.textFaint, height: 1.6),
            ),
          ),
        ),
      ],
    );

    final sidebar = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DownloadsCard(total: metadata.downloadsTotal, daily: metadata.downloadsDaily),
        const SizedBox(height: DartisanSpacing.s4),
        _DetailsCard(homepage: homepage, repository: repository, sdkConstraint: sdkConstraint),
      ],
    );

    return ListView(
      padding: const EdgeInsets.all(DartisanSpacing.s5),
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Center(
            child: isWide
                ? IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: mainColumn),
                        const SizedBox(width: DartisanSpacing.s5),
                        SizedBox(width: 280, child: sidebar),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [mainColumn, const SizedBox(height: DartisanSpacing.s5), sidebar],
                  ),
          ),
        ),
      ],
    );
  }
}

class _LikeButton extends StatelessWidget {
  final bool liked;
  final int count;
  final VoidCallback onTap;
  const _LikeButton({required this.liked, required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = liked ? colors.danger : colors.textFaint;

    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: DartisanSpacing.s2, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(liked ? Icons.favorite : Icons.favorite_border, size: 18, color: color),
            const SizedBox(width: 6),
            Text('$count', style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class _DownloadsCard extends StatelessWidget {
  final int total;
  final List<DownloadDay> daily;
  const _DownloadsCard({required this.total, required this.daily});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DartisanSpacing.s4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Downloads', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: DartisanSpacing.s2),
            Text(
              '$total',
              style: DartisanFonts.mono(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            Text('últimos 30 dias', style: TextStyle(color: colors.textFaint, fontSize: 12)),
            const SizedBox(height: DartisanSpacing.s3),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: CustomPaint(
                painter: _SparklinePainter(
                  values: daily.map((d) => d.count).toList(),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<int> values;
  final Color color;
  const _SparklinePainter({required this.values, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    if (maxValue == 0) {
      final y = size.height - 1;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        Paint()
          ..color = color.withValues(alpha: 0.3)
          ..strokeWidth = 1.5,
      );
      return;
    }

    final stepX = size.width / (values.length - 1).clamp(1, double.infinity);
    final points = [
      for (var i = 0; i < values.length; i++)
        Offset(i * stepX, size.height - (values[i] / maxValue) * size.height),
    ];

    final line = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      line.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(line, Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round);

    final fill = Path.from(line)
      ..lineTo(points.last.dx, size.height)
      ..lineTo(points.first.dx, size.height)
      ..close();
    canvas.drawPath(fill, Paint()..color = color.withValues(alpha: 0.12));
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.color != color;
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
        padding: const EdgeInsets.all(DartisanSpacing.s4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Detalhes', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: DartisanSpacing.s3),
            if (sdkConstraint != null) ...[
              Text('SDK', style: TextStyle(color: context.colors.textFaint, fontSize: 12)),
              Text(sdkConstraint!, style: DartisanFonts.mono(fontSize: 13)),
              const SizedBox(height: DartisanSpacing.s3),
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
      padding: const EdgeInsets.only(bottom: DartisanSpacing.s2),
      child: InkWell(
        onTap: () => launchUrl(Uri.parse(url), webOnlyWindowName: '_blank'),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: DartisanSpacing.s2),
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
    final colors = context.colors;
    return ListTile(
      title: Row(
        children: [
          Text(version.version, style: DartisanFonts.mono(fontSize: 14, fontWeight: FontWeight.w700)),
          if (isLatest) ...[
            const SizedBox(width: DartisanSpacing.s2),
            const StatusPill(label: 'mais recente', variant: StatusPillVariant.latest),
          ],
        ],
      ),
      subtitle: Text(
        'sha256: ${_truncatedSha256(version.archiveSha256)}',
        style: DartisanFonts.mono(fontSize: 12, color: colors.textFaint),
      ),
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

class _InstallCard extends StatelessWidget {
  final String name;
  final String version;
  const _InstallCard({required this.name, required this.version});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final primary = Theme.of(context).colorScheme.primary;
    final command = 'dart pub add $name --hosted-url=$apiBaseUrl';
    final yaml = 'dependencies:\n  $name:\n    hosted: $apiBaseUrl\n    version: ^$version';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(DartisanSpacing.s4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Instalar', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: DartisanSpacing.s3),
            _CodeLine(
              text: command,
              prefix: TextSpan(text: '\$ ', style: TextStyle(color: primary)),
              copyTooltip: 'Copiar comando',
            ),
            const SizedBox(height: DartisanSpacing.s3),
            Text('ou no pubspec.yaml', style: TextStyle(color: colors.textFaint, fontSize: 13)),
            const SizedBox(height: DartisanSpacing.s2),
            _CodeLine(text: yaml, copyTooltip: 'Copiar yaml'),
          ],
        ),
      ),
    );
  }
}

class _CodeLine extends StatelessWidget {
  final String text;
  final TextSpan? prefix;
  final String copyTooltip;
  const _CodeLine({required this.text, required this.copyTooltip, this.prefix});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.only(left: DartisanSpacing.s4, top: 4, bottom: 4, right: 4),
      decoration: BoxDecoration(
        color: colors.codeBackground,
        borderRadius: BorderRadius.circular(DartisanRadii.m - 2),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: DartisanSpacing.s2),
              child: SelectableText.rich(
                TextSpan(
                  style: DartisanFonts.mono(fontSize: 13, height: 1.7),
                  children: [if (prefix != null) prefix!, TextSpan(text: text)],
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: copyTooltip,
            icon: const Icon(Icons.copy_outlined, size: 18),
            onPressed: () => Clipboard.setData(ClipboardData(text: text)),
          ),
        ],
      ),
    );
  }
}
