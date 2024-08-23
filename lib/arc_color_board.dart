import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ArcColorBoard extends StatefulWidget {
  const ArcColorBoard({super.key});

  @override
  State<StatefulWidget> createState() => _ArcColorBoardState();
}

class _ArcColorBoardState extends State<ArcColorBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arc Draw Board'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: const Center(child: _ColorBoard()),
    );
  }
}

class _ColorBoard extends StatefulWidget {
  const _ColorBoard({super.key});

  @override
  State<StatefulWidget> createState() => _ColorBoardState();
}

class _ColorBoardState extends State<_ColorBoard> {
  var clickPos = const Offset(1, 1);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails e) {
          setState(() => clickPos = e.localPosition - const Offset(200, 200));
        },
        child: CustomPaint(
            size: const Size(400, 400), painter: _MyPainter(clickPos)),
      ),
    );
  }
}

class _MyPainter extends CustomPainter {
  final Offset _clickPos;

  _MyPainter(this._clickPos);

  late Offset _origin;

  void drawCircle(Canvas canvas, Offset pos, double r) {
    canvas.drawCircle(pos + _origin, r, Paint()..strokeWidth = 1..style=PaintingStyle.stroke);
  }

  double dist(Offset x, Offset y) {
    return sqrt((x.dx - y.dx) * (x.dx - y.dx) + (x.dy - y.dy) * (x.dy - y.dy));
  }

  Color offsetToColor(Offset x, Offset r, Offset g, Offset b) {
    final R = (dist(x, r) / 400 * 255).toInt().clamp(0, 255);
    final G = (dist(x, g) / 400 * 255).toInt().clamp(0, 255);
    final B = (dist(x, b) / 400 * 255).toInt().clamp(0, 255);
    return Color.fromRGBO(R, G, B, 1);
  }

  @override
  void paint(Canvas canvas, Size size) {
    _origin = Offset(size.width / 2, size.height / 2);

    final d = _clickPos.distance;
    final c1 = Offset.fromDirection(_clickPos.direction + 0.3, d * 0.95);
    final c2 = Offset.fromDirection(_clickPos.direction - 0.3, d * 0.95);
    const lu = Offset(-200, -200);
    const ru = Offset(200, -200);
    const ld = Offset(200, 200);
    canvas.drawCircle(c1 + _origin, 14, Paint()..color = Colors.white..style = PaintingStyle.fill);
    canvas.drawCircle(c1 + _origin, 13, Paint()..color = offsetToColor(c1, lu, ru, ld)..style = PaintingStyle.fill);

    canvas.drawCircle(c2 + _origin, 14, Paint()..color = Colors.white..style=PaintingStyle.fill);
    canvas.drawCircle(c2 + _origin, 13, Paint()..color = offsetToColor(c1, ru, ld, lu)..style=PaintingStyle.fill);


    canvas.drawCircle(_clickPos + _origin, 20, Paint()..color = Colors.white..style=PaintingStyle.fill);
    canvas.drawCircle(_clickPos + _origin, 18, Paint()..color = offsetToColor(c1, ld, lu, ru)..style=PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
