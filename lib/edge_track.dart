import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EdgeTrack extends StatefulWidget {
  const EdgeTrack({super.key});

  @override
  State<StatefulWidget> createState() => _EdgeTrackState();
}

class _EdgeTrackState extends State<EdgeTrack> {
  static const rads = <double>[70.0, 140.0];
  late final pts = <Offset>[..._generatePoints];

  var clickPos = const Offset(1, 1);

  Iterable<Offset> get _generatePoints sync* {
    var step = pi * 2 / 10;
    var curAng = pi / 10;
    for (int i = 0; i < 10; i++, curAng += step) {
      yield Offset(cos(curAng) * rads[i & 1], sin(curAng) * rads[i & 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edge Track'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Center(
        child: GestureDetector(
          onPanUpdate: (DragUpdateDetails e) {
            setState(() => clickPos = e.localPosition - const Offset(150, 150));
          },
          child: CustomPaint(
              size: const Size(300, 300), painter: _MyPainter(pts, clickPos)),
        ),
      ),
    );
  }
}

class _MyPainter extends CustomPainter {
  final Offset _clickPos;
  final List<Offset> _pts;

  _MyPainter(this._pts, this._clickPos);

  late Offset _origin;

  void _drawSeg(Canvas canvas, Offset a, Offset b) {
    canvas.drawLine(a + _origin, b + _origin, Paint()..color = Colors.blue);
  }

  Offset? _tryIntersect(Offset a, Offset x, Offset y) {
    if ((a.dx * x.dy - a.dy * x.dx) * (a.dx * y.dy - a.dy * y.dx) > 0) {
      return null;
    }

    double ua = ((y.dx - x.dx) * -x.dy + (y.dy - x.dy) * x.dx) /
        ((y.dy - x.dy) * a.dx - (y.dx - x.dx) * a.dy);
    double X = a.dx * ua;
    double Y = a.dy * ua;

    if (X * a.dx < 0 || Y * a.dy < 0) return null;
    return Offset(X, Y) + _origin;
  }

  Offset get buttonPos {
    var d = _clickPos.direction;
    var ray = Offset(1000 * cos(d), 1000 * sin(d));
    for (int i = 0; i < 10; i++) {
      var intersection = _tryIntersect(ray, _pts[i], _pts[(i + 1) % 10]);
      if (intersection != null) return intersection;
    }
    throw Exception();
  }

  @override
  void paint(Canvas canvas, Size size) {
    _origin = Offset(size.width / 2, size.height / 2);
    for (int i = 0; i < 10; i++) {
      _drawSeg(canvas, _pts[i], _pts[(i + 1) % 10]);
    }
    canvas.drawCircle(buttonPos, 10, Paint()..color = Colors.red);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
