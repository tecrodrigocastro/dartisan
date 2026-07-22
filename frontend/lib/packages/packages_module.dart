import 'package:flutter_modular/flutter_modular.dart';

import '../core/session/guards.dart';
import 'detail/package_detail_controller.dart';
import 'detail/package_detail_page.dart';
import 'mine/my_packages_controller.dart';
import 'mine/my_packages_page.dart';
import 'search/package_search_controller.dart';
import 'search/package_search_page.dart';

final packagesModule = createModule(
  path: '/',
  register: (c) {
    c
      ..route(
        '/',
        provide: (s) => s.addChangeNotifier<PackageSearchController>(PackageSearchController.new),
        child: (ctx, state) => const PackageSearchPage(),
      )
      ..route(
        '/packages/:name',
        provide: (s) => s.addChangeNotifier<PackageDetailController>(PackageDetailController.new),
        child: (ctx, state) => PackageDetailPage(name: state['name']!),
      )
      ..route(
        '/my-packages',
        guards: [authGuard],
        provide: (s) => s.addChangeNotifier<MyPackagesController>(MyPackagesController.new),
        child: (ctx, state) => const MyPackagesPage(),
      );
  },
);
