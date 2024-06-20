// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:dio_flutter/UI/download_page.dart' as _i1;
import 'package:dio_flutter/UI/main_page.dart' as _i2;
import 'package:dio_flutter/UI/upload_page.dart' as _i3;

abstract class $AppRouter extends _i4.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    DownloadPageRoute.name: (routeData) {
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.DownloadPage(),
      );
    },
    MainPageRoute.name: (routeData) {
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.MainPage(),
      );
    },
    UploadPageRoute.name: (routeData) {
      return _i4.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.UploadPage(),
      );
    },
  };
}

/// generated route for
/// [_i1.DownloadPage]
class DownloadPageRoute extends _i4.PageRouteInfo<void> {
  const DownloadPageRoute({List<_i4.PageRouteInfo>? children})
      : super(
          DownloadPageRoute.name,
          initialChildren: children,
        );

  static const String name = 'DownloadPageRoute';

  static const _i4.PageInfo<void> page = _i4.PageInfo<void>(name);
}

/// generated route for
/// [_i2.MainPage]
class MainPageRoute extends _i4.PageRouteInfo<void> {
  const MainPageRoute({List<_i4.PageRouteInfo>? children})
      : super(
          MainPageRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainPageRoute';

  static const _i4.PageInfo<void> page = _i4.PageInfo<void>(name);
}

/// generated route for
/// [_i3.UploadPage]
class UploadPageRoute extends _i4.PageRouteInfo<void> {
  const UploadPageRoute({List<_i4.PageRouteInfo>? children})
      : super(
          UploadPageRoute.name,
          initialChildren: children,
        );

  static const String name = 'UploadPageRoute';

  static const _i4.PageInfo<void> page = _i4.PageInfo<void>(name);
}
