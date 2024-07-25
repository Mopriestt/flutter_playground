import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ImagePinchZoom extends StatefulWidget {
  const ImagePinchZoom({super.key});

  @override
  State<StatefulWidget> createState() => ImagePinchZoomState();
}

class ImagePinchZoomState extends State<ImagePinchZoom> {
  static const double zoomSpeed = 200.0;

  (double, double)? initialFocus;
  var initialTouchDistance = 0.0;
  var scale1 = 0.0;
  var scale2 = 0.0;
  var offset = const Offset(0, 0);
  final v = <(double, double)>[]; // Active pointers on screen.
  final origin = const Offset(300, 472.5);

  double get scale => max(1, scale1 * scale2);

  static double _dist((double, double) x, (double, double) y) =>
      sqrt((x.$1 - y.$1) * (x.$1 - y.$1) + (x.$2 - y.$2) * (x.$2 - y.$2));

  void _updateMetrics() {
    final diff = _dist(v[0], v[1]) - initialTouchDistance;
    scale2 = 1 + diff / zoomSpeed;
    final curFocus = (initialFocus!.$1 * scale, initialFocus!.$2 * scale);
    offset = Offset(
        (initialFocus!.$1 - curFocus.$1), (initialFocus!.$2 - curFocus.$2));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Blank'),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/')),
        ),
        body: Center(
          child: Listener(
            onPointerDown: (event) {
              v.add((
                event.localPosition.dx - origin.dx,
                event.localPosition.dy - origin.dy
              ));
              if (v.length == 2) {
                initialFocus =
                    ((v[0].$1 + v[1].$1) / 2, (v[0].$2 + v[1].$2) / 2);
                initialTouchDistance = _dist(v[0], v[1]);
              } else {
                initialFocus = null;
              }
            },
            onPointerUp: (_) {
              v.clear();
              scale1 = scale;
              scale2 = 1.0;
              initialFocus = null;
            },
            onPointerMove: (event) {
              final movingPointer = ((
                event.localPosition.dx - origin.dx,
                event.localPosition.dy - origin.dy
              ));
              if (v.length == 1) {
                v[0] = movingPointer;
                return;
              }
              if (v.length == 2) {
                if (_dist(movingPointer, v[0]) < _dist(movingPointer, v[1])) {
                  v[0] = movingPointer;
                } else {
                  v[1] = movingPointer;
                }
                setState(_updateMetrics);
              }
            },
            child: Transform.translate(
              offset: offset,
              child: Transform.scale(
                scale: scale,
                child: Image.asset('assets/frieren-600x945.jpg'),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() {
            scale1 = 1.0;
            scale2 = 1.0;
            offset = const Offset(0, 0);
          }),
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}
