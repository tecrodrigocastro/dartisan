import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../core/theme/tokens.dart';
import '../../packages/liked/liked_packages_controller.dart';
import '../../packages/liked/liked_packages_state.dart';
import '../../shared/widgets/package_card.dart';

class LikedTab extends StatefulWidget {
  const LikedTab({super.key});

  @override
  State<LikedTab> createState() => _LikedTabState();
}

class _LikedTabState extends State<LikedTab> {
  late final LikedPackagesController _controller;

  @override
  void initState() {
    super.initState();
    _controller = context.read<LikedPackagesController>();
    _controller.load();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<LikedPackagesState>(
      valueListenable: _controller,
      builder: (context, state, _) {
        return switch (state) {
          LikedPackagesLoading() => const Center(child: CircularProgressIndicator()),
          LikedPackagesFailure(:final message) => Center(child: Text(message)),
          LikedPackagesLoaded(:final packages) => ListView(
            padding: const EdgeInsets.all(DartisanSpacing.s5),
            children: [
              if (packages.isEmpty)
                Text(
                  'Você ainda não curtiu nenhum pacote.',
                  style: TextStyle(color: context.colors.textFaint),
                )
              else
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
            ],
          ),
        };
      },
    );
  }
}
