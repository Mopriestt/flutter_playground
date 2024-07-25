import 'package:flutter/material.dart';
import 'package:flutter_playground/edge_track.dart';
import 'package:flutter_playground/image_pinch_zoom.dart';
import 'package:go_router/go_router.dart';

import 'blank.dart';

void main() {
  runApp(MaterialApp.router(
    title: 'Flutter Playground',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    routerConfig: _router,
  ));
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const _HomePage();
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
          path: 'blank',
          builder: (BuildContext context, GoRouterState state) {
            return const Blank();
          },
        ),
      ],
    ),
  ],
);

class _HomePage extends StatefulWidget {
  const _HomePage();

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  ListTile _drawerItem(String name) => ListTile(
        title: Text(name),
        onTap: () => context.go('/${name.replaceAll(' ', '').toLowerCase()}'),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Playground'),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: Drawer(
        child: ListView(children: [
          const DrawerHeader(child: Text('Demo List')),
          _drawerItem('Edge Track'),
          _drawerItem('Blank'),
          _drawerItem('Image Pinch Zoom'),
        ]),
      ),
      body: Center(child: Image.asset('assets/frieren-600x945.jpg')),
    );
  }
}
