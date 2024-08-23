import 'package:flutter/material.dart';
import 'package:flutter_playground/arc_color_board.dart';
import 'package:flutter_playground/edge_track.dart';
import 'package:flutter_playground/home/splash_screen.dart';
import 'package:flutter_playground/image_drag_select.dart';
import 'package:flutter_playground/image_pinch_zoom.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'blank.dart';
import 'home/home.dart';

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'edgetrack',
          builder: (BuildContext context, GoRouterState state) {
            return const EdgeTrack();
          },
        ),
        GoRoute(
          path: 'imagepinchzoom',
          builder: (BuildContext context, GoRouterState state) {
            return const ImagePinchZoom();
          },
        ),
        GoRoute(
          path: 'imagedragselect',
          builder: (BuildContext context, GoRouterState state) {
            return const ImageDragSelect();
          },
        ),
        GoRoute(
          path: 'arccolorboard',
          builder: (BuildContext context, GoRouterState state) {
            return const ArcColorBoard();
          },
        ),
        GoRoute(
          path: 'blank',
          builder: (BuildContext context, GoRouterState state) {
            return const Blank();
          },
        ),
      ],
    ),
  ],
);

Stream<InheritedProvider> _dependencies() async* {
  yield Provider.value(value: await SharedPreferences.getInstance());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MaterialApp(home: SplashScreen()));
  runApp(MultiProvider(
    providers: await _dependencies().toList(),
    child: MaterialApp.router(
      title: 'Flutter Playground',
      theme: ThemeData(useMaterial3: true),
      routerConfig: _router,
    ),
  ));
}