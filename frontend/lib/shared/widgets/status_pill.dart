import 'package:flutter/material.dart';

import '../../core/theme/tokens.dart';

enum StatusPillVariant { role, latest, revoked, selfHosted }

/// Badge pequeno e uniforme pra estado (papel do usuário, versão mais
/// recente, token revogado, instância self-hosted) — substitui os `Chip`
/// genéricos e o `_SelfHostedBadge` ad-hoc que cada tela reimplementava.
class StatusPill extends StatelessWidget {
  final String label;
  final StatusPillVariant variant;
  final IconData? icon;

  const StatusPill({super.key, required this.label, required this.variant, this.icon});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final primary = Theme.of(context).colorScheme.primary;

    final (Color bg, Color fg, Color? border, bool uppercase) = switch (variant) {
      StatusPillVariant.role => (colors.brassSoft, colors.brass, colors.brass.withValues(alpha: 0.4), true),
      StatusPillVariant.latest => (colors.accentSoft, primary, null, false),
      StatusPillVariant.revoked => (colors.danger.withValues(alpha: 0.15), colors.danger, null, false),
      StatusPillVariant.selfHosted => (colors.surface2, colors.textFaint, colors.borderStrong, true),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: border != null ? Border.all(color: border) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: fg),
            const SizedBox(width: 4),
          ],
          Text(
            uppercase ? label.toUpperCase() : label,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.3, color: fg),
          ),
        ],
      ),
    );
  }
}
