

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dio_flutter/routes/route.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'routes')
class AppRouter extends $AppRouter {

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: MainPageRoute.page, initial: true, children: [
      AutoRoute(page: DownloadPageRoute.page, initial: true),
      AutoRoute(page: UploadPageRoute.page),
    ]),


    /// routes go here
  ];
}