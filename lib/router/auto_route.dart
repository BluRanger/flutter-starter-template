import 'package:auto_route/auto_route.dart';

import 'auto_route.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: LoginRoute.page, initial: true),
        AutoRoute(
          page: HomeRoute.page,
        ),

        /// routes go here
      ];
}
