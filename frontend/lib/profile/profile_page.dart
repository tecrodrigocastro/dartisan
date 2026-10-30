import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../core/formatting/date_format.dart';
import '../core/session/app_session.dart';
import '../core/session/session_state.dart';
import '../core/theme/tokens.dart';
import '../shared/widgets/app_top_bar.dart';
import '../shared/widgets/status_pill.dart';
import 'data/me_models.dart';
import 'profile_controller.dart';
import 'profile_state.dart';
import 'tabs/liked_tab.dart';
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
    _tabController = TabController(length: _canPublish ? 3 : 2, vsync: this);
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
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: ((MediaQuery.sizeOf(context).width - 1200) / 2).clamp(0.0, double.infinity) +
                    DartisanSpacing.s5,
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: [
                  const Tab(text: 'Pacotes'),
                  const Tab(text: 'Curtidas'),
                  if (_canPublish) const Tab(text: 'Tokens'),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                const PackagesTab(),
                const LikedTab(),
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
    final colors = context.colors;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            DartisanSpacing.s5,
            DartisanSpacing.s6,
            DartisanSpacing.s5,
            DartisanSpacing.s3,
          ),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.brassSoft,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  me.username.isNotEmpty ? me.username[0].toUpperCase() : '?',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: colors.brass),
                ),
              ),
              const SizedBox(width: DartisanSpacing.s4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: DartisanSpacing.s3,
                      runSpacing: DartisanSpacing.s1,
                      children: [
                        Text(me.username, style: Theme.of(context).textTheme.headlineMedium),
                        StatusPill(label: me.role, variant: StatusPillVariant.role),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'membro desde ${formatShortDate(me.createdAt)}',
                      style: TextStyle(color: colors.textFaint, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
