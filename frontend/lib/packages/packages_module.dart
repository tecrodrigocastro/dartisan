import 'package:flutter_modular/flutter_modular.dart';

import '../core/session/guards.dart';
import 'detail/package_detail_controller.dart';
import 'detail/package_detail_page.dart';
import 'import/github_import_controller.dart';
import 'import/github_import_page.dart';
import 'search/package_search_controller.dart';
import 'search/package_search_page.dart';
import 'search/recent_packages_controller.dart';

final packagesModule = createModule(
  path: '/',
  register: (c) {
    c
      ..route(
        '/',
        provide: (s) => s
          ..addChangeNotifier<PackageSearchController>(PackageSearchController.new)
          ..addChangeNotifier<RecentPackagesController>(RecentPackagesController.new),
        child: (ctx, state) => const PackageSearchPage(),
      )
      ..route(
        '/packages/:name',
        provide: (s) => s.addChangeNotifier<PackageDetailController>(PackageDetailController.new),
        child: (ctx, state) => PackageDetailPage(name: state['name']!),
      )
      ..route(
        '/publish/github',
        guards: [authGuard, requireAnyRole(['publisher', 'admin'])],
        provide: (s) => s.addChangeNotifier<GithubImportController>(GithubImportController.new),
        child: (ctx, state) => const GithubImportPage(),
      );
  },
);
