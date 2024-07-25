import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ImageDragSelect extends StatelessWidget {
  const ImageDragSelect({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Drag Select'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: DraggableCover(
          backgroundChild: Image.asset('assets/yuno-400x315.jpg')),
    );
  }
}

/// 最小矩形边长
const double gapSize = 48;

class DraggableCover extends StatefulWidget {
  ///背景组件
  final Widget backgroundChild;

  const DraggableCover({required this.backgroundChild, super.key});

  @override
  State<DraggableCover> createState() => _DraggableCoverState();
}

class _DraggableCoverState extends State<DraggableCover> {
  final corners = const [
    [0, 0],
    [0, 1],
    [1, 0],
    [1, 1]
  ];

  /// 矩形大小
  double width = 0;
  double height = 0;

  /// 自摸点
  int? touching;

  /// 矩形坐标
  final List<double> x = [0, 0];
  final List<double> y = [0, 0];

  double dis(int i, int j, Offset z) =>
      (x[i] - z.dx) * (x[i] - z.dx) + (y[j] - z.dy) * (y[j] - z.dy);

  void _dragStart(DragStartDetails details) {
    var dist2 = double.infinity;
    for (int k = 0; k < 4; k++) {
      final corner = corners[k];
      if (dis(corner[0], corner[1], details.localPosition) < dist2) {
        touching = k;
        dist2 = dis(corner[0], corner[1], details.localPosition);
      }
    }

    if (dist2 > 48 * 48) touching = null;

    if (touching != null) setState(() {});
  }

  void _dragUpdate(DragUpdateDetails details) {
    if (touching == null) return;

    if (touching! < 2) {
      x[0] = max(0, min(details.localPosition.dx, x[1] - gapSize));
    } else {
      x[1] = min(width, max(details.localPosition.dx, x[0] + gapSize));
    }

    if (touching! == 0 || touching! == 2) {
      y[0] = max(0, min(details.localPosition.dy, y[1] - gapSize));
    } else {
      y[1] = min(height, max(details.localPosition.dy, y[0] + gapSize));
    }
    setState(() {});
  }

  void _dragEnd(DragEndDetails _) {
    if (touching != null) setState(() => touching = null);
  }

  void onLayout(double width, double height) {
    if (width == this.width && height == this.height) return;
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(
          () {
            this.width = width;
            this.height = height;
            if (x[0] + y[0] + x[1] + y[1] == 0) {
              // 初始矩形
              x[0] = 0.2 * width;
              x[1] = 0.8 * width;
              y[0] = 0.2 * height;
              y[1] = 0.8 * height;
            }
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        foregroundPainter: _CoverPainter(
          Rect.fromLTRB(x[0], y[0], x[1], y[1]),
          width == 0 ? onLayout : null,
          draggingPoint: touching == null
              ? null
              : Offset(
                  x[corners[touching!][0]],
                  y[corners[touching!][1]],
                ),
        ),
        child: GestureDetector(
          onPanStart: _dragStart,
          onPanUpdate: _dragUpdate,
          onPanEnd: _dragEnd,
          child: widget.backgroundChild,
        ));
  }
}

class _CoverPainter extends CustomPainter {
  final Offset? draggingPoint;
  final Rect rect;
  final Function(double, double)? onLayout;

  _CoverPainter(this.rect, this.onLayout, {this.draggingPoint});

  @override
  void paint(Canvas canvas, Size size) {
    onLayout?.call(size.width, size.height);
    if (rect.size.isEmpty) return;

    final paint = Paint()..color = Colors.white38;
    canvas.drawRect(rect, paint);
    if (draggingPoint != null) {
      canvas.drawCircle(draggingPoint!, 12, paint..color = Colors.white60);
    }
  }

  @override
  bool shouldRepaint(covariant _CoverPainter oldPaint) =>
      rect != oldPaint.rect ||
      draggingPoint != oldPaint.draggingPoint ||
      onLayout != oldPaint.onLayout;
}
