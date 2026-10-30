import 'package:flutter/material.dart';

import '../../core/formatting/date_format.dart';
import '../../core/theme/tokens.dart';
import '../../packages/data/package_models.dart';

/// Card de pacote reutilizado pela busca (pacotes recentes) e por "Meus
/// pacotes": inicial em quadrado suave, nome mono, pill de versão e data.
class PackageCard extends StatelessWidget {
  final PackageSummary package;
  final VoidCallback onTap;

  const PackageCard({super.key, required this.package, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final primary = Theme.of(context).colorScheme.primary;
    final initial = package.name.isEmpty ? '?' : package.name[0].toUpperCase();

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(DartisanSpacing.s4),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.accentSoft,
                  borderRadius: BorderRadius.circular(DartisanRadii.m - 2),
                ),
                child: Text(
                  initial,
                  style: DartisanFonts.mono(fontSize: 16, fontWeight: FontWeight.w600, color: primary),
                ),
              ),
              const SizedBox(width: DartisanSpacing.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      package.name,
                      style: DartisanFonts.mono(fontSize: 14, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      formatShortDate(package.createdAt),
                      style: TextStyle(fontSize: 12, color: colors.textFaint),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: DartisanSpacing.s2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: colors.accentSoft,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'v${package.latestVersion}',
                  style: DartisanFonts.mono(fontSize: 12, fontWeight: FontWeight.w600, color: primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
