import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../core/session/app_session.dart';
import '../core/session/session_state.dart';
import '../core/theme/app_theme.dart';
import '../shared/widgets/app_top_bar.dart';
import 'data/me_models.dart';
import 'profile_controller.dart';
import 'profile_state.dart';
import 'tabs/packages_tab.dart';
import 'tabs/tokens_tab.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  late final ProfileController _controller;
  late final TabController _tabController;
  late final bool _canPublish;

  @override
  void initState() {
    super.initState();
    _controller = context.read<ProfileController>();
    _controller.load();

    final session = inject<AppSession>().value;
    _canPublish = session is SessionAuthenticated &&
        (session.hasRole('publisher') || session.hasRole('admin'));
    _tabController = TabController(length: _canPublish ? 2 : 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(),
      body: Column(
        children: [
          ValueListenableBuilder<ProfileState>(
            valueListenable: _controller,
            builder: (context, state, _) => switch (state) {
              ProfileLoading() => const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),
              ProfileFailure(:final message) => Padding(
                padding: const EdgeInsets.all(32),
                child: Center(child: Text(message)),
              ),
              ProfileLoaded(:final me) => _ProfileHeader(me: me),
            },
          ),
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              const Tab(text: 'Pacotes'),
              if (_canPublish) const Tab(text: 'Tokens'),
            ],
          ),
          const Divider(height: 1),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                const PackagesTab(),
                if (_canPublish) const TokensTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final Me me;
  const _ProfileHeader({required this.me});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            child: Text(
              me.username.isNotEmpty ? me.username[0].toUpperCase() : '?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(me.username, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(me.role, style: const TextStyle(fontSize: 11)),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              Text(
                'membro desde ${me.createdAt.day.toString().padLeft(2, '0')}/${me.createdAt.month.toString().padLeft(2, '0')}/${me.createdAt.year}',
                style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
