import 'package:flutter/material.dart';

import '../../core/formatting/date_format.dart';
import '../../core/theme/tokens.dart';
import '../../packages/data/package_models.dart';

/// Card de pacote reutilizado pela busca (pacotes recentes) e por "Meus
/// pacotes" — antes cada tela desenhava o próprio card do zero.
class PackageCard extends StatelessWidget {
  final PackageSummary package;
  final VoidCallback onTap;

  const PackageCard({super.key, required this.package, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(DartisanRadii.m),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(DartisanSpacing.s4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: DartisanSpacing.s2),
                  Expanded(
                    child: Text(
                      package.name,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: DartisanSpacing.s2),
              Text(
                'v${package.latestVersion}  ·  ${formatShortDate(package.createdAt)}',
                style: DartisanFonts.mono(fontSize: 12, color: colors.textFaint),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
