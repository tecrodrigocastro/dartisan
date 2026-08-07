import 'package:flutter/material.dart';

/// Fundo pontilhado sutil, atrás do hero de busca e do card de login —
/// puramente decorativo, mesma textura dos prints de referência.
class DottedGridBackground extends StatelessWidget {
  final Widget child;

  const DottedGridBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DottedGridPainter(color: Theme.of(context).colorScheme.onSurface),
      child: child,
    );
  }
}

class _DottedGridPainter extends CustomPainter {
  final Color color;
  static const _spacing = 24.0;
  static const _radius = 1.0;

  _DottedGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withValues(alpha: 0.08);
    for (double y = 0; y < size.height; y += _spacing) {
      for (double x = 0; x < size.width; x += _spacing) {
        canvas.drawCircle(Offset(x, y), _radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DottedGridPainter oldDelegate) =>
      oldDelegate.color != color;
}
